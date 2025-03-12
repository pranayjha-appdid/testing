import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testungapp/views/screens/Category_Screens/category_screen.dart';

import '../../../controllers/firebase_controller.dart';
import '../../../services/input_decoration.dart';
import '../../base/custom_image.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: CustomImage(
                      path: Assets.imagesOtpScreenImage, height: 200)),
              Text(
                "Please enter the OTP below to verify your number.",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: Get.find<FirebaseController>().otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                decoration: CustomDecoration.inputDecoration(
                  borderRadius: 50,
                  label: 'OTP code',
                  hint: 'Enter your OTP code',
                  floating: true,
                  icon: Icon(IconlyBroken.chat),
                ),
              ),
              SizedBox(height: 20),
              GetBuilder<FirebaseController>(builder: (firebaseController) {
                return GestureDetector(
                  onTap: () async {
                    if (firebaseController.otpController.text.length == 6) {
                      await firebaseController.verifyOtp();
                      if (firebaseController.userCredential != null) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (c) {
                          return  CategoryPage();
                        }));
                        // Get.off(CategoryScreen()); // Navigate to CategoryScreen if login is successful
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please enter a valid 6-digit OTP.");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFA9884),
                          Color(0xFFFA9884),
                          Color(0xFFE74646)
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        firebaseController.isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                "Verify OTP",
                                style: TextStyle(color: Colors.white),
                              ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Didn't receive code? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Request again",
                          style: TextStyle(
                              color: Color(0xFFFA9884),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Call your resend OTP function here (optional)
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
