import 'Album.dart';
import 'Artist.dart';

class Category {
  final int id;
  final String name;
  final String description;
  final String uri;
  final List<Album>? albums;
  final List<dynamic>? albumIds;
  final String? uriAlbums;
  final List<Artist>? artist;
  final List<dynamic>? artistIds;
  final String? uriArtists;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.uri,
    this.uriArtists,
    this.uriAlbums,
    this.albums,
    this.albumIds,
    this.artist,
    this.artistIds,
  });

  static Category fromJson(Map<String, dynamic> json) {
    int parseId(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      if (v is Map && v[r'$'] != null) {
        return int.tryParse(v[r'$'].toString()) ?? 0;
      }
      return 0;
    }

    String parseStr(dynamic v) {
      if (v is String) return v;
      if (v is Map && v[r'$'] != null) return v[r'$'].toString();
      return '';
    }

    return Category(
      id: parseId(json['id']),
      name: parseStr(json['name']),
      description: parseStr(json['description']),
      uri: parseStr(json['uri']),
      uriAlbums: json['uriAlbums'] != null ? parseStr(json['uriAlbums']) : null,
      uriArtists: json['uriArtists'] != null ? parseStr(json['uriArtists']) : null,
    );
  }
}
