import 'package:flutter/material.dart';
import 'treino_page.dart';

class HomePage extends StatelessWidget {
  final bool modoEscuro;
  final VoidCallback trocarTema;

  const HomePage({
    super.key,
    required this.modoEscuro,
    required this.trocarTema,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Treino'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(250, 55),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TreinoPage(),
              ),
            );
          },
          child: const Text(
            'Iniciar treino',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}