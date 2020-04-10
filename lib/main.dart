
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      
      home: RunJSInWebView(),
     // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class RunJSInWebView extends StatefulWidget {
  @override
  RunJSInWebViewState createState() {
    return new RunJSInWebViewState();
  }
}

class RunJSInWebViewState extends State<RunJSInWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState(){
    super.initState();
    loadJS();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        print("Current URL: $url");
      }
    });
    
  }


  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  Future<String> loadJS() async {
  var givenJS = rootBundle.loadString('assets/login.js');
  return givenJS.then((String js) {
        flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        flutterWebviewPlugin.evalJavascript(js);  
      }
    });
    flutterWebviewPlugin.reloadUrl("https://plati.vitalmm.ro/welcome.jsf;jsessionid=4FC7C694CEB8D9FAD5B9D6037A089005?Adf-Window-Id=w0");
    return;
  });
}

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'https://plati.vitalmm.ro/login.jsp',
     // hidden: true,
     withZoom: true,
      appBar: AppBar(title: Text("My Vital Acount")),
      
    );
  }
}

