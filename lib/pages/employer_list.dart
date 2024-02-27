import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mama_kris/pages/job_create.dart';

class JobsListPage extends StatefulWidget {
  @override
  _JobsListPageState createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0; // Индекс для отслеживания текущего выбранного элемента

  final List<Widget> _widgetOptions = [
    Text('Главная'), // Замените на ваш виджет для /tinder
    Text('Профиль'), // Замените на ваш виджет для /profile
    Text('Поддержка'), // Замените на ваш виджет для /support
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/empl_list');
        break;
      case 1:
        Navigator.pushNamed(context, '/profile_empl');
        break;
      case 2:
        Navigator.pushNamed(context, '/support_empl');
        break;
    }
  }
  void _editJob(Map<String, dynamic> jobData) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => JobPage(jobData: jobData)),
    );
  }

  void _deleteJob(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список вакансий'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('jobs').where('employerId', isEqualTo: _auth.currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Нет данных'));
          }
          final jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              final jobData = job.data() as Map<String, dynamic>;
              jobData['id'] = job.id; // Добавляем id для последующего использования

              return ListTile(
                title: Text(jobData['title'] ?? 'Без названия'),
                subtitle: Text(jobData['description'] ?? 'Без описания'),
                trailing: PopupMenuButton<String>(
                  onSelected: (String value) {
                    if (value == 'edit') {
                      _editJob(jobData);
                    } else if (value == 'delete') {
                      _deleteJob(job.id);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Редактировать'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Удалить'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => JobPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Добавить вакансию',
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey, // Цвет неактивных элементов+
        onTap: _onItemTapped,
      ),
    );
  }
}
