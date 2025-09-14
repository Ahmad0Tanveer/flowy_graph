import 'dart:math';

import 'package:example/Example2/widgets/node.dart';
import 'package:flowy_graph/flowy_graph.dart';
import 'package:flutter/material.dart';

class Example2Page extends StatefulWidget {
  const Example2Page({super.key});

  @override
  State<Example2Page> createState() => _Example2PageState();
}

class _Example2PageState extends State<Example2Page> {
  final FlowyNodeController controller = FlowyNodeController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    controller.addSelectListener((Connection conn) {
      debugPrint("ON SELECT inNode: ${conn.inNode}, inPort: ${conn.inPort}");
    });

    controller.addNode(componentNode('node_1_1'), NodePosition.afterLast);
    controller.addNode(componentNode('node_1_2'), NodePosition.afterLast);
    controller.addNode(componentNode('node_1_3'), NodePosition.afterLast);
    controller.addNode(
      receiverNode('node_2_1', _focusNode2, textEditingController),
      NodePosition.afterLast,
    );
    controller.addNode(binaryNode('node_3_1'), NodePosition.afterLast);
    controller.addNode(sinkNode('node_4_1'), NodePosition.afterLast);
    super.initState();
  }

  void _addNewNode() {
    var randomId = Random.secure().nextInt(20000000);
    controller.addNode(
      componentNode("new_node$randomId}"),
      NodePosition.afterLast,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Flowy Graph Example 2"),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('controller.toMap(): ${controller.toJson()}');
            },
            icon: const Icon(Icons.abc),
          ),
        ],
      ),
      body: FlowyCanvas(
        focusNode: _focusNode,
        controller: controller,
        background: const GridBackground(),
        infiniteCanvasSize: 10000,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNode,
        child: const Icon(Icons.add),
      ),
    );
  }
}
