import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_gate_provider.g.dart';

@riverpod
class IsAuthorised extends _$IsAuthorised {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}
