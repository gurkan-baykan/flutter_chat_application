import 'dart:io';
import 'package:firebase_proje/model/user_test.dart';
import 'package:firebase_proje/tab_menuler/profilOrnek.dart';
import 'package:firebase_proje/uyari_widget/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../view_model/user_model.dart';

class ProfilPage extends StatefulWidget {
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  TextEditingController? _emailController = TextEditingController();

  TextEditingController? _userNameController = TextEditingController();
  File? profilFoto;

  resimSec(String param, BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    if (param == "kamera") {
      var image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        profilFoto = File(image!.path);
      });
    } else {
      var image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        profilFoto = File(image!.path);
      });
    }
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    UserTest? _userModel = Provider.of<UserModel>(context).user;

    _emailController?.text = _userModel?.email as String;
    _userNameController?.text = _userModel?.userName as String;

    return Scaffold(
        appBar: AppBar(
          title: Text("Profil"),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilOrnek())),
                icon: Icon(Icons.supervised_user_circle_sharp)),
                 IconButton(
                onPressed: () {
                  Provider.of<UserModel>(context, listen: false).signOut();
                },
                icon: Icon(Icons.close))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          title: const Text(
                            'Resim Değiştirme',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          actions: <CupertinoActionSheetAction>[
                            CupertinoActionSheetAction(
                              child: Row(
                                children: [
                                  Icon(Icons.camera),
                                  SizedBox(width: 3),
                                  Text("Kamera ile Seç",
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                              onPressed: () {
                                resimSec("kamera", context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Row(
                                children: [
                                  Icon(Icons.photo),
                                  SizedBox(width: 3),
                                  Text("Galeriden  Seç",
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                              onPressed: () {
                                resimSec("galeri", context);
                              },
                            )
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 180,
                      height: 180,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                              backgroundImage: profilFoto == null
                                  ? NetworkImage("${_userModel?.profilUrl}")
                                  : FileImage(profilFoto!) as ImageProvider)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        label: Text("Email"),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.subject_rounded),
                        label: Text("Kullanıcı Adı"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    onPressed: () async {
                      var sonuc = null;
                      if (_userModel?.userName != _emailController?.text) {
                        sonuc = await Provider.of<UserModel>(context,
                                listen: false)
                            .updateUser(
                                _userModel?.userID, _userNameController?.text);
                      }

                      if(profilFoto != null)
                      {
                          sonuc =
                          await Provider.of<UserModel>(context, listen: false)
                              .uploadFile(_userModel?.userID as String,
                                  "profil_fotolari", profilFoto as File);
                      }
                    

                      if (sonuc == false || sonuc == null) {
                        AlertWidget(
                                title: "İşlem Başarısız",
                                mesaj:
                                    "Daha Öncden kayıtlı bir kullanıcıya ait biri isim giremezsiniz !")
                            .goster(context);
                      } else {
                        AlertWidget(
                                title: "İşlem Başarılı",
                                mesaj:
                                    "Güncelleme işlemi Başarı ile Gerçekleşmiştir")
                            .goster(context);
                      }
                    },
                    child: Text(
                      "Güncelle",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

/*TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 20);*/
