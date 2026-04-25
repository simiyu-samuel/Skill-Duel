import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IIAPService {
  Future<void> purchasePro(String uid);
  Future<bool> checkProStatus(String uid);
}

class IAPService implements IIAPService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> purchasePro(String uid) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // In dev mode, we just update Firestore directly
    await _firestore.collection('users').doc(uid).update({
      'isPro': true,
    });
  }

  @override
  Future<bool> checkProStatus(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['isPro'] ?? false;
  }
}

final iapServiceProvider = Provider<IIAPService>((ref) => IAPService());
