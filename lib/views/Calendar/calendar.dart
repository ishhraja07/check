import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:Brahmachaitanya/constant/constants.dart';
import 'package:Brahmachaitanya/models/jap_count.dart';
import 'package:Brahmachaitanya/models/user.dart';
import 'package:Brahmachaitanya/views/Calendar/jap.dart';
import 'package:Brahmachaitanya/views/Calendar/progressScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../database/firebase.dart';

import 'package:flutter_google_location_picker/flutter_google_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/event.dart';
import '../../services/notifications.dart';
import '../common_widgets.dart';

DateTime from = DateTime.now();
DateTime to = DateTime.now();

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => CalenderState();
}

class CalenderState extends State<Calender> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  List<EventData> allData = [];
  CalendarController _controller = CalendarController();
  final TextEditingController hostController = TextEditingController();
  final TextEditingController eventnameController = TextEditingController();
  final TextEditingController venueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController description1Controller = TextEditingController();
  TextEditingController? description2controller;
  static DateTime time = DateTime.now();
  // static DateTime from = DateTime.now();
  // static DateTime to = DateTime.now();
  static String location = "";
  late UserModel userModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    hostController.dispose();
    eventnameController.dispose();
    venueController.dispose();
    super.dispose();
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    List<Appointment> appointmentsToday = [];
    for (Appointment app in calendarAppointmentDetails.appointments) {
      appointmentsToday.add(app);
    }

    return ListView.builder(
        itemCount: appointmentsToday.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.only(left: 10),
              color: COLOR_SCHEME['primary'],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        appointmentsToday[index].subject,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${appointmentsToday[index].startTime.toString().substring(11, 16)} - ${appointmentsToday[index].endTime.toString().substring(11, 16)} ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      onPressed: () {
                        EventData event =
                            allData[appointmentsToday[index].id as int];
                        final TextEditingController hostController2 =
                            TextEditingController(text: event.username);
                        final TextEditingController eventnameController2 =
                            TextEditingController(text: event.title);
                        final TextEditingController venueController2 =
                            TextEditingController(text: event.venue);
                        final TextEditingController descriptionController2 =
                            TextEditingController(text: event.description);
                        final TextEditingController description1Controller2 =
                            TextEditingController(text: event.description1);
                        time = event.from;
                        from = event.from;
                        to = event.to;
                        userModel.userType == 'admin'
                            ? {
                                Get.dialog(AlertDialog(
                                  scrollable: true,
                                  title: Form(
                                      key: _formKey2,
                                      child: FormWidget(
                                        controller: _controller,
                                        eventnameController:
                                            eventnameController2,
                                        hostController: hostController2,
                                        descriptionController:
                                            descriptionController2,
                                        description1Controller:
                                            description1Controller2,
                                        screenHeight:
                                            MediaQuery.of(context).size.height,
                                        screenWidth:
                                            MediaQuery.of(context).size.width,
                                        venueController: venueController2,
                                        event: event,
                                      )),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  actions: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 30,
                                        color: Color.fromARGB(255, 255, 17, 0),
                                      ),
                                      // style: ButtonStyle(
                                      //     backgroundColor: MaterialStatePropertyAll(
                                      //         Color.fromARGB(255, 255, 17, 0))),
                                      onPressed: () async {
                                        await Database().deleteVoid(event.id!);
                                        setState(() {});
                                        Get.back();
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        snackBar(
                                            "Event Deleted Succesfully", "");
                                        NotificationService().sendPushMessage(
                                            "${event.title} got cancelled...",
                                            "open the app for more info");
                                        hostController2.clear();
                                        eventnameController2.clear();
                                        venueController2.clear();
                                      },
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (!_formKey2.currentState!
                                              .validate()) {
                                            return;
                                          } else {
                                            await Database().editData(
                                              event.id!,
                                              eventnameController2.text.trim(),
                                              hostController2.text.trim(),
                                              venueController2.text.trim(),
                                              descriptionController2.text
                                                  .trim(),
                                              description1Controller2.text
                                                  .trim(),
                                              location,
                                              from,
                                              to,
                                            );
                                            setState(() {});
                                            Get.back();
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            snackBar(
                                                "Event saved Succesfully", "");
                                            NotificationService().sendPushMessage(
                                                "There is some change in the event named ${event.title}",
                                                "open the app for more info");
                                            hostController2.clear();
                                            eventnameController2.clear();
                                            venueController2.clear();
                                            descriptionController2.clear();
                                            description1Controller2.clear();
                                            location = "";
                                          }
                                        },
                                        child: Text("Save")),
                                  ],
                                ))
                              }
                            : {
                                Get.bottomSheet(
                                  Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(15),
                                      child: EventInfo(event: event)),
                                ),
                              };
                      },
                      child: Text(
                        userModel.userType == 'admin' ? "Edit" : "More",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FutureBuilder(
        future: Database().getuserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userModel = snapshot.data as UserModel;
            return userModel.userType == 'admin'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.08),
                        child: FloatingActionButton.extended(
                            heroTag: "bt1",
                            elevation: 20,
                            backgroundColor: COLOR_SCHEME['primary'],
                            onPressed: () {
                              // if (_controller.selectedDate == null) {
                              //   Get.snackbar('Please select the date first'.tr,
                              //       'Click on the date to select the date'.tr,
                              //       duration: const Duration(seconds: 3),
                              //       snackPosition: SnackPosition.BOTTOM,
                              //       snackStyle: SnackStyle.FLOATING);
                              // } else {
                              if (_controller.selectedDate == null) {
                                Get.to(
                                  // JapCountPage(),
                                  JapCountPage(date1: DateTime.now()),
                                );
                              } else {
                                Get.to(
                                  // JapCountPage(),
                                  JapCountPage(
                                      date1: _controller.selectedDate!),
                                );
                              }

                              // }
                            },
                            label: Text("Jap Count".tr)),
                      ),
                      FloatingActionButton.extended(
                        heroTag: "bt2",
                        elevation: 20,
                        backgroundColor: COLOR_SCHEME['primary'],
                        label: Text("Add Event".tr),
                        onPressed: () async {
                          if (_controller.selectedDate == null) {
                            Get.snackbar('Please select the date first'.tr,
                                'Click on the date to select the date'.tr,
                                duration: const Duration(seconds: 3),
                                snackPosition: SnackPosition.BOTTOM,
                                snackStyle: SnackStyle.FLOATING);
                          } else {
                            time = _controller.selectedDate!;
                            Get.dialog(AlertDialog(
                              scrollable: true,
                              title: Form(
                                key: _formKey,
                                child: FormWidget(
                                  controller: _controller,
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth,
                                  descriptionController: descriptionController,
                                  description1Controller:
                                      description1Controller,
                                  eventnameController: eventnameController,
                                  hostController: hostController,
                                  venueController: venueController,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      } else {
                                        await Database().addEvent(
                                            title:
                                                eventnameController.text.trim(),
                                            description: descriptionController
                                                .text
                                                .trim(),
                                            description1: description1Controller
                                                .text
                                                .trim(),
                                            time: "time",
                                            date: _controller.selectedDate!,
                                            venue: venueController.text.trim(),
                                            from: from,
                                            to: to,
                                            location: location,
                                            username:
                                                hostController.text.trim(),
                                            createdBy: userModel.fullName);
                                        setState(() {});
                                        Get.back();
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        snackBar("Event Added Succesfully", "");
                                        NotificationService().sendPushMessage(
                                            "New Event Added",
                                            "open the app for more info");

                                        hostController.clear();
                                        eventnameController.clear();
                                        venueController.clear();
                                        descriptionController.clear();
                                        description1Controller.clear();
                                        location = "";
                                      }
                                    },
                                    child: Text("Done"))
                              ],
                            ));
                          }
                        },
                      ),
                    ],
                  )
                : FloatingActionButton.extended(
                    heroTag: 'bt3',
                    elevation: 20,
                    backgroundColor: COLOR_SCHEME['primary'],
                    onPressed: () async {
                      if (_controller.selectedDate == null) {
                        Get.snackbar('Please select the date first'.tr,
                            'Click on the date to select the date'.tr,
                            duration: const Duration(seconds: 3),
                            snackPosition: SnackPosition.BOTTOM,
                            snackStyle: SnackStyle.FLOATING);
                      } else {
                        List<Japcount> data = await Database()
                            .getJapCountByDate(_controller.selectedDate!);
                        Japcount? count;
                        for (Japcount element in data) {
                          if (element.uid == userModel.uid) {
                            count = element;
                          }
                        }
                        TextEditingController japCountContoller =
                            TextEditingController(
                                text: count == null ? "0" : count.japcount);
                        if (japCountContoller.text != '0') {
                          snackBar(
                            "You Previously entered a japcount for this date"
                                .tr,
                            'Do you want to change it?',
                          );
                          // return;
                        }
                        // const Text("data");
                        Get.dialog(
                          AlertDialog(
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            title: FormElement(
                                japCountContoller,
                                "Today's Jap Count",
                                "",
                                screenHeight,
                                screenWidth),
                            actions: [
                              TextButton(
                                child: Text("close"),
                                onPressed: () async {
                                  Get.back();
                                },
                              ),
                              !(_controller.selectedDate!
                                      .isBefore(DateTime.now()))
                                  // && _controller.selectedDate!.month ==
                                  //     DateTime.now().month &&
                                  // _controller.selectedDate!.year ==
                                  //     DateTime.now().year)
                                  ? Container()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (japCountContoller.text == '0') {
                                          snackBar("Please add jap count".tr,
                                              'click on the text box to edit');
                                          return;
                                        } else {
                                          if (count == null) {
                                            await Database().addJupCount(
                                                fullName: userModel.fullName,
                                                japcount: japCountContoller.text
                                                    .trim(),
                                                date: _controller.selectedDate!,
                                                uid: userModel.uid);
                                            Get.back();
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            snackBar("Jap Count Added", "");
                                          } else {
                                            await Database().editJupCount(
                                                count.id!,
                                                japCountContoller.text.trim());
                                            Get.back();
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            snackBar("Jap Count Updated", "");
                                          }
                                        }
                                      },
                                      child: Text("Save")),
                            ],
                          ),
                        );
                        // Text("data1");
                      }
                    },
                    label: Text("Jap Count".tr),
                  );
          } else {
            return Container();
          }
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Calender".tr),
      ),
      body: FutureBuilder(
          future: Database().getEventData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allData = snapshot.data as List<EventData>;
              return SfCalendar(
                controller: _controller,
                backgroundColor: COLOR_SCHEME['faint']!.withOpacity(0.5),
                showNavigationArrow: true,
                cellBorderColor: Colors.black,
                view: CalendarView.month,
                monthViewSettings: MonthViewSettings(
                  showTrailingAndLeadingDates: false,
                  showAgenda: true,
                ),
                dataSource: _getCalendarDataSource(allData),
                appointmentBuilder: appointmentBuilder,
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Server Down!!"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  _AppointmentDataSource _getCalendarDataSource(List<EventData> data) {
    List<Appointment> appointments = <Appointment>[];
    for (EventData event in data) {
      final Appointment app = Appointment(
          id: data.indexOf(event),
          startTime: event.from,
          endTime: event.to,
          subject: event.title,
          color: COLOR_SCHEME['primary']!);
      appointments.add(app);
    }

    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class FormWidget extends StatelessWidget {
  final double screenHeight, screenWidth;
  TextEditingController eventnameController,
      hostController,
      venueController,
      descriptionController,
      description1Controller;
  CalendarController controller = CalendarController();
  final EventData? event;
  FormWidget({
    super.key,
    required this.controller,
    required this.screenHeight,
    required this.screenWidth,
    required this.eventnameController,
    required this.descriptionController,
    required this.description1Controller,
    required this.hostController,
    required this.venueController,
    this.event,
  });
  final Controller1 c1 = Get.put(Controller1());

//   Future<void> _selectLocation(BuildContext context) async {
//   LocationResult? result = await showLocationPicker(
//     context,
//     S.of(context).googleMapsApiKey,
//     initialCenter: LatLng(0, 0),
//     myLocationButtonEnabled: true,
//     layersButtonEnabled: true,
//     desiredAccuracy: LocationAccuracy.best,
//   );

//   if (result != null) {
//     selectedLocation = LatLng(result.latLng.latitude, result.latLng.longitude);
//     // Do something with the selected location
//   }
// }
  @override
  Widget build(BuildContext context) {
    LatLng selectedLocation =
        LatLng(0, 0); // Initialize with default coordinates

    DateTime fromDate =
        event?.from ?? controller.selectedDate!.add(Duration(hours: 0));
    DateTime toDate =
        event?.to ?? controller.selectedDate!.add(Duration(hours: 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            controller.selectedDate.toString().substring(0, 11),
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: COLOR_SCHEME['tertiary']),
          ),
        ),
        SizedBox(height: screenHeight * 0.010),
        FormElement(eventnameController, "Event Name".tr, "".tr,
            screenWidth * 0.5, screenHeight * 0.45),
        SizedBox(height: screenHeight * 0.020),
        Text(
          "From".tr,
          style: TextStyle(
              color: COLOR_SCHEME['tertiary'],
              fontWeight: FontWeight.w400,
              fontSize: 16),
        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(0),
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(color: COLOR_SCHEME['tertiary']!)),
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                      fontSize: 12, color: Colors.black, locale: Get.locale),
                ),
              ),
              child: CupertinoDatePicker(
                initialDateTime: fromDate,
                onDateTimeChanged: (DateTime newdate) {
                  // fromDate = newdate;
                  from = newdate;
                },
                mode: CupertinoDatePickerMode.time,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.020),
        Text(
          "To".tr,
          style: TextStyle(
              color: COLOR_SCHEME['tertiary'],
              fontWeight: FontWeight.w400,
              fontSize: 16),
        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(0),
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(color: COLOR_SCHEME['tertiary']!)),
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                      fontSize: 12, color: Colors.black, locale: Get.locale),
                ),
              ),
              child: CupertinoDatePicker(
                initialDateTime: toDate,
                onDateTimeChanged: (DateTime newdate) {
                  // toDate = newdate;
                  to = newdate;
                },
                mode: CupertinoDatePickerMode.time,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.020),
        FormElement(
          descriptionController,
          "Description".tr,
          "",
          screenHeight,
          screenWidth,
        ),
        SizedBox(height: screenHeight * 0.020),
        TextButton(
          child: const Text(
            "Click here to select Host",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          onPressed: () async {
            final TextEditingController search = TextEditingController();
            List<UserModel> userList = await Database().searchUser();

            Get.bottomSheet(Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Container(
                    child: TextField(
                      onChanged: (value) {
                        c1.searchUser(value, userList);
                      },
                      controller: search,
                      decoration: InputDecoration(
                        hintText: "write name here....",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(
                          Icons.person_add_alt_1_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: COLOR_SCHEME['faint']!.withOpacity(0.3),
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Obx(() {
                    return ListView.builder(
                        itemCount: c1.list.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              margin: EdgeInsets.only(top: 10),
                              color: COLOR_SCHEME['faint'],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(c1.list[index].fullName),
                                  TextButton(
                                    onPressed: () {
                                      hostController.text =
                                          c1.list[index].fullName;
                                      venueController.text =
                                          c1.list[index].address;
                                      CalenderState.location =
                                          c1.list[index].location;
                                      Get.back();
                                    },
                                    child: Text("select"),
                                  )
                                ],
                              ));
                        });
                  })),
                ])));
          },
        ),
        FormElement(
          hostController,
          "Event Host".tr,
          "".tr,
          screenHeight,
          screenWidth,
        ),
        SizedBox(height: screenHeight * 0.020),
        FormElement(
          venueController,
          "Venue".tr,
          "Event Venue".tr,
          screenWidth,
          screenHeight,
        ),
        SizedBox(height: screenHeight * 0.020),
        FormElement(
          description1Controller,
          "More Information\n(pls provide link to document\n or write NA)".tr,
          "",
          screenHeight,
          screenWidth,
        ),
        SizedBox(height: screenHeight * 0.020),
      ],
    );
  }
}

class Controller1 extends GetxController {
  RxList<UserModel> list = <UserModel>[].obs;
  searchUser(String username, List<UserModel> userList) {
    list.clear();
    for (UserModel user in userList) {
      if (user.fullName.contains(username)) {
        list.add(user);
        print(list);
      }
    }
  }
}
