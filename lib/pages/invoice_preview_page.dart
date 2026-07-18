import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:united_app/utils/invoice_pdf.dart';

class InvoicePreviewPage extends StatelessWidget {
  const InvoicePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice Preview")),
      body: PdfPreview(
        build: (format) => InvoicePdf.generate(),
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }
}