import 'Album.dart';
import 'Media.dart';
import 'Track.dart';

class Artist {
  final int id;
  final String name;
  final Media? media;
  final List<int> albumIds;
  List<Album>? albums;
  final String uri;
  final String uriAlbums;
  List<Track>? tracks;

  Artist({
    required this.id,
    required this.name,
    this.media,
    List<int>? albumIds,
    this.albums,
    required this.uri,
    required this.uriAlbums,
    this.tracks,
  }) : albumIds = albumIds ?? const [];

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

  static Artist fromJson(Map<String, dynamic> json) {
    // album ids
    final List<int> albumsIds = [];
    final albumsInfo = json['albumsInfo'];
    if (albumsInfo != null && albumsInfo['albumInfo'] != null) {
      final temp = albumsInfo['albumInfo'];
      try {
        if (temp is List) {
          for (final info in temp) {
            final v = info['@albumId'];
            albumsIds.add(_parseInt(v));
          }
        } else if (temp is Map) {
          final v = temp['@albumId'];
          albumsIds.add(_parseInt(v));
        }
      } catch (_) {/* ignore */}
    }

    // media
    Media? media;
    final pic = json['pictureUrls'];
    final urls = _str(pic);
    if (urls.isNotEmpty) {
      media = Media(urls);
    }

    return Artist(
      id: _parseInt(json['id']),
      name: _str(json['name']),
      media: media,
      albumIds: albumsIds,
      uri: _str(json['uri']),
      uriAlbums: _str(json['uriAlbums']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pictureUrls': media == null
          ? ''
          : '${media!.cover} ${media!.medium} ${media!.medium}',
      'albumsInfo': {
        'albumInfo': albumIds.map((e) => {'@albumId': e.toString()}).toList(),
      },
      'uri': uri,
      'uriAlbums': uriAlbums,
    };
  }

  @override
  bool operator ==(Object other) => other is Artist && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
