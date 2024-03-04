import 'package:flutter/material.dart';
import 'package:fl_proyecto_peluqueria/screens/calendar.dart';
import 'package:fl_proyecto_peluqueria/screens/home_screen.dart';
import 'package:fl_proyecto_peluqueria/providers/providers.dart';
import 'package:fl_proyecto_peluqueria/screens/login_screen.dart';
import 'package:provider/provider.dart'; // Importa tu provider aquí
import 'package:fl_proyecto_peluqueria/screens/register_screen.dart';
import 'package:fl_proyecto_peluqueria/screens/peluqueros_list_screen.dart';
import 'package:fl_proyecto_peluqueria/services/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PeluquerosServices(),
        child: PeluquerosListScreen(),
        ),
        ChangeNotifierProvider(create: (_) => RegisterFormProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Peluqueria App',
        initialRoute: 'login',
        routes: {
          'login': (_) => LoginScreen(),
          'home': (_) => HomeScreen(),
          'register': (_) => RegisterScreen(),
          'peluqueros': (_) => PeluquerosListScreen(),
          'calendario': (_) => MyCalendar(),
        },
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: const Color.fromARGB(115, 0, 0, 0),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            backgroundColor: const Color.fromARGB(221, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}