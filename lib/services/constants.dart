import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PriceConverter {
  static convert(price) {
    return '₹ ${double.parse('$price').toStringAsFixed(2)}';
  }

  static convertRound(price) {
    return '₹ ${double.parse('$price').toInt()}';
  }

  static convertToNumberFormat(num price) {
    final format = NumberFormat("#,##,##,##0.00", "en_IN");
    return '₹ ${format.format(price)}';
  }
}

void showCustomToast(msg, {color}) {
  Fluttertoast.showToast(
    msg: "$msg",
    backgroundColor: color,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    webPosition: "center",
    webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
  );
}

String getStringFromList(List<dynamic>? data) {
  String str = data.toString();
  return data.toString().substring(1, str.length - 1);
}

class AppConstants {
  String get getBaseUrl => baseUrl;
  set setBaseUrl(String url) => baseUrl = url;

  //TODO: Change Base Url
  static String baseUrl = 'https://www.themealdb.com/';
  // static String baseUrl = 'http://192.168.1.5:9000/'; ///USE FOR LOCAL
  //TODO: Change Base Url
  static String appName = 'Receipe App';

  static const String agoraAppId = 'c87b710048c049f59570bd1895b7e561';

  static const String loginUri = 'api/v1/user/login';
  static const String profileUri = 'api/v1/user/profile';
  static const String extras = 'api/v1/extra';

  // Shared Key
  static const String token = 'user_app_token';
  static const String userId = 'user_app_id';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';



  //Category Page
  static const String getCategoryData = 'api/json/v1/1/categories.php';
  static const String getCategoryDetailsData = 'api/json/v1/1/filter.php';


}
