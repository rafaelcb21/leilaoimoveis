import 'package:flutter/material.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';
import 'localizacao.dart';
import 'dbfirebase.dart';

//https://marcinszalek.pl/flutter/firebase-database-flutter-weighttracker/
//https://github.com/MSzalek-Mobile/weight_tracker/tree/v0.3
//https://github.com/flutter/plugins/blob/master/packages/firebase_database/example/lib/main.dart
//https://stackoverflow.com/questions/46236231/store-data-to-models-from-firebase-in-flutter
//https://codelabs.developers.google.com/codelabs/flutter-firebase/#10
//https://github.com/apptreesoftware/flutter_google_map_view/tree/master/example
//https://github.com/matthewtsmith/flutter_map_demo
//https://gist.github.com/branflake2267/ea80ce71179c41fdd8bbdb796ca889f4


//final analytics = new FirebaseAnalytics();
var apiKey = "AIzaSyBfQkQqqwFl0BcPBC1ySZ4i_J_-ANZI_0Q";

void main() {
  MapView.setApiKey(apiKey);
  runApp(new LeilaoImoveisApp());
}

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
  MapView mapView = new MapView();
  var compositeSubscription = new CompositeSubscription();

  Localizacao localizacao = new Localizacao();
  double latitude = -15.794229;
  double longitude = -47.882166;
  List coordenadas = [];
  List<Marker> marcadores = [];

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
  Uri staticMapUri;
  var staticMapProvider = new StaticMapProvider(apiKey);
  bool mapaImovel = false;

  @override
  initState() async {

    FirebaseDB.getVersion().then((dataVersion) {
      //print(dataVersion.version);
    });

    FirebaseDB.getImoveis().then((dataImoveis) {
      for(var item in dataImoveis.imoveis) {

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

        this.marcadores.add(
          new Marker(item['id'], this.tipo, item['latitude'], item['longitude'], color: Colors.blue));
      }

      //print(dataImoveis.imoveis);
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

    this.staticMapUri = staticMapProvider.getStaticUri(Locations.portland, 20, width: 900, height: 400);

    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Leilões de Imóveis da Caixa'),
      ),
      body: new ListView(
        children: <Widget>[
          new Card(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                this.mapaImovel ? new Image.network(staticMapUri.toString()) : new Container(),
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
          new Column(
            children: <Widget>[
              new RaisedButton(
                onPressed: _mapa,
                child: new Text('Buscar')
              )
            ],
          ),
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
    
    //var uri = await staticMapProvider.getImageUriFromMap(mapView, width: 900, height: 400);
    setState(() async {
    //  this.tipo = annotation.tipo;
    //  this.situacao = annotation.situacao;
    //  this.vlr_de_avaliacao = annotation.vlr_de_avaliacao;
    //  this.vlr_de_venda = annotation.vlr_de_venda;
    //  this.endereco = annotation.endereco;
    //  this.bairro = annotation.bairro;
    //  this.descricao = annotation.descricao;

      this.staticMapUri = staticMapProvider.getStaticUri(
        new Location(annotation.latitude, annotation.longitude),
        16, width: 900, height: 400);
      this.mapaImovel = true;
      this.id = annotation.id;
    //  this.leilao = annotation.leilao;
    //  this.num_do_bem = annotation.num_do_bem;
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


///////////

//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';
//
/////This API Key will be used for both the interactive maps as well as the static maps.
/////Make sure that you have enabled the following APIs in the Google API Console (https://console.developers.google.com/apis)
///// - Static Maps API
///// - Android Maps API
///// - iOS Maps API
//var API_KEY = "<your_api_key>";
//
//void main() {
//  MapView.setApiKey(API_KEY);
//  runApp(new MyApp());
//}
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => new _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  MapView mapView = new MapView();
//  CameraPosition cameraPosition;
//  var compositeSubscription = new CompositeSubscription();
//  var staticMapProvider = new StaticMapProvider(API_KEY);
//  Uri staticMapUri;
//
//  @override
//  initState() {
//    super.initState();
//    cameraPosition = new CameraPosition(Locations.portland, 12.0);
//    staticMapUri = staticMapProvider.getStaticUri(Locations.portland, 12,
//        width: 900, height: 400);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new Scaffold(
//          appBar: new AppBar(
//            title: new Text('Map View Example'),
//          ),
//          body: new Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              new Container(
//                height: 250.0,
//                child: new Stack(
//                  children: <Widget>[
//                    new Center(
//                        child: new Container(
//                      child: new Text(
//                        "You are supposed to see a map here.\n\nAPI Key is not valid.\n\n"
//                            "To view maps in the example application set the "
//                            "API_KEY variable in example/lib/main.dart. "
//                            "\n\nIf you have set an API Key but you still see this text "
//                            "make sure you have enabled all of the correct APIs "
//                            "in the Google API Console. See README for more detail.",
//                        textAlign: TextAlign.center,
//                      ),
//                      padding: const EdgeInsets.all(20.0),
//                    )),
//                    new InkWell(
//                      child: new Center(
//                        child: new Image.network(staticMapUri.toString()),
//                      ),
//                      onTap: showMap,
//                    )
//                  ],
//                ),
//              ),
//              new Container(
//                padding: new EdgeInsets.only(top: 10.0),
//                child: new Text(
//                  "Tap the map to interact",
//                  style: new TextStyle(fontWeight: FontWeight.bold),
//                ),
//              ),
//              new Container(
//                padding: new EdgeInsets.only(top: 25.0),
//                child: new Text(
//                    "Camera Position: \n\nLat: ${cameraPosition.center.latitude}\n\nLng:${cameraPosition.center.longitude}\n\nZoom: ${cameraPosition.zoom}"),
//              ),
//            ],
//          )),
//    );
//  }
//
//  showMap() {
//    mapView.show(
//        new MapOptions(
//            mapViewType: MapViewType.normal,
//            showUserLocation: true,
//            initialCameraPosition: new CameraPosition(
//                new Location(45.5235258, -122.6732493), 14.0),
//            title: "Recently Visited"),
//        toolbarActions: [new ToolbarAction("Close", 1)]);
//
//    var sub = mapView.onMapReady.listen((_) {
//      mapView.setMarkers(<Marker>[
//        new Marker("1", "Work", 45.523970, -122.663081, color: Colors.blue),
//        new Marker("2", "Nossa Familia Coffee", 45.528788, -122.684633),
//      ]);
//      mapView.addMarker(new Marker("3", "10 Barrel", 45.5259467, -122.687747,
//          color: Colors.purple));
//
//      mapView.zoomToFit(padding: 100);
//    });
//    compositeSubscription.add(sub);
//
//    sub = mapView.onLocationUpdated
//        .listen((location) => print("Location updated $location"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onTouchAnnotation
//        .listen((annotation) => print("annotation tapped"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onMapTapped
//        .listen((location) => print("Touched location $location"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onCameraChanged.listen((cameraPosition) =>
//        this.setState(() => this.cameraPosition = cameraPosition));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onToolbarAction.listen((id) {
//      if (id == 1) {
//        _handleDismiss();
//      }
//    });
//    compositeSubscription.add(sub);
//
//    sub = mapView.onInfoWindowTapped.listen((marker) {
//      print("Info Window Tapped for ${marker.title}");
//    });
//    compositeSubscription.add(sub);
//  }
//
//  _handleDismiss() async {
//    double zoomLevel = await mapView.zoomLevel;
//    Location centerLocation = await mapView.centerLocation;
//    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
//    print("Zoom Level: $zoomLevel");
//    print("Center: $centerLocation");
//    print("Visible Annotation Count: ${visibleAnnotations.length}");
//    var uri = await staticMapProvider.getImageUriFromMap(mapView,
//        width: 900, height: 400);
//    setState(() => staticMapUri = uri);
//    mapView.dismiss();
//    compositeSubscription.cancel();
//  }
//}
//
//class CompositeSubscription {
//  Set<StreamSubscription> _subscriptions = new Set();
//
//  void cancel() {
//    for (var n in this._subscriptions) {
//      n.cancel();
//    }
//    this._subscriptions = new Set();
//  }
//
//  void add(StreamSubscription subscription) {
//    this._subscriptions.add(subscription);
//  }
//
//  void addAll(Iterable<StreamSubscription> subs) {
//    _subscriptions.addAll(subs);
//  }
//
//  bool remove(StreamSubscription subscription) {
//    return this._subscriptions.remove(subscription);
//  }
//
//  bool contains(StreamSubscription subscription) {
//    return this._subscriptions.contains(subscription);
//  }
//
//  List<StreamSubscription> toList() {
//    return this._subscriptions.toList();
//  }
//}

/////////////////////////////////////////////////

//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';
//
/////This API Key will be used for both the interactive maps as well as the static maps.
/////Make sure that you have enabled the following APIs in the Google API Console (https://console.developers.google.com/apis)
///// - Static Maps API
///// - Android Maps API
///// - iOS Maps API
//var API_KEY = "AIzaSyBfQkQqqwFl0BcPBC1ySZ4i_J_-ANZI_0Q";
//
//void main() {
//  MapView.setApiKey(API_KEY);
//  runApp(new MyApp());
//}
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => new _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  MapView mapView = new MapView();
//  CameraPosition cameraPosition;
//  var compositeSubscription = new CompositeSubscription();
//  var staticMapProvider = new StaticMapProvider(API_KEY);
//  Uri staticMapUri;
//
//  @override
//  initState() {
//    super.initState();
//    cameraPosition = new CameraPosition(Locations.portland, 12.0);
//    staticMapUri = staticMapProvider.getStaticUri(Locations.portland, 12,
//        width: 900, height: 400);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new Scaffold(
//          appBar: new AppBar(
//            title: new Text('Map View Example'),
//          ),
//          body: new Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              new Container(
//                height: 250.0,
//                child: new Stack(
//                  children: <Widget>[
//                    new Center(
//                        child: new Container(
//                      child: new Text(
//                        "You are supposed to see a map here.\n\nAPI Key is not valid.\n\n"
//                            "To view maps in the example application set the "
//                            "API_KEY variable in example/lib/main.dart. "
//                            "\n\nIf you have set an API Key but you still see this text "
//                            "make sure you have enabled all of the correct APIs "
//                            "in the Google API Console. See README for more detail.",
//                        textAlign: TextAlign.center,
//                      ),
//                      padding: const EdgeInsets.all(20.0),
//                    )),
//                    new InkWell(
//                      child: new Center(
//                        child: new Image.network(staticMapUri.toString()),
//                      ),
//                      onTap: showMap,
//                    )
//                  ],
//                ),
//              ),
//              new Container(
//                padding: new EdgeInsets.only(top: 10.0),
//                child: new Text(
//                  "Tap the map to interact",
//                  style: new TextStyle(fontWeight: FontWeight.bold),
//                ),
//              ),
//              new Container(
//                padding: new EdgeInsets.only(top: 25.0),
//                child: new Text(
//                    "Camera Position: \n\nLat: ${cameraPosition.center.latitude}\n\nLng:${cameraPosition.center.longitude}\n\nZoom: ${cameraPosition.zoom}"),
//              ),
//            ],
//          )),
//    );
//  }
//
//  showMap() {
//    mapView.show(
//        new MapOptions(
//            mapViewType: MapViewType.normal,
//            showUserLocation: true,
//            initialCameraPosition: new CameraPosition(
//                new Location(45.5235258, -122.6732493), 14.0),
//            title: "Recently Visited"),
//        toolbarActions: [new ToolbarAction("Close", 1)]);
//
//    var sub = mapView.onMapReady.listen((_) {
//      mapView.setMarkers(<Marker>[
//        new Marker("1", "Work", -15.794229, -47.882166, color: Colors.blue),
//        new Marker("2", "Nossa Familia Coffee", 45.528788, -122.684633),
//      ]);
//      mapView.addMarker(new Marker("3", "10 Barrel", 45.5259467, -122.687747,
//          color: Colors.purple));
//
//      mapView.zoomToFit(padding: 100);
//    });
//    compositeSubscription.add(sub);
//
//    sub = mapView.onLocationUpdated
//        .listen((location) => print("Location updated $location"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onTouchAnnotation
//        .listen((annotation) => print("annotation tapped"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onMapTapped
//        .listen((location) => print("Touched location $location"));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onCameraChanged.listen((cameraPosition) =>
//        this.setState(() => this.cameraPosition = cameraPosition));
//    compositeSubscription.add(sub);
//
//    sub = mapView.onToolbarAction.listen((id) {
//      if (id == 1) {
//        _handleDismiss();
//      }
//    });
//    compositeSubscription.add(sub);
//
//    sub = mapView.onInfoWindowTapped.listen((marker) {
//      print("Info Window Tapped for ${marker.title}");
//    });
//    compositeSubscription.add(sub);
//  }
//
//  _handleDismiss() async {
//    double zoomLevel = await mapView.zoomLevel;
//    Location centerLocation = await mapView.centerLocation;
//    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
//    print("Zoom Level: $zoomLevel");
//    print("Center: $centerLocation");
//    print("Visible Annotation Count: ${visibleAnnotations.length}");
//    var uri = await staticMapProvider.getImageUriFromMap(mapView,
//        width: 900, height: 400);
//    setState(() => staticMapUri = uri);
//    mapView.dismiss();
//    compositeSubscription.cancel();
//  }
//}
//
//class CompositeSubscription {
//  Set<StreamSubscription> _subscriptions = new Set();
//
//  void cancel() {
//    for (var n in this._subscriptions) {
//      n.cancel();
//    }
//    this._subscriptions = new Set();
//  }
//
//  void add(StreamSubscription subscription) {
//    this._subscriptions.add(subscription);
//  }
//
//  void addAll(Iterable<StreamSubscription> subs) {
//    _subscriptions.addAll(subs);
//  }
//
//  bool remove(StreamSubscription subscription) {
//    return this._subscriptions.remove(subscription);
//  }
//
//  bool contains(StreamSubscription subscription) {
//    return this._subscriptions.contains(subscription);
//  }
//
//  List<StreamSubscription> toList() {
//    return this._subscriptions.toList();
//  }
//}