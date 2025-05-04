import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraController cameraController;
  late Future<void> cameraValue;
  bool isFlashOn = false; 
  bool isRearCamera = true;

  void StartCamera(int camera){
    cameraController = CameraController(widget.cameras[camera], ResolutionPreset.high, enableAudio: false, );
    cameraValue = cameraController.initialize();
  }

    @override
  void initState() {
    StartCamera(0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(future: cameraValue, builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return SizedBox(
                width: size.width,
                height: size.height,
                child: FittedBox(
                  fit:BoxFit.cover,
                   child: SizedBox(
                    width: 100,
                    child: CameraPreview(cameraController)
                    ),
                ),
              );
            }
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
             ),
          SafeArea(child: 
          Align(alignment: Alignment.topRight,
          child: Padding(padding: EdgeInsets.only(right: 5, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              const Gap(10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRearCamera = !isRearCamera;
                  });
                  isRearCamera ? StartCamera(0) : StartCamera(1); 
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(50, 0, 0, 0),
                    shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: isFlashOn 
                            ? const Icon(Icons.camera_rear, color: Colors.white, size: 30,)
                            : const Icon(Icons.camera_rear, color: Colors.white, size: 30,),
                      ),
                ),
              ),
            ],
          ),
          ),
          ),
          ),
        ],
      )
    );
  }
}