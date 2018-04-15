import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';
import 'localizacao.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dbsqlite.dart';
import 'favoritos.dart';

var apiKey = "AIzaSyBfQkQqqwFl0BcPBC1ySZ4i_J_-ANZI_0Q";

class MapaPage extends StatefulWidget {
  MapaPage(this.imoveis);
  List imoveis;
  @override
  MapaPageState createState() => new MapaPageState();
}

class MapaPageState extends State<MapaPage> {
  Imovel imovelDB = new Imovel();
  var uuid = new Uuid();
  Color azul = new Color(0xFF1387B3);
  Color azulCeleste = new Color(0xFF1667A6);
  MapView mapView = new MapView();
  Localizacao localizacao = new Localizacao();
  double latitude = -15.794229;
  double longitude = -47.882166;
  List coordenadas = [];
  List<Marker> marcadores = [];
  var compositeSubscription = new CompositeSubscription();  

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
  String label = '';
  String uuidRandom = '';
  Uri staticMapUri;
  var staticMapProvider = new StaticMapProvider(apiKey);
  bool mapaImovel = false;
  bool favorito = false;

  //File jsonFile;
  //Directory dir;
  //String fileName = "favoritosdb.json";
  //bool fileExists = false;
  //Map<String, List> fileContent;

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
      this.uuidRandom = item['uuid'];

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
        this.num_do_bem + '|' +
        this.uuidRandom;

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
    const Color _kKeyUmbraOpacity = const Color(0x33000000); // alpha = 0.2
    const Color _kKeyPenumbraOpacity = const Color(0x24000000); // alpha = 0.14
    const Color _kAmbientShadowOpacity = const Color(0x1F000000); // alpha = 0.12

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Imóvel'),
        backgroundColor: this.azul,
        actions: <Widget>[
          new IconButton(
            color: Colors.white,
            icon: new Icon(Icons.star),
            onPressed: () {
              imovelDB.getAllFavorito().then((data) {
                Navigator.of(context).push(new PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return new FavoritoPage(data);
                  },
                  transitionsBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,
                  ) {
                    return new SlideTransition(
                      position: new Tween<Offset>(
                        begin:  const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }
                ));  
              });                
            },
          )
        ],
      ),
      
      body: !this.mapaImovel ? new Container(
        margin: new EdgeInsets.only(top: 18.0, bottom: 18.0, left: 18.0, right: 18.0),
        child: new ListView(
          children: <Widget>[
            new InkWell(
              onTap: () {
                this.favorito = false;
                _mapa();
              },
              child: new Container(
                margin: new EdgeInsets.only(top:4.0, bottom: 4.0),
                decoration: new BoxDecoration(
                  color: new Color(0xFFF7941E),
                  borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
                  boxShadow: [
                    const BoxShadow(offset: const Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: _kKeyUmbraOpacity),
                    const BoxShadow(offset: const Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
                    const BoxShadow(offset: const Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
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
            new Container(
              margin: new EdgeInsets.all(32.0),
            )
          ],
        ),
      ) : new ListView(
        key: new Key(uuid.v4()),
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text(
                'Favorito',
                style: new TextStyle(
                  color: this.favorito ? new Color(0xFFF7941E) : Colors.black38 ,
                  fontFamily: "Futura",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700
                ),
              ),
              new Container(
                margin: new EdgeInsets.all(4.0),
              ),
              new IconButton(
                icon: this.favorito ? new Icon(Icons.star) : new Icon(Icons.star_border),
                onPressed: () {
                  setState(() {
                    this.favorito = !this.favorito;
                    imovelDB.getFavorito(this.uuidRandom).then((data) {
                      if(data == true) {
                        imovelDB.updateFavorito(this.uuidRandom, "Sim").then((result) {
                        });
                      } else if(data == false) {
                        imovelDB.updateFavorito(this.uuidRandom, "Não").then((result) {
                        });
                      }                      
                    });                    
                  });
                },
                color: new Color(0xFFF7941E)
              ),
            ],
          ),

          new Container(
            margin: new EdgeInsets.only(top: 0.0, bottom: 18.0, left: 18.0, right: 18.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Image.network(
                  'https://maps.googleapis.com/maps/api/streetview?size=900x400&location=' + this.latitude.toString() + "," + this.longitude.toString() + '&key=' + apiKey
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                ),

                new Image.network(
                  staticMapProvider.getStaticUri(
                    new Location(this.latitude, this.longitude),
                    16, width: 900, height: 400).toString() +
                    "&markers=color:red|label:" + this.label +"|" + this.latitude.toString() + "," + this.longitude.toString()
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
                  this.tipo,
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
                  this.situacao,
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
                  prepararNumeroBrasil(this.vlr_de_venda.toString()),
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
                  prepararNumeroBrasil(this.vlr_de_avaliacao.toString()),
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
                  this.endereco,
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
                  this.bairro,
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
                  this.descricao,
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
                  this.leilao,
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
                  this.num_do_bem,
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
                    _launched = _launchInBrowser('http://www1.caixa.gov.br/editais/'+this.leilao+'.PDF');
                  }),
                ),
                new Container(
                  margin: new EdgeInsets.all(16.0),
                ),

                new InkWell(
                  onTap: () {
                    this.favorito = false;
                    _mapa();
                  },
                  child: new Container(
                    margin: new EdgeInsets.only(top:4.0, bottom: 4.0),
                    decoration: new BoxDecoration(
                      color: new Color(0xFFF7941E),
                      borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
                      boxShadow: [
                        const BoxShadow(offset: const Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: _kKeyUmbraOpacity),
                        const BoxShadow(offset: const Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
                        const BoxShadow(offset: const Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
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
                new Container(
                  margin: new EdgeInsets.all(32.0),
                )
              ],
            ),
          )
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

  _handleDismiss(annotation) {
    setState(() {
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
      this.uuidRandom = informacao[10];

      imovelDB.getFavorito(this.uuidRandom).then((data) {
        if(data == true) {
          this.favorito = false;
          
        } else if(data == false) {
          this.favorito = true;          
        }        
      });
      

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
