class Baby{
  Baby({
    this.id,
    this.image,
    this.name,
    this.age,
    this.gender,
    this.desc,
    this.birthDay,
    this.ageOfBirth,
    this.birthWeight,
    this.birthLength,
    this.headSize,
  });

  String image, name, desc, gender, id;
  int age, birthWeight, ageOfBirth, birthDay;
  double birthLength, headSize;


  factory Baby.fromMap(map){
    return Baby(
      id: map['id'],
      name: map['name'],
      desc: map['desc'],
      age: map['age'],
      gender: map['gender'],
      birthDay: map['birthDay'],
      ageOfBirth: map['ageOfBirth'],
      birthLength: map['birthLength'].toDouble(),
      birthWeight: map['birthWeight'],
      headSize: map['headSize'].toDouble(),
      image: map['image'],
    );
  }
  Map<String, dynamic> BabytoMap() {
    return {
      'id'  : id,
      'name': name,
      'desc': desc,
      'age': age,
      'gender': gender,
      'birthDay': birthDay,
      'ageOfBirth' : ageOfBirth,
      'birthLength': birthLength,
      'birthWeight': birthWeight,
      'headSize': headSize,
      'image': image,
    };
  }
}