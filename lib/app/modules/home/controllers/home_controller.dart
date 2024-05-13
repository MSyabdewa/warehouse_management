import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/models/product_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;

  Future<void> downloadCatalog() async {
    final pdf = pw.Document();

    var getData = await firestore.collection("products").get();

    allProducts([]);

    for (var element in getData.docs) {
      allProducts.add(ProductModel.fromJson(element.data()));
    }

    final pw.Font regularFont =
        pw.Font.ttf(await rootBundle.load("assets/OpenSans-Regular.ttf"));

    final pw.Font boldFont =
        pw.Font.ttf(await rootBundle.load("assets/OpenSans-Bold.ttf"));

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          List<pw.TableRow> allData = List.generate(
            allProducts.length,
            (index) {
              ProductModel product = allProducts[index];
              return pw.TableRow(
                children: [
                  // No
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 50, horizontal: 10),
                    child: pw.Text(
                      "${index + 1}",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: regularFont,
                      ),
                    ),
                  ),
                  // Kode Barang
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 50, horizontal: 10),
                    child: pw.Text(
                      product.code,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: regularFont,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 50, horizontal: 10),
                    child: pw.Text(
                      product.name,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: regularFont,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 50, horizontal: 10),
                    child: pw.Text(
                      "${product.qty}",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: regularFont,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.BarcodeWidget(
                      color: PdfColor.fromHex("#000000"),
                      barcode: pw.Barcode.qrCode(),
                      data: product.code,
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              );
            },
          );
          return [
            pw.Center(
              child: pw.Text(
                "Catalog",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: boldFont, fontSize: 30),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // No
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 30, horizontal: 10),
                      child: pw.Text(
                        "No",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: boldFont,
                        ),
                      ),
                    ),
                    // Kode Barang
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Product Code",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: boldFont,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Product Name",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: boldFont,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 25, horizontal: 8),
                      child: pw.Text(
                        "Quantity",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: boldFont,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "QR Code",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: boldFont,
                        ),
                      ),
                    ),
                  ],
                ),
                ...allData,
              ],
            )
          ];
        },
      ),
    );

    //simpan file
    Uint8List bytes = await pdf.save();

    // buat file kosong di direktori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/catalog.pdf');
    print('PDF saved at: ${file.path}');

    // memasukan data bytes -> file kosong
    await file.writeAsBytes(bytes);

    // open file pdf menggunakan open_filex
    await OpenFilex.open(
      '/data/user/0/com.miniproject.warehouse_management/app_flutter/catalog.pdf',
      type: 'application/pdf',
    );
  }
}
