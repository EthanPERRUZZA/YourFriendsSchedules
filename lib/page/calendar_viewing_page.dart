import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_friends_schedules/model/calendar.dart';
import 'package:your_friends_schedules/page/calendar_editing_page.dart';
import 'package:your_friends_schedules/provider/event_provider.dart';

class CalendarViewingPage extends StatelessWidget {
  final Calendar calendar;

  const CalendarViewingPage({
    Key? key,
    required this.calendar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          actions: buildViewingActions(context, calendar),
        ),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Text(
              calendar.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              calendar.link,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      );

  //The littles icons on the top (on for editing event, other to delete event)
  List<Widget> buildViewingActions(BuildContext context, Calendar calendar) => [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => CalendarEditingPage(calendar: calendar)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context, listen: false);

            provider.deleteCalendar(calendar);
            Navigator.of(context).pop();
          },
        ),
      ];
}
