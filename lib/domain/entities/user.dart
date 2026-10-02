import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String emailOrMobile;

  const User({
    required this.id,
    required this.name,
    required this.emailOrMobile,
  });

  @override
  List<Object?> get props => [id, name, emailOrMobile];
}
