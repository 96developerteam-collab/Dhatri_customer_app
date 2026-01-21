# AmazCart - Application Analysis

## 📱 Project Overview
**AmazCart** is a comprehensive Flutter e-commerce mobile application with multi-theme support (AmazCart & Amazy themes). It's built for the Dhatri marketplace and supports both Android and iOS platforms.

---

## 🏗️ Architecture & Project Structure

### Core Technologies
- **Framework**: Flutter 3.0+
- **State Management**: GetX (Get package)
- **HTTP Client**: Dio, http package
- **Local Database**: Hive (with Hive Flutter)
- **UI Framework**: Flutter ScreenUtil (responsive design)
- **Payment Gateways**: 
  - Stripe
  - Razorpay
  - PayPal
  - Paytm
  - Jazz Cash
  - Flutterwave
  - Google Pay
  - Tabby (Buy Now Pay Later)
  - Paystack
  - Instamojo
  - Midtrans

### Key Dependencies
- **persistent_bottom_nav_bar**: Custom bottom navigation
- **badges**: Badge notifications on cart/messages
- **image_picker**: Gallery/camera image selection
- **file_picker**: File upload functionality
- **flutter_svg**: SVG asset rendering
- **cached_network_image**: Image caching
- **flutter_inappwebview**: WebView functionality
- **google_sign_in, flutter_facebook_auth**: Social authentication
- **purchases_flutter**: iOS in-app purchases
- **shared_preferences, get_storage**: Data persistence
- **intl**: Internationalization support
- **flutter_easyloading**: Loading indicators
- **flutter_stripe, razorpay_flutter, pay**: Payment processing

---

## 📂 Directory Structure

### `/lib/main.dart`
- App entry point with initialization
- Stripe & Tabby SDK setup
- Language & localization initialization
- Hive database initialization
- In-app purchase setup for iOS
- Two theme variants: AmazCart (main) and Amazy (alternative)

### `/lib/AppConfig/`
- **app_config.dart**: Application configuration
  - API host URL: https://dhatri.store
  - App name: "Dhatri"
  - Theme colors and assets
  - Login provider configuration (Google, Facebook, Apple)
  - Tabby merchant code

