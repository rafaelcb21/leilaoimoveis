import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClient {
  Database _db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    _db = await openDatabase(dbPath, version: 1, onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute(
      """
        CREATE TABLE imovel (
          id INTEGER PRIMARY KEY,
          longitude REAL NOT NULL,
          tipo TEXT NOT NULL,
          situacao TEXT NOT NULL,
          data_inicio_proposta TEXT NOT NULL,
          vlr_de_venda TEXT NOT NULL,
          endereco TEXT NOT NULL,
          tipo_leilao TEXT NOT NULL,
          vlr_de_avaliacao TEXT NOT NULL,
          estado TEXT NOT NULL,
          id_no_leilao TEXT NOT NULL,
          versao INTEGER NOT NULL,
          latitude REAL NOT NULL,
          data_termino_proposta TEXT NOT NULL,
          cidade TEXT NOT NULL,
          bairro TEXT NOT NULL,
          uuid TEXT NOT NULL,
          descricao TEXT NOT NULL,
          num_do_bem TEXT NOT NULL,
          leilao TEXT NOT NULL,
          favorito TEXT NOT NULL,
          caucao TEXT NOT NULL,
          maisinfo TEXT NOT NULL,
          vendido TEXT NOT NULL
        )
      """
    );

    await db.execute(
      """
        CREATE TABLE version (
          id INTEGER PRIMARY KEY,
          numero INTEGER NOT NULL
        )
      """
    );
    await db.rawInsert("INSERT INTO version (numero) VALUES (0)");

  }
}

class Versao {
  Versao();
  Database db;

  int id;
  int numero;

  String versaoTable = "version";

  static final columns = ["id", "numero"];

  Map toMap() {
    Map map = {"id": id, "numero": numero};
    if (id != null) { map["id"] = id; }
    return map;
  }

  static fromMap(Map map) {
    Versao versaoTable = new Versao();
    versaoTable.id = map["id"];
    versaoTable.numero = map["numero"];
    return versaoTable;
  }

  Future getVersao() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    List results = await db.rawQuery("SELECT numero FROM version");
    await db.close();
    return results[0]['numero'];
  }

  Future insertVersao(int numero) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    await db.rawInsert("INSERT INTO version (numero) VALUES (?)", [numero]);        
    await db.close();
    return true;
  }
}

class Imovel {
  Imovel();
  Database db;

  int id;
  double longitude;
  String tipo;
  String situacao;
  String data_inicio_proposta;
  String vlr_de_venda;
  String endereco;
  String tipo_leilao;
  String vlr_de_avaliacao;
  String estado;
  String id_no_leilao;
  String versao;
  double latitude;
  String data_termino_proposta;
  String cidade;
  String bairro;
  String uuid;
  String descricao;
  String num_do_bem;
  String leilao;
  String favorito;
  String caucao;
  String maisinfo;
  String vendido;

  String imovelTable = "imovel";

  static final columns = ["id", "longitude", "tipo", "situacao", "data_inicio_proposta", 
    "vlr_de_venda", "endereco", "tipo_leilao", "vlr_de_avaliacao",
    "estado", "id_no_leilao",  "versao", "latitude", "data_termino_proposta",
    "cidade", "bairro", "uuid", "descricao", "num_do_bem", "leilao", "favorito",
    "caucao", "maisinfo", "vendido"
  ];

