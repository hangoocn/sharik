import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Downloader extends StatefulWidget {
  final String url;
  final String name;
  final String device;

  const Downloader(
      {required this.url, required this.device, required this.name});

  @override
  _DownloaderState createState() => _DownloaderState();
}

class _DownloaderState extends State<Downloader> {
  late Dio dio;
  bool downloading = false;
  double downloadProgress = 0.0;
  String downloadSpeed = '0.0 B/s';
  late DateTime startTime;
  late int bytesReceived;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    _download();
  }

  @override
  void didUpdateWidget(covariant Downloader oldWidget) {
    if (widget.name != oldWidget.name) {
      _download();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _download() async {
    setState(() {
      downloading = true;
      downloadProgress = 0.0;
      downloadSpeed = '0.0 B/s';
    });

    final appDir = await getApplicationDocumentsDirectory();
    final deviceDir = Directory('${appDir.path}/${widget.device}');
    if (!deviceDir.existsSync()) {
      deviceDir.createSync();
    }
    final filePath = '${deviceDir.path}/${widget.name}';

    if (File(filePath).existsSync()) {
      return;
    }

    startTime = DateTime.now();
    bytesReceived = 0;

    try {
      await dio.download(
        widget.url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = received / total;
              bytesReceived = received;
            });

            final timeElapsed =
                DateTime.now().difference(startTime).inMilliseconds / 1000;
            final speed = (bytesReceived / timeElapsed).round();

            setState(() {
              downloadSpeed = _formatSpeed(speed);
            });
          }
        },
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download image'),
        ),
      );
      setState(() {
        downloading = false;
        downloadProgress = 0.0;
      });
      return;
    }

    setState(() {
      downloading = false;
      downloadProgress = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(' downloaded successfully'),
      ),
    );

    // Open the directory containing the downloaded file
    await OpenFile.open(deviceDir.path);
  }

  String _formatSpeed(int speed) {
    final units = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    var index = 0;
    var speedValue = speed.toDouble();

    while (speedValue >= 1024 && index < units.length - 1) {
      speedValue /= 1024;
      index++;
    }

    return '${speedValue.toStringAsFixed(1)} ${units[index]}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (downloading)
          LinearProgressIndicator(
            value: downloadProgress,
          ),
        const SizedBox(height: 10),
        Text(
          'Download Speed: $downloadSpeed',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
