import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDB {

  //static Future<Imoveis> getVersion() async {
  //  Completer<Imoveis> completer = new Completer<Imoveis>();
  //  FirebaseDatabase.instance
  //      .reference()
  //      .child("imoveis")
  //      .onValue
  //      .listen((Event event) {
  //    var todo = new Imoveis.fromJson(event.snapshot.key, event.snapshot.value);
  //    completer.complete(todo);
  //  });
  //  return completer.future;
  //}

  static Future<Imoveis> getImoveis() async {
    Completer<Imoveis> completer = new Completer<Imoveis>();
    FirebaseDatabase.instance
        .reference()
        .child("imoveis")
        .once()
        .then((DataSnapshot snapshot) {
      var todo = new Imoveis.fromJson(snapshot.key, snapshot.value);
      completer.complete(todo);
    });
    return completer.future;
  }

}

// Models

//class Versao {
//  String key;
//  int version;
//
//  Versao(this.version);
//  Versao.fromSnapshot(DataSnapshot snapshot)
//  : key = snapshot.key,
//    version = snapshot.value;
//  
//  Versao.fromJson(this.key, int data) {
//    version = data;
//    if (version == null) {
//      version = 0;
//    }
//  }
//}

class Imoveis {
  String key;
  List imoveis;

  Imoveis(
    this.imoveis
  );

  Imoveis.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      imoveis = snapshot.value;
  
  Imoveis.fromJson(this.key, List data) {
    imoveis = data;
    if (imoveis == null) {
      imoveis = [];
    }
  }
}