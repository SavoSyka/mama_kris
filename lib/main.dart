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
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Асинхронно получаем начальный маршрут
    String initialRoute = await getInitialRoute();
    // Используем Navigator.pushReplacementNamed для перехода без возможности возвращения назад
    Navigator.of(context).pushReplacementNamed(initialRoute);
  }

  @override
  Widget build(BuildContext context) {
    print('loading1');
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
             return MaterialPageRoute(builder: (context) => RegistrationPage());//TODO: LoadingScreen()
          case '/start':
            return MaterialPageRoute(builder: (context) => StartPage());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginPage());
          case '/welcome':
            return MaterialPageRoute(builder: (context) => WelcomePage());
          case '/registration':
            return MaterialPageRoute(builder: (context) => RegistrationPage());
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
          case '/ch_without_va':
            return MaterialPageRoute(builder: (context) => ChoicePage());
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

class PDFScreen extends StatelessWidget {
  final String path;

  PDFScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: path,
      autoSpacing: false,
      enableSwipe: true,
      pageSnap: true,
      swipeHorizontal: true,
      nightMode: false,
    );
  }
}

