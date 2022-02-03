import 'package:e_commercial/db/lpg_agenecies_db.dart';
import 'package:e_commercial/model/agency.dart';
import 'package:e_commercial/screens/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_commercial/services/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  double usrLatitude = 0;
  double usrLongitude = 0;
  String s1 = '', s2 = '', s3 = '';
  List agencyListBuffer = [];
  List<LPGAgency> agencyListFinal = [];

  void getLocationFinal() async {
    Position _usrLocation = await Location().getLocation();
    usrLatitude = _usrLocation.latitude;
    usrLongitude = _usrLocation.longitude;
  }

  void addrToCoord() async {
    GeoCode geoCode = GeoCode(apiKey: "#APIKEYHERE");
    try {
      Coordinates coordinates =
          await geoCode.forwardGeocoding(address: s1 + ", " + s2 + ", " + s3);
      usrLatitude = coordinates.latitude!;
      usrLongitude = coordinates.longitude!;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future loadAgencyList() async {
    setState(() {
      isLoading = true;
    });

    //To Avoid duplication of data
    agencyListFinal = [];

    agencyListBuffer = await AgencyDB.instance.readAgencyList();
    for (var agency in agencyListBuffer) {
      // print(agency['ID']);
      agencyListFinal.add(
        LPGAgency(
            id: agency['ID'],
            name: agency['Name'],
            lat: agency['Latitude'],
            long: agency['Longitude']),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationFinal();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LPG Finder'),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    onChanged: (val) {
                      s1 = val;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Apartment Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    onChanged: (val) {
                      s2 = val;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter City & State Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    onChanged: (val) {
                      s3 = val;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Country Name',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                //-------------FOR ADDRESS----------
                MaterialButton(
                  onPressed: () async {
                    addrToCoord();
                    await loadAgencyList();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(
                            agencyList: agencyListFinal,
                            usrLong: usrLongitude,
                            usrLat: usrLatitude,
                          ),
                        ));
                  },
                  child: const Text(
                    'Find Stations',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
                //-----------FOR LOCATION---------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      color: Colors.blue,
                      onPressed: () async {
                        getLocationFinal();
                        await loadAgencyList();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(
                                agencyList: agencyListFinal,
                                usrLong: usrLongitude,
                                usrLat: usrLatitude,
                              ),
                            ));
                      },
                      child: const Text(
                        'LPG Near Me',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Visibility(
                    visible: isLoading,
                    child: const CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
