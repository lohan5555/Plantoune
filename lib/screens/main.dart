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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        toolbarHeight: 16,
        elevation: 0
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          HerbierPage(plantes: _plantes),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
