import 'dart:convert';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:chatgpt_image/image_utils.dart';
import 'package:chatgpt_image/message.dart';
import 'package:chatgpt_image/message_repository.dart';
import 'package:chatgpt_image/settings.dart';
import 'package:flutter/material.dart';
import 'package:lib_loading_dialog/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:split_view/split_view.dart';
import 'dio_utils.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _messageController = ScrollController();

  @override
  void initState() {
    _loadHistory();
    super.initState();
  }

  _loadHistory() async {
    final history = await MessageRepository.getInstance().getMessageList();
    setState(() {
      _messages.addAll(history);
      // scroll to bottom
      Future.delayed(const Duration(milliseconds: 200), () {
        _messageController.animateTo(
          _messageController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void sendMessage(BuildContext context) async {
    var setting = Provider.of<Settings>(context, listen: false);
    if (setting.apiKey.isEmpty || setting.host.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('API Key and Host are required'),
            content: const Text('Please set API Key and Host in settings'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final prompt = _controller.text;
    if (prompt.isEmpty) {
      return;
    }
    var dialog = showLoadingDialog(context);

    try {
      final data = await fetchImage(prompt);
      final message = Message(requestTime: DateTime.now().millisecondsSinceEpoch, prompt: prompt, response: data);
      setState(() {
        _messages.add(message);
        MessageRepository.getInstance().addMessage(message);
      });

      // scroll to bottom
      _messageController.animateTo(
        _messageController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      _controller.clear();
    } catch (e) {
      debugPrint('Failed to send message: $e');
    } finally {
      dialog.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: appWindow.titleBarHeight + 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              const Text('DALL·E-3'),
              Expanded(child: MoveWindow()),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SplitView(
            gripSize: 1,
            gripColor: const Color(0xffc5c2c7),
            controller: SplitViewController(weights: [0.85, 0.15], limits: [WeightLimit(min: 0.6, max: 0.8), null]),
            viewMode: SplitViewMode.Vertical,
            children: [
              ListView.builder(
                controller: _messageController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: _buildMessage(_messages[index]),
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("删除消息"),
                              content: const Text("确定删除这条消息吗？"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("取消")),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _messages.removeAt(index);
                                        MessageRepository.getInstance().saveMessageList(_messages);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("确定")),
                              ],
                            );
                          });
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Send a message',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage(context);
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(Message message) {
    if (message.generatedImage.url != null) {
      // show prompt and image
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(message.prompt),
                const Divider(height: 1),
                Center(
                  child: InkWell(
                    onTap: () async {
                      var dialog = showLoadingDialog(context);
                      await saveAndOpenImage(message.generatedImage.url!);
                      dialog.dismiss();
                    },
                    child: Image.network(
                      message.generatedImage.url!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SelectableText(message.generatedImage.revisedPrompt),
              ],
            ),
          ),
        ),
      );
    } else {
      // show prompt and base64 image
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // show request time
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '(${DateTime.fromMillisecondsSinceEpoch(message.requestTime).toLocal().toString()})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(message.prompt),
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Center(
                  child: InkWell(
                    onTap: () async {
                      var dialog = showLoadingDialog(context);
                      await ImageUtils.saveAndOpenImage(base64Decode(message.generatedImage.b64Json!));
                      dialog.dismiss();
                    },
                    child: Image.memory(
                      base64Decode(message.generatedImage.b64Json!),
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(message.generatedImage.revisedPrompt),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
