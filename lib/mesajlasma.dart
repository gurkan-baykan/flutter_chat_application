import 'package:firebase_proje/mesaj.dart';
import 'package:firebase_proje/model/user_test.dart';
import 'package:firebase_proje/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';

class Mesajlasma extends StatefulWidget {
  final UserTest? currentUser;
  final UserTest? sohbetEdilen;

  Mesajlasma({this.currentUser, this.sohbetEdilen});

  @override
  State<Mesajlasma> createState() => _MesajlasmaState();
}

class _MesajlasmaState extends State<Mesajlasma> {
  @override
  static const toMessage = BubbleStyle(
    margin: BubbleEdges.only(top: 15),
    alignment: Alignment.topLeft,
    nipWidth: 8,
    nipHeight: 24,
    nip: BubbleNip.leftTop,
  );

  static const fromMessage = BubbleStyle(
    margin: BubbleEdges.only(top: 15),
    alignment: Alignment.topRight,
    nipWidth: 8,
    nipHeight: 24,
    nip: BubbleNip.rightTop,
    color: Color.fromRGBO(225, 255, 199, 1.0),
  );

  Widget build(BuildContext context) {
    var _currentId = widget.currentUser!.userID;
    var _aliciId = widget.sohbetEdilen!.userID;
    var _userModel = Provider.of<UserModel>(context);
    final _streamData = _userModel.getMessage(_currentId, _aliciId);

    TextEditingController _mesajController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          toolbarTextStyle: TextStyle(fontSize: 17),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  child: CircleAvatar(
                backgroundImage:
                    NetworkImage("${widget.sohbetEdilen?.profilUrl}"),
              )),
              SizedBox(
                width: 10,
              ),
              Text(
                "${widget.sohbetEdilen?.userName}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          )),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<Mesaj>>(
            stream: _streamData,
            builder: (context, snapShot) {
              if (!snapShot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                    value: 5,
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapShot.data?.length,
                itemBuilder: (context, index) {
                  if (snapShot.data?[index].bendenMi == true) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Bubble(
                        style: fromMessage,
                        child: Text("${snapShot.data?[index].mesaj}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0)),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Container(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "${widget.sohbetEdilen?.profilUrl}"),
                                )),
                          ),
                          Bubble(
                            style: toMessage,
                            child: Text("${snapShot.data?[index].mesaj}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18.0)),
                          ),
                        ],
                      ),
                    );
                  }

                  /* snapShot.data?[index].mesaj */
                },
              );
            },
          )),
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Row(children: [
              Expanded(
                  child: TextField(
                controller: _mesajController,
                decoration: InputDecoration(
                    filled: true,
                    label: Text("Mesaj Giriniz"),
                    suffixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              )),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                child: Icon(Icons.send),
                onPressed: () async {
                  Mesaj _mesaj = Mesaj(
                    bendenMi: true,
                    kimden: _currentId,
                    kime: _aliciId,
                    mesaj: _mesajController.text,
                  );

                  final sonuc = await _userModel.saveMessage(_mesaj);

                  if (sonuc == true) {
                    _mesajController.clear();
                  }
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}
