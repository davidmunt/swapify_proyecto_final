import 'package:flutter/material.dart';
import 'package:swapify/presentation/screens/home_screen.dart';
import 'package:swapify/presentation/widgets/widget_texto_formulario.dart';

class CreateAcountScreen extends StatefulWidget {
  const CreateAcountScreen({super.key});

  @override
  State<CreateAcountScreen> createState() => CreateAcountScreenState();
}

class CreateAcountScreenState extends State<CreateAcountScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear cuenta"),
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
              const WidgetTextoFormulario(texto: "Nombre", iconoHint: Icon(Icons.person)),
              const SizedBox(height: 12),
              const WidgetTextoFormulario(texto: "Apellidos", iconoHint: Icon(Icons.person)),
              const SizedBox(height: 12),
              const WidgetTextoFormulario(texto: "Email", iconoHint: Icon(Icons.alternate_email)),
              const SizedBox(height: 12),
              const WidgetTextoFormulario(texto: "Telefono", iconoHint: Icon(Icons.phone)),
              const SizedBox(height: 12),
              //
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 178, 178, 178),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null? "Selecciona tu fecha de nacimiento" : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const Icon(Icons.cake, color: Colors.black54),
                    ],
                  ),
                ),
              ),
              //
              const SizedBox(height: 12),
              const WidgetTextoFormulario(texto: "Contraseña", iconoHint: Icon(Icons.lock)),
              const SizedBox(height: 12),
              const WidgetTextoFormulario(texto: "Confirma la contraseña", iconoHint: Icon(Icons.lock)),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                //no funciona de momento
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                },
                style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 10, 185, 121), 
                minimumSize: const Size(450, 70), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Crear usuario y iniciar sesion", style: TextStyle(
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