import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'pages/treino_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

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

  home: FirebaseAuth.instance.currentUser == null
    ? LoginPage(
        modoEscuro: modoEscuro,
        trocarTema: trocarTema,
      )
    : HomePage(
        modoEscuro: modoEscuro,
        trocarTema: trocarTema,
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
      backgroundColor: modoEscuro ? const Color(0xFF121212) : const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text('Meu Treino'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: trocarTema,
            icon: Icon(modoEscuro ? Icons.light_mode : Icons.dark_mode),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá, Lucas 💪',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pronto para evoluir hoje?',
              style: TextStyle(
                fontSize: 17,
                color: modoEscuro ? Colors.grey[400] : Colors.grey[700],
              ),
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFF4F46E5),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                    size: 52,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Treino de hoje',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Mantenha o foco e conclua seus exercícios!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                _cardResumo(
                  icone: Icons.fitness_center,
                  numero: '5',
                  texto: 'Treinos',
                  cor: Colors.orange,
                ),
                const SizedBox(width: 14),
                _cardResumo(
                  icone: Icons.check_circle,
                  numero: '0',
                  texto: 'Concluídos',
                  cor: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: Colors.deepPurple.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaTreinos(),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 30),
                label: const Text(
                  'Começar treino',
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
  }

  Widget _cardResumo({
    required IconData icone,
    required String numero,
    required String texto,
    required Color cor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: cor.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icone, color: Colors.white, size: 38),
            const SizedBox(height: 12),
            Text(
              numero,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              texto,
              style: const TextStyle(color: Colors.white),
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
Map<String, List<Map<String, dynamic>>> treinos = {
  'Peito': [
    {
      'nome': 'Supino reto',
      'series': '4',
      'repeticoes': '12',
      'descricao':
          'Exercício focado no peitoral, ombros e tríceps.',
      'video':
          'https://www.youtube.com/watch?v=VmB1G1K7v94',
    },
  ],

  'Perna': [
    {
      'nome': 'Agachamento',
      'series': '4',
      'repeticoes': '10',
      'descricao':
          'Fortalece pernas e glúteos.',
      'video':
          'https://www.youtube.com/watch?v=aclHkVaku9U',
    },
  ],

  'Costas': [
    {
      'nome': 'Remada baixa',
      'series': '3',
      'repeticoes': '12',
      'descricao':
          'Exercício para desenvolvimento das costas.',
      'video':
          'https://www.youtube.com/watch?v=roCP6wCXPqo',
    },
  ],

  'Braço': [
    {
      'nome': 'Rosca direta',
      'series': '3',
      'repeticoes': '12',
      'descricao':
          'Foco no bíceps.',
      'video':
          'https://www.youtube.com/watch?v=kwG2ipFRgfo',
    },
  ],

  'Abdômen': [
    {
      'nome': 'Abdominal',
      'series': '4',
      'repeticoes': '20',
      'descricao':
          'Fortalecimento do abdômen.',
      'video':
          'https://www.youtube.com/watch?v=1fbU_MkV7NE',
    },
  ],
};
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
  return Scaffold(
    appBar: AppBar(
      title: const Text('Treinos'),
      centerTitle: true,
    ),

    body: Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            '${treinos.length} treinos disponíveis',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: treinos.keys.length,

            itemBuilder: (context, index) {
              final nomeTreino = treinos.keys.elementAt(index);

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),

              child: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.deepPurple.shade500,
        Colors.deepPurple.shade800,
      ],
    ),
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.deepPurple.withOpacity(0.35),
        blurRadius: 12,
        offset: const Offset(0, 8),
      ),
    ],
  ),

  child: InkWell(
    borderRadius: BorderRadius.circular(25),

    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaExercicios(
            nomeTreino: nomeTreino,
            exercicios: treinos[nomeTreino]!,
          ),
        ),
      );
    },

    child: Padding(
      padding: const EdgeInsets.all(18),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),

            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  nomeTreino,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${treinos[nomeTreino]!.length} exercícios',

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    ),
  ),
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
 
class TelaExercicios extends StatefulWidget {
  final String nomeTreino;
  final List<Map<String, dynamic>> exercicios;

  const TelaExercicios({
    super.key,
    required this.nomeTreino,
    required this.exercicios,
  });

  @override
  State<TelaExercicios> createState() => _TelaExerciciosState();
}

class _TelaExerciciosState extends State<TelaExercicios> {
  List<bool> concluidos = [];
  int segundos = 60;
Timer? timer;
bool rodando = false;
 double get progresso {
  if (concluidos.isEmpty) return 0;
  final feitos = concluidos.where((item) => item).length;
  return feitos / concluidos.length;
}

@override
void initState() {
  super.initState();

  concluidos = List.generate(
    widget.exercicios.length,
    (index) => false,
  );

  carregarTreinoOnline();
}

Future<void> salvarTreinoOnline() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  await FirebaseFirestore.instance
      .collection('treinos')
      .doc('${user.uid}_${widget.nomeTreino}')
      .set({
    'treino': widget.nomeTreino,
    'exercicios': widget.exercicios,
    'concluidos': concluidos,
    'ultimaAtualizacao': DateTime.now(),
  });
}

