import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ugbs_dawuro_ios/apppages/news_blog_details.dart';
import 'package:ugbs_dawuro_ios/providers/newsblogprovider.dart';

var dated = DateFormat.yMMMd();

newsBlogPromo() {
  return Consumer<NewsBlogProvider>(
    builder: (context, newsblog, child) => ListView.builder(
      shrinkWrap: true,
      itemCount: newsblog.itemsNewsBlogList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsBlogDetails(
                  imageUrl: newsblog.itemsNewsBlogList[index].imageUrl!,
                  title: newsblog.itemsNewsBlogList[index].title!,
                  createdBy: newsblog.itemsNewsBlogList[index].createdBy!,
                  description: newsblog.itemsNewsBlogList[index].description!,
                  datePublished:
                      newsblog.itemsNewsBlogList[index].datePublished!,
                ),
              ),
            );
          },
          child: Stack(
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
                  newsblog.itemsNewsBlogList[index].imageUrl!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 7,
                child: Container(
                  width: 180,
                  child: Text(
                    newsblog.itemsNewsBlogList[index].title!,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 7,
                child: Text(
                  'NEWS BLOG',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 7,
                child: Text(
                  dated.format(
                    DateTime.parse(newsblog.itemsNewsBlogList[index].createdAt!
                        .toString()
                        .toUpperCase()),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
