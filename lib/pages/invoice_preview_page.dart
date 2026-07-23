import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:united_app/pages/billwgst_page.dart';
import 'package:united_app/utils/invoice_pdf.dart';

class InvoicePreviewPage extends StatefulWidget {
   final String name;
   final String address;
    final String date;
    final String invoiceNo;
    final List<ProductItem> products;

   const InvoicePreviewPage({super.key, required this.name, required this.address, required this.date, required this.invoiceNo, required this.products, });

  @override
  State<InvoicePreviewPage> createState() => _InvoicePreviewPageState();
}

class _InvoicePreviewPageState extends State<InvoicePreviewPage> {
  double zoom = 1.0;
  @override
  Widget build(BuildContext context) {
 return Scaffold(
  appBar: AppBar(title: const Text("Invoice Preview")),
  body: InteractiveViewer(
    minScale: 0.5,
    maxScale: 5,
    child: PdfPreview(
      build: (format) => InvoicePdf.generate(
         widget.name,
            widget.address,
            widget.date,
            widget.invoiceNo,
            widget.products

      ),
      canChangePageFormat: false,
      canChangeOrientation: false,
      canDebug: false,
    ),
  ),
);

  }
}

