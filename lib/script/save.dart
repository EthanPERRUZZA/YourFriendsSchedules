import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_friends_schedules/model/calendar.dart';
import 'package:your_friends_schedules/provider/event_provider.dart';
import 'package:your_friends_schedules/script/get_calendar.dart';
import 'package:your_friends_schedules/model/event.dart';

class Save {
  static saveICSCalendars(EventProvider eventProvider) async {
    // get the directory where we can store the save infos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var json = {};
    for (Calendar calendar in eventProvider.calendars) {
      json[calendar.title] = {
        'link': calendar.link,
        'backgroundColor': calendar.backgroundColor.value.toString()
      };
    }
    String jsonString = jsonEncode(json);
    File saveFile = File('${appDocDir.path}/calendarICSLinks.json');
    saveFile.writeAsString(jsonString);
  }

  static savePersonalEvents(List<Event> events) async {
    // get the directory where we can store the save infos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var json = {};
    for (Event event in events) {
      json[event.title] = {
        'from': event.from.toString(),
        'to': event.to.toString(),
        'description': event.description,
        'backgroundColor': event.backgroundColor.value.toString()
      };
    }
    String jsonString = jsonEncode(json);
    File saveFile = File('${appDocDir.path}/myCalendar.json');
    saveFile.writeAsString(jsonString);
  }

  //called once on the creation of the EventProvider
  //(loads already know calendars)
  static loadICSCalendars(EventProvider eventProvider) async {
    // get the directory where we can store the save infos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //load of the file
    String jsonString;
    //In case the file wasn't created yet, has been compromised or deleted
    try {
      jsonString =
          await File('${appDocDir.path}/calendarICSLinks.json').readAsString();
    } catch (e) {
      //Then we don't load anything
      return;
    }
    Map json = jsonDecode(jsonString);
    json.forEach((key, value) {
      eventProvider.addCalendar(Calendar(
          title: key,
          link: value["link"],
          backgroundColor: Color(int.parse(value["backgroundColor"]))));
    });
    GetCalendar.refreshCalendars(eventProvider);
  }

  static loadPersonalEvents(EventProvider eventProvider) async {
    // get the directory where we can store the save infos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //load of the file
    String jsonString;
    //In case the file wasn't created yet, has been compromised or deleted
    try {
      jsonString =
          await File('${appDocDir.path}/myCalendar.json').readAsString();
    } catch (e) {
      //Then we don't load anything
      return;
    }
    Map json = jsonDecode(jsonString);
    json.forEach((key, value) {
      eventProvider.addEvent(Event(
          title: key,
          from: DateTime.parse(value["from"]),
          to: DateTime.parse(value["to"]),
          description: value["description"],
          backgroundColor: Color(int.parse(value["backgroundColor"]))));
    });
  }

  static deleteICSCalendarsSaveFile() async {
    // get the directory where we can store the save infos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocDir.path}/calendarICSLinks.json');
    await file.delete();
  }

  static deletePersonalEventSaveFile() async {
    // get the directory where we can store the save infos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocDir.path}/myCalendar.json');
    await file.delete();
  }
}
