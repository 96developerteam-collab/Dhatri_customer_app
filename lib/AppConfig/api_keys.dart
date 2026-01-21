import 'package:flutter_paystack_max/flutter_paystack_max.dart';

final String customServerUrl = 'https://us-central1-amazcart-341610.cloudfunctions.net/expressApp';

///
//**PAYPAL
///
final String paypalDomain =
    "https://api.sandbox.paypal.com"; // "https://api.paypal.com"; // for production mode
final String paypalCurrency = 'USD';
final String paypalClientId =
    'AQgAWV4PlM9g81xZ51TLtVi68KjB89s4mpcchFschs7OvTM-3p4zsQTDqHOkv5Sw44k9goHlE-VAC7zj';
final String paypalClientSecret =
    'ELLoQfnZ4kRbDkul81U_RNRsgHgFPDumlUloCcX6nO6ziXRXKob8gVYaTn6CGCeNVJtBqsfv7VtbsuR2';

///
//**RAZORPAY
///
//**:: Change Razor Pay API Key and API Secret for Razor Pay Payment
final String razorPayKey = 'rzp_live_wcVU6c931D74Eg';
final String razorPaySecret = 'GH2sBrvMsP3S26saB69txmTF';
//**:: Change Company Name to show on Payment pages
final String companyName = "Amazcart";

///
/// Stripe
///
final String stripeServerURL = '$customServerUrl';
final String stripeCurrency = "usd";
final String stripeMerchantID = "test";
final String stripePublishableKey =
    "pk_test_51HZCbrCS6voXGqa21OJlHLqphfL37gbgfJuWEBubUxHBvKW7jSEE25VRjkREtyUrNC4UcmmENlhrA3XAqzyhlROK00dzdbKmcF";
final String stripeSecrateKey =
    "sk_test_51HZCbrCS6voXGqa22SbUi7vJq3IzP9KLJtBRSXpINq2aJm81fHe1FJSKh29Jkchyjw0zu5FMFUecRzk2piCnDLIr00iaCPOR7G";

///
/// Jazzcash
///
final String jazzCashMerchantId = "MC21703";
final String jazzCashPassword = "33183usuyg";
final String jazzCashReturnUrl =
    "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
final String jazzCashIntegritySalt = "129yw891tx";

///
/// InstaMojo
///
final String instaMojoApiUrl = 'https://test.instamojo.com/api/1.1';
final String instaMojoApiKey = 'test_653cb00cbfc37b41dc7fad3bf92';
final String instaMojoAuthToken = 'test_ba9959aa2b6a5be5cb7e0d36a17';

///
/// Midtrans
///
final String midTransServerUrl = '$customServerUrl';

///
/// PayTM
///
final bool payTmIsTesting = true;
final String initiatePayTmTransaction =
    "$customServerUrl/initiatePayTmTransaction";
final String payTMmid = "mmHPCS25768835616700";

///
/// FLUTTERWAVE
///
final String flutterWaveEncryptionKey = 'FLWSECK_TEST4368b34a6870';
final String flutterWavePublicKey =
    'FLWPUBK_TEST-17a05b44892382781970dbab2c3f1750-X';

///
/// Paystack
///
final String payStackPublicKey = "sk_test_ee55a9b27d06843d868851a81362018d1aa9ff90";
final PaystackCurrency payStackCurrency = PaystackCurrency.zar;
final String payStackSecretKey = "sk_test_ee55a9b27d06843d868851a81362018d1aa9ff90";


///Revenue-cat API key for ios in-app purchase
const revenueCatApiKey = 'appl_eBNdocCrYbaVlyhXSpprQYyWBEN';