class EditListingRequest {
  final String? title;
  final int? listingTypeId;
  final int? price;
  final int? beds;
  final int? baths;
  final int? deposit;
  final int? size;
  final String? description;
  final List<int>? amenities;

  const EditListingRequest({
    this.title,
    this.listingTypeId,
    this.price,
    this.beds,
    this.baths,
    this.deposit,
    this.size,
    this.description,
    this.amenities,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (title != null) map['title'] = title;
    if (listingTypeId != null) map['listing_type_id'] = listingTypeId;
    if (price != null) map['price'] = price;
    if (beds != null) map['beds'] = beds;
    if (baths != null) map['baths'] = baths;
    if (deposit != null) map['deposit'] = deposit;
    if (size != null) map['size'] = size;
    if (description != null) map['description'] = description;
    if (amenities != null) map['amenities'] = amenities;
    return map;
  }
}
