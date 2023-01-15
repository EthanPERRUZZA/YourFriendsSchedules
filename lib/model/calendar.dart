import 'package:flutter/material.dart';

class Calendar {
  final String title;
  final String link;
  final Color backgroundColor;

  const Calendar({
    required this.title,
    required this.link,
    this.backgroundColor = Colors.lightBlue,
  });
}