  Map toMap() {
    Map map = {
      "id": id,
      "longitude": longitude,
      "tipo": tipo,
      "situacao": situacao,
      "data_inicio_proposta": data_inicio_proposta,
      "vlr_de_venda": vlr_de_venda,
      "endereco": endereco,
      "tipo_leilao": tipo_leilao,
      "vlr_de_avaliacao": vlr_de_avaliacao,
      "estado": estado,
      "id_no_leilao": id_no_leilao,
      "versao": versao,
      "latitude": latitude,
      "data_termino_proposta": data_termino_proposta,
      "cidade": cidade,
      "bairro": bairro,
      "uuid": uuid,
      "descricao": descricao,
      "num_do_bem": num_do_bem,
      "leilao": leilao,
      "favorito": favorito,
      "caucao": caucao,
      "maisinfo": maisinfo,
      "vendido": vendido
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    Imovel imovelTable = new Imovel();
    imovelTable.id = map["id"];
    imovelTable.longitude = map["longitude"];
    imovelTable.tipo = map["tipo"];
    imovelTable.situacao = map["situacao"];
    imovelTable.data_inicio_proposta = map["data_inicio_proposta"];
    imovelTable.vlr_de_venda = map["vlr_de_venda"];
    imovelTable.endereco = map["endereco"];
    imovelTable.tipo_leilao = map["tipo_leilao"];
    imovelTable.vlr_de_avaliacao = map["vlr_de_avaliacao"];
    imovelTable.estado = map["estado"];
    imovelTable.id_no_leilao = map["id_no_leilao"];
    imovelTable.versao = map["versao"];
    imovelTable.latitude = map["latitude"];
    imovelTable.data_termino_proposta = map["data_termino_proposta"];
    imovelTable.cidade = map["cidade"];
    imovelTable.bairro = map["bairro"];
    imovelTable.uuid = map["uuid"];
    imovelTable.descricao = map["descricao"];
    imovelTable.num_do_bem = map["num_do_bem"];
    imovelTable.leilao = map["leilao"];
    imovelTable.favorito = map["favorito"];
    imovelTable.caucao = map["caucao"];
    imovelTable.maisinfo = map["maisinfo"];
    imovelTable.vendido = map["vendido"];
    return imovelTable;
  }

  Future deleteImoveisVersion() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    await db.rawDelete("DELETE FROM imovel");
    await db.rawDelete("DELETE FROM version");
    await db.close();
    return true;
  }

  Future getFavorito(String uuid) async {
    bool favorito = false;
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    List results = await db.rawQuery("SELECT uuid, favorito FROM imovel WHERE uuid = ?", [uuid]);
    if(results[0]['favorito'] == "Não") {
      favorito = true;
    }
    await db.close();
    return favorito;
  }

  Future getAllFavorito() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    List results = await db.rawQuery("SELECT * FROM imovel WHERE favorito = 'Sim'");
    await db.close();
    return results;
  }

  Future updateFavorito(String uuid, String valor) async {
    bool favorito = false;
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    await db.rawUpdate("UPDATE imovel SET favorito = ? WHERE uuid = ?", [valor, uuid]);
    List results = await db.rawQuery("SELECT uuid, favorito FROM imovel WHERE uuid = ?", [uuid]);
    await db.close();
    return true;
  }

  Future insertImoveis(List imoveis) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    for(var i in imoveis) {
      double longitude = i['longitude'];
      String tipo = i['tipo'];
      String situacao = i['situacao'];
      String data_inicio_proposta = i['data_inicio_proposta'];
      String vlr_de_venda = i['vlr_de_venda'];
      String endereco = i['endereco'];
      String tipo_leilao = i['tipo_leilao'];
      String vlr_de_avaliacao = i['vlr_de_avaliacao'];
      String estado = i['estado'];
      String id_no_leilao = i['id'];
      String versao = i['versao'];
      double latitude = i['latitude'];
      String data_termino_proposta = i['data_termino_proposta'];
      String cidade = i['cidade'];
      String bairro = i['bairro'];
      String uuid = i['uuid'];
      String descricao = i['descricao'];
      String num_do_bem = i['num_do_bem'];
      String leilao = i['leilao'];
      String favorito = i['favorito'];
      String caucao = i['caucao'];
      String maisinfo = i['maisinfo'];
      String vendido = i['vendido'];

      await db.rawInsert('''
        INSERT INTO imovel (
          longitude,
          tipo,
          situacao,
          data_inicio_proposta,
          vlr_de_venda,
          endereco,
          tipo_leilao,
          vlr_de_avaliacao,
          estado,
          id_no_leilao,
          versao,
          latitude,
          data_termino_proposta,
          cidade,
          bairro,
          uuid,
          descricao,
          num_do_bem,
          leilao,
          favorito,
          caucao,
          maisinfo,
          vendido
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Não', ?, ?, ?)
      ''', 
        [
          longitude, tipo, situacao, data_inicio_proposta,
          vlr_de_venda, endereco, tipo_leilao, vlr_de_avaliacao,
          estado, id_no_leilao, versao, latitude, data_termino_proposta,
          cidade, bairro, uuid, descricao, num_do_bem, leilao, caucao, maisinfo,
          vendido
        ]
      );

    }      
    await db.close();
    return true;
  }
}

