import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/calendar.dart';
import '../provider/event_provider.dart';

class CalendarsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Loads all the events already created
    final calendars = Provider.of<EventProvider>(context).calendars;

    return Column(
      children: BuildCalendarsList(calendars),
    );
  }

  List<Widget> BuildCalendarsList(List<Calendar> calendars) {
    List<Widget> calendarsList = [];
    for (Calendar calendar in calendars) {
      calendarsList.add(Row(
        children: [
          // Calendar color
          // Expanded(child:)),
          // Calendar Title
          Expanded(
            flex: 5,
            child: Text(calendar.title),
          ),
          // Calendar delete button
          // Expanded(child:)),
        ],
      ));
    }
    return calendarsList;
  }
}
