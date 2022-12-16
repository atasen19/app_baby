// import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:intl/intl.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/details/details.dart';
import 'package:plant_app/firebaseFunctions.dart';
import 'package:plant_app/model/baby.dart';
import 'package:plant_app/model/logModel.dart';

class BabyLog extends StatefulWidget {
  Baby baby;
  bool visibilityVariable;

  BabyLog({this.baby, this.visibilityVariable});

  @override
  _BabyLogState createState() =>
      _BabyLogState(visibilityVariable: visibilityVariable);
}

class _BabyLogState extends State<BabyLog> {
  User user = FirebaseAuth.instance.currentUser;
  int intdate;
  String dateTime;
  bool visibilityVariable;

  _BabyLogState({this.visibilityVariable});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DetailsScreen(
                babydata: widget.baby,
                visibilityVariable: visibilityVariable)));
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
                                      babydata: widget.baby,
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
                          child:
                              Icon(Icons.add, color: kPrimaryColor, size: 30.0),
                          onPressed: () {
                            showAlertDialog(context, widget.baby);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              FutureBuilder(
                  future:
                      FirebaseService(uid: user.uid).getBabyLog(widget.baby.id),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      LogModel logModel = LogModel(
                        babyID: widget.baby.id,
                        headSize: 12.0,
                        length: 13.0,
                        logID: DateTime.now().toString(),
                        weight: 15,
                      );
                      return SingleChildScrollView(
                          child: FittedBox(
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.lightGreen.withOpacity(0.2)),
                          columns: [
                            DataColumn(
                              label: Center(child: Text("Tarih")),
                            ),
                            DataColumn(
                              label: Center(child: Text("Uzunluk")),
                            ),
                            DataColumn(
                              label: Center(child: Text("Ağırlık")),
                            ),
                            DataColumn(
                              label: Center(child: Text("Baş Boyutu")),
                            ),
                          ],
                          rows: datarowlist(snapshot.data),
                        ),
                      ));
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return null;
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      ),
    );
  }

  String optionTime(String date) {
    String formattedDate = "";
    DateTime dateTime = DateTime.parse(date);
    return formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
  }

  List<DataRow> datarowlist(List data) {
    List<DataRow> list = [];
    for (int i = 0; i < data.length; i++) {
      var temp = DataRow(
          onSelectChanged: (bool selected) {
            if (selected) {
              showAlertDialogUpdate(context, widget.baby, data[i]);
            }
          },
          cells: [
            DataCell(Center(child: Text(optionTime(data[i].logID)))),
            DataCell(Center(child: Text(data[i].length.toString()))),
            DataCell(Center(child: Text(data[i].weight.toString()))),
            DataCell(Center(child: Text(data[i].headSize.toString())))
          ]);
      list.add(temp);
    }
    ;
    return list;
  }

  showAlertDialog(BuildContext context, Baby baby) {
    context;
    var myheight = MediaQuery.of(context).size.height * .50;
    // var mywidth = MediaQuery.of(context).size.width * .50;

    double uzunluk = 34;
    double basBoyutu = 28;
    int agirlik = 1200;
    dateTime = DateTime.now().toString();

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("İptal", style: TextStyle(color: Colors.lightGreen)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ekle", style: TextStyle(color: Colors.red)),
      onPressed: () async {
        LogModel logmodel = LogModel(
          length: uzunluk,
          weight: agirlik,
          headSize: basBoyutu,
          babyID: widget.baby.id,
          logID: dateTime,
        );
        await FirebaseService(uid: user.uid).addBabyLog(logmodel);
        setState(() {});
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      title: StatefulBuilder(
        builder: (context, setState) => RichText(
            text: TextSpan(
          style: TextStyle(
            fontFamily: "ScrambledTofu",
            fontSize: 20.0,
            color: kTextColorB,
            fontWeight: FontWeight.bold,
          ),
          text: optionTime(dateTime.toString()),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              DateTime mydate = DateTime.parse(dateTime);

              intdate = mydate.millisecondsSinceEpoch;

              final DateTime pickedDate = await showDatePicker(
                  context: context,
                  initialDate: mydate,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2050));
              if (pickedDate != null && pickedDate != mydate) {
                mydate = pickedDate;
                dateTime = mydate.toString();
                intdate = mydate.millisecondsSinceEpoch;
                print(mydate);
                setState(() {});
              }
            },
        )),
      ),
      content: StatefulBuilder(
        builder: (context, setState) => Container(
          height: myheight * .40,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Uzunluk"),
                  Row(
                    children: [
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (uzunluk >= 22.0) {
                              uzunluk -= 2.0;
                              print(uzunluk);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (uzunluk >= 20.5) {
                                  uzunluk -= 0.5;
                                  print(uzunluk);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_left,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                      Text(uzunluk.toString() + " cm"),
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (uzunluk <= 118) {
                              uzunluk += 2.0;
                              print(uzunluk);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (uzunluk <= 119.5) {
                                  uzunluk += 0.5;
                                  print(uzunluk);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_right,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ağırlık"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (agirlik >= 505) {
                              agirlik -= 5;
                              print(agirlik);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (agirlik > 500) {
                                  agirlik -= 1;
                                  print(agirlik);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_left,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                      Text(agirlik.toString() + " gr"),
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (agirlik <= 5995) {
                              agirlik += 5;
                              print(agirlik);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (agirlik < 6000) {
                                  agirlik += 1;
                                  print(agirlik);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_right,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Baş"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (basBoyutu >= 16.0) {
                              basBoyutu -= 2.0;
                              print(basBoyutu);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (basBoyutu >= 14.5) {
                                  basBoyutu -= 0.5;
                                  print(basBoyutu);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_left,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                      Text(basBoyutu.toString() + " cm"),
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (basBoyutu <= 58) {
                              basBoyutu += 2.0;
                              print(basBoyutu);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (basBoyutu <= 59.5) {
                                  basBoyutu += 0.5;
                                  print(basBoyutu);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_right,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogUpdate(BuildContext context, Baby baby, LogModel log) {
    context;
    var myheight = MediaQuery.of(context).size.height * .50;
    // var mywidth = MediaQuery.of(context).size.width * .50;

    double uzunluk = log.length;
    double basBoyutu = log.headSize;
    int agirlik = log.weight;
    dateTime = log.logID;

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Sil", style: TextStyle(color: Colors.red)),
      onPressed: () async {
        await FirebaseService(uid: user.uid).deleteBabyLog(log);
        Navigator.of(context).pop();
        setState(() {});
      },
    );
    Widget continueButton = TextButton(
      child: Text("Guncelle", style: TextStyle(color: Colors.lightGreen)),
      onPressed: () async {
        await FirebaseService(uid: user.uid).deleteBabyLog(log);
        log.logID = dateTime;
        log.length = uzunluk;
        log.weight = agirlik;
        log.headSize = basBoyutu;
        await FirebaseService(uid: user.uid).addBabyLog(log);
        setState(() {});
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      title: StatefulBuilder(
        builder: (context, setState) => RichText(
            text: TextSpan(
          style: TextStyle(
            fontFamily: "ScrambledTofu",
            fontSize: 20.0,
            color: kTextColorB,
            fontWeight: FontWeight.bold,
          ),
          text: optionTime(dateTime.toString()),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              DateTime mydate = DateTime.parse(log.logID);

              intdate = mydate.millisecondsSinceEpoch;

              final DateTime pickedDate = await showDatePicker(
                  context: context,
                  initialDate: mydate,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2050));
              if (pickedDate != null && pickedDate != mydate) {
                mydate = pickedDate;
                dateTime = mydate.toString();
                intdate = mydate.millisecondsSinceEpoch;
                print(mydate);
                setState(() {});
              }
            },
        )),
      ),
      content: StatefulBuilder(
        builder: (context, setState) => Container(
          height: myheight * .40,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Uzunluk"),
                  Row(
                    children: [
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (uzunluk >= 22.0) {
                              uzunluk -= 2.0;
                              print(uzunluk);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (uzunluk >= 20.5) {
                                  uzunluk -= 0.5;
                                  print(uzunluk);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_left,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                      Text(uzunluk.toString() + " cm"),
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (uzunluk <= 118) {
                              uzunluk += 2.0;
                              print(uzunluk);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (uzunluk <= 119.5) {
                                  uzunluk += 0.5;
                                  print(uzunluk);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_right,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ağırlık"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (agirlik >= 505) {
                              agirlik -= 5;
                              print(agirlik);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (agirlik > 500) {
                                  agirlik -= 1;
                                  print(agirlik);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_left,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                      Text(agirlik.toString() + " gr"),
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (agirlik <= 5995) {
                              agirlik += 5;
                              print(agirlik);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (agirlik < 6000) {
                                  agirlik += 1;
                                  print(agirlik);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_right,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Baş"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (basBoyutu >= 16.0) {
                              basBoyutu -= 2.0;
                              print(basBoyutu);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (basBoyutu >= 14.5) {
                                  basBoyutu -= 0.5;
                                  print(basBoyutu);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_left,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                      Text(basBoyutu.toString() + " cm"),
                      HoldDetector(
                        onHold: () {
                          setState(() {
                            if (basBoyutu <= 58) {
                              basBoyutu += 2.0;
                              print(basBoyutu);
                            }
                          });
                        },
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (basBoyutu <= 59.5) {
                                  basBoyutu += 0.5;
                                  print(basBoyutu);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_right,
                              color: Colors.black,
                            ),
                            iconSize: 30.0),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
