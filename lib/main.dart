import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:starflut/starflut.dart';

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

  Future<void> callPython() async {
    StarCoreFactory starcore = await Starflut.getFactory();
    StarServiceClass Service = await starcore.initSimple("test", "123", 0, 0, []);
    await starcore.regMsgCallBackP(
        (int serviceGroupID, int uMsg, Object wParam, Object lParam) async{
      print("$serviceGroupID  $uMsg   $wParam   $lParam");
      return null;
    });
    StarSrvGroupClass SrvGroup = await Service["_ServiceGroup"];

    /*---script python--*/
    bool isAndroid = await Starflut.isAndroid();
    if( isAndroid == true ){
      await Starflut.copyFileFromAssets("faceCheck.py", "flutter_assets/starfiles","flutter_assets/starfiles");
      await Starflut.copyFileFromAssets("python3.6.zip", "flutter_assets/starfiles",null);  //desRelatePath must be null 
      await Starflut.copyFileFromAssets("zlib.cpython-36m.so", null,null);
      await Starflut.copyFileFromAssets("unicodedata.cpython-36m.so", null,null);
      await Starflut.loadLibrary("libpython3.6m.so");
    }

    String docPath = await Starflut.getDocumentPath();
    print("docPath = $docPath");

    String resPath = await Starflut.getResourcePath();
    print("resPath = $resPath");

    dynamic rr1 = await SrvGroup.initRaw("python36", Service);

    print("initRaw = $rr1");
		var Result = await SrvGroup.loadRawModule("python", "", resPath + "/flutter_assets/starfiles/" + "testpy.py", false);
    print("loadRawModule = $Result");

		dynamic python = await Service.importRawContext("python", "", false, "");
    print("python = "+ await python.getString());

		StarObjectClass retobj = await python.call("tt", ["hello ", "world"]);
    print(await retobj[0]);
    print(await retobj[1]);

    print(await python["g1"]);
        
    StarObjectClass yy = await python.call("yy", ["hello ", "world", 123]);
    print(await yy.call("__len__",[]));

    StarObjectClass multiply = await Service.importRawContext("python", "Multiply", true, "");
    StarObjectClass multiply_inst = await multiply.newObject(["", "", 33, 44]);
    print(await multiply_inst.getString());

    print(await multiply_inst.call("multiply", [11, 22]));

    await SrvGroup.clearService();
		await starcore.moduleExit();
  }

  void openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
      if(imageFile != null) {
        msgSucesso();
      }
    });
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
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void msgErro() {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Erro",
      desc: "Ocorreu um erro na detecção de face!",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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