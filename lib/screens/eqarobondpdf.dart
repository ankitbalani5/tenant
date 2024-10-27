import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;

  const PdfViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;
  bool _loadError = false;

  @override
  void initState() {
    super.initState();
    _checkPdfAvailability();
  }

  Future<void> _checkPdfAvailability() async {
    try {
      var response = await Dio().get(widget.filePath,
          options: Options(responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) { return status! < 500; }));
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _loadError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loadError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('PDF Viewer')),
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (_loadError) {
      return Scaffold(
        appBar: AppBar(title: const Text('PDF Viewer')),
        body: Center(
          child: Text('Failed to load PDF. Please try again later.'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('PDF Viewer'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.bookmark,
                color: Colors.black,
                semanticLabel: 'Bookmark',
              ),
              onPressed: () {
                _pdfViewerKey.currentState?.openBookmarkView();
              },
            ),
          ],
        ),
        body: SfPdfViewer.network(
          widget.filePath,
          key: _pdfViewerKey,
        ),
      );
    }
  }
}
