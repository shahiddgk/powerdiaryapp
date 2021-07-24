class PostCodeReadResponse {
  String postcode;
  String postcodeInward;
  String postcodeOutward;
  String postTown;
  String dependantLocality;
  String doubleDependantLocality;
  String thoroughfare;
  String dependantThoroughfare;
  String buildingNumber;
  String buildingName;
  String subBuildingName;
  String poBox;
  String departmentName;
  String organisationName;
  int udprn;
  String umprn;
  String postcodeType;
  String suOrganisationIndicator;
  String deliveryPointSuffix;
  String line1;
  String line2;
  String line3;
  String premise;
  double longitude;
  double latitude;
  int eastings;
  int northings;
  String country;
  String traditionalCounty;
  String administrativeCounty;
  String postalCounty;
  String county;
  String district;
  String ward;
  String uprn;

  PostCodeReadResponse(
      {this.postcode,
      this.postcodeInward,
      this.postcodeOutward,
      this.postTown,
      this.dependantLocality,
      this.doubleDependantLocality,
      this.thoroughfare,
      this.dependantThoroughfare,
      this.buildingNumber,
      this.buildingName,
      this.subBuildingName,
      this.poBox,
      this.departmentName,
      this.organisationName,
      this.udprn,
      this.umprn,
      this.postcodeType,
      this.suOrganisationIndicator,
      this.deliveryPointSuffix,
      this.line1,
      this.line2,
      this.line3,
      this.premise,
      this.longitude,
      this.latitude,
      this.eastings,
      this.northings,
      this.country,
      this.traditionalCounty,
      this.administrativeCounty,
      this.postalCounty,
      this.county,
      this.district,
      this.ward,
      this.uprn});

  PostCodeReadResponse.fromJson(Map<String, dynamic> json) {
    postcode = json['postcode'] == null ? "" : json['postcode'];
    postcodeInward =
        json['postcode_inward'] == null ? "" : json['postcode_inward'];
    postcodeOutward =
        json['postcode_outward'] == null ? "" : json['postcode_outward'];
    postTown = json['post_town'] == null ? "" : json['post_town'];
    dependantLocality =
        json['dependant_locality'] == null ? "" : json['dependant_locality'];
    doubleDependantLocality = json['double_dependant_locality'] == null
        ? ""
        : json['double_dependant_locality'];
    thoroughfare = json['thoroughfare'] == null ? "" : json['thoroughfare'];
    dependantThoroughfare = json['dependant_thoroughfare'] == null
        ? ""
        : json['dependant_thoroughfare'];
    buildingNumber =
        json['building_number'] == null ? "" : json['building_number'];
    buildingName = json['building_name'] == null ? "" : json['building_name'];
    subBuildingName =
        json['sub_building_name'] == null ? "" : json['sub_building_name'];
    poBox = json['po_box'] == null ? "" : json['po_box'];
    departmentName =
        json['department_name'] == null ? "" : json['department_name'];
    organisationName =
        json['organisation_name'] == null ? "" : json['organisation_name'];
    udprn = json['udprn'] == null ? 0 : json['udprn'];
    umprn = json['umprn'] == null ? "" : json['umprn'];
    postcodeType = json['postcode_type'] == null ? "" : json['postcode_type'];
    suOrganisationIndicator = json['su_organisation_indicator'] == null
        ? ""
        : json['su_organisation_indicator'];
    deliveryPointSuffix = json['delivery_point_suffix'] == null
        ? ""
        : json['delivery_point_suffix'];
    line1 = json['line_1'] == null ? "" : json['line_1'];
    line2 = json['line_2'] == null ? "" : json['line_2'];
    line3 = json['line_3'] == null ? "" : json['line_3'];
    premise = json['premise'] == null ? "" : json['premise'];
    longitude = json['longitude'] == null ? 0.0 : json['longitude'];
    latitude = json['latitude'] == null ? 0.0 : json['latitude'];
    eastings = json['eastings'] == null ? 0 : json['eastings'];
    northings = json['northings'] == null ? 0 : json['northings'];
    country = json['country'] == null ? "" : json['country'];
    traditionalCounty =
        json['traditional_county'] == null ? "" : json['traditional_county'];
    administrativeCounty = json['administrative_county'] == null
        ? ""
        : json['administrative_county'];
    postalCounty = json['postal_county'] == null ? "" : json['postal_county'];
    county = json['county'] == null ? "" : json['county'];
    district = json['district'] == null ? "" : json['district'];
    ward = json['ward'] == null ? "" : json['ward'];
    uprn = json['uprn'] == null ? "" : json['uprn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postcode'] = this.postcode;
    data['postcode_inward'] = this.postcodeInward;
    data['postcode_outward'] = this.postcodeOutward;
    data['post_town'] = this.postTown;
    data['dependant_locality'] = this.dependantLocality;
    data['double_dependant_locality'] = this.doubleDependantLocality;
    data['thoroughfare'] = this.thoroughfare;
    data['dependant_thoroughfare'] = this.dependantThoroughfare;
    data['building_number'] = this.buildingNumber;
    data['building_name'] = this.buildingName;
    data['sub_building_name'] = this.subBuildingName;
    data['po_box'] = this.poBox;
    data['department_name'] = this.departmentName;
    data['organisation_name'] = this.organisationName;
    data['udprn'] = this.udprn;
    data['umprn'] = this.umprn;
    data['postcode_type'] = this.postcodeType;
    data['su_organisation_indicator'] = this.suOrganisationIndicator;
    data['delivery_point_suffix'] = this.deliveryPointSuffix;
    data['line_1'] = this.line1;
    data['line_2'] = this.line2;
    data['line_3'] = this.line3;
    data['premise'] = this.premise;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['eastings'] = this.eastings;
    data['northings'] = this.northings;
    data['country'] = this.country;
    data['traditional_county'] = this.traditionalCounty;
    data['administrative_county'] = this.administrativeCounty;
    data['postal_county'] = this.postalCounty;
    data['county'] = this.county;
    data['district'] = this.district;
    data['ward'] = this.ward;
    data['uprn'] = this.uprn;
    return data;
  }
}

class PostCodeAddressListModel {
  List<PostCodeReadResponse> values = [];

  PostCodeAddressListModel() {
    values = [];
  }

  PostCodeAddressListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      PostCodeReadResponse model = PostCodeReadResponse.fromJson(area);
      this.values.add(model);
    }
  }
}
