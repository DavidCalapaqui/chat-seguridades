import 'dart:convert';

import 'package:chat_sanchez_calapaqui/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscure = true, acepta=true;
  final _correoController = TextEditingController();
  final _claveController = TextEditingController();
  final _nombreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: SizedBox(
                            width: 300,
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.pink,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(child: Container()),
                                        Text(
                                          "Registro de usuario",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 22),
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: _nombreController,
                                        decoration: InputDecoration(
                                            icon: Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                            ),
                                            hintText: "Nombre(s) y Apellido(s)"),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: _correoController,
                                        decoration: InputDecoration(
                                            icon: Icon(
                                              Icons.mail,
                                              color: Colors.grey,
                                            ),
                                            hintText: "E-mail"),
                                      ),
                                      SizedBox(
                                        height: 20,
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
                                            if(_nombreController.text.length>3&&_correoController.text.length>3&&_correoController.text.contains("@")&&_claveController.text.length>3){
                                            if(acepta){
                                              _registrar();}else{
                                              Toast.show(
                                                  "Acepte los términos y condiciones para continuar",
                                                  context,
                                                  duration: Toast
                                                      .LENGTH_LONG,
                                                  gravity: Toast
                                                      .CENTER);
                                            }

                                            }else{
                                              Toast.show(
                                                  "los campos deben tener al menos 3 caracteres respectivamente",
                                                  context,
                                                  duration: Toast
                                                      .LENGTH_LONG,
                                                  gravity: Toast
                                                      .CENTER);
                                            }
                                          },
                                          color: acepta?Colors.green:Colors.grey,
                                          child: Row(
                                            children: [
                                              Expanded(child: Container()),
                                              Text(
                                                "Registrarse",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            acepta=!acepta;
                                          });
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(acepta?Icons.check_box:Icons.check_box_outline_blank,color: acepta?Colors.green:Colors.grey,),
                                            Expanded(child: RichText(
                                              textAlign: TextAlign.justify,
                                              text: TextSpan(

                                                text: 'Acepto los ',
                                                style: TextStyle(
                                                    color: Colors.black,),

                                                children: <TextSpan>[
                                                  TextSpan(text: "Términos y Condiciones",
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        decoration: TextDecoration.underline,
                                                      )),

                                                  TextSpan(text: ' y autorizo el uso de mis datos de acuerdo a la '),
                                                  TextSpan(text: "Declaración de Privacidad",
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        decoration: TextDecoration.underline,
                                                      )),
                                                ],
                                              ),
                                            ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
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
                          style: TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
  _registrar(){
    var key = utf8.encode('seguridades2064');
    var bytes = utf8.encode(_claveController.text);
    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);
    FirebaseFirestore.instance.collection("usuarios").add({
      "nombre":_nombreController.text,
      "correo":_correoController.text,
      "clave":digest.toString()
    });

    Toast.show(
        "Usuario Creado Exitosamente!!!!!",
        context,
        duration: Toast
            .LENGTH_LONG,
        gravity: Toast
            .CENTER);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        Login(usuario: _correoController.text,clave: _claveController.text,)), (Route<dynamic> route) => false);
  }
}
