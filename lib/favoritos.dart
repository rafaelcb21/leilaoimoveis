import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';
import 'localizacao.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'dbsqlite.dart';

var apiKey = "AIzaSyBfQkQqqwFl0BcPBC1ySZ4i_J_-ANZI_0Q";

class FavoritoPage extends StatefulWidget {
  FavoritoPage(this.favoritos);
  List favoritos;
  @override
  FavoritoPageState createState() => new FavoritoPageState();
}

class FavoritoPageState extends State<FavoritoPage> {
  Imovel imovelDB = new Imovel();
  var uuid = new Uuid();
  Color azul = new Color(0xFF1387B3);
  
  MapView mapView = new MapView();
  Localizacao localizacao = new Localizacao();
  double latitude = -15.794229;
  double longitude = -47.882166;
  List coordenadas = [];
  List listaFavoritos = [];
  List<Marker> marcadores = [];
  var compositeSubscription = new CompositeSubscription();  

  
  Uri staticMapUri;
  
  //bool mapaImovel = false;
  //bool favorito = true;
  List dadosFavoritos = [];

  @override
  void initState() {
    super.initState();    

    setState(() {
      this.dadosFavoritos = widget.favoritos;
    });
    
 
    localizacao.initPlatformState().then((data) {
      if(data != null) {
        for(var i in data.values) {
        this.coordenadas.add(i);
      }
      this.latitude = coordenadas[1];
      this.longitude = coordenadas[3];
      }
    });     
  }

  

