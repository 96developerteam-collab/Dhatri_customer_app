import 'package:amazcart/model/NewModel/Product/AllProducts.dart';

class BrandData {
  BrandData({
    this.id,
    this.name,
    this.logo,
    this.description,
    this.link,
    this.status,
    this.featured,
    this.metaTitle,
    this.metaDescription,
    this.sortId,
    this.totalSale,
    this.avgRating,
    this.slug,
    this.allProducts,
  });

  int? id;
  String? name;
  String? logo;
  String? description;
  dynamic link;
  int? status;
  int? featured;
  String? metaTitle;
  String? metaDescription;
  dynamic sortId;
  int? totalSale;
  int ?avgRating;
  String? slug;
  AllProducts? allProducts;

  factory BrandData.fromJson(Map<String, dynamic> json){

    String? name = '';
    try{
      name = json["name"];
    }catch(e){
      name = json["name"]['en'];
    }
    String? description;
    try{
      description = json["description"];
    }catch(e){
      description = json["description"]['en'];
    }


    String? metaTitle = '';
    try{
      description = json["meta_title"];
    }catch(e){
      description = json["meta_title"]['en'];
    }

    String? metaDescription = '';
    try{
      description = json["meta_description"];
    }catch(e){
      description = json["meta_description"]['en'];
    }

    return BrandData(
      id: json["id"],
      //name: json["name"],
      name: name,
      logo: json["logo"] == null ? null : json["logo"],
      //description: json["description"] == null ? null : json["description"],
      description: description,
      link: json["link"],
      status: json["status"],
      featured: json["featured"],
     // metaTitle: json["meta_title"] == null ? null : json["meta_title"],
      metaTitle: metaTitle == null ? null : metaTitle,
     // metaDescription: json["meta_description"] == null ? null : json["meta_description"],
      metaDescription: metaDescription == null ? null : metaDescription,
      sortId: json["sort_id"],
      totalSale: json["total_sale"],
      avgRating: json["avg_rating"],
      slug: json["slug"],
      allProducts: json["AllProducts"] == null
          ? null
          : AllProducts.fromJson({"data" : json["AllProducts"]}),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo == null ? null : logo,
        "description": description == null ? null : description,
        "link": link,
        "status": status,
        "featured": featured,
        "meta_title": metaTitle == null ? null : metaTitle,
        "meta_description": metaDescription == null ? null : metaDescription,
        "sort_id": sortId,
        "total_sale": totalSale,
        "avg_rating": avgRating,
        "slug": slug,
        "AllProducts": allProducts == null ? null : allProducts?.toJson(),
      };
}
