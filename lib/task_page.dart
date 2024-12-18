import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:event_management/add_task_page.dart';
import 'package:event_management/hive/events_model.dart';
import 'package:event_management/hive/hive_box.dart';
import 'package:event_management/hive/task_model.dart';
import 'package:event_management/provider/them_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TaskPage extends StatefulWidget {
  TaskPage({super.key, this.eventName});
  String? eventName;
  @override
  State<TaskPage> createState() {
    // TODO: implement createState
    return _TaskPageState();
  }
}

class _TaskPageState extends State<TaskPage> {
  Box<EventsModel> eventsBox = Hive.box<EventsModel>(HiveBoxes.eventsModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: SizedBox(
          width: double.infinity,
          child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<EventsModel>(HiveBoxes.eventsModel).listenable(),
              builder: (context, Box<EventsModel> box, _) {
                List<TaskModel> list = [];
                widget.eventName == null
                    // ignore: avoid_function_literals_in_foreach_calls
                    ? box.values.forEach((toElement) {
                        list.addAll(toElement.tasks ?? []);
                      })
                    : list = box.get(widget.eventName)?.tasks ?? [];
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
                              "Tasks",
                              style: TextStyle(
                                  fontSize: 22.sp, fontWeight: FontWeight.w600),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                        width: 2.w,
                                        color: const Color(0xFF4749F1))),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                AddTaskPage(),
                                          ),
                                        );
                                      },
                                      child: Text("+ADD",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF4749F1),
                                          )),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 37.h,
                      ),
                      for (int i = list.length - 1; i >= 0; i--)
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
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.25),
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
                                                                top: 12.h,
                                                                right: 24.w,
                                                                left: 14.w),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AddTaskPage(
                                                                  event:
                                                                      list[i],
                                                                  index: i,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "Edit",
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
                                                                  "assets/icons/edit.svg")
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
                                                            deleteTask(
                                                                list[i], box);
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
                                                  color: const Color.fromRGBO(
                                                      237, 237, 237, 0.9),
                                                ),
                                                offset: const Offset(0, -10),
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                      height: 97.h,
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
                                              EdgeInsets.only(bottom: 17.h),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Task No. ${i + 1}",
                                                style: TextStyle(
                                                    height: 1.h,
                                                    fontSize: 22.sp,
                                                    color: context
                                                        .watch<ThemeProvider>()
                                                        .iconColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                list[i].taskName,
                                                style: TextStyle(
                                                    color: context
                                                        .watch<ThemeProvider>()
                                                        .iconColor,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                                            "Time: ${list[i].startTime} - ${list[i].endTime}",
                                                            style: TextStyle(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: context
                                                                    .watch<
                                                                        ThemeProvider>()
                                                                    .containerColor),
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
                                                                  .containerColor),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Text(
                                                            "Date: ${DateFormat("dd MMMM yyyy").format(DateTime(2000 + int.parse(list[i].setDeadline.split("/")[2]), // Year
                                                                int.parse(list[i].setDeadline.split("/")[1]), // Month
                                                                int.parse(list[i].setDeadline.split("/")[0]) // Day
                                                                ))}",
                                                            style: TextStyle(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: context
                                                                    .watch<
                                                                        ThemeProvider>()
                                                                    .containerColor),
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
                                                              "assets/icons/Responsible.svg",
                                                              // ignore: deprecated_member_use
                                                              color: context
                                                                  .watch<
                                                                      ThemeProvider>()
                                                                  .iconColor),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Text(
                                                            "Responsible: ${list[i].assignResponsiblePerson}",
                                                            style: TextStyle(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: context
                                                                    .watch<
                                                                        ThemeProvider>()
                                                                    .iconColor),
                                                          ),
                                                        ],
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

  void deleteTask(TaskModel task, Box<EventsModel> box) {
    // Получаем текущие задачи события
    String? eventKey = widget.eventName;
    EventsModel? event;
    if (eventKey != null) {
      event = box.get(eventKey);
    } else {
      eventKey = task.selectAnEvent;
      event = box.get(task.selectAnEvent);
    }
    if (event != null) {
      List<TaskModel> updatedTasks = List.from(event.tasks ?? []);
      updatedTasks.remove(task); // Удаляем задачу
      event.tasks = updatedTasks; // Обновляем задачи
      box.put(eventKey, event);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task deleted successfully!'),
      ));
    }
  }

  Color colorInfoContainer(int i) {
    if (i % 3 == 0) {
      return const Color(0xFFFFBEBF); // Если кратно 3
    } else {
      if (i % 2 == 0) {
        return const Color(0xFFBEDCFF); // Если i четное
      }
      return const Color(0xFFD1FFBE); // Если i нечетное
    }
  }

  Color darkcolorInfoContainer(int i) {
    if (i % 3 == 0) {
      return const Color(0xFF5A0002); // Если кратно 3
    } else {
      if (i % 2 == 0) {
        return const Color(0xFF002A5A); // Если i четное
      }
      return const Color(0xFF1B5A00); // Если i нечетное
    }
  }
}
