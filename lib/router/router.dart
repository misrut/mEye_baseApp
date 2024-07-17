import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:misrut_core/misrut_core.dart';
// import 'package:mEyeApp/screens/onboarding/onboarding_page.dart';

class MyRouter {
  MyRouter();

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router {
    return appRouter;
  }

  GoRouter get appRouter => GoRouter(
        initialLocation: '/home',
        debugLogDiagnostics: true,
        navigatorKey: _rootNavigatorKey,
        routes: [
          ShellRoute(
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state, child) {
              // FlutterNativeSplash.remove();
              return NoTransitionPage(
                child: MiAppWrapper(
                  child: child,
                ),
              );
            },
            routes: [
              // GoRoute(
              //   name: OnboardingPage.name,
              //   path: OnboardingPage.path,
              //   builder: (context, state) {
              //     Map<String, dynamic> args =
              //         (state.extra as Map?)?.cast<String, dynamic>() ?? {};
              //     args['route'] = state.fullPath;
              //     return OnboardingPage(
              //       pageArgs: args,
              //     );
              //   },
              // ),
              GoRoute(
                name: DefaultPage.name,
                path: "/:route1",
                builder: (context, state) {
                  Map<String, dynamic> args =
                      (state.extra as Map?)?.cast<String, dynamic>() ?? {};
                  args.addEntries(state.pathParameters.entries);
                  args.addEntries(state.uri.queryParameters.entries);
                  args['route'] = state.matchedLocation;
                  return DefaultPage(
                    key: Key(args.toString()),
                    pageArgs: args,
                  );
                },
                routes: [
                  GoRoute(
                    name: "route2",
                    path: ":route2",
                    builder: (context, state) {
                      Map<String, dynamic> args =
                          (state.extra as Map?)?.cast<String, dynamic>() ?? {};
                      args.addEntries(state.pathParameters.entries);
                      args.addEntries(state.uri.queryParameters.entries);
                      args['route'] = state.matchedLocation;
                      return DefaultPage(
                        key: Key(args.toString()),
                        pageArgs: args,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}


  // initialLocation: Uri(
  //     path: MerchantNewPage.path,
  //     queryParameters: {"MERCH_UNIQUE_URL": "xyz.com"}).toString(),