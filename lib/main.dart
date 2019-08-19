import 'package:flutter/material.dart';
import 'link.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(MyApp());

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
            title: Text('Lynk'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.developer_board)),
              ]
            )
          ),
          body: TabBarView(
            children: [
              Profile(),
              QRCode()
            ]
          )
        ),
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
  //final _name = Text('name');
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: _createLink),
        ],
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
              'You have no links! Add one by pressing the button above',
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
            if (index > _links.length) {
              return null;
            }
            return _buildRow(_links[index]);
        });
    }
  }

  Widget _buildRow(Link link) {
    return ListTile(
      title: Text(
        link.description,
      ),
      trailing: link.icon,
    );
  }

  void _createLink() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Create a Link'),
            ),
            body: Text('testing'),
          );
        }, 
      ),
    );
  }

}

class QRCode extends StatefulWidget {
  @override 
  QRCodeState createState() => QRCodeState();
}

class QRCodeState extends State<QRCode> {
  final _qr = new QrImage(
    data: "https://gmail.com",
    size: 200,
  );
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your QR Code'),
      ),
      body: _buildQR(),
    );
  }

  Widget _buildQR() {
    return Center(
      child: _qr
    );
  }
}