import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MainPage extends StatelessWidget {
  final List agencyList;
  final double usrLat, usrLong;
  const MainPage(
      {required this.agencyList,
      required this.usrLat,
      required this.usrLong,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> infoTile = [];

    double width = MediaQuery.of(context).size.width / 100;

    for (int i = 0; i < agencyList.length; i++) {
      var currentAgency = agencyList[i];

      double distance = Geolocator.distanceBetween(
              usrLat, usrLong, currentAgency.lat, currentAgency.long) /
          1000;

      infoTile.add(ListTile(
        title: Text(
          'Name: ${currentAgency.name}\nDistance: ${distance.toStringAsFixed(1)} km',
          textScaleFactor: width * 0.3,
        ),
      ));
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('LPG Near You'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: infoTile,
            )),
      ),
    ));
  }
}
