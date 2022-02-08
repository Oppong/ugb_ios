import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constant.dart';
import 'dart:io';

class AboutUGBSPage extends StatefulWidget {
  const AboutUGBSPage({Key? key}) : super(key: key);
  static const String id = 'about ugbs';

  @override
  State<AboutUGBSPage> createState() => _AboutUGBSPageState();
}

class _AboutUGBSPageState extends State<AboutUGBSPage> {
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
          'ABOUT UGBS',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: 'https://ugbs.ug.edu.gh/about-the-school',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

/*
Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            SelectableText(
              'Mission Statement:',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 5),
            SelectableText(
              '“Our mission is to develop quality human resource capacity '
              'and leaders through the provision of world class management '
              'education and relevant cutting edge research to meet national and '
              'global development needs”',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15),
            SelectableText(
              'Vision Statement:',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 5),
            SelectableText(
              'To become a world class business school developing global leaders',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15),
            SelectableText(
              'UGBS',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            SelectableText(
              'The University of Ghana Business School (UGBS) is a premier business school in '
              'the sub-region focused on developing world-class human resources and '
              'capabilities to meet national development needs and global challenges, '
              'through quality teaching, learning, research and knowledge dissemination.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15),
            SelectableText(
              'UGBS is a member of reputable international networks of business schools '
              'such as AACSB - The Association to Advance Collegiate Schools of Business '
              '(www.aacsb.edu/about), GNAM - Global Network for Advanced Management '
              '(http://advancedmanagement.net/) and AABS - Association of African '
              'Business Schools (http://www.aabschools.com/).The School has collaborations '
              'with leading business schools in North America, Europe, Asia and Africa in the '
              'areas of student/faculty exchanges, academic programme, case studies, and research development.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15),
            SelectableText(
              'The School offers various undergraduate, masters and PhD programmes in '
              'its six academic departments – Department of Accounting, Department '
              'of Finance, Department of Marketing & Entrepreneurship, Department of '
              'Operations and Management Information Systems (OMIS), Department of Organisation '
              'and Human Resource Management (OHRM), and Department of Public Administration and '
              'Health Services Management (PAHSM). Some of the masters programmes including EMBA, '
              'MBA, MSc Development Finance,MSc Information Systems,and MA Marketing Strategy are '
              'also run in a flexible mode (evenings, weekends and sandwich) to enable students '
              'pursue graduate studies whiles working.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15),
            SelectableText(
              'The School’s executive education outfit, UGBS-Executive Development(UGBS-ED),'
              'offers executive education and tailored programmes to executives and '
              'senior management across various sectors while its Enterprise Development'
              ' Service (EDS) specialises in providing business development, business advisory, '
              'and consulting to a wide range of enterprises.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15),
            SelectableText(
              'UGBS has qualified and experienced faculty who are committed '
              'to carrying out research that is relevant for policy, '
              'covering a variety of areas including, finance, banking, '
              'insurance, accounting, marketing, entrepreneurship, information '
              'systems, operations management, human resource management, health services '
              'management, and public administration.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      )
 */
