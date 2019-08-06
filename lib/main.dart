import 'dart:html';
import 'dart:js' as JS;

import 'package:flutter_web_ui/ui.dart' as ui;
import 'package:flutter_web/material.dart';
import 'dart:async';

void main() {
  runApp(Directionality(
    textDirection: TextDirection.ltr,
    child: MaterialApp(home: Home()),
  ));
}

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
        },
        color: Colors.blue,
        child: Text('jump'),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  static int count = 0;

  SecondRoute() {
    if (count == 0) {
      ui.platformViewRegistry.registerViewFactory(
          'hello-world-html', (int viewId) => embededV1(viewId));
      count = count + 1;
    }
  }

  VideoElement embededV1(int viewId) {
    var element = VideoElement();
    element.id = 'preview';
    //element.controls = true;
    //element.src = 'https://www.w3schools.com/html/mov_bbb.mp4';

    final scanner = JS.JsObject(JS.context['Instascan']['Scanner'], [element]);
    scanner.callMethod('addListener', [
      'scan',
      (content) {
        print(content);
      }
    ]);

    JS.JsFunction cameras = JS.context['Instascan']['Camera'];
    final promise = cameras.callMethod('getCameras');

    promise.callMethod('then', [
      (cameras) {
        if (cameras.length > 0) {
          print('get camera open!');
          scanner.callMethod('start', [cameras[0]]);
        } else {
          print('No cameras found.');
        }
      }
    ]);
    return element;
  }

  @override
  Widget build(BuildContext context) {
    final html = HtmlView(viewType: 'hello-world-html');

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: html,
    );
  }
}
