import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:profile/models/pets_models.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PetsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-55687-default-rtdb.firebaseio.com';
  final List<Pets> pets = [];

  final storage = const FlutterSecureStorage();

  File? newImageFile;

  Pets? selectedPet;

  bool isLoading = true;
  bool isSaving = false;

  PetsService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;

    final url = Uri.https(_baseUrl, 'pets.json',{
      'auth' : await storage.read(key: 'token' ?? '')
    });
    final resp = await http.get(url);

    final Map<String, dynamic> petsMap = json.decode(resp.body);
    petsMap.forEach((key, value) {
      final tempPet = Pets.fromMap(value);
      tempPet.id = key;

      pets.add(tempPet);
    });

    isLoading = false;
    notifyListeners();
    return pets;
  }

  Future saveOrCreatePets(Pets pets) async {
    isSaving = true;
    notifyListeners();

    if (pets.id == null) {
      await createPets(pets);
    } else {
      await updatePets(pets);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updatePets(Pets pets) async {
    final url = Uri.https(_baseUrl, 'pets/${pets.id}.json',{
      'auth' : await storage.read(key: 'token' ?? '')
    });
    final resp = await http.put(url, body: pets.toJson());

    final decodedData = json.decode(resp.body);

    final index = this.pets.indexWhere((element) => element.id == pets.id);
    this.pets[index] = pets;


    return pets.id!;
  }

  Future<String> createPets(Pets pets) async {
    final url = Uri.https(_baseUrl, 'pets.json',{
      'auth' : await storage.read(key: 'token' ?? '')
    });
    final resp = await http.post(url, body: pets.toJson());

    final decodedData = json.decode(resp.body);

    pets.id = decodedData['name'];

    this.pets.add(pets);

    return pets.id!;
  }

  void updateSelectedPetsImage(String path) {
    selectedPet!.image = path;
    notifyListeners();
    newImageFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> upLoadImage() async{
    if (newImageFile == null) return null;
    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dvhmifyvx/image/upload?upload_preset=dfd9cn6n');
    final imageUploadRequest = http.MultipartRequest('POST', url,);
    final file = await http.MultipartFile.fromPath('file', newImageFile!.path);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    newImageFile = null;

    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}