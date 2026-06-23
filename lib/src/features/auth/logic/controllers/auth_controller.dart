import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/auth_user.dart';

/// Provider to store the currently authenticated user.
final currentUserProvider = StateProvider<AuthUser?>((ref) => null);
