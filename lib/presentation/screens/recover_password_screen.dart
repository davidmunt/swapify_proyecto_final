import 'package:flutter/material.dart';
import 'package:swapify/presentation/screens/login_screen.dart';
import 'package:swapify/presentation/widgets/widget_texto_formulario.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => RecoverPasswordScreenState();
}

class RecoverPasswordScreenState extends State<RecoverPasswordScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar contraseña"),
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("assets/images/logo_fin_img.png", fit: BoxFit.contain),
              ),
              const SizedBox(height: 40),
              const WidgetTextoFormulario(texto: "Email", iconoHint: Icon(Icons.alternate_email)),
              const SizedBox(height: 12),
              const WidgetTextoFormulario(texto: "Nueva contraseña", iconoHint: Icon(Icons.lock)),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                //no funciona de momento
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 10, 185, 121), 
                minimumSize: const Size(450, 70), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Modificar contraseña", style: TextStyle(
                color: Colors.black,
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                )),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
    );
  }
}