import 'package:firebase_auth/firebase_auth.dart';
import 'package:pks_14/pages/profile_related/profile_page.dart';
import 'package:pks_14/pages/profile_related/seller_page.dart';
import 'package:flutter/material.dart';
import '../pages/profile_related/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.email == "seller@user.test"){
                return const SellerPage();
              } else {
                return ProfilePage(userEmail: snapshot.data!.email.toString(),);
              }
            } else {
              return const LoginPage();
            }
          }
      ),
    );
  }
}