import 'package:flutter/material.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';
import 'localizacao.dart';
import 'dbfirebase.dart';
import 'textpicker.dart';
//import 'palette.dart';

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
  String label = '';
  Uri staticMapUri;
  var staticMapProvider = new StaticMapProvider(apiKey);
  bool mapaImovel = false;

  String valueTextTipoLeilao = " ";
  String valueTextProposta = "Sim";
  String valueTextTipo = " ";
  String valueTextVMVenda = " ";
  String valueTextVMAvaliacao = " ";
  String valueOcupadoDesocupado = " ";
  String valueTextEstado = " ";
  String valueTextCidade = " ";

  List listaTipoLeilao = [];
  List listaProposta = [];
  List listaTipo = [];
  List listaValorMinimoVenda = [];
  List listaValorMaximoAvaliacao = [];
  List listaOcupadoDesocupado = [];
  List listaEstado = [];
  List listaCidade = [];

  List leilaoTipo = [
    ['Leilão', Colors.purple],
    ['Licitacao Aberta', Colors.purpleAccent],
    ['Licitacao Fechada', Colors.deepPurple],
    ['Venda Direta', Colors.indigo]
  ];

  List proposta = [
    ['Sim', Colors.greenAccent],
    ['Não', Colors.redAccent]
  ];

  List tipoImoveis = [
    ['Apartamento', Colors.lightGreen],
    ['Casa', Colors.lightBlue],
    ['Sobrado', Colors.teal],
    ['Terreno', Colors.orange]
  ];

  List valorMinimoVenda = ['R\$ 50.000.000,00', 'R\$ 900.000.000,00', 'R\$ 9.000.000.000,00', 'R\$ 200.000,00'];
  List valorMaximoAvaliacao = ['R\$ 9.000.000.000,00', 'R\$ 200.000,00', 'R\$ 50.000,00', 'R\$ 100.000,00'];

  List ocupadoDesocupado = [
    ['Desocupado', Colors.greenAccent],
    ['Ocupado', Colors.redAccent]
  ];

  List estado = ['SP', 'RJ', 'MA'];
  List cidade = ['São Paulo', 'Rio de Janeiro', 'Ceará'];

  Map formSubmit = {
    'tipoleilao': ' ',
    'proposta': ' ',
    'tipo': ' ',
    'valor_minimo_venda': ' ',
    'valor_maximo_avaliacao': ' ',
    'ocupado_desocupado': ' ',
    'estado': ' ',
    'cidade': ' ',
  };

  //List cores = [];
  //Palette listaCores = new Palette();
  
  @override
  initState() async {
    super.initState();

    //this.cores = listaCores.cores;
    
    FirebaseDB.getVersion().then((dataVersion) {

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

  void showTipoLeilaoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          this.valueTextTipoLeilao = value.toString();
        });
      }
    });
  }

  void showPropostaDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          this.valueTextProposta = value.toString();
        });
      }
    });
  }

  void showTipoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          this.valueTextTipo = value.toString();
        });
      }
    });
  }


  void showOcupadoDesocupadoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          this.valueOcupadoDesocupado = value.toString();
        });
      }
    });
  }

  List<Widget> buildListaTipoLeilao(list) {
    this.listaTipoLeilao = [];
    for(var item in list) {
      this.listaTipoLeilao.add(
        new DialogItem(
          icon: Icons.brightness_1,            
          text: item[0],
          color: item[1],
          onPressed: () {
            this.formSubmit['tipoleilao'] = item[0];
            Navigator.pop(context, item[0]);
          }
        ),
      );
    }
    return this.listaTipoLeilao;
  }

  List<Widget> buildListaPropostas(list) {
    this.listaProposta = [];
    for(var item in list) {
      this.listaProposta.add(
        new DialogItem(
          icon: Icons.brightness_1,            
          text: item[0],
          color: item[1],
          onPressed: () {
            this.formSubmit['proposta'] = item[0];
            Navigator.pop(context, item[0]);
          }
        ),
      );
    }
    return this.listaProposta;
  }

  List<Widget> buildListaTipo(list) {
    this.listaTipo = [];
    for(var item in list) {
      this.listaTipo.add(
        new DialogItem(
          icon: Icons.brightness_1,            
          text: item[0],
          color: item[1],
          onPressed: () {
            this.formSubmit['tipo'] = item[0];
            Navigator.pop(context, item[0]);
          }
        ),
      );
    }
    return this.listaTipo;
  }

  List<Widget> buildListaOcupadoDesocupado(list) {
    this.listaOcupadoDesocupado = [];
    for(var item in list) {
      this.listaOcupadoDesocupado.add(
        new DialogItem(
          icon: Icons.brightness_1,            
          text: item[0],
          color: item[1],
          onPressed: () {
            this.formSubmit['ocupado_desocupado'] = item[0];
            Navigator.pop(context, item[0]);
          }
        ),
      );
    }
    return this.listaOcupadoDesocupado;
  }

  void onSubmit(List lista) {
    String result = lista[0];
    String tipoLista = lista[1];    
    setState(() {
      if(tipoLista == 'Valor Mínimo de Venda') {
        this.valueTextVMVenda = result;
        this.formSubmit['valor_minimo_venda'] = result;
      } else if(tipoLista == 'Valor Máximo de Avaliação') {
        this.valueTextVMAvaliacao = result;
        this.formSubmit['valor_maximo_avaliacao'] = result;
      } else if(tipoLista == 'Estado') {
        this.valueTextEstado = result;
        this.formSubmit['estado'] = result;
      } else if(tipoLista == 'Cidade') {
        this.valueTextCidade = result;
        this.formSubmit['cidade'] = result;
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Leilões de Imóveis da Caixa'),
        backgroundColor: new Color(0xFF1387b3),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              labelText: 'Tipo de Leilão',
              valueText: this.valueTextTipoLeilao,
              valueStyle: valueStyle,
              onPressed: () {
                showTipoLeilaoDialog<String>(
                  context: context,
                  child: new SimpleDialog(
                    title: const Text('Tipos de Leilões'),
                    children: buildListaTipoLeilao(this.leilaoTipo)
                  )
                );
              },
              onPressed2: () {
                setState(() {
                  this.valueTextTipoLeilao = ' ';
                  this.formSubmit['tipoleilao'] = ' ';
                });
              }
            ),
          ),

          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              labelText: 'Aberto para proposta',
              valueText: this.valueTextProposta,
              valueStyle: valueStyle,
              onPressed: () {
                showPropostaDialog<String>(
                  context: context,
                  child: new SimpleDialog(
                    title: const Text('Aberto para proposta'),
                    children: buildListaPropostas(this.proposta)
                  )
                );
              },
              onPressed2: () {
                setState(() {
                  this.valueTextProposta = ' ';
                  this.formSubmit['proposta'] = ' ';
                });
              }
            ),
          ),

          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              labelText: 'Tipo de Imóvel',
              valueText: this.valueTextTipo,
              valueStyle: valueStyle,
              onPressed: () {
                showTipoDialog<String>(
                  context: context,
                  child: new SimpleDialog(
                    title: const Text('Tipos de Imóveis'),
                    children: buildListaTipo(this.tipoImoveis)
                  )
                );
              },
              onPressed2: () {
                setState(() {
                  this.valueTextTipo = ' ';
                  this.formSubmit['tipo'] = ' ';
                });
              }
            ),
          ),

          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              labelText: 'Valor Mínimo de Venda',
              valueText: this.valueTextVMVenda,
              valueStyle: valueStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  child: new MyForm(onSubmit: onSubmit, rolamento: valorMinimoVenda, tipoLista: 'Valor Mínimo de Venda')
                );
              },
              onPressed2: () {
                setState(() {
                  this.valueTextVMVenda = ' ';
                  this.formSubmit['valor_minimo_venda'] = ' ';
                });
              }
            ),
          ),

          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              labelText: 'Valor Máximo de Avaliação',
              valueText: this.valueTextVMAvaliacao,
              valueStyle: valueStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  child: new MyForm(onSubmit: onSubmit, rolamento: valorMaximoAvaliacao, tipoLista: 'Valor Máximo de Avaliação')
                );
              },
              onPressed2: () {
                setState(() {
                  this.valueTextVMAvaliacao = ' ';
                  this.formSubmit['valor_maximo_avaliacao'] = ' ';
                });
              }
            ),
          ),

          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              labelText: 'Situação',
              valueText: this.valueOcupadoDesocupado,
              valueStyle: valueStyle,
              onPressed: () {
                showOcupadoDesocupadoDialog<String>(
                  context: context,
                  child: new SimpleDialog(
                    title: const Text('Situação'),
                    children: buildListaOcupadoDesocupado(this.ocupadoDesocupado)
                  )
                );
              },
              onPressed2: () {
                setState(() {
                  this.valueOcupadoDesocupado = ' ';
                  this.formSubmit['ocupado_desocupado'] = ' ';
                });
              }
            ),
          ),

          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              labelText: 'Estado',
              valueText: this.valueTextEstado,
              valueStyle: valueStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  child: new MyForm(onSubmit: onSubmit, rolamento: estado, tipoLista: 'Estado')
                );
              },
              onPressed2: () {
                setState(() {
                  this.valueTextEstado = ' ';
                  this.formSubmit['estado'] = ' ';
                });
              }
            ),
          ),

          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              labelText: 'Cidade',
              valueText: this.valueTextCidade,
              valueStyle: valueStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  child: new MyForm(onSubmit: onSubmit, rolamento: cidade, tipoLista: 'Cidade')
                );
              },
              onPressed2: () {
                setState(() {
                  this.valueTextCidade = ' ';
                  this.formSubmit['cidade'] = ' ';
                });
              }
            ),
          ),
          
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

      print(staticMapProvider.getStaticUri(
      new Location(this.latitude, this.longitude),
      20, width: 900, height: 400).toString() +
      "&markers=color:red|label:" + this.label +"|" + this.latitude.toString() + "," + this.longitude.toString());

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

