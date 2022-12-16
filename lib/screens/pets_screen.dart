import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

import 'package:image_picker/image_picker.dart';


class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});


    @override
    Widget build(BuildContext context){
      final petsService = Provider.of<PetsService>(context);
      return ChangeNotifierProvider(
          create: ( _ ) => PetsFormProvider(petsService.selectedPet!),
          child: _PetsScreenBody(petsService: petsService),
      );
    }
}

class _PetsScreenBody extends StatelessWidget {
  const _PetsScreenBody({
    Key? key,
    required this.petsService,
  }) : super(key: key);

  final PetsService petsService;

  @override
  Widget build(BuildContext context) {
    final petsForm = Provider.of<PetsFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
            child: Column(
                children: [
                     Stack(
                       children: [
                           PetsImage(
                            imageUrl: petsService.selectedPet?.image,
                          ),
                          Positioned(
                              top: 50,
                              left: 20,
                              child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 40),
                              ),
                          ),
                         Positioned(
                              top: 50,
                              right: 20,
                              child: IconButton(
                                  onPressed: () async {
                                    final picker = ImagePicker();
                                    final XFile? pickedFile = await picker.pickImage(
                                        source: ImageSource.camera, imageQuality: 100);
                                    if (pickedFile != null) {
                                      petsService.updateSelectedPetsImage(pickedFile.path);
                                    }
                                  },
                                  icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 40),
                              ),
                          ),
                       ],
                     ),
                  const _PetsForm(),
                  const SizedBox(height: 100),
                ],
            ),
        ),
      floatingActionButton: FloatingActionButton(
          onPressed: petsService.isSaving
              ? null
              :
              () async {
              if (!petsForm.isValidForm()) return;
              final String? imageUrl = await petsService.upLoadImage();
              if (imageUrl != null) {
                petsForm.pets.image = imageUrl;
              }
              print(petsForm.pets.image);
              await petsService.saveOrCreatePets(petsForm.pets);
          },
          backgroundColor: Colors.pinkAccent,
          child: petsService.isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.save_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _PetsForm extends StatelessWidget {
  const _PetsForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petsForm = Provider.of<PetsFormProvider>(context);
    final pets = petsForm.pets;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 350,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: petsForm.formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: pets.name,
                onChanged: (value) => pets.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The name is required';
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Nombre de la mascota',
                  labelText: 'Nombre',
                ),
              ),
              TextFormField(
                initialValue: pets.race,
                onChanged: (value) => pets.race = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The name is required';
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Nombre de la raza',
                  labelText: 'Raza',
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: '${pets.age}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\d{0,2}'))
                ],
                onChanged: (value) => {
                  if (int.tryParse(value) != null) {pets.age = int.parse(value)}
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Edad de la mascota',
                  labelText: 'Edad',
                ),
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                value: pets.chip,
                activeColor: Colors.pink,
                title: const Text('¿Tiene chip?'),
                onChanged: petsForm.updateChip,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only( bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: [BoxShadow(
      color: Colors.black.withOpacity(0.05),
      offset: const Offset(0, 5),
      blurRadius: 10,
    )]
  );
}