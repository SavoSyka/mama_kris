import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mama_kris/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChoicePage extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('choices');

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;


    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      body: Stack( // Используем Stack для наложения элементов
        children: <Widget>[
          SineWaveWidget(verticalOffset: height / 2), // Волна на фоне

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 15*VerticalMultiply),
              child: SvgPicture .asset(
                'images/logo.svg',
                width: 220*HorizontalMultiply, // Ширина в пикселях
                height: 224*VerticalMultiply, // Высота в пикселях
              ),
            ),
          ),

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

          Padding(
            padding: EdgeInsets.only(
                left: 32.0*HorizontalMultiply, top: 110*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB7B39A), // Фон кнопки
                foregroundColor: Colors.white, // Цвет текста кнопки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12*TextMultiply),
                ),
                padding: EdgeInsets.only(top: 23*(height/800), bottom:23*(height/800)),
                minimumSize:  Size(double.infinity, 60*TextMultiply), // Растягиваем кнопку на всю ширину с высотой 50

              ),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String uid = user.uid;
                  await collection.doc(uid).set({'choice': 'ищу работу'});
                  Navigator.pushNamed(context, '/search');
                }
              },
              child:  Text(
                'Я ИСПОЛНИТЕЛЬ',
                  style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 32.0 * HorizontalMultiply, left: 32 * HorizontalMultiply, top: 186 * VerticalMultiply),
            child:Container(
              width: double.infinity,
              height: 46*VerticalMultiply, // Примерная высота, убедитесь, что она достаточна
              child: Center(
                child: Text(
                  'Ищу работу, подработку или\nзадания для онлайн-заработка',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                ),
              ),
            ),
          ),





          Padding(
            padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 165*VerticalMultiply+ height/2, right:32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB7B39A), // Фон кнопки
                foregroundColor: Colors.white, // Цвет текста кнопки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12*TextMultiply),
                ),
                padding: EdgeInsets.only(top: 23*(height/800), bottom:23*(height/800)),
                minimumSize:  Size(double.infinity, 60*TextMultiply), // Растягиваем кнопку на всю ширину с высотой 50

              ),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String uid = user.uid;
                  await collection.doc(uid).set({'choice': 'есть вакансии'});
                  Navigator.pushNamed(context, '/job');
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка сохранения: ${e.toString()}'))
                  );
                }
              },
              child:  Text(
                  'Я РАБОТОДАТЕЛЬ',
                  style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 32.0 * HorizontalMultiply, left: 32 * HorizontalMultiply, top: 244 * VerticalMultiply + height/2),
            child:Container(
              width: double.infinity,
              height: 46*VerticalMultiply, // Примерная высота, убедитесь, что она достаточна
              child: Center(
                child: Text(
                  'У меня есть online-вакансия\nили задание',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
