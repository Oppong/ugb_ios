import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ugbs_dawuro_ios/constant.dart';

class ViewDocument extends StatefulWidget {
  const ViewDocument({this.title, this.fileUrl, Key? key}) : super(key: key);
  static const String id = 'view document';
  final String? title, fileUrl;

  @override
  _ViewDocumentState createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(widget.title!),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.previousPage();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.nextPage();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SfPdfViewer.network(
          widget.fileUrl!,
          controller: _pdfViewerController,
          canShowPaginationDialog: true,
        ),
      ),
    );
  }
}

/*

 */
