import 'package:flutter/material.dart';
import 'package:profile/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});


    @override
    Widget build(BuildContext context){
        return  Scaffold(
            body: AuthBackground(
              child: SingleChildScrollView(
                child: Column(
                  children:  [
                    const SizedBox( height: 250,),
                    CardContainer(
                      child: Column(
                        children:  [
                          const SizedBox( height: 10,),
                          Text('Crear cuenta', style: Theme.of(context).textTheme.headline4,),
                          const SizedBox( height: 30,),
                          ChangeNotifierProvider(
                            create: ( _ ) => LoginFormProvider(),
                            child: const _LoginForm(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox( height: 50,),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'login');
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.pinkAccent.withOpacity(0.1)),
                          shape: MaterialStateProperty.all(const StadiumBorder()),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20)),
                        ),
                        child: const Text(
                          '¿Ya tienes una cuenta?',
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: Colors.pink),
                        )
                    ),const SizedBox( height: 50,),
                  ]
                )
              )
            ),
        );
    }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hinText: 'John.doe@correo.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: ( value ){
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'El valor ingresado no es un correo válido';
              },
              ),
            const SizedBox( height: 30,),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                hinText: '*******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_open_outlined,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: ( value ){
                if ( value != null && value.length >= 6 ) {
                  return null;
                } else {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
              },
            ),
            const SizedBox( height: 30,),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.blue,
              onPressed: loginForm.isLoading ? null : () async {
                FocusScope.of(context).unfocus();
                final authService = Provider.of<AuthService>(context, listen: false);

                if ( !loginForm.isValidForm() ) return;

                loginForm.isLoading = true;

                final String? errorMsg = await  authService.signUp(loginForm.email, loginForm.password);

                loginForm.isLoading = false;
                if ( errorMsg == null ) {
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  // Mostrar alerta
                  NotificationsService.showSnackBar(errorMsg);
                  print('Error: $errorMsg');

                }

              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere...' : 'Ingresar',
                  style: const TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
