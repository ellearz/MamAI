import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mother_ai/pages/onboarding_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mother_ai/model/milestone.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:mother_ai/components/constant.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    exit(1);
  }

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Failed to load environment variables: $e');
    exit(1);
  }

  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register Hive adapters
  Hive.registerAdapter(MilestoneAdapter());

  // Open Hive boxes
  try {
    await Hive.openBox<Milestone>('milestones');
    await Hive.openBox<Milestone>('fixed_milestones');
  } catch (e) {
    print('Failed to open Hive boxes: $e');
    exit(1);
  }

  // Retrieve API key
  final apiKey = myApiKey; // Ensure 'API_KEY' is in your .env file
  if (apiKey == null) {
    print('No API_KEY environment variable');
    exit(1);
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}