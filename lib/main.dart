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
      backgroundColor: const Color(0xFF050816),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text(
          'FIT PULSE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: trocarTema,
            icon: const Icon(Icons.bolt, color: Color(0xFF22C55E)),
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
            icon: const Icon(Icons.logout, color: Colors.white70),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bora treinar!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Foco hoje, resultado sempre.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 26),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF14532D),
                    Color(0xFF312E81),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                  color: const Color(0xFF22C55E).withOpacity(0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withOpacity(0.28),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      Icons.fitness_center,
                      size: 150,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TREINO DO DIA',
                        style: TextStyle(
                          color: Color(0xFF86EFAC),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Peito & Tríceps',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '6 exercícios • 50 min • alta intensidade',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.72),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.black,
                            elevation: 0,
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
                            'Iniciar treino',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                _cardResumo(
                  icone: Icons.local_fire_department,
                  numero: '5',
                  texto: 'Treinos',
                  cor: const Color(0xFFFF3D81),
                ),
                const SizedBox(width: 14),
                _cardResumo(
                  icone: Icons.fitness_center,
                  numero: '18',
                  texto: 'Exercícios',
                  cor: const Color(0xFF06B6D4),
                ),
                const SizedBox(width: 14),
                _cardResumo(
                  icone: Icons.bolt,
                  numero: '82%',
                  texto: 'Performance',
                  cor: const Color(0xFF22C55E),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Próximos treinos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Ver todos',
                  style: TextStyle(
                    color: const Color(0xFF22C55E).withOpacity(0.95),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _proximoTreino(
              titulo: 'Costas & Bíceps',
              subtitulo: '8 exercícios • 60 min',
              icone: Icons.accessibility_new,
              cor: const Color(0xFF8B5CF6),
            ),

            const SizedBox(height: 12),

            _proximoTreino(
              titulo: 'Pernas',
              subtitulo: '7 exercícios • 55 min',
              icone: Icons.directions_run,
              cor: const Color(0xFF06B6D4),
            ),

            const SizedBox(height: 12),

            _proximoTreino(
              titulo: 'Abdômen',
              subtitulo: '5 exercícios • 20 min',
              icone: Icons.monitor_heart_outlined,
              cor: const Color(0xFFFF3D81),
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
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cor.withOpacity(0.55)),
          boxShadow: [
            BoxShadow(
              color: cor.withOpacity(0.22),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 34),
            const SizedBox(height: 12),
            Text(
              numero,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _proximoTreino({
    required String titulo,
    required String subtitulo,
    required IconData icone,
    required Color cor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1120),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: cor.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: cor.withOpacity(0.16),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cor.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icone, color: cor, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitulo,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.55),
            size: 18,
          ),
        ],
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
  Map<String, List<Map<String, dynamic>>> treinos = {
    'Peito': [
      {
        'nome': 'Supino reto',
        'series': '4',
        'repeticoes': '12',
        'descricao': 'Exercício focado no peitoral, ombros e tríceps.',
        'video': 'https://www.youtube.com/watch?v=VmB1G1K7v94',
      },
    ],
    'Perna': [
      {
        'nome': 'Agachamento',
        'series': '4',
        'repeticoes': '10',
        'descricao': 'Fortalece pernas e glúteos.',
        'video': 'https://www.youtube.com/watch?v=aclHkVaku9U',
      },
    ],
    'Costas': [
      {
        'nome': 'Remada baixa',
        'series': '3',
        'repeticoes': '12',
        'descricao': 'Exercício para desenvolvimento das costas.',
        'video': 'https://www.youtube.com/watch?v=roCP6wCXPqo',
      },
    ],
    'Braço': [
      {
        'nome': 'Rosca direta',
        'series': '3',
        'repeticoes': '12',
        'descricao': 'Foco no bíceps.',
        'video': 'https://www.youtube.com/watch?v=kwG2ipFRgfo',
      },
    ],
    'Abdômen': [
      {
        'nome': 'Abdominal',
        'series': '4',
        'repeticoes': '20',
        'descricao': 'Fortalecimento do abdômen.',
        'video': 'https://www.youtube.com/watch?v=1fbU_MkV7NE',
      },
    ],
  };

  final List<Color> cores = const [
    Color(0xFF22C55E),
    Color(0xFF06B6D4),
    Color(0xFFFF3D81),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
  ];

  final List<IconData> icones = const [
    Icons.fitness_center,
    Icons.directions_run,
    Icons.accessibility_new,
    Icons.sports_gymnastics,
    Icons.monitor_heart_outlined,
  ];

  final List<String> duracoes = [
    '50 min',
    '55 min',
    '60 min',
    '40 min',
    '20 min',
  ];

  final List<String> niveis = [
    'Intermediário',
    'Avançado',
    'Intermediário',
    'Iniciante',
    'Iniciante',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'FIT PULSE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF14532D),
                  Color(0xFF312E81),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: const Color(0xFF22C55E).withOpacity(0.45),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22C55E).withOpacity(0.22),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withOpacity(0.16),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: Color(0xFF86EFAC),
                    size: 38,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seus Treinos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${treinos.length} programas disponíveis para evolução',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: 90,
              ),
              itemCount: treinos.keys.length,
              itemBuilder: (context, index) {
                final nomeTreino = treinos.keys.elementAt(index);
                final cor = cores[index % cores.length];
                final icone = icones[index % icones.length];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1120),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: cor.withOpacity(0.45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cor.withOpacity(0.20),
                        blurRadius: 24,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
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
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cor.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: cor.withOpacity(0.35),
                              ),
                            ),
                            child: Icon(
                              icone,
                              color: cor,
                              size: 34,
                            ),
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nomeTreino.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  '${treinos[nomeTreino]!.length} exercícios • ${duracoes[index]}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.58),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: cor.withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Text(
                                        niveis[index],
                                        style: TextStyle(
                                          color: cor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Alta performance',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.42),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cor.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: cor,
                              size: 18,
                            ),
                          ),
                        ],
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void abrirDialogAdicionarExercicio() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1120),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Novo exercício',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Digite o exercício',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
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
              child: const Text(
                'Adicionar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final porcentagem = (progresso * 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFF050816),

      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.nomeTreino.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.3,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.black,
        onPressed: abrirDialogAdicionarExercicio,
        icon: const Icon(Icons.add),
        label: const Text(
          'Adicionar',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF14532D),
                  Color(0xFF312E81),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: const Color(0xFF22C55E).withOpacity(0.45),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22C55E).withOpacity(0.22),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PERFORMANCE DO TREINO',
                  style: TextStyle(
                    color: Color(0xFF86EFAC),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      '$porcentagem%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'concluído',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: LinearProgressIndicator(
                    value: progresso,
                    minHeight: 16,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    color: const Color(0xFF22C55E),
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1120),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF06B6D4).withOpacity(0.45),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06B6D4).withOpacity(0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.timer,
                    color: Color(0xFF06B6D4),
                    size: 34,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descanso',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$segundos segundos',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: iniciarDescanso,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFF22C55E),
                    size: 32,
                  ),
                ),

                IconButton(
                  onPressed: pararDescanso,
                  icon: const Icon(
                    Icons.stop_rounded,
                    color: Color(0xFFFF3D81),
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: 90,
              ),
              itemCount: widget.exercicios.length,
              itemBuilder: (context, index) {
                final exercicio = widget.exercicios[index];
                final concluido = concluidos[index];

                return Dismissible(
                  key: Key('${exercicio['nome']}_$index'),
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3D81),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 22),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      widget.exercicios.removeAt(index);
                      concluidos.removeAt(index);
                    });

                    salvarTreinoOnline();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exercício removido'),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: concluido
                          ? const Color(0xFF052E16)
                          : const Color(0xFF0B1120),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: concluido
                            ? const Color(0xFF22C55E)
                            : Colors.white.withOpacity(0.10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: concluido
                              ? const Color(0xFF22C55E).withOpacity(0.22)
                              : Colors.black.withOpacity(0.28),
                          blurRadius: 22,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.25,
                          child: Checkbox(
                            value: concluido,
                            activeColor: const Color(0xFF22C55E),
                            checkColor: Colors.black,
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.45),
                            ),
                            onChanged: (value) {
                              setState(() {
                                concluidos[index] = value!;
                              });

                              salvarTreinoOnline();
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercicio['nome'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  decoration: concluido
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF06B6D4)
                                          .withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFF06B6D4)
                                            .withOpacity(0.35),
                                      ),
                                    ),
                                    child: Text(
                                      '${exercicio['series']}x${exercicio['repeticoes']}',
                                      style: const TextStyle(
                                        color: Color(0xFF67E8F9),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    concluido ? 'Concluído' : 'Pendente',
                                    style: TextStyle(
                                      color: concluido
                                          ? const Color(0xFF22C55E)
                                          : const Color(0xFFFFD166),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.ondemand_video,
                            color: Color(0xFFFF3D81),
                            size: 34,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaDetalheExercicio(
                                  exercicio: exercicio,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF020617),
              Color(0xFF052E2B),
              Color(0xFF111827),
              Color(0xFF14532D),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -60,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF22C55E).withOpacity(0.22),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF06B6D4).withOpacity(0.16),
                ),
              ),
            ),

            Positioned(
              top: 90,
              left: 30,
              child: Icon(
                Icons.monitor_heart_outlined,
                color: Colors.white.withOpacity(0.08),
                size: 120,
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.42),
                        blurRadius: 38,
                        offset: const Offset(0, 24),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF22C55E),
                              Color(0xFF06B6D4),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.45),
                              blurRadius: 30,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'FIT PULSE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Força, saúde e performance em um só lugar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.76),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: const Color(0xFF22C55E).withOpacity(0.35),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt,
                              color: Color(0xFF86EFAC),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Saúde • Treino • Evolução',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.82),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.14),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: Color(0xFF22C55E),
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: senhaController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.14),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: Color(0xFF22C55E),
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
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
                                SnackBar(
                                  content: Text(e.message ?? 'Erro ao entrar'),
                                ),
                              );
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF22C55E),
                                  Color(0xFF06B6D4),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF22C55E)
                                      .withOpacity(0.38),
                                  blurRadius: 20,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Entrar no app',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: const Color(0xFF86EFAC).withOpacity(0.45),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  modoEscuro: modoEscuro,
                                  trocarTema: trocarTema,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text(
                            'Explorar modo demo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: senhaController.text.trim(),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Conta criada com sucesso!'),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.message ?? 'Erro ao criar conta'),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Criar nova conta',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.86),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Versão demo para testar o projeto online',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
    final videoId = YoutubePlayer.convertUrlToId(exercicio['video'] ?? '');

    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        centerTitle: true,
        title: Text(
          exercicio['nome'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (videoId == null || videoId.isEmpty) return;

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
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: const Color(0xFF22C55E).withOpacity(0.45),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      if (videoId != null && videoId.isNotEmpty)
                        Image.network(
                          'https://img.youtube.com/vi/$videoId/0.jpg',
                          fit: BoxFit.cover,
                        )
                      else
                        Container(
                          color: const Color(0xFF0B1120),
                          child: const Icon(
                            Icons.fitness_center,
                            color: Color(0xFF22C55E),
                            size: 80,
                          ),
                        ),

                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.75),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF3D81).withOpacity(0.92),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF3D81).withOpacity(0.45),
                              blurRadius: 30,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 58,
                        ),
                      ),

                      Positioned(
                        left: 20,
                        bottom: 20,
                        right: 20,
                        child: Text(
                          videoId == null || videoId.isEmpty
                              ? 'Vídeo não cadastrado'
                              : 'Assistir execução correta',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              exercicio['nome'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              exercicio['descricao'] ?? 'Sem descrição cadastrada.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                _infoCard(
                  titulo: 'Séries',
                  valor: '${exercicio['series']}',
                  icone: Icons.repeat,
                  cor: const Color(0xFF22C55E),
                ),
                const SizedBox(width: 14),
                _infoCard(
                  titulo: 'Reps',
                  valor: '${exercicio['repeticoes']}',
                  icone: Icons.bolt,
                  cor: const Color(0xFF06B6D4),
                ),
              ],
            ),

            const SizedBox(height: 26),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1120),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.45),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dica de execução',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Execute o movimento com controle, mantenha a postura correta e evite cargas acima do seu limite.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.62),
                      fontSize: 15,
                      height: 1.5,
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

  Widget _infoCard({
    required String titulo,
    required String valor,
    required IconData icone,
    required Color cor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: cor.withOpacity(0.45)),
          boxShadow: [
            BoxShadow(
              color: cor.withOpacity(0.18),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 34),
            const SizedBox(height: 12),
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              titulo,
              style: TextStyle(
                color: Colors.white.withOpacity(0.62),
                fontWeight: FontWeight.bold,
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





