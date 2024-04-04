import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mama_kris/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/icon.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();

}


class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2; // Индекс для отслеживания текущего выбранного элемента


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });


    switch(index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/tinder');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/projects');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/support');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;

    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        Stack(
        children: [
        SineWaveWidget(verticalOffset:  340*VerticalMultiply),
          Padding(
            padding: EdgeInsets.only(
                left: 5.0*HorizontalMultiply, top: 35*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
            child:IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
    Align(
    alignment: Alignment.center,
    child: Padding(
    padding: EdgeInsets.only(top: 58*VerticalMultiply),
    child: SvgPicture .asset(
    'images/logo_named.svg',
    width: 220*HorizontalMultiply, // Ширина в пикселях
    height: 224*VerticalMultiply, // Высота в пикселях
    ),
    ),
    ),
          Padding(
            padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 400*VerticalMultiply, right:32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
            child:  Align(
              alignment: Alignment.center,
              child: user != null ?
              Text(' ${user.email}', style: TextStyle(fontSize: 18*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
              ) :
              Text('Пользователь не вошел в систему', style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
              ),

            ),
          ),

        Padding(
          padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 568*VerticalMultiply, right: 32*HorizontalMultiply, bottom:32*VerticalMultiply), // Общий отступ для группы текстов
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF93D56F), Color(0xFF659A57)], // Градиент от #93D56F до #659A57
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12*TextMultiply), // Скругление углов
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Прозрачный фон для отображения градиента
                shadowColor: Colors.transparent, // Убираем тень
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12*TextMultiply), // Скругление углов
                ),
                minimumSize: Size(double.infinity, 60*VerticalMultiply), // Растягиваем кнопку на всю ширину с высотой 60
                padding: EdgeInsets.only(top: 23*VerticalMultiply, bottom:23*VerticalMultiply),
              ),          onPressed: () async {
            // Выход из аккаунта
            await FirebaseAuth.instance.signOut();

            // Перенаправление на экран входа или на начальный экран приложения
            Navigator.pushReplacementNamed(context, '/start');
          },
         child:  Text(
           'ВЫЙТИ ИЗ АККАУНТА',
           style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
         ),
       ),
      ),
    ),
          Padding(
            padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 640*VerticalMultiply, right: 32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB7B39A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12*TextMultiply),
                ),
                padding: EdgeInsets.only(top: 23*(height/800), bottom:23*(height/800)),
              ),
              child:  Align(
                alignment: Alignment.center,
                child: Text(
                    'СБРОСИТЬ ПАРОЛЬ',
                    style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/reset');
              },
            ),
          ),


      ]
      ),
      ]
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
            icon: SvgIcon('images/icons/projects.svg'),
            label: 'Проекты',
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
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Цвет выбранного элемента
        unselectedItemColor: Colors.black, // Цвет не выбранного элемента
      ),
    );
  }
}