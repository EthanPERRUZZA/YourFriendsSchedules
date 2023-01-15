import 'package:flutter/material.dart';
import '../widget/calendars_list.dart';
import '../page/calendar_editing_page.dart';

class CalendarManagerPage extends StatelessWidget {
  const CalendarManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: const CloseButton()),
        body: CalendarsListWidget(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: ((context) => const CalendarEditingPage())),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
}
