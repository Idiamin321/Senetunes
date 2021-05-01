import 'Album.dart';
import 'Artist.dart';

class Category {
  int id;
  String name;
  String description;
  String uri;
  List<Album> albums;
  List<dynamic> albumIds;
  String uriAlbums;
  List<Artist> artist;
  List<dynamic> artistIds;
  String uriArtists;
  Category({this.id, this.name, this.description, this.uri, this.uriArtists, this.uriAlbums});

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is String
          ? int.parse(json['id'])
          : json['id'] is int
              ? json['id']
              : int.parse(json['id']['\$']),
      name: json['name'] is String ? json['name'] : json['name']["\$"],
      description: json['description'] is String ? json['description'] : json['description']['\$'],
      uri: json['uri'] is String ? json['uri'] : json['uri']['\$'],
      uriAlbums: json['uriAlbums'] is String ? json['uriAlbums'] : json['uriAlbums']['\$'],
      uriArtists: json['uriArtists'] is String ? json['uriArtists'] : json['uriArtists']['\$'],
    );
  }
}
