import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_de_peluqueros/peluquero.dart';

// Clase para gestionar los servicios relacionados con los peluqueros
class PeluquerosServices extends ChangeNotifier {
  final String _baseURL = 'fl-peluqueria-a8930-default-rtdb.europe-west1.firebasedatabase.app';
  List<Peluquero> _peluqueros = []; // Lista de peluqueros
  String _searchValue = ''; // Campo para almacenar el valor de búsqueda
  bool _isLoading = false; // Indicador de carga

  // Getters para obtener la lista de peluqueros, el valor de búsqueda y el estado de carga
  List<Peluquero> get peluqueros => _peluqueros;
  String get searchValue => _searchValue;
  bool get isLoading => _isLoading;

  // Constructor para cargar automáticamente los peluqueros al inicializar el servicio
  PeluquerosServices() {
    loadPeluqueros();
  }

  // Método para cargar la lista de peluqueros desde la base de datos
  Future<void> loadPeluqueros() async {
    _isLoading = true; // Se inicia la carga
    notifyListeners(); // Notificar a los listeners que se inició la carga

    final url = Uri.https(_baseURL, 'peluqueros.json'); // URL de la base de datos
    final response = await http.get(url); // Petición HTTP para obtener los datos

    if (response.statusCode == 200) {
      final Map<String, dynamic> peluquerosMap = json.decode(response.body); // Decodificar la respuesta JSON
      _peluqueros.clear(); // Limpiar la lista antes de cargar nuevos peluqueros
      peluquerosMap.forEach((key, value) {
        final peluquero = Peluquero.fromMap(value); // Crear un objeto Peluquero a partir de los datos
        peluquero.id = key; // Asignar el ID del peluquero
        _peluqueros.add(peluquero); // Agregar el peluquero a la lista
      });
      _isLoading = false; // Se finaliza la carga
      notifyListeners(); // Notificar a los listeners que se completó la carga
    } else {
      print('Error al cargar los peluqueros. Código de estado: ${response.statusCode}');
      throw Exception('Error al cargar los peluqueros'); // Lanzar una excepción en caso de error
    }
  }

  // Método para actualizar la información de un peluquero en la base de datos
  Future<String?> updatePeluquero(Peluquero newPeluquero) async {
    final index = _peluqueros.indexWhere((peluquero) => peluquero.id == newPeluquero.id);
    if (index != -1) {
      _peluqueros[index] = newPeluquero; // Actualizar la información del peluquero en la lista local
      notifyListeners(); // Notificar a los listeners que se actualizó la lista de peluqueros
    }
    return newPeluquero.id; // Devolver el ID del peluquero actualizado
  }

  // Método para agregar un nuevo peluquero a la base de datos
  Future<String?> addPeluquero(Peluquero peluquero) async {
    final url = Uri.https(_baseURL, 'peluqueros/${peluquero.id}.json'); // URL para agregar el nuevo peluquero
    final response = await http.put(url, body: json.encode(peluquero.toMap())); // Petición HTTP para agregar el peluquero

    if (response.statusCode == 200) {
      print('Nuevo peluquero añadido con ID: ${peluquero.id}');
      return peluquero.id; // Devolver el ID del nuevo peluquero
    } else {
      print('Error al añadir el nuevo peluquero. Código de estado: ${response.statusCode}');
      throw Exception('Error al añadir el nuevo peluquero'); // Lanzar una excepción en caso de error
    }
  }

  // Método para actualizar el valor de búsqueda
  void updateSearchValue(String value) {
    _searchValue = value;
    notifyListeners(); // Notificar a los listeners que se actualizó el valor de búsqueda
  }
}
