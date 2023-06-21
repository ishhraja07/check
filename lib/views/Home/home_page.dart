import 'dart:math';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Brahmachaitanya/constant/constants.dart';
import 'package:Brahmachaitanya/models/event.dart';
import 'package:Brahmachaitanya/views/Home/drawer.dart';
import '../../database/firebase.dart';
import '../../services/notifications.dart';
import '../../models/user.dart';
import '../Calendar/calendar.dart';
import '../common_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    List<EventData> allData = [];
    final Controller c = Get.put(Controller());

    return Scaffold(
      drawer: Drawer(
        elevation: 5,
        child: FutureBuilder(
            future: Database().getuserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                user = snapshot.data as UserModel;
                return MainDrawer(
                  user: user,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      // backgroundColor: Color.fromARGB(255, 248, 219, 211),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: COLOR_SCHEME['faint'],
          elevation: 0,
          title: Row(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Brahmachaitanya".tr,
                style: TextStyle(
                    fontSize: screenHeight * 0.035, //30
                    color: COLOR_SCHEME['primary'],
                    fontWeight: FontWeight.bold),
              ),
              // Text(
              //   "App".tr,
              //   style: TextStyle(
              //       fontSize: screenHeight * 0.03,
              //       color: Colors.black,
              //       fontWeight: FontWeight.bold),
              // )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                color: Colors.black,
                icon: Icon(Icons.refresh)),
            Builder(builder: (context) {
              return IconButton(
                  color: Colors.black,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                    // Get.to(MapScreen());
                  },
                  icon: Icon(
                    Icons.menu,
                    size: screenHeight * 0.045, //35
                  ));
            })
          ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: COLOR_SCHEME['faint'],
            padding: EdgeInsets.only(
                top: screenHeight * 0.01, left: screenWidth * 0.05), //10,17
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "Today is".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight * 0.03, //25
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${months[DateTime.now().month - 1].tr} ${DateTime.now().day}, ${DateTime.now().year}",
                    style: TextStyle(
                        fontSize: screenHeight * 0.025, //20
                        fontWeight: FontWeight.bold,
                        color: Colors.black38),
                  ),
                ]),
                Container(
                    padding: EdgeInsets.only(
                        right: screenWidth * 0.03,
                        bottom: screenHeight * 0.005), //10,5
                    height: screenHeight * 0.065, //55
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(const Calender());
                        },
                        child: Row(
                          children: [
                            Text(
                              "Calender".tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: screenWidth * 0.03, //10
                            ),
                            const Icon(
                              Icons.calendar_month,
                              size: 22,
                            )
                          ],
                        )))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(screenHeight * 0.015), //10
            decoration: BoxDecoration(
                color: COLOR_SCHEME['faint'],
                borderRadius: const BorderRadius.only(
                    // bottomLeft: Radius.circular(20),
                    // bottomRight: Radius.circular(20)
                    ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 10.0,
                      // spreadRadius: 6.0,
                      offset: const Offset(
                        0,
                        8,
                      )),
                ]),
            child: DatePicker(
              DateTime(DateTime.now().year, DateTime.now().month, 1),
              onDateChange: (date) {
                c.changeDate(date);
              },
              locale: Get.locale.toString(),
              daysCount: 32 - DateTime.now().day,
              height: [screenHeight * 0.15, 100].reduce(min) * 1.0,
              width: 70, //70
              initialSelectedDate: DateTime.now(),
              selectionColor: COLOR_SCHEME['primary']!,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: screenHeight * 0.02, left: screenWidth * 0.05),
            child: Text(
              "Events".tr,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: screenHeight * 0.035,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder(
            future: Database().getEventData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Obx(() {
                  allData = snapshot.data as List<EventData>;
                  List<EventData> events = [];

                  for (EventData event in allData) {
                    DateTime cmp = DateTime(
                      c.selectedDate.value.year,
                      c.selectedDate.value.month,
                      c.selectedDate.value.day,
                    );
                    if (event.date.day == c.selectedDate.value.day &&
                        event.date.year == c.selectedDate.value.year &&
                        event.date.month == c.selectedDate.value.month) {
                      events.add(event);
                    }
                  }
                  return Container(
                    constraints: BoxConstraints(
                      maxHeight: [screenHeight * 0.2, 150].reduce(max) * 1.0,
                    ),
                    padding: const EdgeInsets.all(5),
                    // color: Colors.amber,
                    child: events.isEmpty
                        ? Center(
                            child: Text("No Events On Selected Date"),
                          )
                        : Events(
                            axix: Axis.horizontal,
                            data: events,
                          ),
                  );
                });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Container(
            padding: EdgeInsets.only(
                top: screenHeight * 0.01, left: screenWidth * 0.05),
            child: Text(
              "Upcoming Events".tr,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: screenHeight * 0.035,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder(
              future: Database().getEventData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  allData = snapshot.data as List<EventData>;

                  List<EventData> upcoming = [];
                  for (EventData event in allData) {
                    if (event.date.day >= DateTime.now().day + 1 &&
                        event.date.month == DateTime.now().month &&
                        event.date.year == DateTime.now().year) {
                      upcoming.add(event);
                    }
                  }
                  return upcoming.isEmpty
                      ? Center(child: Text("No Upcoming Events"))
                      : Expanded(
                          child: Events(axix: Axis.vertical, data: upcoming),
                        );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }
}

class Events extends StatelessWidget {
  final axix;
  final List<EventData> data;
  const Events({required this.axix, required this.data});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
        scrollDirection: axix,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Get.bottomSheet(
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: EventInfo(event: data[index])),
            ),
            child: Container(
                margin: EdgeInsets.all(screenHeight * 0.01),
                width: 300,
                // height: 100, //100
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: COLOR_SCHEME['primary']!.withOpacity(0.1),
                ),
                child: Container(
                  padding: EdgeInsets.all(screenHeight * 0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index].title,
                        style: TextStyle(
                            color: COLOR_SCHEME['tertiary'],
                            fontSize: screenHeight * 0.023,
                            fontWeight: FontWeight.w500),
                      ),
                      Text("${data[index].date.day.toString()} " +
                          "${months[data[index].date.month - 1].tr} " +
                          "${data[index].date.year.toString()}"),
                      Text("Time".tr +
                          " : " +
                          "${data[index].from.toString().substring(11, 16)} - ${data[index].to.toString().substring(11, 16)}"),
                      Text(
                        "Venue".tr + " : " + " ${data[index].venue}",
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}

class Controller extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  changeDate(DateTime date) {
    selectedDate.value = date;
  }
}
