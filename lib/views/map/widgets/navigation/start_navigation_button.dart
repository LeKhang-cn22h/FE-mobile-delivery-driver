import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/navigation_viewmodel.dart';

class StartNavigationButton extends StatelessWidget {
  const StartNavigationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 20,
      right: 80,
      child: SizedBox(
        height: 55,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 8,
          ),
          onPressed: () => context.read<NavigationViewModel>().toggleNavigation(),
          icon: const Icon(Icons.navigation),
          label: const Text(
            "BẮT ĐẦU ĐI",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}