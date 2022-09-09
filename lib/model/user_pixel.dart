class UserPixel {
  String? email;
  UserPixel({this.email});

  UserPixel.fromJson(Map json) : email = json['email'];
}
