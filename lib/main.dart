import 'package:dummyexpense/core/theme/theme.dart';
import 'package:dummyexpense/onboarding/screens/splash_screen.dart';
import 'package:dummyexpense/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyexpense/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dummyexpense/features/category/presentation/bloc/category_bloc.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:dummyexpense/features/sync/presentation/bloc/sync_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Initialize dependency injection
  await InjectionContainer.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => InjectionContainer.authBloc),
        BlocProvider<CategoryBloc>(create: (_) => InjectionContainer.categoryBloc),
        BlocProvider<TransactionBloc>(create: (_) => InjectionContainer.transactionBloc),
        BlocProvider<SyncBloc>(create: (_) => InjectionContainer.syncBloc),
      ],
      child: MaterialApp(
        title: 'Expense Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
