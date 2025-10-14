import 'Artist.dart';
import 'Media.dart';
import 'Track.dart';

class Album {
  final int id;
  final String name;
  final String? description;
  final int? artistId;
  Artist? artistInfo;
  final String uri;
  final Media? media;
  final List<dynamic> contributors;
  final List<Track> tracks;
  double? price;
  bool isBought;

  Album({
    required this.id,
    required this.name,
    this.description,
    this.artistId,
    this.artistInfo,
    required this.uri,
    this.media,
    List<dynamic>? contributors,
    List<Track>? tracks,
    this.isBought = false,
    this.price,
  })  : contributors = contributors ?? const [],
        tracks = tracks ?? const [];

  /// Helpers
  static int _parseInt(dynamic v, {int defaultValue = 0}) {
    if (v == null) return defaultValue;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? defaultValue;
    if (v is Map && v.containsKey(r'$')) {
      return int.tryParse('${v[r"$"]}') ?? defaultValue;
    }
    return defaultValue;
  }

  static String _str(dynamic v, {String defaultValue = ''}) {
    if (v == null) return defaultValue;
    if (v is String) return v;
    if (v is Map && v.containsKey(r'$')) return '${v[r"$"]}';
    return defaultValue;
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static Album fromJson(Map<String, dynamic> json) {
    // tracks
    final List<Track> tracks = [];
    final songs = json['songs'];
    if (songs != null && songs['song'] != null) {
      final s = songs['song'];
      if (s is List) {
        for (final e in s) {
          if (e is Map<String, dynamic>) {
            tracks.add(Track.fromJson(e));
          }
        }
      } else if (s is Map<String, dynamic>) {
        tracks.add(Track.fromJson(s));
      }
    }

    // media
    Media? media;
    final coverUrls = json['coverPictureUrls'];
    if (coverUrls != null) {
      final urls = _str(coverUrls);
      if (urls.isNotEmpty) {
        media = Media(urls); // ton Media(String url) existant
      }
    }

    // contributors
    List<dynamic> contributors = const [];
    final contrib = json['contributors'];
    if (contrib != null) {
      final c2 = contrib['contributors'];
      if (c2 is List) contributors = c2;
    }

    final id = _parseInt(json['id']);
    final name = _str(json['name']);
    final description = _str(json['description'], defaultValue: '');
    final uri = _str(json['uri']);

    int? artistId;
    final ai = json['artistInfo'];
    if (ai != null) {
      final v = ai['@artistId'];
      artistId = (v == null) ? null : _parseInt(v, defaultValue: null ?? 0);
      if (artistId == 0) artistId = null;
    }

    final price = _parseDouble(json['price']);
    final isBought = (json['isBought'] is bool) ? json['isBought'] as bool : false;

    return Album(
      id: id,
      name: name,
      description: description.isEmpty ? null : description,
      artistId: artistId,
      uri: uri,
      media: media,
      contributors: contributors,
      tracks: tracks,
      isBought: isBought,
      price: price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'artistInfo': {'@artistId': artistId},
      'uri': uri,
      // null-safe: si media absent, on renvoie une chaîne vide
      'coverPictureUrls': media == null
          ? ''
          : '${media!.cover} ${media!.medium} ${media!.medium}',
      'contributors': {'contributors': contributors},
      'songs': {'song': tracks.map((e) => e.toJson()).toList()},
      'isBought': isBought,
      'price': price,
    };
  }

  @override
  bool operator ==(Object other) => other is Album && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
