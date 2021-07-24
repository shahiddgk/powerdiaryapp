class SessionUserModel {
  int id;
  int roleId;
  int companyId;
  String name;
  String email;
  String image;
  int isActive;
  int isDeleted;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;

  SessionUserModel(
      {this.id,
      this.roleId,
      this.companyId,
      this.name,
      this.email,
      this.image,
      this.isActive,
      this.isDeleted,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  SessionUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    roleId = json['role_id'] == null ? 0 : json['role_id'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    name = json['name'] == null ? "" : json['name'];
    email = json['email'] == null ? "" : json['email'];
    image = json['image'] == null ? "" : json['image'];
    isActive = json['is_active'] == null ? 0 : json['is_active'];
    isDeleted = json['is_deleted'] == null ? 0 : json['is_deleted'];
    emailVerifiedAt =
        json['email_verified_at'] == null ? "" : json['email_verified_at'];
    createdAt = json['created_at'] == null ? "" : json['created_at'];
    updatedAt = json['updated_at'] == null ? "" : json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
