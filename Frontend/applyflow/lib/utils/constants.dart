import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFFAFAF9);
  static const ink = Color(0xFF0F172A); 
  static const textSecondary = Color(0xFF6B6B68);
  static const textMuted = Color(0xFF9A9890);
  static const border = Color(0xFFE5E3DB);
  static const primary = Color(0xFF2563EB);

  // Status Colors - These directly to your backend's status enum
  static const wishlist = Color(0xFF6B6B68);
  static const applied = Color(0xFFD97706);
  static const interview = Color(0xFF7C3AED);
  static const offer = Color(0xFF059669);
  static const rejected = Color(0xFFDC2626);

  static Color statusColor(String status){
    switch(status){
      case 'Applied' : return applied ;
      case 'INTERVIEW' : return interview ; 
      case 'OFFER' : return offer ; 
      case 'REJECTED' : return rejected ; 
      default : return wishlist ; 
    }
  }
}

class ApiConfig {
  // Change this to your deployed Railway URL once live
  static const baseUrl = 'http://10.0.2.2:8000/api/v1';
  // 10.0.2.2 is how Android emulator reaches your laptop's localhost.
  // On a physical phone on the same WiFi, use your laptop's local IP instead, e.g. 192.168.1.5
  // Once deployed: static const baseUrl = 'https://your-app.up.railway.app/api/v1';
}

