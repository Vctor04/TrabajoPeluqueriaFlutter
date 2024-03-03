import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_de_peluqueros/usuario.dart';
import 'package:gestion_de_peluqueros/peluquero.dart';
import 'package:gestion_de_peluqueros/usuarios_services.dart';
import 'package:gestion_de_peluqueros/peluqueros_services.dart';

class PeluqueroDetailScreen extends StatefulWidget {
  final Peluquero peluquero;

  const PeluqueroDetailScreen({required this.peluquero});

  @override
  _PeluqueroDetailScreenState createState() => _PeluqueroDetailScreenState();
}

class _PeluqueroDetailScreenState extends State<PeluqueroDetailScreen> {
  late TextEditingController nombreController;
  late TextEditingController emailController;
  late TextEditingController telefonoController;
  late TextEditingController horarioController;
  late TextEditingController diasController;
  late TextEditingController vacacionesController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.peluquero.nombre);
    emailController = TextEditingController(text: widget.peluquero.email);
    telefonoController = TextEditingController(text: widget.peluquero.telefono);
    horarioController = TextEditingController(text: widget.peluquero.horario);
    diasController = TextEditingController(text: widget.peluquero.dias);
    vacacionesController = TextEditingController(text: widget.peluquero.vacaciones.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Peluquero'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: horarioController,
              decoration: InputDecoration(labelText: 'Horario'),
            ),
            TextFormField(
              controller: diasController,
              decoration: InputDecoration(labelText: 'Días de trabajo'),
            ),
            TextFormField(
              controller: vacacionesController,
              decoration: InputDecoration(labelText: 'Vacaciones'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Guardar la información modificada en la base de datos
                final newPeluquero = Peluquero(
                  nombre: nombreController.text,
                  email: emailController.text,
                  telefono: telefonoController.text,
                  horario: horarioController.text,
                  dias: diasController.text,
                  vacaciones: int.parse(vacacionesController.text),
                  id: widget.peluquero.id,
                );

                final peluquerosServices = Provider.of<PeluquerosServices>(context, listen: false);
                final updatedId = await peluquerosServices.updatePeluquero(newPeluquero);
                if (updatedId != null) {
                  // Actualizar el peluquero localmente si se actualizó correctamente en la base de datos
                  setState(() {
                    widget.peluquero.nombre = newPeluquero.nombre;
                    widget.peluquero.email = newPeluquero.email;
                    widget.peluquero.telefono = newPeluquero.telefono;
                    widget.peluquero.horario = newPeluquero.horario;
                    widget.peluquero.dias = newPeluquero.dias;
                    widget.peluquero.vacaciones = newPeluquero.vacaciones;
                  });
                  // Mostrar un mensaje de éxito o realizar otras acciones según sea necesario
                } else {
                  // Mostrar un mensaje de error o realizar otras acciones según sea necesario
                }
              },
              child: Text('Guardar'),
            ),

          ],
        ),
      ),
    );
  }

  
}
