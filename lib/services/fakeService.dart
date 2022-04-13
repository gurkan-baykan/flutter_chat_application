import 'package:firebase_proje/model/user_test.dart';
import 'package:firebase_proje/services/auth_base.dart';

class FakeService implements AuthBase
{
  String userID = "213213213312321";
  bool emailVerified =false;
  @override
  Future<UserTest>  currentUser() async  {
     
     return UserTest(userID: userID,email: "ahmet@gmail.com");
  }

  @override
  Future<bool> signOut(){
     return Future.value(true);
  }

  @override
  Future<UserTest> singInAnonymously() async {
      return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Future<UserTest?> signInWithGoogle() async{
      return await Future.delayed(Duration(seconds: 2));
  }
  
   Future<UserTest?>signInWithEmailAndPassword(String email,String password) async {

    
      return null;

    }

  @override
  Future<UserTest?> createUserWithEmailAndPassword(String email, String password) async{
            return null;
  }

  @override
  Future<UserTest?> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }


}