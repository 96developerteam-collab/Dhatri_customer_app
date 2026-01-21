import 'dart:convert';

class LocalizationLanguageResponseModel {
  LocalizationUIModel? localizationUIModel;
  bool? success;

  LocalizationLanguageResponseModel({this.localizationUIModel, this.success});

  LocalizationLanguageResponseModel.fromJson(Map<String, dynamic> json) {
    localizationUIModel = json['data'] != null
        ? new LocalizationUIModel.fromJson(json['data'])
        : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (localizationUIModel != null) {
      data['data'] = localizationUIModel!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class LocalizationUIModel {
  bool? rtl;
  String? code;
  String? native;
  LocalizationLangValue? localizationLangValue;
  String? message;

  LocalizationUIModel(
      {this.rtl,
      this.code,
      this.native,
      this.localizationLangValue,
      this.message});

  LocalizationUIModel.fromJson(Map<String, dynamic> json) {
    rtl = json['rtl'];
    code = json['code'];
    native = json['native'];
    localizationLangValue = json['lang'] != null
        ? new LocalizationLangValue.fromJson(json['lang'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['rtl'] = this.rtl;
    data['code'] = this.code;
    data['native'] = this.native;
    if (localizationLangValue != null) {
      data['lang'] = localizationLangValue!.toJson();
    }
    data['message'] = this.message;
    return data;
  }

  @override
  String toString() => const JsonEncoder.withIndent(' ').convert(toJson());
}

class LocalizationLangValue {
  String? home;
  String? message;
  String? cart;
  String? account;
  String? changeLanguage;
  String? language;
  String? privacyPolicy;
  String? rateOurApp;
  String? settings;
  String? signInOrRegister;
  String? allOrders;
  String? myOrders;
  String? myServices;
  String? myCancellations;
  String? myReturns;
  String? myReview;
  String? messages;
  String? needHelp;
  String? policies;
  String? logout;
  String? searchIn;
  String? browseAllProducts;
  String? newUsersZone;
  String? oFF;
  String? off;
  String? freeShippingUpTo;
  String? shopNow;
  String? sold;
  String? brands;
  String? discount;
  String? topPicks;
  String? youMightLike;
  String? recommendedProducts;
  String? myGiftCards;
  String? sort;
  String? new1;
  String? old;
  String? nameAZ;
  String? nameZA;
  String? priceLowToHigh;
  String? priceHighToLow;
  String? buyGiftCard;
  String? giftCards;
  String? scratchToReveal;
  String? secretCodeCopiedToClipboard;
  String? redeem;
  String? myWishlist;
  String? noProductsFound;
  String? endOfResults;
  String? myCoupons;
  String? noCouponsFound;
  String? delete;
  String? details;
  String? validity;
  String? spend;
  String? getUpTo;
  String? get;
  String? addCoupon;
  String? couponCode;
  String? enterCouponCode;
  String? typeCouponCode;
  String? add;
  String? couponDetails;
  String? termsAndConditions;
  String? noOrdersPlacedYet;
  String? placedOn;
  String? soldBy;
  String? package;
  String? comments;
  String? total;
  String? color;
  String? returnRequest;
  String? selectProductsYouWantToReturn;
  String? storage;
  String? refundsAndDisputes;
  String? noRefundOrders;
  String? noCancelledRefundOrders;
  String? requestedOn;
  String? orderDetails;
  String? shipAndBillTo;
  String? billTo;
  String? shipTo;
  String? returnRefund;
  String? writeAReview;
  String? trackYourOrder;
  String? chatNow;
  String? subtotal;
  String? shipping;
  String? totalSaving;
  String? tAXAmount;
  String? totalVATTAXGST;
  String? totalGST;
  String? grandTotal;
  String? paidBy;
  String? trackingNumber;
  String? receiver;
  String? trackOrder;
  String? cancelledOrders;
  String? noCancelledOrders;
  String? changeReview;
  String? productQuality;
  String? anonymous;
  String? rateYourRider;
  String? waitingForReview;
  String? reviewHistory;
  String? allOrderReviewedThankYou;
  String? noReviewsFound;
  String? reviewDone;
  String? thanksForYourFeedback;
  String? invalidCredentials;
  String? unauthorized;
  String? somethingWentWrong;
  String? pleaseTryAgainThankYou;
  String? review;
  String? selectPickupAddress;
  String? pickupAddress;
  String? pickupMethod;
  String? courierPickUp;
  String? max6FilesAllowed;
  String? productReview;
  String? sellerService;
  String? writeYourComment;
  String? pleaseTypeSomething;
  String? selectAShipmentMethod;
  String? selectCourierPickUpInformation;
  String? selectDropOffInformation;
  String? iAccept;
  String? submitReview;
  String? pleaseAcceptTerms;
  String? pleaseAddRatings;
  String? shopOver2MillionProducts;
  String? atUnbeatablePrice;
  String? signIn;
  String? enterYourEmail;
  String? password;
  String? forgotPassword;
  String? donTHaveAnAccountYet;
  String? register;
  String? firstName;
  String? lastName;
  String? confirmPassword;
  String? passwordMustBeTheSame;
  String? referralCodeOptional;
  String? optional;
  String? addToCart;
  String? errorFetchingImage;
  String? quantity;
  String? canTAddLessThan;
  String? products;
  String? stockNotAvailable;
  String? chatUs;
  String? noMoreStock;
  String? myCart;
  String? clearCart;
  String? doYouWantToClearTheCart;
  String? cancel;
  String? confirm;
  String? cartIsEmpty;
  String? remove;
  String? doYouWantRemove;
  String? fromTheCart;
  String? checkOut;
  String? selectItemsToProceedToCheckout;
  String? shippingAddress;
  String? name;
  String? address;
  String? change;
  String? billToTheSameAddress;
  String? addAddress;
  String? shippingCost;
  String? additionalShipping;
  String? tax;
  String? taxAmount;
  String? qty;
  String? itemSTotal;
  String? totalTAX;
  String? itemSGrandTotal;
  String? enterCouponVoucherCode;
  String? apply;
  String? continue1;
  String? pleaseAddShippingAndBillingAddress;
  String? pleaseConfirmTheCheckout;
  String? selectGateway;
  String? vATIncludedWhereApplicable;
  String? orderConfirm;
  String? selectAPaymentMethodFirst;
  String? all;
  String? continueShopping;
  String? filter;
  String? allBrands;
  String? filterProducts;
  String? childCategory;
  String? rating;
  String? andUp;
  String? reset;
  String? applyFilter;
  String? priceRange;
  String? browseGiftCards;
  String? browseProducts;
  String? topPicksProducts;
  String? user;
  String? visitStore;
  String? store;
  String? variant;
  String? specifications;
  String? brand;
  String? modelNumber;
  String? none;
  String? brandModelSpecifications;
  String? delivery;
  String? highlights;
  String? category;
  String? tags;
  String? description;
  String? ratingsReviews;
  String? vIEWALL;
  String? recommendedBySeller;
  String? accountInformation;
  String? changeName;
  String? typeFirstName;
  String? typeLastName;
  String? save;
  String? mobileNumber;
  String? emailAddress;
  String? dateOfBirth;
  String? update;
  String? profileUpdatedSuccessfully;
  String? updateProfileDescription;
  String? pleaseEnterDescription;
  String? error;
  String? pleaseTypeEmailAddress;
  String? selectCountry;
  String? selectState;
  String? pleaseTypeAddress;
  String? postalZipCode;
  String? pleaseTypePostalZipCode;
  String? saveAddress;
  String? addressAddedSuccessfully;
  String? invalidAccessTokenPleaseReLogin;
  String? selectCity;
  String? noCityFound;
  String? myAddress;
  String? defaultBilling;
  String? setToDefaultBillingAddress;
  String? addressNotFound;
  String? setDefaultBilling;
  String? defaultShipping;
  String? setToDefaultShippingAddress;
  String? setDefaultShipping;
  String? edit;
  String? changePassword;
  String? currentPassword;
  String? typeYourCurrentPassword;
  String? thePasswordMustBeAtLeast8Characters;
  String? newPassword;
  String? typeYourNewPassword;
  String? reTypePassword;
  String? typePasswordAgain;
  String? thePasswordConfirmationDoesNotMatch;
  String? updatePassword;
  String? passwordUpdatedSuccessfully;
  String? editAddress;
  String? addressDeletedSuccessfully;
  String? deleteThisAddress;
  String? saveChange;
  String? addressUpdatedSuccessfully;
  String? termsConditions;
  String? addressBook;
  String? receiveExclusiveOffersPersonalUpdates;
  String? shopMore;
  String? categories;
  String? changeCurrency;
  String? selectCurrency;
  String? back;
  String? currencyChangedTo;
  String? currency;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? toPay;
  String? toShip;
  String? toReceive;
  String? pending;
  String? cancelled;
  String? completed;
  String? confirmed;
  String? paid;
  String? wallet;
  String? hello;
  String? homePage;
  String? allProducts;
  String? loggedOut;
  String? welcomeTo;
  String? notifications;
  String? notification;
  String? forgotPassword1;
  String? signUp;
  String? resetPassword;
  String? send;
  String? coupons;
  String? tAXGSTVATAmount;
  String? priceDropped;
  String? refundRequestedOn;
  String? refundDetails;
  String? requestSentDate;
  String? orderDate;
  String? refundMethod;
  String? shippingType;
  String? bankTransfer;
  String? pleaseTypeBranchName;
  String? accountHolderName;
  String? pleaseTypeAccountHolderName;
  String? branchName;
  String? pleaseTypeBankName;
  String? bankName;
  String? courierPickupInfo;
  String? dropOffInfo;
  String? shippingMethod;
  String? state;
  String? city;
  String? postcode;
  String? dropOffAddress;
  String? typeInDropOffAddress;
  String? pleaseTypeInYourCompleteBankAccountInformation;
  String? dropOff;
  String? selectDropOff;
  String? dealStartsIn;
  String? dealEndsIn;
  String? dealEnded;
  String? productSpecifications;
  String? availability;
  String? inStock;
  String? notInStock;
  String? productSKU;
  String? minimumOrderQuantity;
  String? maximumOrderQuantity;
  String? relatedProducts;
  String? upSalesProducts;
  String? crossSalesProducts;
  String? outOfStock;
  String? viewMore;
  String? showLess;
  String? share;
  String? search;
  String? calculatedAtNextStep;
  String? checkout;
  String? vATTAXGSTIncludedWhereApplicable;
  String? proceedToPayment;
  String? basedOnFlatRate;
  String? basedOnPerHundred;
  String? basedOnPer100Gm;
  String? totalGSTTAX;
  String? whatIsYourPhoneNumber;
  String? enterYourMobileNumber;
  String? pleaseEnterYourMobileNumber;
  String? weWillSendACodeToYourMobileNumber;
  String? enter6DigitVerificationCode;
  String? enterTheVerificationCodeWeHaveSentTo;
  String? oTPTimedOutPleaseResendOTP;
  String? oTPDoesNotMatch;
  String? resendOTP;
  String? youDonTHaveSufficientWalletBalance;
  String? pleaseTypeFirstName;
  String? pleaseTypeLastName;
  String? pleaseTypeEmail;
  String? pleaseTypePassword;
  String? pleaseTypeConfirmPassword;
  String? invalidEmail;
  String? subject;
  String? typeSubject;
  String? typeDescription;
  String? attachFiles;
  String? submit;
  String? accountNumber;
  String? pleaseTypeAccountNumber;
  String? refundTo;
  String? bySubmittingThisFormIAccept;
  String? returnPolicyOf;
  String? canTRemoveAnymore;
  String? pleaseSelectTheProductFirst;
  String? canTAddAnymore;
  String? selectAReasonForReturning;
  String? loading;
  String? country;
  String? cancelOrder;
  String? selectCancelReason;
  String? collectFrom;
  String? orderCancelled;
  String? openDispute;
  String? changeYourComment;
  String? writeReview;
  String? warning;
  String? updatedSuccessfully;
  String? resetPasswordLinkSent;
  String? pleaseTypeYourEmail;
  String? pleaseTypeYourPassword;
  String? donTHaveAnAccountYet1;
  String? orContinueWith;
  String? next;
  String? referralCode;
  String? sKU;
  String? emailDelivery;
  String? canTAddLessThan1;
  String? stockAvailable;
  String? homeDelivery;
  String? pickupLocation;
  String? selectAPickupPoint;
  String? billingAddress;
  String? itemS;
  String? collectFromPickupLocation;
  String? couponDiscount;
  String? grandTotal1;
  String? minimumShoppingAmount;
  String? withoutShippingCost;
  String? doYouWantToRemove;
  String? cartPriceUpdated;
  String? pleaseCheckPricesAndShippingAgain;
  String? oK;
  String? close;
  String? paypalPayment;
  String? stripePayment;
  String? createSession;
  String? openCheckoutPage;
  String? orderCreatedSuccessfully;
  String? orderCreateUnsuccessfully;
  String? tabbyCheckout;
  String? disabledForDemo;
  String? bankPayment;
  String? paymentProcessing;
  String? pleaseDonTCloseThisUntilPaymentIsComplete;
  String? accountHolder;
  String? typeBankName;
  String? typeBranchName;
  String? typeAccountNumber;
  String? typeAccountHolder;
  String? attachPaymentSlip;
  String? paymentSlip;
  String? invalidAccessToken;
  String? pleaseReLogin;
  String? pleaseAttachPaymentSlip;
  String? instamojoPayment;
  String? paymentFailed;
  String? pleaseTryAgain;
  String? jazzcashPayment;
  String? enterYourPhoneNumber;
  String? typePhoneNumber;
  String? midtransPayment;
  String? giftCard;
  String? cardAddedSuccessfully;
  String? noDataAvailable;
  String? filterSellerProducts;
  String? trusted;
  String? memberSince;
  String? newArrival;
  String? confirmation;
  String? areYouSureWantToDeleteAccount;
  String? changeMobileNumber;
  String? phone;
  String? changeEmailAddress;
  String? pleaseTypeFullName;
  String? region;
  String? notificationSettings;
  String? selectLanguage;
  String? deleteAccount;
  String? tickets;
  String? ticketCreatedSuccessfully;
  String? createTicket;
  String? selectCategory;
  String? selectPriority;
  String? supportTicket;
  String? ticketID;
  String? priority;
  String? lastUpdated;
  String? typeAMessageHere;
  String? errorGettingData;
  String? endOfResults1;
  String? createTicket1;
  String? reload;
  String? sendTimeoutInConnectionWithAPIServer;
  String? receiveTimeoutInConnectionWithAPIServer;
  String? requestToAPIServerWasCancelled;
  String? connectionTimeoutWithAPIServer;
  String? internalServerError;
  String? badRequest;
  String? noData;
  String? success;
  String? cashOnDelivery;
  String? noItemFound;

  String? buyNow;
  String? buy;
  String? purchaseWasCancelled;
  String? purchaseSuccessful;
  String? price;

  String? pleaseSinInOrRegViewNotifications;
  String? customerLogin;


  LocalizationLangValue(
      {this.home,
      this.message,
      this.cart,
      this.account,
      this.changeLanguage,
      this.language,
      this.privacyPolicy,
      this.rateOurApp,
      this.settings,
      this.signInOrRegister,
      this.allOrders,
      this.myOrders,
      this.myServices,
      this.myCancellations,
      this.myReturns,
      this.myReview,
      this.messages,
      this.needHelp,
      this.policies,
      this.logout,
      this.searchIn,
      this.browseAllProducts,
      this.newUsersZone,
      this.oFF,
      this.off,
      this.freeShippingUpTo,
      this.shopNow,
      this.sold,
      this.brands,
      this.discount,
      this.topPicks,
      this.youMightLike,
      this.recommendedProducts,
      this.myGiftCards,
      this.sort,
      this.new1,
      this.old,
      this.nameAZ,
      this.nameZA,
      this.priceLowToHigh,
      this.priceHighToLow,
      this.buyGiftCard,
      this.giftCards,
      this.scratchToReveal,
      this.secretCodeCopiedToClipboard,
      this.redeem,
      this.myWishlist,
      this.noProductsFound,
      this.endOfResults,
      this.myCoupons,
      this.noCouponsFound,
      this.delete,
      this.details,
      this.validity,
      this.spend,
      this.getUpTo,
      this.get,
      this.addCoupon,
      this.couponCode,
      this.enterCouponCode,
      this.typeCouponCode,
      this.add,
      this.couponDetails,
      this.termsAndConditions,
      this.noOrdersPlacedYet,
      this.placedOn,
      this.soldBy,
      this.package,
      this.comments,
      this.total,
      this.color,
      this.returnRequest,
      this.selectProductsYouWantToReturn,
      this.storage,
      this.refundsAndDisputes,
      this.noRefundOrders,
      this.noCancelledRefundOrders,
      this.requestedOn,
      this.orderDetails,
      this.shipAndBillTo,
      this.billTo,
      this.shipTo,
      this.returnRefund,
      this.writeAReview,
      this.trackYourOrder,
      this.chatNow,
      this.subtotal,
      this.shipping,
      this.totalSaving,
      this.tAXAmount,
      this.totalVATTAXGST,
      this.totalGST,
      this.grandTotal,
      this.paidBy,
      this.trackingNumber,
      this.receiver,
      this.trackOrder,
      this.cancelledOrders,
      this.noCancelledOrders,
      this.changeReview,
      this.productQuality,
      this.anonymous,
      this.rateYourRider,
      this.waitingForReview,
      this.reviewHistory,
      this.allOrderReviewedThankYou,
      this.noReviewsFound,
      this.reviewDone,
      this.thanksForYourFeedback,
      this.invalidCredentials,
      this.unauthorized,
      this.somethingWentWrong,
      this.pleaseTryAgainThankYou,
      this.review,
      this.selectPickupAddress,
      this.pickupAddress,
      this.pickupMethod,
      this.courierPickUp,
      this.max6FilesAllowed,
      this.productReview,
      this.sellerService,
      this.writeYourComment,
      this.pleaseTypeSomething,
      this.selectAShipmentMethod,
      this.selectCourierPickUpInformation,
      this.selectDropOffInformation,
      this.iAccept,
      this.submitReview,
      this.pleaseAcceptTerms,
      this.pleaseAddRatings,
      this.shopOver2MillionProducts,
      this.atUnbeatablePrice,
      this.signIn,
      this.enterYourEmail,
      this.password,
      this.forgotPassword,
      this.donTHaveAnAccountYet,
      this.register,
      this.firstName,
      this.lastName,
      this.confirmPassword,
      this.passwordMustBeTheSame,
      this.referralCodeOptional,
      this.optional,
      this.addToCart,
      this.errorFetchingImage,
      this.quantity,
      this.canTAddLessThan,
      this.products,
      this.stockNotAvailable,
      this.chatUs,
      this.noMoreStock,
      this.myCart,
      this.clearCart,
      this.doYouWantToClearTheCart,
      this.cancel,
      this.confirm,
      this.cartIsEmpty,
      this.remove,
      this.doYouWantRemove,
      this.fromTheCart,
      this.checkOut,
      this.selectItemsToProceedToCheckout,
      this.shippingAddress,
      this.name,
      this.address,
      this.change,
      this.billToTheSameAddress,
      this.addAddress,
      this.shippingCost,
      this.additionalShipping,
      this.tax,
      this.taxAmount,
      this.qty,
      this.itemSTotal,
      this.totalTAX,
      this.itemSGrandTotal,
      this.enterCouponVoucherCode,
      this.apply,
      this.continue1,
      this.pleaseAddShippingAndBillingAddress,
      this.pleaseConfirmTheCheckout,
      this.selectGateway,
      this.vATIncludedWhereApplicable,
      this.orderConfirm,
      this.selectAPaymentMethodFirst,
      this.all,
      this.continueShopping,
      this.filter,
      this.allBrands,
      this.filterProducts,
      this.childCategory,
      this.rating,
      this.andUp,
      this.reset,
      this.applyFilter,
      this.priceRange,
      this.browseGiftCards,
      this.browseProducts,
      this.topPicksProducts,
      this.user,
      this.visitStore,
      this.store,
      this.variant,
      this.specifications,
      this.brand,
      this.modelNumber,
      this.none,
      this.brandModelSpecifications,
      this.delivery,
      this.highlights,
      this.category,
      this.tags,
      this.description,
      this.ratingsReviews,
      this.vIEWALL,
      this.recommendedBySeller,
      this.accountInformation,
      this.changeName,
      this.typeFirstName,
      this.typeLastName,
      this.save,
      this.mobileNumber,
      this.emailAddress,
      this.dateOfBirth,
      this.update,
      this.profileUpdatedSuccessfully,
      this.updateProfileDescription,
      this.pleaseEnterDescription,
      this.error,
      this.pleaseTypeEmailAddress,
      this.selectCountry,
      this.selectState,
      this.pleaseTypeAddress,
      this.postalZipCode,
      this.pleaseTypePostalZipCode,
      this.saveAddress,
      this.addressAddedSuccessfully,
      this.invalidAccessTokenPleaseReLogin,
      this.selectCity,
      this.noCityFound,
      this.myAddress,
      this.defaultBilling,
      this.setToDefaultBillingAddress,
      this.addressNotFound,
      this.setDefaultBilling,
      this.defaultShipping,
      this.setToDefaultShippingAddress,
      this.setDefaultShipping,
      this.edit,
      this.changePassword,
      this.currentPassword,
      this.typeYourCurrentPassword,
      this.thePasswordMustBeAtLeast8Characters,
      this.newPassword,
      this.typeYourNewPassword,
      this.reTypePassword,
      this.typePasswordAgain,
      this.thePasswordConfirmationDoesNotMatch,
      this.updatePassword,
      this.passwordUpdatedSuccessfully,
      this.editAddress,
      this.addressDeletedSuccessfully,
      this.deleteThisAddress,
      this.saveChange,
      this.addressUpdatedSuccessfully,
      this.termsConditions,
      this.addressBook,
      this.receiveExclusiveOffersPersonalUpdates,
      this.shopMore,
      this.categories,
      this.changeCurrency,
      this.selectCurrency,
      this.back,
      this.currencyChangedTo,
      this.currency,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.toPay,
      this.toShip,
      this.toReceive,
      this.pending,
      this.cancelled,
      this.completed,
      this.confirmed,
      this.paid,
      this.wallet,
      this.hello,
      this.homePage,
      this.allProducts,
      this.loggedOut,
      this.welcomeTo,
      this.notifications,
      this.notification,
      this.forgotPassword1,
      this.signUp,
      this.resetPassword,
      this.send,
      this.coupons,
      this.tAXGSTVATAmount,
      this.priceDropped,
      this.refundRequestedOn,
      this.refundDetails,
      this.requestSentDate,
      this.orderDate,
      this.refundMethod,
      this.shippingType,
      this.bankTransfer,
      this.pleaseTypeBranchName,
      this.accountHolderName,
      this.pleaseTypeAccountHolderName,
      this.branchName,
      this.pleaseTypeBankName,
      this.bankName,
      this.courierPickupInfo,
      this.dropOffInfo,
      this.shippingMethod,
      this.state,
      this.city,
      this.postcode,
      this.dropOffAddress,
      this.typeInDropOffAddress,
      this.pleaseTypeInYourCompleteBankAccountInformation,
      this.dropOff,
      this.selectDropOff,
      this.dealStartsIn,
      this.dealEndsIn,
      this.dealEnded,
      this.productSpecifications,
      this.availability,
      this.inStock,
      this.notInStock,
      this.productSKU,
      this.minimumOrderQuantity,
      this.maximumOrderQuantity,
      this.relatedProducts,
      this.upSalesProducts,
      this.crossSalesProducts,
      this.outOfStock,
      this.viewMore,
      this.showLess,
      this.share,
      this.search,
      this.calculatedAtNextStep,
      this.checkout,
      this.vATTAXGSTIncludedWhereApplicable,
      this.proceedToPayment,
      this.basedOnFlatRate,
      this.basedOnPerHundred,
      this.basedOnPer100Gm,
      this.totalGSTTAX,
      this.whatIsYourPhoneNumber,
      this.enterYourMobileNumber,
      this.pleaseEnterYourMobileNumber,
      this.weWillSendACodeToYourMobileNumber,
      this.enter6DigitVerificationCode,
      this.enterTheVerificationCodeWeHaveSentTo,
      this.oTPTimedOutPleaseResendOTP,
      this.oTPDoesNotMatch,
      this.resendOTP,
      this.youDonTHaveSufficientWalletBalance,
      this.pleaseTypeFirstName,
      this.pleaseTypeLastName,
      this.pleaseTypeEmail,
      this.pleaseTypePassword,
      this.pleaseTypeConfirmPassword,
      this.invalidEmail,
      this.subject,
      this.typeSubject,
      this.typeDescription,
      this.attachFiles,
      this.submit,
      this.accountNumber,
      this.pleaseTypeAccountNumber,
      this.refundTo,
      this.bySubmittingThisFormIAccept,
      this.returnPolicyOf,
      this.canTRemoveAnymore,
      this.pleaseSelectTheProductFirst,
      this.canTAddAnymore,
      this.selectAReasonForReturning,
      this.loading,
      this.country,
      this.cancelOrder,
      this.selectCancelReason,
      this.collectFrom,
      this.orderCancelled,
      this.openDispute,
      this.changeYourComment,
      this.writeReview,
      this.warning,
      this.updatedSuccessfully,
      this.resetPasswordLinkSent,
      this.pleaseTypeYourEmail,
      this.pleaseTypeYourPassword,
      this.donTHaveAnAccountYet1,
      this.orContinueWith,
      this.next,
      this.referralCode,
      this.sKU,
      this.emailDelivery,
      this.canTAddLessThan1,
      this.stockAvailable,
      this.homeDelivery,
      this.pickupLocation,
      this.selectAPickupPoint,
      this.billingAddress,
      this.itemS,
      this.collectFromPickupLocation,
      this.couponDiscount,
      this.grandTotal1,
      this.minimumShoppingAmount,
      this.withoutShippingCost,
      this.doYouWantToRemove,
      this.cartPriceUpdated,
      this.pleaseCheckPricesAndShippingAgain,
      this.oK,
      this.close,
      this.paypalPayment,
      this.stripePayment,
      this.createSession,
      this.openCheckoutPage,
      this.orderCreatedSuccessfully,
      this.orderCreateUnsuccessfully,
      this.tabbyCheckout,
      this.disabledForDemo,
      this.bankPayment,
      this.paymentProcessing,
      this.pleaseDonTCloseThisUntilPaymentIsComplete,
      this.accountHolder,
      this.typeBankName,
      this.typeBranchName,
      this.typeAccountNumber,
      this.typeAccountHolder,
      this.attachPaymentSlip,
      this.paymentSlip,
      this.invalidAccessToken,
      this.pleaseReLogin,
      this.pleaseAttachPaymentSlip,
      this.instamojoPayment,
      this.paymentFailed,
      this.pleaseTryAgain,
      this.jazzcashPayment,
      this.enterYourPhoneNumber,
      this.typePhoneNumber,
      this.midtransPayment,
      this.giftCard,
      this.cardAddedSuccessfully,
      this.noDataAvailable,
      this.filterSellerProducts,
      this.trusted,
      this.memberSince,
      this.newArrival,
      this.confirmation,
      this.areYouSureWantToDeleteAccount,
      this.changeMobileNumber,
      this.phone,
      this.changeEmailAddress,
      this.pleaseTypeFullName,
      this.region,
      this.notificationSettings,
      this.selectLanguage,
      this.deleteAccount,
      this.tickets,
      this.ticketCreatedSuccessfully,
      this.createTicket,
      this.selectCategory,
      this.selectPriority,
      this.supportTicket,
      this.ticketID,
      this.priority,
      this.lastUpdated,
      this.typeAMessageHere,
      this.errorGettingData,
      this.endOfResults1,
      this.createTicket1,
      this.reload,
      this.sendTimeoutInConnectionWithAPIServer,
      this.receiveTimeoutInConnectionWithAPIServer,
      this.requestToAPIServerWasCancelled,
      this.connectionTimeoutWithAPIServer,
      this.internalServerError,
      this.badRequest,
      this.noData,
      this.success,
      this.cashOnDelivery,
      this.noItemFound,
      this.buyNow,
      this.buy,
      this.purchaseWasCancelled,
      this.purchaseSuccessful,
        this.price,
        this.pleaseSinInOrRegViewNotifications,
        this.customerLogin
      });

  LocalizationLangValue.fromJson(Map<String, dynamic> json) {
    home = json['Home'];
    message = json['Message'];
    cart = json['Cart'];
    account = json['Account'];
    changeLanguage = json['Change Language'];
    language = json['Language'];
    privacyPolicy = json['Privacy Policy'];
    rateOurApp = json['Rate our App'];
    settings = json['Settings'];
    signInOrRegister = json['Sign in or Register'];
    allOrders = json['All Orders'];
    myOrders = json['My Orders'];
    myServices = json['My Services'];
    myCancellations = json['My Cancellations'];
    myReturns = json['My Returns'];
    myReview = json['My Review'];
    messages = json['Messages'];
    needHelp = json['Need Help?'];
    policies = json['Policies'];
    logout = json['Logout'];
    searchIn = json['Search in'];
    browseAllProducts = json['Browse All Products'];
    newUsersZone = json['New Users Zone!'];
    oFF = json['OFF'];
    off = json['off'];
    freeShippingUpTo = json['Free Shipping up-to'];
    shopNow = json['Shop Now'];
    sold = json['Sold'];
    brands = json['Brands'];
    discount = json['Discount'];
    topPicks = json['Top Picks'];
    youMightLike = json['You might like'];
    recommendedProducts = json['Recommended Products'];
    myGiftCards = json['My Gift Cards'];
    sort = json['Sort'];
    new1 = json['New'];
    old = json['Old'];
    nameAZ = json['Name (A-Z)'];
    nameZA = json['Name (Z-A)'];
    priceLowToHigh = json['Price (Low to High)'];
    priceHighToLow = json['Price (High to Low)'];
    buyGiftCard = json['Buy Gift Card'];
    giftCards = json['Gift Cards'];
    scratchToReveal = json['Scratch to reveal'];
    secretCodeCopiedToClipboard = json['Secret Code copied to Clipboard'];
    redeem = json['Redeem'];
    myWishlist = json['My Wishlist'];
    noProductsFound = json['No Products found'];
    endOfResults = json['End of results'];
    myCoupons = json['My Coupons'];
    noCouponsFound = json['No Coupons found'];
    delete = json['Delete'];
    details = json['Details'];
    validity = json['Validity'];
    spend = json['Spend'];
    getUpTo = json['get up-to'];
    get = json['get'];
    addCoupon = json['Add Coupon'];
    couponCode = json['Coupon Code'];
    enterCouponCode = json['Enter Coupon Code'];
    typeCouponCode = json['Type Coupon code'];
    add = json['Add'];
    couponDetails = json['Coupon Details'];
    termsAndConditions = json['Terms and Conditions'];
    noOrdersPlacedYet = json['No Orders placed yet!'];
    placedOn = json['Placed on'];
    soldBy = json['Sold by'];
    package = json['Package'];
    comments = json['Comments'];
    total = json['Total'];
    color = json['Color'];
    returnRequest = json['Return Request'];
    selectProductsYouWantToReturn = json['Select Products you want to return'];
    storage = json['Storage'];
    refundsAndDisputes = json['Refunds and Disputes'];
    noRefundOrders = json['No Refund Orders'];
    noCancelledRefundOrders = json['No Cancelled Refund Orders'];
    requestedOn = json['Requested on'];
    orderDetails = json['Order Details'];
    shipAndBillTo = json['Ship and Bill to'];
    billTo = json['Bill to'];
    shipTo = json['Ship to'];
    returnRefund = json['Return/Refund'];
    writeAReview = json['Write a Review'];
    trackYourOrder = json['Track your order'];
    chatNow = json['Chat now'];
    subtotal = json['Subtotal'];
    shipping = json['Shipping'];
    totalSaving = json['Total Saving'];
    tAXAmount = json['TAX Amount'];
    totalVATTAXGST = json['Total VAT/TAX/GST'];
    totalGST = json['Total GST'];
    grandTotal = json['Grand total'];
    paidBy = json['Paid by'];
    trackingNumber = json['Tracking Number'];
    receiver = json['Receiver'];
    trackOrder = json['Track Order'];
    cancelledOrders = json['Cancelled Orders'];
    noCancelledOrders = json['No Cancelled Orders'];
    changeReview = json['Change Review'];
    productQuality = json['Product Quality'];
    anonymous = json['Anonymous'];
    rateYourRider = json['Rate Your Rider'];
    waitingForReview = json['Waiting for Review'];
    reviewHistory = json['Review History'];
    allOrderReviewedThankYou = json['All Order reviewed. Thank you!'];
    noReviewsFound = json['No reviews Found'];
    reviewDone = json['Review Done'];
    thanksForYourFeedback = json['Thanks for your feedback.'];
    invalidCredentials = json['Invalid Credentials'];
    unauthorized = json['Unauthorized'];
    somethingWentWrong = json['Something went wrong'];
    pleaseTryAgainThankYou = json['Please try again. Thank you.'];
    review = json['Review'];
    selectPickupAddress = json['Select Pickup Address'];
    pickupAddress = json['Pickup Address'];
    pickupMethod = json['Pickup Method'];
    courierPickUp = json['Courier Pick Up'];
    max6FilesAllowed = json['Max 6 files allowed'];
    productReview = json['Product Review'];
    sellerService = json['Seller Service'];
    writeYourComment = json['Write your comment'];
    pleaseTypeSomething = json['Please Type something'];
    selectAShipmentMethod = json['Select a Shipment Method'];
    selectCourierPickUpInformation = json['Select Courier Pick Up Information'];
    selectDropOffInformation = json['Select Drop Off Information'];
    iAccept = json['I accept'];
    submitReview = json['Submit Review'];
    pleaseAcceptTerms = json['Please accept terms'];
    pleaseAddRatings = json['Please Add Ratings'];
    shopOver2MillionProducts = json['Shop over 2 Million Products'];
    atUnbeatablePrice = json['at unbeatable price'];
    signIn = json['Sign In'];
    enterYourEmail = json['Enter Your Email'];
    password = json['Password'];
    forgotPassword = json['Forgot password'];
    donTHaveAnAccountYet = json['Don"t have an account Yet?'];
    register = json['Register'];
    firstName = json['First Name'];
    lastName = json['Last Name'];
    confirmPassword = json['Confirm Password'];
    passwordMustBeTheSame = json['Password must be the same'];
    referralCodeOptional = json['Referral code (optional)'];
    optional = json['Optional'];
    addToCart = json['Add to Cart'];
    errorFetchingImage = json['Error fetching Image'];
    quantity = json['Quantity'];
    canTAddLessThan = json['Can"t add less than'];
    products = json['Products'];
    stockNotAvailable = json['Stock not available.'];
    chatUs = json['Chat Us'];
    noMoreStock = json['No more stock'];
    myCart = json['My Cart'];
    clearCart = json['Clear Cart'];
    doYouWantToClearTheCart = json['Do you want to clear the cart?'];
    cancel = json['Cancel'];
    confirm = json['Confirm'];
    cartIsEmpty = json['Cart is Empty'];
    remove = json['Remove'];
    doYouWantRemove = json['Do you want remove'];
    fromTheCart = json['from the cart?'];
    checkOut = json['Check out'];
    selectItemsToProceedToCheckout =
        json['Select Items to proceed to checkout'];
    shippingAddress = json['Shipping Address'];
    name = json['Name'];
    address = json['Address'];
    change = json['Change'];
    billToTheSameAddress = json['Bill to the Same Address'];
    addAddress = json['Add Address'];
    shippingCost = json['Shipping cost'];
    additionalShipping = json['Additional Shipping'];
    tax = json['Tax'];
    taxAmount = json['Tax Amount'];
    qty = json['Qty'];
    itemSTotal = json['Item(s), total=>'];
    totalTAX = json['Total TAX'];
    itemSGrandTotal = json['Item(s), Grand Total=>'];
    enterCouponVoucherCode = json['Enter coupon/voucher code'];
    apply = json['Apply'];
    continue1 = json['Continue'];
    pleaseAddShippingAndBillingAddress =
        json['Please Add Shipping and Billing Address'];
    pleaseConfirmTheCheckout = json['Please confirm the checkout'];
    selectGateway = json['Select Gateway'];
    vATIncludedWhereApplicable = json['VAT included, where applicable'];
    orderConfirm = json['Order Confirm'];
    selectAPaymentMethodFirst = json['Select a Payment method first'];
    all = json['All'];
    continueShopping = json['Continue Shopping'];
    filter = json['Filter'];
    allBrands = json['All Brands'];
    filterProducts = json['Filter Products'];
    childCategory = json['Child Category'];
    rating = json['Rating'];
    andUp = json['and Up'];
    reset = json['Reset'];
    applyFilter = json['Apply Filter'];
    priceRange = json['Price Range'];
    browseGiftCards = json['Browse Gift Cards'];
    browseProducts = json['Browse Products'];
    topPicksProducts = json['Top Picks Products'];
    user = json['User'];
    visitStore = json['Visit Store'];
    store = json['Store'];
    variant = json['Variant'];
    specifications = json['Specifications'];
    brand = json['Brand'];
    modelNumber = json['Model Number'];
    none = json['None'];
    brandModelSpecifications = json['Brand, Model, Specifications'];
    delivery = json['Delivery'];
    highlights = json['Highlights'];
    category = json['Category'];
    tags = json['Tags'];
    description = json['Description'];
    ratingsReviews = json['Ratings & Reviews'];
    vIEWALL = json['VIEW ALL'];
    recommendedBySeller = json['Recommended by Seller'];
    accountInformation = json['Account Information'];
    changeName = json['Change Name'];
    typeFirstName = json['Type First name'];
    typeLastName = json['Type Last name'];
    save = json['Save'];
    mobileNumber = json['Mobile Number'];
    emailAddress = json['Email Address'];
    dateOfBirth = json['Date of Birth'];
    update = json['Update'];
    profileUpdatedSuccessfully = json['Profile updated successfully'];
    updateProfileDescription = json['Update Profile Description'];
    pleaseEnterDescription = json['Please Enter description'];
    error = json['Error'];
    pleaseTypeEmailAddress = json['Please Type Email address'];
    selectCountry = json['Select Country'];
    selectState = json['Select State'];
    pleaseTypeAddress = json['Please Type Address'];
    postalZipCode = json['Postal/Zip Code'];
    pleaseTypePostalZipCode = json['Please Type Postal/Zip code'];
    saveAddress = json['Save Address'];
    addressAddedSuccessfully = json['Address added successfully'];
    invalidAccessTokenPleaseReLogin =
        json['Invalid Access token. Please re-login.'];
    selectCity = json['Select City'];
    noCityFound = json['No City found'];
    myAddress = json['My Address'];
    defaultBilling = json['Default Billing'];
    setToDefaultBillingAddress = json['Set to default billing address'];
    addressNotFound = json['Address not found'];
    setDefaultBilling = json['Set Default Billing'];
    defaultShipping = json['Default Shipping'];
    setToDefaultShippingAddress = json['Set to default Shipping address'];
    setDefaultShipping = json['Set Default Shipping'];
    edit = json['Edit'];
    changePassword = json['Change Password'];
    currentPassword = json['Current Password'];
    typeYourCurrentPassword = json['Type your current password'];
    thePasswordMustBeAtLeast8Characters =
        json['The password must be at least 8 characters.'];
    newPassword = json['New Password'];
    typeYourNewPassword = json['Type your new password'];
    reTypePassword = json['Re-type Password'];
    typePasswordAgain = json['Type password again'];
    thePasswordConfirmationDoesNotMatch =
        json['The password confirmation does not match.'];
    updatePassword = json['Update Password'];
    passwordUpdatedSuccessfully = json['Password Updated successfully'];
    editAddress = json['Edit Address'];
    addressDeletedSuccessfully = json['Address deleted successfully'];
    deleteThisAddress = json['Delete this Address'];
    saveChange = json['Save Change'];
    addressUpdatedSuccessfully = json['Address updated successfully'];
    termsConditions = json['Terms & Conditions'];
    addressBook = json['Address Book'];
    receiveExclusiveOffersPersonalUpdates =
        json['Receive exclusive offers & personal updates'];
    shopMore = json['Shop more'];
    categories = json['Categories'];
    changeCurrency = json['Change Currency'];
    selectCurrency = json['Select Currency'];
    back = json['Back'];
    currencyChangedTo = json['Currency changed to'];
    currency = json['Currency'];
    fullName = json['Full Name'];
    email = json['Email'];
    phoneNumber = json['Phone Number'];
    toPay = json['To Pay'];
    toShip = json['To Ship'];
    toReceive = json['To Receive'];
    pending = json['Pending'];
    cancelled = json['Cancelled'];
    completed = json['Completed'];
    confirmed = json['Confirmed'];
    paid = json['Paid'];
    wallet = json['Wallet'];
    hello = json['Hello'];
    homePage = json['Home Page'];
    allProducts = json['All Products'];
    loggedOut = json['Logged out'];
    welcomeTo = json['Welcome to'];
    notifications = json['Notifications'];
    notification = json['Notification'];
    forgotPassword1 = json['Forgot password?'];
    signUp = json['Sign Up'];
    resetPassword = json['Reset Password'];
    send = json['Send'];
    coupons = json['Coupons'];
    tAXGSTVATAmount = json['TAX/GST/VAT Amount'];
    priceDropped = json['Price dropped'];
    refundRequestedOn = json['Refund Requested on'];
    refundDetails = json['Refund Details'];
    requestSentDate = json['Request Sent Date'];
    orderDate = json['Order Date'];
    refundMethod = json['Refund Method'];
    shippingType = json['Shipping Type'];
    bankTransfer = json['Bank Transfer'];
    pleaseTypeBranchName = json['Please Type Branch Name'];
    accountHolderName = json['Account Holder Name'];
    pleaseTypeAccountHolderName = json['Please Type Account holder name'];
    branchName = json['Branch Name'];
    pleaseTypeBankName = json['Please Type Bank name'];
    bankName = json['Bank Name'];
    courierPickupInfo = json['Courier Pickup Info'];
    dropOffInfo = json['Drop off Info'];
    shippingMethod = json['Shipping Method'];
    state = json['State'];
    city = json['City'];
    postcode = json['Postcode'];
    dropOffAddress = json['Drop off Address'];
    typeInDropOffAddress = json['Type in Drop off Address'];
    pleaseTypeInYourCompleteBankAccountInformation =
        json['Please type in your complete Bank Account Information'];
    dropOff = json['Drop off'];
    selectDropOff = json['Select Drop off'];
    dealStartsIn = json['Deal Starts in'];
    dealEndsIn = json['Deal Ends in'];
    dealEnded = json['Deal Ended'];
    productSpecifications = json['Product Specifications'];
    availability = json['Availability'];
    inStock = json['In Stock'];
    notInStock = json['Not in stock'];
    productSKU = json['Product SKU'];
    minimumOrderQuantity = json['Minimum Order Quantity'];
    maximumOrderQuantity = json['Maximum Order Quantity'];
    relatedProducts = json['Related Products'];
    upSalesProducts = json['Up Sales Products'];
    crossSalesProducts = json['Cross Sales Products'];
    outOfStock = json['Out of Stock'];
    viewMore = json['View more'];
    showLess = json['Show less'];
    share = json['Share'];
    search = json['Search'];
    calculatedAtNextStep = json['Calculated at next step'];
    checkout = json['Checkout'];
    vATTAXGSTIncludedWhereApplicable =
        json['VAT/TAX/GST included, where applicable'];
    proceedToPayment = json['Proceed to Payment'];
    basedOnFlatRate = json['Based on Flat Rate'];
    basedOnPerHundred = json['Based on Per Hundred'];
    basedOnPer100Gm = json['Based on Per 100 Gm'];
    totalGSTTAX = json['Total GST/TAX'];
    whatIsYourPhoneNumber = json['What is your phone number?'];
    enterYourMobileNumber = json['Enter your mobile number'];
    pleaseEnterYourMobileNumber = json['Please Enter your Mobile Number'];
    weWillSendACodeToYourMobileNumber =
        json['We will send a code to your mobile number'];
    enter6DigitVerificationCode = json['Enter 6-digit verification code'];
    enterTheVerificationCodeWeHaveSentTo =
        json['Enter the verification code, we have sent to'];
    oTPTimedOutPleaseResendOTP = json['OTP Timed out. Please resend OTP'];
    oTPDoesNotMatch = json['OTP does not match'];
    resendOTP = json['Resend OTP'];
    youDonTHaveSufficientWalletBalance =
        json["You don't have sufficient wallet balance"];
    pleaseTypeFirstName = json['Please Type first name'];
    pleaseTypeLastName = json['Please Type last name'];
    pleaseTypeEmail = json['Please Type email'];
    pleaseTypePassword = json['Please Type password'];
    pleaseTypeConfirmPassword = json['Please Type confirm password'];
    invalidEmail = json['Invalid email'];
    subject = json['Subject'];
    typeSubject = json['Type Subject'];
    typeDescription = json['Type Description'];
    attachFiles = json['Attach Files'];
    submit = json['Submit'];
    accountNumber = json['Account Number'];
    pleaseTypeAccountNumber = json['Please Type Account Number'];
    refundTo = json['Refund to'];
    bySubmittingThisFormIAccept = json['By submitting this form, I accept'];
    returnPolicyOf = json['Return Policy of'];
    canTRemoveAnymore = json["Can't remove anymore"];
    pleaseSelectTheProductFirst = json['Please select the product first!'];
    canTAddAnymore = json["Can't add anymore"];
    selectAReasonForReturning = json['Select a reason for returning'];
    loading = json['Loading'];
    country = json['Country'];
    cancelOrder = json['Cancel Order'];
    selectCancelReason = json['Select Cancel Reason'];
    collectFrom = json['Collect from'];
    orderCancelled = json['Order Cancelled'];
    openDispute = json['Open Dispute'];
    changeYourComment = json['Change your comment'];
    writeReview = json['Write Review'];
    warning = json['Warning'];
    updatedSuccessfully = json['Updated successfully'];
    resetPasswordLinkSent = json['Reset password link sent'];
    pleaseTypeYourEmail = json['Please Type your email'];
    pleaseTypeYourPassword = json['Please Type your password'];
    donTHaveAnAccountYet1 = json["Don't have an account Yet?"];
    orContinueWith = json['Or continue with'];
    next = json['Next'];
    referralCode = json['Referral code'];
    sKU = json['SKU'];
    emailDelivery = json['Email Delivery'];
    canTAddLessThan = json["Can't add less than"];
    stockAvailable = json['Stock Available'];
    homeDelivery = json['Home Delivery'];
    pickupLocation = json['Pickup Location'];
    selectAPickupPoint = json['Select a pickup point'];
    billingAddress = json['Billing Address'];
    itemS = json['Item(s)'];
    collectFromPickupLocation = json['Collect from Pickup location'];
    couponDiscount = json['Coupon Discount'];
    grandTotal = json['Grand Total'];
    minimumShoppingAmount = json['Minimum shopping amount'];
    withoutShippingCost = json['without shipping cost'];
    doYouWantToRemove = json['Do you want to remove'];
    cartPriceUpdated = json['Cart Price updated'];
    pleaseCheckPricesAndShippingAgain =
        json['Please check prices and shipping again'];
    oK = json['OK'];
    close = json['Close'];
    paypalPayment = json['Paypal Payment'];
    stripePayment = json['Stripe Payment'];
    createSession = json['Create Session'];
    openCheckoutPage = json['Open checkout page'];
    orderCreatedSuccessfully = json['Order created successfully'];
    orderCreateUnsuccessfully = json['Order create unsuccessfully'];
    tabbyCheckout = json['Tabby Checkout'];
    disabledForDemo = json['Disabled for demo'];
    bankPayment = json['Bank Payment'];
    paymentProcessing = json['Payment Processing'];
    pleaseDonTCloseThisUntilPaymentIsComplete =
        json["Please don't close this until payment is complete"];
    accountHolder = json['Account holder'];
    typeBankName = json['Type Bank name'];
    typeBranchName = json['Type Branch name'];
    typeAccountNumber = json['Type Account Number'];
    typeAccountHolder = json['Type Account Holder'];
    attachPaymentSlip = json['Attach Payment Slip'];
    paymentSlip = json['Payment Slip'];
    invalidAccessToken = json['Invalid Access token'];
    pleaseReLogin = json['Please re-login'];
    pleaseAttachPaymentSlip = json['Please attach Payment slip'];
    instamojoPayment = json['Instamojo Payment'];
    paymentFailed = json['Payment failed'];
    pleaseTryAgain = json['Please try again'];
    jazzcashPayment = json['Jazzcash Payment'];
    enterYourPhoneNumber = json['Enter Your Phone Number'];
    typePhoneNumber = json['Type Phone number'];
    midtransPayment = json['Midtrans Payment'];
    giftCard = json['Gift Card'];
    cardAddedSuccessfully = json['Card Added successfully'];
    noDataAvailable = json['No data available'];
    filterSellerProducts = json['Filter Seller Products'];
    trusted = json['Trusted'];
    memberSince = json['Member Since'];
    newArrival = json['New Arrival'];
    confirmation = json['Confirmation'];
    areYouSureWantToDeleteAccount =
        json['Are you sure want to delete account?'];
    changeMobileNumber = json['Change Mobile Number'];
    phone = json['Phone'];
    changeEmailAddress = json['Change Email Address'];
    pleaseTypeFullName = json['Please Type Full Name'];
    region = json['Region'];
    notificationSettings = json['Notification Settings'];
    selectLanguage = json['Select Language'];
    deleteAccount = json['Delete Account'];
    tickets = json['Tickets'];
    ticketCreatedSuccessfully = json['Ticket created successfully'];
    createTicket = json['Create Ticket'];
    selectCategory = json['Select Category'];
    selectPriority = json['Select Priority'];
    supportTicket = json['Support Ticket'];
    ticketID = json['Ticket ID'];
    priority = json['Priority'];
    lastUpdated = json['Last Updated'];
    typeAMessageHere = json['Type a message here'];
    errorGettingData = json['Error getting data'];
    endOfResults = json['End of Results'];
    createTicket = json['Create Ticket?'];
    reload = json['Reload'];
    sendTimeoutInConnectionWithAPIServer =
        json['Send timeout in connection with API server'];
    receiveTimeoutInConnectionWithAPIServer =
        json['Receive timeout in connection with API server'];
    requestToAPIServerWasCancelled =
        json['Request to API server was cancelled'];
    connectionTimeoutWithAPIServer = json['Connection timeout with API server'];
    internalServerError = json['Internal server error'];
    badRequest = json['Bad request'];
    noData = json['No data'];
    success = json['Success'];
    cashOnDelivery = json['Cash On Delivery'];
    noItemFound = json['No item found'];
    buyNow = json['Buy now'];
    buy = json['Buy'];
    purchaseWasCancelled = json['Purchase was cancelled'];
    purchaseSuccessful = json['Purchase Successful'];
    price = json["Price"];
    pleaseSinInOrRegViewNotifications = json['Please Sign in or Register to view notifications'];
    customerLogin = json['Customer Login'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Home'] = this.home;
    data['Message'] = this.message;
    data['Cart'] = this.cart;
    data['Account'] = this.account;
    data['Change Language'] = this.changeLanguage;
    data['Language'] = this.language;
    data['Privacy Policy'] = this.privacyPolicy;
    data['Rate our App'] = this.rateOurApp;
    data['Settings'] = this.settings;
    data['Sign in or Register'] = this.signInOrRegister;
    data['All Orders'] = this.allOrders;
    data['My Orders'] = this.myOrders;
    data['My Services'] = this.myServices;
    data['My Cancellations'] = this.myCancellations;
    data['My Returns'] = this.myReturns;
    data['My Review'] = this.myReview;
    data['Messages'] = this.messages;
    data['Need Help?'] = this.needHelp;
    data['Policies'] = this.policies;
    data['Logout'] = this.logout;
    data['Search in'] = this.searchIn;
    data['Browse All Products'] = this.browseAllProducts;
    data['New Users Zone!'] = this.newUsersZone;
    data['OFF'] = this.oFF;
    data['off'] = this.off;
    data['Free Shipping up-to'] = this.freeShippingUpTo;
    data['Shop Now'] = this.shopNow;
    data['Sold'] = this.sold;
    data['Brands'] = this.brands;
    data['Discount'] = this.discount;
    data['Top Picks'] = this.topPicks;
    data['You might like'] = this.youMightLike;
    data['Recommended Products'] = this.recommendedProducts;
    data['My Gift Cards'] = this.myGiftCards;
    data['Sort'] = this.sort;
    data['New'] = this.new1;
    data['Old'] = this.old;
    data['Name (A-Z)'] = this.nameAZ;
    data['Name (Z-A)'] = this.nameZA;
    data['Price (Low to High)'] = this.priceLowToHigh;
    data['Price (High to Low)'] = this.priceHighToLow;
    data['Buy Gift Card'] = this.buyGiftCard;
    data['Gift Cards'] = this.giftCards;
    data['Scratch to reveal'] = this.scratchToReveal;
    data['Secret Code copied to Clipboard'] = this.secretCodeCopiedToClipboard;
    data['Redeem'] = this.redeem;
    data['My Wishlist'] = this.myWishlist;
    data['No Products found'] = this.noProductsFound;
    data['End of results'] = this.endOfResults;
    data['My Coupons'] = this.myCoupons;
    data['No Coupons found'] = this.noCouponsFound;
    data['Delete'] = this.delete;
    data['Details'] = this.details;
    data['Validity'] = this.validity;
    data['Spend'] = this.spend;
    data['get up-to'] = this.getUpTo;
    data['get'] = this.get;
    data['Add Coupon'] = this.addCoupon;
    data['Coupon Code'] = this.couponCode;
    data['Enter Coupon Code'] = this.enterCouponCode;
    data['Type Coupon code'] = this.typeCouponCode;
    data['Add'] = this.add;
    data['Coupon Details'] = this.couponDetails;
    data['Terms and Conditions'] = this.termsAndConditions;
    data['No Orders placed yet!'] = this.noOrdersPlacedYet;
    data['Placed on'] = this.placedOn;
    data['Sold by'] = this.soldBy;
    data['Package'] = this.package;
    data['Comments'] = this.comments;
    data['Total'] = this.total;
    data['Color'] = this.color;
    data['Return Request'] = this.returnRequest;
    data['Select Products you want to return'] =
        this.selectProductsYouWantToReturn;
    data['Storage'] = this.storage;
    data['Refunds and Disputes'] = this.refundsAndDisputes;
    data['No Refund Orders'] = this.noRefundOrders;
    data['No Cancelled Refund Orders'] = this.noCancelledRefundOrders;
    data['Requested on'] = this.requestedOn;
    data['Order Details'] = this.orderDetails;
    data['Ship and Bill to'] = this.shipAndBillTo;
    data['Bill to'] = this.billTo;
    data['Ship to'] = this.shipTo;
    data['Return/Refund'] = this.returnRefund;
    data['Write a Review'] = this.writeAReview;
    data['Track your order'] = this.trackYourOrder;
    data['Chat now'] = this.chatNow;
    data['Subtotal'] = this.subtotal;
    data['Shipping'] = this.shipping;
    data['Total Saving'] = this.totalSaving;
    data['TAX Amount'] = this.tAXAmount;
    data['Total VAT/TAX/GST'] = this.totalVATTAXGST;
    data['Total GST'] = this.totalGST;
    data['Grand total'] = this.grandTotal;
    data['Paid by'] = this.paidBy;
    data['Tracking Number'] = this.trackingNumber;
    data['Receiver'] = this.receiver;
    data['Track Order'] = this.trackOrder;
    data['Cancelled Orders'] = this.cancelledOrders;
    data['No Cancelled Orders'] = this.noCancelledOrders;
    data['Change Review'] = this.changeReview;
    data['Product Quality'] = this.productQuality;
    data['Anonymous'] = this.anonymous;
    data['Rate Your Rider'] = this.rateYourRider;
    data['Waiting for Review'] = this.waitingForReview;
    data['Review History'] = this.reviewHistory;
    data['All Order reviewed. Thank you!'] = this.allOrderReviewedThankYou;
    data['No reviews Found'] = this.noReviewsFound;
    data['Review Done'] = this.reviewDone;
    data['Thanks for your feedback.'] = this.thanksForYourFeedback;
    data['Invalid Credentials'] = this.invalidCredentials;
    data['Unauthorized'] = this.unauthorized;
    data['Something went wrong'] = this.somethingWentWrong;
    data['Please try again. Thank you.'] = this.pleaseTryAgainThankYou;
    data['Review'] = this.review;
    data['Select Pickup Address'] = this.selectPickupAddress;
    data['Pickup Address'] = this.pickupAddress;
    data['Pickup Method'] = this.pickupMethod;
    data['Courier Pick Up'] = this.courierPickUp;
    data['Max 6 files allowed'] = this.max6FilesAllowed;
    data['Product Review'] = this.productReview;
    data['Seller Service'] = this.sellerService;
    data['Write your comment'] = this.writeYourComment;
    data['Please Type something'] = this.pleaseTypeSomething;
    data['Select a Shipment Method'] = this.selectAShipmentMethod;
    data['Select Courier Pick Up Information'] =
        this.selectCourierPickUpInformation;
    data['Select Drop Off Information'] = this.selectDropOffInformation;
    data['I accept'] = this.iAccept;
    data['Submit Review'] = this.submitReview;
    data['Please accept terms'] = this.pleaseAcceptTerms;
    data['Please Add Ratings'] = this.pleaseAddRatings;
    data['Shop over 2 Million Products'] = this.shopOver2MillionProducts;
    data['at unbeatable price'] = this.atUnbeatablePrice;
    data['Sign In'] = this.signIn;
    data['Enter Your Email'] = this.enterYourEmail;
    data['Password'] = this.password;
    data['Forgot password'] = this.forgotPassword;
    data['Don"t have an account Yet?'] = this.donTHaveAnAccountYet;
    data['Register'] = this.register;
    data['First Name'] = this.firstName;
    data['Last Name'] = this.lastName;
    data['Confirm Password'] = this.confirmPassword;
    data['Password must be the same'] = this.passwordMustBeTheSame;
    data['Referral code (optional)'] = this.referralCodeOptional;
    data['Optional'] = this.optional;
    data['Add to Cart'] = this.addToCart;
    data['Error fetching Image'] = this.errorFetchingImage;
    data['Quantity'] = this.quantity;
    data['Can"t add less than'] = this.canTAddLessThan;
    data['Products'] = this.products;
    data['Stock not available.'] = this.stockNotAvailable;
    data['Chat Us'] = this.chatUs;
    data['No more stock'] = this.noMoreStock;
    data['My Cart'] = this.myCart;
    data['Clear Cart'] = this.clearCart;
    data['Do you want to clear the cart?'] = this.doYouWantToClearTheCart;
    data['Cancel'] = this.cancel;
    data['Confirm'] = this.confirm;
    data['Cart is Empty'] = this.cartIsEmpty;
    data['Remove'] = this.remove;
    data['Do you want remove'] = this.doYouWantRemove;
    data['from the cart?'] = this.fromTheCart;
    data['Check out'] = this.checkOut;
    data['Select Items to proceed to checkout'] =
        this.selectItemsToProceedToCheckout;
    data['Shipping Address'] = this.shippingAddress;
    data['Name'] = this.name;
    data['Address'] = this.address;
    data['Change'] = this.change;
    data['Bill to the Same Address'] = this.billToTheSameAddress;
    data['Add Address'] = this.addAddress;
    data['Shipping cost'] = this.shippingCost;
    data['Additional Shipping'] = this.additionalShipping;
    data['Tax'] = this.tax;
    data['Tax Amount'] = this.taxAmount;
    data['Qty'] = this.qty;
    data['Item(s), total=>'] = this.itemSTotal;
    data['Total TAX'] = this.totalTAX;
    data['Item(s), Grand Total=>'] = this.itemSGrandTotal;
    data['Enter coupon/voucher code'] = this.enterCouponVoucherCode;
    data['Apply'] = this.apply;
    data['Continue'] = this.continue1;
    data['Please Add Shipping and Billing Address'] =
        this.pleaseAddShippingAndBillingAddress;
    data['Please confirm the checkout'] = this.pleaseConfirmTheCheckout;
    data['Select Gateway'] = this.selectGateway;
    data['VAT included, where applicable'] = this.vATIncludedWhereApplicable;
    data['Order Confirm'] = this.orderConfirm;
    data['Select a Payment method first'] = this.selectAPaymentMethodFirst;
    data['All'] = this.all;
    data['Continue Shopping'] = this.continueShopping;
    data['Filter'] = this.filter;
    data['All Brands'] = this.allBrands;
    data['Filter Products'] = this.filterProducts;
    data['Child Category'] = this.childCategory;
    data['Rating'] = this.rating;
    data['and Up'] = this.andUp;
    data['Reset'] = this.reset;
    data['Apply Filter'] = this.applyFilter;
    data['Price Range'] = this.priceRange;
    data['Browse Gift Cards'] = this.browseGiftCards;
    data['Browse Products'] = this.browseProducts;
    data['Top Picks Products'] = this.topPicksProducts;
    data['User'] = this.user;
    data['Visit Store'] = this.visitStore;
    data['Store'] = this.store;
    data['Variant'] = this.variant;
    data['Specifications'] = this.specifications;
    data['Brand'] = this.brand;
    data['Model Number'] = this.modelNumber;
    data['None'] = this.none;
    data['Brand, Model, Specifications'] = this.brandModelSpecifications;
    data['Delivery'] = this.delivery;
    data['Highlights'] = this.highlights;
    data['Category'] = this.category;
    data['Tags'] = this.tags;
    data['Description'] = this.description;
    data['Ratings & Reviews'] = this.ratingsReviews;
    data['VIEW ALL'] = this.vIEWALL;
    data['Recommended by Seller'] = this.recommendedBySeller;
    data['Account Information'] = this.accountInformation;
    data['Change Name'] = this.changeName;
    data['Type First name'] = this.typeFirstName;
    data['Type Last name'] = this.typeLastName;
    data['Save'] = this.save;
    data['Mobile Number'] = this.mobileNumber;
    data['Email Address'] = this.emailAddress;
    data['Date of Birth'] = this.dateOfBirth;
    data['Update'] = this.update;
    data['Profile updated successfully'] = this.profileUpdatedSuccessfully;
    data['Update Profile Description'] = this.updateProfileDescription;
    data['Please Enter description'] = this.pleaseEnterDescription;
    data['Error'] = this.error;
    data['Please Type Email address'] = this.pleaseTypeEmailAddress;
    data['Select Country'] = this.selectCountry;
    data['Select State'] = this.selectState;
    data['Please Type Address'] = this.pleaseTypeAddress;
    data['Postal/Zip Code'] = this.postalZipCode;
    data['Please Type Postal/Zip code'] = this.pleaseTypePostalZipCode;
    data['Save Address'] = this.saveAddress;
    data['Address added successfully'] = this.addressAddedSuccessfully;
    data['Invalid Access token. Please re-login.'] =
        this.invalidAccessTokenPleaseReLogin;
    data['Select City'] = this.selectCity;
    data['No City found'] = this.noCityFound;
    data['My Address'] = this.myAddress;
    data['Default Billing'] = this.defaultBilling;
    data['Set to default billing address'] = this.setToDefaultBillingAddress;
    data['Address not found'] = this.addressNotFound;
    data['Set Default Billing'] = this.setDefaultBilling;
    data['Default Shipping'] = this.defaultShipping;
    data['Set to default Shipping address'] = this.setToDefaultShippingAddress;
    data['Set Default Shipping'] = this.setDefaultShipping;
    data['Edit'] = this.edit;
    data['Change Password'] = this.changePassword;
    data['Current Password'] = this.currentPassword;
    data['Type your current password'] = this.typeYourCurrentPassword;
    data['The password must be at least 8 characters.'] =
        this.thePasswordMustBeAtLeast8Characters;
    data['New Password'] = this.newPassword;
    data['Type your new password'] = this.typeYourNewPassword;
    data['Re-type Password'] = this.reTypePassword;
    data['Type password again'] = this.typePasswordAgain;
    data['The password confirmation does not match.'] =
        this.thePasswordConfirmationDoesNotMatch;
    data['Update Password'] = this.updatePassword;
    data['Password Updated successfully'] = this.passwordUpdatedSuccessfully;
    data['Edit Address'] = this.editAddress;
    data['Address deleted successfully'] = this.addressDeletedSuccessfully;
    data['Delete this Address'] = this.deleteThisAddress;
    data['Save Change'] = this.saveChange;
    data['Address updated successfully'] = this.addressUpdatedSuccessfully;
    data['Terms & Conditions'] = this.termsConditions;
    data['Address Book'] = this.addressBook;
    data['Receive exclusive offers & personal updates'] =
        this.receiveExclusiveOffersPersonalUpdates;
    data['Shop more'] = this.shopMore;
    data['Categories'] = this.categories;
    data['Change Currency'] = this.changeCurrency;
    data['Select Currency'] = this.selectCurrency;
    data['Back'] = this.back;
    data['Currency changed to'] = this.currencyChangedTo;
    data['Currency'] = this.currency;
    data['Full Name'] = this.fullName;
    data['Email'] = this.email;
    data['Phone Number'] = this.phoneNumber;
    data['To Pay'] = this.toPay;
    data['To Ship'] = this.toShip;
    data['To Receive'] = this.toReceive;
    data['Pending'] = this.pending;
    data['Cancelled'] = this.cancelled;
    data['Completed'] = this.completed;
    data['Confirmed'] = this.confirmed;
    data['Paid'] = this.paid;
    data['Wallet'] = this.wallet;
    data['Hello'] = this.hello;
    data['Home Page'] = this.homePage;
    data['All Products'] = this.allProducts;
    data['Logged out'] = this.loggedOut;
    data['Welcome to'] = this.welcomeTo;
    data['Notifications'] = this.notifications;
    data['Notification'] = this.notification;
    data['Forgot password?'] = this.forgotPassword1;
    data['Sign Up'] = this.signUp;
    data['Reset Password'] = this.resetPassword;
    data['Send'] = this.send;
    data['Coupons'] = this.coupons;
    data['TAX/GST/VAT Amount'] = this.tAXGSTVATAmount;
    data['Price dropped'] = this.priceDropped;
    data['Refund Requested on'] = this.refundRequestedOn;
    data['Refund Details'] = this.refundDetails;
    data['Request Sent Date'] = this.requestSentDate;
    data['Order Date'] = this.orderDate;
    data['Refund Method'] = this.refundMethod;
    data['Shipping Type'] = this.shippingType;
    data['Bank Transfer'] = this.bankTransfer;
    data['Please Type Branch Name'] = this.pleaseTypeBranchName;
    data['Account Holder Name'] = this.accountHolderName;
    data['Please Type Account holder name'] = this.pleaseTypeAccountHolderName;
    data['Branch Name'] = this.branchName;
    data['Please Type Bank name'] = this.pleaseTypeBankName;
    data['Bank Name'] = this.bankName;
    data['Courier Pickup Info'] = this.courierPickupInfo;
    data['Drop off Info'] = this.dropOffInfo;
    data['Shipping Method'] = this.shippingMethod;
    data['State'] = this.state;
    data['City'] = this.city;
    data['Postcode'] = this.postcode;
    data['Drop off Address'] = this.dropOffAddress;
    data['Type in Drop off Address'] = this.typeInDropOffAddress;
    data['Please type in your complete Bank Account Information'] =
        this.pleaseTypeInYourCompleteBankAccountInformation;
    data['Drop off'] = this.dropOff;
    data['Select Drop off'] = this.selectDropOff;
    data['Deal Starts in'] = this.dealStartsIn;
    data['Deal Ends in'] = this.dealEndsIn;
    data['Deal Ended'] = this.dealEnded;
    data['Product Specifications'] = this.productSpecifications;
    data['Availability'] = this.availability;
    data['In Stock'] = this.inStock;
    data['Not in stock'] = this.notInStock;
    data['Product SKU'] = this.productSKU;
    data['Minimum Order Quantity'] = this.minimumOrderQuantity;
    data['Maximum Order Quantity'] = this.maximumOrderQuantity;
    data['Related Products'] = this.relatedProducts;
    data['Up Sales Products'] = this.upSalesProducts;
    data['Cross Sales Products'] = this.crossSalesProducts;
    data['Out of Stock'] = this.outOfStock;
    data['View more'] = this.viewMore;
    data['Show less'] = this.showLess;
    data['Share'] = this.share;
    data['Search'] = this.search;
    data['Calculated at next step'] = this.calculatedAtNextStep;
    data['Checkout'] = this.checkout;
    data['VAT/TAX/GST included, where applicable'] =
        this.vATTAXGSTIncludedWhereApplicable;
    data['Proceed to Payment'] = this.proceedToPayment;
    data['Based on Flat Rate'] = this.basedOnFlatRate;
    data['Based on Per Hundred'] = this.basedOnPerHundred;
    data['Based on Per 100 Gm'] = this.basedOnPer100Gm;
    data['Total GST/TAX'] = this.totalGSTTAX;
    data['What is your phone number?'] = this.whatIsYourPhoneNumber;
    data['Enter your mobile number'] = this.enterYourMobileNumber;
    data['Please Enter your Mobile Number'] = this.pleaseEnterYourMobileNumber;
    data['We will send a code to your mobile number'] =
        this.weWillSendACodeToYourMobileNumber;
    data['Enter 6-digit verification code'] = this.enter6DigitVerificationCode;
    data['Enter the verification code, we have sent to'] =
        this.enterTheVerificationCodeWeHaveSentTo;
    data['OTP Timed out. Please resend OTP'] = this.oTPTimedOutPleaseResendOTP;
    data['OTP does not match'] = this.oTPDoesNotMatch;
    data['Resend OTP'] = this.resendOTP;
    data["You don't have sufficient wallet balance"] =
        this.youDonTHaveSufficientWalletBalance;
    data['Please Type first name'] = this.pleaseTypeFirstName;
    data['Please Type last name'] = this.pleaseTypeLastName;
    data['Please Type email'] = this.pleaseTypeEmail;
    data['Please Type password'] = this.pleaseTypePassword;
    data['Please Type confirm password'] = this.pleaseTypeConfirmPassword;
    data['Invalid email'] = this.invalidEmail;
    data['Subject'] = this.subject;
    data['Type Subject'] = this.typeSubject;
    data['Type Description'] = this.typeDescription;
    data['Attach Files'] = this.attachFiles;
    data['Submit'] = this.submit;
    data['Account Number'] = this.accountNumber;
    data['Please Type Account Number'] = this.pleaseTypeAccountNumber;
    data['Refund to'] = this.refundTo;
    data['By submitting this form, I accept'] =
        this.bySubmittingThisFormIAccept;
    data['Return Policy of'] = this.returnPolicyOf;
    data["Can't remove anymore"] = this.canTRemoveAnymore;
    data['Please select the product first!'] = this.pleaseSelectTheProductFirst;
    data["Can't add anymore"] = this.canTAddAnymore;
    data['Select a reason for returning'] = this.selectAReasonForReturning;
    data['Loading'] = this.loading;
    data['Country'] = this.country;
    data['Cancel Order'] = this.cancelOrder;
    data['Select Cancel Reason'] = this.selectCancelReason;
    data['Collect from'] = this.collectFrom;
    data['Order Cancelled'] = this.orderCancelled;
    data['Open Dispute'] = this.openDispute;
    data['Change your comment'] = this.changeYourComment;
    data['Write Review'] = this.writeReview;
    data['Warning'] = this.warning;
    data['Updated successfully'] = this.updatedSuccessfully;
    data['Reset password link sent'] = this.resetPasswordLinkSent;
    data['Please Type your email'] = this.pleaseTypeYourEmail;
    data['Please Type your password'] = this.pleaseTypeYourPassword;
    data["Don't have an account Yet?"] = this.donTHaveAnAccountYet1;
    data['Or continue with'] = this.orContinueWith;
    data['Next'] = this.next;
    data['Referral code'] = this.referralCode;
    data['SKU'] = this.sKU;
    data['Email Delivery'] = this.emailDelivery;
    data["Can't add less than"] = this.canTAddLessThan;
    data['Stock Available'] = this.stockAvailable;
    data['Home Delivery'] = this.homeDelivery;
    data['Pickup Location'] = this.pickupLocation;
    data['Select a pickup point'] = this.selectAPickupPoint;
    data['Billing Address'] = this.billingAddress;
    data['Item(s)'] = this.itemS;
    data['Collect from Pickup location'] = this.collectFromPickupLocation;
    data['Coupon Discount'] = this.couponDiscount;
    data['Grand Total'] = this.grandTotal;
    data['Minimum shopping amount'] = this.minimumShoppingAmount;
    data['without shipping cost'] = this.withoutShippingCost;
    data['Do you want to remove'] = this.doYouWantToRemove;
    data['Cart Price updated'] = this.cartPriceUpdated;
    data['Please check prices and shipping again'] =
        this.pleaseCheckPricesAndShippingAgain;
    data['OK'] = this.oK;
    data['Close'] = this.close;
    data['Paypal Payment'] = this.paypalPayment;
    data['Stripe Payment'] = this.stripePayment;
    data['Create Session'] = this.createSession;
    data['Open checkout page'] = this.openCheckoutPage;
    data['Order created successfully'] = this.orderCreatedSuccessfully;
    data['Order create unsuccessfully'] = this.orderCreateUnsuccessfully;
    data['Tabby Checkout'] = this.tabbyCheckout;
    data['Disabled for demo'] = this.disabledForDemo;
    data['Bank Payment'] = this.bankPayment;
    data['Payment Processing'] = this.paymentProcessing;
    data["Please don't close this until payment is complete"] =
        this.pleaseDonTCloseThisUntilPaymentIsComplete;
    data['Account holder'] = this.accountHolder;
    data['Type Bank name'] = this.typeBankName;
    data['Type Branch name'] = this.typeBranchName;
    data['Type Account Number'] = this.typeAccountNumber;
    data['Type Account Holder'] = this.typeAccountHolder;
    data['Attach Payment Slip'] = this.attachPaymentSlip;
    data['Payment Slip'] = this.paymentSlip;
    data['Invalid Access token'] = this.invalidAccessToken;
    data['Please re-login'] = this.pleaseReLogin;
    data['Please attach Payment slip'] = this.pleaseAttachPaymentSlip;
    data['Instamojo Payment'] = this.instamojoPayment;
    data['Payment failed'] = this.paymentFailed;
    data['Please try again'] = this.pleaseTryAgain;
    data['Jazzcash Payment'] = this.jazzcashPayment;
    data['Enter Your Phone Number'] = this.enterYourPhoneNumber;
    data['Type Phone number'] = this.typePhoneNumber;
    data['Midtrans Payment'] = this.midtransPayment;
    data['Gift Card'] = this.giftCard;
    data['Card Added successfully'] = this.cardAddedSuccessfully;
    data['No data available'] = this.noDataAvailable;
    data['Filter Seller Products'] = this.filterSellerProducts;
    data['Trusted'] = this.trusted;
    data['Member Since'] = this.memberSince;
    data['New Arrival'] = this.newArrival;
    data['Confirmation'] = this.confirmation;
    data['Are you sure want to delete account?'] =
        this.areYouSureWantToDeleteAccount;
    data['Change Mobile Number'] = this.changeMobileNumber;
    data['Phone'] = this.phone;
    data['Change Email Address'] = this.changeEmailAddress;
    data['Please Type Full Name'] = this.pleaseTypeFullName;
    data['Region'] = this.region;
    data['Notification Settings'] = this.notificationSettings;
    data['Select Language'] = this.selectLanguage;
    data['Delete Account'] = this.deleteAccount;
    data['Tickets'] = this.tickets;
    data['Ticket created successfully'] = this.ticketCreatedSuccessfully;
    data['Create Ticket'] = this.createTicket;
    data['Select Category'] = this.selectCategory;
    data['Select Priority'] = this.selectPriority;
    data['Support Ticket'] = this.supportTicket;
    data['Ticket ID'] = this.ticketID;
    data['Priority'] = this.priority;
    data['Last Updated'] = this.lastUpdated;
    data['Type a message here'] = this.typeAMessageHere;
    data['Error getting data'] = this.errorGettingData;
    data['End of Results'] = this.endOfResults;
    data['Create Ticket?'] = this.createTicket;
    data['Reload'] = this.reload;
    data['Send timeout in connection with API server'] =
        this.sendTimeoutInConnectionWithAPIServer;
    data['Receive timeout in connection with API server'] =
        this.receiveTimeoutInConnectionWithAPIServer;
    data['Request to API server was cancelled'] =
        this.requestToAPIServerWasCancelled;
    data['Connection timeout with API server'] =
        this.connectionTimeoutWithAPIServer;
    data['Internal server error'] = this.internalServerError;
    data['Bad request'] = this.badRequest;
    data['No data'] = this.noData;
    data['Success'] = this.success;
    data['Cash On Delivery'] = this.cashOnDelivery;
    data['No item found'] = this.noItemFound;
    data['Buy now'] = buyNow;
    data['Buy'] = buy;
    data['Purchase was cancelled'] = purchaseWasCancelled;
    data['Purchase Successful'] = purchaseSuccessful;
    data['Price'] = price;
    data['Please Sign in or Register to view notifications'] = pleaseSinInOrRegViewNotifications;
    data['Customer Login'] = customerLogin;

    return data;
  }

  @override
  String toString() => const JsonEncoder.withIndent(' ').convert(toJson());
}
