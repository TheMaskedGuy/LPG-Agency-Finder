import 'package:e_commercial/model/agency.dart';
import 'package:sqflite/sqflite.dart';

class AgencyDB {
  static final AgencyDB instance = AgencyDB._init();
  static Database? _database;

  // //priv cons
  AgencyDB._init();

  //opening the db
  Future<Database> get database async {
    _database =
        await openDatabase('lpg_agency.db', version: 1, onCreate: createDB);
    return _database!;
  }

  //Schema for sql db
  Future createDB(Database db, int version) async {
    // final db = await instance.database;
    //create table with schema
    await db.rawQuery(
        'CREATE TABLE LPGAgency(ID INTEGER PRIMARY KEY, Name Text, Latitude DOUBLE, Longitude DOUBLE)');

    //adding data
    await db.rawInsert(
        'INSERT INTO LPGAgency (Name, Latitude, Longitude) VALUES (\'Remi\',19.19696226139419, 72.96165770699464)');
    await db.rawInsert(
        'INSERT INTO LPGAgency (Name, Latitude, Longitude) VALUES (\'Global\',19.211681126471493, 72.9936749357708)');
    await db.rawInsert(
        'INSERT INTO LPGAgency (Name, Latitude, Longitude) VALUES (\'GHC\',19.161729971788493, 73.029016246725)');
    await db.rawInsert(
        'INSERT INTO LPGAgency (Name, Latitude, Longitude) VALUES (\'LH Hira\',19.125049628503415, 72.9176010744161)');
    await db.rawInsert(
        'INSERT INTO LPGAgency (Name, Latitude, Longitude) VALUES (\'UpVan\',19.226253275466384, 72.95537351863838)');
    await db.rawInsert(
        'INSERT INTO LPGAgency (Name, Latitude, Longitude) VALUES (\'Taj Mahal\',27.17532612891537, 78.04212073922581)');
    await db.rawInsert(
        'INSERT INTO LPGAgency (Name, Latitude, Longitude) VALUES (\'Great Wall of China\',40.4321526752919, 116.57032125315578)');
    await db.rawInsert(
        'INSERT INTO LPGAgency (Name, Latitude, Longitude) VALUES (\'Big Ben\',51.50090282681599, -0.12460394452271507)');
  }

  Future readAgencyList() async {
    final db = await instance.database;
    final result = await db.query(agencyTableName);

    return result;
  }

  //closing db
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

// class AgencyDB {
//   static final AgencyDB instance = AgencyDB._init();
//   static Database? _database;
//
//   //priv cons
//   AgencyDB._init();
//
//   //opening the db
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     } else {
//       //create a db
//       _database = await _initDB('lpg_agency.db');
//       return _database!;
//     }
//   }
//
//   //creating the db
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }
//
//   //Schema for sql db
//   Future _createDB(Database db, int version) async {
//     const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     const String textType = 'TEXT NOT NULL';
//     const String doubleType = 'DOUBLE NOT NULL';
//
//     db.execute('''
//     CREATE TABLE $agencyTableName(
//     ${LPGAgencyFields.id} $idType,
//     ${LPGAgencyFields.name} $textType,
//     ${LPGAgencyFields.lat} $doubleType,
//     ${LPGAgencyFields.long} $doubleType
//     )
//     ''');
//   }
//
//   //Adding data in db
//   Future<LPGAgency> create(LPGAgency agency) async {
//     final db = await instance.database;
//     final id = await db.insert(agencyTableName, agency.toJson());
//   }
//
//   //closing db
//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }
