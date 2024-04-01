import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../components/device_list.dart';
import '../logic/device.dart';
import '../logic/services/receiver_service.dart';

class FileManagerScreen extends StatefulWidget {
  @override
  _FileManagerScreenState createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  final ReceiverService receiverService = ReceiverService()..init();
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  List<Device> _devices = <Device>[];

  @override
  void initState() {
    _devices = Hive.box<Device>('devices').values.toList();
    super.initState();
  }

  Future<void> _refreshDevices(List<Device> devices) async {
    await Hive.box<Device>('devices').clear();
    await Hive.box<Device>('devices').addAll(devices);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: receiverService,
      builder: (context, _) {
        final receivers = context.watch<ReceiverService>().receivers;
        for (final device in _devices) {
          device.isOnline = false;
        }
        for (final receiver in receivers) {
          var found = false;
          for (final device in _devices) {
            if (device.id == receiver.id) {
              found = true;
              device.isOnline = true;
            }
          }

          if (!found) {
            _devices.add(Device(id: receiver.id, name: receiver.name, isOnline: true, os: receiver.os, ip: receiver.addr.ip, url: receiver.url));
          }
        }

        _refreshDevices(_devices);

        return Scaffold(
          body: DeviceList(devices: _devices),
        );
      },
    );
  }
}
