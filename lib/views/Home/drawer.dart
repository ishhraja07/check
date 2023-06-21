import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Brahmachaitanya/constant/constants.dart';
import 'package:Brahmachaitanya/main.dart';
import 'package:Brahmachaitanya/views/Calendar/progressScreen.dart';
import 'package:Brahmachaitanya/views/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import '../../../services/location.dart';
import '../../database/firebase.dart';
import '../../middleware/authentication.dart';
import '../../models/user.dart';
import '../Calendar/setTarget.dart';
import '../Calendar/userProgress.dart';

class MainDrawer extends StatelessWidget {
  UserModel user;
  MainDrawer({required this.user});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    // spreadRadius: 6.0,
                    offset: const Offset(
                      0,
                      8,
                    )),
              ],
              color: COLOR_SCHEME['primary']!.withOpacity(0.5),
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 100, left: 10),
                      child: Text(
                        "${user.userType} Info".tr,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            )),
        ListTile(
          onTap: () {
            if (user.userType != 'admin') {
              TextEditingController username =
                  TextEditingController(text: user.fullName);
              Get.dialog(AlertDialog(
                scrollable: true,
                title: FormElement(
                    username,
                    "Edit username".tr,
                    "",
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Close")),
                  ElevatedButton(
                      onPressed: () async {
                        await Database()
                            .changeUsername(user.uid, username.text.trim());
                        Get.back();
                        Get.back();
                        snackBar("UserName Updated", "");
                      },
                      child: const Text("Save")),
                ],
              ));
            }
          },
          leading: const Icon(
            Icons.person,
            color: Colors.black,
          ),
          trailing: user.userType != 'admin'
              ? const Icon(
                  Icons.edit,
                  size: 20,
                )
              : const Icon(Icons.abc, color: Colors.transparent, size: 1),
          title: Text(user.fullName),
        ),
        ListTile(
          onTap: () {
            if (user.userType != 'admin') {
              TextEditingController address =
                  TextEditingController(text: user.address);
              Get.dialog(AlertDialog(
                scrollable: true,
                title: FormElement(
                    address,
                    "Edit address".tr,
                    "",
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Close")),
                  ElevatedButton(
                      onPressed: () async {
                        await Database()
                            .changeAddress(user.uid, address.text.trim());
                        Get.back();
                        Get.back();
                        snackBar("Address Updated", "");
                      },
                      child: const Text("Save")),
                ],
              ));
            }
          },
          leading: const Icon(
            Icons.location_on,
            color: Colors.black,
          ),
          title: Text(user.address),
          trailing: user.userType != 'admin'
              ? const Icon(
                  Icons.edit,
                  size: 20,
                )
              : const Icon(Icons.abc, color: Colors.transparent, size: 1),
        ),
        if (user.userType != 'admin')
          ListTile(
            onTap: () async {
              LocationData? loc = await getUserLocation();
              print("loc $loc");
              if (loc == null) {
                snackBar("Location Access Denied",
                    "please enable location it from app settings");
              } else {
                try {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    loc.latitude!,
                    loc.longitude!,
                  );
                  Placemark place = placemarks[0];
                  String location = loc.latitude!.toString() +
                      "," +
                      loc.longitude!.toString();
                  await Database().changeLocation(user.uid, location);
                  Get.back();
                  snackBar("Live Location Updated", "");
                } catch (e) {
                  snackBar(
                      "Unable to Update location", "Try Again After some Time");
                }
              }
            },
            leading: const Icon(
              Icons.update,
              color: Colors.black,
            ),
            title: Text('Update live location'.tr),
            trailing: const Icon(
              Icons.edit,
              size: 20,
            ),
          ),
        ListTile(
          onTap: () async {
            var location = user.location.split(',');

            var uri = Uri.parse("google.maps:q=${location[0]},${location[1]}");
            if (!await launchUrl(uri)) {
              snackBar(
                  "Something Went Wrong", "Try Again Later After Sometime");
            }
          },
          leading: const Icon(
            Icons.navigation,
            color: Colors.black,
          ),
          title: Text('open location in map'.tr),
        ),
        ListTile(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            final String? local = prefs.getString('language');
            Get.locale == const Locale('en')
                ? {
                    await prefs.setString('language', 'mr'),
                    Get.updateLocale(const Locale('mr'))
                  }
                : {
                    await prefs.setString('language', 'en'),
                    Get.updateLocale(const Locale('en'))
                  };
          },
          leading: const Icon(
            Icons.language,
            color: Colors.black,
          ),
          title: Get.locale == const Locale('en')
              ? const Text("Change language to Marathi")
              : const Text("इंग्रजी भाषा निवडा"),
        ),
        if (user.userType == 'admin')
          ListTile(
            onTap: () async {
              Get.to(const ProgressScreen());
            },
            leading: const Icon(
              Icons.bar_chart,
              color: Colors.black,
            ),
            title: Get.locale == const Locale('en')
                ? const Text("Community Goal Summary")
                : const Text("Community Goal Summary"),
          ),
        if (user.userType == 'admin')
          ListTile(
            onTap: () async {
              Get.to(const TargetSetScreen());
            },
            leading: const Icon(
              Icons.change_circle,
              color: Colors.black,
            ),
            title: Get.locale == const Locale('en')
                ? const Text("Target Settings")
                : const Text("Target Setting"),
          ),
        if (user.userType != 'admin')
          ListTile(
            onTap: () async {
              Get.to(const userProgressScreen());
            },
            leading: const Icon(
              Icons.bar_chart,
              color: Colors.black,
            ),
            title: Get.locale == const Locale('en')
                ? const Text("Community Goal Summary")
                : const Text("Community Goal Summary"),
          ),
        ListTile(
          onTap: () async {
            await FireAuth().logOut();
            Get.offAll(const MyHomePage());
          },
          leading: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
          title: Text("LogOut".tr),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 150, right: 20),
          child: Text(
            "AAARUYA GLOBAL CONSULTING LLP",
            style: TextStyle(
                fontSize: 16,
                color: Colors.red[900],
                fontWeight: FontWeight.w600),
          ),
        ),
        const Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 5, right: 20),
          child: Row(
            children: [
              Icon(
                Icons.phone,
                color: Colors.black,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "+91 8975126448",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 5, right: 20),
          child: Row(children: [
            Icon(
              Icons.email_outlined,
              color: Colors.black,
              size: 15,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "gondavalekarapp23@gmail.com",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        )
      ],
    );
  }
}
