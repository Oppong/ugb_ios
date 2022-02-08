import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:ugbs_dawuro_ios/providers/assignment_provider.dart';
import 'package:ugbs_dawuro_ios/widgets/reuseable_button.dart';

import '../../constant.dart';

class AddAssignmentsPage extends StatefulWidget {
  // const AddAssignmentsPage({Key? key}) : super(key: key);

  static const String id = 'add assignments';
  @override
  _AddAssignmentsPageState createState() => _AddAssignmentsPageState();
}

class _AddAssignmentsPageState extends State<AddAssignmentsPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String? title, details, deadline;
  DateTime? timed;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _deadlineController = TextEditingController();
  DateTime? selectedDate;
  Color? assignmentColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'ADD ASSIGNMENTS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                onChanged: (val) {
                  title = val;
                },
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return 'enter title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Title for Assignment',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _detailsController,
                maxLines: null,
                onChanged: (val) {
                  details = val;
                },
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return 'enter details';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter details for assignment',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Select Date'),
              SizedBox(height: 5),
              DateTimeField(
                onDateSelected: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                selectedDate: selectedDate,
                lastDate: DateTime(DateTime.now().year + 50),
                firstDate: DateTime(1930),
                mode: DateTimeFieldPickerMode.date,
                decoration: InputDecoration(
                  hintText: 'Deadline Date',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Text('Select Time'),
              SizedBox(height: 5),
              FormBuilderDateTimePicker(
                name: 'time',
                initialTime: TimeOfDay.now(),
                fieldHintText: 'Add Time',
                inputType: InputType.time,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.access_time),
                ),
                onChanged: (val) {
                  timed = val;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: OColorPicker(
                                selectedColor: assignmentColor,
                                colors: primaryColorsPalette,
                                onColorChange: (color) {
                                  setState(() {
                                    assignmentColor = color;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ));
                  },
                  child: Row(
                    children: [
                      Text('Select Color'),
                      SizedBox(width: 10),
                      Container(
                        height: 30,
                        width: 30,
                        color: assignmentColor ?? Color(0xffffd428),
                      )
                    ],
                  )),
              SizedBox(height: 20),
              ReusableButton(
                label: 'Add Assignment',
                color: kMainColor,
                textColor: Colors.white,
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    Provider.of<AssignmentsProvider>(context, listen: false)
                        .addAssignments(
                      title: title,
                      deadline: selectedDate,
                      details: details,
                      pending: false,
                      assignmentColor: assignmentColor!.value,
                      time: timed,
                    );

                    _titleController.clear();
                    _detailsController.clear();
                    _deadlineController.clear();

                    showFlushBar();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  showFlushBar() {
    return Flushbar(
      title: 'Added Successful',
      message: 'Your assignment has been Added successfully',
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: kMainColor,
      leftBarIndicatorColor: Colors.white,
      icon: Icon(
        Icons.info_outline,
        size: 20,
        color: Colors.white,
      ),
    )..show(context);
  }
}
