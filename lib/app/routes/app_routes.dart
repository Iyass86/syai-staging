abstract class AppRoutes {
  // Base Routes
  static const initial = '/';
  static const notFound = '/404';

  // Auth Routes
  static const login = '/login';
  static const register = '/register';
  static const oauthCallback = '/auth/callback';
  static const snapOauthCallback = '/auth/snap/callback';

  // Feature Routes
  static const chat = '/chat';
  static const dashboard = '/dashboard';
  static const snapAuth = '/snap_auth';
  static const socialMediaPage = '/social_media_page';
  static const snapAccounts = '/snap-accounts';
  static const snapOrganizations = '/snap-organizations';
  static const errorTest = '/error-test';
}
