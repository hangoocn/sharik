import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Downloader extends StatefulWidget {
  final String url;
  final String name;
  final String device;

  const Downloader({required this.url, required this.device, required this.name});

  @override
  _DownloaderState createState() => _DownloaderState();
}

class _DownloaderState extends State<Downloader> {
  late Dio dio;
  bool downloading = false;
  double downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  Future<void> _download() async {
    setState(() {
      downloading = true;
      downloadProgress = 0.0;
    });

    final appDir = await getApplicationDocumentsDirectory();
    final deviceDir = Directory('${appDir.path}/${widget.device}');
    if (!deviceDir.existsSync()) {
      deviceDir.createSync();
    }
    final savePath = '${deviceDir.path}/${widget.name}';

    try {
      await dio.download(widget.url, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            downloadProgress = received / total;
          });
        }
      });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElevatedButton(
          onPressed: downloading ? null : _download,
          child: Text('Download'),
        ),
        const SizedBox(height: 20),
        if (downloading)
          LinearProgressIndicator(
            value: downloadProgress,
          ),
      ],
    );
  }
}
