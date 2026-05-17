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
  final String? availableFrom;
  final int? floorNo;
  final int? facingId;

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
    this.availableFrom,
    this.floorNo,
    this.facingId,
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
    if (availableFrom != null) map['available_from'] = availableFrom;
    if (floorNo != null) map['floor_no'] = floorNo;
    if (facingId != null) map['facing_id'] = facingId;
    return map;
  }
}
