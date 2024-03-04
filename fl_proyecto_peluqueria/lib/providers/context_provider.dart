import 'package:flutter/material.dart';
class ContextProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  BuildContext? contextoUsuario;

  
  
  void setContext(BuildContext context){
    contextoUsuario = context;
  }

  BuildContext getContext(){
    return this.contextoUsuario!;
  }
}