// Файл verification.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:mama_kris/wave.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late User user;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView( // Добавляем прокрутку
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SineWaveWidget(verticalOffset: 300),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 38),
                  child: Image.asset('images/logo_named.png'),
                ),
              ),
              // Условие для отображения сообщения и кнопки
              if (!user.emailVerified) ...[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Пожалуйста, проверьте свою почту и нажмите на ссылку для подтверждения.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Container(
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
                        width: double.infinity,
                        height: 60, // Высота кнопки
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Прозрачный цвет
                            shadowColor: Colors.transparent, // Убираем тень
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            // Убираем минимальный размер, так как он задается через Container
                          ),
                          onPressed: () async {
                            await user.sendEmailVerification();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Письмо отправлено!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text(
                            'Отправить письмо повторно',
                            style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ] else ...[
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Почта подтверждена!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                ),
              ],
            ],
          ),
        ),
      );

    }

  Future<void> checkEmailVerified() async {
    user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushReplacementNamed(context, '/choice');
    } else {
      setState(() {});
    }
  }
}
