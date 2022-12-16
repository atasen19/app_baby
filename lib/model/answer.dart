class AnswerModel{
  AnswerModel({
    this.mainTitleId,
    this.subTitleId,
    this.answerString,
    this.date,
    this.userId,
    this.questionId,
    this.userInfo,
  });

  String mainTitleId,subTitleId,answerString,userId,date,questionId,userInfo;



  factory AnswerModel.fromMap(map){
    return AnswerModel(
      mainTitleId: map['mainTitleId'],
      subTitleId: map['subTitleId'],
      answerString: map['answerString'],
      userId: map['userId'],
      date: map['date'],
      questionId: map['questionId'],
      userInfo: map['userInfo'],
    );
  }
  Map<String, dynamic> AnswerModeltoMap() {
    return {
      'mainTitleId': mainTitleId,
      'subTitleId': subTitleId,
      'answerString': answerString,
      'userId': userId,
      'date': date,
      'questionId': questionId,
      'userInfo': userInfo,
    };
  }
}