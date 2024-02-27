/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mama_kris/wave.dart';

class ChoicePage extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('choices');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xFFFCFAEE),
    body: SingleChildScrollView(
    child: Column(
    children: <Widget>[
    SizedBox(height: screenHeight / 4),
    Align(
    alignment: Alignment.center,
    child: Image.asset('images/logo_named.png', height: 100), // Предположим, что высота логотипа — 100
    ),
    SizedBox(height: screenHeight / 4 - 100), // Вычитаем высоту картинки, чтобы кнопки были ниже на одинаковом расстоянии
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32.0), // Отступы по бокам
    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF93D56F),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(vertical: 15),
    minimumSize: Size(double.infinity, 50), // Растягиваем кнопку на всю ширину с минимальной высотой
    ),
    onPressed: () {
    Navigator.pushNamed(context, '/welcome');
    },
    child: Text(
    'Создать аккаунт',
    style: TextStyle(fontSize: 18, color: Colors.white),
    ),
    ),
    ),
    SizedBox(height: 20), // Расстояние между кнопками
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32.0), // Отступы по бокам
    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(vertical: 15),
    minimumSize: Size(double.infinity, 50), // Аналогично, растягиваем на всю ширину
    ),
    onPressed: () async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
    String uid = user.uid;
    await collection.doc(uid).set({'choice': 'есть вакансии'});
    Navigator.pushNamed(context, '/job');
    }
    },
    child: Text('Есть вакансии'),
    ),
    ),
      ],
    ),

    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobPage extends StatefulWidget {
  final Map<String, dynamic>? jobData; // Добавляем параметр для передачи данных вакансии

  JobPage({this.jobData});

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference collection = FirebaseFirestore.instance.collection('jobs');

  // Создаем контроллеры для управления текстовыми полями
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactLinkController = TextEditingController();

  String _jobType = 'разовое задание';
  String _sphere = 'маркетинг';
  @override
  void initState() {
    super.initState();

    // Устанавливаем начальные значения для полей из переданных данных, если они есть
    if (widget.jobData != null) {
      _titleController.text = widget.jobData!['title'] ?? '';
      _descriptionController.text = widget.jobData!['description'] ?? '';
      _contactLinkController.text = widget.jobData!['contactLink'] ?? '';
      _jobType = widget.jobData!['jobType'] ?? _jobType;
      _sphere = widget.jobData!['sphere'] ?? _sphere;
    }
  }

  @override
  void dispose() {
    // Очищаем контроллеры при уничтожении виджета
    _titleController.dispose();
    _descriptionController.dispose();
    _contactLinkController.dispose();
    super.dispose();
  }

  // Функция для сохранения вакансии
  void _saveJob() async {
    if (_formKey.currentState!.validate()) {
      // Проверяем, что пользователь выбрал тип работы
      if (_jobType != 'once' && _jobType != 'const') {
        // Если тип работы не выбран, показываем сообщение об ошибке
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пожалуйста, выберите тип работы')),
        );
        return; // Прерываем выполнение метода
      }

      _formKey.currentState!.save(); // Сохраняем форму

      Map<String, dynamic> jobData = {
        'jobType': _jobType,
        'sphere': _sphere,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'contactLink': _contactLinkController.text,
        'employerId': FirebaseAuth.instance.currentUser?.uid,
      };

      try {
        if (widget.jobData != null) {
          // Редактирование существующей вакансии
          await collection.doc(widget.jobData!['id']).update(jobData);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Вакансия обновлена')));
        } else {
          // Добавление новой вакансии
          await collection.add(jobData);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Вакансия добавлена')));
        }

        Navigator.pushReplacementNamed(context, '/empl_list');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Произошла ошибка при сохранении')));
        print(e);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobData != null ? 'Редактировать вакансию' : 'Новая вакансия'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            ListTile(
              title: const Text('разовое задание'),
              leading: Radio<String>(
                value: 'once',
                groupValue: _jobType,
                onChanged: (value) => setState(() => _jobType = value!),
              ),
            ),
            ListTile(
              title: const Text('вакансия на постоянную онлайн работу'),
              leading: Radio<String>(
                value: 'const',
                groupValue: _jobType,
                onChanged: (value) => setState(() => _jobType = value!),
              ),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название задания'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название задания';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание задания'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите описание задания';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _sphere,
              items: ['маркетинг', 'программирование', 'копирайтинг']
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
                  .toList(),
              onChanged: (value) => setState(() => _sphere = value!),
              decoration: InputDecoration(
                labelText: 'Выберите сферы',
              ),
            ),
            TextFormField(
              controller: _contactLinkController, // Используйте контроллер напрямую
              decoration: InputDecoration(labelText: 'Ссылка на контакт'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите ссылку на контакт';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _saveJob,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}