class InputDropdown3 extends StatelessWidget {
  const InputDropdown3({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
    this.onPressed2 }) : super(key: key);
 
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final VoidCallback onPressed2;
  final Widget child;
 
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new Stack(
        children: <Widget>[
          new InputDecorator(
            decoration: new InputDecoration(
              labelText: labelText,
              isDense: true,
            ),
            baseStyle: valueStyle,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(valueText, style: valueStyle),
              ],
            ),
          ),
          valueText == " " ? new Container() :
          new Positioned.fill(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  child: new GestureDetector(
                    onTap: onPressed2,
                    child: new Container(
                      margin: new EdgeInsets.only(top: 12.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                            child: new Icon(
                              Icons.cancel,
                              size: 18.0,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class DialogItem extends StatelessWidget {
  DialogItem({ Key key, this.icon, this.size, this.color, this.text, this.onPressed }) : super(key: key);
 
  final IconData icon;
  double size = 36.0;
  final Color color;
  final String text;
  final VoidCallback onPressed;
 
  @override
  Widget build(BuildContext context) {
    return new SimpleDialogOption(
      onPressed: onPressed,
      child: new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(              
              child: new Container(
                margin: size == 16.0 ? new EdgeInsets.only(left: 7.0) : null,
                child: new Icon(icon, size: size, color: color),
              )
            ),
            new Padding(
              padding: size == 16.0 ? const EdgeInsets.only(left: 17.0) : const EdgeInsets.only(left: 16.0),
              child: new Text(text),
            ),
          ],
        ),
      )
    );
  }
}

typedef void MyFormCallback(List result);

class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;
  List rolamento;
  String tipoLista;

  MyForm({this.onSubmit, this.rolamento, this.tipoLista});

  @override
  _MyFormState createState() => new _MyFormState(this.rolamento, this.tipoLista);
}

class _MyFormState extends State<MyForm> {
  _MyFormState(this.rolamento, this.tipoLista);
  List rolamento;
  String tipoLista;
  int _currentValue = 3;

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text(this.tipoLista),
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextPicker(
              initialValue: _currentValue,
              listName: this.rolamento,
              onChanged: (newValue) =>
                setState(() => _currentValue = newValue)
            ),
          ],
        ),


        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
              widget.onSubmit([rolamento[_currentValue], tipoLista]);
          },
          child: new Container(
            margin: new EdgeInsets.only(right: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  "OK",
                  style: new TextStyle(
                    fontSize: 16.0
                  ),
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}