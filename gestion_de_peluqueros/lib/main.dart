import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_de_peluqueros/usuarios_services.dart';
import 'package:gestion_de_peluqueros/peluqueros_services.dart';
import 'package:gestion_de_peluqueros/peluqueros_list_screen.dart';
import 'package:gestion_de_peluqueros/search_bar.dart'; // Aquí cambia la importación

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PeluquerosServices()),
        ChangeNotifierProvider(create: (context) => UsuariosServices()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: const MySearchBar(), // Aquí utilizamos la clase SearchBar
          drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: const [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
            ]),
          ),
          body: PeluquerosListScreen(),
        ),
      ),
    );
  }
}
