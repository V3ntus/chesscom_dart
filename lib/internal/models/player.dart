import 'package:chesscom_dart/internal/api.dart';
import 'package:chesscom_dart/internal/enum.dart';
import 'package:chesscom_dart/internal/models/player_stats.dart';

class AccountStatus extends IEnum<String> {
  static const AccountStatus closed = AccountStatus._create("closed");
  static const AccountStatus closedFairPlayViolations = AccountStatus._create("closed:fair_play_violations");
  static const AccountStatus basic = AccountStatus._create("basic");
  static const AccountStatus premium = AccountStatus._create("premium");
  static const AccountStatus mod = AccountStatus._create("mod");
  static const AccountStatus staff = AccountStatus._create("staff");
  static const AccountStatus unknown = AccountStatus._create("");

  AccountStatus.from(String? value) : super(value ?? "");
  const AccountStatus._create(String? value) : super(value ?? "");
}

class League extends IEnum<String> {
  static const League wood = League._create("Wood");
  static const League stone = League._create("Stone");
  static const League bronze = League._create("Bronze");
  static const League silver = League._create("Silver");
  static const League crystal = League._create("Crystal");
  static const League elite = League._create("Elite");
  static const League champion = League._create("Champion");
  static const League legend = League._create("Legend");

  League.from(String? value) : super(value ?? "");
  const League._create(String? value) : super(value ?? "");
}

class Title extends IEnum<String> {
  static const Title grandmaster = Title._create("GM");
  static const Title internationalMaster = Title._create("IM");
  static const Title fideMaster = Title._create("FM");
  static const Title nationalMaster = Title._create("NM");
  static const Title candidateMaster = Title._create("CM");
  static const Title womanGrandmaster = Title._create("WGM");
  static const Title womanInternationalMaster = Title._create("WIM");
  static const Title womanFIDEMaster = Title._create("WFM");
  static const Title womanNationalMaster = Title._create("WNM");
  static const Title womanCandidateMaster = Title._create("WCM");

  Title.from(String? value) : super(value ?? "");
  const Title._create(String? value) : super(value ?? "");
}

abstract class IPlayer {
  /// Reference to Chess API client.
  ChessAPI get client;

  /// The raw JSON data returned from the API.
  Map<String, dynamic> get raw;

  /// The player's profile URL on Chess.com.
  String get url;

  /// The player's username.
  String get username;

  /// The player's ID.
  int get playerId;

  /// The player's abbreviated chess title, if any.
  Title? get title;

  /// The player's account status.
  AccountStatus get status;

  /// The player's personal first and last name, if set.
  String? get name;

  /// The player's avatar URL, if set.
  String? get avatar;

  /// The player's city, if set.
  String? get location;

  /// The player's country code, if set.
  String? get country;

  /// A [DateTime] object representing when the player joined Chess.com.
  DateTime get joined;

  /// A [DateTime] object representing when the player was last online.
  DateTime get lastOnline;

  /// The player's follower count.
  int get followers;

  /// True if the player is a Chess.com streamer.
  bool get isStreamer;

  /// The player's Twitch.TV URL, if [isStreamer] is true.
  String? get twitchUrl;

  /// The player's FIDE rating, if set.
  int? get fideRating;

  /// True if the player has been verified.
  bool get verified;

  /// The player's current league.
  League get league;

  Future<PlayerStats> get stats;
}

class Player implements IPlayer {
  @override
  late final String? avatar;

  @override
  final ChessAPI client;

  @override
  late final String? country;

  @override
  late final int? fideRating;

  @override
  late final int followers;

  @override
  late final bool isStreamer;

  @override
  late final DateTime joined;

  @override
  late final DateTime lastOnline;

  @override
  late final League league;

  @override
  late final String? location;

  @override
  late final String? name;

  @override
  late final int playerId;

  @override
  final Map<String, dynamic> raw;

  @override
  late final AccountStatus status;

  @override
  late final Title? title;

  @override
  late final String? twitchUrl;

  @override
  late final String url;

  @override
  late final String username;

  @override
  late final bool verified;

  @override
  Future<PlayerStats> get stats async {
    return await client.fetchProfileStats(username);
  }
  
  Player(this.raw, this.client) {
    avatar = raw["avatar"];
    final String? country = (raw["country"] as String?);
    if (country != null) this.country = country.substring(country.length - 2);

    fideRating = raw["fideRating"];
    followers = raw["followers"];
    isStreamer = raw["is_streamer"];
    joined = DateTime.fromMillisecondsSinceEpoch(raw["joined"] * 1000, isUtc: true);
    lastOnline = DateTime.fromMillisecondsSinceEpoch(raw["last_online"] * 1000, isUtc: true);
    league = League.from(raw["league"] as String);
    location = raw["location"];
    name = raw["name"];
    playerId = raw["player_id"];
    status = AccountStatus.from(raw["status"] as String);
    title = Title.from(raw["title"]);
    twitchUrl = raw["twitch_url"];
    url = raw["url"];
    username = raw["username"];
    verified = raw["verified"];
  }
}
