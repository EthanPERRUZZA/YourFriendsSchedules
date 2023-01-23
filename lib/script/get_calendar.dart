import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:your_friends_schedules/model/calendar.dart';
import 'package:your_friends_schedules/model/event.dart';
import '../provider/event_provider.dart';

class GetCalendar {
  static refreshCalendars(EventProvider eventProvider) async {
    for (Calendar calendar in eventProvider.calendars) {
      fromInternetICS(eventProvider, calendar);
    }
  }

  static fromInternetICS(EventProvider eventProvider, Calendar calendar) async {
    //request to the internet
    final response = await http.get(Uri.parse(calendar.link));
    //load the response in a list of strings
    //use this method to prevent problem if use \r\n or just \n
    Iterable<String> icsLines = LineSplitter.split(response.body);

    //parse of the response
    //And add each new event to the actual calendar display
    //fields availiable
    String title = "";
    String description = "None";
    DateTime from = DateTime(0, 0, 0, 0, 0);
    DateTime to = DateTime(0, 0, 0, 0, 0);
    for (String line in icsLines) {
      //if it is the end of an event, we add him
      if (line == "END:VEVENT") {
        eventProvider.addEvent(Event(
          title: title,
          description: description,
          from: from,
          to: to,
          backgroundColor: calendar.backgroundColor,
          fromXCalendar: calendar.title,
        ));
        //Restoration of the fields
        title = "";
        description = "None";
        from = DateTime(0, 0, 0, 0, 0);
        to = DateTime(0, 0, 0, 0, 0);
      }
      //Get the field name
      int index = line.indexOf(':');
      // if it was found
      if (index > 0) {
        String field = line.substring(0, index);
        //Search if field name is relevant and store it if needed
        switch (field) {
          case 'DESCRIPTION':
            description = line.substring(index + 1);
            break;
          case 'DTSTART':
            from = DateTime.parse(line.substring(index + 1)).toLocal();
            break;
          case 'DTEND':
            to = DateTime.parse(line.substring(index + 1)).toLocal();
            break;
          case 'LOCATION':
            description += '\n\nLocation : ${line.substring(index + 1)}';
            break;
          case 'SUMMARY':
            title = line.substring(index + 1);
            break;
        }
      }
    }
  }
}
