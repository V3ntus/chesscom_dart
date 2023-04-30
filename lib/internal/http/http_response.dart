import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

abstract class IHttpResponse {
  int get code;

  Map<String, String> get headers;

  Uint8List get body;

  String? get text;

  Map<String, dynamic>? get json;
}

class HttpResponse implements IHttpResponse {
  @override
  final int code;

  @override
  final Map<String, String> headers;

  @override
  late final Map<String, dynamic>? json;

  @override
  late final String? text;

  @override
  final Uint8List body;

  http.BaseRequest get request => response.request!;
  final http.BaseResponse response;

  static Future<HttpResponse> fromResponse(
          http.StreamedResponse response) async =>
      HttpResponse(response: response, body: await response.stream.toBytes());

  HttpResponse({
    required this.response,
    required this.body,
  })  : code = response.statusCode,
        headers = response.headers {
    try {
      text = utf8.decode(body);
      json = jsonDecode(text!);
    } on FormatException {
      // json failed to decode, pass
    }
  }

  @override
  String toString() =>
      '$code (${response.reasonPhrase}) ${request.method} ${request.url}';
}
