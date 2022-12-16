import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/home/home_screen.dart';
// import 'package:plant_app/signup/SignUpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _errorMessage = '';

  void onChange() {
    setState(() {
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    emailController.addListener(onChange);
    passwordController.addListener(onChange);

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: kPrimaryColor,
        radius: 48.0,
      ),
    );

    final errorMessage = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '$_errorMessage',
        style: TextStyle(fontSize: 14.0, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );

    final email = TextFormField(
      style: TextStyle(
          color: kPrimaryColor, fontSize: 20.0, fontFamily: 'ScrambledTofu'),
      validator: (value) {
        if (value.isEmpty) {
          return ("Bir email girin");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Geçerli bir email girin");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value;
      },
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailController,
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: 20.0, fontFamily: 'ScrambledTofu'),
        hintText: 'Email',
        fillColor: Colors.white60,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => node.nextFocus(),
    );

    final password = TextFormField(
      style: TextStyle(
          color: kPrimaryColor, fontSize: 20.0, fontFamily: 'ScrambledTofu'),
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value.isEmpty) {
          return ("Sifrenizi girin");
        }
        if (!regex.hasMatch(value)) {
          return ("Sifre en az 6 karekter olmalı");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value;
      },
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(node);
      },
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: 20.0, fontFamily: 'ScrambledTofu'),
        hintText: 'Şifre',
        fillColor: Colors.white60,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: kPrimaryColor,
            padding: EdgeInsets.all(12)),
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        // padding: EdgeInsets.all(12),
        // color: kPrimaryColor,
        child: Text('Giriş',
            style: TextStyle(
                color: kTextColorW,
                fontSize: 20.0,
                fontFamily: 'ScrambledTofu')),
      ),
    );

    return Scaffold(
        backgroundColor: kSecondaryColor,
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 24.0),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Giriş Yap',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 45.0,
                        fontFamily: 'ScrambledTofu'),
                    textAlign: TextAlign.center,
                  ),
                ),
                errorMessage,
                SizedBox(height: 12.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
              ],
            ),
          ),
        ));
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState.validate()) {
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Giriş Başarılı"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            _errorMessage = "Gecersiz email adresi";
            break;
          case "wrong-password":
            _errorMessage = "Sifreniz yanlıs";
            break;
          case "user-not-found":
            _errorMessage = "Boyle bir email adresi yok";
            break;
          case "user-disabled":
            _errorMessage = "Bu kullanici bulumuyor";
            break;
          case "too-many-requests":
            _errorMessage = "Daha sonra tekrar deneyin";
            break;
          case "operation-not-allowed":
            _errorMessage = "Email ve sifre girisi kapali";
            break;
          default:
            _errorMessage = "Bilinmeyen bir hata olustu.";
        }
        Fluttertoast.showToast(msg: _errorMessage);
        print(error.code);
      }
    }
  }
}
