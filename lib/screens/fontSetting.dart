import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

double globalFontSize = 16.0;
String globalFontFamily = ''; // افتراضي النظام



Future<void> loadPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  globalFontSize = prefs.getDouble('fontSize') ?? 16.0;
  globalFontFamily = prefs.getString('fontFamily') ?? '';
}


class FontSettingsPage extends StatefulWidget {
  @override
  _FontSettingsPageState createState() => _FontSettingsPageState();
}

class _FontSettingsPageState extends State<FontSettingsPage> {
  double _fontSize = globalFontSize;
  String _selectedFont = globalFontFamily;

  final List<String> _fonts = [
    'افتراضي النظام',
    'Amiri',
    'Cairo',
    'Lateef',
    'ReemKufi',
    'Scheherazade'
  ];

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setString('fontFamily', _selectedFont);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إعدادات الخط'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'نوع الخط',
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _fonts.length,
                  itemBuilder: (context, index) {
                    return RadioListTile<String>(
                      title: Text(
                        'بسم الله الرحمن الرحيم',
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontFamily: _fonts[index] == 'افتراضي النظام' ? null : _fonts[index],
                        ),
                      ),
                      value: _fonts[index] == 'افتراضي النظام' ? '' : _fonts[index],
                      groupValue: _selectedFont,
                      onChanged: (value) {
                        setState(() {
                          _selectedFont = value!;
                          globalFontFamily = _selectedFont;
                          _savePreferences();
                        });
                      },
                    );
                  },
                ),
              ),
              Text(
                'حجم الخط',
                style: TextStyle(fontSize: 20),
              ),
              Slider(
                value: _fontSize,
                min: 14.0,
                max: 36.0,
                divisions: 22,
                label: _fontSize.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                    globalFontSize = _fontSize;
                    _savePreferences();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

