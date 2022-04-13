import 'package:firebase_proje/home.dart';

import 'package:firebase_proje/sign_page.dart';
import 'package:firebase_proje/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context).user;
    final state = Provider.of<UserModel>(context).state;

    if (state == ViewState.busy) {
      return Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(value: 1.4)],
        ),
      ));
    } else {
      if (user == null) {
       
        return SignPage();
      } else {
       
        return  HomePage();
        
      }
    }
  }
}
