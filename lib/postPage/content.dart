import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/firebaseFunctions.dart';
import 'package:plant_app/model/answer.dart';
import 'package:plant_app/model/postmodel.dart';
import 'package:plant_app/model/question.dart';
import 'package:plant_app/postPage/questioninfo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Content extends StatefulWidget {
  final PostModel post;
  final bool visibiltyVariable;

  Content({
    Key key,
    this.visibiltyVariable,
    @required this.post,
  }) : super(key: key);

  @override
  _ContentState createState() =>
      _ContentState(post: post, visibiltyVariable: visibiltyVariable);
}

class _ContentState extends State<Content> {
  final bool visibiltyVariable;

  _ContentState({this.visibiltyVariable, this.post});

  PostModel post;
  bool textFieldVisibility = false;
  List<bool> answerTextFieldVisibility = [];
  List<bool> questionTextFieldVisibility = [];
  TextEditingController textEditingControllerBaslik = TextEditingController();
  TextEditingController textEditingControllerIcerik = TextEditingController();
  TextEditingController textEditingControllerVideoLink = TextEditingController();
  List<TextEditingController> textEditingControllerSoru = [];
  TextEditingController textEditingControllerYeniSoru = TextEditingController();
  List<TextEditingController> textEditingControllerCevap = [];
  List<QuestionModel> questionList = [];
  List<AnswerModel> answerList = [];
  var image = File("");
  int sayac = 0;
  final picker = ImagePicker();
  User user = FirebaseAuth.instance.currentUser;
  YoutubePlayerController _controller;

