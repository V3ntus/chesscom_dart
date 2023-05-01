class HttpEndpointParam {
  final String param;

  final bool isMajor;

  HttpEndpointParam(this.param, {this.isMajor = false});
}

class HttpEndpointPart {
  final String path;

  final List<HttpEndpointParam> params;

  HttpEndpointPart(this.path, [this.params = const <HttpEndpointParam>[]]);
}

abstract class IHttpEndpoint {
  /// Create an empty [IHttpEndpoint].
  factory IHttpEndpoint() = HttpEndpoint;

  /// Adds a [HttpRoutePart] to this [IHttpEndpoint].
  void add(HttpEndpointPart httpEndpointPart);

  /// A player base endpoint. Requires a username.
  void player(String username);

  /// A club base endpoint. Requires the club name.
  void club(String clubName);

  /// A tournament base endpoint. Requires the full tournament name.
  /// Optional round and group numbers can be supplied.
  void tournament(String tournamentName, {int? round, int? group});

  /// Tournaments parameter.
  void tournaments();

  /// A team match base endpoint. Requires the match ID.
  void match(String matchId);

  /// List of tournaments player is registered/attending/has attended.
  /// Or if appended to a club endpoint, daily and club matches.
  void matches();

  /// A country base endpoint. Requires the two letter country code.
  void country(String countryCode);

  /// A daily puzzle endpoint.
  void puzzle({bool random = false});

  /// Player stats.
  void stats();

  /// Player games.
  void games({bool toMove = false});

  /// Player games archives.
  void archives({int? year, int? month});

  /// Player games archive PGN.
  void pgn();

  /// Titled players.
  void titled(String title);

  /// Club members.
  void members();

  /// Team match board information.
  void board(String id);

  /// Country players.
  void players();

  /// Country clubs.
  void clubs();

  /// Information about Chess.com streamers.
  void streamers();

  /// Info of top 50 players for daily and live games, tactics, and lessons.
  void leaderboards();
}

class HttpEndpoint implements IHttpEndpoint {
  final List<HttpEndpointPart> _httpRouteParts = [];

  List<String> get pathSegments => _httpRouteParts
      .expand((part) => [
            part.path,
            ...part.params.map((param) => param.param),
          ])
      .toList();

  String get path => "/${pathSegments.join("/")}";

  @override
  void add(HttpEndpointPart httpEndpointPart) =>
      _httpRouteParts.add(httpEndpointPart);

  @override
  void club(String clubName) => add(
      HttpEndpointPart("club", [HttpEndpointParam(clubName, isMajor: true)]));

  @override
  void country(String countryCode) => add(HttpEndpointPart(
      "country", [HttpEndpointParam(countryCode, isMajor: true)]));

  @override
  void match(String matchId) => add(
      HttpEndpointPart("match", [HttpEndpointParam(matchId, isMajor: true)]));

  @override
  void matches() => add(HttpEndpointPart("matches"));

  @override
  void player(String username) => add(
      HttpEndpointPart("player", [HttpEndpointParam(username, isMajor: true)]));

  @override
  void tournament(String tournamentName, {int? round, int? group}) =>
      add(HttpEndpointPart("tournament", [
        HttpEndpointParam(tournamentName, isMajor: true),
        ...(round != null && group != null
            ? [
                HttpEndpointParam(round.toString()),
                HttpEndpointParam(group.toString()),
              ]
            : [])
      ]));

  @override
  void tournaments() => add(HttpEndpointPart("tournaments"));

  @override
  void puzzle({bool random = false}) => add(HttpEndpointPart("puzzle", [
        ...(random ? [HttpEndpointParam("random")] : [])
      ]));

  @override
  void stats() => add(HttpEndpointPart("stats"));

  @override
  void games({bool toMove = false}) => add(HttpEndpointPart("games", [
        ...(toMove ? [HttpEndpointParam("to-move")] : [])
      ]));

  @override
  void archives({int? year, int? month}) {
    if (year != null && month != null) {
      add(HttpEndpointPart("archives", [
        HttpEndpointParam(year.toString()),
        HttpEndpointParam(month.toString()),
      ]));
    } else {
      add(HttpEndpointPart("archives"));
    }
  }

  @override
  void titled(String title) => add(
      HttpEndpointPart("titled", [HttpEndpointParam(title, isMajor: true)]));

  @override
  void pgn() => add(HttpEndpointPart("pgn"));

  @override
  void board(String id) => add(HttpEndpointPart(id));

  @override
  void clubs() => add(HttpEndpointPart("clubs"));

  @override
  void members() => add(HttpEndpointPart("members"));

  @override
  void players() => add(HttpEndpointPart("players"));

  @override
  void streamers() => add(HttpEndpointPart("streamers"));

  @override
  void leaderboards() => add(HttpEndpointPart("leaderboards"));
}
