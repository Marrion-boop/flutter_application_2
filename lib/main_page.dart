import 'package:camera/camera.dart';
// ignore: unused_import
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'package:flutter_application_2/pages/AccountPage.dart';
import 'package:flutter_application_2/pages/ChatLogs.dart';
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
  int _selectedIndex = 0;
  late PageController _pageController;

  void StartCamera(int camera){
    cameraController = CameraController(widget.cameras[camera], ResolutionPreset.high, enableAudio: false, );
    cameraValue = cameraController.initialize();
  }

    @override
  void initState() {
    StartCamera(0);
    super.initState();
    _pageController = PageController(initialPage: 0);
  }



 @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    body: PageView(
      controller: _pageController,
  onPageChanged: (index) {
    setState(() {
      _selectedIndex = index;
    });
  },
      children: [
        Stack(
          children: [
            FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    width: size.width,
                    height: size.height,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: 100,
                        child: CameraPreview(cameraController),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
       
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, top: 10),
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
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.camera_rear, color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        ChatLogs(),
        Accountpage(),
      ],
    ), 
    bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  },
  items: [
    
    BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat Logs'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
  ],
),
  );
}

}