import 'package:flutter/material.dart';

import '../constant.dart';

class UGBSMissionAndVision extends StatelessWidget {
  const UGBSMissionAndVision({Key? key}) : super(key: key);
  static const String id = 'ugbs vision and mission';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        title: Text(
          'MISSION AND VISION',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
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
          ],
        ),
      ),
    );
  }
}
