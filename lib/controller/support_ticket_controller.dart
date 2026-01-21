import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/SupportTicketModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../AppConfig/language/app_localizations.dart';

class SupportTicketController extends GetxController {
  var isLoading = false.obs;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  var supportTickets = SupportTicketModel().obs;

  var ticketCategories = TicketCategories().obs;
  var ticketPriorities = TicketPriorities().obs;

  var selectedTicketCategory = TicketCategory().obs;

  var selectedTicketPriority = TicketPriority().obs;

  Future getSupportTickets() async {
    try {
      isLoading(true);
      String token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.TICKET_LIST + '?lang=${AppLocalizations.getLanguageCode()}');
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      supportTickets.value =
          supportTicketModelFromJson(response.body.toString());
      await getTicketCategories().then((value) async {
        await getTicketPriorities();
      });
    } catch (e,tr) {
      isLoading(false);
      print(e);
      print(tr);
    } finally {
      isLoading(false);
    }
  }

  Future getTicketCategories() async {
    try {
      String token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.TICKET_CATEGORIES+'?lang=${AppLocalizations.getLanguageCode()}');
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      ticketCategories.value =
          ticketCategoriesFromJson(response.body.toString());
      selectedTicketCategory.value = ticketCategories.value.categories!.first;
    } catch (e,tr) {
      print(e);
      print(tr);

    } finally {}
  }

  Future getTicketPriorities() async {
    try {
      String token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.TICKET_PRIORITIES+'?lang=${AppLocalizations.getLanguageCode()}');
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      ticketPriorities.value =
          ticketPrioritiesFromJson(response.body.toString());
      selectedTicketPriority.value = ticketPriorities.value.priorities!.first;
    } catch (e,tr) {
      print(e);
      print(tr);

    } finally {}
  }

  @override
  void onInit() {
    getSupportTickets();
    super.onInit();
  }
}
