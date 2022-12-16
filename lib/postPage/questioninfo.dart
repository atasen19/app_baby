import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_app/model/answer.dart';
import 'package:plant_app/model/question.dart';
import '../constants.dart';
import '../firebaseFunctions.dart';

class QuestionInfo extends StatefulWidget {
  final QuestionModel question;
  const QuestionInfo({this.question});

  @override
  _QuestionInfoState createState() => _QuestionInfoState();
}

class _QuestionInfoState extends State<QuestionInfo> {
  List<AnswerModel> answerList = [];
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    func(widget.question);
  }

  @override
  Widget build(BuildContext context) {
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
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: kPrimaryColor),
                      iconSize: 30.0),
                ),
              ],
            ),
            SingleChildScrollView(
              child: FittedBox(
                child: DataTable(
                  dataRowHeight: 120,
                  showCheckboxColumn: false,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.lightGreen.withOpacity(0.2)),
                  columns: [
                    DataColumn(
                      label: Center(child: Text("Tarih")),
                    ),
                    DataColumn(
                      label: Center(child: Text("Email")),
                    ),
                    DataColumn(
                      label: Center(child: Text("Cevap")),
                    ),
                  ],
                  rows: dataRowList(answerList),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String optionTime(String date) {
    // ignore: unused_local_variable
    String formattedDate = "";
    DateTime dateTime = DateTime.parse(date);
    return formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
  }

  Future func(QuestionModel question) async {
    answerList = await FirebaseService().getQuestionInfo(question);
    setState(() {});
  }

  List<DataRow> dataRowList(List<AnswerModel> data) {
    List<DataRow> list = [];
    for (int i = 0; i < data.length; i++) {
      var temp = DataRow(cells: [
        DataCell(ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 100,
            minWidth: 25,
          ),
          child: Center(
              child: Text(
            optionTime(
              data[i].date,
            ),
            overflow: TextOverflow.visible,
            softWrap: true,
          )),
        )),
        DataCell(ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 150,
            minWidth: 25,
          ),
          child: Center(
              child: Text(
            data[i].userInfo,
            overflow: TextOverflow.visible,
            softWrap: true,
          )),
        )),
        DataCell(ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 200,
            minWidth: 25,
          ),
          child: Text(
            data[i].answerString,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        )),
      ]);
      list.add(temp);
    }
    return list;
  }
}
