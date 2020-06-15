import 'package:flutter/material.dart';

class CredentionsPage extends StatefulWidget {
  @override
  _CredentionsPageState createState() => _CredentionsPageState();
}

class _CredentionsPageState extends State<CredentionsPage> {
      @override
      Widget build(BuildContext context) {

        final emailField = TextField(
          obscureText: false,
         // style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );

        final passwordField = TextField(
          obscureText: true,
         // style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Parola",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );

        final loginButon = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {},
            child: Text("Setare Autentificare",
                textAlign: TextAlign.center,
                // style: style.copyWith(
                //     color: Colors.white, fontWeight: FontWeight.bold)
                ),
          ),
        );
        return new WillPopScope(
        child: Scaffold(
         // appBar: AppBar(
         // title: Text("My Vital Acount"),     
          body: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(
                    //   height: 155.0,
                    //   child: Image.asset(
                    //     "assets/logo.png",
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    SizedBox(
                      height: 155.0,
                      child: Text("Setateaza detaliile de conectare Vital.ro",
                             textAlign: TextAlign.center,
                            // style: style.copyWith(
                            // color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                      ),
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
       // ),
        ),
         onWillPop: () async {
         Navigator.pop(context);
         return true;
      },
        );
      }
  
}