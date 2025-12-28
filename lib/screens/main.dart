import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantoune/models/plante.dart';
import 'package:plantoune/services/planteService.dart';
import '../services/db.dart';
import 'herbier.dart';
import 'carte.dart';
import 'FormulaireAjout.dart';

//point d'entrée de l'app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de la base de données au premier lancement
  await DatabaseService.database;

  //Couleur de la barre système
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Color(0xffecefe5),
    ),
  );

  //on lance le widget racine
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Configuration globale
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plantoune',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffffffff),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffd5f2c9)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PlanteService planteService = PlanteService(); //instance du service
  List<Plante> _plantes = [];
  int currentPageIndex = 0;

  @override
  void initState(){
    super.initState();
    _loadPlantes();
  }

  //fonction qui va récupérer la liste des plantes et mettre à jour le state
  Future<void> _loadPlantes() async{
    final plantes = await planteService.getAllplantes();
    //setState va rebuild le widget
    setState(() {
      _plantes = plantes;
    });
  }

  //fonction qui va ajouter une plante en base et mettre à jour le state
  Future<void> _createPlante(Plante plante) async{
    await planteService.insertPlante(plante);
    await _loadPlantes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plante créé')),
    );
  }

  //fonction qui va supprimer une plante de la base et mettre à jour le state
  Future<void> _deletePlante(int id) async {
    await planteService.deletePlante(id);
    await _loadPlantes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plante supprimée')),
    );
  }

  //fonction qui va modifier une plante de la base et mettre à jour le state
  Future<void> _editPlante(Plante plante) async {
    await planteService.updatePlante(plante);
    await _loadPlantes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plante modifiée')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 16,
        elevation: 0
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          HerbierPage(plantes: _plantes, onDelete: _deletePlante, onEdit: _editPlante,),
          CartePage(plantes: _plantes),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.local_florist),
            icon: Icon(Icons.local_florist_outlined),
            label: 'Herbier'),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Carte')
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FormulaireAjout(onCreate: _createPlante),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
