import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:fl_proyecto_peluqueria/services/usuarios_services.dart';
import 'package:fl_proyecto_peluqueria/services/peluqueros_services.dart';


// Implementa PreferredSizedWidget para poder darle un tamaño especifico al widget y que pueda funcionar como AppBar
class MySearchBar extends StatefulWidget implements PreferredSizeWidget {
  const MySearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Estado de la barra de búsqueda
class _SearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    //Se utiliza Consumer para escuchar los cambios en la clase UsuariosServices
    return Consumer<UsuariosServices>(
      builder: (context, usuariosServices, _) {
        // Obtiene el valor de showAllUsers del servicio de usuarios, que es un booleano cuyo valor se cambia al presionar el switch
        bool showAllUsers = usuariosServices.showAllUsers;
        // Devuelve la barra de búsqueda
        return EasySearchBar(
          title: const Text('Gestión de peluqueros'), // Título de la barra de búsqueda
          backgroundColor: const Color.fromARGB(255, 190, 190, 190), // Color de fondo de la barra de búsqueda
          //Al buscar un nombre en la barra de búsqueda, lo actualiza en UsuariosServices o en PeluquerosServices dependiendo el valor de la variable showAllUsers.
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
