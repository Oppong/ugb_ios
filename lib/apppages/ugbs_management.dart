import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constant.dart';
import 'dart:io';

class UGBSManagement extends StatefulWidget {
  const UGBSManagement({Key? key}) : super(key: key);
  static const String id = 'ugbs management';

  @override
  State<UGBSManagement> createState() => _UGBSManagementState();
}

class _UGBSManagementState extends State<UGBSManagement> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'UGBS MANAGEMENT',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: 'http://ugbs.ug.edu.gh/ugbs-management',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
