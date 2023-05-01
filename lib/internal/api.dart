import 'package:chesscom_dart/internal/http/http_endpoints.dart';
import 'package:chesscom_dart/internal/http/http_handler.dart';
import 'package:chesscom_dart/internal/http/http_request.dart';
import 'package:chesscom_dart/internal/cache.dart';
import 'package:chesscom_dart/internal/models/player/player.dart';
import 'package:chesscom_dart/internal/models/player/player_stats.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:logging/logging.dart';


abstract class ChessFactory {
  /// Create an HTTP client instance that connects to the Chess.com API
  static ChessAPI createClient({Level logLevel = Level.INFO}) =>
      ChessAPI(logLevel: logLevel);
}

class ChessAPI {
  late final HttpHandler httpHandler;
  final Level logLevel;

  Cache<Player> players = Cache();
  Cache<PlayerStats> playerStats = Cache();

  ChessAPI({this.logLevel = Level.INFO}) {
    Logger.root.level = logLevel;
    Logger.root.onRecord.listen((record) {
      print('[${record.level.name}] ${record.time} - ${record.message}');
    });

    httpHandler = HttpHandler(this);
  }

  DateTime _getTtl(Map<String, String> headers) {
    DateFormat expiresFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss");
    return expiresFormat.parse(headers["expires"] ?? "");
  }

  Future<Player> fetchProfile(String username) async {
    final res = await httpHandler
        .execute(HttpRequest(HttpEndpoint()..player(username)));
    final profile = Player(res.json!, this);
    players[CacheKey(_getTtl(res.headers), res.json!["player_id"])] = profile;
    return profile;
  }

  Future<PlayerStats> fetchProfileStats(String username) async {
    final res = await httpHandler.execute(HttpRequest(HttpEndpoint()
      ..player(username)
      ..stats()));
    final profileStats = PlayerStats.from(res.json!);
    playerStats[CacheKey(_getTtl(res.headers), res.hashCode)] = profileStats;
    return profileStats;
  }
}
