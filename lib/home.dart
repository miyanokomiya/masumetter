import 'package:flutter/material.dart';
import 'maru_batsu.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('⭕️ ❌', style: TextStyle(fontSize: 50)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MaruBatsu()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
