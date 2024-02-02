import 'dart:io';
import 'dart:typed_data';

import 'package:chatgpt_image/generated_image.dart';
import 'package:chatgpt_image/sp_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


Dio createDioWithProxy() {
  var dio = Dio();

  // 获取系统环境变量中的代理设置
  final String? httpProxy = Platform.environment['http_proxy'];
  final String? httpsProxy = Platform.environment['https_proxy'];
  final String? ftpProxy = Platform.environment['ftp_proxy'];
  final String? allProxy = Platform.environment['all_proxy'];
  String? proxyUrl;

// 检查是否设置了代理
  if (httpProxy != null) {
    proxyUrl = httpProxy;
  } else if (httpsProxy != null) {
    proxyUrl = httpsProxy;
  } else if (ftpProxy != null) {
    proxyUrl = ftpProxy;
  } else if (allProxy != null) {
    proxyUrl = allProxy;
  }

  // 如果代理设置存在，则将其添加到Dio实例中
  if (proxyUrl != null) {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.findProxy = (uri) {
        debugPrint('proxyUrl: $proxyUrl');
        return "PROXY $proxyUrl";
      };
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  } else {
    debugPrint('proxyUrl is null');
  }

  // Add log interceptor
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
}

//prompt 4000 characters limit
Future<GeneratedImageResponse> fetchImage(String prompt) async {
  var style = await SpUtils.getStyle();
  var quality = await SpUtils.getQuality();
  var size = await SpUtils.getSize();
  var responseFormat = await SpUtils.getResponseFormat();
  var host = await SpUtils.getHost();
  var apiKey = await SpUtils.getApiKey();
  if (apiKey.isEmpty || host.isEmpty) {
    throw Exception('API key or host is empty');
  }
  final dio = createDioWithProxy();
  final response = await dio.post(
    '$host/v1/images/generations',
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey', // Replace with your actual API key
      },
    ),
    data: {
      'model': 'dall-e-3',
      'prompt': prompt,
      'n': 1,
      'style': style,
      'quality': quality,
      'size': size,
      'response_format': responseFormat,
    },
  );

  if (response.statusCode == 200) {
    final data = GeneratedImageResponse.fromJson(response.data);
    return data;
  }

  throw Exception('Failed to fetch image');
}

// save image to download folder
Future<String> saveAndOpenImage(String url) async {
  final dio = createDioWithProxy();
  final response = await dio.get(
    url,
    options: Options(
      responseType: ResponseType.bytes,
    ),
  );

  if (response.statusCode == 200) {
    final Uint8List bytes = response.data;
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final File file = File('$dir/$fileName.png');
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
    return file.path;
  }

  throw Exception('Failed to save image');
}