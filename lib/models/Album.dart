import 'package:flutter_rekord_app/models/Artist.dart';

import 'Media.dart';
import 'Track.dart';

class Album {
  int id;
  String name;
  String description;
  int artistId;
  Artist artistInfo;
  String uri;
  Media media;
  List contributors;
  List<Track> tracks;
  double price = 200;
  bool isBought;

  Album({this.id, this.name, this.description, this.artistId, this.artistInfo, this.uri, this.media, this.contributors, this.tracks});

  static Album fromJson(Map<String, dynamic> json) {
    List<Track> tracks = [];
    if (json['songs'] != null && json['songs']['song'] != null) {
      if (json['songs']['song'] is List<dynamic>) {
        for (dynamic e in json['songs']['song']) {
          tracks?.add(Track.fromJson(e as Map<String, dynamic>));
        }
      } else {
        tracks?.add(Track.fromJson(json['songs']['song']));
      }
    }

    return Album(
      id: json['id'] is String
          ? int.parse(json['id'])
          : json['id'] is int
              ? json['id']
              : int.parse(json['id']['\$']),
      name: json['name'] is String ? json['name'] : json['name']['\$'],
      description: json['description'] is String ? json['description'] : json['description']['\$'],
      artistId: json['artistInfo'] == null
          ? null
          : json['artistInfo']['@artistId'] == null
              ? null
              : json['artistInfo']['@artistId'] is String
                  ? int.parse(json['artistInfo']['@artistId'])
                  : json['artistInfo']['@artistId'],
      uri: json['uri'] is String ? json['uri'] : json['uri']['\$'],
      media: Media(json['coverPictureUrls'] is String ? json['coverPictureUrls'] : json['coverPictureUrls']['\$']),
      contributors: json['contributors'] == null
          ? null
          : json['contributors']['contributors'] == null
              ? null
              : json['contributors']['contributors'],
      tracks: tracks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'artistInfo': {'@artistId': artistId},
      'uri': uri,
      'coverPictureUrls': "${media.cover} ${media.medium} ${media.thumbnail}",
      'contributors': {'contributors': contributors},
      'songs': {'song': tracks.map((e) => e.toJson()).toList()}
    };
  }

  @override
  bool operator ==(Object other) => other is Album && other.id == this.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
