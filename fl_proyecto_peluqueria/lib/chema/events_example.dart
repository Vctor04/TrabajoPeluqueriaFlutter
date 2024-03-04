import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_proyecto_peluqueria/chema/reserva.dart';
import 'package:fl_proyecto_peluqueria/chema/reservas_services.dart';
import 'package:fl_proyecto_peluqueria/chema/utils.dart';


void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableCalendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario Citas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Events'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableEventsExample()),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Map<DateTime, List<Event>> _eventsMap = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    loadReservas();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> loadReservas() async {
    final reservas = await ReservasServices().loadReservas();

    final Map<DateTime, List<Event>> eventsMap = {};
    for (var reserva in reservas) {
      final fecha = DateTime(reserva.fecha.year, reserva.fecha.month, reserva.fecha.day);
      eventsMap.putIfAbsent(fecha, () => []);
      eventsMap[fecha]!.add(Event("Reserva", reserva.fecha, reserva));
    }

    setState(() {
      _eventsMap = eventsMap;
      _selectedEvents.value = reservas.map((reserva) => Event("Reserva", reserva.fecha, reserva)).toList();
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    final fecha = DateTime(day.year, day.month, day.day);
    return _eventsMap[fecha] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
      _focusedDay = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    // Verificar si hay eventos para el día seleccionado
    bool eventsFound = false;
    _eventsMap.forEach((key, value) {
      if (key.year == _selectedDay!.year &&
          key.month == _selectedDay!.month &&
          key.day == _selectedDay!.day) {
        eventsFound = true;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Citas para el ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: value.map((event) {
                return ListTile(
                  title: Text('Cita'),
                  subtitle: Text('${event.date.hour}:${event.date.minute} - ${event.reserva?.peluquero ?? ''}'),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    });

    if (!eventsFound) {
      // Mostrar un mensaje indicando que no hay citas para este día
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('No hay citas para el ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario Citas - Reservas'),
        backgroundColor: Colors.grey[300], // Añade el color gris al fondo del AppBar
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          if (_selectedDay != null && _eventsMap[_selectedDay!] != null && _eventsMap[_selectedDay!]!.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                // Este botón no parece tener funcionalidad en la lógica actual
                print('Mostrar información de reserva');
              },
              child: Text('Reservar'),
            ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final DateTime date;
  final Reserva? reserva;

  Event(this.title, this.date, this.reserva);
}
