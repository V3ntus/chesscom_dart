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
  void tournament(String tournamentName);

  /// A team match base endpoint. Requires the match ID.
  void match(String matchId);

  /// A country base endpoint. Requires the two letter country code.
  void country(String countryCode);

  /// A daily puzzle endpoint.
  void puzzle();

  /// Player stats.
  void stats();

  /// Club members.
  void members();

  /// Tournament round information.
  void round(String id);

  /// Tournament round group information.
  void group(String id);

  /// Team match board information.
  void board(String id);

  /// Country players.
  void players();

  /// Country clubs.
  void clubs();
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
  void add(HttpEndpointPart httpEndpointPart) => _httpRouteParts.add(httpEndpointPart);

  @override
  void club(String clubName) => add(HttpEndpointPart("club", [HttpEndpointParam(clubName, isMajor: true)]));

  @override
  void country(String countryCode) => add(HttpEndpointPart("country", [HttpEndpointParam(countryCode, isMajor: true)]));

  @override
  void match(String matchId) => add(HttpEndpointPart("match", [HttpEndpointParam(matchId, isMajor: true)]));

  @override
  void player(String username) => add(HttpEndpointPart("player", [HttpEndpointParam(username, isMajor: true)]));

  @override
  void tournament(String tournamentName) =>
      add(HttpEndpointPart("tournament", [HttpEndpointParam(tournamentName, isMajor: true)]));

  @override
  void puzzle() => add(HttpEndpointPart("puzzle"));

  @override
  void stats() => add(HttpEndpointPart("stats"));

  @override
  void board(String id) => add(HttpEndpointPart(id));

  @override
  void clubs() => add(HttpEndpointPart("clubs"));

  @override
  void group(String id) => add(HttpEndpointPart(id));

  @override
  void members() => add(HttpEndpointPart("members"));

  @override
  void players() => add(HttpEndpointPart("players"));

  @override
  void round(String id) => add(HttpEndpointPart(id));
}
