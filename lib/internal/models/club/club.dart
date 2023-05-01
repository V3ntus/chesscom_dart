import 'package:chesscom_dart/internal/api.dart';

class PartialMember {
  late final String username;
  late final DateTime joined;

  PartialMember(Map<String, dynamic> raw) {
    username = raw["username"];
    joined = DateTime.parse(raw["joined"] * 1000);
  }
}

abstract class IClub {
  ChessAPI get client;

  Map<String, dynamic> get raw;

  /// The name of the club.
  String get name;

  /// The non-changing Chess.com Club ID
  int get clubID;

  /// URL of club's icon, if set.
  String get icon;

  /// Location of this club's country profile.
  String get country;

  /// Average daily rating of club members.
  int get averageDailyRating;

  /// Total number of members in the club.
  int get membersCount;

  /// Timestamp of when the club was created.
  DateTime get created;

  /// Timestamp of when activity was last detected.
  DateTime get lastActivity;

  /// True if club is public.
  bool get isPublic;

  /// URL of where to submit join requests.
  String get joinRequestUrl;

  /// List of usernames acting as admin of the club.
  List<String> get admin;

  /// The club's description.
  String get description;

  /// Members active in the week.
  Future<List<PartialMember?>> get weeklyMembers;

  /// Members active in the month.
  Future<List<PartialMember?>> get monthlyMembers;

  /// All members of this club.
  Future<List<PartialMember?>> get members;
}

class Club implements IClub {
  List<PartialMember?> _members = [];
  List<PartialMember?> _weeklyMembers = [];
  List<PartialMember?> _monthlyMembers = [];

  @override
  final ChessAPI client;

  @override
  Map<String, dynamic> raw;

  @override
  late final List<String> admin;

  @override
  late final int averageDailyRating;

  @override
  late final int clubID;

  @override
  late final String country;

  @override
  late final DateTime created;

  @override
  late final String description;

  @override
  late final String icon;

  @override
  late final bool isPublic;

  @override
  late final String joinRequestUrl;

  @override
  late final DateTime lastActivity;

  @override
  late final int membersCount;

  @override
  late final String name;

  @override
  Future<List<PartialMember?>> get weeklyMembers async {
    // horrific caching practices
    // TODO: implement TTL for club members cache
    if (_weeklyMembers.isEmpty) {
      _weeklyMembers = await client.fetchClubMembers(name.replaceAll(" ", "-"),
          weekly: true, allTime: false);
    }
    return _weeklyMembers;
  }

  @override
  Future<List<PartialMember?>> get monthlyMembers async {
    if (_monthlyMembers.isEmpty) {
      _monthlyMembers = await client.fetchClubMembers(name.replaceAll(" ", "-"),
          monthly: true, allTime: false);
    }
    return _monthlyMembers;
  }

  @override
  Future<List<PartialMember?>> get members async {
    if (_members.isEmpty) {
      _members = await client.fetchClubMembers(name.replaceAll(" ", "-"));
    }
    return _members;
  }

  Club(this.raw, this.client) {
    name = raw["name"];
    clubID = raw["club_id"] as int;
    icon = raw["icon"];
    String country = raw["country"];
    this.country = country.substring(country.length - 2);
    averageDailyRating = raw["average_daily_rating"];
    membersCount = raw["members_count"];
    created = DateTime.fromMillisecondsSinceEpoch(raw["created"] * 1000);
    lastActivity =
        DateTime.fromMillisecondsSinceEpoch(raw["last_activity"] * 1000);
    isPublic = raw["visibility"] == "public";
    joinRequestUrl = raw["join_request"];
    admin =
        (raw["admin"] as List<String>).map((e) => e.split("/").last).toList();
    description = raw["description"];
  }
}
