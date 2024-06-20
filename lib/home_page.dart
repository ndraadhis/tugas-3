import 'package:flutter/material.dart';
import 'package:indraadhis_215410070/breed_page.dart';
import 'package:indraadhis_215410070/breed.dart';
import 'user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Breed>> futureBreeds;

  @override
  void initState() {
    super.initState();
    futureBreeds = UserService().getBreeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog Breeds')),
      body: Center(
        child: FutureBuilder<List<Breed>>(
          future: futureBreeds,
          builder: (context, AsyncSnapshot<List<Breed>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  Breed breed = snapshot.data![index];
                  return ListTile(
                    title: Text(breed.name),
                    subtitle: Text('Life Expectancy: ${breed.life.min} - ${breed.life.max} years'),
                    trailing: const Icon(Icons.chevron_right_outlined),
                    onTap: () => openPage(context, breed),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: Colors.black26);
                },
                itemCount: snapshot.data!.length,
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }

  void openPage(BuildContext context, Breed breed) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BreedPage(breed: breed)),
    );
  }
}
