import 'package:flutter/material.dart';

import '../logic/device.dart';
import 'downloader.dart';
import 'online_indicator.dart';

class DeviceList extends StatelessWidget {
  final List<Device> devices;

  const DeviceList({required this.devices});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        var crossAxisCount = screenWidth ~/ 200; // Adjust based on screen width
        crossAxisCount = crossAxisCount.clamp(1, 4); // Limit to 1-4 columns

        return GridView.builder(
          itemCount: devices.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemBuilder: (context, index) {
            return _buildDeviceCard(devices[index]);
          },
        );
      },
    );
  }

  Widget _buildDeviceCard(Device device) {
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.folder,
                  color: Color(
                    0xFFfec855,
                  ), // Change icon color to similar color to #fec855
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          device.os,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(
                              0xFF525662,
                            ), // Change text color for device name
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        const OnlineIndicator()
                      ],
                    )),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.more_vert),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
            ), // Adjust horizontal padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Files: 20',
                  style: TextStyle(
                    color: Color(
                      0xFF5e616d,
                    ), // Change text color for number of files
                  ),
                ),
                Text(
                  'Space: 120 MB',
                  style: TextStyle(
                    color:
                        Color(0xFF737680), // Change text color for usage space
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8),
            child: Downloader(
              url: device.url,
              device: device.ip,
              name: device.name,
            ),
          ),
        ],
      ),
    );
  }
}
