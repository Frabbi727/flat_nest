import '../../listing/model/listing_model.dart';

class OwnerListingsPage {
  final List<OwnerListingModel> listings;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const OwnerListingsPage({
    required this.listings,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;
}
