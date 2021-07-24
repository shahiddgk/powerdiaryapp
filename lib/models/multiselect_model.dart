class MultiselectItem {
  final String display;
  final dynamic value;

  MultiselectItem({this.display, this.value});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display'] = this.display;
    data['value'] = this.value;
    return data;
  }
}
