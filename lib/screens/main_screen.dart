import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mojazahkam/screens/contactUs.dart';
import 'package:mojazahkam/screens/favorites_screen.dart';
import 'package:mojazahkam/screens/muamalat_screen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chapter_screen.dart';
import 'fontSetting.dart';
import 'ibadat_Screen.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  MainScreen({required this.isDarkMode, required this.onThemeChanged});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> openWebsite(String url) async {
    final Uri websiteUri = Uri.parse(url);
    await launchUrl(websiteUri);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(103, 182, 187, 1),
            title: Image.asset('assets/1722218985400.png'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => SearchScreen()),
                  );
                },
              ),
            ],
            bottom: TabBar(
              labelColor: Colors.white, // لون النصوص المحددة
              unselectedLabelColor: Colors.white, // لون النصوص غير المحددة
              tabs: [
                Tab(text: 'التقليد'),
                Tab(text: 'العبادات'),
                Tab(text: 'المعاملات'),
              ],
            ),
            foregroundColor: Colors.white,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'موجز الأحكام',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Switch(
                        value: widget.isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            widget.onThemeChanged(value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('الرئيسية'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('المفضلة'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => FavoritesScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('الإعدادات'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => FontSettingsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('حول التطبيق'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => AboutApp(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('اتصل بنا'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ContactUsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text('الموقع - الاستفتاءات'),
                  onTap: () {
                    openWebsite(
                        'https://www.leader.ir/ar/services/20/%D8%A7%D9%84%D9%81%D9%82%D9%87-%D9%88%D8%A7%D9%84%D8%A3%D9%85%D9%88%D8%B1-%D8%A7%D9%84%D8%B4%D8%B1%D8%B9%D9%8A%D8%A9');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('مشاركة التطبيق'),
                  onTap: () {

                    Share.share(
                        '''
                        السلام عليكم، يمكنكم تحميل تطبيق كتاب موجز الأحكام للسيد الخامنئي داك ظله، من إعداد السيد أبو تيسير الجابري، عبر الرابط التالي في سوق بلي:
                        
                        https://play.google.com/store/apps/details?id=com.alialrikabi313.mojazahkam''');
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ChapterScreen(),
              IbadatScreen(),
              MuamalatScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(239, 221, 171, 1), // لون الشريط العلوي
          title: Text('حول التطبيق',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 87, 94, 1),
              )),
        ),
        body: Container(
          color: Color.fromRGBO(0, 87, 94, 1),
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                // عرض الصورة الأولى
                Image.asset(
                  'assets/about1.jpg',

                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30),
                // عرض الصورة الثانية
                Image.asset(
                  'assets/about2.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Text(
                  'موجز الأحكام',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(239, 221, 171, 1),
                    fontFamily: 'Arial',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '''
                  تقديم ممثل الإمام الخامنئي (دام ظله) في العراق

ما صدر من الكتب الحاوية لفتاوى الإمام الخامنئي (دام ظله) لم يكن وافيا لتغطية الحاجات وتلبية المتطلبات لكثرتها وتنوعها، فبادر صديقنا السيد كاظم الجابري بجمع فتاوى الإمام الخامنئي (دام ظله) من مصادر مختلفة متعددة، وبذل جهده واستفرغ وسعه لإخراج مجموعة من الفتاوى المبتلى بها من تلك المصادر بتحقيق عميق وترتيب رشيق، وجمعها بين دفتي هذه الرسالة من دون إسهاب ممل أو تلخيص مخل، وسماه (موجز الأحكام).

وقد عرضناها على هيئة الاستفتاء في مكتب الإمام القائد وأبدوا ملاحظاتهم في التكميل والتصحيح والتحسين، فأخذ المؤلف الفاضل بتلك الملاحظات وأصبحت الرسالة جاهزة للطباعة والنشر. نسأل الله أن يشمل قائدنا المفدى برعايته، ويطيل في عمره المبارك، ويوفقنا جميعا للمواظبة في العمل بالواجبات والاهتمام بالمستحبات والاحتراز عن المكروهات، والكف عن المحرمات بصونه وحراسته إنه حميد مجيد.

آية الله السيد مجتبى الحسيني  
۱۳ ربيع المولد ١٤٣٨  
١٢-٢٠١٦-۱۲
                  
                  ''',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.white,
                    fontFamily: 'Arial',
                  ),
                  softWrap: true,
                ),
                SizedBox(height: 10),
                // إضافة المزيد من النصوص هنا
                // ...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
