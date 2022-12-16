import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_app/login/LoginPage.dart';
import 'constants.dart';
import 'home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}
class MyApp extends StatefulWidget
{
  @override
  MyAppState createState() => MyAppState();
}
class MyAppState extends State<MyApp>{
  User user;

  @override
  void initState(){
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred){
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(user == null){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Baby App',
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColorB),
          fontFamily: "Raindrops",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baby App',
      theme: ThemeData(
        focusColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColorB),
        fontFamily: "Raindrops",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );

  }
}
