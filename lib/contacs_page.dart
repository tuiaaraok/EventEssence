import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:event_management/add_contacs_page.dart';
import 'package:event_management/hive/contact_model.dart';
import 'package:event_management/hive/hive_box.dart';
import 'package:event_management/provider/them_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContacsPage extends StatefulWidget {
  const ContacsPage({super.key});

  @override
  State<ContacsPage> createState() {
    // TODO: implement createState
    return _ContacsPageState();
  }
}

class _ContacsPageState extends State<ContacsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: SizedBox(
          width: double.infinity,
          child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<ContactModel>(HiveBoxes.contactModel).listenable(),
              builder: (context, Box<ContactModel> box, _) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 342.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                  width: 49.w,
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(Icons.menu))),
                            ),
                            Text(
                              "Contacts",
                              style: TextStyle(
                                  fontSize: 22.sp, fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const AddContacsPage(),
                                  ),
                                );
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          width: 2.w,
                                          color: const Color(0xFF4749F1))),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Text("+ADD",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF4749F1),
                                          )),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 37.h,
                      ),
                      for (int i = 0; i < box.values.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 28.h),
                          child: SizedBox(
                            width: 342.w,
                            child: Column(
                              children: [
                                Container(
                                  width: 342.w,
                                  decoration: BoxDecoration(
                                      color: context
                                              .watch<ThemeProvider>()
                                              .isDarkMode
                                          ? darkcolorInfoContainer(i + 1)
                                          : colorInfoContainer(i + 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r)),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            offset: Offset(0, 4.h),
                                            blurRadius: 4)
                                      ]),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 13.h, right: 13.w),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              customButton: SvgPicture.asset(
                                                "assets/icons/drop_menu.svg",
                                                // ignore: deprecated_member_use
                                                color: context
                                                    .watch<ThemeProvider>()
                                                    .iconColor,
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 24.w,
                                                                left: 14.w,
                                                                top: 13.h),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            String? encodeQueryParameters(
                                                                Map<String,
                                                                        String>
                                                                    params) {
                                                              return params
                                                                  .entries
                                                                  .map((MapEntry<
                                                                              String,
                                                                              String>
                                                                          e) =>
                                                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                                  .join('&');
                                                            }

                                                            // ···
                                                            final Uri
                                                                emailLaunchUri =
                                                                Uri(
                                                              scheme: 'mailto',
                                                              path: box
                                                                  .getAt(i)
                                                                  ?.mail,
                                                              query:
                                                                  encodeQueryParameters(<String,
                                                                      String>{
                                                                '': '',
                                                              }),
                                                            );
                                                            try {
                                                              if (await canLaunchUrl(
                                                                  emailLaunchUri)) {
                                                                await launchUrl(
                                                                    emailLaunchUri);
                                                              } else {
                                                                throw Exception(
                                                                    "Could not launch $emailLaunchUri");
                                                              }
                                                            } catch (e) {
                                                              log('Error launching email client: $e'); // Log the error
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "Send message",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17.sp,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                              SvgPicture.asset(
                                                                  "assets/icons/send.svg")
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const Divider(),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 24.w,
                                                                left: 14.w),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            var url = Uri.parse(
                                                                "tel:${box.getAt(i)?.phone}");
                                                            if (await canLaunchUrl(
                                                                url)) {
                                                              await launchUrl(
                                                                  url);
                                                            } else {
                                                              throw 'Could not launch $url';
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "Call",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          17.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                              SvgPicture.asset(
                                                                  "assets/icons/phone.svg")
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const Divider(),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 24.w,
                                                                left: 14.w),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            box.deleteAt(i);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17.sp,
                                                                      color: const Color(
                                                                          0xFFFF1A1A),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                              SvgPicture.asset(
                                                                  "assets/icons/delete.svg")
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onChanged: (value) {},
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: 191.h,
                                                width: 250.w,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: const Color(0xFFEDEDED)
                                                      .withOpacity(0.9),
                                                ),
                                                offset: const Offset(0, -10),
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                      height: 143.h,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 342.w,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 28.h),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5.h),
                                                child: Text(
                                                  box
                                                          .getAt(i)
                                                          ?.name
                                                          .toString() ??
                                                      "",
                                                  style: TextStyle(
                                                      color: context
                                                          .watch<
                                                              ThemeProvider>()
                                                          .iconColor,
                                                      height: 1.h,
                                                      fontSize: 22.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 17.w),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 21.h),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/time.svg",
                                                            // ignore: deprecated_member_use
                                                            color: context
                                                                .watch<
                                                                    ThemeProvider>()
                                                                .containerColor,
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Text(
                                                            box
                                                                    .getAt(i)
                                                                    ?.phone
                                                                    .toString() ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: context
                                                                  .watch<
                                                                      ThemeProvider>()
                                                                  .containerColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 19.h),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/caledar.svg",
                                                            // ignore: deprecated_member_use
                                                            color: context
                                                                .watch<
                                                                    ThemeProvider>()
                                                                .containerColor,
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Text(
                                                            box
                                                                    .getAt(i)
                                                                    ?.mail
                                                                    .toString() ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: context
                                                                  .watch<
                                                                      ThemeProvider>()
                                                                  .containerColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Color colorInfoContainer(int i) {
    if (i % 2 == 0) {
      return const Color(0xFFD1FFBE); // Если i четное
    } else if (i % 3 == 0) {
      return const Color(0xFFBEDCFF); // Если i нечетное и кратно 3
    } else {
      return const Color(0xFFFFBEBF); // Если i нечетное и не кратно 3
    }
  }

  Color darkcolorInfoContainer(int i) {
    if (i % 3 == 0) {
      return const Color(0xFF1B5A00);
      // Если кратно 3
    } else {
      if (i % 2 == 0) {
        return const Color(0xFF002A5A); // Если i четное
      }
      return const Color(0xFF5A0002); // Если i нечетное
    }
  }
}
