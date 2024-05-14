import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/color_palette.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.pacificBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        title: const Text(
          "Homepage",
          style: TextStyle(
            fontSize: 26,
            color: ColorPalette.timberGreen,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.power_settings_new,
              color: ColorPalette.timberGreen,
            ),
            onPressed: () async {
              Map<String, dynamic> hasil = await authC.logout();
              if (hasil["error"] == false) {
                Get.offAllNamed(Routes.login);
              } else {
                Get.snackbar("Error", hasil["error"]);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GridView.builder(
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (BuildContext context, int index) {
            late String title;
            late IconData icon;
            late VoidCallback onTap;
            switch (index) {
              case 0:
                title = "Add Product";
                icon = Icons.post_add_rounded;
                onTap = () => Get.toNamed(Routes.addProduct);
                break;
              case 1:
                title = "Products";
                icon = Icons.list_alt_outlined;
                onTap = () => Get.toNamed(Routes.products);
                break;
              case 2:
                title = "QR Code";
                icon = Icons.qr_code;
                onTap = () async {
                  String barcode = await FlutterBarcodeScanner.scanBarcode(
                    "#000000",
                    "CANCEL",
                    true,
                    ScanMode.QR,
                  );

                  Map<String, dynamic> hasil =
                      await controller.getProductById(barcode);
                  if (hasil["error"] == false) {
                    Get.toNamed(Routes.detailProduct, arguments: hasil["data"]);
                  } else {
                    Get.snackbar(
                      "Error",
                      hasil["message"],
                      duration: const Duration(seconds: 2),
                    );
                  }
                };
                break;
              case 3:
                title = "Catalog";
                icon = Icons.document_scanner_outlined;
                onTap = () {
                  controller.downloadCatalog();
                };
                break;
            }
            return InkWell(
              onTap: onTap,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 50, color: ColorPalette.pacificBlue),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.chatBot);
        }, // Atur warna ikon sesuai kebutuhan
        backgroundColor: ColorPalette.pacificBlue,
        child: const Icon(Icons.chat,
            color: Colors.white), // Atur warna sesuai kebutuhan
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Menentukan posisi FAB
    );
  }
}
