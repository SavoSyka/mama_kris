import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:mama_kris/wave.dart';
import 'package:mama_kris/icon.dart';

class TinderPage extends StatefulWidget {
  @override
  TinderPageState createState() => TinderPageState();
}


class TinderPageState extends State<TinderPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _likedJobsIds = [];
  List<String> _dislikedJobsIds = [];
  DocumentSnapshot? _randomJob;
  int _selectedIndex = 0; // Индекс для отслеживания текущего выбранного элемента
  bool _isLoading = true; // Индикатор загрузки


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


  @override
  void initState() {
    super.initState();
    _loadActionsAndFetchRandomJob();
  }

  Future<void> _loadActionsAndFetchRandomJob() async {
    await _loadActionsIds();
    await _fetchRandomJob();
  }

  Future<void> _loadActionsIds() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final docSnapshot = await _firestore.collection('userActions').doc(user.uid).get();
      if (docSnapshot.exists) {
        setState(() {
          _likedJobsIds = List.from(docSnapshot.data()?['likes'] ?? []);
          _dislikedJobsIds = List.from(docSnapshot.data()?['dislikes'] ?? []);
        });
      }
    }
  }

  Future<void> _markJobAsLiked(String jobId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('userActions').doc(user.uid).set({
        'likes': FieldValue.arrayUnion([jobId])
      }, SetOptions(merge: true));
      _likedJobsIds.add(jobId);
    }
  }

  Future<void> _markJobAsDisliked(String jobId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('userActions').doc(user.uid).set({
        'dislikes': FieldValue.arrayUnion([jobId])
      }, SetOptions(merge: true));
      _dislikedJobsIds.add(jobId);
    }
  }

  Future<void> _fetchRandomJob() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .where('status', isEqualTo: 'approved') // Фильтр по статусу 'approved'

  // .where('jobType', isEqualTo: 'desiredJobType') // Условие для jobType
    // .where('sphere', isEqualTo: 'desiredSphere') // Условие для sphere
        .get();

    final allJobsIds = querySnapshot.docs.map((doc) => doc.id).toList();
    final unviewedJobsIds = allJobsIds.where((id) => !_likedJobsIds.contains(id) && !_dislikedJobsIds.contains(id)).toList();

    if (unviewedJobsIds.isNotEmpty) {
      final randomIndex = Random().nextInt(unviewedJobsIds.length);
      final randomJobId = unviewedJobsIds[randomIndex];
      setState(() {
        _randomJob = querySnapshot.docs.firstWhere((doc) => doc.id == randomJobId);
        _isLoading = false; // Загрузка завершена
      });
    } else {
      setState(() {
        _randomJob = null;
        _isLoading = false; // Загрузка завершена
      });
    }
  }

  void _likeJob(String jobId) async {
    await _markJobAsLiked(jobId); // Помечаем вакансию как просмотренную

    // Получаем контакты работодателя из _randomJob
    String employerContacts = _randomJob!['contactLink'] ?? 'Нет контактов';

    // Показываем AlertDialog с контактами
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Контакты работодателя'),
          content: Text(employerContacts),
          actions: <Widget>[
            TextButton(
              child: const Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
            ),
          ],
        );
      },
    ).then((_) => _fetchRandomJob()); // После закрытия диалога загружаем следующую вакансию
  }


  void _dislikeJob(String jobId) async {
    await _markJobAsDisliked(jobId);
    await _fetchRandomJob();
  }




@override
Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return Scaffold(
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _randomJob != null
        ? SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          SineWaveWidget(verticalOffset: 205),

          Padding(
            padding: const EdgeInsets.only(
                left: 32.0, top: 70.0, right: 32.0, bottom: 22.0),

            child: Text(
              '${_randomJob!['title']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 32.0, top: 270.0, right: 32.0, bottom: 22.0),
            child: Text(
              ' ${_randomJob!['description']}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
        padding:  EdgeInsets.only(
            left: 32.0, top: screenHeight-150 , right: 32.0, bottom: 22.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _likeJob(_randomJob!.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF93D56F), // Цвет фона кнопки
                foregroundColor: Colors.white, // Цвет иконки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Закругленные углы
                ),
                minimumSize: const Size(144, 60), // Минимальный размер кнопки

              ),
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () => _dislikeJob(_randomJob!.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD1CEB9), // Цвет фона кнопки
                foregroundColor: Colors.white, // Цвет иконки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Закругленные углы
                ),
                minimumSize: const Size(144, 60), // Минимальный размер кнопки

              ),
              child: const Icon(Icons.arrow_forward, color: Color(0xFF343434)),
            ),
          ],
        )

      ),
        ],
      ),
    )
        : const Center(
      child: Text('Больше вакансий нет', style: TextStyle(fontSize: 24)),
    ),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: DoubleIcon(
            bottomIconAsset: 'images/icons/main-bg.svg',
            topIconAsset: 'images/icons/main.svg',
          ),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: SvgIcon('images/icons/projects.svg'),
          label: 'Проекты',
        ),
        BottomNavigationBarItem(
          icon: SvgIcon('images/icons/profile.svg',),
          label: 'Профиль',
        ),
        BottomNavigationBarItem(
          icon: SvgIcon('images/icons/support.svg'),
          label: 'Поддержка',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.black, // Цвет выбранного элемента
      unselectedItemColor: Colors.black, // Цвет не выбранного элемента
    ),
    );
  }
}
