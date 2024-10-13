import 'package:flutter/material.dart';

class TestProvider extends ChangeNotifier{

String _name='JAIR VELAZQUEZ REYES';

String get name => _name;
set name(String value){
  _name=value;
  notifyListeners();
}























































}