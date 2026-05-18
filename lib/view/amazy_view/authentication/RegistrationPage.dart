import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/view/amazy_view/authentication/LoginPage.dart';
import 'package:amazcart/widgets/amazy_widget/snackbars.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../database/auth_database.dart';


class RegistrationPage extends GetView<LoginController> {
  final LoginController _accountController = Get.put(LoginController());
  final GeneralSettingsController _settingsController = Get.put(GeneralSettingsController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              _buildStickyHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildPersonalDetailsSection(),
                        SizedBox(height: 20.h),
                        _buildStoreInformationSection(),
                        SizedBox(height: 20.h),
                        _buildVerificationSection(context),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
              _buildStickyFooter(context),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: const Color(0xFF1A330F), size: 24.w),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: 12.w),
          Image.asset(
            AppConfig.appLogo,
            width: 45.w,
            height: 45.w,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create an Account'.tr,
                style: AppStyles.appFontBold.copyWith(
                  fontSize: 20.sp,
                  color: const Color(0xFF1A330F),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Join Dhatri Network'.tr,
                style: AppStyles.appFontMedium.copyWith(
                  fontSize: 10.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsSection() {
    return _buildSectionCard(
      title: 'PERSONAL DETAILS',
      icon: Icons.person_outline,
      children: [
        _buildTextField(
          controller: _accountController.firstName,
          hint: 'Enter first name',
          label: 'First Name *',
          icon: Icons.person_outline,
          validator: (value) => value?.trim().isEmpty ?? true ? 'Type First name'.tr : null,
        ),
        _buildTextField(
          controller: _accountController.lastName,
          hint: 'Enter last name',
          label: 'Last Name *',
          icon: Icons.person_outline,
          validator: (value) => value?.trim().isEmpty ?? true ? 'Type Last name'.tr : null,
        ),
        _buildTextField(
          controller: _accountController.registerEmail,
          hint: 'Enter phone number',
          label: 'Phone Number *',
          icon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter phone number'.tr;
            String digits = value!.replaceAll(RegExp(r'\D'), '');
            if (digits.length < 10) return 'Please enter a valid phone number'.tr;
            return null;
          },
        ),
        _buildTextField(
          controller: _accountController.registerPassword,
          hint: '********',
          label: 'Password *',
          icon: Icons.lock_outline,
          obscureText: true,
          validator: (value) => value?.isEmpty ?? true ? 'Please Type your password'.tr : null,
        ),
        _buildTextField(
          controller: _accountController.registerConfirmPassword,
          hint: '********',
          label: 'Confirm Password *',
          icon: Icons.lock_outline,
          obscureText: true,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Type password again'.tr;
            if (value != _accountController.registerPassword.text) return 'Password must be the same'.tr;
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStoreInformationSection() {
    return _buildSectionCard(
      title: 'STORE INFORMATION',
      icon: Icons.store_outlined,
      children: [
        _buildTextField(
          controller: _accountController.storeName,
          hint: 'Your business name',
          label: 'Store Name *',
          icon: Icons.store_outlined,
          validator: (value) => value?.trim().isEmpty ?? true ? 'Please enter store name'.tr : null,
        ),
        _buildTextField(
          controller: _accountController.gstNumber,
          hint: '22AAAAA0000A1Z5',
          label: 'GST Number  (optional)',
          icon: Icons.badge_outlined,
          validator: (_) => null,
        ),
        _buildTextField(
          controller: _accountController.referralCode,
          hint: 'Enter code',
          label: 'Referral code (optional)',
          icon: Icons.card_giftcard,
          validator: (_) => null,
        ),
      ],
    );
  }

  Widget _buildVerificationSection(BuildContext context) {
    return _buildSectionCard(
      title: 'VERIFICATION',
      icon: Icons.verified_outlined,
      children: [
        _buildFilePickerField(
          label: 'Store Documents *',
          subLabel: 'Tap to upload GST, MSME, etc.',
          file: _accountController.pickedDocument.value,
          icon: Icons.upload_file,
          onTap: () async {
            showModalBottomSheet(
              context: context,
              builder: (bc) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: Text('Upload from Gallery'.tr),
                      onTap: () async {
                        Navigator.pop(context);
                        final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          File file = File(image.path);
                          if (await _isFileSizeValid(file)) {
                            _accountController.pickedDocument.value = file;
                          }
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: Text('Take a Photo'.tr),
                      onTap: () async {
                        Navigator.pop(context);
                        final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (image != null) {
                          File file = File(image.path);
                          if (await _isFileSizeValid(file)) {
                            _accountController.pickedDocument.value = file;
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 15.h),
        _buildFilePickerField(
          label: 'SHOP Image *',
          subLabel: 'Upload storefront photo',
          file: _accountController.pickedShopImage.value,
          icon: Icons.image_outlined,
          onTap: () async {
            showModalBottomSheet(
              context: context,
              builder: (bc) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: Text('Upload from Gallery'.tr),
                      onTap: () async {
                        Navigator.pop(context);
                        final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          File file = File(image.path);
                          if (await _isFileSizeValid(file)) {
                            _accountController.pickedShopImage.value = file;
                          }
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: Text('Take a Photo'.tr),
                      onTap: () async {
                        Navigator.pop(context);
                        final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (image != null) {
                          File file = File(image.path);
                          if (await _isFileSizeValid(file)) {
                            _accountController.pickedShopImage.value = file;
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 15.h),
        _buildWarehouseSelectionField(),
        SizedBox(height: 15.h),
        _buildLocationCaptureField(context),
      ],
    );
  }

  Widget _buildLocationCaptureField(BuildContext context) {
    return Obx(() => Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: const Color(0xFF1A330F), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                'Shop Location *'.tr,
                style: AppStyles.appFontBold.copyWith(fontSize: 14.sp, color: const Color(0xFF1A330F)),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'We need your exact shop location for delivery and verification.'.tr,
            style: AppStyles.appFontMedium.copyWith(fontSize: 11.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: () => _captureLocation(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: _accountController.latitude.value != null ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: _accountController.latitude.value != null ? const Color(0xFF698F34) : Colors.grey.shade400,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _accountController.latitude.value != null ? Icons.check_circle : Icons.my_location,
                    color: _accountController.latitude.value != null ? const Color(0xFF698F34) : Colors.grey[700],
                    size: 18.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _accountController.latitude.value != null 
                        ? 'Location Captured ✅'.tr 
                        : 'Capture Current Location'.tr,
                    style: AppStyles.appFontBold.copyWith(
                      color: _accountController.latitude.value != null ? const Color(0xFF698F34) : Colors.grey[700],
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_accountController.latitude.value != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'Lat: ${_accountController.latitude.value!.toStringAsFixed(6)}, Long: ${_accountController.longitude.value!.toStringAsFixed(6)}',
                style: AppStyles.appFontMedium.copyWith(fontSize: 10.sp, color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    ));
  }

  Future<void> _captureLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SnackBars().snackBarWarning('Location services are disabled. Opening settings...'.tr);
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SnackBars().snackBarError('Location permissions are denied'.tr);
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      SnackBars().snackBarError('Location permissions are permanently denied, we cannot request permissions.'.tr);
      return;
    } 

    _accountController.isLoading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _accountController.latitude.value = position.latitude;
      _accountController.longitude.value = position.longitude;
      
      debugPrint("--- Location Captured ---");
      debugPrint("Latitude: ${position.latitude}");
      debugPrint("Longitude: ${position.longitude}");
      
      SnackBars().snackBarSuccess('Location captured successfully!'.tr);
    } catch (e) {
      debugPrint("Error capturing location: $e");
      SnackBars().snackBarError('Could not capture location. Please try again.'.tr);
    } finally {
      _accountController.isLoading.value = false;
    }
  }

  Widget _buildStickyFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sign Up Button
          _accountController.isLoading.value
              ? const Center(child: CupertinoActivityIndicator())
                : InkWell(
                    onTap: () {
                      debugPrint("--- Sign Up Button Tapped ---");
                      _handleSignUp(context);
                    },
                    child: Container(
                    width: double.infinity,
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF698F34),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign Up'.tr,
                          style: AppStyles.appFontBold.copyWith(color: Colors.white, fontSize: 16.sp),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 18.w),
                      ],
                    ),
                  ),
                ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => Get.back(),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Already have an account? '.tr,
                    style: AppStyles.appFontMedium.copyWith(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                  TextSpan(
                    text: 'Login'.tr,
                    style: AppStyles.appFontBold.copyWith(color: const Color(0xFF1A330F), fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Trusted banner
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user_outlined, color: Colors.grey[600], size: 14.w),
                SizedBox(width: 8.w),
                Text(
                  'TRUSTED BY 10,000+ RETAILERS'.tr,
                  style: AppStyles.appFontBold.copyWith(
                    color: Colors.grey[600], 
                    fontSize: 10.sp, 
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignUp(BuildContext context) async {
    debugPrint("--- Registration: Sign Up Clicked ---");
    if (!_formKey.currentState!.validate()) {
      debugPrint("--- Registration: Validation Failed ---");
      SnackBars().snackBarWarning("Please fill all required fields correctly".tr);
      return;
    }
    debugPrint("--- Registration: Validation Passed ---");
    if (_accountController.pickedDocument.value == null) {
      SnackBars().snackBarWarning("Please upload Store Documents".tr);
      return;
    }
    if (_accountController.pickedShopImage.value == null) {
      SnackBars().snackBarWarning("Please upload Shop Image".tr);
      return;
    }
    if (_accountController.selectedMerchant.value == null) {
      SnackBars().snackBarWarning("Please select Warehouse".tr);
      return;
    }
    if (_accountController.latitude.value == null) {
      SnackBars().snackBarWarning("Please capture your Shop Location".tr);
      return;
    }

    Map<String, dynamic> data = {
      "first_name": _accountController.firstName.text.trim(),
      "last_name": _accountController.lastName.text.trim(),
      "login": _accountController.registerEmail.text.trim(),
      "referral_code": _accountController.referralCode.text.trim(),
      "store_name": _accountController.storeName.text.trim(),
      "gst_number": _accountController.gstNumber.text.trim(),
      "warehouse_id": _accountController.selectedMerchant.value?.sellerAccount?.userId,
      "password": _accountController.registerPassword.text,
      "password_confirmation": _accountController.registerConfirmPassword.text,
      "user_type": "customer",
      "device_token": AuthDatabase.instance.getDeviceUniqueId(),
    };

    if (_settingsController.otpOnCustomerRegistration.value) {
      String phone = _accountController.registerEmail.text.trim();
      if (!phone.startsWith('+')) {
        if (phone.length == 10) {
          phone = '+91$phone';
        } else if (phone.length == 12 && phone.startsWith('91')) {
          phone = '+$phone';
        } else if (!phone.startsWith('+91')) {
          phone = '+91$phone';
        }
      }
      Map otpData = {
        "type": "otp_on_customer_registration",
        "phone": phone,
        "first_name": _accountController.firstName.text.trim(),
      };
      final OtpController otpController = Get.put(OtpController());
      _accountController.isLoading.value = true;
      var result = await otpController.generateOtp(otpData);
      _accountController.isLoading.value = false;

      if (result == true) {
        Get.to(() => OtpVerificationPage(
              data: otpData,
              onSuccess: (verified) async {
                if (verified == true) {
                  var result = await _accountController.registerUser(data);
                  if (result == true) {
                    debugPrint("--- Registration Success: Navigating to Login ---");
                    Get.offAll(() => LoginPage());
                  }
                }
              },
            ));
      } else {
        SnackBars().snackBarError(result is String ? result : "OTP generation failed".tr);
      }
    } else {
      var result = await _accountController.registerUser(data);
      if (result == true) {
        debugPrint("--- Registration Success: Navigating to Login ---");
        Get.offAll(() => LoginPage());
      }
    }
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.w, color: Colors.black87),
              SizedBox(width: 10.w),
              Text(
                title.tr,
                style: AppStyles.appFontBold.copyWith(fontSize: 14.sp, color: Colors.black87, letterSpacing: 0.5),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr,
          style: AppStyles.appFontBold.copyWith(fontSize: 12.sp, color: Colors.black87),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint.tr,
            hintStyle: AppStyles.appFontBook.copyWith(fontSize: 14.sp, color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20.w),
            filled: true,
            fillColor: const Color(0xFFF9F9F5),
            contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF1A330F)),
            ),
          ),
          style: AppStyles.appFontMedium.copyWith(fontSize: 14.sp),
          validator: validator,
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildFilePickerField({
    required String label,
    required String subLabel,
    required File? file,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr,
          style: AppStyles.appFontBold.copyWith(fontSize: 12.sp, color: Colors.black87),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(file == null ? icon : Icons.check_circle_outline, 
                     color: file == null ? Colors.grey[500] : const Color(0xFF2D5019), size: 30.w),
                SizedBox(height: 10.h),
                Text(
                  file == null ? subLabel.tr : "${file.path.split('/').last} (${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)}MB)",
                  style: AppStyles.appFontMedium.copyWith(
                    fontSize: 13.sp,
                    color: file == null ? Colors.grey[600] : const Color(0xFF2D5019),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarehouseSelectionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Warehouse *'.tr,
          style: AppStyles.appFontBold.copyWith(fontSize: 12.sp, color: Colors.black87),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => _showWarehouseSearchDialog(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.store_outlined, color: Colors.grey[400], size: 20.w),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    _accountController.selectedMerchant.value?.sellerWarehouseAddress?.warehouseName ?? 'Select nearest hub'.tr,
                    style: AppStyles.appFontMedium.copyWith(
                      fontSize: 14.sp,
                      color: _accountController.selectedMerchant.value == null ? Colors.grey[400] : Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[400], size: 20.w),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showWarehouseSearchDialog() {
    TextEditingController searchController = TextEditingController();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: searchController,
                onChanged: (value) => _accountController.searchMerchants(value),
                decoration: InputDecoration(
                  hintText: 'Search by name or address...'.tr,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (_accountController.isMerchantLoading.value) return const Center(child: CupertinoActivityIndicator());
                if (_accountController.filteredMerchants.isEmpty) return Center(child: Text('No warehouses found'.tr));
                return ListView.separated(
                  itemCount: _accountController.filteredMerchants.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final merchant = _accountController.filteredMerchants[index];
                    final warehouse = merchant.sellerWarehouseAddress;
                    return ListTile(
                      title: Text(warehouse?.warehouseName ?? '', style: AppStyles.appFontBold.copyWith(fontSize: 16.sp)),
                      subtitle: Text(warehouse?.warehouseAddress ?? '', style: AppStyles.appFontBook.copyWith(fontSize: 14.sp)),
                      onTap: () {
                        _accountController.selectedMerchant.value = merchant;
                        _accountController.filteredMerchants.value = _accountController.merchants;
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    ).then((_) => _accountController.filteredMerchants.value = _accountController.merchants);
  }

  Future<bool> _isFileSizeValid(File file) async {
    int sizeInBytes = await file.length();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 10) {
      SnackBars().snackBarWarning("File size exceeds 10MB limit. Current size: ${sizeInMb.toStringAsFixed(2)}MB".tr);
      return false;
    }
    return true;
  }
}