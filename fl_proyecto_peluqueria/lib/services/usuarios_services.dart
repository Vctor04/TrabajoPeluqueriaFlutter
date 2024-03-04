import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fl_proyecto_peluqueria/pojos/usuario.dart';
import 'package:fl_proyecto_peluqueria/pojos/peluquero.dart';
import 'package:fl_proyecto_peluqueria/services/peluqueros_services.dart';


// Clase para gestionar los servicios relacionados con los usuarios
class UsuariosServices extends ChangeNotifier {
  final String _baseURL = 'fl-peluqueria-a8930-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Usuario> usuarios = []; // Lista de usuarios
  String _searchValue = ''; // Campo para almacenar el valor de búsqueda
  String get searchValue => _searchValue; // Getter para obtener el valor de búsqueda
  bool isLoading = true; // Indicador de carga
  bool _showAllUsers = false; // Variable para determinar si se deben mostrar todos los usuarios o no
  
  bool get showAllUsers => _showAllUsers; // Getter para obtener el estado de showAllUsers

  // Constructor para cargar automáticamente los usuarios al inicializar el servicio
  UsuariosServices() {
    loadUsuarios();
  }

  // Método para cargar la lista de usuarios desde la base de datos
  Future<List<Usuario>> loadUsuarios() async {
    isLoading = true; // Se inicia la carga
    notifyListeners(); // Notificar a los listeners que se inició la carga
    
    final url = Uri.https(_baseURL, 'usuarios.json'); // URL de la base de datos
    final resp = await http.get(url); // Petición HTTP para obtener los datos

    final Map<String, dynamic> usuariosMap = json.decode(resp.body); // Decodificar la respuesta JSON
    usuariosMap.forEach((key, value) {
      final usuario = Usuario.fromMap(value); // Crear un objeto Usuario a partir de los datos
      usuario.id = key; // Asignar el ID del usuario
      usuarios.add(usuario); // Agregar el usuario a la lista
    });
   
    isLoading = false; // Se finaliza la carga
    notifyListeners(); // Notificar a los listeners que se completó la carga

    return usuarios; // Devolver la lista de usuarios cargada
  }
  
  // Método para modificar el rol de un usuario
  Future<void> modificarRolUsuario(String id, String nuevoRol, BuildContext context) async {
    try {
      final Usuario usuario = usuarios.firstWhere((usuario) => usuario.id == id); // Obtener el usuario por su ID
      usuario.rol = nuevoRol; // Actualizar el rol del usuario
      notifyListeners(); // Notificar a los listeners sobre el cambio de rol en UsuariosServices

      // Actualizar el rol del usuario en la tabla de usuarios en la base de datos
      final url = Uri.https(_baseURL, 'usuarios/${usuario.id}.json');
      final resp = await http.patch(url, body: json.encode({'rol': nuevoRol}));
      if (resp.statusCode == 200) {
        print('Rol de usuario actualizado con éxito en la base de datos');
      } else {
        print('Error al actualizar el rol de usuario en la base de datos. Código de estado: ${resp.statusCode}');
        throw Exception('Error al actualizar el rol de usuario en la base de datos');
      }

      if (nuevoRol == 'Peluquero') {
        String? dni; // Declaramos la variable dni fuera del diálogo

        // Mostrar un diálogo para ingresar el DNI del nuevo peluquero
        // ignore: use_build_context_synchronously
        dni = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ingrese el DNI del peluquero'),
              content: TextField(
                onChanged: (value) {
                  dni = value; // Actualizar el valor de dni cuando cambia el campo de texto
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, dni),
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );

        if (dni != null) {
          // Añadir el usuario a la lista de peluqueros en PeluquerosServices
          // ignore: use_build_context_synchronously
          final PeluquerosServices peluquerosServices = Provider.of<PeluquerosServices>(context, listen: false);
          final nuevoPeluquero = Peluquero(
            id: dni,
            nombre: usuario.nombre,
            email: usuario.email,
            telefono: usuario.telefono,
            dias: "de Lunes a Viernes",
            horario: "de 09:00 a 12:00 horas",
            vacaciones: 23,
          );
          await peluquerosServices.addPeluquero(nuevoPeluquero);
        } else {
          print('No se proporcionó un DNI para el peluquero.');
        }
      }
    } catch (error) {
      print('Error al modificar el rol del usuario: $error');
      throw Exception('Error al modificar el rol del usuario');
    }
  }

  // Método para actualizar el valor de búsqueda
  void updateSearchValue(String value) {
    _searchValue = value;
    notifyListeners(); // Notificar a los listeners sobre el cambio
  }

  // Método para cambiar el valor de showAllUsers
  void setShowAllUsers(bool value) {
    _showAllUsers = value;
    notifyListeners(); // Notificar a los listeners sobre el cambio
  }
}
