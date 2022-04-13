import 'package:firebase_proje/mesaj.dart';
import 'package:firebase_proje/model/user_test.dart';

abstract class DbBase {
  Future<bool?> createDbBase(UserTest user);
  Future<UserTest?> readDbBase(String userID);
  Future<bool?> updateUser(String userID, String userName);
  Future<bool?> updateProfilUrl(String userID, String profilUrl);
  Future<List<UserTest?>> getAllUser();
  Stream<List<Mesaj>> getMessage(String currentId, String aliciId);
  Future<bool> saveMessage(Mesaj mesaj);
}
