import 'dart:io';

import 'package:flutter/material.dart';
import 'package:how_to/helper/sqlite_helper.dart';
import 'package:how_to/screens/adicionar_contato.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //Adicione neste ponto do código o SQLiteOpenHelper
  final SQLiteOpenHelper helper = SQLiteOpenHelper();

  //Crie uma lista para armazenar os dados vindos do banco de dados.
  List<Contato> listContatos = List();

  @override
  void initState() {
    obterTodosContatos();
    super.initState();
  }

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Contacts'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                _exibirPaginaContato(contato: listContatos[index]);
                print("da esquerda para a direita");
              }
              if (direction == DismissDirection.endToStart) {
                helper.delete(listContatos[index].id);
                print("da direita para a esquerda ");
              }
            },
            child: GestureDetector(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: listContatos[index].caminhoImagem != null
                                ? FileImage(
                                    File(listContatos[index].caminhoImagem))
                                : AssetImage('images/images_social.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listContatos[index].nome,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            Text(
                              listContatos[index].email,
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              listContatos[index].telefone,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                _exibirPaginaContato(contato: listContatos[index]);
              },
            ),
          );
        },
        itemCount: listContatos.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _exibirPaginaContato();
        },
      ),
    );
  }

  _exibirPaginaContato({Contato contato}) async {
    final retornoContato = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdicionarContatoScreen(contato: contato)));

    if (retornoContato != null) {
      if (contato != null) {
        await helper.update(retornoContato);
      } else {
        await helper.insert(retornoContato);
      }
      obterTodosContatos();
    }
  }

  obterTodosContatos() {
    helper
        .findAll()
        .then((list) => setState(() {
              listContatos = list;
            }))
        .catchError((error) {
      print('Erro ao recuperar contatos: ${error.toString()}');
    });
  }
}
