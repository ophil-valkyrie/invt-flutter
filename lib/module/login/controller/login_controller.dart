import 'package:flutter/material.dart';
import 'package:invt/core.dart';
import 'package:invt/state_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../view/login_view.dart';

class LoginController extends State<LoginView> implements MvcController {
  static late LoginController instance;
  late LoginView view;

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  String? username;
  String? password;

  Future<void> doLogin() async {
    // api url
    const url = 'http://192.168.0.10:5001';

    // validasi input
    if (username == null || password == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Error'),
                  ],
                ),
                content: Text('Masukkan Username dan Password'),
                actions: [
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () => Navigator.pop(context),
                    label: const Text(
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
    } else {
      try {
        var response = await http.post(Uri.parse('$url/users/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
            }));

        if (response.statusCode == 200) {
          // login berhasil
          var jsonResponse = jsonDecode(response.body);
          var token = jsonResponse['accessToken'];
          var userdata = jsonResponse['userdata'];
          // print(token);

          // print('Login Berhasil');
          // Simpan akses token ke FlutterSecureStorage
          await storage.write(key: 'accessToken', value: jsonEncode(token));
          await storage.write(key: 'userdata', value: jsonEncode(userdata));

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
                    content: Text('Berhasil Masuk.'),
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
                          Get.to(DashboardView());
                        },
                        label: const Text(
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
        } else {
          //login gagal
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Error'),
                      ],
                    ),
                    content: Text('Gagal Masuk.'),
                    actions: [
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () => Navigator.pop(context),
                        label: const Text(
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
      } catch (e) {
        // terjdi kesalahan
        print('Kesalanan: $e');
      }
    }
    // return;
  }
}
