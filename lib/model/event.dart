import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;
  final String fromXCalendar;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.lightGreen,
    this.isAllDay = false,
    this.fromXCalendar = "__local_events",
  });

  @override
  bool operator ==(Object other) {
    return other is Event &&
        title == other.title &&
        from == other.from &&
        to == other.to &&
        description == other.description &&
        fromXCalendar == other.fromXCalendar;
  }
}
