import 'package:fl_proyecto_peluqueria/pojos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:fl_proyecto_peluqueria/providers/providers.dart';
import 'package:fl_proyecto_peluqueria/services/services.dart';
import 'package:provider/provider.dart';
import 'package:fl_proyecto_peluqueria/ui/input_decorations.dart';
import 'package:fl_proyecto_peluqueria/widgets/widgets.dart';
import 'package:local_auth/local_auth.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 250),
          CardContainer(
              child: Column(
            children: [
              SizedBox(height: 10),
              Text('Regístrate', style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => RegisterFormProvider(), child: _RegisterForm())
            ],
          )),
          SizedBox(height: 50),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.grey.withOpacity(0.1)),
                shape: MaterialStateProperty.all(StadiumBorder())),
            child: Text(
              '¿Ya tienes una cuenta?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    )));
  }
}

// ignore: must_be_immutable
class _RegisterForm extends StatelessWidget {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final bool _isBiometricAvailable = false;

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_outlined),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Pepe',
                  labelText: 'Nombre',
                  prefixIcon: Icons.person_2_outlined),
              onChanged: (value) => registerForm.nombre = value,
              validator: (value) {
                return (value != null) ? null : 'Escribe tu nombre';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Hombre/Mujer',
                  labelText: 'Género',
                  prefixIcon: Icons.person),
              onChanged: (value) => registerForm.gender = value,
              validator: (value) {
                return (value != null &&
                        (((value.toLowerCase()).compareTo("hombre")) == 0 ||
                            ((value.toLowerCase()).compareTo("mujer")) == 0))
                    ? null
                    : 'Elige hombre o mujer';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '+34666666666',
                  labelText: 'Teléfono',
                  prefixIcon: Icons.phone),
              onChanged: (value) => registerForm.tlf = value,
              validator: (value) {
                return (value != null &&
                        value.contains("+") &&
                        value.length == 12)
                    ? null
                    : 'Número no valido';
              },
            ),
            SizedBox(height: 30),
            MaterialButton(
              onPressed: _scanFingerprint,
              child: Text('Registrar Huella Dactilar'),
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromARGB(255, 12, 12, 12),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                    child: Text(
                      registerForm.isLoading ? 'Espere' : 'Registrarse',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: registerForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService = AuthService();

                        if (!registerForm.isValidForm()) return;

                        registerForm.isLoading = true;

                        // TODO: validar si el login es correcto
                        final String? errorMessage =
                            await authService.createUser(
                                registerForm.email,
                                registerForm.password,
                                Usuario(
                                    email: registerForm.email,
                                    genero: registerForm.gender,
                                    nombre: registerForm.nombre,
                                    rol: registerForm.rol,
                                    telefono: registerForm.tlf,
                                    verificado: true));
                        authService
                            .loadUsuarios(registerForm.email)
                            .then((user) => {
                                  if (errorMessage == null)
                                    {
                                      Navigator.pushReplacementNamed(
                                          context, 'home',
                                          arguments: {"user": user})
                                    }
                                  else
                                    {
                                      // Mostrar error en la terminal
                                      print(errorMessage),
                                      registerForm.isLoading = false
                                    }
                                });
                      })
          ],
        ),
      ),
    );
  }

  Future<void> _scanFingerprint() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        try {
          bool didAuthenticate = await _localAuthentication.authenticate(
            localizedReason:
                'Por favor, escanea tu huella dactilar para continuar',
            options: const AuthenticationOptions(
              // Puedes ajustar las opciones según tus necesidades
              stickyAuth:
                  true, // Mantener autenticación hasta que el usuario cierre la app
            ),
          );
          if (didAuthenticate) {
            // Autenticación de huella dactilar exitosa
            // Puedes realizar acciones adicionales aquí
          } else {
            // Autenticación de huella dactilar fallida
            // Manejar según sea necesario
          }
        } catch (e) {
          print(e);
        }
      } else {
        // La autenticación mediante huella dactilar no está disponible en este dispositivo
        // Manejar según sea necesario
      }
    } else {
      // La biometría no está disponible en este dispositivo
      // Manejar según sea necesario
    }
  }
}
