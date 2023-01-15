import 'package:flutter/material.dart';
import '../widget/calendars_list.dart';

class CalendarManagerPage extends StatelessWidget {
  const CalendarManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: const CloseButton()),
        body: CalendarsListWidget(),
      );
}
