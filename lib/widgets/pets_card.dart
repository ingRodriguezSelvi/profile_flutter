import 'package:flutter/material.dart';

import '../models/pets_models.dart';

class PetsCard extends StatelessWidget {
  const PetsCard({Key? key, required this.pets}) : super(key: key);

  final Pets pets;

  @override
  Widget build(BuildContext context) {
    print(pets.image);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30,bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _PetsImage(
              pets.image
            ),
             _PetsDetails(
              name: pets.name,
              race: pets.race,
            ),
              Positioned(
              top: 0,
              right: 0,
              child: _AgeTag(
                age: pets.age
              )
            ),
            if ( pets.chip )
            const Positioned(
                top: 0,
                left: 0,
                child: _chip()
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,7),
        blurRadius: 10
      )
    ]
  );
}

class _chip extends StatelessWidget {
  const _chip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.green[500],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25)
        )
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            'With Chip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

class _AgeTag extends StatelessWidget {
  const _AgeTag({
    Key? key, required this.age,
  }) : super(key: key);

  final int age;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.pinkAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25)
        )
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('$age años', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
      ),
    );
  }
}

class _PetsDetails extends StatelessWidget {
  const _PetsDetails({
    Key? key, required this.name, required this.race,
  }) : super(key: key);

  final String name;
  final String race;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              name,
              style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              race,
              style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  _buildBoxDecoration() => const BoxDecoration(
    color: Colors.pinkAccent,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(25),
      topRight: Radius.circular(25)
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,7),
        blurRadius: 10
      )
    ]
  );
}

class _PetsImage extends StatelessWidget {
  const _PetsImage(this.url, {
    Key? key
  }) : super(key: key);

  final String? url;

  @override
  Widget build(BuildContext context) {
    print('Mi image is: ${url!}');
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null
            ? const Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover)
            : FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(url!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
