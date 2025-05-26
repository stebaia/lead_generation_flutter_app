class DebugHelper {
  static const bool enableDebugMode = true; // Set to false in production

  // Test credentials that should always fail
  static const String testFailEmail = "test@fail.com";
  static const String testFailPassword = "wrongpassword";

  // Check if we should simulate a login error for testing
  static bool shouldSimulateLoginError(String email, String password) {
    if (!enableDebugMode) return false;

    return email == testFailEmail || password == testFailPassword;
  }

  // Simulate different types of login errors for testing
  static Exception getSimulatedError(String email, String password) {
    if (email == testFailEmail) {
      return Exception('Invalid credentials');
    }
    if (password == testFailPassword) {
      return Exception('Invalid credentials');
    }
    return Exception('Invalid credentials');
  }
}