  List<Widget> buildFavoritos(data) {
    this.marcadores = [];
    this.listaFavoritos = [];    

    for(var item in data) {
      this.listaFavoritos.add(
        new ItemFavorito(
          key: new Key(item['uuid']),
          tipo: item['tipo'],
          situacao: item['situacao'],
          vlr_de_avaliacao: item['vlr_de_avaliacao'],
          vlr_de_venda: item['vlr_de_venda'],
          endereco: item['endereco'],
          bairro: item['bairro'],
          descricao: item['descricao'],
          id: item['id'],
          leilao: item['leilao'],
          num_do_bem: item['num_do_bem'],
          uuidRandom: item['uuid'],
          latitude: item['latitude'],
          longitude: item['longitude'],
          onPressed: () {
            setState(() {
              imovelDB.updateFavorito(item['uuid'], "Não").then((data1) {
                imovelDB.getAllFavorito().then((data) {
                  this.dadosFavoritos = data;                  
                  this.marcadores = [];
                  String tipo = '';
                  String situacao = '';
                  String vlr_de_avaliacao = '0.0';
                  String vlr_de_venda = '0.0';
                  String endereco = '';
                  String bairro = '';
                  String descricao = '';
                  String id = '';
                  String leilao = '';
                  String num_do_bem = '';
                  String uuidRandom = '';
                  double latitude = 0.0;
                  double longitude = 0.0;

                  for(var item2 in data) {
                    tipo = item2['tipo'];
                    situacao = item2['situacao'];
                    vlr_de_avaliacao = item2['vlr_de_avaliacao'];
                    vlr_de_venda = item2['vlr_de_venda'];
                    endereco = item2['endereco'];
                    bairro = item2['bairro'];
                    descricao = item2['descricao'];
                    id = item2['id'];
                    leilao = item2['leilao'];
                    num_do_bem = item2['num_do_bem'];
                    uuidRandom = item2['uuid'];
                    latitude = item2['latitude'];
                    longitude = item2['longitude'];

                    var info =
                      tipo + '|' +
                      situacao + '|' +
                      vlr_de_avaliacao.toString() + '|' +
                      vlr_de_venda.toString() + '|' +
                      endereco + '|' +
                      bairro + '|' +
                      descricao + '|' +
                      id.toString() + '|' +
                      leilao + '|' +
                      num_do_bem + '|' +
                      uuidRandom;

                    this.marcadores.add(
                      new Marker(item2['id'].toString(), info, latitude, longitude, color: Colors.blue)
                    );
                  }
                });
              });
            });
          },
        )
      );
    }

    this.listaFavoritos.add(
      new Container(
        margin: new EdgeInsets.all(16.0),
      ), 
    );

    this.listaFavoritos.add(
      new InkWell(
        onTap: () {
          //this.favorito = false;
          _mapa();
        },
        child: new Container(
          margin: new EdgeInsets.only(top:8.0, bottom: 8.0, left: 8.0, right: 8.0),
          decoration: new BoxDecoration(
            color: new Color(0xFFF7941E),
            borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
            boxShadow: [
              const BoxShadow(offset: const Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: const Color(0x33000000)),
              const BoxShadow(offset: const Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: const Color(0x24000000)),
              const BoxShadow(offset: const Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: const Color(0x1F000000)),
            ]
          ),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.only(top: 18.0, bottom: 18.0),
                child: new Text(
                  'Mapa',
                  style: new TextStyle(
                    color: Colors.white,
                    fontFamily: "Futura",
                    fontSize: 18.0
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    this.listaFavoritos.add(
      new Container(
        margin: new EdgeInsets.all(32.0),
      )
    );

    return this.listaFavoritos;
  }

  @override
  Widget build(BuildContext context) {
    const Color _kKeyUmbraOpacity = const Color(0x33000000); // alpha = 0.2
    const Color _kKeyPenumbraOpacity = const Color(0x24000000); // alpha = 0.14
    const Color _kAmbientShadowOpacity = const Color(0x1F000000); // alpha = 0.12

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Favoritos'),
        backgroundColor: this.azul,
      ),
      
      body: new ListView(
        key: new Key(uuid.v4()),
        children: buildFavoritos(this.dadosFavoritos)
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

  _handleDismiss(annotation) {
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

class ItemFavorito extends StatefulWidget {
  final String tipo;
  final String situacao;
  final String vlr_de_avaliacao;
  final String vlr_de_venda;
  final String endereco;
  final String bairro;
  final String descricao;
  final String id;
  final String leilao;
  final String num_do_bem;
  final String uuidRandom;
  final double latitude;
  final double longitude;
  final VoidCallback onPressed;

  ItemFavorito({
    Key key,
    this.tipo,
    this.situacao,
    this.vlr_de_avaliacao,
    this.vlr_de_venda,
    this.endereco,
    this.bairro,
    this.descricao,
    this.id,
    this.leilao,
    this.num_do_bem,
    this.uuidRandom,
    this.latitude,
    this.longitude,
    this.onPressed}) : super(key: key);

  @override
  ItemFavoritoState createState() => new ItemFavoritoState();
}

class ItemFavoritoState extends State<ItemFavorito> {
  ItemFavoritoState();
  Color azulCeleste = new Color(0xFF1667A6);
  var staticMapProvider = new StaticMapProvider(apiKey);

  void initState() {
    super.initState();

  }

  String numeroBrasil(List<int> numerosLista) {
    if(numerosLista.length == 0) {
      return '0,00';
    }
    if(numerosLista.length == 1) {
      return '0,0' + numerosLista[0].toString();
    }
   if(numerosLista.length == 2) {
      return '0,' + numerosLista[0].toString() + numerosLista[1].toString();
    }
    if(numerosLista.length >= 3) {
      List<int> inteiroLista = numerosLista.sublist(0, numerosLista.length -2);
      List<int> decimalLista = numerosLista.sublist(numerosLista.length -2, numerosLista.length);
      String inteiroListaString = inteiroLista.map((i) => i.toString()).join('');
      String decimalListaString = decimalLista.map((i) => i.toString()).join('');
 
      var f = new NumberFormat("#,###,###,###,###.00", "pt_BR");
      var valor = f.format(double.parse(inteiroListaString + '.' + decimalListaString));
      return  valor;
 
    }
  }

  String prepararNumeroBrasil(String item) {
    List numerosInt = [];
    List numerosString = item.split('');    
    for(var i in numerosString) {                
      if(i != '.') {
        numerosInt.add(int.parse(i));
      }
    }
    String numerosBrasileirados = 'R\$ ' + numeroBrasil(numerosInt);
    return numerosBrasileirados;
  }

  Future<Null> _launched;

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);//, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Erro em abrir o Edital';
    }
  }

  @override
  Widget build(BuildContext context) {
    new Container(
      margin: new EdgeInsets.only(top:8.0, bottom: 8.0, left: 8.0, right: 8.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
          boxShadow: [
            const BoxShadow(offset: const Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: const Color(0x33000000)),
            const BoxShadow(offset: const Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: const Color(0x24000000)),
            const BoxShadow(offset: const Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: const Color(0x1F000000))
        ]
      ),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text(
                'Favorito',
                style: new TextStyle(
                  color: new Color(0xFFF7941E),
                  fontFamily: "Futura",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700
                ),
              ),
              new Container(
                margin: new EdgeInsets.all(4.0),
              ),
              new IconButton(
                color: new Color(0xFFF7941E),
                icon: new Icon(Icons.star),
                onPressed: widget.onPressed
               ),
            ],
          ),
          new Container(
            margin: new EdgeInsets.only(top: 0.0, bottom: 18.0, left: 18.0, right: 18.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Image.network(
                  'https://maps.googleapis.com/maps/api/streetview?size=900x400&location=' + widget.latitude.toString() + "," + widget.longitude.toString() + '&key=' + apiKey
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Image.network(
                  staticMapProvider.getStaticUri(
                    new Location(widget.latitude, widget.longitude),
                    16, width: 900, height: 400).toString() +
                    "&markers=color:red|" + widget.latitude.toString() + "," + widget.longitude.toString()
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Tipo de Imóvel',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.tipo,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 18.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Situação',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.situacao,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Valor Mínimo de Venda',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  prepararNumeroBrasil(widget.vlr_de_venda.toString()),
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Valor Máximo de Avaliação',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  prepararNumeroBrasil(widget.vlr_de_avaliacao.toString()),
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Endereço',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.endereco,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Bairro',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.bairro,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Descrição do Imóvel',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.descricao,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Código do leilão',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.leilao,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Numero do imóvel no leilão',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.num_do_bem,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new InkWell(
                  child: new Text(
                    "Edital",
                    style: new TextStyle(
                      color: this.azulCeleste,
                      fontFamily: "Futura",
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: () => setState(() {
                    _launched = _launchInBrowser('http://www1.caixa.gov.br/editais/'+widget.leilao+'.PDF');
                  }),
                ),
                new Container(
                  margin: new EdgeInsets.all(16.0),
                ),
              ],
            ),
          )
        ],
      ),
    );    
  }
}
