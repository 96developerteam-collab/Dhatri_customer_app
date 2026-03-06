class MerchantModel {
  List<Merchant>? merchants;
  String? message;

  MerchantModel({this.merchants, this.message});

  MerchantModel.fromJson(Map<String, dynamic> json) {
    if (json['merchants'] != null) {
      merchants = <Merchant>[];
      json['merchants'].forEach((v) {
        merchants!.add(new Merchant.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.merchants != null) {
      data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Merchant {
  SellerAccount? sellerAccount;
  SellerWarehouseAddress? sellerWarehouseAddress;

  Merchant({this.sellerAccount, this.sellerWarehouseAddress});

  Merchant.fromJson(Map<String, dynamic> json) {
    sellerAccount = json['seller_account'] != null
        ? new SellerAccount.fromJson(json['seller_account'])
        : null;
    sellerWarehouseAddress = json['seller_warehouse_address'] != null
        ? new SellerWarehouseAddress.fromJson(json['seller_warehouse_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sellerAccount != null) {
      data['seller_account'] = this.sellerAccount!.toJson();
    }
    if (this.sellerWarehouseAddress != null) {
      data['seller_warehouse_address'] = this.sellerWarehouseAddress!.toJson();
    }
    return data;
  }
}

class SellerAccount {
  int? id;
  int? userId;
  int? sellerCommissionId;
  int? commissionRate;
  String? sellerId;
  String? banner;
  String? subscriptionType;
  String? sellerPhone;
  String? sellerShopDisplayName;
  int? holidayMode;
  String? holidayType;
  String? holidayDate;
  String? holidayDateStart;
  String? holidayDateEnd;
  int? isTrusted;
  int? totalSaleQty;
  String? aboutSeller;
  String? createdAt;
  String? updatedAt;

  SellerAccount(
      {this.id,
      this.userId,
      this.sellerCommissionId,
      this.commissionRate,
      this.sellerId,
      this.banner,
      this.subscriptionType,
      this.sellerPhone,
      this.sellerShopDisplayName,
      this.holidayMode,
      this.holidayType,
      this.holidayDate,
      this.holidayDateStart,
      this.holidayDateEnd,
      this.isTrusted,
      this.totalSaleQty,
      this.aboutSeller,
      this.createdAt,
      this.updatedAt});

  SellerAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    sellerCommissionId = json['seller_commission_id'];
    commissionRate = json['commission_rate'];
    sellerId = json['seller_id'];
    banner = json['banner'];
    subscriptionType = json['subscription_type'];
    sellerPhone = json['seller_phone'];
    sellerShopDisplayName = json['seller_shop_display_name'];
    holidayMode = json['holiday_mode'];
    holidayType = json['holiday_type'];
    holidayDate = json['holiday_date'];
    holidayDateStart = json['holiday_date_start'];
    holidayDateEnd = json['holiday_date_end'];
    isTrusted = json['is_trusted'];
    totalSaleQty = json['total_sale_qty'];
    aboutSeller = json['about_seller'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['seller_commission_id'] = this.sellerCommissionId;
    data['commission_rate'] = this.commissionRate;
    data['seller_id'] = this.sellerId;
    data['banner'] = this.banner;
    data['subscription_type'] = this.subscriptionType;
    data['seller_phone'] = this.sellerPhone;
    data['seller_shop_display_name'] = this.sellerShopDisplayName;
    data['holiday_mode'] = this.holidayMode;
    data['holiday_type'] = this.holidayType;
    data['holiday_date'] = this.holidayDate;
    data['holiday_date_start'] = this.holidayDateStart;
    data['holiday_date_end'] = this.holidayDateEnd;
    data['is_trusted'] = this.isTrusted;
    data['total_sale_qty'] = this.totalSaleQty;
    data['about_seller'] = this.aboutSeller;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SellerWarehouseAddress {
  int? id;
  int? userId;
  String? warehouseName;
  String? warehouseAddress;
  String? warehousePhone;
  String? warehouseCountry;
  String? warehouseState;
  String? warehouseCity;
  String? warehousePostcode;
  String? createdAt;
  String? updatedAt;

  SellerWarehouseAddress(
      {this.id,
      this.userId,
      this.warehouseName,
      this.warehouseAddress,
      this.warehousePhone,
      this.warehouseCountry,
      this.warehouseState,
      this.warehouseCity,
      this.warehousePostcode,
      this.createdAt,
      this.updatedAt});

  SellerWarehouseAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    warehouseName = json['warehouse_name'];
    warehouseAddress = json['warehouse_address'];
    warehousePhone = json['warehouse_phone'];
    warehouseCountry = json['warehouse_country'].toString();
    warehouseState = json['warehouse_state'].toString();
    warehouseCity = json['warehouse_city'].toString();
    warehousePostcode = json['warehouse_postcode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['warehouse_name'] = this.warehouseName;
    data['warehouse_address'] = this.warehouseAddress;
    data['warehouse_phone'] = this.warehousePhone;
    data['warehouse_country'] = this.warehouseCountry;
    data['warehouse_state'] = this.warehouseState;
    data['warehouse_city'] = this.warehouseCity;
    data['warehouse_postcode'] = this.warehousePostcode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
