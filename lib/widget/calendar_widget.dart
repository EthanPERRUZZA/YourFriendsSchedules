import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../provider/event_provider.dart';
import '../model/event_data_source.dart';
import '../page/event_viewing_page.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Loads all the events already created
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
      view: CalendarView.day,
      dataSource: EventDataSource(events),
      timeSlotViewSettings: const TimeSlotViewSettings(timeFormat: 'HH:mm'),
      appointmentBuilder: appointmentBuilder, //the style of each event
      //To get more details on the event (onclick)
      onTap: (details) {
        if (details.appointments == null) return;

        final event = details.appointments!.first;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventViewingPage(event: event),
        ));
      },
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
          color: event.backgroundColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.all(3.0),
      child: Text(
        event.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
