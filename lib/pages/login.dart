// Файл login.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Добавьте этот импорт

import 'package:firebase_auth/firebase_auth.dart'; // Добавьте этот импорт
import 'package:mama_kris/pages/home.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Создайте экземпляр FirebaseAuth

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Войти'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text('Войти'),
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

                    // Проверяем, содержит ли документ информацию о выборе пользователя
                    if (docSnapshot.exists && docSnapshot.data()!.containsKey('choice')) {
                      final choice = docSnapshot.data()!['choice'];

                      // Перенаправляем пользователя в зависимости от его выбора
                      if (choice == 'ищу работу') {
                        Navigator.pushNamed(context, '/tinder'); // Перенаправление на страницу поиска работы
                      } else if (choice == 'есть вакансии') {
                        Navigator.pushNamed(context, '/empl_list'); // Перенаправление на страницу с вакансиями
                      } else {
                        // Если не удалось определить выбор, перенаправляем на страницу по умолчанию
                        Navigator.pushNamed(context, '/home');
                      }
                    } else {
                      // Если в документе нет информации о выборе, перенаправляем на страницу по умолчанию
                      Navigator.pushNamed(context, '/home');
                    }
                  } else {
                    print('Аутентификация не удалась.');
                  }
                } on FirebaseAuthException catch (e) {
                  // Обработка ошибок аутентификации...
                } catch (e) {
                  // Обработка других ошибок...
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
