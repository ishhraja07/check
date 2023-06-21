import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Brahmachaitanya/database/firebase.dart';
import 'package:Brahmachaitanya/views/common_widgets.dart';
import 'package:get/get.dart';
import '../../../middleware/authentication.dart';
import '../../../models/user.dart';
import '../../Calendar/calendar.dart';
import '../../Home/home_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  //firebase auth
  final auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    UserModel userModel;

    Widget LoginButton() {
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
              List<String> adminInfo = await Database().checkAdminEmail(
                  emailController.text, passwordController.text.trim());
              if (adminInfo.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                prefs.setStringList('admin', adminInfo);
                Get.offAllNamed('/home');
                snackBar("Welcome Back!", 'Admin Login Sucessful...');
              } else {
                try {
                  await auth
                      .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text.trim())
                      .then((value) async => {
                            Get.offAllNamed('/home'),
                            snackBar("Welcome Back!", 'Login Sucessful...')
                          });
                } catch (e) {
                  snackBar('Something Went Wrong', e.toString());
                  FireAuth().logOut();
                }
              }
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))))),
          child: Text("Login".tr,
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
                    try {
                      await signInWithGoogle().then((value) async => {
                            Get.offAllNamed('/home'),
                            snackBar("Welcome Back!", 'Login Sucessful...')
                          });
                    } catch (e) {
                      snackBar('Something Went Wrong', e.toString());
                      FireAuth().logOut();
                    }
                  },
                  child: Text('Login With Google'.tr,
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
                  FormElement(emailController, "Email Id".tr, "abc@gmail.com",
                      screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.024),
                  FormElement(passwordController, "Password".tr,
                      "Enter Your Password".tr, screenHeight, screenWidth),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: LoginButton(),
                  ),
                  divider(),
                  googleButton(),
                  // divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//  Widget AdminButton() {
    //   return Container(
    //     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.066),
    //     height: 50,
    //     width: screenWidth,
    //     margin: const EdgeInsets.symmetric(vertical: 20),
    //     decoration: const BoxDecoration(
    //       borderRadius: BorderRadius.all(Radius.circular(10)),
    //     ),
    //     child: ElevatedButton(
    //       onPressed: () async {
    //         String adminCode = await Database().getCode();
    //         await Get.bottomSheet(
    //           Container(
    //             color: Colors.white,
    //             padding: EdgeInsets.only(
    //                 top: screenWidth * 0.05,
    //                 left: screenWidth * 0.05,
    //                 right: screenWidth * 0.05),
    //             height: 200,
    //             child: Column(
    //               children: [
    //                 FormElement(codeController, "Admin Code".tr,
    //                     "Admin Code required".tr, screenHeight, screenWidth),
    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //                 ElevatedButton(
    //                     onPressed: () {
    //                       if (codeController.text.trim() != adminCode) {
    //                         print(codeController.text.trim().toString() ==
    //                             adminCode.toString());
    //                         Get.snackbar('Wrong Admin Code'.tr,
    //                             'Try Again or login as user'.tr,
    //                             duration: const Duration(seconds: 3),
    //                             snackPosition: SnackPosition.BOTTOM,
    //                             snackStyle: SnackStyle.FLOATING);
    //                       } else {
    //                         Get.offNamed('/login_signup', arguments: "admin");
    //                         // Get.to(const Calender());
    //                       }
    //                     },
    //                     child: Text("Next".tr))
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //       style: ButtonStyle(
    //           shape: MaterialStateProperty.all(const RoundedRectangleBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(10))))),
    //       child: Text("Admin Login".tr,
    //           textAlign: TextAlign.center,
    //           style: const TextStyle(
    //             fontSize: 20,
    //             color: Colors.black,
    //           )),
    //     ),
    //   );
    // }
