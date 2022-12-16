
class MainTitleModel{
  String mainTitleId;
  String baslik;

  MainTitleModel({
    this.mainTitleId,
    this.baslik,
  });
  Map<String,dynamic> toMap(){
    return{
      'mainTitleId': mainTitleId,
      'baslik': baslik,
    };
  }

  factory MainTitleModel.fromMap(map){
    return MainTitleModel(
      mainTitleId: map['mainTitleId'],
      baslik: map['baslik'],
    );
  }
}