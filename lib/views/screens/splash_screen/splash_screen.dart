import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testungapp/services/route_helper.dart';
import 'package:testungapp/views/screens/Category_Screens/category_screen.dart';

import '../../../controllers/auth_controller.dart';
import '../../../services/constants.dart';
import '../../base/custom_image.dart';
import '../auth_screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      Future.delayed(const Duration(seconds: 2), () {});
      Navigator.pushReplacement(
        context,
        getCustomRoute(child: CategoryPage())
        // getMaterialRoute(
        //   child: const Dashboard(),
        // ),
      );

      // if (Get.find<AuthController>().isLoggedIn()) {
      //   Get.find<AuthController>().getUserProfileData().then((value) {
      //     Future.delayed(const Duration(seconds: 2), () {
      //       if (Get.find<AuthController>().checkUserData()) {
      //         // Navigator.pushReplacement(
      //         //   context,
      //         //   getMaterialRoute(
      //         //     child: const Dashboard(),
      //         //   ),
      //         // );
      //       } else {
      //         // Navigator.pushReplacement(
      //         //   context,
      //         //   getMaterialRoute(
      //         //     child: const SignupScreen(),
      //         //   ),
      //         // );
      //       }
      //     });
      //   });
      // } else {
      //   // Navigator.pushReplacement(
      //   //   context,
      //   //   getMaterialRoute(
      //   //     child: const LoginScreen(),
      //   //   ),
      //   // );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            CustomImage(
              path: Assets.imagesLogo,
              height: size.height * .3,
              width: size.height * .3,
            ),
            const Spacer(flex: 3),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 26.0,
                  ),
            ),
            Text(
              "Subtitle",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
