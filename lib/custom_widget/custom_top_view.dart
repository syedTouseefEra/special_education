
import 'package:flutter/Material.dart';

class CustomTopView extends StatefulWidget {
  const CustomTopView({super.key});

  @override
  _CustomTopViewState createState() => _CustomTopViewState();
}

class _CustomTopViewState extends State<CustomTopView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Height of the bottom view when expanded
  final double expandedHeight = 200;
  final double collapsedHeight = 60;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation =
        Tween<double>(begin: collapsedHeight, end: expandedHeight).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
  }

  void togglePanel() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom View Open From Top'),
      ),
      body: Stack(
        children: [
          Center(child: Text('Main content here')),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: _animation.value,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // The draggable/open handle area (collapsed top edge of panel)
                      GestureDetector(
                        onTap: togglePanel,
                        child: Container(
                          height: collapsedHeight,
                          alignment: Alignment.center,
                          child: Container(
                            width: 40,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // When expanded, show three texts
                      if (_animation.value > collapsedHeight + 10)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Text 1',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                'Text 2',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                'Text 3',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}