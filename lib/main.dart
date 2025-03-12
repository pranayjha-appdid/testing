import 'dart:io';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'services/constants.dart';
import 'services/init.dart';
import 'services/theme.dart';
import 'views/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid)
    await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Init().initialize();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // initPlatForm() async {
  //   // OneSignal.Debug.setLogLevel(OSLogLevel.info);
  //   //
  //   // OneSignal.initialize('65205fba-5398-4a03-8f6b-2fdbf8926432'); //---------------------ADD ONESIGNAL APP ID
  //   // // OneSignal.Notifications.requestPermission(true);
  //   // print(OneSignal.User.pushSubscription.id);
  //   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  //   OneSignal.shared.setAppId("65205fba-5398-4a03-8f6b-2fdbf8926432"); //---------------------ADD ONESIGNAL APPID
  //   // print(await Get.find<AuthController>().authRepo.getDeviceId());
  //   await Permission.notification.request();
  //   OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //     if (kDebugMode) {
  //       print("Accepted permission: $accepted");
  //     }
  //   });
  //   OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
  //     event.complete(event.notification);
  //   });
  //   OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
  //   OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {});
  //   OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {});
  //   OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {});
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('Current state = $state');
  }

  @override
  void initState() {
    super.initState();
    // initPlatForm();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: AppConstants.appName,
        navigatorKey: navigatorKey,
        themeMode: ThemeMode.light,
        theme: CustomTheme.light,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
