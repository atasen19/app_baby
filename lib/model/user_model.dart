// import 'package:plant_app/model/baby.dart';
class UserModel {
  int admin;
  String uid;
  String email;
  String firstName;
  String secondName;

  UserModel(
      {this.admin, this.uid, this.email, this.firstName, this.secondName});

  factory UserModel.fromMap(map) {
    return UserModel(
      admin: map['admin'],
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'admin': admin,
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
    };
  }
}
