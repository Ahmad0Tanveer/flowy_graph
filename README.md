# Flowy Graph

Flowy Graph is a Flutter package for building interactive node-based editors, flow diagrams, and
graph visualizations — entirely with Flutter widgets.

It provides a flexible, customizable, and performant API for creating workflows, data pipelines,
visual programming tools, and more.
Inspired by libraries like React Flow, but built natively for Flutter.

## ✨ Features

- 🟦 Customizable Nodes & Edges — build nodes using any Flutter widget
- 🔗 Interactive Connections — connect nodes via drag-and-drop ports
- 📐 Infinite Canvas with Pan & Zoom — navigate large diagrams easily
- 🎨 Theming & Styling — full control over colors, shapes, and ports
- ⚡ Optimized Performance — supports large graphs efficiently
- 🧩 Extensible API — extend with your own widgets and behaviors

## 🚀 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flowy_graph: ^0.0.1
```

Then run:

```bash
flutter pub get
```

Import it in your Dart code:

```dart
import 'package:flowy_graph/flowy_graph.dart';
```

## 📸 Examples

### Example 1: Simple Canvas with Custom Nodes

This example demonstrates a basic canvas with three custom nodes added programmatically via a
floating action button. Each node has input and output ports styled with distinct colors for
connections.

```dart
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
```

![Simple Canvas Example](assets/axample-1.png)

### Example 2: Multiple Node Types with Properties

This example showcases different node types (`componentNode`, `receiverNode`, `binaryNode`,
`sinkNode`) with varied properties, such as dropdown menus, checkboxes, and text input fields,
demonstrating the package's flexibility.

```dart
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
      componentNode("new_node$randomId"),
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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
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

