import 'package:flutter/material.dart';
import 'package:mama_kris/icon.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileEmplPage extends StatefulWidget {
  @override
  _ProfileEmplPageState createState() => _ProfileEmplPageState();

}
class _ProfileEmplPageState extends State<ProfileEmplPage> {
  int _selectedIndex = 1; // Индекс для отслеживания текущего выбранного элемента


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        // Отображение виджета, соответствующего текущему выбранному элементу
        child: ElevatedButton(
          child: Text('Выйти из аккаунта'),
          onPressed: () async {
            // Выход из аккаунта
            await FirebaseAuth.instance.signOut();

            // Перенаправление на экран входа или на начальный экран приложения
            Navigator.pushReplacementNamed(context, '/start');
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/main.svg'),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: DoubleIcon(
              bottomIconAsset: 'images/icons/profile-bg.svg',
              topIconAsset: 'images/icons/profile.svg',
            ),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/support.svg'),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Цвет выбранного элемента
        unselectedItemColor: Colors.black, // Цвет не выбранного элемента
        onTap: _onItemTapped,
      ),
    );
  }
}