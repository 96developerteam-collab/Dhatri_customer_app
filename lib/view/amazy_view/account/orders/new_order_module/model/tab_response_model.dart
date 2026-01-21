class TabResponseModel {
  List<TabData>? data;

  TabResponseModel({this.data});

  TabResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TabData>[];
      json['data'].forEach((v) {
        data!.add(new TabData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TabData {
  int? id;
  String? name;

  TabData({this.id, this.name});

  TabData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
