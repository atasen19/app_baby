import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/firebaseFunctions.dart';
import 'package:plant_app/home/home_screen.dart';
import 'package:plant_app/model/baby.dart';

class AddBabyScreen extends StatefulWidget {
  final Baby baby;
  final int option;
  AddBabyScreen({this.option, this.baby});

  @override
  State<StatefulWidget> createState() {
    return AddBabyScreenState(baby);
  }
}

class AddBabyScreenState extends State<AddBabyScreen> {
  int butonKapat = 1;
  int sayac = 0;

  File _image = File("");
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  Baby baby;
  Baby baby2;

  AddBabyScreenState(baby) {
    image = baby.image;
    name2 = baby.name;
    genderIndex = setIndex(baby.gender);
    birthWeek = baby.ageOfBirth;
    birthWeight2 = baby.birthWeight;
    birthLength2 = baby.birthLength;
    headSize2 = baby.headSize;
    birthDay2 = DateTime.now().millisecondsSinceEpoch;
    baby2 = baby;
  }

  var image;
  var name2;
  var birthWeek;
  var birthWeight2;
  var birthLength2;
  var headSize2;
  var birthDay2;
  var genderArr = ["Erkek", "Kız", "Özel"];
  var genderIndex;
  User user = FirebaseAuth.instance.currentUser;
  Baby firebaseBaby;

  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, int birthDay2) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        birthDay2 = currentDate.millisecondsSinceEpoch;
        print(birthDay2);
      });
  }

  String optionTime(int option) {
    String formattedDate = "";

    if (option == 1) {
      return formattedDate =
          DateFormat('yyyy-MM-dd - kk:mm').format(currentDate);
    } else {
      var convert = DateTime.fromMillisecondsSinceEpoch(widget.baby.birthDay);
      return formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(convert);
    }
  }

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var myheight = MediaQuery.of(context).size.height * .50;
    // var mywidth = MediaQuery.of(context).size.width * .50;

    return Scaffold(
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
                        Navigator.pop(context, true);
                      },
                      icon: Icon(Icons.arrow_back, color: kPrimaryColor),
                      iconSize: 30.0),
                ),
                Container(
                  width: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90.0)),
                    ),
                    child: Icon(Icons.check, color: Colors.white),
                    onPressed: () async {
                      if (butonKapat == 1) {
                        butonKapat = 0;

                        showLoaderDialog(context);

                        if (widget.option == 1) {
                          String resimUrl = "";
                          if (_image.path == "") {
                            _image = await FirebaseService()
                                .fileFromImageUrl(baby2.image);
                            resimUrl = await FirebaseService()
                                .uploadImageToFirebase(context, _image);
                          } else {
                            resimUrl = await FirebaseService()
                                .uploadImageToFirebase(context, _image);
                          }

                          firebaseBaby = Baby(
                              name: name2,
                              image: resimUrl,
                              age: 0,
                              gender: genderArr[genderIndex],
                              desc: "desc",
                              birthDay: birthDay2,
                              ageOfBirth: birthWeek,
                              birthLength: birthLength2,
                              birthWeight: birthWeight2,
                              headSize: headSize2);
                          await FirebaseService(uid: user.uid)
                              .addBaby(firebaseBaby);
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else if (widget.option == 2) {
                          await FirebaseService(uid: user.uid)
                              .deleteBaby(baby2);

                          String resimUrl = "";
                          if (_image.path == "") {
                            _image = await FirebaseService()
                                .fileFromImageUrl(baby2.image);
                            resimUrl = await FirebaseService()
                                .uploadImageToFirebase(context, _image);
                            await FirebaseService().deleteImage(baby2.image);
                          } else {
                            resimUrl = await FirebaseService()
                                .uploadImageToFirebase(context, _image);
                            await FirebaseService().deleteImage(baby2.image);
                          }

                          firebaseBaby = Baby(
                              name: name2,
                              image: resimUrl,
                              age: 0,
                              gender: genderArr[genderIndex],
                              desc: "descc",
                              birthDay: birthDay2,
                              ageOfBirth: birthWeek,
                              birthLength: birthLength2,
                              birthWeight: birthWeight2,
                              headSize: headSize2);
                          await FirebaseService(uid: user.uid)
                              .addBaby(firebaseBaby);
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          print('bebek ekleme tuşuna bastığnızda hata oluştu');
                        }
                      } else {
                        return;
                      }
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: kPrimaryColor,
                            child: CircleAvatar(
                              backgroundImage: resimGetir(baby2.image).image,
                              radius: 56,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black, width: 2.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Center(
                                        child: Text("İsim ve Doğum Tarihi",
                                            style: TextStyle(
                                                color: kTextColorW,
                                                fontSize: 25.0,
                                                fontFamily: 'ScrambledTofu')),
                                      ),
                                      height: myheight * .10,
                                      decoration:
                                          BoxDecoration(color: kPrimaryColor),
                                    ),
                                    Container(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              initialValue: name2,
                                              onChanged: (value) {
                                                name2 = value;
                                              },
                                              autofocus: false,
                                              textAlign: TextAlign.center,
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "ScrambledTofu",
                                                color: kTextColorB,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Bebeğin ismi",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                            SizedBox(height: myheight * 0.03),
                                            RichText(
                                                text: TextSpan(
                                              style: TextStyle(
                                                fontFamily: "ScrambledTofu",
                                                fontSize: 20.0,
                                                color: kTextColorB,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              text: optionTime(widget.option),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  if (widget.option == 1) {
                                                    _selectDate(
                                                        context, birthDay2);
                                                  } else {
                                                    _selectDate(context,
                                                        widget.baby.birthDay);
                                                  }
                                                },
                                            )),
                                          ],
                                        ),
                                      ),
                                      height: myheight * .30,
                                      decoration:
                                          BoxDecoration(color: boxColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.transparent,
                            border: Border.all(color: kTextColorB, width: 2.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Center(
                                        child: Text("Cinsiyet",
                                            style: TextStyle(
                                                color: kTextColorW,
                                                fontSize: 25.0,
                                                fontFamily: 'ScrambledTofu')),
                                      ),
                                      height: myheight * .10,
                                      decoration:
                                          BoxDecoration(color: kPrimaryColor),
                                    ),
                                    Container(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (genderIndex > 0) {
                                                      genderIndex -= 1;
                                                      print(genderIndex);
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.arrow_left,
                                                  color: Colors.black,
                                                ),
                                                iconSize: 40.0),
                                            Text(genderArr[genderIndex],
                                                style: TextStyle(
                                                    color: kTextColorB,
                                                    fontSize: 25,
                                                    fontFamily:
                                                        "ScrambledTofu")),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (genderIndex < 2) {
                                                      genderIndex += 1;
                                                      print(genderIndex);
                                                    }
                                                  });
                                                },
                                                icon: Icon(Icons.arrow_right,
                                                    color: Colors.black),
                                                iconSize: 40.0),
                                          ],
                                        ),
                                      ),
                                      height: myheight * .30,
                                      decoration:
                                          BoxDecoration(color: boxColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black, width: 2.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Center(
                                        child: Text("Hamilelik Süresi",
                                            style: TextStyle(
                                                color: kTextColorW,
                                                fontSize: 25.0,
                                                fontFamily: 'ScrambledTofu')),
                                      ),
                                      height: myheight * .10,
                                      decoration:
                                          BoxDecoration(color: kPrimaryColor),
                                    ),
                                    Container(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (birthWeek > 20) {
                                                      birthWeek -= 1;
                                                      print(birthWeek);
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.arrow_left,
                                                  color: Colors.black,
                                                ),
                                                iconSize: 40.0),
                                            Text(
                                                birthWeek.toString() + " Hafta",
                                                style: TextStyle(
                                                  color: kTextColorB,
                                                  fontSize: 25,
                                                  fontFamily: "ScrambledTofu",
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (birthWeek < 40) {
                                                      birthWeek += 1;
                                                      print(birthWeek);
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.arrow_right,
                                                  color: Colors.black,
                                                ),
                                                iconSize: 40.0),
                                          ],
                                        ),
                                      ),
                                      height: myheight * .30,
                                      decoration:
                                          BoxDecoration(color: boxColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black, width: 2.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Center(
                                        child: Text("Doğum Kilosu",
                                            style: TextStyle(
                                                color: kTextColorW,
                                                fontSize: 25.0,
                                                fontFamily: 'ScrambledTofu')),
                                      ),
                                      height: myheight * .10,
                                      decoration:
                                          BoxDecoration(color: kPrimaryColor),
                                    ),
                                    Container(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            HoldDetector(
                                              onHold: () {
                                                setState(() {
                                                  if (birthWeight2 >= 505) {
                                                    birthWeight2 -= 5;
                                                    print(birthWeight2);
                                                  }
                                                });
                                              },
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (birthWeight2 > 500) {
                                                        birthWeight2 -= 1;
                                                        print(birthWeight2);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_left,
                                                    color: Colors.black,
                                                  ),
                                                  iconSize: 40.0),
                                            ),
                                            Text(
                                                birthWeight2.toString() + " gr",
                                                style: TextStyle(
                                                    color: kTextColorB,
                                                    fontSize: 25,
                                                    fontFamily:
                                                        "ScrambledTofu")),
                                            HoldDetector(
                                              onHold: () {
                                                setState(() {
                                                  if (birthWeight2 <= 5995) {
                                                    birthWeight2 += 5;
                                                    print(birthWeight2);
                                                  }
                                                });
                                              },
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (birthWeight2 < 6000) {
                                                        birthWeight2 += 1;
                                                        print(birthWeight2);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_right,
                                                    color: Colors.black,
                                                  ),
                                                  iconSize: 40.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      height: myheight * .30,
                                      decoration:
                                          BoxDecoration(color: boxColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black, width: 2.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Center(
                                        child: Text("Doğum Boyu",
                                            style: TextStyle(
                                                color: kTextColorW,
                                                fontSize: 25.0,
                                                fontFamily: 'ScrambledTofu')),
                                      ),
                                      height: myheight * .10,
                                      decoration:
                                          BoxDecoration(color: kPrimaryColor),
                                    ),
                                    Container(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            HoldDetector(
                                              onHold: () {
                                                setState(() {
                                                  if (birthLength2 >= 22.0) {
                                                    birthLength2 -= 2.0;
                                                    print(birthLength2);
                                                  }
                                                });
                                              },
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (birthLength2 >=
                                                          20.5) {
                                                        birthLength2 -= 0.5;
                                                        print(birthLength2);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_left,
                                                    color: Colors.black,
                                                  ),
                                                  iconSize: 40.0),
                                            ),
                                            Text(
                                                birthLength2.toString() + " cm",
                                                style: TextStyle(
                                                    color: kTextColorB,
                                                    fontSize: 25,
                                                    fontFamily:
                                                        "ScrambledTofu")),
                                            HoldDetector(
                                              onHold: () {
                                                setState(() {
                                                  if (birthLength2 <= 118) {
                                                    birthLength2 += 2.0;
                                                    print(birthLength2);
                                                  }
                                                });
                                              },
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (birthLength2 <=
                                                          119.5) {
                                                        birthLength2 += 0.5;
                                                        print(birthLength2);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_right,
                                                    color: Colors.black,
                                                  ),
                                                  iconSize: 40.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      height: myheight * .30,
                                      decoration:
                                          BoxDecoration(color: boxColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black, width: 2.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Center(
                                        child: Text("Baş Boyutu",
                                            style: TextStyle(
                                                color: kTextColorW,
                                                fontSize: 25.0,
                                                fontFamily: 'ScrambledTofu')),
                                      ),
                                      height: myheight * .10,
                                      decoration:
                                          BoxDecoration(color: kPrimaryColor),
                                    ),
                                    Container(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            HoldDetector(
                                              onHold: () {
                                                setState(() {
                                                  if (headSize2 >= 16.0) {
                                                    headSize2 -= 2.0;
                                                    print(headSize2);
                                                  }
                                                });
                                              },
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (headSize2 >= 14.5) {
                                                        headSize2 -= 0.5;
                                                        print(headSize2);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_left,
                                                    color: Colors.black,
                                                  ),
                                                  iconSize: 40.0),
                                            ),
                                            Text(headSize2.toString() + " cm",
                                                style: TextStyle(
                                                    color: kTextColorB,
                                                    fontSize: 25,
                                                    fontFamily:
                                                        "ScrambledTofu")),
                                            HoldDetector(
                                              onHold: () {
                                                setState(() {
                                                  if (headSize2 <= 58) {
                                                    headSize2 += 2.0;
                                                    print(headSize2);
                                                  }
                                                });
                                              },
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (headSize2 <= 59.5) {
                                                        headSize2 += 0.5;
                                                        print(headSize2);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_right,
                                                    color: Colors.black,
                                                  ),
                                                  iconSize: 40.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      height: myheight * .30,
                                      decoration:
                                          BoxDecoration(color: boxColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Text("Lütfen Bekleyin",
                style: TextStyle(color: kTextColorB, fontSize: 15.0)),
          )
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Image resimGetir(String url) {
    if (widget.option == 1) {
      if (sayac == 0) {
        sayac += 1;
        return Image.network(
            "https://firebasestorage.googleapis.com/v0/b/appbaby-68c8d.appspot.com/o/images%2Fbebek2.jpg?alt=media&token=08e729d7-701d-47ad-bcd3-51e603e574d7");
      } else {
        sayac += 1;
        if (_image.path != "") {
          return Image.file(File(_image.path));
        } else {
          return Image.network(
              "https://firebasestorage.googleapis.com/v0/b/appbaby-68c8d.appspot.com/o/images%2Fbebek2.jpg?alt=media&token=08e729d7-701d-47ad-bcd3-51e603e574d7");
        }
      }
    } else {
      if (sayac == 0) {
        sayac += 1;
        return Image.network(url);
      } else {
        sayac += 1;
        if (_image.path != "") {
          return Image.file(File(_image.path));
        } else {
          return Image.network(url);
        }
      }
    }
  }
}

//index ayarlama fonksiyonu
int setIndex(String cinsiyet) {
  if (cinsiyet == 'Erkek') {
    return 0;
  } else if (cinsiyet == 'Kız') {
    return 1;
  } else {
    return 2;
  }
}
