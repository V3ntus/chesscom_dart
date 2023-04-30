import 'package:chesscom_dart/internal/http/http_endpoints.dart';
import 'package:chesscom_dart/internal/http/http_handler.dart';
import 'package:chesscom_dart/internal/http/http_request.dart';

import 'package:logging/logging.dart';

abstract class ChessFactory {
  /// Create an HTTP client instance that connects to the Chess.com API
  static ChessAPI createClient({Level logLevel = Level.INFO}) => ChessAPI(logLevel: logLevel);
}

class ChessAPI {
  late final HttpHandler httpHandler;
  final Level logLevel;

  Future<Map<String, dynamic>?> fetchProfile(String username) async {
    final res = await httpHandler.execute(HttpRequest(HttpEndpoint()..player(username)));
    return res.json;
  }

  ChessAPI({this.logLevel = Level.INFO}) {
    Logger.root.level = logLevel;
    Logger.root.onRecord.listen((record) {
      print('[${record.level.name}] ${record.time} - ${record.message}');
    });

    httpHandler = HttpHandler(this);
  }
}