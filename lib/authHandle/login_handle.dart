// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/alert_snackbar.dart';
import 'package:nike_e_commerce/services/auth/auth_exceptions.dart';
import 'package:nike_e_commerce/services/auth/auth_service.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginHandle {
  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      await AuthService.firebase().logIn(email: email, password: password);
      showTopSnackBar(
        Overlay.of(context),
        CustomAlertBar.success(
          messageStatus: 'Success',
          message: 'Logged in successfully',
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } on InvalidCredentialsAuthException {
      showTopSnackBar(
        Overlay.of(context),
        CustomAlertBar.error(
          messageStatus: 'Error',
          message: 'Invalid Credentials',
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomAlertBar.error(
          messageStatus: 'Error',
          message: 'Server error, please try again later',
        ),
      );
    }
  }
}
