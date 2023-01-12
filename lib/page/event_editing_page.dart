import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../model/event.dart';
import '../utils.dart';
import '../provider/event_provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event = null;

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  //Look of the page to add an event
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              SizedBox(height: 12),
              buildDateTimePickers(),
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
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add Title',
        ),
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
      );

  //Dates Selector
  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(), //Build the from selector
          buildTo(), //Build the from selectot
        ],
      );

  Widget buildFrom() => buildHeader(
      header: 'FROM',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(fromDate),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropDownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          )
        ],
      ));

  Widget buildTo() => buildHeader(
      header: 'TO',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(toDate),
              onClicked: () => pickToDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropDownField(
              text: Utils.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            ),
          )
        ],
      ));

  Future pickFromDateTime({required bool pickDate}) async {
    //We get the new date
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    //If user didn't cancel
    if (date == null) return;

    //If from date is after todate then we change the to date
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    //Then, display the new date
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    //We get the new date
    final date = await pickDateTime(toDate,
        pickDate: pickDate,
        //makes impossible to chose a date before the fromDate
        firstDate: pickDate ? fromDate : null);

    //If user didn't cancel
    if (date == null) return;

    //Then, display the new date
    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2023),
          lastDate: DateTime(2500));

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
          child
        ],
      );

  //Save the form's infos
  Future saveForm() async {
    //Check if valid (title not empty)
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: 'None',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );

      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);

      Navigator.of(context).pop();
    }
  }
}
