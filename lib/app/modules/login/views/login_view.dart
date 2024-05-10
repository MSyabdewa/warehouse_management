import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/svg_strings.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: SizedBox()),
              SvgPicture.string(SvgStrings.warehouse),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Warehouse\nManagement",
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SvgPicture.string(SvgStrings.location),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Condongcatur',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                      color: const Color(0xff000000).withOpacity(0.16),
                    ),
                  ],
                ),
                height: 50,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  key: UniqueKey(),
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.transparent,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.withOpacity(0.58),
                    ),
                  ),
                  cursorColor: const Color(0xFF0096a5),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                      color: const Color(0xff000000).withOpacity(0.16),
                    ),
                  ],
                ),
                height: 50,
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: TextField(
                          obscureText: controller.isHidden.value,
                          controller: passwordC,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            filled: true,
                            fillColor: Colors.transparent,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.withOpacity(0.58),
                            ),
                          ),
                          cursorColor: const Color(0xFF0096a5),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: controller.isHidden.value
                              ? Colors.black
                              : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          controller.isHidden.toggle();
                        },
                        splashColor: Colors.transparent,
                        splashRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.isLoading.isFalse) {
                          if (emailC.text.isNotEmpty &&
                              passwordC.text.isNotEmpty) {
                            controller.isLoading(true);
                            Map<String, dynamic> hasil =
                                await authC.login(emailC.text, passwordC.text);
                            controller.isLoading(false);

                            if (hasil["error"] == true) {
                              Get.snackbar("Error", hasil["message"]);
                            } else {
                              Get.offAllNamed(Routes.home);
                            }
                          } else {
                            Get.snackbar(
                                "Error", "Email dan password wajib diisi.");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        backgroundColor: const Color(0xFF0096a5),
                      ),
                      child: Obx(
                        () => Text(
                          controller.isLoading.isFalse ? "LOGIN" : "LOADING...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigasi ke halaman register
                      },
                      child: const Text(
                        "Belum punya akun? Register disini",
                        style: TextStyle(
                          color: Color(0xFF0096a5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
