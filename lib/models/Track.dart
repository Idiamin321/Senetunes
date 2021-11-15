import 'Album.dart';
import 'Artist.dart';

class Track {
  int id;
  String name;
  String displayedName;
  String description;
  int trackNumber;
  String fileName;
  String playUrl;
  int albumId;
  Album albumInfo;
  int artistId;
  Artist artistInfo;
  List contributors;
  String localPath;
  Track(
      {this.id,
      this.name,
      this.displayedName,
      this.description,
      this.trackNumber,
      this.fileName,
      this.playUrl,
      this.albumId,
      this.albumInfo,
      this.artistId,
      this.artistInfo,
      this.contributors,
      this.localPath});

  static Track fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] is String
          ? int.parse(json['id'])
          : json['id'] is int
              ? json['id']
              : int.parse(json['id']['\$']),
      name: json['name'] is String ? json['name'] : json['name']['\$'],
      displayedName: json['displayedName'] is String ? json['displayedName'] : json['displayedName']['\$'],
      description: json['description'] == null
          ? null
          : json['description'] is String
              ? json['description']
              : json['description']['\$'],
      trackNumber: json['trackNumber'] is String
          ? int.parse(json['trackNumber'])
          : json['trackNumber'] is int
              ? json['trackNumber']
              : int.parse(json['trackNumber']['\$']),
      fileName: json['fileName'] is String ? json['fileName'] : json['fileName']['\$'],
      playUrl: json['playUrl'] is String ? json['playUrl'] : json['playUrl']['\$'],
      albumId: json['albumInfo'] == null
          ? null
          : json['albumInfo']['@albumId'] == null
              ? null
              : json['albumInfo']['@albumId'] is String
                  ? int.parse(json['albumInfo']['@albumId'])
                  : json['albumInfo']['@albumId'],
      artistId: json['artistInfo'] == null
          ? null
          : json['artistInfo']['@artistId'] == null
              ? null
              : json['artistInfo']['@artistId'] is String
                  ? int.parse(json['artistInfo']['@artistId'])
                  : json['artistInfo']['@artistId'],
      contributors: json['contributors'],
      localPath: json['localPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayedName': displayedName,
      'description': description,
      'trackNumber': trackNumber,
      'fileName': fileName,
      'playUrl': playUrl,
      'albumInfo': {'@albumId': albumId},
      'artistInfo': {'@artistId': artistId},
      'contributors': contributors,
      'localPath': localPath,
    };
  }

  @override
  bool operator ==(Object other) => other is Track && other.id == this.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "$id $albumId";
  }
}
