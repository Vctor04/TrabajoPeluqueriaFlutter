import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_proyecto_peluqueria/event/event.dart';
import 'package:fl_proyecto_peluqueria/event/event_creation_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime today = DateTime.now();
  List<Event> events = []; // Lista para almacenar los eventos
  List<String> availableHours = [
    '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30', '12:45', '13:00', '13:15', '13:30', '13:45', '16:00', '16:15', '16:30', '16:45', '17:00', '17:15', '17:30', '17:45', '18:00', '18:15', '18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00', '20:15', '20:30', '20:45', '21:00'
  ];
  String currentHour = '00:00';

  void addEvent() async {
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

  void _onDaySelected(DateTime day, DateTime focusedDay) {
  setState(() {
    today = day;

    // Determina el día de la semana
    int dayOfWeek = day.weekday;
    String dayName = '';

    // Asigna el nombre del día correspondiente
    switch (dayOfWeek) {
      case 1:
        dayName = 'Lunes';
        break;
      case 2:
        dayName = 'Martes';
        break;
      case 3:
        dayName = 'Miércoles';
        break;
      case 4:
        dayName = 'Jueves';
        break;
      case 5:
        dayName = 'Viernes';
        break;
      case 6:
        dayName = 'Sábado';
        break;
      case 7:
        dayName = 'Domingo';
        break;
      default:
        dayName = 'Desconocido';
        break;
    }
    
    // Reinicia las horas disponibles basadas en el día seleccionado
    if (dayOfWeek == 6 || dayOfWeek == 7) { // Si es sábado o domingo
      availableHours.clear();
    } else {
      availableHours = [
        '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30', '12:45', '13:00', '13:15', '13:30', '13:45', '14:00', '14:15', '14:30', '14:45', '15:00', '15:15', '15:30', '15:45', '16:00', '16:15', '16:30', '16:45', '17:00', '17:15', '17:30', '17:45', '18:00', '18:15', '18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00', '20:15', '20:30', '20:45'
      ];
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                'Opciones',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Calendario'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'calendario');
              },
            ),
            ListTile(
              title: Text('Enviar WhatsApp'),
              onTap: () {
                _launchWhatsApp2('+34643269989');
              },
            ),
            ListTile(
              title: Text('Gestión de peluqueros'),
              onTap: () {
                Navigator.pushReplacementNamed(context , 'peluqueros');
              },
            ),
            ListTile(
              title: Text('Ir a prueba'),
              onTap: () {
                Navigator.pushReplacementNamed(context , 'prueba');
              },
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context , 'login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Selected Day = " + today.toString().split(" ")[0]),
            const SizedBox(height: 20), // Agregué un SizedBox para separar los elementos
            Expanded(
              child: Column(
                children: [
                  Container(
                    child: TableCalendar(
                      locale: "en_US",
                      rowHeight: 43,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
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
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Number of columns
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemCount: availableHours.length,
                      itemBuilder: (context, index) {
                        final hour = availableHours[index];
                        return GestureDetector(
                          onTap: () {
                            // Handle button click (e.g., show a message or update reservation state)
                            print('Clicked on $hour');
                            setState(() {
                              currentHour = hour;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: currentHour == hour ? Color.fromARGB(255, 28, 28, 28) : Color.fromARGB(255, 68, 68, 68),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              hour,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addEvent, // Llama al método para agregar un evento
        child: const Icon(Icons.add, color: Colors.white,), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _launchWhatsApp2(String phoneNumber) async {
    final whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }
}

class MyScreen extends StatelessWidget {
  final List<String> availableHours = [
    '10:00', '10:15', '10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30', '12:45', '13:00', '13:15', '13:30', '13:45', '16:00', '16:15', '16:30', '16:45', '17:00', '17:15', '17:30', '17:45', '18:00', '18:15', '18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00', '20:15', '20:30', '20:45', '21:00'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva de Horas')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Number of columns
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: availableHours.length,
        itemBuilder: (context, index) {
          final hour = availableHours[index];
          return GestureDetector(
            onTap: () {
              // Handle button click (e.g., show a message or update reservation state)
              _MyCalendarState cal = _MyCalendarState();
              cal.addEvent();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: Text(
                hour,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle "reservar" button click
          _MyCalendarState cal = _MyCalendarState();
          cal.addEvent();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
