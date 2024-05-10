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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 15,
            ),
            width: double.infinity,
            height: 70,
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      "Add Product",
                      style: TextStyle(
                        fontSize: 24,
                        color: ColorPalette.timberGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextField(
                  autocorrect: false,
                  controller: codeC,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Product Code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  cursorColor: const Color(0xFF0096a5),
                ),
                const SizedBox(height: 20),
                TextField(
                  autocorrect: false,
                  controller: nameC, // Uncommented controller
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  cursorColor: const Color(0xFF0096a5),
                ),
                const SizedBox(height: 20),
                TextField(
                  autocorrect: false,
                  controller: qtyC, // Uncommented controller
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(
                        color: Color(0xFF0096a5),
                      ),
                    ),
                  ),
                  cursorColor: const Color(0xFF0096a5),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: () async {
                    if (controller.isLoading.isFalse) {
                      if (codeC.text.isNotEmpty &&
                          codeC.text.length == 10 &&
                          nameC.text.isNotEmpty &&
                          qtyC.text.isNotEmpty) {
                        controller.isLoading(true);
                        Map<String, dynamic> hasil =
                            await controller.addProduct({
                          "code": codeC.text,
                          "name": nameC.text,
                          "qty": int.tryParse(qtyC.text) ?? 0,
                        });
                        controller.isLoading(false);
                        Get.back();
                        Get.snackbar(
                            hasil["error"] == true ? "Error" : "Success",
                            hasil["message"]);
                      } else {
                        Get.snackbar("Error", "Semua data wajib diisi.");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    backgroundColor: const Color(0xFF0096a5),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Obx(
                    () => Text(
                      controller.isLoading.isFalse
                          ? "ADD PRODUCT"
                          : "LOADING...",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
