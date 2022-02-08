class NewsBlogModel {
  String? createdBy, description, title, imageUrl, newsBlogId;

  DateTime? createdAt, datePublished;

  NewsBlogModel({
    this.imageUrl,
    this.createdAt,
    this.createdBy,
    this.title,
    this.description,
    this.newsBlogId,
    this.datePublished,
  });
}
