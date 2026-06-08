import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../chat/controller/chat_controller.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../../../route/app_routes.dart';
import '../../../listing/model/listing_model.dart';

class ListingDetailStickyBar extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const ListingDetailStickyBar({
    super.key,
    required this.t,
    required this.listing,
  });

  Future<void> _call() async {
    final phone = listing.ownerPhone;
    if (phone == null) return;
    try {
      await launchUrl(Uri.parse('tel:$phone'));
    } catch (_) {}
  }

  void _onMessageTap() {
    // Check if ChatController is registered, if not, it means we are in a state 
    // where bindings weren't loaded (like guest browsing or direct link).
    if (!Get.isRegistered<ChatController>()) {
      Get.snackbar('Error', 'Chat system is initializing. Please try again in a moment.');
      return;
    }

    final chatController = Get.find<ChatController>();
    
    // Check for existing chat first
    final existingChat = chatController.findExistingChat(listing.id);
    if (existingChat != null) {
      chatController.openChat(existingChat);
      return;
    }

    // Show dialog to enter initial message
    final textController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Message Owner', style: TextStyle(color: t.ink, fontWeight: FontWeight.w700, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ask a question or request to view this flat.',
              style: TextStyle(color: t.inkMid, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: t.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.borderSoft),
              ),
              child: TextField(
                controller: textController,
                maxLines: 3,
                style: TextStyle(color: t.ink, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Hi, is this flat still available?',
                  hintStyle: TextStyle(color: t.inkFaint),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: t.inkSoft)),
          ),
          ElevatedButton(
            onPressed: () async {
              final msg = textController.text.trim();
              if (msg.isEmpty) return;
              Get.back(); // close dialog
              
              Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
              final result = await chatController.startChat(listingId: listing.id, initialMessage: msg);
              Get.back(); // close loading
              
              if (result != null) {
                // Success - startChat should navigate or update UI
                Get.toNamed(Routes.chatList);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: t.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhone = listing.ownerPhone != null;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.borderSoft)),
      ),
      child: Row(
        children: [
          if (hasPhone) ...[
            GestureDetector(
              onTap: _call,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: t.borderSoft),
                ),
                child: Icon(Icons.phone_outlined, color: t.ink, size: 22),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _onMessageTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                '💬 Message Owner',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
