import 'dart:convert';

class Peluquero {
    String? id; 
    String dias;
    String email;
    String horario;
    String nombre;
    String telefono;
    int vacaciones;

    Peluquero({
        required this.dias,
        required this.email,
        required this.horario,
        required this.nombre,
        required this.telefono,
        required this.vacaciones,
        this.id,
    });

    factory Peluquero.fromJson(String str) => Peluquero.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Peluquero.fromMap(Map<String, dynamic> json) => Peluquero(
        dias: json["dias"],
        email: json["email"],
        horario: json["horario"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        vacaciones: json["vacaciones"],
    );

    Map<String, dynamic> toMap() => {
        "dias": dias,
        "email": email,
        "horario": horario,
        "nombre": nombre,
        "telefono": telefono,
        "vacaciones": vacaciones,
    };

    Peluquero copy() => Peluquero(
      dias: dias, 
      email: email, 
      horario: horario, 
      nombre: nombre, 
      telefono: telefono, 
      vacaciones: vacaciones,
      id: this.id,
    );
}
