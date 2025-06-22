enum AppRoute {
  splash(path: '/splash'),
  signIn(path: '/signIn'),
  signUp(path: '/signUp'),
  takeSelfies(path: '/takeSelfies'),
  camera(path: '/camera'),
  beranda(path: '/beranda'),
  foto(path: '/foto'),
  profile(path: '/profile'),
  detailEvent(path: '/detail-event'),
  driveSearchDetail(path: '/drive-search-detail');

  final String path;
  const AppRoute({required this.path});
}
