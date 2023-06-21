// import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:Brahmachaitanya/database/firebase.dart';
import 'package:intl/intl.dart';

import '../../models/jap_count.dart';

class JapCountPage extends StatelessWidget {
  // final DateTime date = DateTime.now();
  DateTime date1;
  JapCountPage({super.key, required this.date1});
  String getMonthInText(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  String convertToDDMMMM(DateTime date1) {
    // DateTime date = DateTime.parse(dateString);
    return DateFormat('dd MMMM').format(date1);
  }

  @override
  Widget build(BuildContext context) {
    int total = 0;
    // DateTime selectedMonth = DateTime(2023, 6); // Example month and year
    String monthInText = getMonthInText(date1);
    // print(monthInText); // Output: "June"
    String convertedDate = convertToDDMMMM(date1);
// print(convertedDate); // Output: "19 June"
    return Scaffold(
      appBar: AppBar(
        title: Text("Jap Count in $monthInText"),
      ),
      body: FutureBuilder(
        // future: Database().getJapCountByDate(date),
        future: Database().getJapCountByMonth(date1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Japcount> data = snapshot.data as List<Japcount>;
            return ListView.builder(
              itemCount: data.length == 0 ? 2 : data.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index != 0 && index != data.length + 1) {
                  total = total + int.parse(data[index - 1].japcount);
                  // print(total);
                }

                if (index == 0) {
                  return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              padding: const EdgeInsets.all(4.0),
                              width: 100.0,
                              child: const Text(
                                "Date",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                          Container(
                            width: 1,
                            color: Colors.black,
                          ),
                          Container(
                              padding: const EdgeInsets.all(4.0),
                              width: 100.0,
                              child: const Text(
                                "Name",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                          Container(
                            width: 1,
                            color: Colors.black,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            width: 100.0,
                            child: const Text(
                              "Jap Count",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else if (index == data.length + 1) {
                  return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            width: 100.0,
                            child: Text(
                              monthInText,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.black,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            width: 100.0,
                            child: const Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.black,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            width: 100.0,
                            child: Text(
                              "$total",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            width: 110.0,
                            child: Text(
                              convertToDDMMMM(data[index - 1].date),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.black,
                          ),
                          Container(
                            width: 110,
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              data[index - 1].fullName.split(' ')[0],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.black,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            width: 110.0,
                            child: Text(
                              data[index - 1].japcount,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return Container(
              child: const Text("Data Loading..."),
            );
          }
        },
      ),
    );
  }
}
