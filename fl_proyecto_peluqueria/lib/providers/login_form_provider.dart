import 'package:flutter/material.dart';
import 'package:fl_proyecto_peluqueria/pojos/usuario.dart';
class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email    = '';
  String password = '';

  Usuario? user;

  BuildContext? contextoUsuario; 
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }
  
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setContext(BuildContext context){
    contextoUsuario = context;
  }

  BuildContext getContext(){
    return this.contextoUsuario!;
  }

  void setUser(Usuario? usuario){
    user = usuario;
  }

  Usuario? getUser(){
    return user;
  }

  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool isValidForm() {

    print(formKey.currentState?.validate());

    print('$email - $password');

    return formKey.currentState?.validate() ?? false;
  }

}