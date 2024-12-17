import 'package:event_management/add_event_page.dart';
import 'package:event_management/hive/contact_model.dart';
import 'package:event_management/hive/events_model.dart';
import 'package:event_management/hive/hive_box.dart';
import 'package:event_management/hive/task_model.dart';
import 'package:event_management/provider/them_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddTaskPage extends StatefulWidget {
  AddTaskPage({super.key, this.event, this.index});
  TaskModel? event;
  int? index;
  @override
  State<AddTaskPage> createState() {
    // TODO: implement createState
    return _AddTaskPageState();
  }
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  TextEditingController deadlineController = TextEditingController();
  String selectAnEvent = "";
  String assignResponsiblePerson = "";

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
  bool isOpenMenuAdd = false;
  Box<TaskModel> taskBox = Hive.box<TaskModel>(HiveBoxes.taskModel);
  Box<EventsModel> eventsBox = Hive.box<EventsModel>(HiveBoxes.eventsModel);
  Box<ContactModel> contactBox = Hive.box<ContactModel>(HiveBoxes.contactModel);
  String key = "";

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
  String selectMouth = "";
  String selectMenuItem = "";
  Set<String> categoryTypeOfReport = {};
  int currentMonthIndex(String monthName) {
    return mouth.indexOf(monthName) + 1;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.event != null) {
      key = widget.event!.selectAnEvent;
      isOpenMenuAdd = true;
      selectAnEvent = eventsBox.get(key)!.eventName;
      taskNameController.text = widget.event!.taskName;
      startTimeController.text = widget.event!.startTime;
      endTimeController.text = widget.event!.endTime;
      assignResponsiblePerson = widget.event!.assignResponsiblePerson;
      deadlineController.text = widget.event!.setDeadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: SingleChildScrollView(
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
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: const Color(0xFFFF0000),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Text(
                        "Add Tasks",
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
                      CustomWidgets.textFieldViewCategory(
                          "Select an event",
                          358.w,
                          selectAnEvent,
                          isOpenMenuCategory,
                          context.watch<ThemeProvider>().titleColor,
                          context.watch<ThemeProvider>().backgroundColor,
                          context.watch<ThemeProvider>().strokeColorDec,
                          context.watch<ThemeProvider>().containerColor,
                          eventsBox.keys.map((toElement) {
                            return eventsBox.get(toElement)!.eventName;
                          }).toList(), onTapMenuElem: (p0) {
                        selectAnEvent = p0;
                        key = eventsBox.keys
                            .where((toElement) =>
                                eventsBox.get(toElement)!.eventName == p0)
                            .first;
                        setState(() {});
                      }, isOpenChanger: (isOPen) {
                        isOpenMenuCategory = !isOPen;

                        setState(() {});
                      }),
                      CustomWidgets.textFieldForm(
                        "Task name",
                        358.w,
                        taskNameController,
                        context.watch<ThemeProvider>().titleColor,
                        context.watch<ThemeProvider>().textContainerColor,
                        context.watch<ThemeProvider>().strokeColorDec,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomWidgets.textFieldCalendar(
                            "Start Time",
                            169.w,
                            "assets/icons/time.svg",
                            startTimeController,
                            isEndDate,
                            context.watch<ThemeProvider>().titleColor,
                            context.watch<ThemeProvider>().textContainerColor,
                            context.watch<ThemeProvider>().strokeColorDec,
                          ),
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
                      CustomWidgets.textFieldViewCategory(
                          "Assign a responsible person",
                          358.w,
                          assignResponsiblePerson,
                          isOpenMenuAdd,
                          context.watch<ThemeProvider>().titleColor,
                          context.watch<ThemeProvider>().backgroundColor,
                          context.watch<ThemeProvider>().strokeColorDec,
                          context.watch<ThemeProvider>().containerColor,
                          contactBox.values.map((toElement) {
                            return "${toElement.name} ${toElement.phone} ${toElement.mail}";
                          }).toList(), onTapMenuElem: (p0) {
                        assignResponsiblePerson = p0;
                        setState(() {});
                      }, isOpenChanger: (isOPen) {
                        isOpenMenuAdd = !isOPen;

                        setState(() {});
                      }),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomWidgets.textFieldCalendar(
                              "Set a deadline",
                              169.w,
                              "assets/icons/caledar.svg",
                              deadlineController,
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
                            validDate(text, deadlineController);
                          })),
                    ],
                  ),
                ),
                isStartDate
                    ? myCustomCalendar(startTimeController)
                    : SizedBox(
                        height: 200.h,
                      ),
                Padding(
                    padding: EdgeInsets.only(top: 43.h, bottom: 31.h),
                    child: GestureDetector(
                        onTap: () {
                          if (key.isNotEmpty &&
                              taskNameController.text.isNotEmpty &&
                              startTimeController.text.isNotEmpty &&
                              endTimeController.text.isNotEmpty &&
                              assignResponsiblePerson.isNotEmpty &&
                              deadlineController.text.isNotEmpty) {
                            if (widget.event != null) {
                              List<TaskModel>? tasks =
                                  eventsBox.get(key)?.tasks;
                              tasks![widget.index!.toInt()] = TaskModel(
                                  selectAnEvent: key,
                                  taskName: taskNameController.text,
                                  startTime: startTimeController.text,
                                  endTime: endTimeController.text,
                                  assignResponsiblePerson:
                                      assignResponsiblePerson
                                          .split(RegExp(r'\d+'))[0]
                                          .trim(),
                                  setDeadline: deadlineController.text);
                              eventsBox.put(
                                  key,
                                  EventsModel(
                                    eventName: eventsBox.get(key)!.eventName,
                                    startDate: eventsBox.get(key)!.startDate,
                                    endDate: eventsBox.get(key)!.endDate,
                                    startTime: eventsBox.get(key)!.startTime,
                                    endTime: eventsBox.get(key)!.endTime,
                                    location: eventsBox.get(key)!.location,
                                    description:
                                        eventsBox.get(key)!.description,
                                    contacts: eventsBox.get(key)!.contacts,
                                    tasks: tasks,
                                  ));
                            } else {
                              eventsBox.put(
                                  key,
                                  EventsModel(
                                      eventName: eventsBox.get(key)!.eventName,
                                      startDate: eventsBox.get(key)!.startDate,
                                      endDate: eventsBox.get(key)!.endDate,
                                      startTime: eventsBox.get(key)!.startTime,
                                      endTime: eventsBox.get(key)!.endTime,
                                      location: eventsBox.get(key)!.location,
                                      description:
                                          eventsBox.get(key)!.description,
                                      contacts: eventsBox.get(key)!.contacts,
                                      tasks: [
                                        ...eventsBox.get(key)?.tasks ?? [],
                                        TaskModel(
                                            selectAnEvent: key,
                                            taskName: taskNameController.text,
                                            startTime: startTimeController.text,
                                            endTime: endTimeController.text,
                                            assignResponsiblePerson:
                                                assignResponsiblePerson
                                                    .split(RegExp(r'\d+'))[0]
                                                    .trim(),
                                            setDeadline:
                                                deadlineController.text)
                                      ]));
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: CustomWidgets.infoBtn("Create a contact")))
              ],
            ),
          ),
        ),
      ),
    );
  }

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
                color: const Color(0xFF3C3C43).withOpacity(0.3),
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
                        ? const Color(0xFF1947E5).withOpacity(0.2)
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
      // ignore: unused_local_variable
      DateTime date = DateTime(month.year, month.month + 1, i);
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
