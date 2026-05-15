class CreateListingRequest {
  final String title;
  final int listingTypeId;
  final int price;
  final int beds;
  final int baths;
  final int? deposit;
  final int? size;
  final String? description;
  final List<int>? amenities;

  const CreateListingRequest({
    required this.title,
    required this.listingTypeId,
    required this.price,
    required this.beds,
    required this.baths,
    this.deposit,
    this.size,
    this.description,
    this.amenities,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'listing_type_id': listingTypeId,
      'price': price,
      'beds': beds,
      'baths': baths,
    };
    if (deposit != null) map['deposit'] = deposit;
    if (size != null) map['size'] = size;
    if (description != null) map['description'] = description;
    if (amenities != null) map['amenities'] = amenities;
    return map;
  }
}
