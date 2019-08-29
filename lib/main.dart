import 'package:flutter/material.dart';
import 'package:lynk_mobile/auth.dart';
import 'package:lynk_mobile/profile.dart';

void main() => runApp(Login());

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lynk',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lynk'),
          backgroundColor: Colors.lightBlue,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              LoginButton()
            ]
          )
        )
      )
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialButton(
            onPressed: () => authService.signOut(),
            color: Colors.lightBlue,
            textColor: Colors.white,
            child: Text('Signout'),
          );
        } else {
          return MaterialButton(
            onPressed: () {
              signIn(context);
            },
            color: Colors.lightBlue,
            textColor: Colors.white,
            child: Text('Login with Google'),
          );
        }
      }
    );
  }

  void signIn(BuildContext context) {
    authService.googleSignIn();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainProfile()),
    );
  }

}



// class UserProfile extends StatefulWidget {
//   @override 
//   UserProfileState createState() => UserProfileState();
// }

// class UserProfileState extends State<UserProfile> {
//   Map<String, dynamic> _profile;
//   var _loading = false;

//   @override
//   initState() {
//     super.initState();

//     authService.profile.listen((state) => setState(() => _profile = state));
//     authService.loading.listen((state) => setState(() => _loading = state));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
//       Text(_loading.toString())
//     ]);
//   }
// }

