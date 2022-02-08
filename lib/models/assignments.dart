import 'package:flutter/cupertino.dart';

class AssignmentsModel {
  final String? title;
  final String? details;
  final DateTime? deadline;
  final String? assignmentsId;
  final int? colors;
  final DateTime? time;
  bool? pending = false;

  AssignmentsModel({
    this.title,
    this.details,
    this.deadline,
    this.assignmentsId,
    this.pending,
    this.colors,
    this.time,
  });
}
