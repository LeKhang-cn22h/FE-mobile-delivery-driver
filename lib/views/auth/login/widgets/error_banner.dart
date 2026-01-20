import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  const ErrorBanner({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),

      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red,),
          const SizedBox(width: 8,),
          Expanded(child: Text(message, style: TextStyle(color: Colors.red, fontSize: 16),
          )
          ),
          if(onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.clear, color: Colors.grey[500],),
            )
        ]
      ),
    );
  }
}
