enum AppRoute {
  splash(path: '/splash'),
  auth(path: '/auth');

  final String path;
  const AppRoute({required this.path});
}
