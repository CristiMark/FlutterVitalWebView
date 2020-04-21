
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:local_auth/local_auth.dart';

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
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState(){
    super.initState();
   // checkBiometrics();
   // getAvailableBiometrics();
    authenticate();

  
   // cancelAuthentication();
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
    return;
  });
}


void loadPayPage(){
      
   flutterWebviewPlugin.onUrlChanged.where((x) => x.contains("welcome")).listen((String url) {
      if (mounted) {
        print("Current URL: $url");
            var newurl = url.replaceRange(url.lastIndexOf('/')+1,url.lastIndexOf('.'), "plata");
            print("New Address :  $newurl ");
            flutterWebviewPlugin.reloadUrl(newurl);
      }
    });      

}

Future<void> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);    

      if(authenticated){
         flutterWebviewPlugin.reloadUrl("https://plati.vitalmm.ro/login.jsp");
          loadJS();
          loadPayPage();
        }     
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });

  }

  // void cancelAuthentication() {
  //   auth.stopAuthentication();
  // }

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

