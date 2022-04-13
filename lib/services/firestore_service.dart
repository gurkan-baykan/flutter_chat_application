import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_proje/mesaj.dart';
import 'package:firebase_proje/model/user_test.dart';
import 'package:firebase_proje/services/dbbase.dart';

class FireStore implements DbBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool?> createDbBase(UserTest? user) async {
    if (user != null) {
      Map<String, dynamic> yeni_kullanici = user.toMap();

      yeni_kullanici['createdAt'] = FieldValue.serverTimestamp();
      yeni_kullanici['updateAt'] = FieldValue.serverTimestamp();

      await _firestore.collection("users").doc(user.userID).set(yeni_kullanici);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<UserTest?> readDbBase(String? userID) async {
    CollectionReference users = _firestore.collection('users');

    DocumentSnapshot _dokuman = await users.doc(userID).get();

    Map<String, dynamic> _mapUsers = _dokuman.data() as Map<String, dynamic>;

    return UserTest.fromMap(_mapUsers);
  }

  @override
  Future<bool?> updateUser(String? userID, String? userName) async {
    var user = await _firestore
        .collection('users')
        .where("username", isEqualTo: userName)
        .get();

    if (user.docs.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .doc(userID)
          .update({"username": userName});

      return true;
    }
  }

  @override
  Future<bool?> updateProfilUrl(String? userID, String? profilUrl) async {
    await _firestore
        .collection("users")
        .doc(userID)
        .update({"profilUrl": profilUrl});

    return true;
  }

  @override
  Future<List<UserTest>> getAllUser() async {
    CollectionReference users = _firestore.collection('users');

    List<UserTest> tum_kullanicilar = [];

    await users.get().then((QuerySnapshot _querySnapshot) {
      _querySnapshot.docs.forEach((DocumentSnapshot doc) {
        Map<String, dynamic> _mapUsers = doc.data() as Map<String, dynamic>;

        UserTest _userTest = UserTest.fromMap(_mapUsers);

        tum_kullanicilar.add(_userTest);
      });
    });

    return tum_kullanicilar;
  }

  @override
  Stream<List<Mesaj>> getMessage(String currentId, String aliciId) {
    var snapShot = _firestore
        .collection('konusmalar')
        .doc(currentId + "--" + aliciId)
        .collection("mesajlar")
        .orderBy("date")
        .snapshots();

    return snapShot.map((mesajListesi) => mesajListesi.docs
        .map((DocumentSnapshot mesaj) =>
            Mesaj.fromMap(mesaj.data() as Map<String, dynamic>))
        .toList());
  }

  Future<bool> saveMessage(Mesaj mesaj) async {
    var mesajId = _firestore.collection("konusmalar").doc().id;
    var myDocId = mesaj.kimden! + "--" + mesaj.kime!;
    var yourDocId = mesaj.kime! + "--" + mesaj.kimden!;
    var _mesajMap = mesaj.toMap();

    await _firestore
        .collection("konusmalar")
        .doc(myDocId)
        .collection("mesajlar")
        .doc(mesajId)
        .set(_mesajMap);

    _mesajMap.update("bendenMi", (deger) => false);

    await _firestore
        .collection("konusmalar")
        .doc(yourDocId)
        .collection("mesajlar")
        .doc(mesajId)
        .set(_mesajMap);

    return true;
  }
}
