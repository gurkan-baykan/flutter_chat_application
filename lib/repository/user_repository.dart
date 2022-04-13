import 'dart:io';

import 'package:firebase_proje/locator.dart';
import 'package:firebase_proje/mesaj.dart';
import 'package:firebase_proje/model/user_test.dart';
import 'package:firebase_proje/services/auth_base.dart';
import 'package:firebase_proje/services/fakeService.dart';
import 'package:firebase_proje/services/firebase_auth_service.dart';
import 'package:firebase_proje/services/firestore_service.dart';

import '../services/firestorage_service.dart';

enum AppMode { debug, relase }

class UserRepository implements AuthBase {
  final appMode = AppMode.relase;

  Future<UserTest?> currentUser() async {
    if (appMode == AppMode.relase) {
      await locator<FirebaseAuthService>().currentUser();
    } else {
      await locator<FakeService>().currentUser();
    }
  }

  @override
  Future<bool?> signOut() async {
    if (appMode == AppMode.relase) {
      await locator<FirebaseAuthService>().signOut();
    } else {
      await locator<FakeService>().signOut();
    }
  }

  @override
  Future<UserTest?> singInAnonymously() async {
    if (appMode == AppMode.relase) {
      final donen = await locator<FirebaseAuthService>().singInAnonymously();

      if (donen != null) {
        UserTest? read_user =
            await locator<FireStore>().readDbBase(donen.userID);
        print(read_user?.userName);
        return read_user;
      } else {
        return null;
      }
    } else {
      await locator<FakeService>().singInAnonymously();
    }
  }

  @override
  Future<UserTest?> signInWithGoogle() async {
    if (appMode == AppMode.relase) {
      final user = await locator<FirebaseAuthService>().signInWithGoogle();
      return user;
      /* if (donen != null) {
        UserTest? read_user =
            await locator<FireStore>().readDbBase(donen.userID);
        print(read_user?.userName);
        return read_user;
      } else {
        return null;
      }*/
    } else {
      await locator<FakeService>().signInWithGoogle();
    }
  }

  Future<UserTest?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.relase) {
      final auth_user = await locator<FirebaseAuthService>()
          .signInWithEmailAndPassword(email, password);

      if (auth_user != null) {
        UserTest? read_user =
            await locator<FireStore>().readDbBase(auth_user.userID);

        return read_user;
      }
    } else {
      await locator<FakeService>().signInWithEmailAndPassword(email, password);
    }
  }

  @override
  Future<UserTest?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.relase) {
      UserTest? user = await locator<FirebaseAuthService>()
          .createUserWithEmailAndPassword(email, password);

      var sonuc = locator<FireStore>().createDbBase(user);

      if (sonuc != null) {
        UserTest? read_user =
            await locator<FireStore>().readDbBase(user?.userID);

        return read_user;
      } else {
        return null;
      }
    } else {
      return await locator<FakeService>()
          .createUserWithEmailAndPassword(email, password);
    }
  }

  @override
  Future<UserTest?> sendPasswordResetEmail(String email) async {
    if (appMode == AppMode.relase) {
      return await locator<FirebaseAuthService>().sendPasswordResetEmail(email);
    } else {
      await locator<FakeService>().sendPasswordResetEmail(email);
    }
  }

  @override
  Future<bool?> uploadFile(
      String userID, String fileType, File uploadFile) async {
    if (appMode == AppMode.relase) {
      final profilUrl = await locator<FireStorageService>()
          .uploadFile(userID, fileType, uploadFile);

      var sonuc = await locator<FireStore>().updateProfilUrl(userID, profilUrl);

      return sonuc;
    } else {
      return null;
    }
  }

  @override
  Future<List<UserTest>> getAllUser() async {
    if (appMode == AppMode.relase) {
      return await locator<FireStore>().getAllUser();
    } else {
      return [];
    }
  }

  @override
  Stream<List<Mesaj>> getMessage(String currentUser, String aliciId) {
    return locator<FireStore>().getMessage(currentUser, aliciId);
  }

  @override
  Future<bool> saveMessage(Mesaj mesaj) async {
    if (appMode == AppMode.relase) {
      return await locator<FireStore>().saveMessage(mesaj);
    } else {
      return false;
    }
  }
}
