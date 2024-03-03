import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:gestion_de_peluqueros/usuarios_services.dart';
import 'package:gestion_de_peluqueros/peluqueros_services.dart';

// Clase para mostrar una barra de búsqueda dinámica
class MySearchBar extends StatefulWidget implements PreferredSizeWidget {
  const MySearchBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Estado de la barra de búsqueda
class _SearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsuariosServices>(
      builder: (context, usuariosServices, _) {
        // Obtener el valor de showAllUsers del servicio de usuarios
        bool showAllUsers = usuariosServices.showAllUsers;

        return EasySearchBar(
          title: const Text('Gestión de peluqueros'), // Título de la barra de búsqueda
          backgroundColor: const Color.fromARGB(255, 190, 190, 190), // Color de fondo de la barra de búsqueda
          onSearch: (value) {
            if (showAllUsers) {
              // Actualizar el valor de búsqueda en el servicio de usuarios
              usuariosServices.updateSearchValue(value);
            } else {
              // Actualizar el valor de búsqueda en el servicio de peluqueros
              Provider.of<PeluquerosServices>(context, listen: false).updateSearchValue(value);
            }
          },
          asyncSuggestions: (value) async {
            if (showAllUsers) {
              final usuariosServices = Provider.of<UsuariosServices>(context, listen: false);
              // Obtener sugerencias de nombres de usuarios para la búsqueda
              final suggestions = usuariosServices.usuarios
                  .where((usuario) =>
                      usuario.nombre.toLowerCase().contains(value.toLowerCase()) ||
                      usuario.email.toLowerCase().contains(value.toLowerCase()) ||
                      usuario.telefono.contains(value))
                  .map((usuario) => usuario.nombre)
                  .toList();
              return suggestions;
            } else {
              final peluquerosServices = Provider.of<PeluquerosServices>(context, listen: false);
              // Obtener sugerencias de nombres de peluqueros para la búsqueda
              final suggestions = peluquerosServices.peluqueros
                  .where((peluquero) =>
                      peluquero.nombre.toLowerCase().contains(value.toLowerCase()) ||
                      peluquero.email.toLowerCase().contains(value.toLowerCase()) ||
                      peluquero.telefono.contains(value))
                  .map((peluquero) => peluquero.nombre)
                  .toList();
              return suggestions;
            }
          },
          actions: [
            // Switch para alternar entre mostrar todos los usuarios o solo peluqueros
            Switch(
              value: showAllUsers,
              onChanged: (newValue) {
                setState(() {
                  // Cambiar el valor de showAllUsers del servicio de usuarios
                  usuariosServices.setShowAllUsers(newValue);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
