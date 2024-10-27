import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPdf extends StatefulWidget {
  final pdf;
  const ShowPdf(this.pdf);

  @override
  State<ShowPdf> createState() => _ShowPdfState();
}

class _ShowPdfState extends State<ShowPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pdf View'),),
      body: Container(
          width: MediaQuery.of(context).size.width,
          child: SfPdfViewer.network(
              widget.pdf)
      ),
    );
  }
}
