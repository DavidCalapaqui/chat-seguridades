import 'dart:convert';

import 'package:chat_sanchez_calapaqui/chats.dart';
import 'package:chat_sanchez_calapaqui/probarCryto.dart';
import 'package:chat_sanchez_calapaqui/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final String usuario;
  final String clave;

  const Login({Key key, this.usuario="", this.clave=""}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscure = true;
  final _correoController = TextEditingController();
  final _claveController = TextEditingController();
  String claveEncriptada="";

  @override
  void initState() {
    // TODO: implement initState
    var key = utf8.encode('seguridades2064');
    var bytes = utf8.encode(widget.clave);
    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);
    setState(() {
      claveEncriptada=digest.toString();
    });
    print(claveEncriptada);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios').where("correo",isEqualTo: widget.usuario).where("clave",isEqualTo: claveEncriptada).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length != 0) {
              return Chats(Usuario: snapshot.data.docs[0]);
            } else {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img/vbanner.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      width: 250,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 100,
                                            child: Image.asset(
                                              "assets/img/logo.png",
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            "Iniciar Sesión",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          TextField(
                                            controller: _correoController,
                                            decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.account_circle,
                                                  color: Colors.grey,
                                                ),
                                                hintText: "E-mail"),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          TextField(
                                            controller: _claveController,
                                            obscureText: _obscure,
                                            decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.lock,
                                                  color: Colors.grey,
                                                ),
                                                suffixIcon: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _obscure = !_obscure;
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.grey,
                                                    )),
                                                hintText: "Contraseña"),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              onPressed: () {
                                                _ingresar();
                                              },
                                              color: Colors.pink,
                                              child: Row(
                                                children: [
                                                  Expanded(child: Container()),
                                                  Text(
                                                    "ENTRAR",
                                                    style:
                                                    TextStyle(color: Colors.white),
                                                  ),
                                                  Expanded(child: Container()),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(child: Container()),
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignUp()),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Registrarse",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      decoration:
                                                      TextDecoration.underline,
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 12,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.pink,
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                Text(
                                  "© 2021 Dair Sánchez - David Calapaqui",
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                ),
                                Expanded(child: Container()),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              );

            }
          } else {
            return Padding(
                padding: const EdgeInsets.all(40.0),
                child: SizedBox(width:60,child: AspectRatio(aspectRatio: 1,child: CircularProgressIndicator()))
            );
          }
        },
      )
    );
  }
  _ingresar(){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        Login(usuario: _correoController.text,clave: _claveController.text,)), (Route<dynamic> route) => false);
  }
}