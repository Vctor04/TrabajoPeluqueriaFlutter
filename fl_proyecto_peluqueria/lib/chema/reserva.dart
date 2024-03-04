import 'dart:convert';


class Reserva {
  String? id;
  bool cancelada;
  DateTime fecha;
  bool pagada;
  String pago;
  String peluquero;
  Map<String, bool> servicios;
  String usuario;

  Reserva({
    this.id,
    required this.cancelada,
    required this.fecha,
    required this.pagada,
    required this.pago,
    required this.peluquero,
    required this.servicios,
    required this.usuario,
  });

  factory Reserva.fromJson(String str) => Reserva.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Reserva.fromMap(Map<String, dynamic> json) => Reserva(
        cancelada: json["cancelada"],
        fecha: DateTime.parse(json["fecha"]),
        pagada: json["pagada"],
        pago: json["pago"],
        peluquero: json["peluquero"],
        servicios: Map.from(json["servicios"]).map((k, v) => MapEntry<String, bool>(k, v)),
        usuario: json["usuario"],
      );

  Map<String, dynamic> toMap() => {
        "cancelada": cancelada,
        "fecha": fecha.toIso8601String(),
        "pagada": pagada,
        "pago": pago,
        "peluquero": peluquero,
        "servicios": Map.from(servicios).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "usuario": usuario,
      };
}



