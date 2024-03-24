// Файл login.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Добавьте этот импорт
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Добавьте этот импорт
import 'package:mama_kris/wave.dart'; // Убедитесь, что wave.dart содержит SineWaveWidget
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Создайте экземпляр FirebaseAuth

  Future<bool?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        // Возвращаем true, если пользователь новый, и false, если нет
        return userCredential.additionalUserInfo?.isNewUser;
      }
    } catch (e) {
      print(e);
    }
    return null; // В случае ошибки возвращаем null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
        Stack(
        children: [
        SineWaveWidget(verticalOffset: 300), // Убедитесь, что у вас есть SineWaveWidget
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 38),
            child: SvgPicture .asset('images/logo_named.svg'), // Убедитесь, что путь к изображению правильный
          ),
        ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.only(left: 32.0, top: 70.0, right: 72.0, bottom: 22.0),
        child: Text(
          'Пожалуйста, войдите',
          style: TextStyle(fontSize: 32, color: Color(0xFF343434), fontFamily: 'Inter', fontWeight: FontWeight.w700),
          textAlign: TextAlign.left,
        ),
      ),
      _buildTextField(_emailController, 'Email', false),
      _buildTextField(_passwordController, 'Пароль', true),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF93D56F), Color(0xFF659A57)], // Градиент от #93D56F до #659A57
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12), // Скругление углов
          ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, // Прозрачный фон для отображения градиента
            shadowColor: Colors.transparent, // Убираем тень
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Скругл
            ),
            padding: EdgeInsets.symmetric(vertical: 15),
            minimumSize: Size(double.infinity, 60),
          ),child: const Text(
          'Войти',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
              onPressed: () async {
                try {
                  final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  if (userCredential.user != null) {
                    // Получаем UID аутентифицированного пользователя
                    final uid = userCredential.user!.uid;

                    // Получаем документ пользователя из коллекции 'choices' в Firestore
                    final docSnapshot = await FirebaseFirestore.instance.collection('choices').doc(uid).get();
                    final docSnapshot2 = await FirebaseFirestore.instance.collection('jobSearchers').doc(uid).get();

                    // Проверяем, содержит ли документ информацию о выборе пользователя
                    if (docSnapshot.exists && docSnapshot.data()!.containsKey('choice')) {
                      final choice = docSnapshot.data()!['choice'];

                      // Перенаправляем пользователя в зависимости от его выбора
                      if (choice == 'ищу работу' && docSnapshot2.exists && docSnapshot2.data()!.containsKey('employerId')) {
                        Navigator.pushNamed(context, '/tinder'); // Перенаправление на страницу поиска работы
                      }
                      else if (choice == 'ищу работу') {
                        Navigator.pushNamed(context, '/search'); // Перенаправление на страницу с вакансиями
                      }
                      else if (choice == 'есть вакансии') {
                        Navigator.pushNamed(context, '/empl_list'); // Перенаправление на страницу с вакансиями
                      }
                      else {
                        // Если не удалось определить выбор, перенаправляем на страницу по умолчанию
                        Navigator.pushNamed(context, '/choice');
                      }
                    } else {
                      // Если в документе нет информации о выборе, перенаправляем на страницу по умолчанию
                      Navigator.pushNamed(context, '/choice');
                    }
                  } else {
                    print('Аутентификация не удалась.');
                  }
                }  catch (e) {
                  // Обработка других ошибок...
                }
              },
            ),
        ),
      ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                    label: Text(""),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(60, 60),
                    ),
                    onPressed: () async {
                      final bool? isNewUser = await signInWithGoogle();
                      if (isNewUser == true) {
                        // Новый пользователь
                        Navigator.pushReplacementNamed(context, '/choice');
                      } else if (isNewUser == false) {
                        // Пользователь уже существует, получаем дополнительные данные из Firestore
                        final User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final uid = user.uid;
                          final docSnapshot = await FirebaseFirestore.instance.collection('choices').doc(uid).get();
                          final docSnapshot2 = await FirebaseFirestore.instance.collection('jobSearches').doc(uid).get();

                          // Проверяем, содержит ли документ информацию о выборе пользователя
                          if (docSnapshot.exists && docSnapshot.data()!.containsKey('choice')) {
                            final choice = docSnapshot.data()!['choice'];

                            // Перенаправляем пользователя в зависимости от его выбора
                            if (choice == 'ищу работу' && docSnapshot2.exists && docSnapshot2.data()!.containsKey('employerId')) {
                              Navigator.pushNamed(context, '/tinder'); // Перенаправление на страницу поиска работы
                            }
                            else if (choice == 'ищу работу') {
                              Navigator.pushNamed(context, '/search'); // Перенаправление на страницу с вакансиями
                            }
                            else if (choice == 'есть вакансии') {
                              Navigator.pushNamed(context, '/empl_list'); // Перенаправление на страницу с вакансиями
                            } else {
                              Navigator.pushReplacementNamed(context, '/choice');
                            }
                          } else {
                            // Документ не найден или не содержит выбора
                            Navigator.pushReplacementNamed(context, '/choice');
                          }
                        } else {
                          print('Ошибка: пользователь не определён после входа через Google.');
                        }
                      } else {
                        // Ошибка аутентификации или отмена входа пользователем
                        print("Ошибка аутентификации или вход отменён пользователем");
                      }

                    },
                  )

              ),
          ],
        ),
      ),
    );
  }
  Widget _buildTextField(TextEditingController controller, String label, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always, // Лейбл всегда над полем
          labelStyle: TextStyle(color: Color(0xFF343434)), // Цвет лейбла
          // Устанавливаем толстую рамку
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color:Color(0xFF343434), width: 2.0), // Увеличиваем ширину рамки
          ),
          // Также применяем стиль рамки когда поле в фокусе
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF343434), width: 2.0), // Та же толщина рамки
          ),
          // Стиль рамки при вводе неверных данных
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2.0), // Можно изменить цвет/толщину для ошибок
          ),
        ),
        keyboardType: obscureText ? TextInputType.text : TextInputType.emailAddress,
      ),
    );
  }
}
