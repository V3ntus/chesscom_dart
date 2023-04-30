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
  factory IHttpEndpoint() = HttpEndpoint;

  void add(HttpEndpointPart httpEndpointPart);

  void player(String username);

  void club(String clubName);

  void tournament(String tournamentName);

  void match(String matchId);

  void country(String countryCode);
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
  void match(String matchId) =>
      add(HttpEndpointPart("match", [HttpEndpointParam(matchId, isMajor: true)]));

  @override
  void player(String username) =>
      add(HttpEndpointPart("username", [HttpEndpointParam(username)]));

  @override
  void tournament(String tournamentName) {
    // TODO: implement tournament
  }
}
