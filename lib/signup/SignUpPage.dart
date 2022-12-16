import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/home/home_screen.dart';
import 'package:plant_app/model/user_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final emailTextEditController = new TextEditingController();
  final firstNameTextEditController = new TextEditingController();
  final lastNameTextEditController = new TextEditingController();
  final passwordTextEditController = new TextEditingController();
  final confirmPasswordTextEditController = new TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseAuth auth2 = FirebaseAuth.instance;

  String _errorMessage = '';

  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 36.0, left: 24.0, right: 24.0),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Kayıt Ol',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 45.0,
                          fontFamily: 'ScrambledTofu'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '$_errorMessage',
                      style: TextStyle(fontSize: 14.0, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 20.0,
                          fontFamily: 'ScrambledTofu'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return ("Bir email girin");
                        }
                        // reg expression for email validation
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Geçerli bir email girin");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailTextEditController.text = value;
                      },
                      controller: emailTextEditController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_firstNameFocus);
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        fillColor: Colors.white60,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 20.0,
                          fontFamily: 'ScrambledTofu'),
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value.isEmpty) {
                          return ("İsminizi girin");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("En az 3 karakter bir isim girin");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        firstNameTextEditController.text = value;
                      },
                      controller: firstNameTextEditController,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      focusNode: _firstNameFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_lastNameFocus);
                      },
                      decoration: InputDecoration(
                        hintText: 'Isim',
                        fillColor: Colors.white60,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 20.0,
                          fontFamily: 'ScrambledTofu'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return ("Soyadinizi girin");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        lastNameTextEditController.text = value;
                      },
                      controller: lastNameTextEditController,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      focusNode: _lastNameFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      decoration: InputDecoration(
                        hintText: 'Soyad',
                        fillColor: Colors.white60,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 20.0,
                          fontFamily: 'ScrambledTofu'),
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
                        passwordTextEditController.text = value;
                      },
                      autofocus: false,
                      obscureText: true,
                      controller: passwordTextEditController,
                      textInputAction: TextInputAction.next,
                      focusNode: _passwordFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocus);
                      },
                      decoration: InputDecoration(
                        hintText: 'Sifre',
                        fillColor: Colors.white60,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 20.0,
                          fontFamily: 'ScrambledTofu'),
                      autofocus: false,
                      obscureText: true,
                      controller: confirmPasswordTextEditController,
                      focusNode: _confirmPasswordFocus,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (passwordTextEditController.text != value) {
                          return "Şifreler aynı değil";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        confirmPasswordTextEditController.text = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Sifre tekrar',
                        fillColor: Colors.white60,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        // color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        padding: EdgeInsets.all(12),
                      ),
                      onPressed: () {
                        signUpFireBase(emailTextEditController.text,
                            passwordTextEditController.text);
                      },
                      child: Text('Kayıt Ol',
                          style: TextStyle(
                              color: kTextColorW,
                              fontSize: 20.0,
                              fontFamily: 'ScrambledTofu')),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.zero,
                      child: ElevatedButton(
                        child: Text(
                          'Geri Git',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 20.0,
                              fontFamily: 'ScrambledTofu'),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                      ))
                ],
              ))),
    );
  }

  void signUpFireBase(String email, String password) async {
    if (_formKey.currentState.validate()) {
      FirebaseApp app = await Firebase.initializeApp(
          name: 'secondary', options: Firebase.app().options);
      try {
        UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(email: email, password: password);
        postDetailsToFirestore(userCredential);
      } on FirebaseAuthException catch (e) {
        print(e);
      }
      await app.delete();
    }
  }

  postDetailsToFirestore(UserCredential userCredential) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserModel userModel = UserModel();

    userModel.admin = 0;
    userModel.email = userCredential.user.email;
    userModel.uid = userCredential.user.uid;
    userModel.firstName = firstNameTextEditController.text;
    userModel.secondName = lastNameTextEditController.text;

    await firebaseFirestore
        .collection("users")
        .doc(userCredential.user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Hesap başarıyla oluşturuldu");
  }
}
