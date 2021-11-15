import 'Album.dart';
import 'Media.dart';
import 'Track.dart';

class Artist {
  int id;
  String name;
  Media media;
  List<int> albumIds;
  List<Album> albums;
  String uri;
  String uriAlbums;
  List<Track> tracks;
  Artist(
      {this.id,
      this.name,
      this.media,
      this.albumIds,
      this.albums,
      this.uri,
      this.uriAlbums,
      this.tracks});

  static Artist fromJson(Map<String, dynamic> json) {
    List<int> albumsIds = [];
    if (json['albumsInfo'] != null && json['albumsInfo']['albumInfo'] != null) {
      var temp = json['albumsInfo']['albumInfo'];
      try {
        for (Map<String, dynamic> info in temp) {
          albumsIds?.add(int.parse(info['@albumId']));
        }
      } catch (TypeError) {
        temp['@albumId'] is String
            ? albumsIds?.add(int.parse(temp['@albumId']))
            : albumsIds?.add(temp['@albumId']);
      }
    }

    return Artist(
      id: json['id'] is String
          ? int.parse(json['id'])
          : json['id'] is int
              ? json['id']
              : int.parse(json['id']['\$']),
      name: json['name'] is String ? json['name'] : json['name']["\$"],
      media: Media(json['pictureUrls'] is String ? json['pictureUrls'] : json['pictureUrls']["\$"]),
      albumIds: albumsIds,
      uri: json['uri'] is String ? json['uri'] : json['uri']["\$"],
      uriAlbums: json['uriAlbums'] is String ? json['uriAlbums'] : json['uriAlbums']["\$"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pictureUrls': "${media.cover} ${media.medium} ${media.thumbnail}",
      'albumsInfo': {
        'albumInfo': albumIds.map((e) => {'@albumId': e.toString()}).toList()
      },
      'uri': uri,
      'uriAlbums': uriAlbums,
    };
  }

  @override
  bool operator ==(Object other) => other is Artist && other.id == this.id;

  @override
  int get hashCode => id.hashCode;
}
