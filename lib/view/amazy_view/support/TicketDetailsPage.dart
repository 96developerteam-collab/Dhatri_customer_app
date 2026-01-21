import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/model/SupportTicketModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazcart_widget/CustomDate.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazy_widget/snackbars.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as DIO;

import '../../../config/config.dart';
import '../../../widgets/amazcart_widget/dio_exception.dart';
import '../../../widgets/amazy_widget/AppBarWidget.dart';

class TicketDetailsPage extends StatefulWidget {
  final String ticketId;
  final int id;

  TicketDetailsPage({required this.ticketId, required this.id});

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  bool ticketProcessing = false;

  GetStorage userToken = GetStorage();
  var tokenKey = 'token';

  final _formKey = GlobalKey<FormState>();

  Future<TicketData>? ticket;

  Future<TicketData> getTicketDetails() async {
    var jsonString;
    try {
      String token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.TICKET_SHOW + '/${widget.ticketId}');
      print(userData);
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        jsonString = jsonDecode(response.body);
        print('ticket data $jsonString');
      }


      log("Response :::: ${jsonString['ticket']}");

      return TicketData.fromJson(jsonString['ticket']);

    } catch (e,tr) {
      log(e.toString());
      log(tr.toString());
      return TicketData();
    }
  }

  File? file;

  List<File> files = [];

  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();

  final TextEditingController replyCtrl = TextEditingController();

  void pickTicketFile() async {
    if (AppConfig.isDemo) {
      SnackBars().snackBarWarning("Disabled for demo".tr);
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
      );

      if (result != null) {
        setState(() {
          files = result.paths.map((path) => File(path!)).toList();
        });
      } else {
        SnackBars().snackBarWarning('Cancelled'.tr);
      }
    }
  }

  String result = '';

  Future replyTicket() async {
    if (_formKey.currentState?.validate()??false) {
      try {
        setState(() {
          ticketProcessing = true;
        });

        String token = await userToken.read(tokenKey);

        final formData = DIO.FormData.fromMap({
          'text': replyCtrl.text,
          'ticket_id': widget.id,
        });

        if (files.length > 0) {
          for (var file in files) {
            formData.files.addAll([
              MapEntry(
                  "ticket_file[]", await DIO.MultipartFile.fromFile(file.path)),
            ]);
          }
        }
        print("ticket formData ::: ${formData.fields}");
        print("ticket formData files::: ${formData.files}");
        // return;

        response = await dio.post(
          URLs.TICKET_REPLY,
          data: formData,
          options: DIO.Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          onSendProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + '%');
            }
          },
        ).catchError((e) {
          print("EEEE $e");
          final errorMessage = DioExceptions.fromDioError(e).toString();
          print("ERROR MSG : $errorMessage");
          if (errorMessage == "401") {
            SnackBars().snackBarWarning('Unauthorized'.tr);
            Get.back();
          }
          setState(() {
            ticketProcessing = false;
          });
        });
        setState(() {
          ticketProcessing = false;
        });
        if (response?.statusCode == 201) {
          replyCtrl.clear();
          SnackBars().snackBarSuccess('${response?.data['msg']}');
          ticket = getTicketDetails();
        } else {
          if (response?.statusCode == 401) {
            SnackBars()
                .snackBarWarning("${"Invalid Access token".tr}. ${"Please re-login".tr}");
          } else {
            SnackBars().snackBarError(response?.data);
            return false;
          }
        }
      } catch (e) {
        print('ERROR  $e');
      }
    }
  }

  @override
  void initState() {
    setState(() {
      ticket = getTicketDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar:AppBarWidget(title: 'Details'.tr + "- ${widget.ticketId}",showCart: false,),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<TicketData>(
                future: ticket,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occured',
                          style: TextStyle(fontSize: 18),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      TicketData ticketData = snapshot.data ?? TicketData();
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Form(
                              child: ListView(
                                children: [
                                  // TicketDataWidget(
                                  //   ticketData: ticketData,
                                  // ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppStyles.appBackgroundColor,
                                      borderRadius: BorderRadius.circular(
                                        15.r,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.w,
                                    ),
                                    child: Html(
                                      data: '''${ticketData.description}''',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: ticketData.messages?.length ?? 0,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 10.h,
                                        );
                                      },
                                      itemBuilder: (context, index) {


                                        log("ticketData.messages :::: ${ticketData.messages?[index].text}");
                                        return Container(
                                          margin: EdgeInsets.only(
                                            right: ticketData
                                                .messages?[index].type ==
                                                1
                                                ? 25
                                                : 0,
                                            left: ticketData
                                                .messages?[index].type ==
                                                0
                                                ? 25
                                                : 0,
                                          ),
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: ticketData
                                                .messages?[index].type ==
                                                1
                                                ? AppStyles.lightPinkColor
                                                : AppStyles.appBackgroundColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: ticketData
                                                  .messages?[index]
                                                  .type ==
                                                  0
                                                  ? Radius.circular(15)
                                                  : Radius.circular(0),
                                              bottomRight: ticketData
                                                  .messages?[index]
                                                  .type ==
                                                  0
                                                  ? Radius.circular(0)
                                                  : Radius.circular(15.w),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: ticketData
                                                .messages?[index].type ==
                                                1
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              ticketData.messages?[index].type ==
                                                  1
                                                  ? CircleAvatar(
                                                radius: 12.0.r,
                                                backgroundImage: ticketData
                                                    .messages?[
                                                index]
                                                    .user
                                                    ?.avatar !=
                                                    null
                                                    ? NetworkImage(
                                                    "${AppConfig.assetPath}/${ticketData.messages?[index].user?.avatar}")
                                                    : NetworkImage(
                                                    '${AppConfig.hostUrl}/public/backend/img/avatar.png'),
                                                backgroundColor:
                                                Colors.transparent,
                                              )
                                                  : SizedBox.shrink(),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: ticketData
                                                      .messages?[index]
                                                      .type ==
                                                      1
                                                      ? CrossAxisAlignment.start
                                                      : CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${ticketData.messages?[index].user?.firstName} ${ticketData.messages?[index].user?.lastName ?? ""}',
                                                      style: AppStyles
                                                          .kFontBlack12w4,
                                                    ),
                                                    Text(
                                                      '${CustomDate().formattedDateTime(ticketData.messages?[index].createdAt)}',
                                                      style: AppStyles
                                                          .kFontBlack12w4,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),

                                                    Text(
                                                      ticketData.messages?[index].text??'',
                                                      style: AppStyles
                                                          .kFontBlack12w4,
                                                    ),

                                                    // Html(
                                                    //   data:
                                                    //   '${ticketData.messages?[index].text}',
                                                    //   style: {
                                                    //     "p": Style(
                                                    //       textAlign: ticketData
                                                    //           .messages?[
                                                    //       index]
                                                    //           .type ==
                                                    //           1
                                                    //           ? TextAlign.left
                                                    //           : TextAlign.right,
                                                    //       fontSize: FontSize(13.fontSize)
                                                    //     ),
                                                    //   },
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              ticketData.messages?[index].type ==
                                                  0
                                                  ? CircleAvatar(
                                                radius: 12.0.r,
                                                backgroundImage: NetworkImage("${AppConfig.assetPath}/${ticketData.messages?[index].user?.avatar}"),
                                                backgroundColor:
                                                Colors.transparent,
                                              )
                                                  : Container(),
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: CustomLoadingWidget(),
                  );
                }),
          ),
          Form(
            key: _formKey,
            child: Container(
              height: 70.h,
              child: Row(
                children: [
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.attach_file_rounded,
                        color: AppStyles.greyColorDark,
                        size: 20.w,
                      ),
                      onPressed: ()=> pickTicketFile(),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      maxLines: 15,
                      minLines: 1,
                      autofocus: false,
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      controller: replyCtrl,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        hintText: 'Type a message here'.tr,
                        fillColor: AppStyles.appBackgroundColor,
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        hintStyle: AppStyles.kFontGrey12w5,
                      ),
                      style: AppStyles.kFontBlack12w4,
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: AppStyles.greyColorDark,
                        size: 20.w,
                      ),
                      onPressed: () async {
                        print('send');
                        await replyTicket();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

