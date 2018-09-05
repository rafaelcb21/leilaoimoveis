import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:map_view/map_view.dart';
import 'dbfirebase.dart';
import 'textpicker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:queries/collections.dart';
//import 'mapa.dart';
import 'querys.dart';
import 'localizacao.dart';
import 'dbsqlite.dart';
//import 'favoritos.dart';
import 'help.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

//https://marcinszalek.pl/flutter/firebase-database-flutter-weighttracker/
//https://github.com/MSzalek-Mobile/weight_tracker/tree/v0.3
//https://github.com/flutter/plugins/blob/master/packages/firebase_database/example/lib/main.dart
//https://stackoverflow.com/questions/46236231/store-data-to-models-from-firebase-in-flutter
//https://codelabs.developers.google.com/codelabs/flutter-firebase/#10
//https://github.com/apptreesoftware/flutter_google_map_view/tree/master/example
//https://github.com/matthewtsmith/flutter_map_demo
//https://gist.github.com/branflake2267/ea80ce71179c41fdd8bbdb796ca889f4


//final analytics = new FirebaseAnalytics();
var apiKey = "xxxxxx";

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
  DatabaseClient db = new DatabaseClient();
  //MapView mapView = new MapView();
  //var compositeSubscription = new CompositeSubscription();
  Color azul = new Color(0xFF1387b3);
  Color azulCeleste = new Color(0xFF1667A6);
  //double latitude = -15.794229;
  //double longitude = -47.882166;
  //List coordenadas = [];
  //List<Marker> marcadores = [];

  int page = 2; //formulario
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
  //String label = '';
  //Uri staticMapUri;
  //var staticMapProvider = new StaticMapProvider(apiKey);
  //bool mapaImovel = false;

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
  List allRealState = [];

  List<Marker> marcadores = [];
  var compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new StaticMapProvider(apiKey);
  MapView mapView = new MapView();
  Localizacao localizacao = new Localizacao();
  double latitude = -15.794229;
  double longitude = -47.882166;
  List coordenadas = [];  
  String uuidRandom = '';
  String caucao = '0.0';
  String maisinfo = '';
  String vendido = '';
  String favoritoInit = '';
  String label = '';
  bool mapaImovel = false;
  bool favorito = false;
  var uuid = new Uuid();

  //File jsonFile;
  //Directory dir;
  //String fileName = "db.json";
  //bool fileExists = false;
  //Map<String, List> fileContent;

  List leilaoTipo = [];

  List proposta = [
    ['Sim', Colors.greenAccent],
    ['Não', Colors.redAccent]
  ];

  List tipoImoveis = [];
  List valorMinimoVenda = [];
  List valorMaximoAvaliacao = [];
  List ocupadoDesocupado = [];
  List leiloes = [];
  Map dictEstadosCidades = {};
  List estado = [];
  List cidade = [];
  List<Widget> listaFavoritos = [];
  List dadosFavoritos = [];

  Map formSubmit = {
    'tipoleilao': ' ',
    'proposta': ' ',
    'tipo': ' ',
    'valor_minimo_venda': '0.0',
    'valor_maximo_avaliacao': '0.0',
    'ocupado_desocupado': ' ',
    'estado': ' ',
    'cidade': ' ',
  };

  Versao versaoDB = new Versao();
  Imovel imovelDB = new Imovel();

  //void createFile(Map<String, List> content, Directory dir, String fileName) {
  //  print("Creating file!");
  //  File file = new File(dir.path + "/" + fileName);
  //  file.createSync();
  //  fileExists = true;
  //  file.writeAsStringSync(json.encode(content));
  //}

  //void writeToFile(String key, List value) {
  //  //print("Writing to file!");
  //  Map<String, List> content = {key: value};
  //  //if (fileExists) {
  //  //  print("File exists");
  //  //  Map<String, List> jsonFileContent = json.decode(jsonFile.readAsStringSync());
  //  //  jsonFileContent.addAll(content);
  //  //  jsonFile.writeAsStringSync(json.encode(jsonFileContent));
  //  //} else {
  //  //  print("File does not exist!");
  //    createFile(content, dir, fileName);
  //  //}
  //  //this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
  //  //print(fileContent);
  //}

  buildList(List lista) {
    List x = [];
    List listaSemDuplicados = new Collection(lista).distinct().toList();
    for(var item in listaSemDuplicados) {
      x.add([item, azul]);
    }
    return x;
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

  String numeroBrasil(List<int> numerosLista){
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

  void criandoListasForm(List imoveis) {
    List estados = [];
    List tiposImoveis = [];
    List tipoLeilao = [];
    List situacaoLista = [];
    List valorVenda = [];
    List valorAvaliacao = [];
    List leiloes = [];

    for(var item in imoveis) {
      estados.add(item['estado']);
      tipoLeilao.add(item['tipo_leilao']);
      tiposImoveis.add(item['tipo']);
      situacaoLista.add(item['situacao']);
      valorVenda.add(double.parse(item['vlr_de_venda']));
      valorAvaliacao.add(double.parse(item['vlr_de_avaliacao']));
      leiloes.add(item['leilao']);
    }

    // criando a lista de estados e o dicionario estado->cidades
    this.estado = new Collection(estados).distinct().toList();
    for(var item in this.estado) {
      this.dictEstadosCidades[item] = [];
    }
    for(var item in imoveis) {
      this.dictEstadosCidades[item['estado']].add(item['cidade']);
    }
    void iterateMapEntry(key, value) {
      this.dictEstadosCidades[key] = new Collection(value).distinct().toList();
    }
    this.dictEstadosCidades.forEach(iterateMapEntry);

    // Cria lista de tipos de leilões
    this.tipoImoveis = buildList(tiposImoveis);           

    // Criando lista de tipos de imóveis
    this.leilaoTipo = buildList(tipoLeilao);

    // Criando a lista da situação do imóvel: Ocupado ou Desocupado
    this.ocupadoDesocupado = buildList(situacaoLista);

    // Criando lista de tipos de imóveis
    this.leiloes = buildList(leiloes);

    // Criando a lista de valor minimo de venda
    valorVenda.sort();
    double x = valorVenda.first;
    double y = valorVenda.last;
    List vmvenda = [x.toStringAsFixed(2)];
    
    while(x < y) {
      x = x + 50000.0;
      vmvenda.add(x.toStringAsFixed(2));
    }
    for(var item in vmvenda) {
      List numerosString = item.toString().split('');
      List numerosInt = [];
      for(var i in numerosString) {                
        if(i != '.') {
          numerosInt.add(int.parse(i));
        }
      }
      String numerosBrasileirados = 'R\$ ' + numeroBrasil(numerosInt);
      this.valorMinimoVenda.add(numerosBrasileirados);
    }

    // Criando a lista de valor maximo de avaliação
    valorAvaliacao.sort();
    double x1 = valorAvaliacao.first;
    double y1 = valorAvaliacao.last;
    List vmavaliacao = [x1.toStringAsFixed(2)];
    
    while(x1 < y1) {
      x1 = x1 + 50000.0;
      vmavaliacao.add(x1.toStringAsFixed(2));
    }
    for(var item in vmavaliacao) {
      List numerosString = item.toString().split('');
      List numerosInt = [];
      for(var i in numerosString) {                
        if(i != '.') {
          numerosInt.add(int.parse(i));
        }
      }
      String numerosBrasileirados = 'R\$ ' + numeroBrasil(numerosInt);
      this.valorMaximoAvaliacao.add(numerosBrasileirados);
    }
  }

  @override
  initState() {
    super.initState();
    db.create();
    Localizacao localizacao = new Localizacao();
    localizacao.initPlatformState();

    this.formSubmit['proposta'] = this.proposta[0][0]; // Sim

    FirebaseDB.getImoveisFB().then((dataImoveis) {      
      int versionFirebase = int.parse(dataImoveis.imoveis[0]['versao']);
      versaoDB.getVersao().then(
        (data) {
          if(versionFirebase > data) {
            imovelDB.deleteImoveisVersion().then((data) {
              versaoDB.insertVersao(versionFirebase);
              imovelDB.insertImoveis(dataImoveis.imoveis).then((resultado) {
                imovelDB.insertFavoritoNovamente().then((imoveisBanco) {
                  this.allRealState = imoveisBanco;
                });
              });
              criandoListasForm(dataImoveis.imoveis);
            });
          } else if(versionFirebase == data) {
            imovelDB.getImoveis().then((imoveisBanco) {
              this.allRealState = imoveisBanco;
            });
            criandoListasForm(dataImoveis.imoveis);
          }
        }
      );
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

  void showErroDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          
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

  List<Widget> buildFavoritos(data) {
    this.marcadores = [];
    this.listaFavoritos = [];

    for(var item in data) {
      var info =
        item['tipo'] + '|' +
        item['situacao'] + '|' +
        item['vlr_de_avaliacao'].toString() + '|' +
        item['vlr_de_venda'].toString() + '|' +
        item['endereco'] + '|' +
        item['bairro'] + '|' +
        item['descricao'] + '|' +
        item['id_no_leilao'] + '|' +
        item['leilao'] + '|' +
        item['num_do_bem'] + '|' +
        item['uuid'] + '|' +
        item['caucao'] + '|' +
        item["maisinfo"] + '|' +
        item["vendido"];

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
          id: item['id_no_leilao'],
          leilao: item['leilao'],
          num_do_bem: item['num_do_bem'],
          uuidRandom: item['uuid'],
          latitude: item['latitude'],
          longitude: item['longitude'],
          caucao: item['caucao'],
          maisinfo: item['maisinfo'],
          vendido: item['vendido'],
          onPressed: () {
            imovelDB.updateFavorito(item['uuid'], item['id_no_leilao'], "Não").then((data1) {
              imovelDB.getAllFavorito().then((data) {
                setState(() {
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
                  String caucao = '0.0';
                  String maisinfo = '';
                  String vendido = '';

                  for(var item2 in data) {
                    tipo = item2['tipo'];
                    situacao = item2['situacao'];
                    vlr_de_avaliacao = item2['vlr_de_avaliacao'];
                    vlr_de_venda = item2['vlr_de_venda'];
                    endereco = item2['endereco'];
                    bairro = item2['bairro'];
                    descricao = item2['descricao'];
                    id = item2['id'].toString();
                    leilao = item2['leilao'];
                    num_do_bem = item2['num_do_bem'];
                    uuidRandom = item2['uuid'];
                    latitude = item2['latitude'];
                    longitude = item2['longitude'];
                    caucao = item2['caucao'];
                    maisinfo = item2['maisinfo'];
                    vendido = item2['vendido'];

                    var info2 =
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
                      uuidRandom + '|' +
                      caucao + '|' +
                      maisinfo + '|' +
                      vendido;

                    if(vendido == 'Não') {
                      this.marcadores.add(
                        new Marker(item2['id'].toString(), info2, latitude, longitude, color: new Color(0xFFF7941E))
                      );
                    } else {
                      this.marcadores.add(
                        new Marker(item2['id'].toString(), info2, latitude, longitude, color: Colors.red)
                      );
                    }
                  }
                });
              });
            });
          },
        )
      );

      if(item['vendido'] == 'Não') {
        this.marcadores.add(
          new Marker(item['id_no_leilao'], info, item['latitude'], item['longitude'], color: new Color(0xFFF7941E))
        );
      } else {
        this.marcadores.add(
          new Marker(item['id_no_leilao'], info, item['latitude'], item['longitude'], color: Colors.red)
        );
      }      
    }

    this.listaFavoritos.add(
      new Container(
        margin: new EdgeInsets.all(16.0),
      ), 
    );

    //this.listaFavoritos.add(
    //  new InkWell(
    //    onTap: () {
    //      //this.favorito = false;
    //      _mapa(3);
    //    },
    //    child: new Container(
    //      margin: new EdgeInsets.only(top:8.0, bottom: 8.0, left: 8.0, right: 8.0),
    //      decoration: new BoxDecoration(
    //        color: new Color(0xFFF7941E),
    //        borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
    //        boxShadow: [
    //          const BoxShadow(offset: const Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: const Color(0x33000000)),
    //          const BoxShadow(offset: const Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: const Color(0x24000000)),
    //          const BoxShadow(offset: const Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: const Color(0x1F000000)),
    //        ]
    //      ),
    //      child: new Row(
    //        mainAxisAlignment: MainAxisAlignment.center,
    //        children: <Widget>[
    //          new Container(
    //            padding: new EdgeInsets.only(top: 18.0, bottom: 18.0),
    //            child: new Text(
    //              'Mapa',
    //              style: new TextStyle(
    //                color: Colors.white,
    //                fontFamily: "Futura",
    //                fontSize: 18.0
    //              ),
    //            ),
    //          )
    //        ],
    //      ),
    //    ),
    //  ),
    //);

    this.listaFavoritos.add(
      new Container(
        margin: new EdgeInsets.all(32.0),
      )
    );

    return this.listaFavoritos;
  }

  Widget escolherListView(tipo) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    const Color _kKeyUmbraOpacity = const Color(0x33000000); // alpha = 0.2
    const Color _kKeyPenumbraOpacity = const Color(0x24000000); // alpha = 0.14
    const Color _kAmbientShadowOpacity = const Color(0x1F000000); // alpha = 0.12

    if(tipo == 1) { // Favoritos
      return new ListView(
        key: new Key(uuid.v4()),
        children: buildFavoritos(this.dadosFavoritos)
      );
    }
    
    else if(tipo == 2) { // Formulario
      return new ListView(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
            child: new Text(
              'Leilões',
              style: new TextStyle(
                color: this.azulCeleste,
                fontFamily: "Futura",
                fontSize: 20.0,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              help: false,
              labelText: 'Estado *',
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
              help: false,
              labelText: 'Cidade *',
              valueText: this.valueTextCidade,
              valueStyle: valueStyle,
              onPressed: () {
                this.cidade = this.dictEstadosCidades[this.valueTextEstado];
                if(this.cidade != null) {
                  showDialog(
                    context: context,
                    child: new MyForm(onSubmit: onSubmit, rolamento: this.cidade, tipoLista: 'Cidade')
                  );
                }
              },
              onPressed2: () {
                setState(() {
                  this.valueTextCidade = ' ';
                  this.formSubmit['cidade'] = ' ';
                });
              }
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              help: true,
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
              },
              onPressed3: () {
                Navigator.of(context).push(new PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return new HelpPage();
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
              },
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              help: false,
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
              help: false,
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
              help: false,
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
                  this.formSubmit['valor_minimo_venda'] = '0.0';
                });
              }
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              help: false,
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
                  this.formSubmit['valor_maximo_avaliacao'] = '0.0';
                });
              }
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new InputDropdown3(
              help: false,
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
          new Column(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.all(12.0),
              ),
            ],
          ),
          new Column(
            children: <Widget>[              
              new InkWell(
                onTap: () {
                  if(this.formSubmit['estado'] != ' ' && this.formSubmit['cidade'] != ' ') {
                    Queryes queryResult = new Queryes();
                    setState(() {
                      List resultado = queryResult.resultadoQuery(this.formSubmit, this.allRealState);
                      marker(resultado, true);
                    });                    
                  } else {
                    showErroDialog<String>(
                      context: context,
                      child: new SimpleDialog(
                        title: const Text('Erro'),
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.only(left: 24.0),
                            child: new Row(
                              children: <Widget>[
                                new Container(
                                  margin: new EdgeInsets.only(right: 10.0),
                                  child: new Icon(
                                    Icons.error,
                                    color: const Color(0xFFE57373)),
                                ),
                                new Text(
                                  "Preencha os campos\n- Estado\n- Cidade",
                                  softWrap: true,
                                  style: new TextStyle(
                                    color: Colors.black45,
                                    fontSize: 16.0,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                  )
                                )
                              ],
                            ),
                          )
                        ]
                      )
                    );
                  }
                  
                },
                child: new Container(
                  margin: new EdgeInsets.only(top:4.0, bottom: 4.0, left: 8.0, right: 8.0),
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
                        padding: new EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: new Text(
                          'Buscar',
                          style: new TextStyle(
                            color: Colors.white,
                            fontFamily: "Futura",
                            fontSize: 16.0
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
        ],
      );
    }
    else if (tipo == 3) { // Hum Imovel
      return new ListView(
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
                        imovelDB.updateFavorito(this.uuidRandom, this.id, "Sim").then((result) {
                          Queryes queryResult = new Queryes();
                          this.allRealState = result;                      
                          List resultado = queryResult.resultadoQuery(this.formSubmit, this.allRealState);
                          marker(resultado, false);
                          //marker(result, false);
                        });
                      } else if(data == false) {
                        imovelDB.updateFavorito(this.uuidRandom, this.id, "Não").then((result) {
                          this.allRealState = result;
                          marker(result, false);
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
                  'Vendido',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  this.vendido,
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
                  'Caução',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  prepararNumeroBrasil(this.caucao.toString()),
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
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Mais informação',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  this.maisinfo,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
                ),               
                new Container(
                  margin: new EdgeInsets.all(16.0),
                ),

                //new InkWell(
                //  onTap: () {
                //    setState(() {
                //      this.favorito = false;
                //      _mapa(3);
                //    });                    
                //  },
                //  child: new Container(
                //    margin: new EdgeInsets.only(top:4.0, bottom: 4.0),
                //    decoration: new BoxDecoration(
                //      color: new Color(0xFFF7941E),
                //      borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
                //      boxShadow: [
                //        const BoxShadow(offset: const Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: _kKeyUmbraOpacity),
                //        const BoxShadow(offset: const Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
                //        const BoxShadow(offset: const Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
                //      ]
                //    ),
                //    child: new Row(
                //      mainAxisAlignment: MainAxisAlignment.center,
                //      children: <Widget>[
                //        new Container(
                //          padding: new EdgeInsets.only(top: 18.0, bottom: 18.0),
                //          child: new Text(
                //            'Mapa',
                //            style: new TextStyle(
                //              color: Colors.white,
                //              fontFamily: "Futura",
                //              fontSize: 18.0
                //            ),
                //          ),
                //        )
                //      ],
                //    ),
                //  ),
                //),
                new Container(
                  margin: new EdgeInsets.all(32.0),
                )
              ],
            ),
          )
        ],
      );
    } else { return new Container();}
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    const Color _kKeyUmbraOpacity = const Color(0x33000000); // alpha = 0.2
    const Color _kKeyPenumbraOpacity = const Color(0x24000000); // alpha = 0.14
    const Color _kAmbientShadowOpacity = const Color(0x1F000000); // alpha = 0.12

    Widget buildLeading() {      
      if(this.page == 1) {
        return new GestureDetector(
          onTap: () {
            setState(() {
              mapView.dismiss();
              this.page = 2;
            });            
          },
            child: new Icon(Icons.arrow_back)
        );
      } else if(this.page == 2) {
        return new Icon(Icons.home);
      } if(this.page == 3) {
        return new GestureDetector(
          onTap: () {
            _mapa(3);
          },
            child: new Icon(Icons.arrow_back)
        );
      }
    }

    List<Widget> buildAction() {
      if(this.page == 1) {
        return <Widget>[
          new IconButton(
            color: Colors.white,
            icon: new Icon(Icons.map),
            onPressed: () {
              _mapa(1);
            },
          )
        ];
      } else if(this.page == 2) {
        return <Widget>[
          new IconButton(
            color: Colors.white,
            icon: new Icon(Icons.star),
            onPressed: () {
              imovelDB.getAllFavorito().then((data) {
                setState(() {
                  this.dadosFavoritos = data;
                  this.page = 1;
                });                
              });
            },
          )
        ];
      } else if( this.page == 3) {
        return <Widget>[
          new IconButton(
            color: Colors.white,
            icon: new Icon(Icons.home),
            onPressed: () {
              setState(() {
                this.page = 2;
              });                
            },
          ),
          new IconButton(
            color: Colors.white,
            icon: new Icon(Icons.star),
            onPressed: () {
              imovelDB.getAllFavorito().then((data) {
                setState(() {
                  this.dadosFavoritos = data;
                  this.page = 1;
                });                
              });
            },
          )
        ];
      }
      return <Widget>[];
    }

    Widget titulo() {
      if(this.page == 1) {
        return new Text('Favoritos');
      } else if(this.page == 2) {
        return new Text('Buscar');
      } else if(this.page == 3) {
        return new Text('Imóvel');
      }
      return new Text('');
    }

    return new Scaffold(
      appBar: new AppBar(
        title: titulo(),
        backgroundColor: this.azul,
        leading: buildLeading(),
        actions: buildAction()          
      ),
      body: escolherListView(this.page)
      
      

    );
  }

