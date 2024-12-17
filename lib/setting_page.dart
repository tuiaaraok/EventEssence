import 'dart:developer';

import 'package:event_management/provider/them_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() {
    // TODO: implement createState
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 308.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Light",
                        style: TextStyle(
                          color:
                              context.watch<ThemeProvider>().switchLightColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 37.34.sp,
                        ),
                      ),
                      StyledSwitch(
                        key: widget.key,
                        onToggled: (isToggled) {},
                      ),
                      Text(
                        "Dark",
                        style: TextStyle(
                          color: context.watch<ThemeProvider>().switchDarkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 37.34.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 48.h,
                ),
                SizedBox(
                  height: 255.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((MapEntry<String, String> e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          // ···
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'sedatgul29@icloud.com',
                            query: encodeQueryParameters(<String, String>{
                              '': '',
                            }),
                          );
                          try {
                            if (await canLaunchUrl(emailLaunchUri)) {
                              await launchUrl(emailLaunchUri);
                            } else {
                              throw Exception(
                                  "Could not launch $emailLaunchUri");
                            }
                          } catch (e) {
                            log('Error launching email client: $e'); // Log the error
                          }
                        },
                        child: infoBtn(
                            "Contact Us",
                            context.watch<ThemeProvider>().containerColor,
                            context.watch<ThemeProvider>().textContainerColor),
                      ), // Используем read),
                      GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse(
                              'https://docs.google.com/document/d/1ZISwCM2O6i-2Pnri_W1zLuoUStbyZX6dJ0ZyMt7PkZw/mobilebasic');
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        child: infoBtn(
                            "Privacy Policy",
                            context.watch<ThemeProvider>().containerColor,
                            context.watch<ThemeProvider>().textContainerColor),
                      ),
                      GestureDetector(
                        onTap: () async {
                          InAppReview.instance.openStoreListing(
                            appStoreId: '6738952934',
                          );
                          // 6738952934
                        },
                        child: infoBtn(
                            "Rate Us",
                            context.watch<ThemeProvider>().containerColor,
                            context.watch<ThemeProvider>().textContainerColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Image(
                      width: double.infinity,
                      height: 308.h,
                      image: const AssetImage("assets/menu.png")),
                ),
              ],
            ),
            SizedBox(
              height: 60.h,
            )
          ],
        ),
      ),
    );
  }
}

Widget infoBtn(String description, Color container, Color text) {
  return Container(
    width: 309.w,
    height: 67.h,
    decoration: BoxDecoration(
        color: container,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: Offset(0, 4.h),
              blurRadius: 4)
        ]),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 22.sp, fontWeight: FontWeight.w600, color: text),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: text,
            size: 22.h,
          )
        ],
      ),
    ),
  );
}

class StyledSwitch extends StatefulWidget {
  final void Function(bool isToggled) onToggled;

  const StyledSwitch({super.key, required this.onToggled});

  @override
  State<StyledSwitch> createState() => _StyledSwitchState();
}

class _StyledSwitchState extends State<StyledSwitch> {
  bool isToggled = false;
  double size = 50.h;
  double innerPadding = 0;

  @override
  void initState() {
    innerPadding = size / 10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ThemeProvider>().toggleTheme(); // Используем read
        widget.onToggled(isToggled);
      },
      onPanEnd: (b) {
        widget.onToggled(isToggled);
      },
      child: AnimatedContainer(
        height: size,
        width: size * 2,
        padding: EdgeInsets.all(innerPadding),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: context.watch<ThemeProvider>().isDarkMode
              ? const Color(0xFF1E1E1E)
              : const Color(0xFF7FABFF),
        ),
        child: Stack(
          children: [
            context.watch<ThemeProvider>().isDarkMode
                ? Center(
                    child: Container(
                    width: 70.w,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/icons/onDark.png"))),
                  ))
                : Center(
                    child: SvgPicture.asset(
                      "assets/icons/onLight.svg",
                      width: 70.w,
                    ),
                  ),
            context.watch<ThemeProvider>().isDarkMode
                ? const SizedBox.shrink()
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Container(
                        width: 40.h,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: context.watch<ThemeProvider>().isDarkMode
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
