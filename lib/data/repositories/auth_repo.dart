import 'dart:developer';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  AuthRepo({required this.sharedPreferences, required this.apiClient});

  /// Methods to deal with Remote Data ///
  // Future<Response> sendOtp({required String phone}) async => await apiClient.postData(AppConstants.sendOtp, {
  //   "phone": phone,
  // });


  // Future<Response> verifyOtp({required String phone, required String otp}) async => await apiClient.postData(AppConstants.verifyOtp, {
  //   "phone": phone,
  //   "otp": otp,
  //   "device_id": await getDeviceId(),
  // });


  Future<Response> login(String? deviceId, {String? phone, String? otp}) async =>
      await apiClient.postData(AppConstants.loginUri, {"phone": phone ?? '', "device_id": await getDeviceId(), "otp": otp});

  Future<Response> getUser() async => await apiClient.getData(AppConstants.profileUri);

  Future<Response> getExtras() async => await apiClient.getData(AppConstants.extras);

  /// Methods to deal with Remote Data ///

  /// Methods to deal with Local Data ///
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<bool> saveUserId(String id) async {
    log(getUserId());
    return await sharedPreferences.setString(AppConstants.userId, id);
  }

  String getUserId() {
    return sharedPreferences.getString(AppConstants.userId) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.userId);
    apiClient.token = null;
    apiClient.updateHeader(null);
    return true;
  }

  Future<String> getDeviceId() async {
    return OneSignal.User.pushSubscription.id ?? 'null';
  }

  /// Methods to deal with Local Data ///

  // Methods call for getting category dta

}
