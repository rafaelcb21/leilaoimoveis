import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';
import 'localizacao.dart';

var apiKey = "AIzaSyBfQkQqqwFl0BcPBC1ySZ4i_J_-ANZI_0Q";

class MapaPage extends StatefulWidget {
  MapaPage(this.imoveis);
  List imoveis;
  @override
  MapaPageState createState() => new MapaPageState();
}

class MapaPageState extends State<MapaPage> {
  Color azul = new Color(0xFF1387b3);
  MapView mapView = new MapView();
  Localizacao localizacao = new Localizacao();
  double latitude = -15.794229;
  double longitude = -47.882166;
  List coordenadas = [];
  List<Marker> marcadores = [];
  var compositeSubscription = new CompositeSubscription();  

  String tipo = '';
  String situacao = '';
  double vlr_de_avaliacao = 0.0;
  double vlr_de_venda = 0.0;
  String endereco = '';
  String bairro = '';
  String descricao = '';
  String id = '';
  String leilao = '';
  String num_do_bem = '';
  String label = '';
  Uri staticMapUri;
  var staticMapProvider = new StaticMapProvider(apiKey);
  bool mapaImovel = false;

  @override
  void initState() {
    super.initState();
    for(var item in widget.imoveis) {
      this.tipo = item['tipo'];
      this.situacao = item['situacao'];
      this.vlr_de_avaliacao = item['vlr_de_avaliacao'];
      this.vlr_de_venda = item['vlr_de_venda'];
      this.endereco = item['endereco'];
      this.bairro = item['bairro'];
      this.descricao = item['descricao'];
      this.id = item['id'];
      this.leilao = item['leilao'];
      this.num_do_bem = item['num_do_bem'];
      this.tipo = item['tipo'];

      var info =
        this.tipo + '|' +
        this.situacao + '|' +
        this.vlr_de_avaliacao.toString() + '|' +
        this.vlr_de_venda.toString() + '|' +
        this.endereco + '|' +
        this.bairro + '|' +
        this.descricao + '|' +
        this.id + '|' +
        this.leilao + '|' +
        this.num_do_bem;

      this.marcadores.add(
        new Marker(item['id'], info, item['latitude'], item['longitude'], color: Colors.blue));
    }


    localizacao.initPlatformState().then((data) {
      if(data != null) {
        for(var i in data.values) {
        this.coordenadas.add(i);
      }
      this.latitude = coordenadas[1];
      this.longitude = coordenadas[3];
      }

      _mapa();
    });


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Leilões de Imóveis da Caixa'),
        backgroundColor: this.azul,
      ),
      body: new ListView(
        children: <Widget>[
          ////////
          new Card(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                !this.mapaImovel ? new Container() :
                new Image.network(
                  staticMapProvider.getStaticUri(
                    new Location(this.latitude, this.longitude),
                    16, width: 900, height: 400).toString() +
                    "&markers=color:red|label:" + this.label +"|" + this.latitude.toString() + "," + this.longitude.toString()
                ),
                new Text('tipo: ' + this.tipo),
                new Text('situação: ' + this.situacao),
                new Text('valor de avaliação: ' + this.vlr_de_avaliacao.toString()),
                new Text('valor de venda' + this.vlr_de_venda.toString()),
                new Text('endereção: ' + this.endereco),
                new Text('bairro: ' + this.bairro),
                new Text('descrição: ' + this.descricao),
                new Text('id:' + this.id),
                new Text('leilão: ' + this.leilao),
                new Text('numero do bem: ' + this.num_do_bem)                
              ],
            ),
          ),
          ////////
        ],
      )
    );
  }

  Future _mapa() async {
    //1. Show the map
    mapView.show(
      new MapOptions(
        showUserLocation: true,
        title: "Imóveis de leilão",
        initialCameraPosition: new CameraPosition(new Location(this.latitude, this.longitude), 18.0)),
          toolbarActions: <ToolbarAction>[new ToolbarAction("Fechar", 1)]
    );

    var sub = mapView.onMapReady.listen((_) {
      mapView.setMarkers(this.marcadores);
      mapView.zoomToFit(padding: 100);
    });
    compositeSubscription.add(sub);

    sub = mapView.onTouchAnnotation.listen((annotation) {
      _handleDismiss(annotation);
      
    });
    compositeSubscription.add(sub);

    sub = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });
    compositeSubscription.add(sub);
   
  }

  _handleDismiss(annotation) async {
    setState(() async {
      List informacao = annotation.title.split('|');

      this.tipo = informacao[0];
      this.situacao = informacao[1];
      this.vlr_de_avaliacao = informacao[2];
      this.vlr_de_venda = informacao[3];
      this.endereco = informacao[4];
      this.bairro = informacao[5];
      this.descricao = informacao[6];
      this.id = informacao[7];
      this.leilao = informacao[8];
      this.num_do_bem = informacao[9];

      this.latitude = annotation.latitude;
      this.longitude = annotation.longitude;

      this.label = this.tipo[0];


      this.mapaImovel = true;

    });


    mapView.dismiss();
      compositeSubscription.cancel();
  }
}

class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}
