
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireData extends StatefulWidget {
  @override
  _FireDataState createState() => _FireDataState();
}

class _FireDataState extends State<FireData> {
  @override
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _dersstream =
        FirebaseFirestore.instance.collection('Kullanici').snapshots();
    final _user = FirebaseFirestore.instance.collection('Kullanici');

    return Scaffold(
        appBar: AppBar(title: Text("Ders programı")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _dersstream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  final List<DocumentSnapshot> document = snapshot.data!.docs;

                  ;

                  return ListView.builder(
                    itemCount: document.length,
                    itemBuilder: (BuildContext context, int index) {
                      var isim = document[index].data() as Map<String, dynamic>;

                      return Dismissible(
                        key: Key("$UniqueKey(),"),
                        background: Container(child: Icon(Icons.delete),alignment: Alignment.centerRight, color: Colors.red[300],),
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection){

                            document[index].reference.delete();
                        },
                        child: Card(
                          child: ListTile(
                            title: Text("${isim['ad']}"),
                            subtitle: Text("${isim['soyad']}"),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          child: Text("Post At"),
                          onPressed: () async {
                            await _user.add({"ad": "ayten", "soyad": "bulmaz"});

                            _user
                                .doc("FLp0Vsfle9tGbuPOPdCI")
                                .update({"soyad": "korkmaz"});

                            _user
                                .doc("FLp0Vsfle9tGbuPOPdCI")
                                .set({"yas": "16"});
                          }))
                ],
              ),
            )
          ],
        )));
  }
}
