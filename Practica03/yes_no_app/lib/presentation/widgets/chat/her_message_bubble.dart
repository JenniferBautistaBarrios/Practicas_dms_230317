import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class HerMessageBubble extends StatelessWidget {
  final Message message;

  const HerMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              message.isLoading ? 'Pensando...' : message.text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (message.imageUrl != null) ...[
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              message.imageUrl!,
              width: size.width * 0.7,
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: size.width * 0.7,
                  height: 150,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                developer.log(
                  'No se pudo cargar el GIF ${message.imageUrl}',
                  error: error,
                  stackTrace: stackTrace,
                  name: 'HerMessageBubble',
                );
                return const SizedBox(
                  width: 220,
                  height: 90,
                  child: Center(
                    child: Text('No se pudo cargar el GIF. Revisa tu conexión.'),
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 10),
      ],
    );
  }
}
