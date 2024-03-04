import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_proyecto_peluqueria/pojos/usuario.dart';
import 'package:fl_proyecto_peluqueria/pojos/peluquero.dart';
import 'package:fl_proyecto_peluqueria/widgets/search_bar.dart';
import 'package:fl_proyecto_peluqueria/services/usuarios_services.dart';
import 'package:fl_proyecto_peluqueria/services/peluqueros_services.dart';
import 'package:fl_proyecto_peluqueria/screens/peluquero_detail_screen.dart';

class UsuariosServicesProvider extends InheritedWidget {
  final UsuariosServices usuariosServices;

  UsuariosServicesProvider({
    Key? key,
    required this.usuariosServices,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(UsuariosServicesProvider oldWidget) =>
      usuariosServices != oldWidget.usuariosServices;

  static UsuariosServicesProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UsuariosServicesProvider>();
}
// Clase para mostrar una lista dinámica de usuarios o peluqueros
class PeluquerosListScreen extends StatefulWidget {
  @override
  _PeluquerosListState createState() => _PeluquerosListState();
}

// Estado de la lista de usuarios o peluqueros
class _PeluquerosListState extends State<PeluquerosListScreen> {
  @override
  Widget build(BuildContext context) {
    // Utiliza el parámetro usuariosServices pasado al Consumer en lugar de obtenerlo de UsuariosServicesProvider.of(context)
    return Consumer<UsuariosServices>(
      builder: (context, usuariosServices, _) {
        // Obtener el valor de showAllUsers del servicio de usuarios
        bool showAllUsers = usuariosServices.showAllUsers;

        return Scaffold(
          appBar: MySearchBar(),
          body: showAllUsers
              ? _buildUsuariosList(context, usuariosServices)
              : _buildPeluquerosList(context),
        );
      },
    );
  }

  // Construir la lista de usuarios
  Widget _buildUsuariosList(BuildContext context, UsuariosServices usuariosServices) {
    final searchValue = usuariosServices.searchValue.toLowerCase();
    final usuarios = usuariosServices.usuarios.where((usuario) =>
        usuario.nombre.toLowerCase().contains(searchValue) ||
        usuario.email.toLowerCase().contains(searchValue) ||
        usuario.telefono.contains(searchValue)).toList();

    return usuariosServices.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final Usuario usuario = usuarios[index];
              return ListTile(
                leading: const Icon(Icons.person), // Icono de persona a la izquierda
                title: Text(usuario.nombre), // Nombre del usuario
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(usuario.email), // Email del usuario
                    Text(usuario.telefono), // Teléfono del usuario
                    Text(usuario.rol) // Rol del usuario
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.build),
                  onPressed: () {
                    // Cambiar el rol del usuario a peluquero
                    usuariosServices.modificarRolUsuario(usuario.id!, 'Peluquero', context).then((_) {
                      // Actualizar la lista después de cambiar el rol
                      setState(() {}); // Aquí se actualiza el estado de la lista de usuarios
                    }).catchError((error) {
                      // Manejar el error si ocurre
                      print('Error al cambiar el rol del usuario: $error');
                    });
                  },
                ),
              );
            },
          );
  }

  // Construir la lista de peluqueros
  Widget _buildPeluquerosList(BuildContext context) {
    final peluquerosServices = Provider.of<PeluquerosServices>(context);
    final searchValue = peluquerosServices.searchValue.toLowerCase();
    final peluqueros = peluquerosServices.peluqueros.where((peluquero) =>
        peluquero.nombre.toLowerCase().contains(searchValue) ||
        peluquero.email.toLowerCase().contains(searchValue) ||
        peluquero.telefono.contains(searchValue)).toList();

    return peluquerosServices.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: peluqueros.length,
            itemBuilder: (context, index) {
              final Peluquero peluquero = peluqueros[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PeluqueroDetailScreen(peluquero: peluquero),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.person), // Icono de persona a la izquierda
                  title: Text(peluquero.nombre), // Nombre del peluquero
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(peluquero.email), // Email del peluquero
                      Text(peluquero.telefono), // Teléfono del peluquero
                    ],
                  ),
                ),
              );
            },
          );
  }
}