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
  final String? availableFrom;
  final int? floorNo;
  final int? facingId;
  final String? road;
  final String? houseName;
  final String? block;
  final String? section;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerAltPhone;
  final String? ownerEmail;
  final String? preferredContact;

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
    this.availableFrom,
    this.floorNo,
    this.facingId,
    this.road,
    this.houseName,
    this.block,
    this.section,
    this.ownerName,
    this.ownerPhone,
    this.ownerAltPhone,
    this.ownerEmail,
    this.preferredContact,
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
    if (availableFrom != null) map['available_from'] = availableFrom;
    if (floorNo != null) map['floor_no'] = floorNo;
    if (facingId != null) map['facing_id'] = facingId;
    if (road != null) map['road'] = road;
    if (houseName != null) map['house_name'] = houseName;
    if (block != null) map['block'] = block;
    if (section != null) map['section'] = section;
    if (ownerName != null) map['owner_name'] = ownerName;
    if (ownerPhone != null) map['owner_phone'] = ownerPhone;
    if (ownerAltPhone != null) map['owner_alt_phone'] = ownerAltPhone;
    if (ownerEmail != null) map['owner_email'] = ownerEmail;
    if (preferredContact != null) map['preferred_contact'] = preferredContact;
    return map;
  }
}
