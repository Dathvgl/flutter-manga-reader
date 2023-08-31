import 'package:flutter/material.dart';

enum NavigateStatus {
  go,
  push,
  pushReplacement,
}

class RouteModel {
  final NavigateStatus navigation;
  final String name;
  final String path;
  final IconData icon;

  RouteModel({
    required this.navigation,
    required this.name,
    required this.path,
    required this.icon,
  });
}
