import 'package:flutter/foundation.dart';

@immutable
class AppUser {
  final String uid;
  final String username;
  final int elo;
  final bool isPro;
  final bool isOnline;
  final String status;
  final String? avatarUrl;
  final String? avatarLetter;

  const AppUser({
    required this.uid,
    required this.username,
    this.elo = 1000,
    this.isPro = false,
    this.isOnline = false,
    this.status = 'Offline',
    this.avatarUrl,
    this.avatarLetter,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'elo': elo,
      'isPro': isPro,
      'isOnline': isOnline,
      'status': status,
      'avatarUrl': avatarUrl,
      'avatarLetter': avatarLetter,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      uid: id,
      username: map['username'] ?? '',
      elo: map['elo'] ?? 1000,
      isPro: map['isPro'] ?? false,
      isOnline: map['isOnline'] ?? false,
      status: map['status'] ?? 'Offline',
      avatarUrl: map['avatarUrl'],
      avatarLetter: map['avatarLetter'],
    );
  }

  AppUser copyWith({
    int? elo,
    bool? isPro,
    bool? isOnline,
    String? status,
    String? username,
  }) {
    return AppUser(
      uid: uid,
      username: username ?? this.username,
      elo: elo ?? this.elo,
      isPro: isPro ?? this.isPro,
      isOnline: isOnline ?? this.isOnline,
      status: status ?? this.status,
      avatarUrl: avatarUrl,
      avatarLetter: avatarLetter,
    );
  }
}
