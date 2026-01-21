// To parse this JSON data, do
//
//     final notificationSettingsModel = notificationSettingsModelFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/utils/app_utilities.dart';

NotificationSettingsModel notificationSettingsModelFromJson(String str) =>
    NotificationSettingsModel.fromJson(json.decode(str));

String notificationSettingsModelToJson(NotificationSettingsModel data) =>
    json.encode(data.toJson());

class NotificationSettingsModel {
  NotificationSettingsModel({
    this.notifications,
    this.msg,
  });

  List<NotificationData>? notifications;
  String? msg;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json){

    try {
      return NotificationSettingsModel(
        notifications: List<NotificationData>.from(
            json["notifications"].map((x) => NotificationData.fromJson(x))),
        msg: json["msg"],
      );
    }catch(e,tr){
       log("Error -> $e");
       log("Track -> $tr");
      return NotificationSettingsModel();
    }
  }


  Map<String, dynamic> toJson() => {
        "notifications":
            List<dynamic>.from(notifications!.map((x) => x.toJson())),
        "msg": msg,
      };
}

class NotificationData {
  NotificationData({
    this.id,
    this.userId,
    this.notificationSettingId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.notificationSetting,
  });

  int? id;
  int? userId;
  int? notificationSettingId;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  NotificationSetting? notificationSetting;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: AppUtilities.convertToInt(item: json["id"]),
        userId: AppUtilities.convertToInt(item: json["user_id"]),
        notificationSettingId: AppUtilities.convertToInt(item: json["notification_setting_id"]),
        type: json["type"],
        createdAt: AppUtilities.convertToDateTime(dateTime:json["created_at"]),
        updatedAt:AppUtilities.convertToDateTime(dateTime:json["updated_at"]),
        notificationSetting: NotificationSetting.fromJson(json["notification_setting"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "notification_setting_id": notificationSettingId,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "notification_setting": notificationSetting?.toJson(),
      };
}

class NotificationSetting {
  NotificationSetting({
    this.id,
    this.event,
    this.deliveryProcessId,
    this.type,
    this.message,
    this.userAccessStatus,
    this.sellerAccessStatus,
    this.adminAccessStatus,
    this.staffAccessStatus,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? event;
  int? deliveryProcessId;
  String? type;
  String? message;
  int? userAccessStatus;
  int? sellerAccessStatus;
  int? adminAccessStatus;
  int? staffAccessStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) =>
      NotificationSetting(
        id: AppUtilities.convertToInt(item: json["id"]),
        event: json["event"],
        deliveryProcessId: AppUtilities.convertToInt(item: json["delivery_process_id"]),
        type: json["type"],
        message: json["message"],
        userAccessStatus: AppUtilities.convertToInt(item: json["user_access_status"]),
        sellerAccessStatus: AppUtilities.convertToInt(item: json["seller_access_status"]),
        adminAccessStatus: AppUtilities.convertToInt(item: json["admin_access_status"]),
        staffAccessStatus: AppUtilities.convertToInt(item: json["staff_access_status"]),
        createdAt: AppUtilities.convertToDateTime(dateTime:json["created_at"]),
        updatedAt:AppUtilities.convertToDateTime(dateTime:json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event": event,
        "delivery_process_id":
            deliveryProcessId == null ? null : deliveryProcessId,
        "type": type,
        "message": message,
        "user_access_status": userAccessStatus,
        "seller_access_status": sellerAccessStatus,
        "admin_access_status": adminAccessStatus,
        "staff_access_status": staffAccessStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
