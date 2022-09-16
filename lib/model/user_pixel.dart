class UserPixel {
  String? email;
  UserPixel({this.email});

  Map toJson() => {
        'email': email,
      };

  UserPixel.fromJson(Map json) : email = json['email'];
}
