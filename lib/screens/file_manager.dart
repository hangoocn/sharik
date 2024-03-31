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
        context.watch<ReceiverService>();

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                  context.watch<ReceiverService>().receivers.length.toString()),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        color: Colors.amber[colorCodes[index]],
                        child: Center(child: Text('Entry ${entries[index]}')),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
