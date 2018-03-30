import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

//https://marcinszalek.pl/flutter/firebase-database-flutter-weighttracker/
//https://github.com/MSzalek-Mobile/weight_tracker/tree/v0.3
//https://github.com/flutter/plugins/blob/master/packages/firebase_database/example/lib/main.dart
//https://stackoverflow.com/questions/46236231/store-data-to-models-from-firebase-in-flutter
//https://codelabs.developers.google.com/codelabs/flutter-firebase/#10
//https://github.com/apptreesoftware/flutter_google_map_view/tree/master/example
//https://github.com/matthewtsmith/flutter_map_demo

void main() => runApp(new LeilaoImoveisApp());
final analytics = new FirebaseAnalytics();

class LeilaoImoveisApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new LeilaoImoveisPage(),
    );
  }
}

class LeilaoImoveisPage extends StatefulWidget {

  @override
  _LeilaoImoveisPageState createState() => new _LeilaoImoveisPageState();
}

class _LeilaoImoveisPageState extends State<LeilaoImoveisPage> {
  final reference = FirebaseDatabase.instance.reference();
  List<Leiloes> leiloes = new List();


  _LeilaoImoveisPageState() {
    reference.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event event) {
    setState(() {
      leiloes.add(new Leiloes.fromSnapshot(event.snapshot));
      for(var i in leiloes) {
        print(i.leilao);
      }
      print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      
      
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Leilões de Imóveis da Caixa'),
      ),
      body: new Center(
        child: new Column(

        ),
      ),
    );
  }
}

class Leiloes {
  String key;
  List leilao;
  //String id;
  //double latitude;
  //String num_do_bem;
  //double longitude;
  //double vlr_de_avaliacao;
  //String descricao;
  //String tipo;
  //double vlr_de_venda;
  //String endereco;
  //String situacao;
  //String leilao;
  //String bairro;

  Leiloes(
    this.leilao
    //this.id,
    //this.latitude,
    //this.num_do_bem,
    //this.longitude,
    //this.vlr_de_avaliacao,
    //this.descricao,
    //this.tipo,
    //this.vlr_de_venda,
    //this.endereco,
    //this.situacao,
    //this.leilao,
    //this.bairro
  );

  Leiloes.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      leilao = snapshot.value;
      //id = snapshot.value["id"],
      //latitude = snapshot.value["latitude"].toDouble(),
      //num_do_bem = snapshot.value["num_do_bem"],
      //longitude = snapshot.value["longitude"].toDouble(),
      //vlr_de_avaliacao = snapshot.value["vlr_de_avaliacao"].toDouble(),
      //descricao = snapshot.value["descricao"],
      //tipo = snapshot.value["tipo"],
      //vlr_de_venda = snapshot.value["vlr_de_venda"].toDouble(),
      //endereco = snapshot.value["endereco"],
      //situacao = snapshot.value["situacao"],
      //leilao = snapshot.value["leilao"],
      //bairro = snapshot.value["bairro"];
}
