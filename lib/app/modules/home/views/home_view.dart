import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 25,
              left: 20,
              right: 15,
            ),
            decoration: const BoxDecoration(
              color: ColorPalette.pacificBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Homepage",
                  style: TextStyle(
                    fontSize: 26,
                    color: ColorPalette.timberGreen,
                  ),
                ),
                IconButton(
                  splashColor: ColorPalette.timberGreen,
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
          ),
          Expanded(
            child: GridView.builder(
              itemCount: 4,
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
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
                    onTap = () {
                      print("Open Camera");
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
                return Material(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(icon, size: 50),
                        ),
                        const SizedBox(height: 10),
                        Text(title),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
