import 'package:flutter/material.dart';
import 'package:frameup/app/fram_up.dart';
import 'package:frameup/net/flutterfire.dart';
import 'package:frameup/ui/home_view.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: _emailField,
              decoration: InputDecoration(
                  hintText: "user1234g@email.com",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
            ),
            TextField(
              controller: _passwordField,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 36),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: MaterialButton(
                onPressed: () async {
                  bool shouldNavigate =
                      await register(_emailField.text, _passwordField.text);
                  if (shouldNavigate) {
                    //Navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FrameupApp(),
                      ),
                    );
                  }
                },
                child: Text("Register"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: MaterialButton(
                  onPressed: () async {
                    bool shouldNavigate =
                        await signIn(_emailField.text, _passwordField.text);
                    if (shouldNavigate) {
                      //Navigate
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FrameupApp(),
                        ),
                      );
                    }
                  },
                  child: Text("Login")),
            ),
          ],
        ),
      ),
    );
  }
}
