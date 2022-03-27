import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:go_flutter_todo_list/services/env.dart';
import 'package:http/http.dart' as http;

class Api {
  static Uri Function(String, String, [Map<String, dynamic>?]) get uri {
    return Env.sslMode.contains('dev') ? Uri.http : Uri.https;
  }

  static Uri buildUri({required String path, Map<String, String>? params}) {
    final authority = Env.apiAuthority;

    return uri(authority, path, params);
  }

  static const headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  static Future get(String path, {Map<String, String>? params}) async {
    final req = http.get(
      buildUri(path: path, params: params),
      headers: headers,
    );

    final res = await req;

    log(res);

    final decoded = jsonDecode(res.body);

    return decoded;
  }

  static Future post(
    String path, {
    Map<String, String>? params,
    Map<String, String>? body,
  }) async {
    final req = http.post(
      buildUri(path: path, params: params),
      headers: headers,
      body: jsonEncode(body),
    );

    final res = await req;

    log(res);

    final decoded = jsonDecode(res.body);

    return decoded;
  }

  static Future put(
    String path, {
    Map<String, String>? params,
    Map<String, String>? body,
  }) async {
    final req = http.put(
      buildUri(path: path, params: params),
      headers: headers,
      body: jsonEncode(body),
    );

    final res = await req;

    log(res);

    final decoded = jsonDecode(res.body);

    return decoded;
  }

  static Future delete(
    String path, {
    Map<String, String>? params,
    Map<String, String>? body,
  }) async {
    final req = http.delete(
      buildUri(path: path, params: params),
      headers: headers,
      body: jsonEncode(body),
    );

    final res = await req;

    log(res);

    final decoded = jsonDecode(res.body);

    return decoded;
  }

  static void log(http.Response res) {
    if (kDebugMode) {
      final request = res.request;

      final uri = request?.url;

      final path = uri?.path;

      final method = request?.method;

      final contentLength =
          ((res.contentLength ?? 0) / 1000).toStringAsFixed(2);

      print('$method $path ${contentLength}KB');

      // print(response.body);

      print(res.headers);
    }
  }
}
