import 'package:chesscom_dart/internal/api.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class HttpHandler {
  late final http.Client httpClient;

  final Logger logger = Logger("http");

  final ChessAPI client;



  HttpHandler(this.client);
}