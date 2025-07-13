import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

Future<void> showPdfViewerDialog(BuildContext context, Uint8List bytes) async {
  try {
    final pdfDocument = PdfDocument.openData(bytes);
    final pdfController = PdfControllerPinch(document: pdfDocument);

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        child: SizedBox(
          width: 600,
          height: 600,
          child: PdfViewPinch(controller: pdfController),
        ),
      ),
    );

    pdfController.dispose();
  } catch (e) {
    debugPrint('Error loading PDF: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load PDF')),
    );
  }
}
