import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testungapp/controllers/firebase_controller.dart';
import 'package:testungapp/views/base/common_button.dart';
import 'package:testungapp/views/base/custom_textfield.dart';

import '../../../controllers/auth_controller.dart';
import '../../../services/input_decoration.dart';
import 'opt_verification_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: Get.find<FirebaseController>().phoneController,
                keyboardType: TextInputType.phone,
                decoration: CustomDecoration.inputDecoration(
                  floating: true,
                  label: 'Mobile Number',
                  icon: Icon(
                    Icons.phone_in_talk_outlined,
                    size: 19,
                    color: Color(0xFF130F26),
                  ),
                  hint: 'Enter your mobile number',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  final firebaseController = Get.find<FirebaseController>();
                  if (firebaseController.phoneController.text.length == 10) {
                    firebaseController.sendOtp().then(
                      (value) {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return const OTPVerificationScreen();
                        }));
                      },
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please enter a valid 10-digit number");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(44),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFA9884),
                        Color(0xFFFA9884),
                        Color(0xFFE74646),
                      ],
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
