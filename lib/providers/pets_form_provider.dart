import 'package:flutter/material.dart';

import '../models/pets_models.dart';


class PetsFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Pets pets;

  PetsFormProvider( this.pets );

  updateChip( bool value ) {
    pets.chip = value;
    notifyListeners();
  }


  bool isValidForm() {

    print(pets.name);
    print(pets.age);
    print(pets.chip);
    print(pets.race);

    return formKey.currentState?.validate() ?? false;
  }
}