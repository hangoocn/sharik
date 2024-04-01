import 'package:flutter/material.dart';

class OnlineIndicator extends StatelessWidget {
  final double size;

  const OnlineIndicator({this.size = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}