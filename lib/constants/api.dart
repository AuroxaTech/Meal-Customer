// import 'package:velocity_x/velocity_x.dart';

class Api {
  // return "http://mealknight.truedemo.online/api";    2
  // return "http://192.168.100.3:8000/api";    1
  //return "http://15.222.4.249/api";

  static const baseUrl = "https://mealknight.ca/api";

  static const appSettings = "/app/settings";
  static const appOnboardings = "/app/onboarding?type=customer";
  static const faqs = "/app/faqs?type=customer";

  static const accountDelete = "/account/delete";
  static const tokenSync = "/device/token/sync";
  static const login = "/login";
  static const qrlogin = "/login/qrcode";
  static const register = "/register";
  static const logout = "/logout";
  static const forgotPassword = "/password/reset/init";
  static const verifyPhoneAccount = "/verify/phone";
  static const updateProfile = "/profile/update";
  static const updatePassword = "/profile/password/update";

  //
  static const sendOtp = "/otp/send";
  static const verifyOtp = "/otp/verify";
  static const verifyFirebaseOtp = "/otp/firebase/verify";
  static const socialLogin = "/social/login";

  //
  static const banners = "/banners";
  static const categories = "/categories";
  static const products = "/products";
  static const services = "/services";
  static const bestProducts = "/products?type=best";
  static const forYouProducts = "/products?type=you";
  static const vendorTypes = "/vendor/types";
  static const vendors = "/vendors";
  static const user_vendors = "/user/vendors";
  static const vendorReviews = "/vendor/reviews";
  static const topVendors = "/vendors?type=top";
  static const bestVendors = "/vendors?type=best";

  static const search = "/search";
  static const tags = "/tags";
  static const searchData = "/search/data";
  static const favourites = "/favourites";
  static const favouritesVendor = "/favourite-vendors";

  //cart & checkout
  static const coupons = "/coupons";
  static const deliveryAddresses = "/delivery/addresses";
  static const paymentMethods = "/payment/methods";
  static const orders = "/orders";
  static const trackOrder = "/track/order";
  static const packageOrders = "/package/orders";
  static const packageOrderSummary = "/package/order/summary";
  static const generalOrderSummary = "/general/order/summary";
  static const chat = "/chat/notification";
  static const rating = "/rating";
  static const orderPayment = "/pay/square-up";

  //packages
  static const packageTypes = "/package/types";
  static const packageVendors = "/package/order/vendors";

  //Taxi booking
  static const vehicleTypes = "/vehicle/types";
  static const vehicleTypePricing = "/vehicle/types/pricing";
  static const newTaxiBooking = "/taxi/book/order";
  static const currentTaxiBooking = "/taxi/current/order";
  static const cancelTaxiBooking = "/taxi/order/cancel";
  static const taxiDriverInfo = "/taxi/driver/info";
  static const taxiLocationAvailable = "/taxi/location/available";
  static const taxiTripLocationHistory = "/taxi/location/history";

  //wallet
  static const walletBalance = "/wallet/balance";
  static const walletTopUp = "/wallet/topup";
  static const walletTransactions = "/wallet/transactions";
  static const myWalletAddress = "/wallet/my/address";
  static const walletAddressesSearch = "/wallet/address/search";
  static const walletTransfer = "/wallet/address/transfer";

  //loyaltypoints
  static const myLoyaltyPoints = "/loyalty/point/my";
  static const loyaltyPointsWithdraw = "/loyalty/point/my/withdraw";
  static const loyaltyPointsReport = "/loyalty/point/my/report";

  //map
  static const geocoderForward = "/geocoder/forward";
  static const geocoderReserve = "/geocoder/2/reserve";
  static const geocoderPlaceDetails = "/geocoder/place/details";

  //reviews
  static const productReviewSummary = "/product/review/summary";
  static const productReviews = "/product/reviews";
  static const productBoughtFrequent = "/product/frequent";

  //flash sales
  static const flashSales = "/flash/sales";
  static const externalRedirect = "/external/redirect";
  static const ticketList = "/ticket/list";
  static const ticketReply = "/ticket/reply";
  static const closeTicket = "/ticket/close";
  static const createTicket = "/ticket/create";
  //
  static const cancellationReasons = "/cancellation/reasons";

  // Other pages
  static String get privacyPolicy {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/privacy/policy";
  }

  static String get terms {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/pages/terms";
  }

  static String get contactUs {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/pages/contact";
  }

  static String get inappSupport {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/support/chat";
  }

  static String get appShareLink {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/preview/share";
  }
}
