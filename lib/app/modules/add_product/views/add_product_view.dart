import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/color_palette.dart';
import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({super.key});
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          "Add Product",
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
            TextField(
              controller: codeC,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "Product Code",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              cursorColor: ColorPalette.timberGreen,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              cursorColor: ColorPalette.timberGreen,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: qtyC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: const BorderSide(
                    color: ColorPalette.timberGreen,
                  ),
                ),
              ),
              cursorColor: ColorPalette.timberGreen,
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () async {
                if (!controller.isLoading.value) {
                  if (codeC.text.isNotEmpty &&
                      codeC.text.length == 10 &&
                      nameC.text.isNotEmpty &&
                      qtyC.text.isNotEmpty) {
                    controller.isLoading.value = true;
                    Map<String, dynamic> hasil = await controller.addProduct({
                      "code": codeC.text,
                      "name": nameC.text,
                      "qty": int.tryParse(qtyC.text) ?? 0,
                    });
                    controller.isLoading.value = false;
                    Get.back();
                    Get.snackbar(
                      hasil["error"] == true ? "Error" : "Success",
                      hasil["message"],
                    );
                  } else {
                    Get.snackbar("Error", "All data must be filled.");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                backgroundColor: ColorPalette.timberGreen,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: Obx(
                () => Text(
                  controller.isLoading.value ? "LOADING..." : "ADD PRODUCT",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
