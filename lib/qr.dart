import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

const baseUrl = 'https://gmail.com';

class QRCode extends StatefulWidget {
  @override 
  QRCodeState createState() => QRCodeState();
}

class QRCodeState extends State<QRCode> {

  final _qr = new QrImage(
    data: baseUrl,
    size: 200,
  );

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildQR(),
    );
  }

  Widget _buildQR() {
    return Center(
      child: _qr
    );
  }
}