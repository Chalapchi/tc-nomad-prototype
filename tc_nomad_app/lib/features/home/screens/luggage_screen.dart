import 'package:flutter/material.dart';
import '../../luggage/screens/luggage_list_screen.dart';

/// Luggage Tab Screen (Bottom Navigation)
/// Wrapper for the LuggageListScreen
class LuggageScreen extends StatelessWidget {
  const LuggageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LuggageListScreen(isSelectionMode: false);
  }
}
