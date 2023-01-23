import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_friends_schedules/model/event.dart';
import 'package:your_friends_schedules/page/event_editing_page.dart';
import 'package:your_friends_schedules/provider/event_provider.dart';
import 'package:your_friends_schedules/utils.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          actions: buildViewingActions(context, event),
        ),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
            const SizedBox(height: 32),
            Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              event.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            buildColorView(),
          ],
        ),
      );

  Widget buildColorView() => Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              "Event Color:",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: event.backgroundColor,
              ),
              width: 40,
              height: 40,
            ),
          ),
        ],
      );

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        if (!event.isAllDay) buildDate('To', event.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(title),
        ),
        Expanded(
          child: Text(Utils.toDateTime(date)),
        ),
      ],
    );
  }

  //The littles icons on the top (on for editing event, other to delete event)
  List<Widget> buildViewingActions(BuildContext context, Event event) => [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => EventEditingPage(event: event)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context, listen: false);

            provider.deleteEvent(event);
            Navigator.of(context).pop();
          },
        ),
      ];
}
