import 'package:chatgpt_image/sp_utils.dart';
import 'package:flutter/foundation.dart';

class Settings extends ChangeNotifier {
  static const List<String> styles = ['natural', 'vivid'];
  static const List<String> qualities = ['standard', 'hd'];
  static const List<String> sizes = ['1024x1024', '1792x1024', '1024x1792'];
  static const List<String> responseFormats = ['url', 'b64_json'];

  String _style = 'natural';
  String _quality = 'standard';
  String _size = '1024x1024';
  String _responseFormat = 'url';
  String _host = 'https://api.openai.com';
  String _apiKey = '';

  String get style => _style;
  String get quality => _quality;
  String get size => _size;
  String get responseFormat => _responseFormat;
  String get host => _host;
  String get apiKey => _apiKey;

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
    notifyListeners();
  }

  void setHost(String host) {
    _host = host;
    notifyListeners();
  }

  void setStyle(String style) {
    _style = style;
    notifyListeners();
  }

  void setQuality(String quality) {
    _quality = quality;
    notifyListeners();
  }

  void setSize(String size) {
    _size = size;
    notifyListeners();
  }

  void setResponseFormat(String responseFormat) {
    _responseFormat = responseFormat;
    notifyListeners();
  }

  Future<void> load() async {
    _apiKey = await SpUtils.getApiKey();
    _host = await SpUtils.getHost();
    _style = await SpUtils.getStyle();
    _quality = await SpUtils.getQuality();
    _size = await SpUtils.getSize();
    _responseFormat = await SpUtils.getResponseFormat();
    notifyListeners();
  }
}