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

  Future<Position> getLocationFinal() async {
    Position _usrLocation = await Location().getLocation();
    usrLatitude = _usrLocation.latitude;
    usrLongitude = _usrLocation.longitude;
    return _usrLocation;
  }

  void addrToCoord() async {
    GeoCode geoCode = GeoCode(apiKey: "204641088467641194307x117388");
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
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    '─────── Personal Information ───────',
                    style: TextStyle(fontSize: 15.0, color: Colors.blue),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter Your Name', labelText: 'Name'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                        hintText: 'Enter Your Phone Number',
                        labelText: 'Phone Number'),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    '─────── Address ───────',
                    style: TextStyle(fontSize: 15.0, color: Colors.blue),
                  ),
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
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await getLocationFinal();
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
                        } catch (e) {
                          SnackBar snackBar = SnackBar(content: Text('$e'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        setState(() {
                          isLoading = false;
                        });
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
