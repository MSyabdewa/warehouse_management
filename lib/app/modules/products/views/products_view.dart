import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/color_palette.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

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
          "Products",
          style: TextStyle(
            fontSize: 24,
            color: ColorPalette.timberGreen,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamProducts(),
        builder: (context, snapProducts) {
          if (snapProducts.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapProducts.data!.docs.isEmpty) {
            return const Center(
              child: Text("No products"),
            );
          }

          List<ProductModel> allProducts = snapProducts.data!.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList();

          return ListView.builder(
            itemCount: allProducts.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            itemBuilder: (context, index) {
              ProductModel product = allProducts[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: ListTile(
                  onTap: () {
                    Get.toNamed(Routes.detailProduct, arguments: product);
                  },
                  contentPadding: const EdgeInsets.all(10),
                  leading: QrImageView(
                    data: product.code,
                    version: QrVersions.auto,
                    size: 50.0,
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text("Code: ${product.code}"),
                      Text("Jumlah: ${product.qty}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
