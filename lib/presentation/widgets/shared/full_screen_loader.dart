import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final List<String> messages = [
      'Cargando...',
      'Espera un momento...',
      'Estamos preparando todo...',
      'Estamos casi listos...',
      'Estamos listos...',
    ];
    return Stream.periodic(const Duration(milliseconds: 1200), (int index) {
      return messages[index % messages.length];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
          ),
          const SizedBox(height: 10),
          StreamBuilder(stream: getLoadingMessages(), builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Cargando...');
            return Text(snapshot.data!);
          })
        ],
      ),
    );
  }
}
