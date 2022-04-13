import 'dart:io';
import 'package:firebase_proje/model/user_test.dart';
import 'package:firebase_proje/repository/user_repository.dart';
import 'package:firebase_proje/services/auth_base.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../mesaj.dart';
import '../services/firestore_service.dart';

enum ViewState { idle, busy }

class UserModel with ChangeNotifier implements AuthBase {
  @override
  var _state = ViewState.idle;
  UserTest? _user;

  ViewState get state => _state;

  UserTest? get user => _user;

  set state(ViewState value) {
    _state = value;
  }

  UserModel() {
    currentUser();
  }

  Future<UserTest?> currentUser() async {
    try {
      state = ViewState.busy;

      _user = await locator<UserRepository>().currentUser();
      notifyListeners();
      return _user;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool?> signOut() async {
    try {
      state = ViewState.busy;

      bool? sonuc = await locator<UserRepository>().signOut();
      _user = null;
      notifyListeners();
      state = ViewState.idle;
      return sonuc;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserTest?> singInAnonymously() async {
    try {
      state = ViewState.busy;

      _user = await locator<UserRepository>().singInAnonymously();
      notifyListeners();
      return _user;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserTest?> signInWithGoogle() async {
    try {
      state = ViewState.busy;

      _user = await locator<UserRepository>().signInWithGoogle();
      notifyListeners();
      return _user;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserTest?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      state = ViewState.busy;

      _user = await locator<UserRepository>()
          .signInWithEmailAndPassword(email, password);
      notifyListeners();
      return _user;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserTest?> createUserWithEmailAndPassword(
      String email, String password) async {
    state = ViewState.busy;

    _user = await locator<UserRepository>()
        .createUserWithEmailAndPassword(email, password);
    notifyListeners();
    return _user;
  }

  @override
  Future<UserTest?> sendPasswordResetEmail(String email) async {
    try {
      state = ViewState.busy;

      _user = await locator<UserRepository>().sendPasswordResetEmail(email);
      notifyListeners();
      return _user;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool?> updateUser(String? userID, String? userName) async {
    try {
      final sonuc = await locator<FireStore>().updateUser(userID, userName);

      return sonuc;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<bool?> uploadFile(
      String userID, String fileType, File uploadFile) async {
    try {
      final sonuc = await locator<UserRepository>()
          .uploadFile(userID, fileType, uploadFile);

      /* _user = await locator<FireStore>().readDbBase(user?.userID);*/

      return sonuc;
    } finally {}
  }

  @override
  Future<List<UserTest>> getAllUser() async {
    try {
      state = ViewState.busy;
      return await locator<UserRepository>().getAllUser();
    } finally {
      state = ViewState.idle;
    }
  }

  Stream<List<Mesaj>> getMessage(String currentId, String aliciID) {
    try {
      state = ViewState.busy;
      return locator<UserRepository>().getMessage(currentId, aliciID);
    } finally {
      state = ViewState.idle;
    }
  }

  Future<bool?> saveMessage(Mesaj mesaj) async {
    try {
      final sonuc = await locator<UserRepository>().saveMessage(mesaj);
      return sonuc;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
