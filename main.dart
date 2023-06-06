import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(),
  ));
}

class ThemeProvider with ChangeNotifier {
  ThemeData _theme = ThemeData.light();

  ThemeData get theme => _theme;

  void changeTheme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: ListRoute.routeName,
      routes: {
        ListRoute.routeName: (context) => ListRoute(),
        AddRoute.routeName: (context) => AddRoute(),
      },
    );
  }
}



class Mahasiswa {
  final String nim;
  final String name;
  final double angkatan;
  final String prodi;
  final String gender;
  final String matakuliah;
  final int? sks;
  final double nilai;

  Mahasiswa({
    required this.nim,
    required this.name,
    required this.angkatan,
    required this.prodi,
    required this.gender,
    required this.matakuliah,
    required this.sks,
    required this.nilai,
  });
}

class ListRoute extends StatefulWidget {
  static const String routeName = '/';

  @override
  State createState() => ListRouteState();
}



class ListRouteState extends State<ListRoute> {
  final _items = <Mahasiswa>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Aksi yang akan dijalankan ketika item menu dipilih
              print('Menu item selected: $value');
              // Tambahkan kode sesuai aksi yang Anda inginkan
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'menu1',
                child: Text('Menu 1'),
              ),
              const PopupMenuItem<String>(
                value: 'menu2',
                child: Text('Menu 2'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            for (var item in _items.asMap().entries)
              ListTile(
                title: Text(item.value.name),
                subtitle:
                    Text('${item.value.matakuliah}, ${item.value.nilai} skor'),
                onTap: () async {
                  int idx = item.key;
                  final result = await Navigator.pushNamed(
                    context,
                    AddRoute.routeName,
                    arguments: item.value,
                  ) as Mahasiswa?;
                  if (result != null) {
                    setState(() {
                      _items[idx] = result;
                    });
                  }
                },
                onLongPress: () {
                  int idx = item.key;
                  setState(() {
                    _items.removeAt(idx);
                  });
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AddRoute.routeName,
          ) as Mahasiswa?;
          if (result != null) {
            setState(() {
              _items.add(result);
            });
          }
        },
      ),
    );
  }
}


class AddRoute extends StatelessWidget {
  static const String routeName = '/add';

  final nimController = TextEditingController();
  final nameController = TextEditingController();
  final angkatanController = TextEditingController();
  final prodiController = TextEditingController();
  final genderController = TextEditingController();
  final matakuliahController = TextEditingController();
  final sksController = TextEditingController();
  final nilaiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Mahasiswa?;
    String action = args == null ? 'Tambah' : 'Edit';
    if (args != null) {
      nimController.text = args.nim;
      nameController.text = args.name;
      angkatanController.text = args.angkatan.toString();
      prodiController.text = args.prodi;
      genderController.text = args.gender;
      matakuliahController.text = args.matakuliah;
      sksController.text = args.sks.toString();
      nilaiController.text = args.nilai.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('$action Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  hintText: 'Nim Mahasiswa',
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Nama Mahasiswa',
                ),
              ),
              TextFormField(
                controller: angkatanController,
                decoration: const InputDecoration(
                  hintText: 'Angkatan Mahasiswa',
                ),
              ),
              TextFormField(
                controller: prodiController,
                decoration: const InputDecoration(
                  hintText: 'Prodi Mahasiswa',
                ),
              ),
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(
                  hintText: 'Jenis Kelamin Mahasiswa',
                ),
              ),
              TextFormField(
                controller: matakuliahController,
                decoration: const InputDecoration(
                  hintText: 'Mata Kuliah Yang diambil Mahasiswa',
                ),
              ),
              TextFormField(
                controller: sksController,
                decoration: const InputDecoration(
                  hintText: 'SKS yang diambil Mahasiswa',
                ),
              ),
              TextFormField(
                controller: nilaiController,
                decoration: const InputDecoration(
                  hintText: 'nilai Mahasiswa',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          final mahasiswa = Mahasiswa(
            nim: nimController.text,
            name: nameController.text,
            angkatan: double.parse(angkatanController.text),
            prodi: prodiController.text,
            gender: genderController.text,
            matakuliah: matakuliahController.text,
            sks: int.parse(sksController.text),
            nilai: double.parse(nilaiController.text),
          );
          Navigator.pop(context, mahasiswa);
        },
      ),
    );
  }
}

