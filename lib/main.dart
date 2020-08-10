import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {

  String _status;

  @override
  void initState() {
    super.initState();
    _status = 'Not Authenticated';
  }

  void _signInAnon() async {
    final authResult = await _auth.signInAnonymously();
    final user = authResult.user;
    if (user != null && user.isAnonymous) {
      setState(() {
        _status = 'Signed in Anonymously:\n'
                  'User uid: ${authResult.user.uid}';
      });
    } else {
      setState(() {
        _status = 'Sign in failed!';
      });
    }
  }

  void _signInGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    if (user != null && !user.isAnonymous) {
      setState(() {
        _status = 'Signed in with Google\n'
            'User uid: ${user.uid}\n'
            'User email: ${user.email}\n'
            'User name: ${user.displayName}\n'
            'User phoneNumber: ${user.phoneNumber}';
      });
    } else {
      setState(() {
        _status = 'Google Sign-in Failed';
      });
    }
  }

  void _signOut() async {
    await _auth.signOut();
    setState(() {
      _status = 'Signed out';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Name here'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(_status),
              new RaisedButton(onPressed: _signOut, child: new Text('Sign out'),),
              new RaisedButton(onPressed: _signInAnon, child: new Text('Sign in Anon'),),
              new RaisedButton(onPressed: _signInGoogle, child: new Text('Sign in Google'),),
            ],
          ),
        )
      ),
    );
  }
}
