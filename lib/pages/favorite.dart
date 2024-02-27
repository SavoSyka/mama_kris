import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 1; // Индекс для отслеживания текущего выбранного элемента

  // Список виджетов для каждой страницы
  final List<Widget> _widgetOptions = [
    Text('Главная'), // Замените на ваш виджет для /tinder
    Text('Проекты'), // Замените на ваш виджет для /projects
    Text('Профиль'), // Замените на ваш виджет для /profile
    Text('Поддержка'), // Замените на ваш виджет для /support
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch(index) {
      case 0:
        Navigator.pushNamed(context, '/tinder');
        break;
      case 1:
        Navigator.pushNamed(context, '/projects');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushNamed(context, '/support');
        break;
    }
  }
  Future<List<DocumentSnapshot>> getLikedJobs() async {
    User? user = _auth.currentUser;
    List<DocumentSnapshot> likedJobs = [];
    if (user != null) {
      var userActionsDoc = await _firestore.collection('userActions').doc(user.uid).get();
      List<dynamic> likedJobsIds = userActionsDoc.data()?['likes'] ?? [];
      for (String jobId in likedJobsIds) {
        var jobDoc = await _firestore.collection('jobs').doc(jobId).get();
        if (jobDoc.exists) {
          likedJobs.add(jobDoc);
        }
      }
    }
    return likedJobs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Лайкнутые объявления"),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: getLikedJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Произошла ошибка"));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text("Нет лайкнутых объявлений"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var jobData = snapshot.data![index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(jobData['title'] ?? 'Без названия'),
                  subtitle: Text(jobData['description'] ?? 'Без описания'),
                  onTap: () {
                    // Показываем AlertDialog с контактами
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Контакты работодателя'),
                          content: Text(jobData['contactLink'] ?? 'Нет контактов'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Закрыть'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Закрываем диалог
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_sharp),
            label: 'Проекты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_sharp),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF93D56F),
        unselectedItemColor: Colors.grey, // Цвет неактивных элементов+
        onTap: _onItemTapped,
      ),
    );
  }
}
