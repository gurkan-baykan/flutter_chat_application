import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_proje/fire_data.dart';
import 'package:firebase_proje/home.dart';
import 'package:firebase_proje/register.dart';
import 'package:firebase_proje/sign_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
 
class OnboardPage extends StatefulWidget {
 

  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {

  var isLogged = false;


  

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<Auth>(context);
    return  StreamBuilder(
      stream: auth.streamState(),
      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot)  {

            if(snapshot.connectionState == ConnectionState.active)
            {
                return snapshot.data != null ? FireData() : SignPage();
            }
            else
            {
              return CircularProgressIndicator();
            }
    });
  }
}