//////////////////////////////////
  

  Future _mapa(int origem) async {
    MapView mapView = new MapView();
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
      _handleDismiss(annotation, origem);
      
    });
    compositeSubscription.add(sub);

    sub = mapView.onToolbarAction.listen((id) {
      if (id == 1) {        
        setState(() {
          mapView.dismiss();
          if(origem == 3) { //Hum imovel
            this.page = 2; 
          } else if(origem == 2) { //formulario
            this.page = 2;
          } else if(origem == 1) { // favorito
            this.page = 1;
          }
        });
      }
    });
    compositeSubscription.add(sub);
   
  }

  _handleDismiss(annotation, origem) {
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
      this.caucao = informacao[11];
      this.maisinfo = informacao[12];
      this.vendido = informacao[13];
      

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
      if(origem == 3) { //Hum imovel
        this.page = 3; 
      } else if(origem == 2) { //formulario
        this.page = 3;
      } else if(origem == 1) { // favorito
        this.page = 1;
      }
      
      //this.mapaImovel = true;

    });

    mapView.dismiss();
    compositeSubscription.cancel();
  }

  void marker(data, mostrarMapa) {
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
    String caucao = '0.0';
    String maisinfo = '';
    String vendido = '';
    String favorito = '';

    for(var item2 in data) {
      tipo = item2['tipo'];
      situacao = item2['situacao'];
      vlr_de_avaliacao = item2['vlr_de_avaliacao'];
      vlr_de_venda = item2['vlr_de_venda'];
      endereco = item2['endereco'];
      bairro = item2['bairro'];
      descricao = item2['descricao'];
      id = item2['id'].toString();
      leilao = item2['leilao'];
      num_do_bem = item2['num_do_bem'];
      uuidRandom = item2['uuid'];
      latitude = item2['latitude'];
      longitude = item2['longitude'];
      caucao = item2['caucao'];
      maisinfo = item2['maisinfo'];
      vendido = item2['vendido'];
      favorito = item2['favorito'];

      var info2 =
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
        uuidRandom + '|' +
        caucao + '|' +
        maisinfo + '|' +
        vendido;

      if(favorito == 'Sim') {
        this.marcadores.add(
          new Marker(item2['id'].toString(), info2, latitude, longitude, color: new Color(0xFFF7941E))
        );
      } else if(vendido == 'Sim' && favorito == 'Não') {
        this.marcadores.add(
          new Marker(item2['id'].toString(), info2, latitude, longitude, color: Colors.red)
        );
      } else if(vendido == 'Não' && favorito == 'Não') {
        this.marcadores.add(
          new Marker(item2['id'].toString(), info2, latitude, longitude, color: Colors.blue)
        );
      }
    }

    if(mostrarMapa) {
      setState(() {
        _mapa(this.page);
      });
      
    }
    
  }



