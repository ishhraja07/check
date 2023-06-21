// ignore_for_file: deprecated_member_use
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/constants.dart';
import '../database/firebase.dart';
import '../middleware/authentication.dart';
import '../models/event.dart';
import '../models/user.dart';

//----------------------------------------

///form field for email validation
Widget FormElement(TextEditingController controller, String title,
    String hintText, double screenHeight, double screenWidth) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            color: COLOR_SCHEME['tertiary'],
            fontWeight: FontWeight.w400,
            fontSize: 16),
      ),
      const SizedBox(height: 10),
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(color: COLOR_SCHEME['tertiary']),
        autofocus: false,
        onSaved: (value) {
          controller.text = value!;
        },
        validator: (value) {
          if (GetUtils.isBlank(value)!) return "Enter Valid Info".tr;
          if (title == 'Email Id'.tr) return emailValidtor(value);
          if (title == 'Password'.tr) {
            if (value!.length < 6) return "min 6 characters".tr;
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(color: COLOR_SCHEME['tertiary']!.withOpacity(0.5)),
          contentPadding: EdgeInsets.all(screenWidth * 0.02),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: COLOR_SCHEME['tertiary']!, width: 1)),
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: COLOR_SCHEME['tertiary']!, width: 1)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_SCHEME['tertiary']!, width: 2),
          ),
        ),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
    ],
  );
}

String? emailValidtor(String? value) {
  if (value!.isEmpty) {
    return "Enter Your Email".tr;
  }
  //reg ex for email validation
  if (!GetUtils.isEmail(value)) {
    return "Invalid Email".tr;
  }
  return null;
}

//----------------------------------------
Widget divider() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: <Widget>[
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              thickness: 1,
            ),
          ),
        ),
        Text('OR'.tr),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              thickness: 1,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    ),
  );
}

SnackbarController snackBar(String title, String subtitle) {
  return Get.snackbar(title.tr, subtitle.tr,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING);
}

class EventInfo extends StatelessWidget {
  final EventData event;
  EventInfo({super.key, required this.event});

  void _handleUrlLaunch(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // final DateTime from1 = event.from;
  // String formattedTime = DateFormat('HH:mm').format(event.from);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            event.title,
            style: TextStyle(
                color: COLOR_SCHEME['tertiary'],
                fontSize: 25,
                fontWeight: FontWeight.w500),
          ),
          Divider(
            color: COLOR_SCHEME['primary'],
          ),
          Row(
            children: [
              Icon(
                Icons.date_range_sharp,
                size: 22,
                color: Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Date".tr + ":-",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                event.date.toString().substring(0, 11),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 22,
                color: Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Time".tr + ":-",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                // "${event.from.toString().substring(12,17 )}:${event.from.minute} - ${event.to.hour}:${event.to.minute}",
                "${event.from.toString().substring(11, 16)} - ${event.to.toString().substring(11, 16)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 22,
                color: Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Venue".tr + ":-",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  event.venue,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                size: 22,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (event.location == '') {
                      snackBar("Location link not provided yet",
                          "It will be available soon");
                    } else {
                      var location = event.location!.split(',');

                      var uri = Uri.parse(
                          "google.navigation:q=${location[0]},${location[1]}");
                      if (!await launchUrl(uri)) {
                        snackBar("Something Went Wrong",
                            "Try Again Later After Sometime");
                      }
                    }
                  },
                  child:const Text(
                    'Google Maps Link',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.person_2_outlined,
                size: 22,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Host".tr + ":-",
                style:const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  event.username,
                  style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.description,
                size: 22,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Description".tr + ":-",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  event.description,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.download,
                size: 22,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  // String pdfUrl ="https://drive.google.com/file/d/1jw1FAa-nyqK2knhijDnKpirEf-gojc-V/view?usp=share_link";
                  String check = event.description1;
                  String pdfUrl;
                  if (check == "NA") {
                    pdfUrl = "";
                  } else {
                    pdfUrl = event.description1.toString();
                  }
                  _handleUrlLaunch(pdfUrl);
                },
                child:const Text(
                  'For More Informations',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),

            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
