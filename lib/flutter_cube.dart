import 'dart:async';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ARView extends StatefulWidget {
  @override
  _ARViewState createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  late ARKitController arkitController;
  late ARKitNode node;
  double moveDistance = 0.0;
  bool forward = true;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARKitSceneView(
        onARKitViewCreated: (controller) {
          arkitController = controller;
          _add3DObject();
        },
      ),
    );
  }

  void _add3DObject() {
    final sphere = ARKitSphere(radius: 0.1, materials: [
      ARKitMaterial(
        diffuse: ARKitMaterialProperty.color(Color.fromRGBO(0, 35, 215, 1)),
      ),
    ]);

    node = ARKitNode(
      geometry: sphere,
      position: Vector3(0, 0, -0.5),
    );

    arkitController.add(node);
    _startAnimation();
  }

  void _startAnimation() {
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (forward) {
        moveDistance += 0.01;
        if (moveDistance >= 0.2) forward = false;
      } else {
        moveDistance -= 0.01;
        if (moveDistance <= 0.0) forward = true;
      }
      node.position = Vector3(0, 0, -0.5 + moveDistance);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