NodeWidgetBase componentNode(String name) {
  return TitleBarNodeWidget(
    name: name,
    typeName: 'node_1',
    backgroundColor: Colors.black87,
    radius: 10,
    selectedBorder: Border.all(color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Output 1'),
            OutPortWidget(
              name: 'PortOut1',
              icon: const Icon(
                Icons.play_arrow_outlined,
                color: Colors.red,
                size: 24,
              ),
              iconConnected: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red),
                ),
                child: Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              multiConnections: false,
              connectionTheme: ConnectionTheme(
                color: Colors.red,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Output 2'),
            SizedBox(
              width: 24,
              height: 24,
              child: OutPortWidget(
                name: 'PortOut2',
                icon: const Icon(
                  Icons.circle_outlined,
                  color: Colors.yellowAccent,
                  size: 20,
                ),
                iconConnected: const Icon(
                  Icons.circle,
                  color: Colors.yellowAccent,
                  size: 20,
                ),
                multiConnections: false,
                connectionTheme: ConnectionTheme(
                  color: Colors.yellowAccent,
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const CheckBoxProperty(name: 'check_port'),
            const Text('Output 3'),
            OutPortWidget(
              name: 'PortOut3',
              icon: const Icon(
                Icons.play_arrow_outlined,
                color: Colors.green,
                size: 24,
              ),
              iconConnected: const Icon(
                Icons.play_arrow,
                color: Colors.green,
                size: 24,
              ),
              multiConnections: false,
              connectionTheme: ConnectionTheme(
                color: Colors.green,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: 30,
                padding: const EdgeInsets.only(left: 4),
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Builder(
                  builder: (context) {
                    return Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(canvasColor: Colors.black),
                      child: DropdownMenuProperty<int>(
                        underline: const SizedBox(),
                        name: 'select',
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(
                              'Item1',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              'Item2',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                              'Item3',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (int? v) {},
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('check 1:'),
            CheckBoxProperty(name: 'check_prop1'),
          ],
        ),
      ],
    ),
    title: const Text('Components'),
    iconTileSpacing: 5,
    titleBarPadding: const EdgeInsets.all(4.0),
    titleBarGradient: const LinearGradient(
      colors: [Color.fromRGBO(0, 23, 135, 1.0), Colors.lightBlue],
    ),
    icon: const Icon(Icons.rectangle_outlined, color: Colors.white),
    width: 200,
  );
}

NodeWidgetBase receiverNode(String name,
    FocusNode focusNode,
    TextEditingController controller,) {
  return TitleBarNodeWidget(
    name: name,
    typeName: 'node_2',
    backgroundColor: Colors.black87,
    radius: 10,
    selectedBorder: Border.all(color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InPortWidget(
                  name: 'PortIn1',
                  onConnect: (String name, String port) => true,
                  icon: const Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.red,
                    size: 24,
                  ),
                  iconConnected: const Icon(
                    Icons.play_arrow,
                    color: Colors.red,
                    size: 24,
                  ),
                  multiConnections: false,
                  connectionTheme: ConnectionTheme(
                    color: Colors.red,
                    strokeWidth: 2,
                  ),
                ),
                const Text('Input 1'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Output 3'),
                OutPortWidget(
                  name: 'PortOut3',
                  icon: const Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.blue,
                    size: 24,
                  ),
                  iconConnected: const Icon(
                    Icons.play_arrow,
                    color: Colors.blue,
                    size: 24,
                  ),
                  multiConnections: false,
                  connectionTheme: ConnectionTheme(
                    color: Colors.blue,
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InPortWidget(
              name: 'PortIn2',
              onConnect: (String name, String port) => true,
              icon: const Icon(
                Icons.play_arrow_outlined,
                color: Colors.red,
                size: 24,
              ),
              iconConnected: const Icon(
                Icons.play_arrow,
                color: Colors.red,
                size: 24,
              ),
              multiConnections: false,
              connectionTheme: ConnectionTheme(
                color: Colors.red,
                strokeWidth: 2,
              ),
            ),
            const Text('Input 2'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Value: '),
            SizedBox(
              width: 50,
              height: 25,
              child: TextEditProperty(
                name: 'text_prop',
                focusNode: focusNode,
                controller: controller,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 5.0,
                  ),
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    title: const Text('Receiver'),
    iconTileSpacing: 5,
    titleBarPadding: const EdgeInsets.all(4.0),
    titleBarGradient: const LinearGradient(
      colors: [Color.fromRGBO(12, 100, 6, 1.0), Colors.greenAccent],
    ),
    icon: const Icon(Icons.receipt_rounded, color: Colors.white),
    width: 200,
  );
}

NodeWidgetBase binaryNode(String name) {
  return ContainerNodeWidget(
    name: name,
    typeName: 'node_3',
    backgroundColor: Colors.blue.shade800,
    radius: 10,
    width: 200,
    contentPadding: const EdgeInsets.all(4),
    selectedBorder: Border.all(color: Colors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InPortWidget(
              name: 'PortIn1',
              onConnect: (String name, String port) => true,
              icon: const Icon(
                Icons.circle_outlined,
                color: Colors.yellowAccent,
                size: 20,
              ),
              iconConnected: const Icon(
                Icons.circle,
                color: Colors.yellowAccent,
                size: 20,
              ),
              multiConnections: false,
              connectionTheme: ConnectionTheme(
                color: Colors.yellowAccent,
                strokeWidth: 2,
              ),
            ),
            InPortWidget(
              name: 'PortIn2',
              onConnect: (String name, String port) => true,
              icon: const Icon(
                Icons.circle_outlined,
                color: Colors.yellowAccent,
                size: 20,
              ),
              iconConnected: const Icon(
                Icons.circle,
                color: Colors.yellowAccent,
                size: 20,
              ),
              multiConnections: false,
              connectionTheme: ConnectionTheme(
                color: Colors.yellowAccent,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
        const Icon(Icons.safety_divider),
        OutPortWidget(
          name: 'PortOut1',
          icon: const Icon(
            Icons.pause_circle_outline,
            color: Colors.deepOrange,
            size: 24,
          ),
          iconConnected: const Icon(
            Icons.pause_circle,
            color: Colors.deepOrange,
            size: 24,
          ),
          multiConnections: false,
          connectionTheme: ConnectionTheme(
            color: Colors.deepOrange,
            strokeWidth: 2,
          ),
        ),
      ],
    ),
  );
}

NodeWidgetBase sinkNode(String name) {
  return TitleBarNodeWidget(
    name: name,
    typeName: 'node_4',
    backgroundColor: Colors.green.shade800,
    radius: 10,
    selectedBorder: Border.all(color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InPortWidget(
                    name: 'PortIn1',
                    onConnect: (String name, String port) => true,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                    iconConnected: const Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                    multiConnections: false,
                    connectionTheme: ConnectionTheme(
                      color: Colors.blueAccent,
                      strokeWidth: 2,
                    ),
                  ),
                  const Text('Input 2'),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    title: const Text(
      'Sinker',
      style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
    ),
    iconTileSpacing: 5,
    titleBarPadding: const EdgeInsets.all(4.0),
    titleBarGradient: const LinearGradient(
      colors: [Colors.yellowAccent, Colors.yellow],
    ),
    icon: const Icon(Icons.calculate_rounded, color: Colors.deepOrange),
    width: 200,
  );
}
```

![Multiple Node Types Example](assets/example-2.png)

## 🛠 Example Project

This package includes a full `example/` app with multiple demos.
Run it with:

```bash
cd example
flutter run
```

## 📖 API Overview

- **FlowyCanvas** → Infinite canvas container with pan/zoom
- **FlowyNodeController** → Manages nodes and connections
- **NodeWidgetBase** → Base class for creating custom nodes
- **InPortWidget / OutPortWidget** → Ports for connections
- **ConnectionTheme** → Style for edges

## 🔑 Use Cases

- Workflow & process editors
- Visual programming tools
- Data pipelines & ETL designers
- Mind maps & organizational charts
- Custom graph-based UIs

## 🧩 Roadmap

- Export/import graph as JSON
- Advanced edge routing (bezier, straight, orthogonal)
- Mini-map widget
- Undo/redo history
- Collaborative editing support

## 🤝 Contributing

Contributions are welcome! 🎉

1. Fork the repo
2. Create a new branch (`feature/my-feature`)
3. Commit changes (`git commit -m 'Add my feature'`)
4. Push and create a PR

Please make sure your code is formatted (`flutter format .`) and passes analysis (
`flutter analyze`).

## 📜 License

This project is licensed under the MIT License.
See the [LICENSE](LICENSE) file for details.

## ❤️ Credits

Created by Your Name.  
Inspired by React Flow but reimagined for the Flutter ecosystem.

## 🛒 Exclusive Software Deals

Check out [Dealsbe](https://dealsbe.com) for exclusive software deals tailored for developers and
startups. Find tools to boost your productivity and streamline your workflow.

### Fresh Recommendations

- Explore the latest deals on developer tools and services.
- [Post a Deal](https://dealsbe.com/post-a-deal) to share your own software or service with the
  community.