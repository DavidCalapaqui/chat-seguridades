import 'package:chat_sanchez_calapaqui/login.dart';
import 'package:chat_sanchez_calapaqui/probarCryto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMensajes extends StatefulWidget {
  final DocumentSnapshot docContactos;
  final String nombreAmigo;
  final DocumentSnapshot Yo;

  const ChatMensajes({Key key, this.docContactos, this.nombreAmigo, this.Yo}) : super(key: key);
  @override
  _ChatMensajesState createState() => _ChatMensajesState();
}

class _ChatMensajesState extends State<ChatMensajes> {
  List dias=["Lun","Mar","Mié","Jue","Vie","Sáb","Dom"];
  final _mensajeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: ListTile(
            leading: Icon(Icons.account_circle_outlined,color: Colors.white70,size: 40,),
            title: Text(widget.nombreAmigo,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: () {
          Navigator.of(context).pop();
        },),
        centerTitle: true,
        actions: [
          _Settings()
        ],
      ),
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
              accountEmail: Text(widget.Yo['correo'],style: TextStyle(color: Colors.white,),),
              accountName: Text(widget.Yo['nombre'],style: TextStyle(color: Colors.white,),),
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
      body: Container(
        color: Color(0xFFf0f0f0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                children: [
        StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('contactos').doc(widget.docContactos.id).collection('mensajes').orderBy('fecha',descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length != 0) {
              return Column(
                  children: snapshot.data.docs
                      .map((doc) => _buildMensaje(doc))
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
                child: CircularProgressIndicator()
            );
          }
        },
      )
                ],
              ),
            ),
            Divider(color: Colors.black,),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
              child: Row(children: [
                Expanded(child:Material(clipBehavior: Clip.antiAlias,shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Colors.white,
                child: TextField(
                  controller: _mensajeController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0),
                    ),disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0),
                  ),errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0),
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0),
                  ),focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0),
                  ),
                    hintText: "Escribe tu Mensaje"
                  ),
                ),
                )),
                SizedBox(width: 8,),
                FloatingActionButton(onPressed: (){_enviarMensaje(_mensajeController.text);},child: Icon(Icons.send,color: Colors.white,),backgroundColor: Colors.pink,)
              ],),
            )
          ],
        ),
      ),
    );
  }
  Widget _Settings() {
    return new PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
          new PopupMenuItem<int>(
              value: 1, child: new Text('Eliminar chat')),
          new PopupMenuItem<int>(
              value: 2, child: new Text('Cerrar Sesión')),
        ],
        onSelected: (int value) {

        });
  }
  Widget _buildMensaje(DocumentSnapshot doc){
    return doc['envia']==widget.Yo.id?Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [

        SizedBox(width: 90,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.5),
              borderRadius: BorderRadius.only(topLeft:  Radius.circular(40),bottomLeft:  Radius.circular(40)),

            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10,left: 10,right: 5,bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Desencriptar(doc['mensaje']),style: TextStyle(color: Colors.white),),

                  Row(
                    children: [
                      Expanded(child: Container(),),
                      Text(_fecha(doc['fecha']),style: TextStyle(color: Colors.white70,fontSize: 10),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

      ],),
    ):Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight:  Radius.circular(40),bottomRight:  Radius.circular(40)),

            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10,left: 10,right: 5,bottom: 5),
              child: Column(
                children: [
                  Text(Desencriptar(doc['mensaje'])),
                  Row(
                    children: [
                      Expanded(child: Container(),),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(_fecha(doc['fecha']),style: TextStyle(color: Colors.grey,fontSize: 10),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 90,),

      ],),
    );
  }
  
  String _fecha(int fecha){
    DateTime fechaMensaje=DateTime.fromMillisecondsSinceEpoch(fecha);
    DateTime fechaActual=DateTime.now();
    if(fechaActual.difference(fechaMensaje).inHours<24){
      if(fechaActual.day==fechaMensaje.day){
        return 'hoy, ${fechaMensaje.hour}:${fechaMensaje.minute}';
      }
    }
    return '${dias[fechaMensaje.weekday-1]}, ${fechaMensaje.day}-${fechaMensaje.month} ${fechaMensaje.hour}:${fechaMensaje.minute}';
  }
  void _enviarMensaje(String mensaje){

    widget.docContactos.reference.collection('mensajes').add(
      {
        "envia":widget.Yo.id,
        "fecha":DateTime.now().millisecondsSinceEpoch,
        "mensaje":Encriptar(mensaje)
      }
    );
    widget.docContactos.reference.update(
        {
          "fechaUltimo":DateTime.now().millisecondsSinceEpoch,
          "ultimo":Encriptar(mensaje)
        }
    );
    setState(() {
      _mensajeController.text="";
    });
  }
}
