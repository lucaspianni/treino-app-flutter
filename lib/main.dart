import 'pages/treino_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MeuTreinoApp());
}

class MeuTreinoApp extends StatefulWidget {
  const MeuTreinoApp({super.key});

  @override
  State<MeuTreinoApp> createState() => _MeuTreinoAppState();
}

class _MeuTreinoAppState extends State<MeuTreinoApp> {
  bool modoEscuro = false;

  void trocarTema() {
    setState(() {
      modoEscuro = !modoEscuro;
    });
  }
 @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Treino App',

    themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,

    theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.deepPurple,
    ),

    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
    ),

 home: Builder(
  builder: (context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Treino'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

     body: Padding(
  padding: const EdgeInsets.all(20),

  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      const Icon(
        Icons.fitness_center,
        size: 100,
        color: Colors.black,
      ),

      const SizedBox(height: 20),

      const Text(
        'Meu Treino',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 10),

      const Text(
        'Seu foco cria resultados.',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
      ),

      const SizedBox(height: 50),

      SizedBox(
        width: double.infinity,
        height: 60,

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  ),
),
    );
  },
),
  );
}
}

class HomePage extends StatefulWidget {
  final bool modoEscuro;
  final VoidCallback trocarTema;

  const HomePage({
    super.key,
    required this.modoEscuro,
    required this.trocarTema,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;

  @override
  Widget build(BuildContext context) {
    final paginas = [
      TelaInicio(
        modoEscuro: widget.modoEscuro,
        trocarTema: widget.trocarTema,
      ),
      const TelaTreinos(),
      const TelaProgresso(),
    ];

    return Scaffold(
      body: paginas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Treinos'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progresso'),
        ],
      ),
    );
  }
}

class TelaInicio extends StatelessWidget {
  final bool modoEscuro;
  final VoidCallback trocarTema;

  const TelaInicio({
    super.key,
    required this.modoEscuro,
    required this.trocarTema,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Meu Treino'),
  centerTitle: true,
  actions: [
    IconButton(
      onPressed: trocarTema,
      icon: Icon(
        modoEscuro ? Icons.light_mode : Icons.dark_mode,
      ),
    ),

    IconButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              modoEscuro: modoEscuro,
              trocarTema: trocarTema,
            ),
          ),
        );
      },
      icon: const Icon(Icons.logout),
    ),
  ],
),
  
    body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Olá, Lucas 💪',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Seu foco cria resultados.',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                children: [
                  Icon(Icons.local_fire_department, color: Colors.white, size: 50),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Continue firme no treino de hoje!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaTreinos extends StatefulWidget {
  const TelaTreinos({super.key});

  @override
  State<TelaTreinos> createState() => _TelaTreinosState();
}

class _TelaTreinosState extends State<TelaTreinos> {

Future<void> salvarTreinoOnline() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('treinos')
        .doc(user.uid)
        .set({
      'concluidos': concluidos,
      'ultimaAtualizacao': DateTime.now(),
    });
  }

  final List<String> exercicios = [
    'Supino reto',
    'Agachamento',
    'Remada baixa',
    'Rosca direta',
    'Abdominal',
  ];

  List<bool> concluidos = [false, false, false, false, false];

  int segundos = 60;
  Timer? timer;
  bool rodando = false;
  

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < concluidos.length; i++) {
      await prefs.setBool('exercicio_$i', concluidos[i]);
    }
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      for (int i = 0; i < concluidos.length; i++) {
        concluidos[i] = prefs.getBool('exercicio_$i') ?? false;
      }
    });
  }

  void iniciarDescanso() {
    if (rodando) return;

    setState(() {
      segundos = 60;
      rodando = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (segundos > 0) {
        setState(() {
          segundos--;
        });
      } else {
        timer.cancel();
        setState(() {
          rodando = false;
        });
      }
    });
  }

  void pararDescanso() {
    timer?.cancel();
    setState(() {
      segundos = 60;
      rodando = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalConcluidos = concluidos.where((item) => item).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Treinos'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '$totalConcluidos/${exercicios.length} concluídos',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Descanso entre séries',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('$segundos segundos',
                      style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: rodando ? pararDescanso : iniciarDescanso,
                    child: Text(rodando ? 'Parar' : 'Iniciar descanso'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercicios.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: CheckboxListTile(
                    value: concluidos[index],
                    title: Text(exercicios[index]),
                    subtitle: const Text('3 séries de 12 repetições'),
                    secondary: const Icon(Icons.fitness_center),
                    onChanged: (value) {
                      setState(() {
                        concluidos[index] = value!;
                      });
                      salvarDados();
                      salvarTreinoOnline();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TelaProgresso extends StatelessWidget {
  const TelaProgresso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Progresso'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Card(
              child: ListTile(
                leading: Icon(Icons.local_fire_department),
                title: Text('Treinos concluídos'),
                subtitle: Text('Seu progresso está sendo salvo'),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.monitor_weight),
                title: Text('Peso Atual'),
                subtitle: Text('68kg'),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.emoji_events),
                title: Text('Meta'),
                subtitle: Text('Treinar 5x por semana'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final bool modoEscuro;
  final VoidCallback trocarTema;

  const LoginPage({
    super.key,
    required this.modoEscuro,
    required this.trocarTema,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final senhaController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              'Treino App',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: senhaController.text.trim(),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          modoEscuro: modoEscuro,
                          trocarTema: trocarTema,
                        ),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message ?? 'Erro ao entrar')),
                    );
                  }
                },
                child: const Text('Entrar'),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: senhaController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Conta criada com sucesso!')),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? 'Erro ao criar conta')),
                  );
                }
              },
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}