import './distributor.dart';

class AppData {
  String adress;
  String primaryColor;
  String secondaryColor;
  String name;
  String logoUrl;
  List<Distributor> distributors;
  AppData({
    required this.adress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.name,
    required this.logoUrl,
    required this.distributors,
  });
  AppData.fromJson(Map<String, dynamic> json)
      : adress = json['adress'],
        primaryColor = json['primaryColor'],
        secondaryColor = json['secondaryColor'],
        name = json['name'],
        logoUrl = json['logoUrl'],
        distributors = json['distributors']
            .map<Distributor>(
                (distributor) => Distributor.fromJson(distributor))
            .toList();
}
