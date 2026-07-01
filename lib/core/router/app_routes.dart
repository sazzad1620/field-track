class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const locationAdd = '/locations/add';
  static const profileEdit = '/profile/edit';
  static const profileNotifications = '/profile/notifications';
  static const profileSettings = '/profile/settings';
  static const profileHelp = '/profile/help';

  static String locationEditPath(String id) => '/locations/$id/edit';
}
