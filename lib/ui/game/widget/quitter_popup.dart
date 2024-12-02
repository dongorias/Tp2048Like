import 'package:flutter/material.dart';

class QuitConfirmationPopup extends StatelessWidget {
  final VoidCallback onQuit;
  final VoidCallback onCancel;

  const QuitConfirmationPopup({
    super.key,
    required this.onQuit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Êtes-vous sûr de vouloir quitter?',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onQuit,
                      child: const Text('Oui'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}