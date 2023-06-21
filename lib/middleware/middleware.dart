import 'package:get/get.dart';
import '../views/Auth/Login/login_signup.dart';
import '../views/Home/home_page.dart';

appRoutes() => [
      GetPage(
        name: '/home',
        page: () => HomePage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/login_signup',
        page: () => Login_SignUp(),
        // middlewares: [MyMiddelware()],
        transition: Transition.rightToLeftWithFade,
        transitionDuration: Duration(milliseconds: 500),
      ),
    ];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    print(page?.name);
    return super.onPageCalled(page);
  }
}
