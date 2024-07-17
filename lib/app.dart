import 'package:mEyeApp/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:misrut_core/misrut_core.dart';

class MyApp extends StatefulWidget {
  final AppRepository appRepository;
  final APIRepository apiRepository;
  final UserRepository userRepository;
  final StorageRepository storageRepository;
  final ThemeRepository themeRepository;

  const MyApp({
    Key? key,
    required this.appRepository,
    required this.apiRepository,
    required this.userRepository,
    required this.storageRepository,
    required this.themeRepository,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRepository _appRepository;
  late final APIRepository _apiRepository;
  late final UserRepository _userRepository;
  late final StorageRepository _storageRepository;
  late final ThemeRepository _themeRepository;

  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    _appRepository = widget.appRepository;
    _apiRepository = widget.apiRepository;
    _userRepository = widget.userRepository;
    _storageRepository = widget.storageRepository;
    _themeRepository = widget.themeRepository;
    router = MyRouter().router;
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppRepository>.value(
          value: _appRepository,
        ),
        RepositoryProvider<APIRepository>.value(
          value: _apiRepository,
        ),
        RepositoryProvider<UserRepository>.value(
          value: _userRepository,
        ),
        RepositoryProvider<StorageRepository>.value(
          value: _storageRepository,
        ),
        RepositoryProvider<ThemeRepository>.value(
          value: _themeRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) => AppBloc(
              apiRepository: _apiRepository,
              userRepository: _userRepository,
              appRepository: _appRepository,
              storageRepository: _storageRepository,
            )..add(const AppStarted()),
          )
        ],
        child: AppView(router: router),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  final GoRouter router;

  const AppView({
    super.key,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: context.read<ThemeRepository>().getColorScheme(),
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Raleway'),
      ),
    );
  }
}
