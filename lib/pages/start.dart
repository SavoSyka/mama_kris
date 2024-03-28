import 'package:flutter/material.dart';
import 'package:mama_kris/wave.dart'; // Убедитесь, что wave.dart содержит SineWaveWidget
import 'package:flutter_svg/flutter_svg.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Изменено на start для размещения волны в верху
        children: <Widget>[
          Stack(
            children: [
              SineWaveWidget(verticalOffset: height*0.4175), // Ваша волна
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0725*height), // Отступ сверху в 50 пикселей
                  child: SvgPicture.asset(
                    "images/logo_named.svg",
                    width: 220*(width/360), // Ширина в пикселях
                    height: 224*(height/800), // Высота в пикселях
                  )
                ),
              ),
            ],),

          Expanded( // Используем Expanded для центрирования кнопок в оставшемся пространстве
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Padding(
                    padding:  EdgeInsets.only(left: 32*(width/360), top: 0.0, right:0, bottom:0), // Общий отступ для группы текстов
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: const TextSpan(

                          children: <TextSpan>[
                            TextSpan(text: 'Добро\n',style: TextStyle(fontSize: 40, fontFamily: 'Inter', fontWeight: FontWeight.w900, color: Color(0xFF343434)),), // \n - перенос строки
                            TextSpan(text: 'пожаловать!',style: TextStyle(fontSize: 40, fontFamily: 'Inter', fontWeight: FontWeight.w900, color: Color(0xFF343434)),),
                          ],
                        ),
                      ),
                    ),
                  ),

                   Padding(
                    padding:  EdgeInsets.only(left: 32*(width/360), top: 8*(height/800), right:0, bottom:0), // Общий отступ для группы текстов
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Войдите или создайте аккаунт',
                        style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, // Делаем текст более жирным
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Expanded( // Растягиваем кнопку на всю доступную ширину в Row
                        child: Padding(
                          padding:  EdgeInsets.only(left: 32*(width/360), top: 28*(height/800), right: 32*(width/360), bottom:0), // Общий отступ для группы текстов
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF93D56F), // верхний цвет
                                  Color(0xFF659A57)  // нижний цвет
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 20), // Задаем ширину (бесконечность для максимальной ширины) и высоту кнопки
                                backgroundColor: Colors.transparent, // Прозрачный цвет
                                shadowColor: Colors.transparent, // Убираем тень
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.only(top: 23*(height/800), bottom:23*(height/800)),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/welcome');
                              },
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'СОЗДАТЬ АККАУНТ',
                                  style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                  ),
                  Row(
                    children: <Widget>[
                      Expanded( // Растягиваем кнопку на всю доступную ширину в Row
                        child: Padding(
                          padding:  EdgeInsets.only(left: 32*(width/360), top: 12*(height/360), right: 32*(width/360), bottom:0), // Общий отступ для группы текстов
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFB7B39A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.only(top: 23*(height/800), bottom:23*(height/800)),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'ВОЙТИ',
                                  style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.only( top: 24*(height/800)), // Общий отступ для группы текстов
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'или войдите с помощью:',
                        style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, // Делаем текст более жирным
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
