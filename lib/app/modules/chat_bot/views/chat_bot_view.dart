import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_palette.dart';
import '../controllers/chat_bot_controller.dart';

class ChatBotView extends GetView<ChatBotController> {
  const ChatBotView({super.key});

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
          "AI Warehouse Management",
          style: TextStyle(
            fontSize: 24,
            color: ColorPalette.timberGreen,
          ),
        ),
      ),
      body: GetBuilder<ChatBotController>(
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: DashChat(
                  currentUser: controller.myself,
                  messages: controller.responses,
                  messageOptions: const MessageOptions(
                    messagePadding: EdgeInsets.all(12),
                    containerColor: ColorPalette.pacificBlue,
                    showTime: true,
                  ),
                  inputOptions: InputOptions(
                    autocorrect: false,
                    inputDecoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: ColorPalette.pacificBlue,
                          width: 2,
                        ),
                      ),
                      label: const Text('Message AI...'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                  onSend: (message) {
                    controller.submitForm(message);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered by AI',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: ColorPalette.timberGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
