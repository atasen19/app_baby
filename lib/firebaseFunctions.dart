import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/model/answer.dart';
import 'package:plant_app/model/baby.dart';
import 'package:plant_app/model/logModel.dart';
import 'package:plant_app/model/mainTitle.dart';
import 'package:plant_app/model/postmodel.dart';
import 'package:plant_app/model/question.dart';
import 'package:plant_app/model/user_model.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// final HttpClient _httpClient = HttpClient();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference userCollection = _firestore.collection('users');
final CollectionReference postsCollection = _firestore.collection('posts');

class FirebaseService {
  List array = [];

  List<PostModel> PostModelList = [];

  final String uid;
  FirebaseService({this.uid});
  UserModel userModel = UserModel();

  Future addBaby(Baby baby) async {
    print(uid);

    var convert = DateTime.fromMillisecondsSinceEpoch(baby.birthDay);
    var newDocId = await userCollection.doc(uid).collection("babies").doc();

    try {
      await userCollection.doc(uid).collection("babies").doc(newDocId.id).set({
        'id': newDocId.id,
        'name': baby.name,
        'desc': baby.desc,
        'age': baby.age,
        'gender': baby.gender,
        'birthDay': baby.birthDay,
        'ageOfBirth': baby.ageOfBirth,
        'birthLength': baby.birthLength,
        'birthWeight': baby.birthWeight,
        'headSize': baby.headSize,
        'image': baby.image,
      });
    } catch (e) {
      print(e);
    }

    LogModel logModel = LogModel(
      headSize: baby.headSize,
      babyID: newDocId.id,
      length: baby.birthLength,
      weight: baby.birthWeight,
      logID: convert.toString(),
    );
    await FirebaseService(uid: uid).addBabyLog(logModel);
  }

  Future<List> getBabies() async {
    var babyList = await userCollection.doc(uid).collection("babies").get();
    List<DocumentSnapshot> document = babyList.docs;
    List<Baby> result = [];
    document.forEach((element) {
      result.add(Baby.fromMap(element));
    });
    return result;
  }

  Future deleteBaby(Baby baby) async {
    print(uid);
    await userCollection.doc(uid).collection("babies").doc(baby.id).delete();
  }

  Future updateBaby(Baby baby) async {
    print(uid);
    await userCollection.doc(uid).collection("babies").doc(baby.id).update({
      'name': baby.name,
      'desc': baby.desc,
      'age': baby.age,
      'gender': baby.gender,
      'birthDay': baby.birthDay,
      'ageOfBirth': baby.ageOfBirth,
      'birthLength': baby.birthLength,
      'birthWeight': baby.birthWeight,
      'headSize': baby.headSize,
      'image': baby.image,
    });
  }

  Future addBabyLog(LogModel logModel) async {
    print("***********");
    print(logModel.babyID);
    print(uid);
    print(logModel.logID);
    print("***********");

    var newDocId = await userCollection
        .doc(uid)
        .collection("babies")
        .doc(logModel.babyID)
        .collection("log")
        .doc(logModel.logID);
    await userCollection
        .doc(uid)
        .collection("babies")
        .doc(logModel.babyID)
        .collection("log")
        .doc(newDocId.id)
        .set({
      'babyID': logModel.babyID,
      'logID': newDocId.id,
      'length': logModel.length,
      'headSize': logModel.headSize,
      'weight': logModel.weight,
    });
  }

  Future<List> getBabyLog(String babyID) async {
    var babyLogList = await userCollection
        .doc(uid)
        .collection("babies")
        .doc(babyID)
        .collection("log")
        .get();
    List<DocumentSnapshot> document = babyLogList.docs;
    List result = [];
    document.forEach((element) {
      result.add(LogModel.fromMap(element));
    });
    return result;
  }

  Future updateBabyLog(LogModel logModel) async {
    print(logModel.babyID);
    print(uid);

    await userCollection
        .doc(uid)
        .collection("babies")
        .doc(logModel.babyID)
        .collection("log")
        .doc(logModel.logID)
        .update({
      'babyID': logModel.babyID,
      'logID': logModel.logID,
      'length': logModel.length,
      'headSize': logModel.headSize,
      'weight': logModel.weight,
    });
  }

  Future deleteBabyLog(LogModel logModel) async {
    print(logModel.babyID);
    print(uid);

    await userCollection
        .doc(uid)
        .collection("babies")
        .doc(logModel.babyID)
        .collection("log")
        .doc(logModel.logID)
        .delete();
  }

