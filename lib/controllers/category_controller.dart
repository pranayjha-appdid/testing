import 'dart:convert';
import 'dart:developer';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:testungapp/data/models/response/category_model.dart';

import '../data/models/response/response_model.dart';
import '../data/repositories/basic_repo.dart';

class CategoryController extends GetxController implements GetxService {
  CategoryController({required this.basicRepo});
  final BasicRepo basicRepo;

  bool _isLoading = false;
  bool get isLoading {
    return _isLoading;
  }


  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
  }


  List<CategoryModel> categoryDataList = [];
  
  Future<ResponseModel> fetchCategoryData() async {
    log('fetchCategoryData() CALLED');
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      final response = await basicRepo.fetchCategoryData();
      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: 'fetchCategoryData()');
        if (response.body.containsKey('errors')) {
          responseModel = ResponseModel(false, response.statusText!, response.body['errors']);
        } else {
          categoryDataList = categorydataFromJson(json.encode(response.body['categories']));
          responseModel = ResponseModel(true, '${response.body}', response.body);
        }
      } else {
        responseModel = ResponseModel(false, response.statusText!, response.body['errors']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, 'CATCH');
      log('++++++++ ${e.toString()} ++++++++', name: 'ERROR AT fetchCategoryData()');
    }

    _isLoading = false;
    update();
    return responseModel;
  }


}
