import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invt/core.dart';
import 'package:invt/state_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../view/dashboard_view.dart';

class DashboardController extends State<DashboardView>
    implements MvcController {
  static late DashboardController instance;
  late DashboardView view;

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    instance = this;
    super.initState();
    // getUserdata();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  String? username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUserData();
  }

  // String? userdata = await storage.read(key: 'userdata');

  Future<void> loadUserData() async {
    // Baca userdata dari FlutterSecureStorage
    String? userDataString = await storage.read(key: 'userdata');

    if (userDataString != null) {
      Map<String, dynamic> userdata = jsonDecode(userDataString);

      //ambil properti yang dibutuhkan
      String? nama = userdata['nama'];

      setState(() {
        username = nama;
      });
    }
    print(username);
    // setState(() {}); // memperbarui tampilan dengan userdata yang baru
  }

  Future<void> doLogout() async {
    // Hapus data akses token dan userdata dari FlutterSecureStorage
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'userdata');

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 10),
                  Text('Success'),
                ],
              ),
              content: Text('Berhasil Keluar.'),
              actions: [
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Get.to(LoginView());
                  },
                  label: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ));
  }
}
