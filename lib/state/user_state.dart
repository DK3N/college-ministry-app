import 'package:flutter/material.dart';

/// A global "whiteboard" to hold user session data (like member_id)
/// across the entire app without needing to re-fetch it from the database.
class UserState extends ChangeNotifier {
  // 1. Private state variables
  int? _memberId;
  bool _is_minister = false;
  bool _is_cg_leader = false;

  // 2. Public getters (so other widgets can read the data)
  int? get memberId => _memberId;
  bool get isLoggedIn => _memberId != null;
  bool get is_minister => _is_minister;
  bool get is_cg_leader => _is_cg_leader;


  // 3. Methods to update the state
  void setMemberId(int id) async {
    _memberId = id;
    notifyListeners();
  }

  void setIsMinister(bool isMinister) async {
    _is_minister = isMinister;
    notifyListeners();
  }

  void setIsCGLeader(bool isCGLeader) async {
    _is_cg_leader = isCGLeader;
    notifyListeners();
  }

  void clearState() {
    _memberId = null;
    notifyListeners();
  }
}