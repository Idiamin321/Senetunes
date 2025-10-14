import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String? token;

  const User({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    this.token,
  });

  /// Parse robuste (gère les champs absents/typage hétérogène)
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      final usi = json['userSessionInfo'];
      final ui = usi != null ? usi['userInfo'] : null;
      if (ui != null) {
        final idStr = ui['@id']?.toString();
        final fullName = (ui['@name']?.toString() ?? '').trim();
        final parts = fullName.split(' ');
        final first = parts.isNotEmpty ? parts.first : null;
        final last = parts.length > 1 ? parts.sublist(1).join(' ') : null;

        return User(
          id: int.tryParse(idStr ?? ''),
          email: ui['@email']?.toString(),
          firstName: first,
          lastName: last,
        );
      }
    } catch (_) {
      // on tombe sur la version "vide", sans crasher
    }
    return const User();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'avatar': avatar,
    'token': token,
  };
}
