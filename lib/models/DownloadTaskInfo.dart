import 'package:hive/hive.dart';

import 'Track.dart';

part 'DownloadTaskInfo.g.dart';

@HiveType(typeId: 0)
class DownloadTaskInfo extends HiveObject {
  @HiveField(0)
  final Track track;

  @HiveField(1)
  int received = 0;
  @HiveField(2)
  int total = 0;

  DownloadTaskInfo({this.track});
}
