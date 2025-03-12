import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/models/contact_number.dart';
import '../data/models/response/response_model.dart';
import '../data/models/response/user_model.dart';
import '../data/repositories/auth_repo.dart';
import '../main.dart';
import '../services/constants.dart';
import '../services/extensions.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool _acceptTerms = true;

  late final number = ContactNumber(number: '', countryCode: '+91');
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  bool get isLoading => _isLoading;

  bool get acceptTerms => _acceptTerms;

  TextEditingController pNumber = TextEditingController();
  TextEditingController otp = TextEditingController();


  Future<ResponseModel> login(String? phone, {String? otp}) async {
    ResponseModel responseModel;
    log("response.body.toString()${AppConstants.baseUrl}${AppConstants.loginUri}", name: "login");
    try {
      Response response = await authRepo.login(await authRepo.getDeviceId(), phone: phone, otp: otp);
      /*if(response.body.containsKey('errors')){
        return ResponseModel(false, response.statusText!,response.body['errors']);
      }*/
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        log(response.body.toString());

        if (response.body.containsKey('errors')) {
          _isLoading = false;
          update();
          return ResponseModel(false, response.statusText!, response.body['errors']);
        }
        if (response.body.containsKey('token')) {
          authRepo.saveUserToken(response.body['token'].toString());
        }
        responseModel = ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT login()");
    }
    _isLoading = false;
    // update();
    return responseModel;
  }

  //
  // Future<ResponseModel> sendOtp({required String phone}) async {
  //   ResponseModel responseModel;
  //   log("response.body.toString()${AppConstants.baseUrl}${AppConstants.sendOtp}", name: "sendOtp");
  //   try {
  //     Response response = await authRepo.sendOtp(phone: phone);
  //     log(response.statusCode.toString());
  //     log(response.body.toString());
  //     if (response.statusCode == 200) {
  //       log(response.body.toString());
  //       if (response.body.containsKey('errors')) {
  //         _isLoading = false;
  //         update();
  //         return ResponseModel(false, response.statusText!, response.body['errors']);
  //       }
  //
  //       responseModel = ResponseModel(true, '${response.body['message']}', response.body);
  //     } else {
  //       responseModel = ResponseModel(false, response.statusText!);
  //     }
  //   } catch (e) {
  //     responseModel = ResponseModel(false, "CATCH");
  //     log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT sendOtp()");
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }
  //
  // Future<ResponseModel> verifyOtp({required String phone, required String otp}) async {
  //   ResponseModel responseModel;
  //   log("response.body.toString()${AppConstants.baseUrl}${AppConstants.verifyOtp}", name: "verifyOtp");
  //   try {
  //     //----id token
  //     Get.find<AuthController>().authRepo.apiClient.addDataToHeader({
  //       // 'type': (Get.find<AuthController>().authRepo.getType() == "sale_person") ? Get.find<AuthController>().authRepo.getType() : "vendor",
  //       "type": "vendor",
  //     });
  //     Response response = await authRepo.verifyOtp(phone: phone, otp: otp);
  //     log(response.statusCode.toString());
  //     log(response.body.toString());
  //     if (response.statusCode == 200) {
  //       log(response.body.toString());
  //       log(jsonEncode(response.body.toString()), name: "Json Data");
  //       if (response.body.containsKey('token')) {
  //         await authRepo.saveUserToken(response.body['token'].toString());
  //       }
  //       if (response.body.containsKey('message')) {
  //         await authRepo.saveType(response.body['message'].toString());
  //         Get.find<AuthController>().authRepo.apiClient.addDataToHeader({
  //           // 'type': (Get.find<AuthController>().authRepo.getType() == "sale_person") ? Get.find<AuthController>().authRepo.getType() : "vendor",
  //           "type": "vendor",
  //         });
  //       }
  //       if (response.body.containsKey('errors')) {
  //         _isLoading = false;
  //         update();
  //         return ResponseModel(false, response.statusText!, response.body['errors']);
  //       }
  //
  //       if (response.body["otp_verified"] == false) {
  //         _isLoading = false;
  //         update();
  //         return ResponseModel(false, response.body["message"], response.body);
  //       }
  //       if (response.body.containsKey('token')) {
  //         authRepo.saveUserToken(response.body['token'].toString());
  //       }
  //       // if (response.body["type"] == "old") {
  //       //   _isLoading = false;
  //       //   update();
  //       //
  //       //   Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, getCustomRoute(child: HomePage()), (route) => false); //old user
  //       // } else {
  //       //   _isLoading = false;
  //       //   update();
  //       //   Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, getCustomRoute(child: const SignUpScreen()), (route) => false); //new user
  //       // }
  //
  //       responseModel = ResponseModel(true, '${response.body['message']}', response.body);
  //     } else {
  //       responseModel = ResponseModel(false, response.statusText!);
  //     }
  //   } catch (e) {
  //     responseModel = ResponseModel(false, "CATCH");
  //     log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT verifyOtp()");
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }
  //
  // Future<ResponseModel> login(String? idToken) async {
  //   ResponseModel responseModel;
  //   log("response.body.toString()${AppConstants.baseUrl}${AppConstants.loginUri}", name: "login");
  //   try {
  //     //----id token
  //     Get.find<AuthController>().authRepo.apiClient.addDataToHeader({
  //       'type': (Get.find<AuthController>().authRepo.getType() == "sale_person") ? Get.find<AuthController>().authRepo.getType() : "vendor",
  //     });
  //     Response response = await authRepo.loginVendor(idToken!);
  //     log(response.statusCode.toString());
  //     log(response.bodyString.toString(), name: 'BODY');
  //     if (response.statusCode == 200) {
  //       log(jsonEncode(response.body.toString()), name: "Json Data");
  //       if (response.body.containsKey('token')) {
  //         await authRepo.saveUserToken(response.body['token'].toString());
  //       }
  //       if (response.body.containsKey('message')) {
  //         await authRepo.saveType(response.body['message'].toString());
  //         Get.find<AuthController>().authRepo.apiClient.addDataToHeader({
  //           'type': (Get.find<AuthController>().authRepo.getType() == "sale_person") ? Get.find<AuthController>().authRepo.getType() : "vendor",
  //         });
  //       }
  //       if (response.body.containsKey('errors')) {
  //         _isLoading = false;
  //         update();
  //         return ResponseModel(false, response.statusText!, response.body['errors']);
  //       }
  //       if (response.body.containsKey('token')) {
  //         authRepo.saveUserToken(response.body['token'].toString());
  //       }
  //       if (response.body.containsKey('message')) {
  //         await authRepo.saveType(response.body['message'].toString());
  //       }
  //       responseModel = ResponseModel(true, '${response.body['msg']}', response.body);
  //     } else {
  //       responseModel = ResponseModel(false, response.statusText!);
  //     }
  //   } catch (e) {
  //     responseModel = ResponseModel(false, "CATCH");
  //     log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT login()");
  //   }
  //   _isLoading = false;
  //   // update();
  //   return responseModel;
  // }
  //
  // Future<ResponseModel> getUserProfileData() async {
  //   log("getUserProfileData");
  //   ResponseModel responseModel;
  //   _isLoading = true;
  //   try {
  //     Map<String, dynamic> data = {};
  //     if (authRepo.getType().isNotEmpty) {
  //       data.addAll({"type": authRepo.getType()});
  //     }
  //     Response response = await authRepo.getUser(data);
  //     // log(response.bodyString ?? "NULL", name: "UserModel");
  //     // log(response.statusCode.toString(), name: "statusCode");
  //     if (response.statusCode == 200) {
  //       log(response.bodyString!, name: "UserModel");
  //       // log(response.statusCode.toString(), name: "statusCode");
  //       _userModel = userModelFromJson(jsonEncode(response.body['data']));
  //
  //       authRepo.saveUserId('${_userModel!.id}');
  //       authRepo.saveApprovalStatus('${_userModel!.approvalStatus}');
  //       log('${authRepo.getApprovalStatus()}', name: '--');
  //       update();
  //       responseModel = ResponseModel(true, 'success');
  //     } else {
  //       ApiChecker.checkApi(response);
  //       responseModel = ResponseModel(false, "${response.statusText}");
  //     }
  //   } catch (e) {
  //     log('---- ${e.toString()} ----', name: "ERROR AT getUserProfileData()");
  //     responseModel = ResponseModel(false, "$e");
  //   }
  //
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  // String getType() {
  //   return authRepo.getType();
  // }

  void setUserToken(String id) {
    authRepo.saveUserToken(id);
  }

  // bool checkUserData() {
  //   log(_userModel!.name.toString());
  //   log(_userModel!.email.toString());
  //   log(_userModel!.contactNo.toString());
  //   try {
  //     if (_userModel!.name.isValid && _userModel!.email.isValid && _userModel!.contactNo.isValid) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

//====================log out user==================
//   Future<void> logOutUser() async {
//     try {
//       Response response = await authRepo.logoutUser();
//       if (response.statusCode == 200) {
//         // Get.find<FirebaseController>().pNumber.clear();
//         // Get.find<FirebaseController>().otp.clear();
//         clearSharedData();
//         // Get.find<FirebaseController>().logoutFirebase();
//         Get.find<SignUpController>().clearSignUpTextField();
//         Navigator.pushAndRemoveUntil(
//           navigatorKey.currentContext!,
//           getCustomRoute(child: const SplashScreen()),
//           (route) => false,
//         );
//       } else {}
//     } catch (e) {
//       log('---- ${e.toString()} ----', name: "ERROR AT logout()");
//     }
//   }
}
