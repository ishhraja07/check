class Japcount {
  String fullName;
  String japcount;
  DateTime date;
  String? id;
  String uid;
  Japcount(
      {required this.fullName,
      required this.japcount,
      required this.date,
      required this.uid,
      this.id});

  // receive data from server -> creating map
  factory Japcount.fromMap(map) {
    return Japcount(
        id: map['id'],
        uid: map['uid'],
        fullName: map['fullName'],
        date: map['date'].toDate(),
        japcount: map['japcount']);
  }
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'japcount': japcount,
      'date': date,
      'uid': uid
    };
  }
}
