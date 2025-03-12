import 'dart:convert';
import 'dart:developer';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:testungapp/data/models/response/category_model.dart';

import '../data/models/response/response_model.dart';
import '../data/repositories/basic_repo.dart';

class CategoryDetailsController extends GetxController implements GetxService {
  CategoryDetailsController({required this.basicRepo,required this.category});
  final BasicRepo basicRepo;
  final String category;

  bool _isLoading = false;
  bool get isLoading {
    return _isLoading;
  }





  List<CategoryModel> categoryDetailsDataList = [];

  Future<ResponseModel> fetchCategoryDetailsData() async {
    log('fetchCategoryDetailsData() CALLED');
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      final response = await basicRepo.fetchCategoryDetailsData(category);
      if (response.statusCode == 200) {
        log(response.bodyString.toString(), name: 'fetchCategoryDetailsData()');
        if (response.body.containsKey('errors')) {
          responseModel = ResponseModel(false, response.statusText!, response.body['errors']);
        } else {
          categoryDetailsDataList = categorydataFromJson(json.encode(response.body['meals']));
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
