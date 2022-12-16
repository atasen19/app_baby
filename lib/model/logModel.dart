class LogModel{
  LogModel({
    this.babyID,
    this.headSize,
    this.length,
    this.logID,
    this.weight,
  });

  String babyID, logID;
  int weight;
  double length, headSize;


  factory LogModel.fromMap(map){
    return LogModel(
      babyID: map['babyID'],
      headSize: map['headSize'].toDouble(),
      length: map['length'].toDouble(),
      logID: map['logID'],
      weight: map['weight'],
    );
  }
  Map<String, dynamic> LogModeltoMap() {
    return {
      'babyID'  : babyID,
      'headSize': headSize,
      'length': length,
      'logID': logID,
      'weight': weight,
    };
  }
}