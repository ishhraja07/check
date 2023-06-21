import 'package:Brahmachaitanya/views/Calendar/setTarget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Brahmachaitanya/views/Calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../constant/constants.dart';
import '../../models/jap_count.dart';
import '../../models/user.dart';
import '../common_widgets.dart';

class ProgressScreen extends StatefulWidget {
  // final String uid;
  const ProgressScreen({
    Key? key,
    //  required this.uid
  }) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  double targetJapCount = 10000000;
  // late UserModel userModel;

  Future<double> getTotalJapCount() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference japCollection = firestore.collection('jap');

    double totalJapCount = 0;

    QuerySnapshot querySnapshot = await japCollection.get();
    for (var doc in querySnapshot.docs) {
      var myInt = double.parse(doc['japcount']);
      totalJapCount += myInt;
    }

    return totalJapCount;
  }

  Future<void> setTarget(String newTarget) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    // await Future.delayed(const Duration(seconds: 5));
    await db.collection('admin').doc('target').set({'target': newTarget});
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
          Future.delayed(Duration(seconds: 1));
          return LinearProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.white,
          ); // Display a loading indicator while retrieving the count
        } else if (snapshot2.hasError) {
          return Text(
            "${snapshot2.error}",
          ); // Display an error message if there's an error
        } else {
          // List<strin
          return FutureBuilder<double>(
            future: getTotalJapCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Future.delayed(Duration(seconds: 1));
                return LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.white,
                ); // Display a loading indicator while retrieving the count
              } else if (snapshot.hasError) {
                return Text(
                  'Error retrieving total Jap count',
                ); // Display an error message if there's an error
              } else {
                return FutureBuilder<double>(
                  future: getTarget(),
                  builder: (context1, snapshot1) {
                    try {
                      if (snapshot1.connectionState ==
                          ConnectionState.waiting) {
                        Future.delayed(Duration(seconds: 1));
                        return LinearProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.white,
                        ); // Display a loading indicator while retrieving the count
                      } else if (snapshot1.hasError) {
                        return Text(
                          'Error retrieving total Jap count',
                        ); // Display an error message if there's an error
                      } else {
                        List<String> answer = snapshot2.data!;
                        answer[0];
                        double totalJapCount = snapshot
                            .data!; // Get the retrieved count from the snapshot
                        double percentage =
                            (totalJapCount / targetJapCount) * 100;
                        double percentage1 =
                            (totalJapCount / targetJapCount) * 100;
                        String formattedPercentage =
                            percentage1.toStringAsFixed(0);
                        if (percentage > 100) {
                          percentage = 100;
                        }
                        ;
                        double japleft = targetJapCount - totalJapCount;
                        if (japleft < 0) {
                          japleft = 0;
                        }

                        return SafeArea(
                          child: Container(
                            color: COLOR_SCHEME['faint']!.withOpacity(0.5),
                            child: Scaffold(
                              appBar: AppBar(
                                leading: null,
                                centerTitle: true,
                                title: Center(
                                  child: Text("My progress"),
                                ),
                              ),
                              body: Container(
                                color: COLOR_SCHEME['faint']!.withOpacity(0.5),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
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
                                                  // "Community Contribution",
                                                  "${answer[0]} to ${answer[1]} ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: screenHeight * 0.065,
                                                ),
                                                Center(
                                                  child:
                                                      CircularPercentIndicator(
                                                    radius: screenWidth / 2.5,
                                                    lineWidth: screenWidth / 12,
                                                    animation: true,
                                                    animationDuration: 3000,
                                                    percent:
                                                        // (totalJapCount /targetJapCount),
                                                        percentage / 100,
                                                    progressColor:
                                                        COLOR_SCHEME['primary'],
                                                    backgroundColor:
                                                        Colors.white,
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    center: Text(
                                                      "$formattedPercentage%",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 50,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.035),
                                                const Text(
                                                  "Community Contribution",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.02),
                                                Text(
                                                  "Target Jap count = ${targetJapCount.toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.02),
                                                Text(
                                                  "Japs completed = ${totalJapCount.toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.lightGreen[700],
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.02),
                                                Text(
                                                  "Japs left= ${japleft.toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 24,
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
                          ),
                        );
                      }
                    } catch (e) {
                      return LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.white,
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
