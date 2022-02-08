import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:ugbs_dawuro_ios/providers/termpaper_provider.dart';
import 'package:ugbs_dawuro_ios/widgets/reuseable_button.dart';

import '../../constant.dart';

class TermPapersDetails extends StatefulWidget {
  static const String id = 'termPapers details';

  final String? title;
  final String? details;
  final int? colors;
  final DateTime? deadline;
  final String? termPaperId;
  final DateTime? time;
  TermPapersDetails(
      {this.title,
      this.colors,
      this.deadline,
      this.details,
      this.termPaperId,
      this.time});

  @override
  _TermPapersDetailsState createState() => _TermPapersDetailsState();
}

class _TermPapersDetailsState extends State<TermPapersDetails> {
  var dated = DateFormat.yMMMd();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //for updating termPapers
  String? title, details, deadline;
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? timed;
  Color? termPaperColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.colors!),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context, builder: (context) => alertDialog());
                },
                child: Icon(Icons.edit)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
                onTap: () async {
                  await _firestore
                      .collection('profiles')
                      .doc(_auth.currentUser!.uid)
                      .collection('termPapers')
                      .doc(widget.termPaperId)
                      .update({
                    'pending': true,
                  });
                  Navigator.pop(context);
                  showFlushBarTrash();
                },
                child: Icon(Icons.delete)),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 50,
            color: Color(widget.colors!),
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 19),
                ),
                Row(
                  children: [
                    Text(
                      dated.format(
                        DateTime.parse(widget.deadline.toString()),
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                    Spacer(),
                    Text(
                      DateFormat.jm().format(widget.time!),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              widget.details!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  showFlushBarTrash() {
    return Flushbar(
      title: 'Trashed Successful',
      message: 'Your TermPaper has been Trashed successfully',
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.redAccent,
      leftBarIndicatorColor: Colors.white,
      icon: Icon(
        Icons.info_outline,
        size: 20,
        color: Colors.white,
      ),
    )..show(context);
  }

  AlertDialog alertDialog() {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.title,
                onChanged: (val) {
                  title = val;
                },
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return 'update title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'update Title for Assignment',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: widget.details,
                maxLines: null,
                onChanged: (val) {
                  details = val;
                },
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return 'update details';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'update details for assignment',
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
                                selectedColor: termPaperColor,
                                colors: primaryColorsPalette,
                                onColorChange: (color) {
                                  setState(() {
                                    termPaperColor = color;
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
                        color: termPaperColor ?? Color(0xffffd428),
                      )
                    ],
                  )),
              SizedBox(height: 20),
              ReusableButton(
                label: 'Update TermPaper',
                color: kMainColor,
                textColor: Colors.white,
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    Provider.of<TermPaperProvider>(context, listen: false)
                        .updateTermPaper(
                      title: title ?? widget.title,
                      deadline: selectedDate ?? widget.deadline,
                      details: details ?? widget.details,
                      pending: false,
                      time: timed ?? widget.time,
                      termPaperColor: termPaperColor == null
                          ? widget.colors
                          : termPaperColor!.value,
                      termPaperId: widget.termPaperId,
                    );
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
