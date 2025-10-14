import 'Album.dart';
import 'Artist.dart';

class Track {
  final int id;
  final String name;
  final String displayedName;
  final String? description;
  final int trackNumber;
  final String fileName;
  final String playUrl;
  final int? albumId;
  Album? albumInfo;
  final int? artistId;
  Artist? artistInfo;
  final List<dynamic> contributors;
  String? localPath;

  Track({
    required this.id,
    required this.name,
    required this.displayedName,
    this.description,
    required this.trackNumber,
    required this.fileName,
    required this.playUrl,
    this.albumId,
    this.albumInfo,
    this.artistId,
    this.artistInfo,
    List<dynamic>? contributors,
    this.localPath,
  }) : contributors = contributors ?? const [];

  /// Parsing helpers
  static int _parseInt(dynamic v, {int defaultValue = 0}) {
    if (v == null) return defaultValue;
    if (v is int) return v;
    if (v is String) {
      return int.tryParse(v) ?? defaultValue;
    }
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

  static Track fromJson(Map<String, dynamic> json) {
    final id = _parseInt(json['id']);
    final name = _str(json['name']);
    final displayedName = _str(json['displayedName'], defaultValue: name);
    final description = json['description'] == null
        ? null
        : _str(json['description'], defaultValue: null ?? '');

    final trackNumber = _parseInt(json['trackNumber'], defaultValue: 0);
    final fileName = _str(json['fileName']);
    final playUrl = _str(json['playUrl']);

    int? albumId;
    final ai = json['albumInfo'];
    if (ai != null) {
      final v = ai['@albumId'];
      albumId = (v == null) ? null : _parseInt(v, defaultValue: null ?? 0);
    }

    int? artistId;
    final ar = json['artistInfo'];
    if (ar != null) {
      final v = ar['@artistId'];
      artistId = (v == null) ? null : _parseInt(v, defaultValue: null ?? 0);
    }

    return Track(
      id: id,
      name: name,
      displayedName: displayedName,
      description: description?.isEmpty == true ? null : description,
      trackNumber: trackNumber,
      fileName: fileName,
      playUrl: playUrl,
      albumId: albumId == 0 ? null : albumId,
      artistId: artistId == 0 ? null : artistId,
      contributors: (json['contributors'] as List?) ?? const [],
      localPath: json['localPath'] as String?,
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
  bool operator ==(Object other) => other is Track && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$id $albumId';
}
