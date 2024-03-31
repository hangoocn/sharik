
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/services/receiver_service.dart';

class FileManagerScreen extends StatefulWidget {
  @override
  _FileManagerScreenState createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(context.watch<ReceiverService>().receivers.length.toString()),
            const Expanded(child: Text(''),),
            const SizedBox(height: 24),
            ],
        ),
    );
  }
}
