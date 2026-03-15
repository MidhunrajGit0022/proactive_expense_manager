class AppConstants {
  static const String baseUrl = 'https://appskilltest.zybotech.in';

  static const String sendOtpPath = '/auth/send-otp/';
  static const String createAccountPath = '/auth/create-account/';

  static const String categoriesPath = '/categories/';
  static const String addCategoryPath = '/categories/add/';
  static const String deleteCategoriesPath = '/categories/delete/';

  static const String transactionsPath = '/transactions/';
  static const String addTransactionsPath = '/transactions/add/';
  static const String deleteTransactionsPath = '/transactions/delete/';

  static const String authTokenKey = 'auth_token';
  static const String nicknameKey = 'nickname';
  static const String phoneKey = 'phone';
  static const String budgetLimitKey = 'budget_limit';

  static const int otpLength = 6;
  static const int otpResendSeconds = 30;

  static const double defaultBudgetLimit = 1000.0;
}
