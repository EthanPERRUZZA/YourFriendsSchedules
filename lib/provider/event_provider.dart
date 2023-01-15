import 'package:flutter/cupertino.dart';
import 'package:your_friends_schedules/model/event.dart';
import 'package:your_friends_schedules/model/calendar.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];
  final List<Calendar> _calendars = [];

  List<Event> get events => _events;
  List<Calendar> get calendars => _calendars;

  void addEvent(Event event) {
    _events.add(event);

    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;

    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);

    notifyListeners();
  }
}
