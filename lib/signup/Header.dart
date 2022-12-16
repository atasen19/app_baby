import 'package:flutter/material.dart';

class Header extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text("Kayit Olun", style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.white, fontSize: 70, fontFamily: "Raindrops")),
          ),
          SizedBox(height: 10),
          Center(
            child: Text("Bebeginizi takip edin", style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: "Raindrops")),
          )
        ],
      ),
    );
  }
}