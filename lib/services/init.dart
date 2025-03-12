import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testungapp/controllers/firebase_controller.dart';
import 'package:testungapp/data/repositories/basic_repo.dart';

import '../controllers/auth_controller.dart';
import '../controllers/category_controller.dart';
import '../data/api/api_calls.dart';
import '../data/api/api_client.dart';
import '../data/repositories/auth_repo.dart';
import 'constants.dart';

class Init {
  getBaseUrl() async {
    ApiCalls calls = ApiCalls();
    await calls
        .apiCallWithResponseGet(
            'https://fishcary.com/fishcary/api/link2.php?for=true')
        .then((value) {
      log(value.toString());
      AppConstants().setBaseUrl = jsonDecode(value)['link'];
      log(AppConstants().getBaseUrl, name: 'BASE');
    });
  }

  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      // Get.lazyPut(FirebaseController());
      Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
      Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
      Get.lazyPut(() => BasicRepo(apiClient: Get.find(), sharedPreferences: Get.find()));



      Get.lazyPut(() => FirebaseController());
      Get.lazyPut(() => AuthController(authRepo: Get.find()));
      Get.lazyPut(()=>CategoryController(basicRepo: Get.find()));
      // Get.lazyPut(()=>CategoryDetailsController(basicRepo: Get.find(),));


    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
