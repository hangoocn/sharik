import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/device_list.dart';
import '../logic/services/receiver_service.dart';

class FileManagerScreen extends StatefulWidget {
  @override
  _FileManagerScreenState createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  final ReceiverService receiverService = ReceiverService()..init();
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: receiverService,
      builder: (context, _) {
        final receivers = context.watch<ReceiverService>().receivers;

        return Scaffold(
          body: DeviceListWidget(devices: receivers),
        );
      },
    );
  }
}
