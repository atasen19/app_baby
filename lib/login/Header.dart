import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';

class Header extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text("Giris Yapin", style: TextStyle(fontWeight: FontWeight.bold ,color: kTextColorW, fontSize: 70, fontFamily: "Raindrops")),
          ),
          SizedBox(height: 10),
          Center(
            child: Text("Bebeginizi takip edin", style: TextStyle(color: kTextColorW, fontSize: 30, fontFamily: "Raindrops")),
          )
        ],
      ),
    );
  }
}