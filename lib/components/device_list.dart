import 'package:flutter/material.dart';

import '../logic/services/receiver_service.dart';
import 'downloader.dart';
import 'online_indicator.dart';

class DeviceListWidget extends StatelessWidget {
  final List<Receiver> devices;
  final List data = [
    {'color': const Color(0xffff6968)},
    {'color': const Color(0xff7a54ff)},
    {'color': const Color(0xffff8f61)},
    {'color': const Color(0xff2ac3ff)},
    {'color': const Color(0xff5a65ff)},
    {'color': const Color(0xff96da45)},
    {'color': const Color(0xffff6968)},
    {'color': const Color(0xff7a54ff)},
    {'color': const Color(0xffff8f61)},
    {'color': const Color(0xff2ac3ff)},
    {'color': const Color(0xff5a65ff)},
    {'color': const Color(0xff96da45)},
  ];

  final colorwhite = Colors.white;

  DeviceListWidget({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GridView.builder(
        itemCount: devices.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          // crossAxisSpacing: 10
        ),
        itemBuilder: (context, index) {
          final device = devices[index];
          return Padding(
            padding: EdgeInsets.zero,
            child: Card(
              color: data[index]['color'],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                device.os,
                                style:
                                    TextStyle(color: colorwhite, fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              const OnlineIndicator(),
                            ],
                          ),
                          Icon(
                            Icons.more_vert,
                            color: colorwhite,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        device.addr.ip,
                        style: TextStyle(fontSize: 16, color: colorwhite),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(8),
                      child: Downloader(
                          url: device.url,
                          device: device.addr.ip,
                          name: device.name),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
