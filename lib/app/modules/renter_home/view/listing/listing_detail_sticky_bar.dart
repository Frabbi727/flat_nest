import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.borderSoft)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t.borderSoft),
            ),
            child: Icon(Icons.phone_outlined, color: t.ink, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.chatList),
              style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                '💬 Message Owner',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