void iniciarDescanso() {
  if (rodando) return;

  setState(() {
    segundos = 60;
    rodando = true;
  });

  timer = Timer.periodic(
    const Duration(seconds: 1),
    (timer) {
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
    },
  );
}

void pararDescanso() {
  timer?.cancel();

  setState(() {
    segundos = 60;
    rodando = false;
  });
}

Future<void> carregarTreinoOnline() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('treinos')
      .doc('${user.uid}_${widget.nomeTreino}')
      .get();

  if (!doc.exists) return;

  final dados = doc.data();

  if (dados == null) return;

  final listaSalva = List<bool>.from(dados['concluidos'] ?? []);

  setState(() {
    concluidos = List.generate(
      widget.exercicios.length,
      (index) => index < listaSalva.length ? listaSalva[index] : false,
    );
  });
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.nomeTreino),
      centerTitle: true,
    ),

    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      onPressed: () {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Novo exercício'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Digite o exercício',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
         ElevatedButton(
  onPressed: () {
    if (controller.text.isNotEmpty) {
      setState(() {
      widget.exercicios.add({
  'nome': controller.text,
  'series': '3',
  'repeticoes': '12',
  'descricao': 'Novo exercício adicionado pelo usuário.',
  'video': '',
});  
        concluidos.add(false);
      });

      salvarTreinoOnline();

      Navigator.pop(context);
    }
  },
  child: const Text('Adicionar'),
), 
        ],
      );
    },
  );
},
      icon: const Icon(Icons.add),
      label: const Text('Adicionar'),
    ),

  body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${(progresso * 100).toInt()}% concluído',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 14,
              backgroundColor: Colors.grey.withOpacity(0.25),
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    ),

    Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon (Icons.timer, color: Colors.white, size: 36),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              'Descanso: $segundos s',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
               ),
            ),
          ),
          IconButton(
            onPressed: iniciarDescanso,
            icon: const Icon(Icons.play_arrow, color: Colors.white),
          ),
          IconButton(
            onPressed: pararDescanso,
            icon: const Icon(Icons.stop, color: Colors.white),
          ),
        ],
      ),
    ),


   Expanded(
  child: ListView.builder(
    itemCount: widget.exercicios.length,
    itemBuilder: (context, index) {
      return Dismissible(
        key: Key(widget.exercicios[index]['nome']),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
          setState(() {
            widget.exercicios.removeAt(index);
            concluidos.removeAt(index);
          });

          salvarTreinoOnline();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exercício removido')),
          );
        },
       child: AnimatedContainer(
  duration: const Duration(milliseconds: 300),

  child: Card(
    elevation: 6,
    color: concluidos[index]
        ? Colors.green.withOpacity(0.08)
        : Colors.white,

    child: ListTile(
            leading: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: concluidos[index],
                onChanged: (value) {
                  setState(() {
                    concluidos[index] = value!;
                  });

                  salvarTreinoOnline();
                },
              ),
            ),
            title: Text(
              widget.exercicios[index]['nome'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: concluidos[index]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.exercicios[index]['series']}x${widget.exercicios[index]['repeticoes']}',
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    concluidos[index] ? 'Concluído' : 'Pendente',
                    style: TextStyle(
                      color: concluidos[index] ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.play_circle_fill,
                color: Colors.red,
                size: 34,
              ),
            onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TelaDetalheExercicio(
        exercicio: widget.exercicios[index],
      ),
    ),
   );
},  
             ),
            ),
          ),
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

class TelaDetalheExercicio extends StatelessWidget {
  final Map<String, dynamic> exercicio;

  const TelaDetalheExercicio({
    super.key,
    required this.exercicio,
  });

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(exercicio['nome']),
      centerTitle: true,
    ),

    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        GestureDetector(
  onTap: () async {
   Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TelaPlayerVideo(
      videoUrl: exercicio['video'],
      nomeExercicio: exercicio['nome'],
    ),
  ),
);
  },

  child: ClipRRect(
    borderRadius: BorderRadius.circular(25),

    child: Stack(
      alignment: Alignment.center,
      children: [

        Image.network(
          'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(exercicio['video'])}/0.jpg',
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,

          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Container(
              height: 220,
              color: Colors.black12,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },

          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 220,
              color: Colors.black87,
              child: const Center(
                child: Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 70,
                ),
              ),
            );
          },
        ),

        Container(
          height: 220,
          color: Colors.black.withOpacity(0.35),
        ),

        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.play_circle_fill,
              size: 90,
              color: Colors.red,
            ),

            SizedBox(height: 10),

            Text(
              'Assistir exercício',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
), 

             

          const SizedBox(height: 25),

          Text(
            exercicio['nome'],
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  '${exercicio['series']} séries',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  '${exercicio['repeticoes']} reps',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            'Descrição',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            exercicio['descricao'],
            style: const TextStyle(
              fontSize: 17,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}
}

class TelaPlayerVideo extends StatefulWidget {
  final String videoUrl;
  final String nomeExercicio;

  const TelaPlayerVideo({
    super.key,
    required this.videoUrl,
    required this.nomeExercicio,
  });

  @override
  State<TelaPlayerVideo> createState() => _TelaPlayerVideoState();
}

class _TelaPlayerVideoState extends State<TelaPlayerVideo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.nomeExercicio),
            centerTitle: true,
          ),
          body: Column(
            children: [
              player,

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Assista com atenção à execução correta do movimento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}