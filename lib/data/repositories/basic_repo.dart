import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/constants.dart';
import '../api/api_client.dart';

class BasicRepo {
  BasicRepo({required this.sharedPreferences, required this.apiClient});

  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  Future<Response> fetchCategoryData() async =>
      await apiClient.getData(AppConstants.getCategoryData);

  Future<Response> fetchCategoryDetailsData(String category) async =>
      await apiClient
          .get(AppConstants.getCategoryDetailsData, query: {'c': category});
}
