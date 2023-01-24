import 'package:flutter/cupertino.dart';
import 'package:your_friends_schedules/model/event.dart';
import 'package:your_friends_schedules/model/calendar.dart';
import 'package:your_friends_schedules/script/get_calendar.dart';
import 'package:your_friends_schedules/script/save.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];
  final List<Calendar> _calendars = [];

  List<Event> get events => _events;
  List<Calendar> get calendars => _calendars;

  //For searching efficency purpose
  final Map<String, List<Event>> _eventsBook = {};

  EventProvider() {
    Save.loadICSCalendars(this);
    Save.loadPersonalEvents(this);
  }

  void addEvent(Event event) {
    //Checks if the event is not already in the calendar (to prevent duplicate)
    if (!(_eventsBook.containsKey(event.fromXCalendar))) {
      _eventsBook[event.fromXCalendar] = [];
    } else if (_eventsBook[event.fromXCalendar]!.contains(event)) {
      return;
    }
    //If not then we add it and display it
    _eventsBook[event.fromXCalendar]!.add(event);

    if (event.fromXCalendar == "__local_events") {
      Save.savePersonalEvents(_eventsBook["__local_events"]!);
    }

    _events.add(event);

    notifyListeners();
  }

  void addCalendar(Calendar calendar) {
    _calendars.add(calendar);
    notifyListeners();

    //Loads the event from the new calendar
    GetCalendar.fromInternetICS(this, calendar);
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;

    notifyListeners();
  }

  void editCalendar(Calendar newCalendar, Calendar oldCalendar) {
    final index = _calendars.indexOf(oldCalendar);
    _calendars[index] = newCalendar;

    if (_eventsBook[oldCalendar.title] == null) {
      addCalendar(newCalendar);
      _calendars.removeAt(index);
      return;
    }

    _eventsBook[newCalendar.title] = _eventsBook[oldCalendar.title]!;
    if (newCalendar.title != oldCalendar.title) {
      _eventsBook.remove(oldCalendar.title);
    }

    if (newCalendar.link != oldCalendar.link) {
      //If links have changed then got to change everything
      _calendars.removeAt(index);
      deleteCalendar(oldCalendar);
      addCalendar(newCalendar);
    } else {
      //Then only a change color or calendar name
      //Update all of this Calendar events
      int nbEventModified = 0;
      //When all the events have been modified we don't need to search for other
      //event from this calendar so we stop the loop
      for (int i = 0;
          i < _events.length &&
              nbEventModified < _eventsBook[newCalendar.title]!.length;
          i++) {
        if (_events[i].fromXCalendar == oldCalendar.title) {
          _events[i] = Event(
              title: _events[i].title,
              description: _events[i].description,
              from: _events[i].from,
              to: _events[i].to,
              backgroundColor: newCalendar.backgroundColor,
              fromXCalendar: newCalendar.title);
          nbEventModified++;
        }
      }
    }

    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    _eventsBook[event.fromXCalendar]!.remove(event);

    //If we are removing an event from the user's saved events
    if (event.fromXCalendar == "__local_events") {
      if (_eventsBook["__local_events"]!.isEmpty) {
        //Delete the save file
        Save.deletePersonalEventSaveFile();
      } else {
        //rewrite the save file
        Save.savePersonalEvents(_eventsBook["__local_events"]!);
      }
    }

    notifyListeners();
  }

  void deleteCalendar(Calendar calendar) {
    _calendars.remove(calendar);

    //Delete all of this Calendar events
    int nbEventModified = 0;
    //When all the events have been deleted we don't need to search for others
    int i = 0;
    while (i < _events.length &&
        nbEventModified < _eventsBook[calendar.title]!.length) {
      if (_events[i] == _eventsBook[calendar.title]![nbEventModified]) {
        _events.removeAt(i);
        nbEventModified++; //new event deleted
        //cause event has been deleted need to stay on same index
      } else {
        i++; //next event
      }
    }

    _eventsBook.remove(calendar.title);

    //Deleting from the save file
    if (_calendars.isEmpty) {
      //Delete the save file
      Save.deleteICSCalendarsSaveFile();
    } else {
      Save.saveICSCalendars(this);
    }

    notifyListeners();
  }
}
