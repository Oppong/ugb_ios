class TermPaperModel {
  final String? title;
  final String? details;
  final DateTime? deadline;
  final String? termPaperId;
  final int? colors;
  final DateTime? time;
  bool? pending = false;

  TermPaperModel(
      {this.title,
      this.details,
      this.deadline,
      this.termPaperId,
      this.pending,
      this.colors,
      this.time});
}
