import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdf {
  static Future<Uint8List> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (context) => [_invoice()],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _invoice() {
    return pw.Column(children: [ pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
      child: pw.Column(
        children: [
          //----------title---------------
          pw.Container(
            padding: const pw.EdgeInsets.all(5),
            alignment: pw.Alignment.center,
            child: pw.Text(
              "Tax Invoice",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
          ),
          //------------header-----------
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// LEFT
              pw.Expanded(
                flex: 5,
                child: pw.Container(
                  height: 230,
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(width: 1),
                      left: pw.BorderSide(width: 1),
                      right: pw.BorderSide(width: 1),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "UNITED IT SOLUTIONS",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 5),

                            pw.Text("No.115, New Jail Road"),
                             pw.SizedBox(height: 5),

                            pw.Text("Madurai-625016"),
 pw.SizedBox(height: 5),
                            pw.Text("State Name : Tamil Nadu"),
 pw.SizedBox(height: 5),
                            pw.Text("E-Mail : uniteditsolutions28@gmail.com"),
                          ],
                        ),
                      ),

                      pw.Divider(height: 1),

                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          "Buyer (Bill to)",
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      ),

                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "VTM LIMITED",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),

                            pw.Text("MADURAI"),

                            pw.SizedBox(height: 10),

                         
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// RIGHT
              pw.Expanded(
                flex: 4,
                child: pw.Container(
                  height: 230,
                  decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _detailRow(
                        "Invoice No.",
                        "U99/26-27",
                        "Dated",
                        "15-Jul-26",
                      ),

                      _detailRow(
                        'Delivery Note',
                        '',
                        'Mode/Terms of Payment',
                        '',
                      ),

                      _detailRow(
                        "Reference No. & Date.",
                        "",
                        "Other References",
                        "",
                      ),

                      _detailRow("Buyer's Order No.", "", "Dated", ""),

                      _detailRow(
                        "Dispatch Doc No.",
                        "",
                        "Delivery Note Date",
                        "",
                      ),

                      _detailRow("Dispatched through", "", "Destination", ""),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(2),
                        child: pw.Text('Terms of Delivery'),
                      ),

                      // _detailRow("Terms of Delivery", ""),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //-----------table------------
          pw.Column(
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(width: 1),
                    right: pw.BorderSide(width: 1),
                    bottom: pw.BorderSide(width: 1),
                  ),
                ),
                child: pw.Row(
                  children: [
                    _headCell("SI", 30),

                    _headCell("Description of Goods", 180),



                    _headCell("Quantity", 50),

                    _headCell("Rate", 65),



                    _headCell("Amount", 45),
                  ],
                ),
              ),

              _itemRow(
                "1",
                "Dell Optiplex 3080 Desktop",

                "1",
                "18,000.00",
                "18,000.00",
              ),

              
              _emptyItemRow(),
              _emptyItemRow(),
              _emptyItemRow(),
            ],
          ),

          //-------------bottom part ---------------
          //total
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(width: 1),
                right: pw.BorderSide(width: 1),
                bottom: pw.BorderSide(width: 1),
              ),
            ),
            child: pw.Column(
              children: [
                _totalRow("Output CGST @9%", "1,372.88"),

                _totalRow("Output SGST @9%", "1,372.88"),

                _totalRow("Round Off", "0.00"),

                pw.Container(
                  height: 26,
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 5),
                          child: pw.Text(
                            "Total",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),

                      pw.Container(
                        width: 120,
                        alignment: pw.Alignment.centerRight,
                        padding: const pw.EdgeInsets.only(right: 5),
                        child: pw.Text(
                          "18,000.00 rs",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //amount in words
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(width: 1),
                right: pw.BorderSide(width: 1),
                bottom: pw.BorderSide(width: 1),
              ),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Amount Chargeable (in words)",
                  style: const pw.TextStyle(fontSize: 8),
                ),

                pw.SizedBox(height: 3),

                pw.Text(
                  "INR Eighteen Thousand Only",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),

          //tax table
          pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
            child: pw.Column(
              children: [
                pw.Container(
                  height: 24,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "Tax Summary",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),

                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        _taxHead("HSN/SAC"),

                        _taxHead("Taxable"),

                        _taxHead("CGST"),

                        _taxHead("SGST"),

                        _taxHead("Total Tax"),
                      ],
                    ),

                    pw.TableRow(
                      children: [
                        _taxCell("8471"),

                        _taxCell("15,254.24"),

                        _taxCell("1,372.88"),

                        _taxCell("1,372.88"),

                        _taxCell("2,745.76"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.Container(
            alignment: pw.Alignment.centerLeft,
            margin: pw.EdgeInsets.only(left: 4),
            child:   pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Amount Chargeable (in words)",
                  style: const pw.TextStyle(fontSize: 8),
                ),

                pw.SizedBox(height: 3),

                pw.Text(
                  "INR Two Thousand Seven Hundred And Fourty Five Rupees and Seventy Six Paise Only",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
        
          //bank details
          pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(width: 1),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [

        pw.Expanded(
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Text(
                  "Company's Bank Details",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 5),

                pw.Text("Bank :KARUR VYSYA BANK"),

                pw.Text("A/c No :1767115000003732"),

                pw.Text("Branch & IFSC :MADURAI NORTH & KVBL0001767"),

              ],
            ),
          ),
        ),

        pw.Container(
          width: 220,
          padding: const pw.EdgeInsets.all(6),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Text(
                "Declaration",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 5),

              pw.Text(
                "We declare that this invoice shows the actual price of the goods described and that all particulars are true and correct.",
                style: const pw.TextStyle(fontSize: 8),
              ),

              pw.SizedBox(height: 35),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Authorised Signatory",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              )

            ],
          ),
        )

      ],
    ),
  ),
  //----------footer-------
 

          
        ],
      ),
    ),
     pw.Container(
    width: double.infinity,
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.all(5),
    child: pw.Text(
      "This is a Computer Generated Invoice",
      style: const pw.TextStyle(
        fontSize: 8,
      ),
    ),
  )
    ]);
  }

  static pw.Widget _taxHead(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      ),
    );
  }

  static pw.Widget _taxCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 8),
      ),
    );
  }

  static pw.Widget _totalRow(String title, String value) {
    return pw.Container(
      height: 22,
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(width: 1)),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(left: 5),
              child: pw.Text(title),
            ),
          ),

          pw.Container(
            width: 120,
            alignment: pw.Alignment.centerRight,
            padding: const pw.EdgeInsets.only(right: 5),
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  static pw.Widget _itemRow(
    String sl,
    String description,
    String qty,
    String inclRate,
    String amount,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(width: 1),
          right: pw.BorderSide(width: 1),
          bottom: pw.BorderSide(width: 1),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _cell(sl, 30),

          _cell(description, 180, alignment: pw.Alignment.topLeft),

          _cell(qty, 50),

          _cell(inclRate, 65, alignment: pw.Alignment.centerRight),


          _cell(amount, 45, alignment: pw.Alignment.centerRight),
        ],
      ),
    );
  }

  static pw.Widget _cell(
    String text,
    double width, {
    double height = 28,
    pw.Alignment alignment = pw.Alignment.center,
  }) {
    return pw.Container(
      width: width,
      height: height,
      padding: const pw.EdgeInsets.symmetric(horizontal: 3),
      alignment: alignment,
      decoration: pw.BoxDecoration(
        border: pw.Border(right: pw.BorderSide(width: 1)),
      ),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 8)),
    );
  }

  static pw.Widget _emptyItemRow() {
    return _itemRow("", "", "", "", "", );
  }

  static pw.Widget _headCell(String text, double width) {
    return pw.Container(
      width: width,
      height: 32,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        border: pw.Border(
          right: pw.BorderSide(width: 1),
          top: pw.BorderSide(width: 1),
        ),
      ),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      ),
    );
  }

  static pw.Widget _detailRow(
    String title1,
    String value1,
    String title2,
    String value2,
  ) {
    return pw.Container(
      height: 22,
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(width: 1)),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              padding: const pw.EdgeInsets.only(left: 4),
              alignment: pw.Alignment.centerLeft,
              child: pw.Column(
                children: [
                  pw.Text(title1, style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(
                    value1,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.VerticalDivider(),
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              padding: const pw.EdgeInsets.only(left: 4),
              alignment: pw.Alignment.centerLeft,
              child: pw.Column(
                children: [
                  pw.Text(title2, style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(
                    value2,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
