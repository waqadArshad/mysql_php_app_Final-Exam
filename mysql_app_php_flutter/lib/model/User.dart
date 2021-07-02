class User{
  String id;
  String name;
  String email;
  String phone;
  String skill;
  String blood_group;
  String address;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.skill,
      this.blood_group,
      this.address});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      skill: json['skill'] as String,
      blood_group: json['blood_group'] as String,
      address: json['address'] as String,
    );
  }
}
