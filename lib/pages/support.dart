import 'package:flutter/material.dart';
import 'package:mama_kris/icon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mama_kris/pages/conf.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();

}


class Article {
  final String title;
  final List<TextSpan> contentSpans;

  Article(this.title, this.contentSpans);
}

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Стандартная высота AppBar
        child: AppBar(
          backgroundColor: const Color(0xFFFCFAEE),
          title: Text(article.title),
        ),
      ),
      backgroundColor: const Color(0xFFFCFAEE),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Этот виджет позволяет прокрутку
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16.0, color: Colors.black), // Базовый стиль текста
              children: article.contentSpans,
            ),
          ),
        ),
      ),
    );
  }
}



class _SupportPageState extends State<SupportPage> {
  int _selectedIndex = 3; // Индекс для отслеживания текущего выбранного элемента

  final List<Article> articles = [
    Article(
      'Как пользоваться приложением?',
      [
      const TextSpan(text: '''Добро пожаловать на самую удобную платформу по поиску онлайн-заданий и вакансий!\nМеня зовут Кристина. Я автор идеи и руководитель команды приложения “MamaKris”.\n
Это приложение создано для поиска и размещения лучших предложений по онлайн-работе для мам в декрете, студентов, пенсионеров, людей с ограниченными возможностями и фрилансеров. Для всех, кто ищет работу онлайн.\n
Я сама многодетная мама и уже более 10 лет зарабатываю только онлайн. Я была и в роли сотрудника, и в роли работодателя. И знаю боли и тех, и других.\n
Биржи по фрилансу сложны по интерфейсу и берут достаточно большие комиссии с исполнителей и работодателей. Чаты по фрилансу превратились в суп из предложений по работе, где много мусора. И достаточно трудно найти что-то стоящее.\n
Мне захотелось упростить этот процесс и сделать поиск и размещение онлайн-вакансий более удобным. Надеюсь вам понравится то, как мы решили соединять онлайн-проекты и сотрудников. Надеюсь наша платформа будет для вас самой удобной и поможет с легкостью найти работу мечты или ценного сотрудника, не выходя из дома.\n
- В приложении есть две роли:\n\n'''),
        const TextSpan(text: 'Роль исполнителя и Роль работодателя.\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '''Если вы выбираете роль исполнителя, то после ответов на несколько уточняющих вопросов вы получаете доступ к предложениям по онлайн-заработку. Для этого достаточно просто листать вправо.\n
Если предложение вас заинтересовало, вы ставите “лайк” и эта вакансия (или задание) улетает в раздел “Мои проекты”.\n
Далее вы можете кликнуть по проекту и увидеть контакт работодателя, чтобы связаться с ним по конкретной вакансии.\n
Если вы выбираете роль работодателя, то после ответов на несколько уточняющих вопросов вы размещаете свое предложение по работе, указываете свои контакты, чтобы потенциальный сотрудник мог с вами связаться. И после ожидаете откликов от исполнителей.\n
- Внизу у вас есть панель, которая состоит из следующих разделов:\n\n'''),
        const TextSpan(text: 'Главная\n', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: '(здесь вы видите объявления о работе)\n'),
        const TextSpan(text: 'Проекты\n', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: '(сюда улетают понравившиеся вам объявления)\n'),
        const TextSpan(text: 'Профиль\n', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: '(в профиле размещена анкета, по которой вы можете составить свое резюме. Данную ссылку на резюме вы можете присылать работодателю, если он запросит)\n'),
        const TextSpan(text: 'Поддержка\n', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: '(тут размещены полезные статьи и возможность переписываться с тех. поддержкой приложения)\n\n'),
        const TextSpan(text: 'Все просто! Успехов в поиске. Тут собраны лучшие онлайн-вакансии и задания для онлайн-заработка.'),

      ],
    ),
    Article(
      'Новичку в мире онлайна.',
      [
        const TextSpan(text: 'Я поздравляю вас! Вы смотрите в сторону онлайн-заработка и скачали правильное приложение.\n\n'),
        const TextSpan(text: 'Хочу, чтобы вы знали:\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '''1. Работы и денег в онлайне очень много.\n
2. Трудно сразу найти то, что точно будет вашим делом жизни, будет сразу легко получаться и приносить миллионы. Но начать делать первые шаги в том, что потенциально может быть вам интересно, нужно уже сегодня.\n
3. Идеальней условий, чем сейчас, для старта и построения карьеры онлайн не будет.\n
4. Понять ваше или не ваше можно только после того, как попробуете СДЕЛАТЬ! А дальше чувствуйте себя....\n
5. Ничего не бойтесь. Отнеситесь как к игре, в которой вы просто проходите новые уровни.\n
6. Не тратьте время и силы на сомнения.\n
7. Не сдавайтесь при первой же неудаче. Успех - это процесс, а не конечная точка. Начните играть в свой успех уже сейчас.\n
8. У вас точно получится, потому что та сила, которая вас сюда привела очень хочет раскрыть вс, так же как и вы ее.\n
9. Не замирайте. Замирать и бездействовать = проиграть.\n\n'''),
        const TextSpan(text: 'Какие есть основные пути онлайн-заработка?\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '''• Работа над чужими проектами
• Работа над своим проектами\n
Работа над чужими проектами – это когда вы можете устроиться в штат одного проекта и на регулярной основе выполнять определенный фронт задач за фиксированную ЗП в той области, в которой вы сильны. Либо можете быть в качестве подрядчика. Брать заказы в разных проектах. И принимать оплату за конкретный заказ, задание, услугу.\n
Работа над своими проектами – это когда вы сами организуете какой-либо бизнес-проект в интернете и сами для себя решаете до каких размеров вы хотите его «вырастить». Вы сами себе начальник!
Ваша повестка дня полностью зависит от вас и ваших идей, а ваша зарплата – от ваших умений и сноровки. Тут надо уметь многое, но зато финансового «потолка» у вас в этом случае нет. А знаете почему? Потому что аудитория людей, «сидящих» в интернете (а значит, ваших потенциальных клиентов), ОГРОМНА! Работая на себя, вы становитесь тем человеком, от которого зависит ваша зарплата.\n
В общем, кому что нравится. И работа в чужих проектах и работа «на себя» в интернете имеют право на жизнь и могут приносить и удовлетворение, и хороший заработок. К тому же очень часто, начав работать в чужих проектах, вы затем решаете заняться своим делом, опираясь на опыт и ошибки, которые смогли увидеть внутри. Ну, или наоборот.\n
Бывает и так, что ты идешь в чужой проект, чтобы просто заработать на свой. Либо в своем просадка, идешь подработать в другое место.\n
Но места в интернете точно хватит всем!\n
Это приложение поможет и соискателям и собственникам найти свое.
Соискатели найдут хорошие вакансии.
Собственники проектов - хороших исполнителей в свою команду.\n
К 2022 году по подсчетам экспертов население Земли составляет 8 046 949 318 человек. В настоящее время проникновение Интернета составляет 62,5% от общей численности населения земли. За последние 10 лет количество пользователей Интернета выросло более чем в 2 раза, с 2,18 млрд в январе 2013 года до 4,95 млрд в начале 2023 года. Поэтому возможностей, предложений в онлайне “вагон и целая тележка”. Было бы желание заработать, а возможности найдутся с помощью приложения “MamaKris”.\n\n'''),
        const TextSpan(text: 'В каком статусе вы можете быть с юридической точки зрения в онлайне?\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '    • ', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: 'Трудоустроиться в онлайн-проект (компанию) по трудовому договору\n'),
        const TextSpan(text: '    • ', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: 'Принимать деньги в статусе самозанятого\n'),
        const TextSpan(text: '    • ', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: 'Принимать деньги в статусе ИП\n\n'),
        const TextSpan(text: 'Какие есть сферы работ/вакансии/задания в онлайне?\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '''Есть онлайн-профессии, которые требуют конкретные прикладные навыки в онлайне, а есть профессии, где достаточно вашего набора Soft skills - в переводе с английского — «гибкие навыки». Иногда переводят буквально — «мягкие навыки», это одно и то же. Они не связаны с конкретной профессией, но помогают хорошо выполнять свою работу и важны для карьеры.\n
В онлайне есть множество заданий и вакансий, где достаточно только “мягких навыков” сотрудника. И отсутствие опыта не будет являться камнем преткновения.\n\n'''),
        const TextSpan(text: 'Направления, в которых можно развиваться и зарабатывать онлайн:\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '''  ◦ Дизайн (веб-дизайн)
 ◦ Программирование, разработка и IT
 ◦ Аналитика 
 ◦ ИИ, нейросети
 ◦ Тексты и переводы
 ◦ Обработка фото и монтаж видео
 ◦ Копирайтинг, контент, смыслы
 ◦ Seo и трафик
 ◦ Социальные сети, блоги, реклама 
 ◦ Продажи
 ◦ Маркетинг 
 ◦ Менеджмент
 ◦ Методология
 ◦ Модератор, тестировщик
 ◦ Психология, коучинг, консалтинг, кураторство
 ◦ Блогерство
 ◦ Административные задачи 
 ◦ Творческие и креативные задачи 
 ◦ Репетиторство
 ◦ Общие задачи 
 ◦ Очумелые ручки (заказ онлайн на изготовление тортов, шитья на заказ, вязания, любой hand made) \n\n'''),

        const TextSpan(text: 'Где можно обучиться онлайн-профессиям:\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: 'Нетология, Skillbox, Coursera, Академия Яндекса, Stepik, edX.\n'),
        // Добавьте остальные части содержимого с соответствующим форматированием...
      ],
    ),
    Article('Как защититься от мошенников в онлайне?',
      [
        const TextSpan(text: '''Мошенники были всегда и во все времена. И интернет не стал исключением.
Но поговорим мы не о самых обычных мошенниках, а о тех, которые наглым образом готовы бросить на деньги юного фрилансера. Интересно, что иногда даже опытные копирайтеры/дизайнеры/верстальщики/сеошники попадаются на самый, казалось бы, типовой обман.\n
Неудобство ведения работы через сеть заключается в том, что при общении с непосредственным работодателем мы не видим вживую того человека, который оплачивает работу. По сути, это виртуальный заказчик, с которым зачастую не подписан договор и все держится на честном слове.\n
Давайте же рассмотрим в отдельности некоторые из таких ситуационных моментов, которые практикуют большинство мошенников. Информация проверена на печальном опыте, а потому является полностью достоверной.\n\n'''),
        const TextSpan(text: 'Заказчики, которые уходят по-английски.\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '''В первую очередь мы поговорим о тех заказчиках, которых можно обнаружить в социальной сети, на форуме или на биржах. Это вроде доски объявлений с актуальными вакансиями. Для связи с работодателем необходимо использовать мессенджер или Zoom. Оплата, соответственно, производится со счета заказчика на счет исполнителя.\n
Итак, вы общаетесь с работодателем и обсуждаете все детали выполнения его заказа. Задание понятно, и вы приступаете к его исполнению. Далее необходимо передать работу заказчику и получить свое вознаграждение.\n
Оговоримся, что на всех этапах работы, уточнений и отправки заказа идет активный диалог. Но после того, как работа отправлена, контакт сводится к минимуму: «Ожидайте, я все еще проверяю/занят/не могу говорить».
Но большинство из таких мошенников предпочитает просто уйти по-английски без лишних слов. Без «Goodbye» или «Good luck» они удаляют вас из списка контактов и просто замолкают. Очевидно, что вас кинули, и самое неприятное, что вы сами во всем виноваты. В чем ваша вина?\n
Все просто! Если работодатель не проверенный, то единственным гарантом сделки может выступать оплата авансового типа. До начала работы попросите предоставить половину стоимости обещанного вознаграждения.\n\n'''),
        const TextSpan(text: 'Миф о том, как сделать тестовое задание и получить работу.\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '''Очень многие фрилансеры находят предложения о работе, где указана необходимость выполнения тестового задания и ее отправки его на почту. Все приукрашено громкими словами о прекрасной цене, огромных объемах и светлом будущем.\n
Отправленная работа на почту может и просто затеряться в спаме, но чаще всего это одна из схем мошенников, которые заинтересованы в получении бесплатной работы от вас. Вы с ним не знакомы, не общались и не виделись. Работа получена, но могла по каким-то причинам не понравится (теоретически), а по тому отвечать вам и не стоит. На практике же ваша работа очень даже подошла и ваш недобросовестный заказчик получил ваше время бесплатно. Потому забудьте о тестовых заданиях в сети, так как они являются не больше, чем предлогом к мошенничеству.\n
Если работодателю и вправду необходимо узнать ваш профессиональный уровень в выполнении определенной по тематике работе, то ему можно предоставить свое резюме или пообщаться с вами.\n
Либо вышлите ему несколько из своих старых работ, чего будет вполне достаточно для первичного знакомства.\n\n'''),
        const TextSpan(text: 'Подведем итоги.\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: '''Сегодня мошенники обосновались абсолютно в каждом уголке интернета, где они чувствуют себя максимально комфортно и уверенно. Это не означает, что из-за них придется отказаться от мечты о работе в виртуальной среде. Заметьте, что сотни тысяч фрилансеров успешно получают доход от своих проектов. Конечно, большинство из них уже набило немало шишек. Но опыт, который вы получили из этой статьи, для вас пока только теория, а не практика.\n
Наша команда Hr-менеджеров сиарается подбирать лучшие предложения по онлайн-работе в приложении “MamaKris”, но все равно мы не можем дать 100 процентной гарантии, что среди наших объявлений не будет каких-то недобросовестных работодателей.\n\n'''),
        const TextSpan(text: 'Поэтому будьте внимательны и осторожны:\n\n', style: TextStyle(fontStyle: FontStyle.italic)),
        const TextSpan(text: '    • ', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: 'Никому не переводите деньги за то, чтобы получить работу\n'),
        const TextSpan(text: '    • ', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: 'Никому не сообщайте паролей, которые приходят в смс и не давайте данных от своих аккаунтов iCloud, App Store, iMessage и электронных почт.\n\n'),
        const TextSpan(text: 'Стоит быть'),
        const TextSpan(text: 'бдительным и осторожным ', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: '''при работе с новыми заказчиками, просить аванс и требовать дополнительных гарантий.\n
Успехов вам в поиске! Наша команда приложения “MamaKris” поможет вам и сделает его максимально удобным!'''),

      ]
      ),
    //  Article('Как не попасться на мошенников в онлайне?', 'Содержимое статьи 3...'),
  ];


  Widget articleCard(Article article) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(article.title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Здесь мы добавляем навигацию к странице статьи
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArticlePage(article: article),
            ),
          );
        },
      ),
    );
  }



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
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0ECD3),

        title: const Text(''),
      ),
      backgroundColor: const Color(0xFFF0ECD3),

      body: ListView(
        children: [
          ...articles.map(articleCard).toList(),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: const Text('Поддержка.\nНапишите нам, если у Вас остались вопросы, замечания, предложения.'),
              trailing: const Icon(Icons.send),
              onTap: ()  => _launchURL('https://t.me/MamaKris_support_bot?start=helpc'),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: const Text('Политика конфиденциальности'),
              //trailing: const Icon(Icons.send),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                );
              },
            ),
          ),
        ],
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
            icon: SvgIcon('images/icons/profile.svg'),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: DoubleIcon(
              bottomIconAsset: 'images/icons/support-bg.svg',
              topIconAsset: 'images/icons/support.svg',
            ),
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
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не удалось открыть $url';
    }
  }
}


