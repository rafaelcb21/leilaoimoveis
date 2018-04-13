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
  Color azulCeleste = new Color(0xFF1667A6);
  MapView mapView = new MapView();
  Localizacao localizacao = new Localizacao();
  double latitude = -15.794229;
  double longitude = -47.882166;
  List coordenadas = [];
  List listaFavoritos = [];
  List<Marker> marcadores = [];
  var compositeSubscription = new CompositeSubscription();  

  
  Uri staticMapUri;
  var staticMapProvider = new StaticMapProvider(apiKey);
  //bool mapaImovel = false;
  bool favorito = true;
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
      //_mapa();
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

  List<Widget> buildFavoritos(data) {
    this.listaFavoritos = [];
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

    for(var item in data) {
      tipo = item['tipo'];
      situacao = item['situacao'];
      vlr_de_avaliacao = item['vlr_de_avaliacao'];
      vlr_de_venda = item['vlr_de_venda'];
      endereco = item['endereco'];
      bairro = item['bairro'];
      descricao = item['descricao'];
      id = item['id'];
      leilao = item['leilao'];
      num_do_bem = item['num_do_bem'];
      uuidRandom = item['uuid'];

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
        new Marker(item['id'], info, item['latitude'], item['longitude'], color: Colors.blue));

      this.listaFavoritos.add(
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
                        imovelDB.getFavorito(uuidRandom).then((data) {
                          if(data == true) {
                            imovelDB.updateFavorito(uuidRandom, "Sim").then((result) {
                            });
                          } else if(data == false) {
                            imovelDB.updateFavorito(uuidRandom, "Não").then((result) {
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
                        "&markers=color:red|label:" + label +"|" + this.latitude.toString() + "," + this.longitude.toString()
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
                      tipo,
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
                      situacao,
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
                      prepararNumeroBrasil(vlr_de_venda.toString()),
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
                      prepararNumeroBrasil(vlr_de_avaliacao.toString()),
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
                      endereco,
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
                      bairro,
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
                      descricao,
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
                      leilao,
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
                      num_do_bem,
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
                        _launched = _launchInBrowser('http://www1.caixa.gov.br/editais/'+leilao+'.PDF');
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
          this.favorito = false;
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
