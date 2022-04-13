import 'package:firebase_proje/sign_page.dart';
import 'package:firebase_proje/tab_menuler/kullaniciOrnek.dart';
import 'package:firebase_proje/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mesajlasma.dart';
import '../model/user_test.dart';

class KullanicilarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Kullanici",
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => KullaniciOrnek())),
              icon: Icon(Icons.supervised_user_circle_sharp),
            ),
            IconButton(
                onPressed: () {
                  _userModel.signOut();
                },
                icon: Icon(Icons.close))
          ],
        ),
        body: FutureBuilder<List<UserTest>>(
          future: Provider.of<UserModel>(context, listen: false).getAllUser(),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              if (sonuc.data?.length != null) {
                return ListView.builder(
                    itemCount: sonuc.data?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => Mesajlasma(
                                          currentUser: _userModel.user,
                                          sohbetEdilen: sonuc.data?[index],
                                        )));
                          },
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "${sonuc.data?[index].profilUrl}")),
                          subtitle: Text("${sonuc.data?[index].email}"),
                          hoverColor: Colors.grey[350],
                          dense: true,
                          tileColor: Colors.grey[200],
                          title: Text(
                            "${sonuc.data?[index].userName}",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      );
                    });
              } else {
                return Text("deneme");
              }
            } else {
              return Text("kayit yok");
            }
          },
        ));
  }
}
