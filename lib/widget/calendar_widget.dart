import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.day,
    );
  }
}
