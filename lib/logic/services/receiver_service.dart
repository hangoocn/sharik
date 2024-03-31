import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../conf.dart';
import '../sharing_object.dart';
import 'ip_service.dart';

class ReceiverService extends ChangeNotifier {
  final ipService = LocalIpService();

  // todo SharingObject instead
  final List<Receiver> receivers = [];

  bool loaded = false;
  int loop = 0;

  void kill() {
    loaded = false;
  }

  Future<void> init() async {
    await ipService.load();
    loaded = true;
    notifyListeners();

    while (true) {
      if (!loaded) {
        return;
      }

      final res = await compute(_run, ipService.getIp());
      receivers.clear();
      receivers.addAll(res);

      loop++;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  static Future<List<Receiver>> _run(String _ip) async {
    final _ = _ip.split('.');
    final thisDevice = int.parse(_.removeLast());

    final ip = _.join('.');

    final devices = [
      for (var e in List.generate(254, (index) => index + 1))
        if (e != thisDevice) '$ip.$e'
    ];

    final futuresPing = <NetworkAddr, Future<bool>>{};

    // todo run first port every time, second every second time, etc
    for (final device in devices) {
      for (final port in ports) {
        final n = NetworkAddr(ip: device, port: port);
        futuresPing[n] = _ping(n);
      }
    }

    final futuresSharik = <Future<Receiver?>>[];

    for (final ping in futuresPing.entries) {
      final p = await ping.value;

      if (p) {
        futuresSharik.add(_hasSharik(ping.key));
      }
    }

    final result = <Receiver>[];

    for (final sharik in futuresSharik) {
      final r = await sharik;
      if (r != null) {
        result.add(r);
      }
    }

    return result;
  }

  static Future<Receiver?> _hasSharik(NetworkAddr addr) async {
    try {
      final url = 'http://${addr.ip}:${addr.port}/sharik.json';
      final result = await http
          .get(Uri.parse(url))
          .timeout(const Duration(milliseconds: 800));

      await http
          .get(Uri.parse('http://${addr.ip}:${addr.port}'))
          .then((response) {
        final jsonData = json.decode(result.body);

        File('C:\\Users\\tadrop\\Documents\\sharik\\' +
                (jsonData['name'] as String))
            .writeAsBytesSync(response.bodyBytes, flush: true);
      }).catchError((e) {
        print(e);
      });
      return Receiver.fromJson(addr: addr, json: result.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // todo check if this works when sharing extra large files
  static Future<bool> _ping(NetworkAddr addr) async {
    try {
      final s = await Socket.connect(
        addr.ip,
        addr.port,
        timeout: const Duration(seconds: 1),
      );
      s.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }
}

class NetworkAddr {
  final String ip;
  final int port;

  const NetworkAddr({
    required this.ip,
    required this.port,
  });
}

class Receiver {
  final NetworkAddr addr;

  final String os;
  final String name;
  final SharingObjectType type;

  const Receiver({
    required this.addr,
    required this.os,
    required this.name,
    required this.type,
  });

  factory Receiver.fromJson({required NetworkAddr addr, required String json}) {
    final parsed = jsonDecode(json);

    return Receiver(
      addr: addr,
      os: parsed['os'] as String,
      name: parsed['name'] as String,
      type: string2fileType(parsed['type'] as String),
    );
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString('$counter');
}

Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}
