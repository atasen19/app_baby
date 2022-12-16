import 'package:flutter/material.dart';

import 'TopBarField.dart';

class TopBarWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            child: TopBarField(),
          ),
        ],
      ),
    );
  }
}