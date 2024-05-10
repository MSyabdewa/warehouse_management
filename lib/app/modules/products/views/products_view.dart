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
                      "Products",
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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

                List<ProductModel> allProducts = [];

                for (var element in snapProducts.data!.docs) {
                  allProducts.add(ProductModel.fromJson(element.data()));
                }

                return ListView.builder(
                  itemCount: allProducts.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    ProductModel product = allProducts[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.detailProduct, arguments: product);
                        },
                        borderRadius: BorderRadius.circular(9),
                        child: Container(
                          height: 110,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.code,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(product.name),
                                    Text("Jumlah : ${product.qty}"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: QrImageView(
                                  data: product.code,
                                  size: 200.0,
                                  version: QrVersions.auto,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
