import 'package:firebase_proje/butonlar/raisedbutton.dart';
import 'package:firebase_proje/register.dart';
import 'package:firebase_proje/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("firebase projesi")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

             TextButton(
            child: const Text('Çıkış'),
            onPressed: () {
              Provider.of<UserModel>(context,listen: false).signOut();
            },
          ),

            Text("Oturum Açın", style: TextStyle(fontSize: 25)),
            SizedBox(height: 15),
            MyRaisedButton(
                color: Colors.red[700],
                text: "Google Hesabı ile Giriş",
                press: () {
                Provider.of<UserModel>(context, listen: false).signInWithGoogle();

                    
                },
                buttonIcon: Image.asset("assets/images/google.png")),
            SizedBox(height: 15),
            MyRaisedButton(
                color: Colors.orange,
                text: "SignIn Anonymous",
                press: () => Provider.of<UserModel>(context, listen: false)
                    .singInAnonymously(),
                buttonIcon: Image.asset("assets/images/gmail.jpg")),
            SizedBox(height: 15),

              MyRaisedButton(
                color: Colors.grey[500],
                text: "Mail/Şifre ile Giriş",
                press: () {
                  Navigator.push((context),
                      MaterialPageRoute(builder: (context) => Register()));
                },
                buttonIcon: Image.asset("assets/images/gmail.jpg")),
            SizedBox(height: 15),
            
            MyRaisedButton(
                color: Colors.blue[900],
                text: "FaceBook ile giriş",
                press: () {
                  Navigator.push((context),
                      MaterialPageRoute(builder: (context) => Register()));
                },
                buttonIcon: Image.asset("assets/images/facebook.png")),
            SizedBox(height: 15),
          
          ],
        ),
      ),
    );
  }
}
