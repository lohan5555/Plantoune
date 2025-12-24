import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantoune/models/plante.dart';
import 'package:plantoune/services/planteService.dart';
import '../services/db.dart';
import 'herbier.dart';
import 'carte.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PlanteService planteService = PlanteService(); //instance du service
  List<Plante> _plantes = [];

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

  Future<void> _addTest() async{
      var plante = Plante(name: 'PlantounePasLe1', text: "D'autre plantoune", longitude: 1.0);
      await planteService.insertPlante(plante);
      await _loadPlantes(); //toujours recharger le state quand on modifie la liste
  }

  Future<void> _deletePlante(int id) async {
    await planteService.deletePlante(id);
    await _loadPlantes();
  }

  int currentPageIndex = 0;

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
          HerbierPage(plantes: _plantes, onDelete: _deletePlante,),
          CartePage(),
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
        onPressed: _addTest,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
