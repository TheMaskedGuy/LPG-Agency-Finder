//DB Schema

//table name
const String agencyTableName = 'LPGAgency';

class LPGAgency {
  final int id;
  final String name;
  final double lat;
  final double long;

  const LPGAgency({
    required this.id,
    required this.name,
    required this.long,
    required this.lat,
  });
}
