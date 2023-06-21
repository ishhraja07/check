import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:Brahmachaitanya/database/firebase.dart';
import 'package:Brahmachaitanya/middleware/authentication.dart';
import 'package:Brahmachaitanya/models/user.dart';
import 'package:Brahmachaitanya/views/common_widgets.dart';
import 'package:get/get.dart';

import 'package:location/location.dart';
import '../../../services/location.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  //firenase auth

  final auth = FirebaseAuth.instance;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget SignUpButton() {
      return Container(
        height: 50,
        width: screenWidth,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            } else {
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
                  UserModel userModel;
                  await auth
                      .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text.trim())
                      .then((userCredential) {
                    Database().addUser(
                        fullName: fullNameController.text.trim(),
                        email: emailController.text,
                        address: addressController.text.trim(),
                        location: location,
                        userType: 'user',
                        uid: userCredential.user!.uid);
                    Get.offAllNamed('/home');
                    snackBar("Welcome!", 'SignUp Sucessful...');
                  }).catchError((e) {
                    snackBar('Something Went Wrong', e);
                  });
                } catch (e) {
                  snackBar('Something Went Wrong', e.toString());
                }
              }
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))))),
          child: Text("New Account".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              )),
        ),
      );
    }

    Widget googleButton() {
      return Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff1959a9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: const Text('G',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff2872ba),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () async {
                    LocationData? loc = await getUserLocation();
                    print("loc $loc");
                    if (loc == null) {
                      snackBar("Location Access Denied",
                          "please enable location it from app settings");
                    } else {
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        loc.latitude!,
                        loc.longitude!,
                      );
                      Placemark place = placemarks[0];
                      String location = loc.latitude!.toString() +
                          "," +
                          loc.longitude!.toString();

                      print(
                          ' ${place.name}\n, ${place.street}\n,${place.locality}\n, ${place.subLocality}\n,${place.administrativeArea}\n, ${place.subAdministrativeArea}\n,${place.thoroughfare}\n, ${place.subThoroughfare}');
                      String address =
                          '${place.name},${place.street},${place.subLocality},${place.locality},${place.subAdministrativeArea},${place.administrativeArea},${place.subThoroughfare}, ${place.thoroughfare}';

                      try {
                        UserModel userModel;
                        await signInWithGoogle().then((userCredential) {
                          Database().addUser(
                              fullName: userCredential.user!.displayName ??
                                  "not found",
                              email: userCredential.user!.email!,
                              address: address,
                              location: location,
                              userType: 'user',
                              uid: userCredential.user!.uid);
                          Get.offAllNamed('/home');
                          snackBar("Welcome!", 'SignUp Sucessful...');
                        }).catchError((e) {
                          snackBar('Something Went Wrong', e);
                        });
                      } catch (e) {
                        snackBar('Something Went Wrong', e.toString());
                      }
                    }
                  },
                  child: Text('Signup With Google'.tr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.066),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.024),
                  FormElement(fullNameController, "Full Name".tr,
                      "Enter Your Full Name".tr, screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.024),
                  FormElement(addressController, "Address".tr,
                      "Enter Your Address".tr, screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.024),
                  FormElement(emailController, "Email Id".tr, "abc@gmail.com",
                      screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.024),
                  FormElement(
                      passwordController,
                      "Password".tr,
                      "must be at least 6 characters".tr,
                      screenHeight,
                      screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  Center(
                    child: SignUpButton(),
                  ),
                  divider(),
                  googleButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
