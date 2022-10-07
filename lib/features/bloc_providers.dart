import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/home/bloc/home_bloc.dart';
import 'package:instagram_clone/features/home/bloc/home_repository.dart';
import 'package:instagram_clone/features/login/bloc/login_bloc.dart';
import 'package:instagram_clone/features/login/bloc/login_repository.dart';
import 'package:instagram_clone/features/signUp/bloc/signUp_bloc.dart';
import 'package:instagram_clone/features/signUp/bloc/signUp_repository.dart';

MultiBlocProvider listOfBlocs(Widget child) {
  return MultiBlocProvider(providers: [
    BlocProvider(
        create: (_) => SignUpBloc(signUpRepository: SignUpRepository())),
    BlocProvider(create: (_) => LoginBloc(loginRepository: LogInRepository())),
    BlocProvider(create: (_) => HomeBloc(homeRepository: HomeRepository()))
  ], child: child);
}
