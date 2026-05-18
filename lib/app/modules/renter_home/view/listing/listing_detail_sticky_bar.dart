import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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
              onPressed: () => Get.toNamed(Routes.chatList),
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
