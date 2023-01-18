import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_friends_schedules/page/calendar_viewing_page.dart';
import '../model/calendar.dart';
import '../provider/event_provider.dart';

class CalendarsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Loads all the events already created
    final calendars = Provider.of<EventProvider>(context).calendars;

    return Column(
      children: BuildCalendarsList(context, calendars),
    );
  }

  List<Widget> BuildCalendarsList(
      BuildContext context, List<Calendar> calendars) {
    List<Widget> calendarsList = [
      const SizedBox(height: 12),
      const Text(
        'Imported Calendars : ',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ];
    for (Calendar calendar in calendars) {
      calendarsList.add(
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CalendarViewingPage(calendar: calendar)));
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).toggleableActiveColor),
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                child: Row(
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
                ))),
      );
    }
    return calendarsList;
  }
}
