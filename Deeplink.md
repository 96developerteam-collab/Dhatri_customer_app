# Dhatri Deep Linking Implementation Guide (App Links & Universal Links)

This document outlines the steps to implement Deep Linking for the Dhatri customer app, ensuring that product links (e.g., `https://dhatri.store/product/pavan-rice`) open directly in the mobile app instead of a web browser.

---

## 1. Web & Backend Requirements (The "Handshake")

For a mobile OS to trust your app, you must host verification files on your domain.

### A. Android App Links
Host a file at: `https://dhatri.store/.well-known/assetlinks.json`

**Content:**
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.dhatri.store",
    "sha256_cert_fingerprints": [
      "YOUR_APP_SHA256_FINGERPRINT" 
    ]
  }
}]
```
*   **Note**: You can find the SHA256 fingerprint in the Google Play Console under "App Integrity" or by running `./gradlew signingReport` in the `android/` folder.

### B. iOS Universal Links
Host a file at: `https://dhatri.store/.well-known/apple-app-site-association`
*(Note: No file extension allowed)*

**Content:**
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "YOUR_TEAM_ID.com.dhatri.store",
        "paths": ["/product/*"]
      }
    ]
  }
}
```
*   **Note**: `YOUR_TEAM_ID` is found in your Apple Developer portal.

---

## 2. App-Level Implementation

### Android (`AndroidManifest.xml`)
Add this intent filter inside the `<activity>` tag of your `MainActivity`:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="dhatri.store" android:pathPrefix="/product" />
</intent-filter>
```

### iOS (Xcode)
1.  Open `ios/Runner.xcworkspace` in Xcode.
2.  Go to **Signing & Capabilities**.
3.  Add **Associated Domains**.
4.  Add the entry: `applinks:dhatri.store`.

---

## 3. Flutter Implementation

### Package Integration
Add `app_links` to your `pubspec.yaml`:
```yaml
dependencies:
  app_links: ^6.3.2
```

### Link Handling Logic
Create a service to listen for incoming links in `main.dart` or a controller:

```dart
final _appLinks = AppLinks();

// Subscribe to link changes
_appLinks.uriLinkStream.listen((uri) {
    print('Received link: $uri');
    handleDeepLink(uri);
});

void handleDeepLink(Uri uri) {
  if (uri.path.contains('/product/')) {
    String slug = uri.pathSegments.last;
    // Navigate to Product Details using the slug
    // Get.to(() => ProductDetails(slug: slug));
  }
}
```

---

## 4. Using Firebase (Optional but Recommended)

> [!WARNING]
> Google is deprecating **Firebase Dynamic Links** on August 25, 2025. It is recommended to use the native App Links method described above. However, you can still use Firebase for the following:

### A. Firebase Hosting for Verification Files
If your backend is complex to manage, you can host the `.well-known` files using **Firebase Hosting**. This is very fast and secure.

1.  Initialize Firebase Hosting in your project.
2.  Place the `assetlinks.json` and `apple-app-site-association` files in a `public/.well-known/` folder.
3.  Deploy: `firebase deploy`.

### B. Firebase Cloud Messaging (FCM) Integration
You can send Push Notifications that contain deep links. When the user taps the notification, the `app_links` listener will trigger, and the app will open the specific product.

### C. Analytics
Use **Firebase Analytics** to track which deep links are being clicked the most, allowing you to see which products are trending via social sharing.

---

## Checklist for Success
- [ ] Website has HTTPS enabled.
- [ ] `.well-known` files are accessible via browser at the exact URLs.
- [ ] `assetlinks.json` has the correct SHA256 (Release key for Play Store).
- [ ] `apple-app-site-association` has the correct Team ID.
- [ ] App is configured to handle the specific path `/product/*`.
    