import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Brahmachaitanya/constant/constants.dart';
import 'package:Brahmachaitanya/views/Auth/Login/signUp.dart';
import 'package:Brahmachaitanya/views/Auth/Login/login.dart';

class Login_SignUp extends StatefulWidget {
  const Login_SignUp({super.key});

  @override
  State<Login_SignUp> createState() => _Login_SignUpState();
}

class _Login_SignUpState extends State<Login_SignUp>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("ब्रह्मचैतन्य गोंदवलेकर महाराज मठ"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: COLOR_SCHEME['primary'],
            child: TabBar(
                indicatorColor: COLOR_SCHEME['tertiary'],
                indicatorWeight: 3,
                controller: tabController,
                tabs: [
                  Tab(
                    child: Text(
                      "Login".tr,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Tab(
                    child: Text("New Account".tr,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20)),
                  )
                ]),
          ),
          Expanded(
            child: TabBarView(
                controller: tabController, children: const [Login(), SignUp()]),
          )
        ],
      ),
    );
  }
}
