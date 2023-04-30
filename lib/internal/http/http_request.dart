import 'package:chesscom_dart/internal/constants.dart';
import 'package:chesscom_dart/internal/http/http_endpoints.dart';

class HttpRequest {
  late final Uri uri;
  late final Map<String, String> headers;

  final String method;
  final Map<String, dynamic>? queryParams;
  
  final HttpEndpoint endpoint;
  
  HttpRequest(this.endpoint, {this.method = "GET", this.queryParams, Map<String, String>? headers}) {
    uri = Uri.https(Constants.host, Constants.baseUri);
  }
}