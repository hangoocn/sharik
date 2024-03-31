import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                receivers.length.toString(),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: receivers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.amber[colorCodes[index]],
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              '设备 ${receivers[index].os} ${receivers[index].addr.ip}',
                            ),
                            const SizedBox(height: 8),
                            Text('文件 ${receivers[index].name}')
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
