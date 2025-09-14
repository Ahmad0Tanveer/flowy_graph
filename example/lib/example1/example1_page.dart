import 'dart:math';

import 'package:flowy_graph/flowy_graph.dart';
import 'package:flutter/material.dart';

class Example1Page extends StatefulWidget {
  const Example1Page({super.key});

  @override
  State<Example1Page> createState() => _Example1PageState();
}

class _Example1PageState extends State<Example1Page> {
  final FlowyNodeController _controller = FlowyNodeController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    updateListener();
    super.initState();
  }

  void onUpdate() {}

  void updateListener() {
    _controller.addListener(onUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flowy Graph')),
      body: FlowyCanvas(
        controller: _controller,
        focusNode: _focusNode,
        infiniteCanvasSize: 10000,
        background: const GridBackground(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.addNode(
            exampleNode("MyFirstNode${Random.secure().nextInt(20000000)}"),
            NodePosition.custom(const Offset(100, 100)),
          );
          _controller.addNode(
            exampleNode("MyFirstNode2${Random.secure().nextInt(20000000)}"),
            NodePosition.custom(const Offset(200, 230)),
          );
          _controller.addNode(
            exampleNode("MyFirstNode8${Random.secure().nextInt(20000000)}"),
            NodePosition.custom(const Offset(320, 330)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  NodeWidgetBase exampleNode(String name) {
    return ContainerNodeWidget(
      name: name,
      typeName: 'custom_node',
      backgroundColor: Colors.blue.shade800,
      radius: 10,
      width: 230,
      contentPadding: const EdgeInsets.all(8),
      selectedBorder: Border.all(color: Colors.white, width: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InPortWidget(
            name: 'in1',
            onConnect: (node, port) => true,
            icon: const Icon(Icons.circle_outlined, color: Colors.yellow),
            iconConnected: const Icon(Icons.circle, color: Colors.yellow),
            connectionTheme: ConnectionTheme(
              color: Colors.yellow,
              strokeWidth: 2,
            ),
            multiConnections: true,
          ),
          InPortWidget(
            name: 'in2',
            onConnect: (node, port) => true,
            icon: const Icon(Icons.circle_outlined, color: Colors.yellow),
            iconConnected: const Icon(Icons.circle, color: Colors.yellow),
            connectionTheme: ConnectionTheme(
              color: Colors.yellow,
              strokeWidth: 2,
            ),
            multiConnections: true,
          ),
          const Icon(Icons.link),
          OutPortWidget(
            name: 'out1',
            multiConnections: false,
            icon: const Icon(Icons.circle_outlined, color: Colors.red),
            iconConnected: const Icon(Icons.circle, color: Colors.red),
            connectionTheme: ConnectionTheme(color: Colors.red, strokeWidth: 2),
          ),
        ],
      ),
    );
  }
}
