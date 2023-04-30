// pls write a proper cache implementation
import 'dart:async';
import 'dart:collection';

import 'package:chesscom_dart/internal/api.dart';
import 'package:chesscom_dart/internal/models/player.dart';

abstract class Cacheable<T extends CacheKey, S extends Object> {
  final ChessAPI client;
  final T _key;

  bool isExpired() {
    return DateTime.now().millisecondsSinceEpoch >= _key.ttl.millisecondsSinceEpoch;
  }

  Cacheable(this.client, this._key);

  /// Return an entity from cache or null if not present.
  S? getFromCache();

  /// Downloads entity and caches result.
  Future<S> download();

  /// Returns entity from cache or tries to download from API
  /// if not found. Caches result.
  FutureOr<S> getOrDownload() async {
    final cacheResult = getFromCache();
    if (isExpired() && cacheResult != null) {
      return cacheResult;
    }
    return download();
  }
}

class PlayerCacheable extends Cacheable<CacheKey, Player> {
  final CacheKey key;

  PlayerCacheable(ChessAPI client, this.key) : super(client, key);

  @override
  Future<Player> download() => client.fetchProfile((key.v as Player).username);

  @override
  Player? getFromCache() => isExpired() ? null : client.players[key];
}

class PlayerStatsCacheable extends Cacheable<CacheKey, Object> {
  final CacheKey key;

  PlayerStatsCacheable(ChessAPI client, this.key) : super(client, key);

  @override
  Future<Object> download() {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  Object? getFromCache() {
    // TODO: implement getFromCache
    throw UnimplementedError();
  }
}

class CacheKey {
  DateTime ttl;
  Object v;

  @override
  int get hashCode => ttl.millisecondsSinceEpoch + v.hashCode;

  CacheKey(this.ttl, this.v);

  @override
  bool operator ==(Object other) => v.hashCode == other.hashCode;
}

class Cache<V> extends InMemoryCache<CacheKey, V> {
  final int cacheSize;

  Cache([this.cacheSize = -1]) : super();

  @override
  void operator []=(CacheKey key, V value) {
    if (cacheSize == 0) {
      return;
    }
    if (cacheSize > 0 && length >= cacheSize) {
      remove(keys.first);
    }
    _map[key] = value;
  }
}

abstract class InMemoryCache<K, V> extends MapMixin<K, V> implements ICache<K, V> {
  final Map<K, V> _map = {};

  @override
  V? operator [](Object? key) => _map[key];

  @override
  void operator []=(K key, V value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V? remove(Object? key) => _map.remove(key);

  void dispose() => _map.clear();
}

abstract class ICache<K, V> implements MapMixin<K, V> {}