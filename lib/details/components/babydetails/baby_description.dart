import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/details/details.dart';
import 'package:plant_app/firebaseFunctions.dart';
import 'package:plant_app/model/baby.dart';

class BabyDescription extends StatefulWidget {
  Baby baby;
  bool visibilityVariable;

  BabyDescription({
    this.baby,
    this.visibilityVariable,
  });

  @override
  _BabyDescriptionState createState() =>
      _BabyDescriptionState(visibilityVariable: visibilityVariable);
}

class _BabyDescriptionState extends State<BabyDescription> {
  bool visibilityVariable;

  _BabyDescriptionState({
    this.visibilityVariable,
  });

  bool textFieldVisibility = false;
  TextEditingController textEditingControllerBaslik = TextEditingController();
  TextEditingController textEditingControllerIcerik = TextEditingController();

  User user = FirebaseAuth.instance.currentUser;

  Baby baby;

  @override
  Widget build(BuildContext context) {
    baby = widget.baby;
    textEditingControllerIcerik.text = baby.desc;
    textEditingControllerBaslik.text = baby.name + " bebeğim için notlarım";

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DetailsScreen(
                babydata: baby, visibilityVariable: visibilityVariable)));
      },
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                      babydata: baby,
                                      visibilityVariable: visibilityVariable)));
                        },
                        icon: Icon(Icons.arrow_back, color: kPrimaryColor),
                        iconSize: 30.0),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0)),
                          ),
                          child: Icon(Icons.edit,
                              color: kPrimaryColor, size: 30.0),
                          onPressed: () {
                            setState(() {
                              if (textFieldVisibility == false) {
                                textFieldVisibility = true;
                              } else if (textFieldVisibility == true) {
                                textFieldVisibility = false;
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0)),
                          ),
                          child: Icon(Icons.check,
                              color: kPrimaryColor, size: 30.0),
                          onPressed: () async {
                            baby.desc = textEditingControllerIcerik.text;
                            await FirebaseService(uid: user.uid)
                                .updateBaby(baby);

                            setState(() {
                              if (textFieldVisibility == true) {
                                textFieldVisibility = false;
                              }
                            });

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                        babydata: baby,
                                        visibilityVariable:
                                            visibilityVariable)));
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25, right: 20, bottom: 0, left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: false,
                                  ),
                                  enabled: false,
                                  controller: textEditingControllerBaslik,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: kTextColorB,
                                      fontFamily: "ScrambledTofu"))),
                          SizedBox(height: 10),
                          Container(
                              child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: textFieldVisibility,
                                  ),
                                  enabled: textFieldVisibility,
                                  controller: textEditingControllerIcerik,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: kTextColorB,
                                      fontFamily: "ScrambledTofu")))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
