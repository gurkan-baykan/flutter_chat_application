
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Auth {

  final _auth = FirebaseAuth.instance;


  Future<User?> singInAnonymously() async
  {
       
      final userCredential = await _auth.signInAnonymously();
      print(userCredential);
      return userCredential.user;
  }

  Future<User?>createUser(String email,String password) async {
    
      final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password:password
    );

    return userCredential.user;
  }

  Future<User?>signInUser(String email,String password) async {

      UserCredential _userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      return _userCredential.user;

  }

  Future<User?>sendResetEmail(String email) async
  {
      final _userCredential = await _auth.sendPasswordResetEmail(email: email);
  }

  void userExit() async
  {
      await _auth.signOut();
  }
 
  Stream<User?> streamState() {

     return  _auth.authStateChanges();

  }

  

Future<User?> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  UserCredential _userCredential =  await _auth.signInWithCredential(credential);

  return _userCredential.user;
}
}