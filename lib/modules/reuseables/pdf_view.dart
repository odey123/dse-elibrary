import 'package:flutter/material.dart';
import 'package:pdf_viewer_plus/pdf_viewer.dart';

class PdfView extends StatefulWidget {
  final String title;
  final String url;
  const PdfView({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PdfViewer(
        pdfPath: widget.url,
        initialSidebarOpen: true,
        sidebarWidth: 180,
        thumbnailHeight: 160,
        sidebarBackgroundColor: Colors.grey[300]!,
      ),
    );
  }
}
