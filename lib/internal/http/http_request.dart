import 'package:http/http.dart' as http;

import 'package:chesscom_dart/internal/constants.dart';
import 'package:chesscom_dart/internal/http/http_endpoints.dart';

class HttpRequest {
  late final Uri uri;
  late final Map<String, String> headers;

  final String method;
  final Map<String, dynamic>? queryParams;

  final HttpEndpoint endpoint;

  http.BaseRequest prepare() => http.Request(
      method,
      uri.replace(
          queryParameters: queryParams
              ?.map((key, value) => MapEntry(key, value.toString()))))
    ..headers.addAll(headers);

  HttpRequest(this.endpoint,
      {this.method = "GET", this.queryParams, Map<String, String>? headers}) {
    uri = Uri.https(Constants.host, Constants.baseUri + endpoint.path);
    this.headers = headers ?? {};
    this.headers.addAll({
      "Accept-Encoding": "gzip",
    });
  }
}
