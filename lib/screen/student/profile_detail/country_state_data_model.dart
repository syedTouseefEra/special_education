


class CountryDataModal {
  int? countryId;
  String? countryName;
  String? countryCode;
  String? phoneCode;
  String? currency;

  CountryDataModal(
      {this.countryId,
        this.countryName,
        this.countryCode,
        this.phoneCode,
        this.currency});

  CountryDataModal.fromJson(Map<String, dynamic> json) {
    countryId = json['countryId'];
    countryName = json['countryName'];
    countryCode = json['countryCode'];
    phoneCode = json['phoneCode'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryId'] = countryId;
    data['countryName'] = countryName;
    data['countryCode'] = countryCode;
    data['phoneCode'] = phoneCode;
    data['currency'] = currency;
    return data;
  }
}

class StateDataModel {
  int? stateId;
  String? stateName;
  String? stateCode;
  int? countryId;

  StateDataModel(
      {this.stateId, this.stateName, this.stateCode, this.countryId});

  StateDataModel.fromJson(Map<String, dynamic> json) {
    stateId = json['stateId'];
    stateName = json['stateName'];
    stateCode = json['stateCode'];
    countryId = json['countryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['stateCode'] = stateCode;
    data['countryId'] = countryId;
    return data;
  }
}

class CityDataModel {
  int? cityId;
  String? cityName;
  int? stateId;

  CityDataModel(
      {this.cityId, this.cityName,this.stateId});

  CityDataModel.fromJson(Map<String, dynamic> json) {
    cityId = json['cityId'];
    cityName = json['cityName'];
    stateId = json['stateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    data['stateId'] = stateId;
    return data;
  }
}