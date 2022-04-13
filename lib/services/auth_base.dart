


import '/model/user_test.dart';
abstract class AuthBase { 

  Future<UserTest?> currentUser();
  Future<UserTest?> singInAnonymously();
  Future<bool?> signOut();
  Future<UserTest?>signInWithGoogle();
  Future<UserTest?>signInWithEmailAndPassword(String email,String password);
  Future<UserTest?>createUserWithEmailAndPassword(String email,String password);
  Future<UserTest?>sendPasswordResetEmail(String email );
 
   
}