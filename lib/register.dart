import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_proje/hatalar/hata_mesajlari.dart';
import 'package:firebase_proje/uyari_widget/alert.dart';
import 'package:firebase_proje/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormStatus { signIn, registerIn, reset }

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar() {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(
        "İşlem başarıyla kayıt edildi",
        style: TextStyle(fontSize: 18),
      ),
      duration: Duration(seconds: 5),
      dismissDirection: DismissDirection.up,
      backgroundColor: Colors.green[400],
    ));
  }

  var _formstatus = FormStatus.signIn;

  Widget build(BuildContext context) {
    final state = Provider.of<UserModel>(context).state;

    return state == ViewState.busy
        ? Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.amber,
              value: 2.2,
            )),
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.backspace),
              ),
              title: Text("Kapat"),
              backgroundColor: Colors.brown,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
                child: _formstatus == FormStatus.signIn
                    ? signForm(context)
                    : (_formstatus == FormStatus.reset
                        ? resetForm()
                        : registerForm())),
          );
  }

  Future<void> _resetshowMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Mailinize gelen linke tıklayarak yeni şifrenizi oluşturabilirsiniz'),
          actions: <Widget>[
            TextButton(
              child: const Text('Anladım'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  resetForm() {
    final _signFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    return Form(
      key: _signFormKey,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Expanded(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Şifre Yenileme",
                style: TextStyle(fontSize: 20, color: Colors.red[200]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Zorunlu alanlar girilmedi !";
                  } else {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!emailValid) {
                      return "Email formatında değil !";
                    }
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    label: Text("E-mail"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.red),
              ),
              SizedBox(height: 15),
              RaisedButton(
                onPressed: () async {
                  var ok = _signFormKey.currentState!.validate();
                  if (ok) {
                    await Provider.of<UserModel>(context, listen: false)
                        .sendPasswordResetEmail(_emailController.text);
                    await _resetshowMyDialog(context);
                    setState(() {
                      _formstatus = FormStatus.signIn;
                    });
                  }
                },
                child: Text("Gönder"),
                color: Colors.blueAccent,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  signForm(context) {
    final _signFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Form(
      key: _signFormKey,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Sisteme Giriş",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Zorunlu alanlar girilmedi !";
                } else {
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (!emailValid) {
                    return "Email formatında değil !";
                  }
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  label: Text("E-mail"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.red),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Zorunlu alanlar girilmedi !";
                } else {
                  if (value.length != 6) {
                    return "Şifre 6 karakterli olmak zorundadır !";
                  }
                }
              },
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  label: Text("Şifre"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.red),
            ),
            SizedBox(height: 15),
            RaisedButton(
              onPressed: () async {
                var ok = _signFormKey.currentState!.validate();
                if (ok) {
                  try {
                    await Provider.of<UserModel>(context, listen: false)
                        .signInWithEmailAndPassword(
                            _emailController.text, _passwordController.text);

                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    AlertWidget(title: HataMesajlari().goster(e.code))
                        .goster(context);
                  }

                  /* if (user != null && user.emailVerified == false) {
                    await user.sendEmailVerification;

                    await _showMyDialog();
                    Provider.of<UserModel>(context, listen: false).signOut();
                  } */
                }
              },
              child: Text("Giriş", style: TextStyle(color: Colors.white)),
              color: Colors.blueAccent,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _formstatus = FormStatus.registerIn;
                  });
                },
                child: Text(
                  "Sistemde kaydınız yoksa tıklaynız",
                  style: TextStyle(color: Colors.black),
                )),
            SizedBox(width: 10),
            TextButton(
                onPressed: () {
                  setState(() {
                    _formstatus = FormStatus.reset;
                  });
                },
                child: Text("Şifremi unuttum",
                    style: TextStyle(color: Colors.black)))
          ]),
        ),
      ),
    );
  }

  registerForm() {
    final _globalformkey = GlobalKey<FormState>();
    var sifreController = TextEditingController();
    var mailController = TextEditingController();
    return Form(
      key: _globalformkey,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Expanded(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Sisteme Kayıt",
                style: TextStyle(fontSize: 20, color: Colors.blue[600]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: mailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Zorunlu alanlar girilmedi !";
                  } else {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!emailValid) {
                      return "Email formatında değil !";
                    }
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    label: Text("E-mail"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.red),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: sifreController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    label: Text("Şifre"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.red),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Zorunlu alanlar girilmedi !";
                  } else {
                    if (value.length != 6) {
                      return "Şifre 6 karakterli olmak zorundadır !";
                    }

                    if (sifreController.text != value) {
                      return "Doğrulanan şifre yukarıdaki şifre ile aynı değil !";
                    }
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    label: Text("Doğrula"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.red),
              ),
              SizedBox(height: 15),
              RaisedButton(
                  onPressed: () async {
                    var ok = _globalformkey.currentState!.validate();

                    if (ok) {
                      try {
                        final user =
                            await Provider.of<UserModel>(context, listen: false)
                                .createUserWithEmailAndPassword(
                                    mailController.text, sifreController.text);

                        if (user != null) {
                          showInSnackBar();
                          mailController.text = "";
                          sifreController.text = "";
                        }
                      } on FirebaseAuthException catch (e) {
                        Navigator.of(context).pop();
                        AlertWidget(title: HataMesajlari().goster(e.code))
                            .goster(context);
                      }
                    }
                  },
                  child: Text("Kayıt"),
                  color: Colors.blueAccent),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _formstatus = FormStatus.signIn;
                    });
                  },
                  child: Text("Sisteme kaydınız var ise  tıklaynız"))
            ]),
          ),
        ),
      ),
    );
  }
}
