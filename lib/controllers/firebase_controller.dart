import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../data/models/response/response_model.dart';
import '../services/constants.dart';

class FirebaseController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _phoneCode = '+91';
  String _verificationId = '';
  int? _resendToken;
  bool _isLoading = false;
  int _otpTimer = 30;
  Timer? _otpTimerInstance;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  void changePhoneCode(String code) {
    _phoneCode = code;
    update();
  }

  void _startOtpTimer() {
    if (_otpTimerInstance != null && _otpTimerInstance!.isActive) {
      _otpTimerInstance!.cancel();
    }
    _otpTimer = 30;
    update();

    _otpTimerInstance = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpTimer == 0) {
        _otpTimerInstance!.cancel();
      } else {
        _otpTimer--;
        update();
      }
    });
  }

  Future<void> sendOtp() async {
    final phoneNumber = "$_phoneCode${phoneController.text.trim()}";
    log("Phone number to send OTP: $phoneNumber");
    isLoading = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          isLoading = false; // Update with RxBool
        },
        verificationFailed: (e) {
          isLoading = false; // Update with RxBool
          log("Verification Failed: ${e.message}");
          Get.snackbar("Error", e.message ?? "Verification Failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          _startOtpTimer();
          _verificationId = verificationId;
          _resendToken = resendToken;
          log("Verification ID: $_verificationId");
          Fluttertoast.showToast(msg: "OTP sent to ${phoneController.text.trim()}");
          isLoading = false; // Update with RxBool
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          isLoading = false; // Update with RxBool
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      isLoading = false; // Update with RxBool
      log("Error in sending OTP: $e");
      Get.snackbar("Error", e.toString());
    }
  }
  Future<void> verifyOtp() async {
    try {
      final otpCode = otpController.text.trim();
      if (otpCode.isEmpty || otpCode.length != 6) {
        Fluttertoast.showToast(msg: "Please enter a valid OTP.");
        return;
      }

      if (_verificationId.isEmpty) {
        log("Verification ID is invalid.");
        Fluttertoast.showToast(msg: "Verification ID is invalid.");
        return;
      }

      print("Verification ID used for OTP: $_verificationId");

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpCode,
      );

      await _signInWithCredential(credential);
    } catch (e) {
      isLoading = false;
      Fluttertoast.showToast(msg: "Invalid OTP. Please try again.");
    }
  }

  UserCredential? userCredential;
  Future<void> _signInWithCredential(AuthCredential credential) async {
    try {
       userCredential = await _auth.signInWithCredential(credential);
      if (userCredential?.user != null) {
        // Get.off(CategoryScreen()); // Navigate to CategoryScreen if login is successful
      } else {
        Fluttertoast.showToast(msg: "Signing failed. Please try again.");
      }
    } catch (e) {
      log("Error signing in: $e");
      Fluttertoast.showToast(msg: "Error signing in: $e");
    }
  }
}
