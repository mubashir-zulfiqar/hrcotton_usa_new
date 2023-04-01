import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewer extends StatelessWidget {
  String documentUrl = "", title = "";
  PdfViewer({Key? key, required this.documentUrl, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<PdfDocument> doc = PdfDocument.openData(InternetFile.get(documentUrl));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // const SpinKitFadingCircle(color: Color(0xFF0061A6))
      body: Center(
        child: PdfViewPinch(
          controller: PdfControllerPinch(
            document: doc,
          ),
        ),
      ),
    );
  }
}
