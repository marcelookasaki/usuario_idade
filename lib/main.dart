import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  recuperarBD() async {
    var caminhoBD = await getDatabasesPath();
    var localBD = join(caminhoBD, "bd.db");

    var bd = await openDatabase(localBD, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          "CREATE TABLE usuario (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
      db.execute(sql);
      print("Criou");
    });
    print("Aberto " + bd.isOpen.toString());
    return bd;
  }

  salvar() async {
    Database bd = await recuperarBD();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Marcelo Okasaki",
      "idade": 54
    };
    int id = await bd.insert("usuario", dadosUsuario);
    print("Salvo " + id.toString());
  }

  listaUsuario() async {
    Database bd = await recuperarBD();

    String consultaIdade = "SELECT * FROM usuario WHERE idade = 54";
    String listaUsuarios = "SELECT * FROM usuario";

    List usuarios = await bd.rawQuery(listaUsuarios);
    for (var usuario in usuarios) {
      print("id: " +
          usuario['id'].toString() +
          " nome: " +
          usuario['nome'] +
          " idade: " +
          usuario['idade'].toString());
    }
  }

  excluirUsuario(int id) async {
    Database bd = await recuperarBD();
    int retorno = await bd.delete("usuario", where: "id=?", whereArgs: [id]);
    print("excluído: " + retorno.toString());
  }

  atualizarUsuario(int id) async {
    Database bd = await recuperarBD();
    Map<String, dynamic> dadosUsuario = {"nome": "Mariana", "idade": 12};
    int retorno = await bd
        .update("usuario", dadosUsuario, where: "id=?", whereArgs: [id]);
    print("atualizado " + retorno.toString());
  }

  @override
  Widget build(BuildContext context) {
    //salvar();

    excluirUsuario(1);
    //atualizarUsuario(2);
    listaUsuario();
    return Container();
  }
}
