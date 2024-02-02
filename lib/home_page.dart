import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:chatgpt_image/chat_page.dart';
import 'package:chatgpt_image/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sp_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Settings _settings;

  @override
  void initState() {
    _settings = Provider.of<Settings>(context, listen: false);
    _loadConfig();
    super.initState();
  }
  
  _loadConfig() async {
    _settings.load();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: ListView(
                children: [
                  WindowTitleBarBox(child: MoveWindow()),
                  // show price
                  Text("price: \$${_getPrice()}"),
                  const SizedBox(height: 20),
                  // menu style: natural vivid
                  const Text('style'),
                  DropdownButton<String>(
                    value: _settings.style,
                    onChanged: (String? newValue) {
                      setState(() {
                        _settings.setStyle(newValue!);
                        SpUtils.setStyle(newValue);
                      });
                    },
                    items: Settings.styles
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  // menu quality : standard, hd
                  const Text('quality'),
                  DropdownButton<String>(
                    value: _settings.quality,
                    onChanged: (String? newValue) {
                      setState(() {
                        _settings.setQuality(newValue!);
                        SpUtils.setQuality(newValue);
                      });
                    },
                    items: Settings.qualities
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  const Text('size'),
                  DropdownButton<String>(
                    value: _settings.size,
                    onChanged: (String? newValue) {
                      setState(() {
                        _settings.setSize(newValue!);
                        SpUtils.setSize(newValue);
                      });
                    },
                    items: Settings.sizes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  const Text('response format'),
                  DropdownButton<String>(
                    value: _settings.responseFormat,
                    onChanged: (String? newValue) {
                      setState(() {
                        _settings.setResponseFormat(newValue!);
                        SpUtils.setResponseFormat(newValue);
                      });
                    },
                    items: Settings.responseFormats
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  // Set OpenAi
                  ListTile(
                    title: const Text('Settings'),
                    onTap: () {
                      _showSettingOpenAiDialog();
                    },
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            const Expanded(
              child: ChatPage(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingOpenAiDialog() {
    TextEditingController hostController = TextEditingController(text: _settings.host);
    TextEditingController apiKeyController = TextEditingController(text: _settings.apiKey);


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('OpenAI API Key'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // input host
                TextField(
                  controller: hostController,
                  decoration: const InputDecoration(labelText: 'Host'),
                ),
                // input api key
                TextField(
                  controller: apiKeyController,
                  decoration: const InputDecoration(labelText: 'API Key'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        var host = hostController.text.trim();
                        var apiKey = apiKeyController.text.trim();
                        if (host.isEmpty || apiKey.isEmpty) {
                          // show error message
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Host and API Key are required')));
                          return;
                        }
                        _settings.setHost(host);
                        _settings.setApiKey(apiKey);
                        SpUtils.setHost(host);
                        SpUtils.setApiKey(apiKey);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _getPrice() {
    var price = 0.04;
    if (_settings.quality == 'hd') {
      price = 0.08;
    }
    if (_settings.size != '1024x1024') {
      price *= 2;
    }
    return price;
  }

}