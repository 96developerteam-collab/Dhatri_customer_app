import 'dart:developer';

import '../../../utils/app_utilities.dart';

class AttributeColor {
  AttributeColor({
    this.id,
    this.attributeValueId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? attributeValueId;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AttributeColor.fromJson(Map<String, dynamic> json){
    return AttributeColor(
      id: json["id"],
      attributeValueId: int.tryParse("${json["attribute_value_id"]}"),
      name: json["name"],
      createdAt: AppUtilities.convertToDateTime(dateTime:json["created_at"]),
      updatedAt:AppUtilities.convertToDateTime(dateTime:json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "attribute_value_id": attributeValueId,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
