import 'package:chat_sanchez_calapaqui/chat_mesajes.dart';
import 'package:chat_sanchez_calapaqui/editarDatos.dart';
import 'package:chat_sanchez_calapaqui/login.dart';
import 'package:chat_sanchez_calapaqui/nuevoContacto.dart';
import 'package:chat_sanchez_calapaqui/probarCryto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  final DocumentSnapshot Usuario;

  const Chats({Key key, @required this.Usuario}) : super(key: key);
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    print("Id u: ${widget.Usuario.id}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Secure Chat",style:TextStyle( color: Colors.white),),
        centerTitle: true,
        actions: [
          _Settings()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevoContacto(doc: widget.Usuario,)),
          );
        },child: Icon(Icons.person_add,color: Colors.white,),backgroundColor: Colors.pink,),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: FittedBox(fit:BoxFit.contain,child: Icon(Icons.account_circle,color: Colors.white70,)),
              accountEmail: Text(widget.Usuario['correo'],style: TextStyle(color: Colors.white,),),
              accountName: Text(widget.Usuario['nombre'],style: TextStyle(color: Colors.white,),),
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
            ),
            ListTile(
              leading: Icon(Icons.send),
              title: Text('Chats'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de...'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,color: Colors.red,),
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 15,),
          Center(child: Text("Todos tus Chats",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: Colors.blueGrey),),),
          SizedBox(height: 5,),
          Divider(),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('contactos').where("usuario1",isEqualTo: widget.Usuario.id).orderBy('fechaUltimo',descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length != 0) {
                  return Column(
                    children: [
                      Column(
                          children: snapshot.data.docs
                              .map((doc) => _buildChat(doc))
                              .toList()),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('contactos').where("usuario2",isEqualTo: widget.Usuario.id).orderBy('fechaUltimo',descending: true).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.docs.length != 0) {
                              return Column(
                                  children: snapshot.data.docs
                                      .map((doc) => _buildChat(doc))
                                      .toList());
                            } else {
                              return Container();

                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  );
                } else {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('contactos').where("usuario2",isEqualTo: widget.Usuario.id).orderBy('fechaUltimo',descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.length != 0) {
                          return Column(
                              children: snapshot.data.docs
                                  .map((doc) => _buildChat(doc))
                                  .toList());
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




                }
              } else {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('contactos').where("usuario2",isEqualTo: widget.Usuario.id).orderBy('fechaUltimo',descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length != 0) {
                        return Column(
                            children: snapshot.data.docs
                                .map((doc) => _buildChat(doc))
                                .toList());
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
                        padding: const EdgeInsets.all(40.0),
                        child: SizedBox(width:50,child: AspectRatio(aspectRatio: 1,child: CircularProgressIndicator()))
                      );
                    }
                  },
                );
              }
            },
          ),

        ],
      ),
    );
  }
  Widget _Settings() {
    print(DateTime.now().millisecondsSinceEpoch);
    print(DateTime.fromMillisecondsSinceEpoch(1611208301772));
    return new PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
          new PopupMenuItem<int>(
              value: 1, child: new Text('Editar mis Datos')),
          new PopupMenuItem<int>(
              value: 2, child: new Text('Cerrar Sesión')),
        ],
        onSelected: (int value) {
if(value==1){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditarDatos(doc:widget.Usuario)),
  );
}else if(value==2){
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      Login(usuario: "",clave: "",)), (Route<dynamic> route) => false);
}
        });
  }
  Widget _buildChat(DocumentSnapshot doc){
    String nombre=doc['usuario1']!=widget.Usuario.id?doc['nombre1']:doc['nombre2'];
        String subtitulo=doc['ultimo'];
    return ListTile(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatMensajes(nombreAmigo: nombre,docContactos: doc,Yo: widget.Usuario,)),
          );
        },
        leading: Icon(Icons.account_circle_outlined,color: Colors.grey,size: 45,),
        title: Text(nombre,style: TextStyle(fontWeight: FontWeight.w700),),
        subtitle: Text(Desencriptar(subtitulo),maxLines: 1,)
    );
  }
}
