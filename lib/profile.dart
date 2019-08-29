import 'package:flutter/material.dart';
import 'package:lynk_mobile/models/link_model.dart';
import 'package:lynk_mobile/qr.dart';
import 'package:lynk_mobile/auth.dart';

class MainProfile extends StatelessWidget {
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
            title: Text('Lynk'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove_circle),
                tooltip: 'Logoff',
                onPressed: () {
                  authService.signOut();
                  Navigator.pop(context);
                }
              )
            ],
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
                      Link newLink = Link.construct(value,_dropdownValue);
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