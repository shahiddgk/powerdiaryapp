class PostCodeAddressListRequest {
  String postcode;
  String apiKey;

  PostCodeAddressListRequest(this.postcode, this.apiKey);

  // _zipController.text.split(" ").join("")
  // this.postcode,
  //_zipController.text.split(" ").join(""),

// PostCodeAddressListRequest.fromJson(Map<String, dynamic> json) {
  //   postcode = json['postcode'];
  //   apiKey = json['api_key'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> result = new Map<String, dynamic>();
  //   result['postcode'] = this.postcode.toString();
  //   result['api_key'] = this.postcode.toString();
  //   return result;
  // }
}
