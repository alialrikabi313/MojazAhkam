import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chapter.dart';
import 'issues_screen.dart';

class IbadatScreen extends StatefulWidget {
  IbadatScreen({Key? key}) : super(key: key);

  @override
  _IbadatScreenState createState() => _IbadatScreenState();
}

class _IbadatScreenState extends State<IbadatScreen> with SingleTickerProviderStateMixin {
  List<Chapter> _chapters = [];
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _loadChapters();
  }

  void _loadChapters() async {
    final chapters = Provider.of<ChapterProvider>(context, listen: false).ibadatChapters;
    setState(() {
      _chapters = chapters;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SlideTransition(
        position: _offsetAnimation,
        child: ListView.builder(
          itemCount: _chapters.length,
          itemBuilder: (ctx, index) {
            final chapter = _chapters[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              color: Colors.teal,
              child: ListTile(
                title: Text(
                  chapter.title,
                  style: TextStyle(fontSize: 26, color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => IssuesScreen(
                        chapterId: chapter.id,
                        tab: 'ibadat',
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
