import 'package:flutter/material.dart';
import 'package:profile/models/pets_models.dart';
import 'package:profile/screens/screens.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context){
    final petsService = Provider.of<PetsService>(context);

    if( petsService.isLoading ) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets App'),
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            final authService = Provider.of<AuthService>(context, listen: false);
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: petsService.pets.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () =>{
              petsService.selectedPet = petsService.pets[index].copy(),
              Navigator.pushNamed(context, 'pets', arguments: petsService.pets[index])
            },
            child: PetsCard(
              pets: petsService.pets[index],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          petsService.selectedPet = Pets(
              age: 0,
              chip: false,
              name: '',
              race: ''
          ),
          Navigator.pushNamed(context, 'pets', arguments: 0)
        },
      ),
    );
  }
}