//////////////////////////////
}


/////////////////////////////
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
//////////////////////////////

class InputDropdown3 extends StatelessWidget {
  const InputDropdown3({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
    this.onPressed2,
    this.onPressed3,
    this.help}) : super(key: key);
 
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final VoidCallback onPressed2;
  final VoidCallback onPressed3;
  final Widget child;
  final bool help;
 
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
          valueText == " " ? 
          new Positioned.fill(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                !this.help ? new Container() : new Container(
                  child: new GestureDetector(
                    onTap: onPressed3,
                    child: new Container(
                      margin: new EdgeInsets.only(top: 12.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                            child: new Icon(
                              Icons.help,
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
          ) :
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
            if(rolamento.length > 0) {
              widget.onSubmit([rolamento[_currentValue], tipoLista]);
            }              
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
  final String caucao;
  final String maisinfo;
  final String vendido;
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
    this.caucao,
    this.maisinfo,
    this.vendido,
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
    return new Container(
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
                  'Vendido',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.vendido,
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
                  'Caução',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  prepararNumeroBrasil(widget.caucao.toString()),
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
                  margin: new EdgeInsets.all(8.0),
                ),

                new Text(
                  'Mais informação',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
                  widget.maisinfo,
                  style: new TextStyle(
                    fontFamily: "Futura",
                    fontSize: 16.0,
                  ),
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
