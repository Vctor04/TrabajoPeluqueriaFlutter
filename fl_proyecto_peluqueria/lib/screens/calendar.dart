import 'package:fl_proyecto_peluqueria/events/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_proyecto_peluqueria/events/event_creation_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime today = DateTime.now();
  List<Event> events = []; // Lista para almacenar los eventos

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void _addEvent() async {
    final Map<String, String?>? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventCreationPage()),
    );

    if (result != null && result['title'] != null && result['description'] != null) {
      setState(() {
        events.add(Event(
          title: result['title']!,
          date: today,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Selected Day = " + today.toString().split(" ")[0]),
            const SizedBox(height: 20), // Agregué un SizedBox para separar los elementos
            Container(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle:
                    HeaderStyle(formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                // Para poder seleccionar un día que no sea el día de hoy
                focusedDay: today, // Establecer el día enfocado en la fecha seleccionada
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                onDaySelected: _onDaySelected,
                eventLoader: (day) {
                  // Retorna una lista de eventos para un día específico
                  return events
                      .where((event) => isSameDay(event.date, day))
                      .map((event) => event.title)
                      .toList();
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(events[index].title),
                    subtitle: Text(events[index].date.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent, // Llama al método para agregar un evento
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
