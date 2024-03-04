import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_proyecto_peluqueria/providers/providers.dart';
import 'package:fl_proyecto_peluqueria/screens/login_screen.dart';
import 'package:fl_proyecto_peluqueria/screens/peluqueros_list_screen.dart';
import 'package:fl_proyecto_peluqueria/pojos/usuario.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PELUQUERÍA BARBER\'S',
          style: TextStyle(color: Colors.white),
        ),
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
            parametros["user"]?.rol == "Gestor"
                ? ListTile(
                    title: Text('Calendario'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'calendario');
                    },
                  )
                : SizedBox(height: 0),
            ListTile(
              title: Text('Enviar WhatsApp'),
              onTap: () {
                _launchWhatsApp2('+34643269989');
              },
            ),
            ListTile(
              title: Text('Gestión de peluqueros'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'peluqueros');
              },
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Contenido Principal',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  void _launchWhatsApp2(String phoneNumber) async {
    final whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }
}
