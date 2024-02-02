import 'package:chatgpt_image/generated_image.dart';

class Message {
  final int requestTime;
  final String prompt;
  final GeneratedImageResponse response;

  // dall-e-3的时候只有一个image
  GeneratedImage get generatedImage => response.data.first;

  Message({required this.requestTime, required this.prompt, required this.response});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      requestTime: json['requestTime'],
      prompt: json['prompt'],
      response: GeneratedImageResponse.fromJson(json['response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestTime': requestTime,
      'prompt': prompt,
      'response': response.toJson(),
    };
  }
}
