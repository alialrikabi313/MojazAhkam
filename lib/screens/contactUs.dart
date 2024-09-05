import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';




class ContactUsPage extends StatelessWidget {
  void _openWhatsApp() async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '+9647818207212', // يجب إدخال رقم الهاتف هنا
    );
    await launch(whatsappUri.toString());

  }

  void _openTelegram() async {
    final Uri telegramUri = Uri(
      scheme: 'https',
      host: 't.me',
      path: 'abutaiser', // يجب إدخال اسم المستخدم هنا
    );
    await launch(telegramUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('اتصل بنا'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _openWhatsApp,
                child: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  size: 100,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 50),
              GestureDetector(
                onTap: _openTelegram,
                child: FaIcon(
                  FontAwesomeIcons.telegram,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}