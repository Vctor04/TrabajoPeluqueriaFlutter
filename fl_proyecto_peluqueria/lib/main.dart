import 'package:fl_proyecto_peluqueria/screens/home_screen.dart';
import 'package:fl_proyecto_peluqueria/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_proyecto_peluqueria/screens/login_screen.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peluqueria App',
      initialRoute: 'login',
      routes: {
        'login': ( _ ) => LoginScreen(),
        'home': ( _ ) => HomeScreen(),
        'register': ( _ ) => RegisterScreen()
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: const Color.fromARGB(115, 0, 0, 0)
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          backgroundColor: const Color.fromARGB(221, 0, 0, 0)
        )
      ),
    );
  }
}
/*
class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductosServices())
      ],
      child: MyApp(),
    );
  }
}*/