import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:admin_app/rounded_button.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/Screens/charts.dart';
import 'package:admin_app/Screens/userlist.dart';
import 'package:admin_app/Screens/studentlist.dart';
import 'package:admin_app/Screens/driverslist.dart';
import 'package:admin_app/Screens/vehiclelist.dart';
import 'package:admin_app/Screens/linelist.dart';
import 'package:admin_app/Screens/linetypelist.dart';
import 'package:admin_app/Screens/schedulelist.dart';
import 'package:admin_app/Screens/dayofflist.dart';
import 'package:admin_app/login.dart';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController page = PageController();

  logoutPressed() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token != null) {
      final headers = {"Authorization": "Bearer $token"};
      print(headers);
      await http
          .post(Uri.http(baseURL(), '/api/logout2'), headers: headers)
          .then((response) async {
        var jsonData = jsonDecode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          successSnackBar(context, 'Đăng xuất thành công');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          errorSnackBar(context, 'Có lỗi xảy ra 1');
        }
      }).catchError((error) {
        errorSnackBar(context, 'Có lỗi xảy ra 2');
      });
    } else {
      errorSnackBar(context, 'Có lỗi xảy ra 3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
              // showTooltip: false,
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            title: Column(
              children: [
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              // SideMenuItem(
              //   priority: 0,
              //   title: 'Trang chủ',
              //   onTap: () {
              //     page.jumpToPage(0);
              //   },
              //   icon: const Icon(Icons.home),
              //   tooltipContent: "This is a tooltip for Dashboard item",
              // ),
              SideMenuItem(
                priority: 0,
                title: 'Người dùng',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Học sinh',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.school),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Các tuyến xe',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.format_list_numbered),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Loại Tuyến',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: const Icon(Icons.type_specimen_rounded),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Lộ trình',
                onTap: () {
                  page.jumpToPage(4);
                },
                icon: const Icon(Icons.location_on_sharp),
              ),
              SideMenuItem(
                priority: 5,
                title: 'Tài xế',
                onTap: () {
                  page.jumpToPage(5);
                },
                icon: const Icon(Icons.support),
              ),
              SideMenuItem(
                priority: 6,
                title: 'Xe',
                onTap: () {
                  page.jumpToPage(6);
                },
                icon: const Icon(Icons.drive_eta),
              ),
              SideMenuItem(
                priority: 7,
                title: 'Ngày nghỉ',
                onTap: () {
                  page.jumpToPage(7);
                },
                icon: const Icon(Icons.calendar_month),
              ),
              SideMenuItem(
                priority: 8,
                title: 'Đăng xuất',
                onTap: () {
                  logoutPressed();
                },
                icon: const Icon(Icons.logout),
              ),
              // const SideMenuItem(
              //   priority: 9,
              //   title: 'Exit',
              //   icon: Icon(Icons.exit_to_app),
              // ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                // Container(color: Colors.white, child: const Text('YES')),
                Container(
                  color: Colors.white,
                  child: const Center(child: UserListScreen()),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: StudentListScreen()),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: LineListScreen()),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: LineTypeListScreen()),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: ScheduleListScreen()),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: DriverListScreen()),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: VehicleListScreen()),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: DayOffListScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
