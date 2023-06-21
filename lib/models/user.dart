class UserModel {
  String email;
  String fullName;
  String userType;
  String address;
  String location;
  String uid;
  UserModel(
      {required this.email,
      required this.fullName,
      required this.userType,
      required this.address,
      required this.location,
      required this.uid});

  // receive data from server -> creating map
  factory UserModel.fromMap(map) {
    return UserModel(
        email: map['email'],
        uid: map['uid'],
        fullName: map['fullName'],
        address: map['address'],
        location: map['location'],
        userType: map['userType']);
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'userType': userType,
      'address': address,
      'uid': uid,
      'location': location
    };
  }
}
