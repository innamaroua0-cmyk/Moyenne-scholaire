import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moyenne scolaire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class Matiere {
  final TextEditingController nom;
  final TextEditingController note = TextEditingController();
  final TextEditingController coef = TextEditingController(text: '1');
  Matiere(String n) : nom = TextEditingController(text: n);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Matiere> matieres = [
    Matiere('Maths'),
    Matiere('Français'),
    Matiere('Anglais'),
  ];
  double? moyenne;
  String? erreur;

  double? _parse(String s) =>
      double.tryParse(s.trim().replaceAll(',', '.'));

  void calculer() {
    double total = 0;
    double sommeCoef = 0;
    for (final m in matieres) {
      final n = _parse(m.note.text);
      final c = _parse(m.coef.text);
      if (n == null || c == null) {
        setState(() {
          moyenne = null;
          erreur = 'Remplissez toutes les notes et coefficients.';
        });
        return;
      }
      if (n < 0 || n > 20 || c <= 0) {
        setState(() {
          moyenne = null;
          erreur = 'Notes entre 0 et 20, coefficients supérieurs à 0.';
        });
        return;
      }
      total += n * c;
      sommeCoef += c;
    }
    setState(() {
      erreur = null;
      moyenne = total / sommeCoef;
    });
  }

  String appreciation(double m) {
    if (m >= 16) return 'Très bien';
    if (m >= 14) return 'Bien';
    if (m >= 12) return 'Assez bien';
    if (m >= 10) return 'Passable';
    return 'Insuffisant';
  }

  void ajouter() {
    setState(() => matieres.add(Matiere('')));
  }

  void supprimer(int i) {
    setState(() {
      matieres.removeAt(i);
      moyenne = null;
    });
  }

  void reinitialiser() {
    setState(() {
      for (final m in matieres) {
        m.note.clear();
        m.coef.text = '1';
      }
      moyenne = null;
      erreur = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    const kb = TextInputType.numberWithOptions(decimal: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moyenne scolaire'),
        actions: [
          IconButton(
            onPressed: reinitialiser,
            icon: const Icon(Icons.refresh),
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Matière')),
                SizedBox(width: 70, child: Text('Note /20')),
                SizedBox(width: 8),
                SizedBox(width: 60, child: Text('Coef')),
                SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matieres.length,
              itemBuilder: (context, i) {
                final m = matieres[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: m.nom,
                          decoration: const InputDecoration(
                            hintText: 'Nom',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          controller: m.note,
                          keyboardType: kb,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: m.coef,
                          keyboardType: kb,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => supprimer(i),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (erreur != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(erreur!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          if (moyenne != null)
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('${moyenne!.toStringAsFixed(2)} / 20',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(appreciation(moyenne!)),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: ajouter,
                    icon: const Icon(Icons.add),
                    label: const Text('Matière'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: calculer,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculer'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
