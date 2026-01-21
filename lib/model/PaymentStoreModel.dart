// To parse this JSON data, do
//
//     final paymentStore = paymentStoreFromJson(jsonString);

import 'dart:convert';

import '../utils/app_utilities.dart';

PaymentStore paymentStoreFromJson(String str) =>
    PaymentStore.fromJson(json.decode(str));

String paymentStoreToJson(PaymentStore data) => json.encode(data.toJson());

class PaymentStore {
  PaymentStore({
    this.paymentInfo,
    this.message,
  });

  PaymentInfo? paymentInfo;
  String? message;

  factory PaymentStore.fromJson(Map<String, dynamic> json) => PaymentStore(
        paymentInfo: PaymentInfo.fromJson(json["payment_info"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "payment_info": paymentInfo?.toJson(),
        "message": message,
      };
}

class PaymentInfo {
  PaymentInfo({
    this.userId,
    this.amount,
    this.paymentMethod,
    this.txnId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  int? userId;
  dynamic amount;
  dynamic paymentMethod;
  String? txnId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        userId: json["user_id"],
        amount: json["amount"],
        paymentMethod: json["payment_method"],
        txnId: json["txn_id"],
    createdAt: AppUtilities.convertToDateTime(dateTime:json["created_at"]),
    updatedAt:AppUtilities.convertToDateTime(dateTime:json["updated_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "amount": amount,
        "payment_method": paymentMethod,
        "txn_id": txnId,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