  @override
  void initState() {
    // Initiate the Youtube player controller
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(post.video_link),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        //disableDragSeek: true,
        mute: false,
        //loop: false,
        // enableCaption: false
      ),
    );
    super.initState();
    setState(() {});
    getQuestions(post);
  }

  File _image = File("");
  Future getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    post = widget.post;
    textEditingControllerIcerik.text = post.icerik;
    textEditingControllerBaslik.text = post.baslik;
    // String videoId = YoutubePlayer.convertUrlToId(post.video_link);

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
                Row(
                  children: [
                    Visibility(
                      visible: visibiltyVariable,
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        width: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0)),
                          ),
                          child: Icon(Icons.edit,
                              color: Colors.white, size: 30.0),
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
                    ),
                    Visibility(
                      visible: visibiltyVariable,
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        width: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0)),
                          ),
                          child: Icon(Icons.check,
                              color: Colors.white, size: 30.0),
                          onPressed: () async {
                            post.baslik = textEditingControllerBaslik.text;
                            post.icerik = textEditingControllerIcerik.text;
                            post.video_link = textEditingControllerVideoLink.text;
                            String resimUrl = "";
                            if (_image.path == "") {
                              _image = await FirebaseService()
                                  .fileFromImageUrl(post.image);
                              resimUrl = await FirebaseService()
                                  .uploadImageToFirebase(context, _image);
                              post.image = resimUrl;
                            } else {
                              resimUrl = await FirebaseService()
                                  .uploadImageToFirebase(context, _image);
                              post.image = resimUrl;
                            }

                            await FirebaseService().updateSubTitle(post);

                            setState(() {
                              if (textFieldVisibility == true) {
                                textFieldVisibility = false;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
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
                            backgroundImage: resimGetir(post.image).image,
                            radius: 90,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Container(
                          width: double.infinity,
                          child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: textFieldVisibility,
                              ),
                              enabled: textFieldVisibility,
                              controller: textEditingControllerBaslik,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: kTextColorB,
                                  fontFamily: "ScrambledTofu"))),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: Container(
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
                                  fontSize: 20,
                                  color: kTextColorB,
                                  fontFamily: "ScrambledTofu"))),
                    ),
                    if(_controller.initialVideoId != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: Container(
                          child: YoutubePlayer(
                            controller: _controller,
                            liveUIColor: Colors.amber,
                          ),),
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: visibiltyVariable,
                          child: Container(
                            width: 80,
                            height: 50,
                            margin: EdgeInsets.only(bottom: 40),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(29.0)),
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                              onPressed: () async {
                                showAlertDialogAdd(
                                  context,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                        itemCount: questionList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 0.0),
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            if (visibiltyVariable) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuestionInfo(
                                                          question:
                                                              questionList[
                                                                  index]),
                                                ),
                                              );
                                            } else {
                                              if (answerTextFieldVisibility[
                                                      index] ==
                                                  false) {
                                                answerTextFieldVisibility[
                                                    index] = true;
                                              } else {
                                                answerTextFieldVisibility[
                                                    index] = false;
                                              }
                                              setState(() {});
                                            }
                                          },
                                          title: Transform.translate(
                                            offset: Offset(0, 0),
                                            child: TextField(
                                              maxLines: null,
                                              enabled:
                                                  questionTextFieldVisibility[
                                                      index],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                filled:
                                                    questionTextFieldVisibility[
                                                        index],
                                              ),
                                              controller:
                                                  textEditingControllerSoru[
                                                      index],
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  fontFamily: 'ScrambledTofu',
                                                  color: kTextColorB),
                                            ),
                                          ),
                                          leading: Container(
                                              height: double.infinity,
                                              child: Icon(Icons.circle_rounded,
                                                  color: kTextColorB,
                                                  size: 13)),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Visibility(
                                                visible: visibiltyVariable,
                                                child: IconButton(
                                                    onPressed: () async {
                                                      if (questionTextFieldVisibility[
                                                          index]) {
                                                        questionTextFieldVisibility[
                                                            index] = false;
                                                        if (textEditingControllerSoru[
                                                                    index]
                                                                .text !=
                                                            questionList[index]
                                                                .questionString) {
                                                          questionList[index]
                                                                  .questionString =
                                                              textEditingControllerSoru[
                                                                      index]
                                                                  .text;
                                                          await FirebaseService()
                                                              .updateQuestion(
                                                                  questionList[
                                                                      index]);
                                                        }
                                                      } else {
                                                        questionTextFieldVisibility[
                                                            index] = true;
                                                      }
                                                      setState(() {});
                                                    },
                                                    icon: Icon(Icons.edit,
                                                        color: kTextColorB,
                                                        size: 20),
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        BoxConstraints()),
                                              ),
                                              Visibility(
                                                visible: visibiltyVariable,
                                                child: IconButton(
                                                    onPressed: () async {
                                                      await FirebaseService()
                                                          .deleteQuestion(
                                                              questionList[
                                                                  index]);
                                                      print(index);
                                                      questionList
                                                          .removeAt(index);
                                                      questionList
                                                          .forEach((element) {
                                                        print(element
                                                            .questionString);
                                                      });
                                                      textEditingControllerSoru
                                                          .removeAt(index);
                                                      setState(() {});
                                                    },
                                                    icon: Icon(Icons.delete,
                                                        color: kTextColorB,
                                                        size: 20)),
                                              ),
                                              Container(
                                                  height: double.infinity,
                                                  child: Icon(Icons.arrow_right,
                                                      color: kTextColorB,
                                                      size: 30)),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              answerTextFieldVisibility[index],
                                          child: TextField(
                                              maxLines: null,
                                              keyboardType: TextInputType.text,
                                              maxLength: 150,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.send),
                                                  onPressed: () async {
                                                    answerTextFieldVisibility[
                                                        index] = false;
                                                    AnswerModel answer = AnswerModel(
                                                        userId: user.uid,
                                                        subTitleId:
                                                            questionList[index]
                                                                .subTitleId,
                                                        mainTitleId:
                                                            questionList[index]
                                                                .mainTitleId,
                                                        questionId:
                                                            questionList[index]
                                                                .questionId,
                                                        date: DateTime.now()
                                                            .toString(),
                                                        userInfo: user.email,
                                                        answerString:
                                                            textEditingControllerCevap[
                                                                    index]
                                                                .text);
                                                    await FirebaseService(
                                                            uid: user.uid)
                                                        .addAnswer(answer);
                                                    setState(() {});
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Soruya verdiğiniz cevap kaydedildi",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        timeInSecForIosWeb: 2,
                                                        textColor: Colors.white,
                                                        fontSize: 14.0);
                                                  },
                                                ),
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                filled:
                                                    answerTextFieldVisibility[
                                                        index],
                                              ),
                                              enabled:
                                                  answerTextFieldVisibility[
                                                      index],
                                              controller:
                                                  textEditingControllerCevap[
                                                      index],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: kTextColorB,
                                                  fontFamily: "ScrambledTofu")),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getQuestions(PostModel postModel) async {
    questionList = await FirebaseService(uid: user.uid).getQuestions(postModel);
    questionTextFieldVisibility.clear();
    answerTextFieldVisibility.clear();
    textEditingControllerSoru.clear();
    textEditingControllerCevap.clear();
    answerList.clear();
    for (int i = 0; i < questionList.length; i++) {
      questionTextFieldVisibility.add(false);
      answerTextFieldVisibility.add(false);
      textEditingControllerSoru.add(TextEditingController());
      textEditingControllerCevap.add(TextEditingController());
      AnswerModel answer = await FirebaseService(uid: user.uid)
          .getAnswer(questionList[i], user.email);
      textEditingControllerCevap[i].text = answer.answerString;
      textEditingControllerSoru[i].text = questionList[i].questionString;
      answerList.add(answer);
    }
    setState(() {});
  }

  showAlertDialogAdd(BuildContext context) {
    textEditingControllerYeniSoru.text = "";
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("İptal", style: TextStyle(color: Colors.lightGreen)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Devam Et", style: TextStyle(color: Colors.red)),
      onPressed: () async {
        await FirebaseService()
            .addQuestion(widget.post, textEditingControllerYeniSoru.text);
        getQuestions(widget.post);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      title: Text("Soruyu Giriniz", style: TextStyle(color: kTextColorB)),
      content: TextField(
        controller: textEditingControllerYeniSoru,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 20.0, fontFamily: 'ScrambledTofu'),
          fillColor: Colors.white60,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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

  Image resimGetir(String url) {
    if (url == "" && _image.path == "") {
      return Image.network(
          "https://firebasestorage.googleapis.com/v0/b/appbaby-68c8d.appspot.com/o/images%2FHelp-Guide.png?alt=media&token=186251bc-a404-4272-bec5-666e0f2026c7");
    } else if (_image.path != "") {
      return Image.file(File(_image.path));
    } else {
      return Image.network(url);
    }
  }
}
