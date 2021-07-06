import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:senetunes/models/DownloadTaskInfo.dart';

class DownloadLogic extends ChangeNotifier {
  var _dio = Dio();
  ReceivePort _port = ReceivePort();

  void bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    print("isSuccess:$isSuccess");
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    try {
      _port.listen((dynamic data) async {
        DownloadTaskInfo _taskInfo = data;
        Directory dir = await getApplicationDocumentsDirectory();
        await _dio.download(
            _taskInfo.track.playUrl, "${dir.path}/${_taskInfo.track.name}.mp3",
            onReceiveProgress: (received, total) {
          _taskInfo.received = received;
          _taskInfo.total = total;
          _downloadCallBack(_taskInfo);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static _downloadCallBack(DownloadTaskInfo taskInfo) {
    SendPort send = IsolateNameServer.lookupPortByName("downloadIsolate");
    send.send(taskInfo);
  }
}
