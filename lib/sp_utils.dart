import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static const String _keyStyle = 'style';
  static const String _keyQuality = 'quality';
  static const String _keySize = 'size';
  static const String _keyResponseFormat = 'response_format';
  static const String _keyHost = 'host';
  static const String _keyApiKey = 'api_key';

  static Future<void> setApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiKey, apiKey);
  }

  static Future<String> getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyApiKey) ?? '';
  }

  static Future<void> setHost(String host) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyHost, host);
  }

  static Future<String> getHost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyHost) ?? 'https://api.openai.com';
  }

  static Future<void> setResponseFormat(String responseFormat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyResponseFormat, responseFormat);
  }

  static Future<String> getResponseFormat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyResponseFormat) ?? 'url';
  }

  static Future<void> setSize(String size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySize, size);
  }

  static Future<String> getSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySize) ?? "1024x1024";
  }

  static Future<void> setStyle(String style) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStyle, style);
  }

  static Future<String> getStyle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStyle) ?? 'natural';
  }

  static Future<void> setQuality(String quality) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyQuality, quality);
  }

  static Future<String> getQuality() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyQuality) ?? 'standard';
  }

}