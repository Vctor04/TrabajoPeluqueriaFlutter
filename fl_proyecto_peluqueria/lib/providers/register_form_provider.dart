import 'package:flutter/material.dart';
class RegisterFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email    = '';
  String password = '';
  String gender = '';
  String rol = 'usuario';
  String tlf = '';
  bool verificado = false;
  String nombre = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool isValidForm() {

    print(formKey.currentState?.validate());

    print('$email - $password - $nombre - $gender - $rol - $tlf - $verificado');

    return formKey.currentState?.validate() ?? false;
  }

}