import 'package:flutter/cupertino.dart';
import 'package:your_friends_schedules/model/event.dart';
import 'package:your_friends_schedules/model/calendar.dart';
import 'package:your_friends_schedules/script/save.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];
  final List<Calendar> _calendars = [];

  List<Event> get events => _events;
  List<Calendar> get calendars => _calendars;

  //For searching efficency purpose
  Map<String, List<Event>> _eventsBook = {};

  EventProvider() {
    Save.loadICSCalendars(this);
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

    _events.add(event);

    notifyListeners();
  }

  void addCalendar(Calendar calendar) {
    _calendars.add(calendar);

    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;

    notifyListeners();
  }

  void editCalendar(Calendar newCalendar, Calendar oldCalendar) {
    final index = _calendars.indexOf(oldCalendar);
    _calendars[index] = newCalendar;

    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);

    notifyListeners();
  }

  void deleteCalendar(Calendar calendar) {
    _calendars.remove(calendar);

    notifyListeners();
  }
}
