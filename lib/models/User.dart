import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'User.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;
  final String token;

  User({this.id, this.username, this.email, this.firstName, this.lastName, this.avatar, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['userSessionInfo'] != null && json['userSessionInfo']['userInfo'] != null)
      return User(
          id: int.parse(json['userSessionInfo']['userInfo']['@id']),
          email: json['userSessionInfo']['userInfo']['@email'],
          firstName: (json['userSessionInfo']['userInfo']['@name'] as String).split(" ")[0],
          lastName: (json['userSessionInfo']['userInfo']['@name'] as String).split(" ")[1]);
    else
      return User();
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "username": username, "email": email, "firstName": firstName, "lastName": lastName, "avatar": avatar, "token": token};
}
