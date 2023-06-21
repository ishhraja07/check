// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Brahmachaitanya/views/Calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../constant/constants.dart';
// import '../../database/firebase.dart';
import '../../models/jap_count.dart';
import '../../models/user.dart';
import '../common_widgets.dart';

class userProgressScreen extends StatefulWidget {
  // final String uid;
  const userProgressScreen({
    Key? key,
    //  required this.uid
  }) : super(key: key);

  @override
  State<userProgressScreen> createState() => _userProgressScreenState();
}

class _userProgressScreenState extends State<userProgressScreen> {
  double targetJapCount = 10000000;
  // late UserModel userModel;
  // Future<List<Japcount>> getJapCount() async {
  //   FirebaseFirestore db = FirebaseFirestore.instance;
  //   double totaluserjapcount = 0;
  //   QuerySnapshot querysnap = await db
  //       .collection('jap')
  //       .where(
  //         'uid',
  //         isEqualTo: FirebaseAuth.instance.currentUser!.uid,
  //       )
  //       .get();
  //   for (var doc in querysnap.docs) {
  //     var myInt = double.parse(doc['japcount']);
  //     totaluserjapcount += myInt;
  //   }

  //   countList;
  //   return countList;
  // }

  Future<List<double>> getTotalJapCount() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference japCollection = db.collection('jap');
    List<double> list = [0, 0];

    double totalJapCount = 0;

    QuerySnapshot querySnapshot = await japCollection.get();
    for (var doc in querySnapshot.docs) {
      var myInt = double.parse(doc['japcount']);
      totalJapCount += myInt;
    }
    list[0] = totalJapCount;
    double totaluserjapcount = 0;
    QuerySnapshot querysnap = await db
        .collection('jap')
        .where(
          'uid',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    for (var doc in querysnap.docs) {
      var myInt = double.parse(doc['japcount']);
      totaluserjapcount += myInt;
    }
    list[1] = totaluserjapcount;
    return list;
  }

  Future<double> getTarget() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String target = await db
        .collection('admin')
        .doc('target')
        .get()
        .then((value) => value['target']);
    double code = double.parse(target);
    targetJapCount = code;
    return code;
  }

  Future<List<String>> getStart() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Timestamp start1 = await db
        .collection('admin')
        .doc('start')
        .get()
        .then((value) => value['start']);
    DateTime startDate = start1.toDate();

    String startString = DateFormat('dd-MM-yyyy').format(startDate);
    Timestamp end1 = await db
        .collection('admin')
        .doc('end')
        .get()
        .then((value) => value['end']);
    DateTime endDate = end1.toDate();

    String endString = DateFormat('dd-MM-yyyy').format(endDate);
    List<String> list1 = ["", ""];
    list1[0] = startString;
    list1[1] = endString;
    return list1;
  }

  Future<void> setTarget(String newTarget) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('admin').doc('target').set({'target': newTarget});
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _controller = TextEditingController();

    return FutureBuilder<List<String>>(
      future: getStart(),
      builder: (context2, snapshot2) {
        if (snapshot2.connectionState == ConnectionState.waiting) {
          Future.delayed(const Duration(seconds: 1));
          return const LinearProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.white,
          ); // Display a loading indicator while retrieving the count
        } else if (snapshot2.hasError) {
          return Text("${snapshot2.error}"
              // 'Error retrieving totalyee wala',
              ); // Display an error message if there's an error
        } else {
          return FutureBuilder<List<double>>(
            future: getTotalJapCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.white,
                ); // Display a loading indicator while retrieving the count
              } else if (snapshot.hasError) {
                return const Text(
                    'Error retrieving total Jap count'); // Display an error message if there's an error
              } else {
                return FutureBuilder<double>(
                  future: getTarget(),
                  builder: (context1, snapshot1) {
                    if (snapshot1.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.white,
                      ); // Display a loading indicator while retrieving the count
                    } else if (snapshot1.hasError) {
                      return Text(
                          'Error retrieving total Jap count'); // Display an error message if there's an error
                    } else {
                      List<String> answer = snapshot2.data!;
                      List<double> list = snapshot
                          .data!; // Get the retrieved count from the snapshot
                      double totalJapCount = list[0];
                      double totaluserJapCount = list[1];

                      double percentage =
                          (totalJapCount / targetJapCount) * 100;
                      double percentage1 =
                          (totalJapCount / targetJapCount) * 100;
                      double japleft = targetJapCount - totalJapCount;
                      String formattedPercentage =
                          percentage1.toStringAsFixed(0);
                      if (percentage > 100) {
                        percentage = 100;
                      }
                      ;
                      if (japleft < 0) {
                        japleft = 0;
                      }

                      return SafeArea(
                        child: Scaffold(
                          appBar: AppBar(
                            leading: null,
                            centerTitle: true,
                            title: const Center(
                              child: Text("My progress"),
                            ),
                          ),
                          body: Container(
                            color: COLOR_SCHEME['faint']!.withOpacity(0.5),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.02,
                                            ),
                                            Text(
                                              "${answer[0]} to ${answer[1]} ",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.055,
                                            ),
                                            Center(
                                              child: CircularPercentIndicator(
                                                radius: screenWidth / 2.5,
                                                lineWidth: screenWidth / 12,
                                                animation: true,
                                                animationDuration: 3000,
                                                percent: percentage / 100,
                                                progressColor:
                                                    COLOR_SCHEME['primary'],
                                                backgroundColor: Colors.white,
                                                circularStrokeCap:
                                                    CircularStrokeCap.round,
                                                center: Text(
                                                  "$formattedPercentage%",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 50,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.035,
                                            ),
                                            const Text(
                                              "Community Contribution",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            Text(
                                              "Target Jap count = ${targetJapCount.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            Text(
                                              "Japs completed = ${totalJapCount.toStringAsFixed(0)}",
                                              style: TextStyle(
                                                color: Colors.lightGreen[700],
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            Text(
                                              "Japs left= ${japleft.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.01),
                                            const Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            const Text(
                                              "Your Contribution",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            Text(
                                              "Your total Japs= ${totaluserJapCount.toStringAsFixed(0)}",
                                              style: TextStyle(
                                                color: Colors.lightGreen[700],
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(height: screenHeight),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
