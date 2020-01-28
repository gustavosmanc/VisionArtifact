import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MyApp());

const MaterialColor myColor = const MaterialColor(
  0XFF45A5F5,
  const <int, Color>{
    50: const Color (0XFF45A5F5),
    100: const Color (0XFF45A5F5),
    200: const Color (0XFF45A5F5),
    300: const Color (0XFF45A5F5),
    400: const Color (0XFF45A5F5),
    500: const Color (0XFF45A5F5),
    600: const Color (0XFF45A5F5),
    700: const Color (0XFF45A5F5),
    800: const Color (0XFF45A5F5),
    900: const Color (0XFF45A5F5),
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: myColor,
        scaffoldBackgroundColor: const Color(0xFF2A2A2A)
      ),
home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File imageFile;

  void openCamera() async {
    try {
      var picture = await ImagePicker.pickImage(source: ImageSource.camera);
      this.setState(() {
        imageFile = picture;
        if(imageFile != null) {
          msgSucesso();
          msgErro(1);
          msgErro(2);
          msgErro(3);
        }
      });
    } on Exception catch(_) {
      msgErro(2);
    }
  }

  void msgSucesso() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Acesso autorizado!",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void msgErro(int Tipo) {

    String txtErro = "";
    if(Tipo == 1) {
      txtErro = "Acesso não autorizado!";
    }
    else if(Tipo == 2) {
      txtErro = "Erro ao abrir a câmera!";
    }
    else if(Tipo == 3) {
      txtErro = "Erro na aplicação!";
    }

    Alert(
      context: context,
      type: AlertType.error,
      title: txtErro,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: new Image.asset(
                'assets/images/LogoVA.png',
                color: Color.fromRGBO(255, 255, 255, 1.0),
                colorBlendMode: BlendMode.modulate,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          openCamera();
        },
        label: Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}