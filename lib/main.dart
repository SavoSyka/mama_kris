  import 'package:flutter/material.dart';
  import 'package:flutter_localizations/flutter_localizations.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_core/firebase_core.dart'; // Добавьте этот импорт
  import 'package:mama_kris/pages/favorite.dart';
  import 'package:mama_kris/pages/login.dart'; // Импортируем login.dart
  import 'package:mama_kris/pages/start.dart';
  import 'package:mama_kris/pages/welcome.dart';
  import 'package:mama_kris/pages/registration.dart';
  import 'package:mama_kris/pages/home.dart';
  import 'package:mama_kris/pages/verififcation.dart';
  import 'package:mama_kris/pages/choice.dart';
  import 'package:mama_kris/pages/job_create.dart';
  import 'package:mama_kris/pages/search.dart';
  import 'package:mama_kris/pages/tinder.dart';
  import 'package:mama_kris/pages/support.dart';
  import 'package:mama_kris/pages/profile.dart';
  import 'package:mama_kris/pages/employer_list.dart';
  import 'package:mama_kris/pages/profile_empl.dart';
  import 'package:mama_kris/pages/support_empl.dart';
  import 'package:mama_kris/pages/conf.dart';
  import 'package:mama_kris/pages/subscription.dart';
  import 'package:mama_kris/pages/pass_reset.dart';
  import 'package:mama_kris/test.dart';
  import 'package:mama_kris/pages/update.dart';
  import 'package:mama_kris/pages/thx_empl.dart';
  import 'package:mama_kris/pages/thx_ee.dart';

  import 'package:firebase_remote_config/firebase_remote_config.dart';
  import 'package:package_info_plus/package_info_plus.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC6JKIXtGJPlYYv30hfQXlcyukdzwem_tA", // replace with your own value
        projectId: "mamakris-0", // replace with your own value
        messagingSenderId: "86099763542", // replace with your own value
        appId: "1:86099763542:android:7c7fd22ae44e007753f6f7", // replace with your own value
      ),
    );
    runApp(MyApp());
  }

  class LoadingScreen extends StatefulWidget {
    @override
    _LoadingScreenState createState() => _LoadingScreenState();
  }

  class _LoadingScreenState extends State<LoadingScreen> {
    @override
    void initState() {
      super.initState();
      _checkVersion();
    }

    Future<void> _checkVersion() async {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(minutes: 0),  //TODO: hours:1
      ));
      bool updated = await remoteConfig.fetchAndActivate();
      if (updated) {
        print("Конфигурация успешно обновлена из Firebase.");
      } else {
        print("Используется кэшированная конфигурация.");
      }

      final String minRequiredVersion = remoteConfig.getString('min_required_version');
      print(currentVersion);
      print(minRequiredVersion);

      if (_compareVersion(currentVersion, minRequiredVersion) < 0) {
        _navigateToUpdatePage();
      }
      else{
        _navigateToNextScreen();
      }
    }

    int _compareVersion(String currentVersion, String minRequiredVersion) {
      List<int> currentVersionList = currentVersion.split('.').map(int.parse).toList();
      List<int> minRequiredVersionList = minRequiredVersion.split('.').map(int.parse).toList();

      for (int i = 0; i < currentVersionList.length; i++) {
        if (i >= minRequiredVersionList.length || currentVersionList[i] > minRequiredVersionList[i]) {
          return 1;
        } else if (currentVersionList[i] < minRequiredVersionList[i]) {
          return -1;
        }
      }
      return 0;
    }

    void _navigateToUpdatePage() { //TODO: вернуть переход на страницу с обновлением
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (context) => UpdateAppPage(
      //     appStoreUrl: 'https://www.apple.com/app-store/',
      //     playStoreUrl: 'https://play.google.com/store/search?q=MamaKris&c=apps',
      //   ),
      // ));
      _navigateToNextScreen(); //TODO: это надо будте убрать
    }
    void _navigateToNextScreen() async {

      // Асинхронно получаем начальный маршрут
      String initialRoute = await getInitialRoute();
      // Используем Navigator.pushReplacementNamed для перехода без возможности возвращения назад
      Navigator.of(context).pushReplacementNamed(initialRoute);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Индикатор загрузки
      );
    }
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'MamaKris',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('ru', ''), // Russian, no country code
        ],
        // Удаляем initialRoute и routes
        // Добавляем onGenerateRoute
        //initialRoute: initialRoute, // Используем полученный начальный маршрут
        onGenerateRoute: (settings) {
          // Получаем имя маршрута
          final name = settings.name;
          // Возвращаем MaterialPageRoute в зависимости от имени маршрута
          switch (name) {
             case '/':
               return MaterialPageRoute(builder: (context) => LoadingScreen());//TODO: LoadingScreen()
            case '/start':
              return MaterialPageRoute(builder: (context) => StartPage());
            case '/login':
              return MaterialPageRoute(builder: (context) => LoginPage());
            case '/welcome':
              return MaterialPageRoute(builder: (context) => WelcomePage());
            case '/registration':
              return MaterialPageRoute(builder: (context) => RegistrationPage());
            case '/ch_without_va':
              return MaterialPageRoute(builder: (context) => ChoicePage());
            case '/job':
              return MaterialPageRoute(builder: (context) => JobPage());
            case '/search':
              return MaterialPageRoute(builder: (context) => JobSearchPage());
            case '/home':
              return MaterialPageRoute(builder: (context) => StartPage());
            case '/tinder':
              return MaterialPageRoute(builder: (context) => TinderPage());
            case '/support':
              return MaterialPageRoute(builder: (context) => SupportPage());
            case '/support_empl':
              return MaterialPageRoute(builder: (context) => SupportEmplPage());
            case '/profile':
              return MaterialPageRoute(builder: (context) => ProfilePage());
             case '/profile_empl':
               return MaterialPageRoute(builder: (context) => ProfileEmplPage());
            case '/empl_list':
              return MaterialPageRoute(builder: (context) => JobsListPage());
            case '/projects':
              return MaterialPageRoute(builder: (context) => FavoritePage());
            case '/subscribe':
              return MaterialPageRoute(builder: (context) => SubscriptionPage());
            case '/reset':
              return MaterialPageRoute(builder: (context) => ResetPasswordPage());
            case '/choice':
            // Проверяем, подтверждена ли почта пользователя
              final emailVerified =
                  FirebaseAuth.instance.currentUser?.emailVerified ?? false;
              // Если да, то показываем ChoicePage
              if (emailVerified) {
                return MaterialPageRoute(builder: (context) => ChoicePage());
              } else {
                // Если нет, то показываем VerificationPage
                return MaterialPageRoute(builder: (context) => VerificationPage());
              }
            case '/verification':
              return MaterialPageRoute(builder: (context) => VerificationPage());
            default:
            // Если имя маршрута неизвестно, то показываем страницу с ошибкой
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(
                    child: Text('Страница не найдена'),
                  ),
                ),
              );
          }
        },
      );
    }
  }


