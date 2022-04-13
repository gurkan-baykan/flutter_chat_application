import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_proje/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_proje/model/user_test.dart';

class FirebaseAuthService implements AuthBase {
  final _auth = FirebaseAuth.instance;

  Future<UserTest?> currentUser() async {
    final _user = await _auth.currentUser;

    return _userFromFirebase(_user);
  }

  UserTest? _userFromFirebase(user) {
    if (user != null) {
     
      return UserTest(
          userID: user.uid,
          emailVerified: user.emailVerified,
          email: user.email);
    }

    return null;
  }

  @override
  Future<bool?> signOut() async {
    final googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<UserTest?> singInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();

    var user_id = _userFromFirebase(userCredential.user);

    return user_id;
  }

  Future<UserTest?> signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential _userCredential =
        await _auth.signInWithCredential(credential);

    return _userFromFirebase(_userCredential.user);
  }

  @override
  Future<UserTest?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential _userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return _userFromFirebase(_userCredential.user);
  }

  @override
  Future<UserTest?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<UserTest?> sendPasswordResetEmail(String email) async {
    final _userCredential = await _auth.sendPasswordResetEmail(email: email);
  }

 
}
