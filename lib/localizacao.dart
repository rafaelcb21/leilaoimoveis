import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class Localizacao {
  Location _location = new Location();
  List valores;
  List localizacaoAtual;

  initPlatformState() async {
    Map<String,double> location;
    try {
      location = await _location.getLocation;
      return location;

    } on PlatformException {
      _location = null;
      return null;
    }
  }
}