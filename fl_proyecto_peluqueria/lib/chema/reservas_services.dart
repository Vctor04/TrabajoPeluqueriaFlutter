import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_proyecto_peluqueria/chema/reserva.dart';

class ReservasServices extends ChangeNotifier {
  final String _baseURL = 'fl-peluqueria-a8930-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Reserva> reservas = [];
  String _searchValue = '';
  String get searchValue => _searchValue;
  bool isLoading = true;

  ReservasServices() {
    loadReservas();
  }

  Future<List<Reserva>> loadReservas() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'reservas.json');
    final resp = await http.get(url);

    final Map<String, dynamic> reservasMap = json.decode(resp.body);
    reservasMap.forEach((key, value) {
      final peluquero = Reserva.fromMap(value);
      peluquero.id = key;
      reservas.add(peluquero);
      peluquero.fecha;
    });

    isLoading = false;
    notifyListeners();

    return reservas;
  }

  Future<String?> updateReserva(Reserva reserva) async {
    final url = Uri.https(_baseURL, 'reservas/${reserva.id}.json');
    final resp = await http.put(url, body: json.encode(reserva.toJson()));
    if (resp.statusCode == 200) {
      print('Reserva actualizada con éxito en la base de datos');
    } else {
      print('Error al actualizar la reserva en la base de datos. Código de estado: ${resp.statusCode}');
      throw Exception('Error al actualizar la reserva en la base de datos');
    }
    return reserva.id;
  }

  void updateSearchValue(String value) {
    _searchValue = value;
    notifyListeners();
  }
}
