import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../model/calendar.dart';
import '../utils.dart';
import '../provider/event_provider.dart';

class CalendarEditingPage extends StatefulWidget {
  final Calendar? calendar;

  const CalendarEditingPage({
    Key? key,
    this.calendar,
  }) : super(key: key);

  @override
  _CalendarEditingPageState createState() => _CalendarEditingPageState();
}

class _CalendarEditingPageState extends State<CalendarEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final linkController = TextEditingController();
  Color backgroundColor = Colors.lightBlue;

  @override
  void initState() {
    super.initState();

    //if we clicked on an already defined calendar (not new)
    if (widget.calendar != null) {
      final calendar = widget.calendar!;

      titleController.text = calendar.title;
      linkController.text = calendar.link;
      backgroundColor = calendar.backgroundColor;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();

    super.dispose();
  }

  //Look of the page to add a calendar
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              const SizedBox(height: 12),
              buildLink(),
              //const SizedBox(height: 12),
              //buildColorPicker(),
            ],
          ),
        ),
      ));

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          icon: const Icon(Icons.done),
          label: const Text('SAVE'),
        ),
      ];

  //Field to type the title of the event
  Widget buildTitle() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add Title',
        ),
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
      );

  //Field to type the title of the event
  Widget buildLink() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add an ICS Calendar Link',
        ),
        onFieldSubmitted: (_) {},
        validator: (link) =>
            link != null && link.isEmpty ? 'Link cannot be empty' : null,
        controller: linkController,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: const TextStyle(fontWeight: FontWeight.bold)),
          child
        ],
      );

  //Save the form's infos
  Future saveForm() async {
    //Check if valid (title not empty)
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final calendar = Calendar(
        title: titleController.text,
        link: linkController.text,
        backgroundColor: backgroundColor,
      );

      final isEditing = widget.calendar != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editCalendar(calendar, widget.calendar!);
      } else {
        provider.addCalendar(calendar);
      }

      Navigator.of(context).pop();
    }
  }
}
