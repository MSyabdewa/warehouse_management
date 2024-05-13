import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/models/product_model.dart';
import '../../../utils/color_palette.dart';
import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({super.key});

  final ProductModel product = Get.arguments;
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameC.text = product.name;
    qtyC.text = "${product.qty}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.pacificBlue,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 35),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Detail Product",
          style: TextStyle(
            fontSize: 24,
            color: ColorPalette.timberGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: product.code,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: nameC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: qtyC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () async {
                if (!controller.isLoadingUpdate.value) {
                  if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                    controller.isLoadingUpdate.value = true;
                    Map<String, dynamic> hasil = await controller.editProduct({
                      "id": product.productId,
                      "name": nameC.text,
                      "qty": int.tryParse(qtyC.text) ?? 0,
                    });
                    controller.isLoadingUpdate.value = false;

                    Get.snackbar(
                      hasil["error"] == true ? "Error" : "Success",
                      hasil["message"],
                      duration: const Duration(seconds: 2),
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      "All data must be filled.",
                      duration: const Duration(seconds: 2),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: Obx(
                () => Text(
                  controller.isLoadingUpdate.value
                      ? "LOADING..."
                      : "UPDATE PRODUCT",
                  style: const TextStyle(color: Color(0xFF0096a5)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Product",
                  content: const Column(
                    children: [
                      Text("Are you sure you want to delete this product?"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        controller.isLoadingDelete.value = true;
                        Map<String, dynamic> hasil =
                            await controller.deleteProduct(product.productId);
                        controller.isLoadingDelete.value = false;

                        Get.back(); // Close dialog
                        Get.back(); // Back to all products page

                        Get.snackbar(
                          hasil["error"] == true ? "Error" : "Success",
                          hasil["message"],
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Obx(
                          () => controller.isLoadingDelete.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 1),
                                )
                              : const Text("DELETE"),
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: Text(
                "Delete Product",
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
