import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:event_management/add_contacs_page.dart';
import 'package:event_management/hive/contact_model.dart';
import 'package:event_management/hive/events_model.dart';
import 'package:event_management/hive/hive_box.dart';
import 'package:event_management/provider/them_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddEventPage extends StatefulWidget {
  AddEventPage({super.key, this.eventM, this.detail, this.id});
  EventsModel? eventM;
  bool? detail;
  String? id;
  @override
  State<AddEventPage> createState() {
    // TODO: implement createState
    return _AddEventPageState();
  }
}

class _AddEventPageState extends State<AddEventPage> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TextEditingController> addContactPersonsController = [];

  Box<EventsModel> eventsBox = Hive.box<EventsModel>(HiveBoxes.eventsModel);
  Box<ContactModel> contactBox = Hive.box<ContactModel>(HiveBoxes.contactModel);

  String previousText = '';
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);
  DateTime _currentMonth = DateTime.now();
  bool dateYearOrMouth = false;
  DateTime? _startDate;
  bool isStartDate = false;
  bool isEndDate = false;
  bool isRemoveListener = false;
  bool isOpenMenuCategory = false;

  List<String> mouth = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  final List<ContactModel> _currencies = [
    ContactModel(name: "Add ", phone: "New ", mail: "Contacs"),
  ];
  String selectMouth = "";
  String selectMenuItem = "";
  FocusNode noteFocuse = FocusNode();
  Set<String> categoryTypeOfReport = {};
  int currentMonthIndex(String monthName) {
    return mouth.indexOf(monthName) + 1;
  }

  @override
  void initState() {
    super.initState();
    _currencies.addAll(contactBox.values);
    if (widget.eventM != null) {
      eventNameController.text = widget.eventM!.eventName;
      startDateController.text = widget.eventM!.startDate;
      endDateController.text = widget.eventM!.endDate;
      startTimeController.text = widget.eventM!.startTime;
      endTimeController.text = widget.eventM!.endTime;
      locationController.text = widget.eventM!.location;
      descriptionController.text = widget.eventM!.description;
      for (var action in widget.eventM!.contacts) {
        addContactPersonsController.add(TextEditingController(text: action));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: KeyboardActions(
        config: KeyboardActionsConfig(nextFocus: false, actions: [
          KeyboardActionsItem(
            focusNode: noteFocuse,
          ),
        ]),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: 358.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: const Color(0xFFFF0000),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "Add Events",
                        style: TextStyle(
                            color: context.watch<ThemeProvider>().titleColor,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 52.w,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 358.w,
                  child: Column(
                    children: [
                      CustomWidgets.textFieldForm(
                        "Event name",
                        358.w,
                        eventNameController,
                        context.watch<ThemeProvider>().titleColor,
                        context.watch<ThemeProvider>().textContainerColor,
                        context.watch<ThemeProvider>().strokeColorDec,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomWidgets.textFieldCalendar(
                              "Start date",
                              169.w,
                              "assets/icons/caledar.svg",
                              startDateController,
                              isStartDate,
                              context.watch<ThemeProvider>().titleColor,
                              context.watch<ThemeProvider>().textContainerColor,
                              context.watch<ThemeProvider>().strokeColorDec,
                              onToggle: () {
                            setState(() {
                              if (!isStartDate && isEndDate) {
                                isEndDate = false;
                              }
                              isStartDate = !isStartDate;
                            });
                          }, onChange: (text) {
                            validDate(text, startDateController);
                          }),
                          CustomWidgets.textFieldCalendar(
                              "End date",
                              169.w,
                              "assets/icons/caledar.svg",
                              endDateController,
                              isStartDate,
                              context.watch<ThemeProvider>().titleColor,
                              context.watch<ThemeProvider>().textContainerColor,
                              context.watch<ThemeProvider>().strokeColorDec,
                              onToggle: () {
                            setState(() {
                              if (!isEndDate && isStartDate) {
                                isStartDate = false;
                              }
                              isEndDate = !isEndDate;
                            });
                          }, onChange: (text) {
                            validDate(text, endDateController);
                          }),
                        ],
                      ),
                      if (isStartDate) myCustomCalendar(startDateController),
                      if (isEndDate) myCustomCalendar(endDateController),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomWidgets.textFieldCalendar(
                              "Start Time",
                              169.w,
                              "assets/icons/time.svg",
                              startTimeController,
                              isStartDate,
                              context.watch<ThemeProvider>().titleColor,
                              context.watch<ThemeProvider>().textContainerColor,
                              context.watch<ThemeProvider>().strokeColorDec,
                              onChange: (text) {}),
                          CustomWidgets.textFieldCalendar(
                              "End Time",
                              169.w,
                              "assets/icons/time.svg",
                              endTimeController,
                              isStartDate,
                              context.watch<ThemeProvider>().titleColor,
                              context.watch<ThemeProvider>().textContainerColor,
                              context.watch<ThemeProvider>().strokeColorDec,
                              onChange: (text) {}),
                        ],
                      ),
                      CustomWidgets.textFieldForm(
                        "Location",
                        358.w,
                        locationController,
                        context.watch<ThemeProvider>().titleColor,
                        context.watch<ThemeProvider>().textContainerColor,
                        context.watch<ThemeProvider>().strokeColorDec,
                      ),
                      CustomWidgets.descriptionTextFieldForm(
                          "Description",
                          358.w,
                          descriptionController,
                          context.watch<ThemeProvider>().titleColor,
                          context.watch<ThemeProvider>().textContainerColor,
                          context.watch<ThemeProvider>().strokeColorDec,
                          noteFocuse),
                      Padding(
                        padding: EdgeInsets.only(top: 26.h, bottom: 6.h),
                        child: GestureDetector(
                          onTap: () {
                            addContactPersonsController
                                .add(TextEditingController());
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Add contact persons",
                                style: TextStyle(
                                    color: context
                                            .watch<ThemeProvider>()
                                            .isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              SvgPicture.asset("assets/icons/add_contact.svg",
                                  // ignore: deprecated_member_use
                                  color:
                                      context.watch<ThemeProvider>().isDarkMode
                                          ? const Color(0xFF404040)
                                          : Colors.black)
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: addContactPersonsController.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: SizedBox(
                                    width: 358.h,
                                    child: Text(
                                      "Add contact persons",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: context
                                                  .watch<ThemeProvider>()
                                                  .isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                              Container(
                                width: 358.h,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r)),
                                  color: context
                                      .watch<ThemeProvider>()
                                      .textContainerColor,
                                  border: Border.all(
                                      color: context
                                          .watch<ThemeProvider>()
                                          .strokeColorDec,
                                      width: 2.w),
                                ),
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        onMenuStateChange: (isOpen) {
                                          isOpenMenuCategory =
                                              !isOpenMenuCategory;

                                          setState(() {});
                                        },
                                        alignment: Alignment.center,
                                        customButton: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 20.w),
                                                child: Wrap(
                                                    spacing: 10,
                                                    runAlignment:
                                                        WrapAlignment.center,
                                                    alignment:
                                                        WrapAlignment.start,
                                                    children:
                                                        addContactPersonsController[
                                                                index]
                                                            .text
                                                            .split(",")
                                                            .map((toElement) {
                                                      return Text(
                                                        toElement,
                                                        style: TextStyle(
                                                            color: context
                                                                .watch<
                                                                    ThemeProvider>()
                                                                .titleColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.sp),
                                                      );
                                                    }).toList()),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 43.h,
                                              child: Icon(
                                                isOpenMenuCategory
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                color: context
                                                    .watch<ThemeProvider>()
                                                    .containerColor,
                                                size: 30.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                        items: _currencies
                                            .expand((ContactModel item) => [
                                                  DropdownMenuItem<
                                                          ContactModel>(
                                                      value: item,
                                                      child: SizedBox(
                                                        width: 354.w,
                                                        height: 50.h,
                                                        child: Wrap(
                                                          spacing: 10,
                                                          runAlignment:
                                                              WrapAlignment
                                                                  .center,
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              item.name,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              item.phone,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              item.mail,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ])
                                            .toList(),
                                        onChanged: (value) {
                                          if (value?.name != "Add ") {
                                            _currencies.remove(value);
                                          }
                                          if (addContactPersonsController[index]
                                              .text
                                              .isNotEmpty) {
                                            List<String> contact =
                                                addContactPersonsController[
                                                        index]
                                                    .text
                                                    .split(",");
                                            _currencies.insert(
                                                1,
                                                ContactModel(
                                                    name: contact[0],
                                                    mail: contact[1],
                                                    phone: contact[2]));
                                          }
                                          if (value?.name == "Add ") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<ContactModel>(
                                                builder:
                                                    (BuildContext context) =>
                                                        const AddContacsPage(),
                                              ),
                                            ).then((onValue) {
                                              if (onValue != null) {
                                                String con =
                                                    // ignore: prefer_interpolation_to_compose_strings
                                                    onValue.name + ",";
                                                con +=
                                                    // ignore: prefer_interpolation_to_compose_strings
                                                    onValue.mail + ",";
                                                // ignore: prefer_interpolation_to_compose_strings
                                                con += onValue.phone + ",";
                                                addContactPersonsController[
                                                        index]
                                                    .text = (con);
                                                setState(() {});
                                              }
                                            });
                                          }
                                          if (value?.name != "Add ") {
                                            String con =
                                                // ignore: prefer_interpolation_to_compose_strings
                                                (value?.name ?? "") + ",";
                                            // ignore: prefer_interpolation_to_compose_strings
                                            con += (value?.mail ?? "") + ",";
                                            // ignore: prefer_interpolation_to_compose_strings
                                            con += (value?.phone ?? "") + ",";

                                            addContactPersonsController[index]
                                                .text = (con);
                                          }
                                          setState(() {});
                                        },
                                        dropdownStyleData: DropdownStyleData(
                                          width: 358.w,
                                          maxHeight: 300.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.white,
                                          ),
                                          offset: Offset(-10.w, 0),
                                        ),
                                        menuItemStyleData: MenuItemStyleData(
                                            customHeights: List.filled(
                                                _currencies.length, 50.h),
                                            padding: EdgeInsets.only(
                                                top: 5.h,
                                                left: 10.w,
                                                right: 10.w)),
                                      ),
                                    )),
                              ),
                            ]);
                          }),
                      if (widget.detail == null)
                        Padding(
                            padding: EdgeInsets.only(top: 43.h, bottom: 31.h),
                            child: GestureDetector(
                                onTap: () {
                                  if (eventNameController.text.isNotEmpty &&
                                      startDateController.text.isNotEmpty &&
                                      endDateController.text.isNotEmpty &&
                                      startTimeController.text.isNotEmpty &&
                                      endTimeController.text.isNotEmpty &&
                                      addContactPersonsController.isNotEmpty) {
                                    if (widget.eventM != null) {
                                      eventsBox.put(
                                          widget.id,
                                          EventsModel(
                                              eventName:
                                                  eventNameController.text,
                                              startDate:
                                                  startDateController.text,
                                              endDate: endDateController.text,
                                              startTime:
                                                  startTimeController.text,
                                              endTime: endTimeController.text,
                                              location: locationController.text,
                                              description:
                                                  descriptionController.text,
                                              contacts:
                                                  addContactPersonsController
                                                      .map((toElement) {
                                                return toElement.text;
                                              }).toList(),
                                              tasks: widget.eventM != null
                                                  ? widget.eventM?.tasks ?? []
                                                  : []));
                                    } else {
                                      DateTime date = DateTime.now();
                                      String formattedDate =
                                          '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}'
                                          '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}';
                                      String dateInt = (formattedDate);

                                      eventsBox.put(
                                          dateInt,
                                          EventsModel(
                                              eventName:
                                                  eventNameController.text,
                                              startDate:
                                                  startDateController.text,
                                              endDate: endDateController.text,
                                              startTime:
                                                  startTimeController.text,
                                              endTime: endTimeController.text,
                                              location: locationController.text,
                                              description:
                                                  descriptionController.text,
                                              contacts:
                                                  addContactPersonsController
                                                      .map((toElement) {
                                                return toElement.text;
                                              }).toList(),
                                              tasks: widget.eventM != null
                                                  ? widget.eventM?.tasks ?? []
                                                  : []));
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                child:
                                    CustomWidgets.infoBtn("Create a contact")))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//  Row(
//                                     children: [
//                                       Expanded(
//                                         child: Padding(
//                                             padding:
//                                                 EdgeInsets.only(bottom: 8.h),
//                                             child: Text(
//                                               "",
//                                               style: TextStyle(
//                                                   color: context
//                                                       .watch<ThemeProvider>()
//                                                       .titleColor,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 15.sp),
//                                             )),
//                                       ),
//                                       GestureDetector(
//                                           onTap: () {},
//                                           child: Icon(
//                                             isOpenMenuCategory
//                                                 ? Icons.keyboard_arrow_up
//                                                 : Icons.keyboard_arrow_down,
//                                             color: Color(0xFF5F61F3),
//                                             size: 30.w,
//                                           )),
//                                     ],
//                                   ),
  void validDate(text, TextEditingController dateController) {
    String sanitizedText = text.replaceAll(RegExp(r'[^0-9]'), '');
    String formattedText = '';
    for (int i = 0; i < sanitizedText.length && i < 6; i++) {
      formattedText += sanitizedText[i];
      if (previousText.length > text.length) {
        if (sanitizedText.length > 2) {
          if (i == 1) {
            formattedText += '/';
          }
        }
        if (sanitizedText.length > 4) {
          if (i == 3) {
            formattedText += '/';
          }
        }
      } else {
        if (i == 1 || i == 3) {
          formattedText += '/';
        }
      }
    }

    List<String> parts = formattedText.split('/');
    // ignore: prefer_is_empty
    if (parts.isNotEmpty && parts[0].length > 0) {
      int? day = int.tryParse(parts[0]);
      if (day != null && day > 31) {
        formattedText = formattedText.substring(0, 2);
      }
    }
    // ignore: prefer_is_empty
    if (parts.isNotEmpty && parts.length > 1 && parts[1].length > 0) {
      int? mouth = int.tryParse(parts[1]);
      if (mouth != null && mouth > 12) {
        formattedText = formattedText.substring(0, 2);
      }
    }
    dateController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
    previousText = dateController.text;
  }

  Widget myCustomCalendar(TextEditingController dateController) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        width: 351.w,
        height: 333.h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.r))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: SizedBox(
                  width: 317.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (dateYearOrMouth) {
                            dateYearOrMouth = false;
                            selectMouth = "";
                          } else {
                            dateYearOrMouth = true;
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(_currentMonth),
                              style: TextStyle(
                                  fontSize: 17.37.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 12.h,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_currentMonth.month == 1) {
                                // Если января — переключаемся на декабрь предыдущего года
                                setState(() {
                                  _currentMonth =
                                      DateTime(_currentMonth.year - 1, 12);
                                  _pageController.jumpToPage(
                                      11); // Сброс к странице 11 (декабрь предыдущего года)
                                });
                              } else {
                                setState(() {
                                  _currentMonth = DateTime(
                                    _currentMonth.year,
                                    _currentMonth.month - 1,
                                  );
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              }
                            },
                            child: SvgPicture.asset(
                              "assets/icons/arrow_back.svg",
                              width: 10.w,
                              height: 18.h,
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_currentMonth.month == 12) {
                                // Если декабря — переключаемся на январь следующего года
                                setState(() {
                                  _currentMonth =
                                      DateTime(_currentMonth.year + 1, 1);
                                  _pageController.jumpToPage(
                                      0); // Сброс к странице 0 (январь следующего года)
                                });
                              } else {
                                setState(() {
                                  _currentMonth = DateTime(
                                    _currentMonth.year,
                                    _currentMonth.month + 1,
                                  );
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              }
                            },
                            child: SvgPicture.asset(
                              "assets/icons/arrow_next.svg",
                              width: 10.w,
                              height: 18.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              dateYearOrMouth
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _currentMonth = DateTime(
                                      _currentMonth.year - 1,
                                      _currentMonth.month,
                                    );

                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.remove)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  _currentMonth.year.toString(),
                                  style: TextStyle(
                                      fontSize: 17.37.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _currentMonth = DateTime(
                                      _currentMonth.year + 1,
                                      _currentMonth.month,
                                    );

                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 180.h,
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            childAspectRatio: 300.w / 120.h,
                            children: mouth.map((toElement) {
                              return GestureDetector(
                                onTap: () {
                                  _currentMonth = DateTime(
                                    _currentMonth.year,
                                    currentMonthIndex(toElement),
                                  );
                                  selectMouth = toElement;
                                  setState(() {});
                                },
                                child: Text(
                                  textAlign: TextAlign.start,
                                  toElement,
                                  style: TextStyle(
                                      color: selectMouth == toElement
                                          ? Colors.redAccent
                                          : Colors.grey,
                                      fontSize: 17.37.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    )
                  : Expanded(
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              index + 1,
                            );
                          });
                        },
                        itemCount: 12 * 3,
                        itemBuilder: (context, pageIndex) {
                          return buildCalendar(
                              DateTime(
                                  _currentMonth.year, _currentMonth.month, 1),
                              dateController);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCalendar(DateTime month, TextEditingController dateController) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    List<Widget> calendarCells = [];

    // Добавляем названия дней недели
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (String day in weekDays) {
      calendarCells.add(
        Container(
          alignment: Alignment.center,
          child: Text(day.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.28.sp,
                color: const Color.fromRGBO(60, 60, 67, 0.3),
              )),
        ),
      );
    }

    // Добавляем дни предыдущего месяца
    int daysInPreviousMonth = DateTime(month.year, month.month, 0).day;
    int daysToShowFromPreviousMonth = (weekdayOfFirstDay - 1) % 7;

    for (int i = daysInPreviousMonth - daysToShowFromPreviousMonth + 1;
        i <= daysInPreviousMonth;
        i++) {
      calendarCells.add(const SizedBox.shrink());
    }

    // Добавляем дни текущего месяца
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(month.year, month.month, i);
      calendarCells.add(
        GestureDetector(
          onTap: () {
            _startDate = date;
            dateController.text = DateFormat("dd/MM/yy").format(date);

            setState(() {});
          },
          child: Container(
              decoration: BoxDecoration(
                color: _startDate == null
                    ? Colors.white
                    : DateFormat("DD MM YY").format(date) ==
                            DateFormat("DD MM YY").format(_startDate!)
                        ? const Color.fromRGBO(25, 71, 229, 0.2)
                        : Colors.white, // Цвет для дней текущего месяца
              ),
              child: Center(
                child: Text(date.day.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 20.43.sp)),
              )),
        ),
      );
    }

    int size = calendarCells.length;

    // Добавляем дни текущего месяца
    for (int i = 1;
        // ignore: division_optimization
        size % 7 != 0 ? i <= (7 * ((size / 7).toInt() + 1)) - size : false;
        i++) {
      calendarCells.add(const SizedBox.shrink());
    }

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: calendarCells,
    );
  }
}

class CustomWidgets {
  static Widget infoBtn(String description) {
    return Container(
      width: 358.w,
      height: 52.h,
      decoration: BoxDecoration(
          color: const Color(0xFF4749F1),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
    );
  }

  static Widget textFieldForm(
      String description,
      double widthContainer,
      TextEditingController myController,
      Color title,
      Color container,
      Color stroke,
      {FocusNode? myNode,
      TextInputType? keyboard}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 15.sp, color: title, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          height: 43.h,
          width: widthContainer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: container,
            border: Border.all(color: stroke, width: 2.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Center(
              child: TextField(
                focusNode: myNode,
                controller: myController,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 15.sp)),
                keyboardType: keyboard ?? TextInputType.text,
                cursorColor: title,
                style: TextStyle(
                    color: title, fontWeight: FontWeight.bold, fontSize: 15.sp),
                onChanged: (text) {
                  // Additional functionality can be added here
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget textFieldCalendar(
      String description,
      double widthContainer,
      String svgPath,
      TextEditingController myController,
      bool isStartDate,
      Color title,
      Color container,
      Color stroke,
      {VoidCallback? onToggle,
      void Function(String)? onChange}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 15.sp, color: title, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          height: 43.h,
          width: widthContainer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: container,
            border: Border.all(color: stroke, width: 2.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: '',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 14.sp)),
                      keyboardType: TextInputType.datetime,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: title,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp),
                      onChanged: (text) {
                        onChange!(text);
                      },
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: onToggle, child: SvgPicture.asset(svgPath))
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget textFieldViewCategory(
      String description,
      double widthContainer,
      String currentName,
      bool isOpenMenu,
      Color descriptionColor,
      Color containerColor,
      Color strokeColor,
      Color iconColor,
      List<String> categoryMenu,
      {void Function(String)? onTapMenuElem,
      void Function(bool)? isOpenChanger}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: descriptionColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
          height: isOpenMenu
              ? categoryMenu.isEmpty
                  ? 43.h
                  : null
              : 43.h,
          width: widthContainer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: containerColor,
            border: Border.all(color: strokeColor, width: 2.w),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              onMenuStateChange: (isOpen) {
                isOpenChanger!(isOpen);
              },
              alignment: Alignment.center,
              customButton: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        currentName,
                        style: TextStyle(
                            color: descriptionColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: SizedBox(
                      height: 43.h,
                      child: Icon(
                        isOpenMenu
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: iconColor,
                        size: 30.w,
                      ),
                    ),
                  ),
                ],
              ),
              items: categoryMenu
                  .expand((item) => [
                        DropdownMenuItem<String>(
                            value: item,
                            child: Container(
                              width: widthContainer,
                              height: 50.h,
                              color: currentName == item
                                  ? const Color(0xFFEFF6FF)
                                  : Colors.white,
                              child: Center(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: currentName == item
                                        ? Colors.black
                                        : const Color.fromRGBO(6, 17, 10, 0.5),
                                  ),
                                ),
                              ),
                            )),
                      ])
                  .toList(),
              onChanged: (value) {
                onTapMenuElem!(value.toString());
              },
              dropdownStyleData: DropdownStyleData(
                width: widthContainer,
                maxHeight: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                offset: Offset(0, -10.h),
              ),
              menuItemStyleData: MenuItemStyleData(
                  customHeights: List.filled(categoryMenu.length, 50.h),
                  padding: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w)),
            ),
          ),
        ),
      ],
    );
  }

  static Widget descriptionTextFieldForm(
      String description,
      double widthContainer,
      TextEditingController myController,
      Color title,
      Color container,
      Color stroke,
      FocusNode focus) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 15.sp, color: title, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          height: 108.h,
          width: widthContainer,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: container,
              border: Border.all(color: stroke, width: 2.w)),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                maxLines: null,
                focusNode: focus,
                controller: myController,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16.sp)),
                keyboardType: TextInputType.multiline,
                cursorColor: title,
                style: TextStyle(
                    color: title, fontWeight: FontWeight.bold, fontSize: 16.sp),
                onChanged: (text) {},
              )),
        ),
      ],
    );
  }
}
