
import 'dart:async';
//import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vitalflutter/credention_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vitalflutter/login_page.dart';


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
     // home: RunJSInWebView(),
     initialRoute: '/',
      routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => RunJSInWebView(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/credential': (context) => CredentionsPage(),
  },

    //  home: LoginPage(),
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
  String _url = 'https://plati.vitalmm.ro/login.jsp';
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState(){
    super.initState();
    //checkBiometrics();
    //getAvailableBiometrics();

    //authenticate();

  
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
            flutterWebviewPlugin.reloadUrl(newurl).whenComplete(() => 
           makeAllPaymant()
           
            );
          
            
      }
    });      

}

void makeAllPaymant()
{
  
   new Future.delayed(const Duration(seconds: 3), () =>
  flutterWebviewPlugin.evalJavascript('''document.getElementById('addall').click();
                                      document.getElementById('cont_plata2').click();'''));

   new Future.delayed(const Duration(seconds: 5), () =>
  flutterWebviewPlugin.evalJavascript('''document.getElementById('j_idt72').click();'''));
}

Future<void> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

        canCheckBiometrics
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

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
     url: _url,           
    // url: '', 
    
    hidden: true,          
     withZoom: true,
      appBar: AppBar(
       title: Text("My Vital Acount"),
       actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.add_alert),
          //   tooltip: 'Show Snackbar',
          //   onPressed: () {
          //    // scaffoldKey.currentState.showSnackBar(snackBar);
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Autentificare',
            onPressed: () {
              setState(() {
                _url = "";
              });
            Navigator.pushNamed(context, '/credential');
                    
            },
          ),
        ],
        ),   
      
    );
  }
}

