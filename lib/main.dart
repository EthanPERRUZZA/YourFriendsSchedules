import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:provider/provider.dart';
import 'package:your_friends_schedules/provider/event_provider.dart';
import 'widget/calendar_widget.dart';
import 'page/event_editing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String title = 'Your Friends Schedules';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData.dark(),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(MyApp.title),
        centerTitle: true,
        actions: buildMenu(),
      ),
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const EventEditingPage())),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<Widget> buildMenu() => [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(child: Text('Other Calendars')),
          ],
          icon: const Icon(Icons.more_vert),
        )
      ];
}
