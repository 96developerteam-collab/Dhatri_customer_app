import '../../../utils/app_utilities.dart';
import 'FilterAttributeValue.dart';

class FilterAttributeElement {
  FilterAttributeElement({
    this.id,
    this.name,
    this.displayType,
    this.description,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.values,
  });

  dynamic id;
  String? name;
  String? displayType;
  dynamic description;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<FilterAttributeValue>? values;

  factory FilterAttributeElement.fromJson(Map<String, dynamic> json){

    String name;
    try{
      name = json["name"];
    }catch(e){
      name = json["name"]['en'];
    }
    return FilterAttributeElement(
      id: json["id"],
     // name: json["name"],
      name: name,
      displayType: json["display_type"],
      description: json["description"],
      status: json["status"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: AppUtilities.convertToDateTime(dateTime:json["created_at"]),
      updatedAt:AppUtilities.convertToDateTime(dateTime:json["updated_at"]),
      values: List<FilterAttributeValue>.from(
          json["values"].map((x) => FilterAttributeValue.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "display_type": displayType,
        "description": description,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "values": List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}
