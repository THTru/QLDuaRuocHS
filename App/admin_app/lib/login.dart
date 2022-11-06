import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutterapp/Services/auth_services.dart';
// import 'package:flutterapp/Services/globals.dart';
import 'package:admin_app/rounded_button.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  String _type = '1';

  loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      // http.Response response = await AuthServices.login(_email, _password);
      // Map responseMap = jsonDecode(response.body);
      final params = {'password': _password, 'email': _email, 'type': _type};
      // var response =
      //     await http.post(Uri.http("localhost:8000", "/api/login2", params));
      // var jsonData = jsonDecode(response.body);
      // if (response.statusCode == 200) {
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (BuildContext context) => const Home(),
      //       ));
      // } else {
      //   errorSnackBar(context, jsonData.values.first);
      // }
      await http
          .post(Uri.http(baseURL(), "/api/login2", params))
          .then((response) {
        var jsonData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Home(),
              ));
        } else {
          errorSnackBar(context, jsonData.values.first);
        }
      }).catchError((error) {
        errorSnackBar(context, 'Có lỗi Server');
      });
    } else {
      errorSnackBar(context, 'Xin điền email và password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nhập email',
                ),
                onChanged: (value) {
                  _email = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Nhập password',
                ),
                onChanged: (value) {
                  _password = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              RoundedButton(
                btnText: 'LOG IN',
                onBtnPressed: () => loginPressed(),
              )
            ],
          ),
        ));
  }
}
