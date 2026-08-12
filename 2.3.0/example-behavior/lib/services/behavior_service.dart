/// Holds session/user state shared across Login, Home and Dashboard
/// (mirrors Capacitor BehaviorService).
class BehaviorService {
  BehaviorService._();
  static final BehaviorService instance = BehaviorService._();

  String sessionId = '';
  String userId = '';
}
