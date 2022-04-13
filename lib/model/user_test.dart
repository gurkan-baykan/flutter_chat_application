

import 'package:flutter/scheduler.dart';

class UserTest{


  final String userID;
  String email;
  String? profilUrl;
  String? userName;
  DateTime?  createdAt;
  DateTime? updateAt;
  int? seviye;
  final bool? emailVerified;
  final VoidCallback? sendEmailVerification;

  UserTest({required this.userID,this.emailVerified,this.sendEmailVerification,required this.email,this.userName,this.profilUrl});

  Map<String,dynamic>toMap(){

    return {
      'userID':userID,
      'email':email,
      'profilUrl':profilUrl,
      'createdAt':createdAt,
      'updateAt':updateAt,
      'seviye':seviye,
      'username':userName !=null ? userName :  email.substring(0,email.indexOf('@')),
    };
  }


  static UserTest fromMap(Map<String,dynamic> map){

     return  UserTest(userID: map['userID'], email: map['email'] != null ? map['email'] : "", profilUrl: map['profilUrl'],userName: map['username']);

  }
}