import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import 'signup_presenter_factory.dart';

Widget makeSignUpPage() => SignUpPage(presenter: makeGetxSignUpPresenter());
