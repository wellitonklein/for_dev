import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget makePage({@required String path, @required Widget Function() page}) {
  final getPages = [
    GetPage(
      name: path,
      page: page,
    ),
    GetPage(
      name: '/fake_page',
      page: () => Scaffold(appBar: AppBar(), body: const Text('fake page')),
    ),
  ];
  if (path != '/login') {
    getPages.add(GetPage(
      name: '/login',
      page: () => Scaffold(body: const Text('fake login')),
    ));
  }
  return GetMaterialApp(
    navigatorObservers: [Get.put<RouteObserver>(RouteObserver<PageRoute>())],
    initialRoute: path,
    getPages: getPages,
  );
}

String get currentRoute => Get.currentRoute;
