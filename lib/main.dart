import 'package:flutter/material.dart';
import 'package:lynk_mobile/link.dart';
import 'package:lynk_mobile/qr.dart';
import 'package:lynk_mobile/auth.dart';

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
              LoginButton(),
              UserProfile()
            ]
          )
        )
      )
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lynk',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Lynk')
          ),
          bottomNavigationBar: TabBar(
            tabs: [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Profile'
                ),
                Tab(
                  icon: Icon(Icons.developer_board),
                  text: 'QR Code'
                )
            ]
          ),
          body: TabBarView(
            children: <Widget>[ 
              Profile(), 
              QRCode()
            ],
          )
        ) 
      ),
    );
  }
}



class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final _links = <Link>[];
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createLink();
        },
        child: Icon(Icons.add),
      ),
      body: _buildProfile(),
    );
  }

  Widget _buildProfile() {
    if (_links.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have no links! Add one by pressing the button below',
            ),
          ],
        ),
      );
    } else {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();

            final index = i ~/ 2;
            if (index >= _links.length) {
              return null;
            }
            return _buildRow(_links[index]);
        });
    }
  }

  Widget _buildRow(Link link) {
    return ListTile(
      title: Text(link.description),
      subtitle: Text(link.source),
      trailing: Icon(link.icon)
    );
  }

  void _createLink() {
    final _formKey = GlobalKey<FormState>();
    final _socialMedia = iconDict.keys;
    String _dropdownValue = _socialMedia.elementAt(0);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButton<String>(
                    hint: Text('Site'),
                    value: _dropdownValue,
                    onChanged: (String newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    items: _socialMedia
                      .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value)
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.link),
                      labelText: 'Social Media URL'
                    ),
                    onSaved: (String value) {
                      Link newLink = Link(value,_dropdownValue);
                      _links.add(newLink);
                    },
                    validator: (String value) {
                      return value.contains('.com') ? null : 'Please put full link';
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                         form.save();
                         Navigator.pop(context);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            )
          );
        })
    );
  }
}

class UserProfile extends StatefulWidget {
  @override 
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  var _loading = false;

  @override
  initState() {
    super.initState();

    authService.profile.listen((state) => setState(() => _profile = state));
    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
      Text(_loading.toString())
    ]);
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
            onPressed: () => authService.googleSignIn(),
            color: Colors.lightBlue,
            textColor: Colors.white,
            child: Text('Login with Google'),
          );
        }
      } 
    );
  }
}