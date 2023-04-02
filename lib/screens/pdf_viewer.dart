import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:lottie/lottie.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewer extends StatelessWidget {
  String documentUrl = "", title = "";
  PdfViewer({Key? key, required this.documentUrl, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<PdfDocument> doc = PdfDocument.openData(InternetFile.get(documentUrl));

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(
            fontSize: 18
        )),
        centerTitle: true,
      ),
      // const SpinKitFadingCircle(color: Color(0xFF0061A6))
      body: Center(
        child: FutureBuilder<PdfDocument>(
          future: doc,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: SizedBox(width: 200, child: Lottie.asset('assets/lottie/loading_circle_1.json')),
              );
            } if(snapshot.hasData){
              return PdfViewPinch(
                controller: PdfControllerPinch(
                  document: doc,
                ),
              );
            } else {
              return const Center(
                child:  Text("There is nothing to show."),
              );
            }
          },
        ),
      ),
    );
  }
}
