import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_friends_schedules/model/calendar.dart';
import 'package:your_friends_schedules/provider/event_provider.dart';
import 'package:your_friends_schedules/script/get_calendar.dart';

class Save {
  static saveICSCalendars(BuildContext context) async {
    // get the directory where we can store the save infos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    // get the provider where all calendars are stored
    final provider = Provider.of<EventProvider>(context, listen: false);
    var json = {};
    provider.calendars.forEach((calendar) => json[calendar.title] = {
          'link': calendar.link //,
          //'backgroundColor': calendar.backgroundColor
        });
    String jsonString = jsonEncode(json);
    File saveFile = File('${appDocDir.path}/calendarICSLinks.json');
    saveFile.writeAsString(jsonString);
  }

  //called once on the creation of the EventProvider
  //(loads already know calendars)
  static loadICSCalendars(EventProvider eventProvider) async {
    // get the directory where we can store the save infos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //load of the file
    String jsonString =
        await File('${appDocDir.path}/calendarICSLinks.json').readAsString();
    Map json = jsonDecode(jsonString);
    json.forEach((key, value) {
      eventProvider.addCalendar(Calendar(
          title: key, link: value["link"], backgroundColor: Colors.lightBlue));
      //,backgroundColor: value["backgroundColor"]
    });
    GetCalendar.refreshCalendars(eventProvider);
  }
}
