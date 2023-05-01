import 'package:chesscom_dart/internal/api.dart';
import 'package:chesscom_dart/internal/http/http_request.dart';
import 'package:chesscom_dart/internal/http/http_response.dart';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class HttpHandler {
  late final http.Client httpClient;

  final ChessAPI client;

  late final Logger logger;

  HttpHandler(this.client) {
    httpClient = http.Client();
    logger = client.logger;
  }

  Future<HttpResponse> execute(HttpRequest request) async {
    logger.fine('Handling request execution $request');
    logger.finer([...request.headers.entries.map((e) => "${e.key}: ${e.value}")]
        .join("\n"));

    final response = await HttpResponse.fromResponse(
        await httpClient.send(request.prepare()));

    if (response.code >= 200 && response.code < 300) {
      logger.finest("Successful response: $response");
      return response;
    } else if (response.code == 429) {
      logger.warning("429 Rate limited. Retrying...");
      return Future.delayed(Duration(seconds: 1), () => execute(request));
    }
    logger.finest("Unknown response: ${response.toString()}");
    return response;
  }

  Future<void> dispose() async => httpClient.close();
}
