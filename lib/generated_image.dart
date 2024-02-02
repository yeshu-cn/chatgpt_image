class GeneratedImage {
  final String revisedPrompt;
  final String? url;
  final String? b64Json;

  GeneratedImage({required this.revisedPrompt, this.url, this.b64Json});

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    return GeneratedImage(
      revisedPrompt: json['revised_prompt'],
      url: json['url'],
      b64Json: json['b64_json'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revised_prompt': revisedPrompt,
      'url': url,
      'b64_json': b64Json,
    };
  }
}

class GeneratedImageResponse {
  final int created;
  final List<GeneratedImage> data;

  GeneratedImageResponse(this.created, this.data);

  factory GeneratedImageResponse.fromJson(Map<String, dynamic> json) {
    return GeneratedImageResponse(
      json['created'],
      (json['data'] as List).map((e) => GeneratedImage.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created': created,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}