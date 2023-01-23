import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../model/event.dart';
import '../utils.dart';
import '../provider/event_provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
      backgroundColor = event.backgroundColor;
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
              buildDateTimePickers(),
              const SizedBox(height: 25),
              buildColorPickerField(),
            ],
          ),
        ),
      ));

  Widget buildColorPickerField() => Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              "Event Color:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => pickColor(context),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                ),
                width: 40,
                height: 40,
              ),
            ),
          )
        ],
      );

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Pick Your Color"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildColorPicker(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('SELECT', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ));

  Widget buildColorPicker() => BlockPicker(
      pickerColor: backgroundColor,
      availableColors: const [
        Colors.red,
        Colors.pink,
        Colors.purple,
        Colors.deepPurple,
        Colors.indigo,
        Colors.blue,
        Colors.lightBlue,
        Colors.cyan,
        Colors.teal,
        Colors.green,
        Colors.lightGreen,
        Colors.lime,
        Colors.yellow,
        Colors.amber,
        Colors.orange,
        Colors.deepOrange,
        Colors.brown,
        Colors.grey,
        Colors.blueGrey,
        Colors.black,
      ],
      onColorChanged: (newColor) => setState(() => backgroundColor = newColor));

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
    setState(() {
      //If from date is after todate then we change the to date
      if (date.isBefore(fromDate)) {
        toDate = DateTime(
            date.year, date.month, date.day + 1, date.hour, date.minute);
      } else {
        toDate = date;
      }
    });
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
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
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
      final event = Event(
        title: titleController.text,
        description: 'None',
        from: fromDate,
        to: toDate,
        isAllDay: false,
        backgroundColor: backgroundColor,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);
      } else {
        provider.addEvent(event);
      }

      Navigator.of(context).pop();
    }
  }
}
