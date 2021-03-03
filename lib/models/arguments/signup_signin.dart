import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';

@immutable
class SignUpSignInArguments implements Arguments{
  final String email;

  const SignUpSignInArguments(this.email);
}