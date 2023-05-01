import 'package:chesscom_dart/internal/api.dart';

abstract class IPuzzle {
  ChessAPI get client;

  /// The name of the puzzle.
  String get title;

  /// The URL of this puzzle.
  String get url;

  /// The time this puzzle was published.
  DateTime get publishTime;

  /// The FEN string of this puzzle.
  String get fen;

  /// The PGN string of this puzzle.
  String get pgn;

  /// The image URL of this puzzle.
  String get image;
}

class Puzzle implements IPuzzle {
  Map<String, dynamic> raw;

  @override
  final ChessAPI client;

  @override
  late final String fen;

  @override
  late final String image;

  @override
  late final String pgn;

  @override
  late final DateTime publishTime;

  @override
  late final String title;

  @override
  late final String url;

  Puzzle(this.raw, this.client) {
    fen = raw["fen"];
    image = raw["image"];
    pgn = raw["pgn"];
    publishTime = DateTime.fromMillisecondsSinceEpoch(raw["publish_time"] * 1000);
    title = raw["title"];
    url = raw["url"];
  }
}