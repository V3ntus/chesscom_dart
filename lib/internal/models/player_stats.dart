import 'dart:convert';

import 'package:chesscom_dart/internal/enum.dart';

typedef RawApiMap = Map<String, dynamic>;

class PlayerStatsRecordName extends IEnum<String> {
  static const PlayerStatsRecordName chessDaily =
      PlayerStatsRecordName._create("chess_daily");
  static const PlayerStatsRecordName chessBlitz =
      PlayerStatsRecordName._create("chess_blitz");
  static const PlayerStatsRecordName chessRapid =
      PlayerStatsRecordName._create("chess_rapid");
  static const PlayerStatsRecordName chessBullet =
      PlayerStatsRecordName._create("chess_bullet");
  static const PlayerStatsRecordName chess960Daily =
      PlayerStatsRecordName._create("chess960_daily");
  static const PlayerStatsRecordName tactics =
      PlayerStatsRecordName._create("tactics");
  static const PlayerStatsRecordName lessons =
      PlayerStatsRecordName._create("lessons");
  static const PlayerStatsRecordName puzzleRush =
      PlayerStatsRecordName._create("puzzle_rush");

  PlayerStatsRecordName.from(String? value) : super(value ?? "");
  const PlayerStatsRecordName._create(String? value) : super(value ?? "");
}

class PlayerStatsSectionName extends IEnum<String> {
  static const PlayerStatsSectionName last =
      PlayerStatsSectionName._create("last");
  static const PlayerStatsSectionName best =
      PlayerStatsSectionName._create("best");
  static const PlayerStatsSectionName record =
      PlayerStatsSectionName._create("record");
  static const PlayerStatsSectionName tournament =
      PlayerStatsSectionName._create("tournament");
  static const PlayerStatsSectionName highest =
      PlayerStatsSectionName._create("highest");
  static const PlayerStatsSectionName lowest =
      PlayerStatsSectionName._create("lowest");

  PlayerStatsSectionName.from(String? value) : super(value ?? "");
  const PlayerStatsSectionName._create(String? value) : super(value ?? "");
}

class LastGame implements IStatEntry {
  @override
  final RawApiMap raw;
  late final int rating;
  late final DateTime date;
  late final int rd;
  LastGame(this.raw) {
    rating = raw["rating"] as int;
    date = DateTime.fromMillisecondsSinceEpoch((raw["date"] as int) * 1000);
    rd = raw["rd"] as int;
  }
}

class BestGame implements IStatEntry {
  @override
  final RawApiMap raw;
  late final int rating;
  late final DateTime date;
  late final String game;
  BestGame(this.raw) {
    rating = raw["rating"] as int;
    date = DateTime.fromMillisecondsSinceEpoch((raw["date"] as int) * 1000);
    game = raw["game"];
  }
}

class RecordGame implements IStatEntry {
  @override
  final RawApiMap raw;
  late final int win;
  late final int loss;
  late final int draw;
  late final int? timePerMove;
  late final int? timeoutPercent;
  RecordGame(this.raw) {
    win = raw["win"] as int;
    loss = raw["loss"] as int;
    draw = raw["draw"] as int;
    timePerMove = raw["time_per_move"] as int?;
    timeoutPercent = raw["timeout_percent"] as int?;
  }
}

class TournamentGame implements IStatEntry {
  @override
  final RawApiMap raw;
  late final int points;
  late final int withdraw;
  late final int count;
  late final int highestFinish;
  TournamentGame(this.raw) {
    points = raw["points"] as int;
    withdraw = raw["withdraw"] as int;
    count = raw["count"] as int;
    highestFinish = raw["highest_finish"] as int;
  }
}

class TacticsRecord implements IStatEntry {
  @override
  final RawApiMap raw;
  late final int rating;
  late final DateTime date;
  TacticsRecord(this.raw) {
    rating = raw["rating"] as int;
    date = DateTime.fromMillisecondsSinceEpoch((raw["date"] as int) * 1000);
  }
}

class PuzzleRushRecord implements IStatEntry {
  @override
  final RawApiMap raw;
  late final int totalAttempts;
  late final int score;
  PuzzleRushRecord(this.raw) {
    score = raw["score"] as int;
    totalAttempts = raw["total_attempts"] as int;
  }
}

class RawRecord implements IStatEntry {
  @override
  final RawApiMap raw;
  RawRecord(this.raw);
}

abstract class IStatEntry {
  RawApiMap get raw;
}

class PlayerRecordSection {
  /// The record type of this player stats section.
  final PlayerStatsRecordName type;

  /// The entry for this player stat section.
  late final IStatEntry statEntry;

  /// The name of the player record section.
  final PlayerStatsSectionName sectionName;

  PlayerRecordSection(this.type, this.sectionName, RawApiMap recordSection) {
    if (type == PlayerStatsRecordName.chessDaily ||
        type == PlayerStatsRecordName.chessBlitz ||
        type == PlayerStatsRecordName.chessRapid ||
        type == PlayerStatsRecordName.chessBullet ||
        type == PlayerStatsRecordName.chess960Daily) {
      if (sectionName == PlayerStatsSectionName.last) {
        statEntry = LastGame(recordSection);
      } else if (sectionName == PlayerStatsSectionName.best) {
        statEntry = BestGame(recordSection);
      } else if (sectionName == PlayerStatsSectionName.record) {
        statEntry = RecordGame(recordSection);
      } else if (sectionName == PlayerStatsSectionName.tournament) {
        statEntry = TournamentGame(recordSection);
      } else {
        statEntry = RawRecord(recordSection);
      }
    } else if (type == PlayerStatsRecordName.tactics) {
      statEntry = TacticsRecord(recordSection);
    } else if (type == PlayerStatsRecordName.puzzleRush) {
      statEntry = PuzzleRushRecord(recordSection);
    } else {
      statEntry = RawRecord(recordSection);
    }
  }
}

class PlayerRecord {
  /// The name of this record.
  late final PlayerStatsRecordName recordName;

  /// A list of this record's sections.
  List<PlayerRecordSection> sections = [];

  PlayerRecord.from(MapEntry<String, dynamic> raw) {
    recordName = PlayerStatsRecordName.from(raw.key);

    for (var section in (raw.value as Map).entries) {
      sections.add(
        PlayerRecordSection(recordName, PlayerStatsSectionName.from(section.key), section.value)
      );
    }
  }
}

class PlayerStats {
  RawApiMap raw;

  /// A list of this player's records.
  List<PlayerRecord> records = [];

  PlayerStats.from(this.raw) {
    for (var record in raw.entries) {
      if (record.value is Map) {
        records.add(
            PlayerRecord.from(record)
        );
      }
    }
  }

  @override
  String toString() => jsonEncode(raw);
}
