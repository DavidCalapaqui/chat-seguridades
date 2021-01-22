import 'package:chat_sanchez_calapaqui/login.dart';
import 'package:chat_sanchez_calapaqui/probarCryto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class NuevoContacto extends StatefulWidget {
  final DocumentSnapshot doc;

  const NuevoContacto({Key key, this.doc}) : super(key: key);
  @override
  _NuevoContactoState createState() => _NuevoContactoState();
}

class _NuevoContactoState extends State<NuevoContacto> {
  bool _obscure = true;
  final _correoController = TextEditingController();
  String buscar="";
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
                                              "Nuevo Contacto",
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
                                        controller: _correoController,
                                        decoration: InputDecoration(
                                            icon: Icon(
                                              Icons.mail,
                                              color: Colors.grey,
                                            ),
                                            hintText: "E-mail"),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            if(_correoController.text.length>3&&_correoController.text.contains("@")){
                                              setState(() {
                                                buscar=_correoController.text;
                                              });

                                            }else{
                                              Toast.show(
                                                  "El correo debe tener al menos 3 caracteres\n\ny tener formato de correo @",
                                                  context,
                                                  duration: Toast
                                                      .LENGTH_LONG,
                                                  gravity: Toast
                                                      .CENTER);
                                            }
                                          },
                                          color: Colors.green,
                                          child: Row(
                                            children: [
                                              Expanded(child: Container()),
                                              Text(
                                                "Buscar",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        ),
                                      ),
                                      buscar.length>=3?StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('usuarios').where("correo",isEqualTo: buscar).snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data.docs.length != 0) {
                                              DocumentSnapshot docC=snapshot.data.docs[0];
                                              return StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance
                                                    .collection('contactos').snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    if (snapshot.data.docs.length != 0) {
                                                      DocumentSnapshot auxDoc;
                                                      bool encontro=false;
                                                      for(int i=0;i<snapshot.data.docs.length;i++){
                                                        if((snapshot.data.docs[i]['usuario1']==widget.doc.id&&snapshot.data.docs[i]['usuario2']==docC.id)||(snapshot.data.docs[i]['usuario2']==widget.doc.id&&snapshot.data.docs[i]['usuario1']==docC.id)){
                                                          encontro=true;
                                                        }
                                                      }
                                                      return !encontro?Column(
                                                          children: snapshot.data.docs
                                                              .map((doc) => _buildChat(docC))
                                                              .toList()):Padding(
                                                        padding: const EdgeInsets.all(18.0),
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                          ),
                                                          elevation: 15,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Container(
                                                              width: double.infinity,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  Icon(Icons.sentiment_dissatisfied),
                                                                  Text(
                                                                    'El usuario ya es uno de sus contactos',
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(18.0),
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                          ),
                                                          elevation: 15,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Container(
                                                              width: double.infinity,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  Icon(Icons.sentiment_dissatisfied),
                                                                  Text(
                                                                    'No hay contactos registrados para chatear\n agrega a tus amigos',
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );

                                                    }
                                                  } else {
                                                    return Padding(
                                                      padding: const EdgeInsets.all(18.0),
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                        ),
                                                        elevation: 15,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Container(
                                                            width: double.infinity,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Icon(Icons.sentiment_dissatisfied),
                                                                Text(
                                                                  'No hay contactos registrados para chatear\n agrega a tus amigos',
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            } else {
                                              return Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  elevation: 15,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Icon(Icons.sentiment_dissatisfied),
                                                          Text(
                                                            'No hay ningún usuario con es correo',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
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
                                      ):Container()
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
  _registrar(DocumentSnapshot item){
    FirebaseFirestore.instance.collection("contactos").add({
      "fechaUltimo":DateTime.now(),
      "ultimo":Encriptar(" "),
      "nombre1":widget.doc['nombre'],
      "usuario1":widget.doc.id,
      "nombre2":item['nombre'],
      "usuario2":item.id,
    });
    Toast.show(
        "Contacto Creado Exitosamente!!!!!",
        context,
        duration: Toast
            .LENGTH_LONG,
        gravity: Toast
            .CENTER);
    Navigator.of(context).pop();
  }
  Widget _buildChat(DocumentSnapshot doc){
    return ListTile(
        onTap: (){
          _registrar(doc);
        },
        leading: Icon(Icons.account_circle_outlined,color: Colors.grey,size: 45,),
        title: Text(doc['nombre'],style: TextStyle(fontWeight: FontWeight.w700),),
    );
  }
}
