import 'package:event_management/add_event_page.dart';
import 'package:event_management/hive/contact_model.dart';
import 'package:event_management/hive/hive_box.dart';
import 'package:event_management/provider/them_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class AddContacsPage extends StatefulWidget {
  const AddContacsPage({super.key});

  @override
  State<AddContacsPage> createState() {
    // TODO: implement createState
    return _AddContacsPageState();
  }
}

class _AddContacsPageState extends State<AddContacsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  Box<ContactModel> contactBox = Hive.box<ContactModel>(HiveBoxes.contactModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
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
                      "Add Contacts",
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
              CustomWidgets.textFieldForm(
                "Name",
                358.w,
                nameController,
                context.watch<ThemeProvider>().titleColor,
                context.watch<ThemeProvider>().textContainerColor,
                context.watch<ThemeProvider>().strokeColorDec,
              ),
              CustomWidgets.textFieldForm(
                "Phone number",
                358.w,
                phoneController,
                context.watch<ThemeProvider>().titleColor,
                context.watch<ThemeProvider>().textContainerColor,
                context.watch<ThemeProvider>().strokeColorDec,
              ),
              CustomWidgets.textFieldForm(
                "Email",
                358.w,
                mailController,
                context.watch<ThemeProvider>().titleColor,
                context.watch<ThemeProvider>().textContainerColor,
                context.watch<ThemeProvider>().strokeColorDec,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (nameController.text.isNotEmpty &&
                      mailController.text.isNotEmpty &&
                      phoneController.text.isNotEmpty) {
                    contactBox.add(ContactModel(
                        name: nameController.text,
                        mail: mailController.text,
                        phone: phoneController.text));
                    Navigator.pop(
                        context,
                        ContactModel(
                            name: nameController.text,
                            mail: mailController.text,
                            phone: phoneController.text));
                  }
                },
                child: Padding(
                    padding: EdgeInsets.only(bottom: 31.h),
                    child: CustomWidgets.infoBtn("Create a contact")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
