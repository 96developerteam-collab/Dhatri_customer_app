
import 'AttributeColor.dart';

class AttributeValue {
  AttributeValue({
    this.id,
    this.value,
    this.attributeId,
    this.createdAt,
    this.updatedAt,
    this.color,
    this.name
  });

  int? id;
  String? value;
  int? attributeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  AttributeColor? color;
  String? name;

  factory AttributeValue.fromJson(Map<String, dynamic> json){

    return AttributeValue(
      id: json["id"],
      value: json["value"],
      attributeId: int.tryParse("${json["attribute_id"]}"),
      name : json["name"],
      color: json["color"] != null && (json["color"] is Map)
          ? AttributeColor.fromJson(json["color"])
          : null,

    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "attribute_id": attributeId,
        // "created_at": createdAt?.toIso8601String(),
        // "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "color": color == null ? null : color?.toJson(),
        "name" : name
      };
}