  Future addQuestion(PostModel post, String questionString) async {
    print("***********");
    print(uid);
    print(post.parentId);
    print("***********");

    var newDocId = await postsCollection
        .doc(post.parentId)
        .collection("subtitle")
        .doc(post.id)
        .collection("sorular")
        .doc();
    await postsCollection
        .doc(post.parentId)
        .collection("subtitle")
        .doc(post.id)
        .collection("sorular")
        .doc(newDocId.id)
        .set({
      'mainTitleId': post.parentId,
      'subTitleId': post.id,
      'questionString': questionString,
      'questionId': newDocId.id,
    });
  }

  Future<List<QuestionModel>> getQuestions(PostModel postModel) async {
    var questionList = await postsCollection
        .doc(postModel.parentId)
        .collection("subtitle")
        .doc(postModel.id)
        .collection("sorular")
        .get();
    List<DocumentSnapshot> document = questionList.docs;
    print(postModel.id);
    print(postModel.parentId);
    List<QuestionModel> result = [];
    document.forEach((element) {
      result.add(QuestionModel.fromMap(element));
    });
    return result;
  }

  Future updateQuestion(QuestionModel questionModel) async {
    print(questionModel.mainTitleId);
    print(uid);

    await postsCollection
        .doc(questionModel.mainTitleId)
        .collection("subtitle")
        .doc(questionModel.subTitleId)
        .collection("sorular")
        .doc(questionModel.questionId)
        .update({
      'mainTitleId': questionModel.mainTitleId,
      'subTitleId': questionModel.subTitleId,
      'questionString': questionModel.questionString,
      'questionId': questionModel.questionId,
    });
  }

  Future deleteQuestion(QuestionModel questionModel) async {
    print(questionModel.questionId);
    print(uid);

    await postsCollection
        .doc(questionModel.mainTitleId)
        .collection("subtitle")
        .doc(questionModel.subTitleId)
        .collection("sorular")
        .doc(questionModel.questionId)
        .delete();
  }

  Future addAnswer(AnswerModel answerModel) async {
    print("***********");
    print(uid);
    print(answerModel.userId);
    print("***********");

    var newDocId = await postsCollection
        .doc(answerModel.mainTitleId)
        .collection("subtitle")
        .doc(answerModel.subTitleId)
        .collection("sorular")
        .doc(answerModel.questionId)
        .collection("cevaplar")
        .doc(answerModel.userId);
    await postsCollection
        .doc(answerModel.mainTitleId)
        .collection("subtitle")
        .doc(answerModel.subTitleId)
        .collection("sorular")
        .doc(answerModel.questionId)
        .collection("cevaplar")
        .doc(newDocId.id)
        .set({
      'mainTitleId': answerModel.mainTitleId,
      'subTitleId': answerModel.subTitleId,
      'answerString': answerModel.answerString,
      'date': answerModel.date,
      'userId': answerModel.userId,
      'questionId': answerModel.questionId,
      'userInfo': answerModel.userInfo,
    });
  }

  Future<AnswerModel> getAnswer(
      QuestionModel questionModel, String email) async {
    DocumentSnapshot snapshot = await postsCollection
        .doc(questionModel.mainTitleId)
        .collection("subtitle")
        .doc(questionModel.subTitleId)
        .collection("sorular")
        .doc(questionModel.questionId)
        .collection("cevaplar")
        .doc(uid)
        .get();
    if (snapshot.exists) {
      AnswerModel answerModel = AnswerModel.fromMap(snapshot.data());
      return answerModel;
    } else {
      AnswerModel defAnswer = AnswerModel(
        answerString: "",
        date: DateTime.now().toString(),
        mainTitleId: questionModel.mainTitleId,
        questionId: questionModel.questionId,
        subTitleId: questionModel.subTitleId,
        userId: uid,
        userInfo: email,
      );
      return defAnswer;
    }
  }

  Future updateAnswer(AnswerModel answerModel) async {
    print(answerModel.mainTitleId);
    print(uid);
    await postsCollection
        .doc(answerModel.mainTitleId)
        .collection("subtitle")
        .doc(answerModel.subTitleId)
        .collection("sorular")
        .doc(answerModel.questionId)
        .collection("cevaplar")
        .doc(answerModel.userId)
        .update({
      'mainTitleId': answerModel.mainTitleId,
      'subTitleId': answerModel.subTitleId,
      'answerString': answerModel.answerString,
      'questionId': answerModel.questionId,
      'userId': answerModel.userId,
      'date': answerModel.date,
      'userInfo': answerModel.userInfo,
    });
  }

