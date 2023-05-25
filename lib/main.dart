import 'package:invt/core.dart';
import 'package:invt/state_util.dart';
import 'package:flutter/material.dart';

void main() async {
  // await initialize();
  Widget mainView = const LoginView();
  runApp(
    MaterialApp(
      title: 'Inventory',
      navigatorKey: Get.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: mainView,
    )
    );
}


