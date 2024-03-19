import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/icon.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}




class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Индекс для отслеживания текущего выбранного элемента

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });


    switch(index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/projects');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/support');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body:  Center(
        // Отображение виджета, соответствующего текущему выбранному элементу
        child: SvgPicture.asset(
          'images/icons/main.svg',
          width: 100, // Установите желаемый размер
          height: 100,
        ),
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
              icon: SvgIcon('images/icons/profile.svg'),
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