import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event.dart';
import '../models/jap_count.dart';
import '../models/user.dart';
import '../views/Calendar/jap.dart';

class Database {
  final db = FirebaseFirestore.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  //User
  Future<UserModel> getuserData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? adminInfo = prefs.getStringList('admin');
    if (adminInfo == null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var snap = await users.doc(uid).get();
      return UserModel.fromMap(snap);
    } else {
      return UserModel(
          email: adminInfo[0],
          fullName: adminInfo[2],
          userType: 'admin',
          address: adminInfo[3],
          location: adminInfo[4],
          uid: "");
    }
  }

  Future<List<UserModel>> searchUser() async {
    var snap = await db.collection('users').get();

    List<UserModel> list = snap.docs.map((e) => UserModel.fromMap(e)).toList();
    return list;
  }

  Future addUser(
      {required String fullName,
      required String email,
      required String address,
      required String userType,
      required String location,
      required String uid}) async {
    UserModel user = UserModel(
        email: email,
        fullName: fullName,
        userType: userType,
        address: address,
        location: location,
        uid: uid);

    await db.collection("users").doc(user.uid).set(user.toMap());

    print("user added $uid");
  }

  //Event
  Future<List<EventData>> getEventData() async {
    final snap = await db.collection('events').get();
    final List<EventData> eventList =
        snap.docs.map((event) => EventData.fromMap(event)).toList();
    return eventList;
  }

  Future<List<EventData>> getEventsByDate(DateTime date) async {
    final snap = await db.collection('events').get();
    final List<EventData> eventList = snap.docs.map((event) {
      return EventData.fromMap(event);
    }).toList();
    return eventList;
  }

  Future<List<EventData>> getUpcomingEvents() async {
    final snap = await db.collection('events').get();
    final List<EventData> eventList =
        snap.docs.map((event) => EventData.fromMap(event)).toList();
    return eventList;
  }

  Future addEvent(
      {required String title,
      required String description,
      required String description1,
      required String time,
      required DateTime date,
      required String venue,
      required DateTime from,
      required DateTime to,
      required String username,
      required String location,
      required String createdBy}) async {
    EventData newEvent = EventData(
        title: title,
        description: description,
        description1: description1,
        time: time,
        date: date,
        venue: venue,
        from: from,
        to: to,
        username: username,
        location: location,
        createdBy: createdBy);
    DocumentReference ref =
        await db.collection("events").add(newEvent.toMap()).then((value) async {
      await db.collection("events").doc(value.id).update({'id': value.id});
      print("value id ${value.id}");

      return value;
    });
  }

  //admin code
  Future<String> getCode() async {
    String code = await db
        .collection('admin')
        .doc('code')
        .get()
        .then((value) => value['code']);
    return code;
  }

  // Set target
  Future<void> setTarget(String newTarget) async {
    await db.collection('admin').doc('target').set({'target': newTarget});
  }

  // Get target
  Future<String> getTarget() async {
    String code = await db
        .collection('admin')
        .doc('target')
        .get()
        .then((value) => value['target']);
    return code;
  }

  //edit event data
  Future<void> editData(
      String id,
      String title,
      String username,
      String venue,
      String description,
      String description1,
      String location,
      DateTime from,
      DateTime to) async {
    await db.collection("events").doc(id).update({
      'title': title,
      'username': username,
      'venue': venue,
      'description': description,
      'description1': description1,
      'location': location,
      'from': from,
      'to': to
    });
  }

  //delete  event
  Future<void> deleteVoid(String id) async {
    await db.collection("events").doc(id).delete();
  }

  Future<List<String>> checkAdminGmail(String email) async {
    List<String> list = [];
    var snap = await db.collection('admin').doc('admins').get().then((value) {
      if (value['data'][0].toString() == email) {
        list.add(value['data'][0].toString());
        list.add(value['data'][2].toString());
        list.add(value['data'][3].toString());
        return;
      }
    });
    return list;
  }

  Future<List<String>> checkAdminEmail(String email, String password) async {
    List<String> list = [];
    var snap = await db.collection('admin').doc('admins').get().then((value) {
      if (value['data'][0].toString() == email &&
          value['data'][1].toString() == password) {
        list.add(value['data'][0].toString());
        list.add(value['data'][1].toString());
        list.add(value['data'][2].toString());
        list.add(value['data'][3].toString());
        list.add(value['data'][4].toString());
        return;
      }
    });
    return list;
  }

  //get jap count Admin
  Future<List<Japcount>> getJapCountByDate(DateTime date) async {
    final snap = await db.collection('jap').get();
    final List<Japcount> allDate = snap.docs.map((e) {
      return Japcount.fromMap(e);
    }).toList();
    List<Japcount> countList = [];
    for (var element in allDate) {
      if (element.date.day == date.day &&
          element.date.month == date.month &&
          element.date.year == date.year) {
        countList.add(element);
      }
    }
    return countList;
  }

  Future<List<Japcount>> getJapCountByYear(DateTime date) async {
    final snap = await db.collection('jap').get();
    final List<Japcount> allDate = snap.docs.map((e) {
      return Japcount.fromMap(e);
    }).toList();
    List<Japcount> countList = [];
    for (var element in allDate) {
      if (element.date.year == date.year) {
        countList.add(element);
      }
    }
    return countList;
  }

  // Future<List<Japcount>> getJapCountByMonth(DateTime date) async {
  //   final snap = await db.collection('jap').get();
  //   final List<Japcount> allDate = snap.docs.map((e) {
  //     return Japcount.fromMap(e);
  //   }).toList();

  //   List<Japcount> countList = [];

  //   for (var element in allDate) {
  //     if (element.date.year == date.year && element.date.month == date.month) {
  //       countList.add(element);
  //     }
  //   }

  //   return countList;
  // }
  Future<List<Japcount>> getJapCountByMonth(DateTime date) async {
    final snap = await db.collection('jap').get();
    final List<Japcount> allDate = snap.docs.map((e) {
      return Japcount.fromMap(e);
    }).toList();

    List<Japcount> countList = [];

    for (var element in allDate) {
      if (element.date.year == date.year && element.date.month == date.month) {
        countList.add(element);
      }
    }

    countList.sort((a, b) => a.date.compareTo(b.date));

    return countList;
  }

  // Future<int> getTotalJapCount() async {
  //   // FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference japCollection = db.collection('jap');

  //   int totalJapCount = 0;

  //   QuerySnapshot querySnapshot = await japCollection.get();
  //   for (var doc in querySnapshot.docs) {
  //     totalJapCount +=
  //         (doc['japcount'] as int?)!; // Add the japcount to the total
  //   }

  //   return totalJapCount;
  // }

  Future<List<Japcount>> getJapCount() async {
    final snap = await db
        .collection('jap')
        .where(
          'uid',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    final List<Japcount> allDate = snap.docs.map((e) {
      return Japcount.fromMap(e);
    }).toList();
    List<Japcount> countList = [];
    for (var element in allDate) {
      // if (element.date.year == date.year) {
      countList.add(element);
      // }
    }
    countList;
    return countList;
  }

  //add jap count user
  Future addJupCount(
      {required String fullName,
      required String japcount,
      required DateTime date,
      required String uid}) async {
    Japcount jp =
        Japcount(fullName: fullName, japcount: japcount, date: date, uid: uid);
    DocumentReference ref =
        await db.collection("jap").add(jp.toMap()).then((value) async {
      await db.collection("jap").doc(value.id).update({'id': value.id});
      print("value id ${value.id}");

      return value;
    });
  }

  Future<void> editJupCount(String id, String count) async {
    await db.collection("jap").doc(id).update({
      'japcount': count,
    });
  }

  //change username
  Future<void> changeUsername(String id, String username) async {
    await db.collection("users").doc(id).update({
      'fullName': username,
    });
  }

  //change address
  Future<void> changeAddress(String id, String address) async {
    await db.collection("users").doc(id).update({
      'address': address,
    });
  }

  //change location
  Future<void> changeLocation(String id, String location) async {
    await db.collection("users").doc(id).update({
      'location': location,
    });
  }
}
