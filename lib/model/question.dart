class QuestionModel{
  QuestionModel({
    this.mainTitleId,
    this.subTitleId,
    this.questionString,
    this.questionId,
  });

  String mainTitleId,subTitleId,questionString,questionId;



  factory QuestionModel.fromMap(map){
    return QuestionModel(
      mainTitleId: map['mainTitleId'],
      subTitleId: map['subTitleId'],
      questionString: map['questionString'],
      questionId: map['questionId'],
    );
  }
  Map<String, dynamic> QuestionModeltoMap() {
    return {
      'mainTitleId': mainTitleId,
      'subTitleId': subTitleId,
      'questionString': questionString,
      'questionId': questionId,
    };
  }
}