- **language/**: Internationalization system
  - Multi-language support
  - Language API service
  - App localizations

### `/lib/controller/` (29 Controllers)
**State Management Controllers:**
- `home_controller.dart`: Home page, categories, brands, products, flash deals
- `cart_controller.dart`: Shopping cart management
- `product_controller.dart`: Product data management
- `product_details_controller.dart`: Single product details
- `login_controller.dart`: Authentication (email, Google, Facebook)
- `account_controller.dart`: User account management
- `settings_controller.dart`: General settings & currency
- `payment_gateway_controller.dart`: Payment method selection
- `order_controller.dart`: Order history & tracking
- `order_cancel_controller.dart`: Order cancellation
- `order_refund_controller.dart`: Refund processing
- `my_coupon_controller.dart`: Coupon management
- `my_wishlist_controller.dart`: Wishlist management
- `gift_card_controller.dart`: Gift card handling
- `support_ticket_controller.dart`: Customer support tickets
- `seller_profile_controller.dart`: Seller information
- `review_controller.dart`: Product reviews
- `search_controllers.dart`: Search functionality
- `address_book_controller.dart`: Delivery addresses
- `checkout_controller.dart`: Checkout process
- `new_user_zone_controller.dart`: New user promotions
- `tag_controller.dart`: Product tags
- `otp_controller.dart`: OTP verification
- `cancelled_order_controller.dart`: Cancelled order history
- `navigation_controller.dart`: Navigation state
- `in-app-purchase_controller.dart`: iOS in-app purchases
- `language_controller.dart`: Language switching

### `/lib/model/` (Data Models)
**NewModel/** (Modern API models):
- Product models
- Cart models
- Order models
- Category & Brand models
- Payment models
- Shipping & Delivery models
- Customer data models
- Filter models
- Flash deal models
- Seller models
- Notification models

**Legacy Models**:
- UserModel, UserNotificationModel
- MyWishListModel, MyReviewListModel
- SupportTicketModel, etc.

### `/lib/view/`
Two parallel theme implementations:

**AmazCart Theme** (`amazcart_view/`):
- `MainNavigation.dart`: Bottom nav with 4 tabs (Home, Notifications, Cart, Account)
- `Home.dart`: Homepage with featured products, categories, brands
- **account/**: Account management (SignIn, Account, WishList, GiftCards)
- **cart/**: Shopping cart (CartMain, Checkout, GatewaySelection)
- **products/**: Product pages
  - category/: Category browsing
  - brand/: Brand browsing
  - product/: Product details
  - tags/: Tag-based products
  - giftCard/: Gift card products
- **payment/**: Payment processors
  - stripe/: Stripe integration
  - paypal/: PayPal integration
  - razorpay_sheet.dart: Razorpay
  - paytm_payment.dart: Paytm
  - jazzcash.dart: Jazz Cash
  - tabby/: Tabby BNPL
  - gpay_service.dart: Google Pay
  - And more...
- **messages/**: Notifications & messaging
- **marketing/**: Marketing/promotional pages
- **seller/**: Seller profile & store
- **settings/**: App settings
- **support/**: Customer support
- **authentication/**: Login/Register pages

**Amazy Theme** (`amazy_view/`):
- Alternative theme implementation with similar structure

### `/lib/network/`
- `logging_interceptor.dart`: HTTP request/response logging

### `/lib/database/`
- `auth_database.dart`: Local authentication database using Hive

### `/lib/utils/`
- `styles.dart`: Color schemes, typography
- `extensions/`: Dart extensions
- `theme.dart`: Theme definitions
- `theme_service.dart`: Theme switching service
- `app_utilities.dart`: Utility functions

### `/lib/widgets/`
**amazcart_widget/**: Custom UI components
- `custom_loading_widget.dart`: Loading indicators
- `snackbars.dart`: Toast notifications
- And other reusable widgets

**amazy_widget/**: Alternative theme widgets

### `/lib/bindings/`
- `home_bindings.dart`: Dependency injection for home screen
- `application_binding.dart`: Global dependency injection

### `/lib/config/`
- `config.dart`: URLs & API endpoints configuration

---

## 🔌 API Endpoints
**Base URL**: `https://dhatri.store/api`

Key endpoints:
- `/seller/products` - All products
- `/homepage-data` - Homepage content
- `/product/category` - Categories
- `/product/brand` - Brands
- `/login` - Authentication
- `/cart` - Shopping cart
- `/order` - Orders
- `/gift-card` - Gift cards
- And many more...

---

## 🎨 UI/UX Structure

### Navigation
- **Bottom Navigation Bar** (persistent_bottom_nav_bar)
  - Tab 1: Home (featured, categories, brands, products)
  - Tab 2: Notifications/Messages
  - Tab 3: Cart (with badge showing item count)
  - Tab 4: Account/Profile

### Key Screens
1. **Home**: Categories, brands, flash deals, recommended products
2. **Product Details**: Images, price, reviews, related products
3. **Cart**: Item management, coupon application, checkout
4. **Checkout**: Address selection, shipping method, payment gateway
5. **Payment**: Multiple payment method options
6. **Orders**: Order history, tracking, cancellation, returns
7. **Account**: Profile, addresses, wishlist, gift cards, settings
8. **Settings**: Currency, language, notifications
9. **Support**: Help, tickets, FAQs

---

## 🔐 Authentication & Security
- **Methods**: Email/Password, Google Sign-In, Facebook Login
- **Token Storage**: GetStorage (Secure storage with secure_storage package)
- **Token Key**: "token"
- **Device ID**: Unique device identification for tracking

---

## 💳 Payment Integration
**Supported Payment Methods**:
1. Card Payment (Stripe)
2. Razorpay
3. PayPal
4. Paytm
5. Jazz Cash
6. Flutterwave
7. Google Pay
8. Paystack
9. Instamojo
10. Midtrans
11. Tabby (BNPL)
12. Bank Transfer

---

## 🌍 Internationalization
- Multi-language support
- RTL support (Arabic, Urdu, etc.)
- Currency switching
- Language service API

---

## 📦 Build Configuration

### Android
- **Namespace**: com.amazcart.store
- **Compile SDK**: 35
- **Min SDK**: 16 (configurable)
- **Target SDK**: 31 (configurable)
- **Firebase**: Integrated
- **Google Services**: Configured
- **Signing**: Keystore setup (key.properties)

### iOS
- **Deployment Target**: Configurable
- **GoogleService-Info.plist**: Firebase configuration
- **Entitlements**: App capabilities

---

## 🚀 Features Summary

### Customer Features
✅ Product browsing (categories, brands, tags)
✅ Product search & filtering
✅ Product reviews & ratings
✅ Wishlist management
✅ Shopping cart
✅ Multiple payment methods
✅ Order tracking
✅ Order returns/refunds
✅ Gift card purchasing & redemption
✅ Coupon application
✅ Multiple delivery addresses
✅ In-app notifications
✅ Customer support tickets
✅ User account management
✅ Social authentication

### Admin/Seller Features (amazy_view)
✅ Seller profile management
✅ Flash deals management
✅ Brand management
✅ Category management
✅ Product management
✅ Inventory management
✅ Order management

### Technical Features
✅ Offline data caching
✅ Image caching & optimization
✅ Responsive design (ScreenUtil)
✅ RTL support
✅ Dark/Light theme support
✅ Comprehensive error handling
✅ Request logging & debugging
✅ In-app purchase (iOS)
✅ Deep linking (via WebView)
✅ WebView support for content

---

## 📊 State Management Strategy
- **GetX Controllers** for business logic
- **Reactive variables** (.obs) for UI updates
- **Get.put()** for dependency injection
- **Update()** for manual refresh
- **Obx()** widgets for reactivity

---

## 🔧 Key Technologies Summary
| Aspect | Technology |
|--------|-----------|
| UI Framework | Flutter |
| State Management | GetX |
| HTTP | Dio, http |
| Local DB | Hive |
| Auth | Email, Google, Facebook |
| Payments | Multiple (Stripe, Razorpay, etc.) |
| Analytics | (Firebase configured) |
| Responsive Design | ScreenUtil |
| Localization | Intl, custom service |
| WebView | flutter_inappwebview |

---

## 📋 Current Configuration
- **App Version**: 1.0.6+1
- **SDK**: Dart 3.0.0 - < 5.0.0
- **App Name**: Dhatri
- **Primary Theme**: AmazCart
- **API Host**: https://dhatri.store
- **Default Language Code**: (Configurable)
- **Demo Mode**: Disabled

---

**Status**: ✅ Ready for feature requests and modifications

