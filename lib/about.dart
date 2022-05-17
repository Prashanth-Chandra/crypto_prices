import 'package:flutter/material.dart';
import './home.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          centerTitle: true,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 120,
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/logo2.png',
                    height: 40,
                  ),
                )
              ],
            ),
          ),

          //backgroundColor: Colors.blueGrey[800],
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(5.0, 40.0, 5.0, 0.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                    'This app is to check the curent crypto prices.\nWill add a feature later to steal your crypto when you open the app   ; - ) ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ));
  }
}
