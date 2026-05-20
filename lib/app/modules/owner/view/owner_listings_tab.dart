part of 'owner_home_view.dart';

// ── My Listings tab ───────────────────────────────────────────────────────────

class _MyListingsTab extends GetView<OwnerController> {
  final FlatNestTheme t;
  const _MyListingsTab({required this.t});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.bg,
        elevation: 0,
        title: Text('My Listings', style: TextStyle(color: t.ink, fontWeight: FontWeight.w700, fontSize: 20)),
        actions: [
          IconButton(
            onPressed: controller.goToCreateListing,
            icon: Icon(Icons.add, color: t.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return Center(child: CircularProgressIndicator(color: t.primary));
              }
              if (controller.myListings.isEmpty) {
                return _buildEmptyState();
              }
              return _buildList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home_work_outlined, size: 64, color: t.inkFaint),
          const SizedBox(height: 16),
          Text('No listings yet', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.ink)),
          const SizedBox(height: 8),
          Text('Post your first flat to get started.', style: TextStyle(fontSize: 13, color: t.inkMid)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.goToCreateListing,
            style: ElevatedButton.styleFrom(
              backgroundColor: t.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Post a flat'),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification && notification.metrics.extentAfter < 200) {
          controller.loadMoreListings();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        itemCount: controller.myListings.length + 1,
        itemBuilder: (_, i) {
          if (i == controller.myListings.length) {
            return Obx(() => controller.isLoadingMore.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator(color: t.primary)),
                  )
                : const SizedBox.shrink());
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ListingRow(t: t, listing: controller.myListings[i]),
          );
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: t.surface,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Obx(() {
        final currentStatus = controller.filterStatus.value;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _statusChip('All', null, currentStatus == null),
              const SizedBox(width: 6),
              _statusChip('Active', 'active', currentStatus == 'active'),
              const SizedBox(width: 6),
              _statusChip('Pending', 'pending', currentStatus == 'pending'),
              const SizedBox(width: 6),
              _statusChip('Draft', 'draft', currentStatus == 'draft'),
              const SizedBox(width: 6),
              _statusChip('Rejected', 'rejected', currentStatus == 'rejected'),
              const SizedBox(width: 6),
              _statusChip('Rented', 'rented', currentStatus == 'rented'),
            ],
          ),
        );
      }),
    );
  }

  Widget _statusChip(String label, String? status, bool active) {
    return GestureDetector(
      onTap: () => controller.applyOwnerFilters(status: status, typeId: controller.filterTypeId.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? t.primary : t.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? t.primary : t.borderSoft),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : t.inkMid),
        ),
      ),
    );
  }
}
