class GoogleAuthConfig {
  // Web client ID is needed for web platform support
  static const String webClientId =
      '425965460296-hi3u74h2css3bhin8rebopef0r7nol66.apps.googleusercontent.com'; // Replace with your web client ID from Google Cloud Console

  // iOS client ID is needed for iOS platform support
  static const String iosClientId =
      'YOUR_IOS_CLIENT_ID'; // Replace with your iOS client ID from Google Cloud Console

  // Note: Android doesn't need a client ID in code
  // It uses the package name from AndroidManifest.xml and
  // the SHA-1 fingerprint you register in Google Cloud Console
}
