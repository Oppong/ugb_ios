import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsBlogDetails extends StatefulWidget {
  const NewsBlogDetails(
      {this.description,
      this.title,
      this.datePublished,
      this.imageUrl,
      this.createdBy,
      Key? key})
      : super(key: key);
  static const String id = 'news blog details';

  final String? createdBy, description, title, imageUrl;
  final DateTime? datePublished;

  @override
  _NewsBlogDetailsState createState() => _NewsBlogDetailsState();
}

class _NewsBlogDetailsState extends State<NewsBlogDetails> {
  var dated = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.black])
                      .createShader(bounds);
                },
                child: Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 7,
                child: Text(
                  widget.title!,
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Positioned(
                bottom: 20,
                right: 7,
                child: Text(
                  'By: ${widget.createdBy!}',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Positioned(
                bottom: 40,
                left: 7,
                width: 200,
                child: Text(
                  dated.format(
                    DateTime.parse(widget.datePublished!.toString()),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.description!,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.8,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
