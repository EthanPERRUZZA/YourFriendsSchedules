import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../provider/event_provider.dart';
import '../model/event_data_source.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Loads all the events already created
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
      view: CalendarView.day,
      dataSource: EventDataSource(events),
    );
  }
}
