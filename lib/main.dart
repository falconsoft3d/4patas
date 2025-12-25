import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'config/theme.dart';
import 'services/auth_service.dart';
import 'services/pet_service.dart';
import 'services/vaccine_service.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/pets_screen.dart';
import 'screens/create_pet_screen.dart';
import 'screens/pet_detail_screen.dart';
import 'screens/edit_pet_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/add_vaccine_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<PetService>(create: (_) => PetService()),
        Provider<VaccineService>(create: (_) => VaccineService()),
      ],
      child: MaterialApp.router(
        title: '4Patas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

// Router Configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/pets',
      builder: (context, state) => const PetsScreen(),
    ),
    GoRoute(
      path: '/create-pet',
      builder: (context, state) => const CreatePetScreen(),
    ),
    GoRoute(
      path: '/pet-detail/:id',
      builder: (context, state) {
        final petId = state.pathParameters['id']!;
        return PetDetailScreen(petId: petId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/edit-pet/:id',
      builder: (context, state) {
        final petId = state.pathParameters['id']!;
        return EditPetScreen(petId: petId);
      },
    ),
    GoRoute(
      path: '/add-vaccine/:petId',
      builder: (context, state) {
        final petId = state.pathParameters['petId']!;
        return AddVaccineScreen(petId: petId);
      },
    ),
  ],
);
