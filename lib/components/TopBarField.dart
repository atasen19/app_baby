import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';

class TopBarField extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Container(
            child: Text("", style: TextStyle(
              fontSize: 30,
              color: kPrimaryColor,
            )),
          ),
        ),
      ],
    );
  }
}