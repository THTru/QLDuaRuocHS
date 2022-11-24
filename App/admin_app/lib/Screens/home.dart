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
import 'package:admin_app/Screens/linetypelist.dart';
import 'package:admin_app/Screens/schedulelist.dart';

import 'package:easy_sidemenu/easy_sidemenu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  goToUserList() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const UserListScreen(),
        ));
  }

  goToStudentList() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const StudentListScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Trang chủ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Material(
                        color: Colors.orange,
                        elevation: 5,
                        child: MaterialButton(
                          minWidth: 250,
                          height: 60,
                          onPressed: () {
                            goToUserList();
                          },
                          child: Text(
                            "Người dùng",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Material(
                        color: Colors.orange,
                        elevation: 5,
                        child: MaterialButton(
                          minWidth: 250,
                          height: 60,
                          onPressed: () {
                            goToStudentList();
                          },
                          child: Text(
                            "Học sinh",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Material(
                        color: Colors.orange,
                        elevation: 5,
                        child: MaterialButton(
                          minWidth: 250,
                          height: 60,
                          onPressed: () {
                            errorSnackBar(context, 'Xe & tài xế');
                          },
                          child: Text(
                            "Xe & tài xế",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Material(
                        color: Colors.orange,
                        elevation: 5,
                        child: MaterialButton(
                          minWidth: 250,
                          height: 60,
                          onPressed: () {
                            errorSnackBar(context, 'Lịch trình');
                          },
                          child: Text(
                            "Lịch trình",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            )));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController page = PageController();

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
                // ConstrainedBox(
                //   constraints: const BoxConstraints(
                //     maxHeight: 150,
                //     maxWidth: 150,
                //   ),
                //   child: const Icon(
                //     Icons.school_outlined,
                //     color: Colors.blueAccent,
                //     size: 100,
                //   ),
                // ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            // footer: const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     'mohada',
            //     style: TextStyle(fontSize: 15),
            //   ),
            // ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Trang chủ',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.home),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                priority: 1,
                title: 'Người dùng',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Học sinh',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.school),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Các tuyến xe',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: const Icon(Icons.format_list_numbered),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Loại Tuyến',
                onTap: () {
                  page.jumpToPage(4);
                },
                icon: const Icon(Icons.type_specimen_rounded),
              ),
              SideMenuItem(
                priority: 5,
                title: 'Lộ trình',
                onTap: () {
                  page.jumpToPage(5);
                },
                icon: const Icon(Icons.location_on_sharp),
              ),
              SideMenuItem(
                priority: 6,
                title: 'Tài xế',
                onTap: () {
                  page.jumpToPage(6);
                },
                icon: const Icon(Icons.support),
              ),
              SideMenuItem(
                priority: 7,
                title: 'Xe',
                onTap: () {
                  page.jumpToPage(7);
                },
                icon: const Icon(Icons.drive_eta),
              ),
              SideMenuItem(
                priority: 8,
                title: 'Settings',
                onTap: () {
                  page.jumpToPage(8);
                },
                icon: const Icon(Icons.settings),
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
                Container(
                  color: Colors.white,
                  child: const Center(child: ChartsScreen()),
                ),
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
                  child: const Center(
                    child: Text(
                      'Tuyến xe',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
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
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
