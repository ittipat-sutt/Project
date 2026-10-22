import 'package:flutter/material.dart';
import '../models/device.dart';

final devices = <SmartDevice>[
  SmartDevice(
    id: 'light',
    name: 'Light',
    icon: Icons.lightbulb_rounded,
    color: const Color(0xFFFFB74D),
    power: '12 W',
    isOn: true,
    schedule: '18:00 – 23:00',
  ),
  SmartDevice(
    id: 'fan',
    name: 'Fan',
    icon: Icons.mode_fan_off_rounded,
    color: const Color(0xFF55C9F5),
    power: '65 W',
    isOn: true,
  ),
  SmartDevice(
    id: 'airConditioner',
    name: 'Air Conditioner',
    icon: Icons.ac_unit_rounded,
    color: const Color(0xFF9BAAFF),
    power: '0 W',
    isOn: false,
    schedule: '22:00 – 06:00',
  ),
  SmartDevice(
    id: 'computer',
    name: 'Computer',
    icon: Icons.desktop_windows_rounded,
    color: const Color(0xFFB39DDB),
    power: '0 W',
    isOn: false,
  ),
];