  Future deleteAnswer(AnswerModel answerModel) async {
    print(answerModel.questionId);
    print(uid);
    await postsCollection
        .doc(answerModel.mainTitleId)
        .collection("subtitle")
        .doc(answerModel.subTitleId)
        .collection("sorular")
        .doc(answerModel.questionId)
        .collection("cevaplar")
        .doc(answerModel.userId)
        .delete();
  }

  Future<List<MainTitleModel>> getPosts() async {
    print("--------");
    var questionList = await postsCollection.get();
    List<DocumentSnapshot> document = questionList.docs;
    List<MainTitleModel> result = [];
    document.forEach((element) {
      result.add(MainTitleModel.fromMap(element));
    });
    return result;
  }

  Future<List<PostModel>> getPostDocuments(
      MainTitleModel mainTitleModel) async {
    var docList = await postsCollection
        .doc(mainTitleModel.mainTitleId)
        .collection("subtitle")
        .get();
    List<DocumentSnapshot> document = docList.docs;
    List<PostModel> result = [];
    document.forEach((element) {
      result.add(PostModel.fromMap(element));
    });
    return result;
  }

  addMainTitle(String title) async {
    var newDocId = postsCollection.doc();
    await postsCollection.doc(newDocId.id).set({
      "baslik": title,
      "mainTitleId": newDocId.id,
    });
  }

  deleteMainTitle(MainTitleModel mainTitleModel) async {
    await postsCollection.doc(mainTitleModel.mainTitleId).delete();
  }

  updateMainTitle(MainTitleModel mainTitleModel) async {
    await postsCollection.doc(mainTitleModel.mainTitleId).update({
      "baslik": mainTitleModel.baslik,
      "mainTitleId": mainTitleModel.mainTitleId,
    });
  }

  addSubTitle(MainTitleModel mainTitleModel, String subTitle) async {
    var newDocId = postsCollection
        .doc(mainTitleModel.mainTitleId)
        .collection("subtitle")
        .doc();
    await postsCollection
        .doc(mainTitleModel.mainTitleId)
        .collection("subtitle")
        .doc(newDocId.id)
        .set({
      "parentId": mainTitleModel.mainTitleId,
      "id": newDocId.id,
      "ana_baslik": mainTitleModel.baslik,
      "baslik": subTitle,
      "icerik": "",
      "image": ""
    });
  }

  deleteSubTitle(PostModel postModel) async {
    await postsCollection
        .doc(postModel.parentId)
        .collection("subtitle")
        .doc(postModel.id)
        .delete();
  }

  updateSubTitle(PostModel postModel) async {
    await postsCollection
        .doc(postModel.parentId)
        .collection("subtitle")
        .doc(postModel.id)
        .update({
      "parentId": postModel.parentId,
      "id": postModel.id,
      "ana_baslik": postModel.ana_baslik,
      "baslik": postModel.baslik,
      "icerik": postModel.icerik,
      "image": postModel.image,
    });
  }

  Future<bool> getAdminState() async {
    int result;
    Future<DocumentSnapshot> snapshot = userCollection.doc(uid).get();
    result = await snapshot.then((value) => UserModel.fromMap(value).admin);
    if (result == 1) {
      return true;
    } else
      return false;
  }

  Future uploadImageToFirebase(BuildContext context, File _imageFile) async {
    String url;

    // String fileName = basename(_imageFile.path);
    FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
    Reference reference =
        firebaseStorageRef.ref().child("images/" + Uuid().v4());
    UploadTask uploadTask = reference.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
      url = await reference.getDownloadURL();
    });
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );

    return url;
  }

  Future<File> fileFromImageUrl(String string) async {
    Uri uri = Uri.parse(string);
    final response = await http.get(uri);

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  deleteImage(String url) async {
    FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
    Reference ref = await firebaseStorageRef.refFromURL(url);
    await ref.delete();
  }

  Future<List<AnswerModel>> getQuestionInfo(QuestionModel question) async {
    var answerList = await postsCollection
        .doc(question.mainTitleId)
        .collection("subtitle")
        .doc(question.subTitleId)
        .collection("sorular")
        .doc(question.questionId)
        .collection("cevaplar")
        .get();
    List<DocumentSnapshot> document = answerList.docs;
    List<AnswerModel> result = [];
    document.forEach((element) {
      result.add(AnswerModel.fromMap(element));
    });
    return result;
  }
}
