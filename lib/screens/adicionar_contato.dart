// ignore: avoid_web_libraries_in_flutter
import 'dart:io';

import 'package:how_to/helper/sqlite_helper.dart';
import 'package:how_to/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdicionarContatoScreen extends StatefulWidget {
  @override
  _AdicionarContatoScreenState createState() => _AdicionarContatoScreenState();
  final Contato contato;
  AdicionarContatoScreen({this.contato});
}

class _AdicionarContatoScreenState extends State<AdicionarContatoScreen> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  Contato contatoEdicao;
  final ImagePicker imagePicker = ImagePicker();
  PickedFile _caminhoImagem;

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {
      contatoEdicao = Contato();
    } else {
      contatoEdicao = Contato.fromMap(widget.contato.toMap());
      nomeController.text = contatoEdicao.nome;
      emailController.text = contatoEdicao.email;
      telefoneController.text = contatoEdicao.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionat Contato'),
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          SizedBox(height: 20),
          GestureDetector(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: contatoEdicao.caminhoImagem != null
                      ? FileImage(File(contatoEdicao.caminhoImagem))
                      : AssetImage('images/images_social.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              /* De forma assincrona, o objeto imagePicker gerencia a abertura do aplicativo de camera selecionado,
    persiste a forografia e retorna o caminho do arquivo armazenado.
  */
              imagePicker.getImage(source: ImageSource.camera).then((value) {
                // Atualizamos os dados da tela.
                setState(() {
                  _caminhoImagem = value;
                  //Depois de armazenae globalmente a referencia do arquivo, atualizamos o atributo caminhoImagem do contato, para recupera o arquivo para exibiçao.
                  contatoEdicao.caminhoImagem = _caminhoImagem.path;
                });
              });
            },
          ),
          CustomTextField(
            hint: "Nome",
            icon: Icons.text_fields,
            controller: nomeController,
          ),
          CustomTextField(
            hint: "E-mail",
            icon: Icons.email,
            controller: emailController,
          ),
          CustomTextField(
            hint: "Telefone",
            icon: Icons.phone,
            controller: telefoneController,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.teal.shade200,
              onPressed: () {
                Contato contato = Contato(
                    nome: nomeController.text,
                    email: emailController.text,
                    telefone: telefoneController.text,
                    caminhoImagem: _caminhoImagem.path);
                if (contatoEdicao.nome != null) {
                  contato.id = contatoEdicao.id;
                }
                Navigator.pop(context, contato);
              },
              child: Text('Salvar', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
