abstract class IClub {
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
}

class Club implements IClub {
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

  Club(this.raw) {
    name = raw["name"];
    clubID = raw["club_id"] as int;
    icon = raw["icon"];
    String country = raw["country"];
    this.country = country.substring(country.length - 2);
    averageDailyRating = raw["average_daily_rating"];
    membersCount = raw["members_count"];
    created = DateTime.fromMillisecondsSinceEpoch(raw["created"] * 1000);
    lastActivity = DateTime.fromMillisecondsSinceEpoch(raw["last_activity"] * 1000);
    isPublic = raw["visibility"] == "public";
    joinRequestUrl = raw["join_request"];
    admin = (raw["admin"] as List<String>).map((e) => e.split("/").last).toList();
    description = raw["description"];
  }
}