class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const locationAdd = '/locations/add';

  static String locationEditPath(String id) => '/locations/$id/edit';
}
