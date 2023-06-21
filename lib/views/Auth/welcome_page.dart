import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Brahmachaitanya/services/location.dart';
import 'package:Brahmachaitanya/views/Auth/Login/login_signup.dart';
import 'package:Brahmachaitanya/views/common_widgets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background1.jpg"),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.066),
              height: 50,
              width: screenWidth,
              margin: EdgeInsets.only(bottom: screenHeight * 0.08),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  Get.to(() => const Login_SignUp());
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                child: Text(
                  "Get Started".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              // alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  Get.locale == const Locale('en')
                      ? "Change language to Marathi"
                      : "इंग्रजी भाषा निवडा",
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () async {
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
              ),
            ),
          ],
        ),
      ],
    );
  }
}
