import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/access_request_controller.dart';
import '../model/access_request_model.dart';

class OwnerAccessRequestsView extends GetView<AccessRequestController> {
  const OwnerAccessRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.surface,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new, size: 18, color: t.ink),
        ),
        title: Text(
          'Contact Requests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: t.ink,
            letterSpacing: -0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: t.borderSoft),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          _FilterChips(t: t),
          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return _LoadingShimmer(t: t);
              }
              if (controller.requests.isEmpty) {
                return _EmptyState(t: t);
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollEndNotification &&
                      n.metrics.pixels >= n.metrics.maxScrollExtent - 80) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  itemCount: controller.requests.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    if (i >= controller.requests.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: CircularProgressIndicator(color: t.primary),
                        ),
                      );
                    }
                    return _AccessRequestCard(
                      t: t,
                      request: controller.requests[i],
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────

class _FilterChips extends GetView<AccessRequestController> {
  final FlatNestTheme t;
  const _FilterChips({required this.t});

  @override
  Widget build(BuildContext context) {
    const statuses = [
      ('pending', 'Pending'),
      ('accepted', 'Accepted'),
      ('rejected', 'Rejected'),
    ];

    return Container(
      color: t.surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Obx(() => Row(
            children: statuses.map((s) {
              final isActive = controller.selectedStatus.value == s.$1;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.selectedStatus.value = s.$1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isActive ? t.primary : t.bg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? t.primary : t.borderSoft,
                      ),
                    ),
                    child: Text(
                      s.$2,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : t.inkMid,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}

// ── Request card ──────────────────────────────────────────────────────────────

class _AccessRequestCard extends GetView<AccessRequestController> {
  final FlatNestTheme t;
  final AccessRequestModel request;

  const _AccessRequestCard({
    required this.t,
    required this.request,
  });

  Color get _statusColor {
    switch (request.status) {
      case 'accepted':
        return t.success;
      case 'rejected':
        return t.error;
      default:
        return t.warning;
    }
  }

  Color get _statusBg {
    switch (request.status) {
      case 'accepted':
        return t.successSoft;
      case 'rejected':
        return t.errorSoft;
      default:
        return t.warningSoft;
    }
  }

  String get _statusLabel {
    switch (request.status) {
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final requester = request.requester;
    final listing = request.listing;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: t.primarySoft,
                ),
                child: Center(
                  child: Text(
                    requester?.initials ?? '?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: t.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name + listing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requester?.name ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: t.ink,
                      ),
                    ),
                    if (listing != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        listing.title,
                        style: TextStyle(fontSize: 12, color: t.inkMid),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          // Accept / Reject buttons — only for pending requests
          if (request.status == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.reject(request),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: t.error,
                      side: BorderSide(color: t.error),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Reject',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.accept(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Accept',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final FlatNestTheme t;
  const _EmptyState({required this.t});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.contacts_outlined, size: 52, color: t.borderSoft),
          const SizedBox(height: 16),
          Text(
            'No requests yet',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: t.ink),
          ),
          const SizedBox(height: 6),
          Text(
            'Requests from renters will appear here.',
            style: TextStyle(fontSize: 13, color: t.inkSoft),
          ),
        ],
      ),
    );
  }
}

// ── Loading shimmer ───────────────────────────────────────────────────────────

class _LoadingShimmer extends StatelessWidget {
  final FlatNestTheme t;
  const _LoadingShimmer({required this.t});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: t.borderSoft,
      highlightColor: t.surface,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, __) => Container(
          height: 88,
          decoration: BoxDecoration(
            color: t.borderSoft,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
