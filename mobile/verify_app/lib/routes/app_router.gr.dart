// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:verify_app/features/auth/presentation/screens/login_screen.dart'
    as _i1;
import 'package:verify_app/features/auth/presentation/screens/registration_screen.dart'
    as _i2;
import 'package:verify_app/features/auth/presentation/screens/scan_creen.dart'
    as _i3;
import 'package:verify_app/features/auth/presentation/screens/welcome_screen.dart'
    as _i4;

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute({List<_i5.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginScreen();
    },
  );
}

/// generated route for
/// [_i2.RegistrationScreen]
class RegistrationRoute extends _i5.PageRouteInfo<void> {
  const RegistrationRoute({List<_i5.PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i3.ScanScreen]
class ScanRoute extends _i5.PageRouteInfo<void> {
  const ScanRoute({List<_i5.PageRouteInfo>? children})
    : super(ScanRoute.name, initialChildren: children);

  static const String name = 'ScanRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.ScanScreen();
    },
  );
}

/// generated route for
/// [_i4.WelcomeScreen]
class WelcomeRoute extends _i5.PageRouteInfo<void> {
  const WelcomeRoute({List<_i5.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.WelcomeScreen();
    },
  );
}
