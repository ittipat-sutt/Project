import 'package:flutter/material.dart';

class SmartDevice {
  SmartDevice({
    required this.name,
    required this.icon,
    required this.color,
    required this.power,
    required this.isOn,
    this.schedule,
  });

  final String name;
  final IconData icon;
  final Color color;
  final String power;
  bool isOn;
  String? schedule;
}
