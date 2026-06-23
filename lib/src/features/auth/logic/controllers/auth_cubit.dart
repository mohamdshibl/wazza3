import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_user.dart';

class AuthCubit extends Cubit<AuthUser?> {
  AuthCubit() : super(null);

  void setUser(AuthUser? user) => emit(user);
  void clear() => emit(null);
}
