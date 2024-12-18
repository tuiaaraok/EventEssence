import 'package:event_management/contacs_page.dart';
import 'package:event_management/event_page.dart';
import 'package:event_management/provider/them_provider.dart';
import 'package:event_management/setting_page.dart';
import 'package:event_management/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() {
    // TODO: implement createState
    return _MenuPageState();
  }
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              width: double.infinity,
              height: 268.h,
              image: const AssetImage("assets/menu.png")),
          SizedBox(
            height: 80.h,
          ),
          SizedBox(
            height: 349.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const EventPage(),
                      ),
                    );
                  },
                  child: menuBtn(
                      "Events",
                      context.watch<ThemeProvider>().containerColor,
                      context.read<ThemeProvider>().textContainerColor),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => TaskPage(),
                        ),
                      );
                    },
                    child: menuBtn(
                        "Tasks",
                        context.watch<ThemeProvider>().containerColor,
                        context.read<ThemeProvider>().textContainerColor)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ContacsPage(),
                      ),
                    );
                  },
                  child: menuBtn(
                      "Contacts",
                      context.watch<ThemeProvider>().containerColor,
                      context.read<ThemeProvider>().textContainerColor),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SettingPage(),
                      ),
                    );
                  },
                  child: menuBtn(
                      "Settings",
                      context.watch<ThemeProvider>().containerColor,
                      context.read<ThemeProvider>().textContainerColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

menuBtn(String description, Color container, Color text) {
  return Container(
    width: 309.w,
    height: 67.h,
    decoration: BoxDecoration(
        color: container,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 4.h),
              blurRadius: 4)
        ]),
    child: Center(
      child: Text(
        description,
        style: TextStyle(
            fontSize: 22.sp, fontWeight: FontWeight.w600, color: text),
      ),
    ),
  );
}
