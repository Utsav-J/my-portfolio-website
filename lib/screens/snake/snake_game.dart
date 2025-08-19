import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/config/app_design.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int rows = 15;
  static const int cols = 15;
  static const int cellSize = 45;

  final random = Random();
  final techIcons = [
    'assets/icons/python.png',
    'assets/icons/java.png',
    'assets/icons/javascript.png',
    'assets/icons/aws.png',
    'assets/icons/flutter.png',
    'assets/icons/docker.png',
    'assets/icons/kubernetes.png',
    'assets/icons/react.png',
    'assets/icons/node.png',
    //new
    'assets/icons/dart.png',
    'assets/icons/c.png',
    'assets/icons/cpp.png',
    'assets/icons/sql.png',
    'assets/icons/bash.png',
    'assets/icons/angular.png',
    'assets/icons/huggingface.png',
    'assets/icons/mongodb.png',
    'assets/icons/postman.png',
    'assets/icons/firebase.png',
  ];

  List<Point<int>> snake = [const Point(7, 7)];
  Point<int> direction = const Point(1, 0);
  Point<int> food = const Point(5, 5);
  String currentFoodIcon = '';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _spawnFood();
    timer = Timer.periodic(const Duration(milliseconds: 200), _update);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _spawnFood() {
    setState(() {
      food = Point(random.nextInt(cols), random.nextInt(rows));
      currentFoodIcon = techIcons[random.nextInt(techIcons.length)];
    });
  }

  void _update(Timer timer) {
    final newHead = Point(
      snake.first.x + direction.x,
      snake.first.y + direction.y,
    );

    // Game over if hit wall or self
    if (newHead.x < 0 ||
        newHead.y < 0 ||
        newHead.x >= cols ||
        newHead.y >= rows ||
        snake.contains(newHead)) {
      timer.cancel();
      _showGameOverOverlay();
      return;
    }

    setState(() {
      snake.insert(0, newHead);

      if (newHead == food) {
        _spawnFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void _changeDirection(Point<int> newDir) {
    if ((newDir.x + direction.x != 0) || (newDir.y + direction.y != 0)) {
      setState(() {
        direction = newDir;
      });
    }
  }

  void _showGameOverOverlay() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => _GameOverOverlay(
        score: snake.length - 1,
        onRestart: () {
          Navigator.pop(context);
          setState(() {
            snake = [const Point(7, 7)];
            direction = const Point(1, 0);
            _spawnFood();
            this.timer = Timer.periodic(
              const Duration(milliseconds: 200),
              _update,
            );
          });
        },
        onClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowUp:
              _changeDirection(const Point(0, -1));
              break;
            case LogicalKeyboardKey.arrowDown:
              _changeDirection(const Point(0, 1));
              break;
            case LogicalKeyboardKey.arrowLeft:
              _changeDirection(const Point(-1, 0));
              break;
            case LogicalKeyboardKey.arrowRight:
              _changeDirection(const Point(1, 0));
              break;
          }
        }
        return KeyEventResult.handled;
      },
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < 0) _changeDirection(const Point(0, -1));
          if (details.delta.dy > 0) _changeDirection(const Point(0, 1));
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < 0) _changeDirection(const Point(-1, 0));
          if (details.delta.dx > 0) _changeDirection(const Point(1, 0));
        },
        child: Container(
          color: Colors.black,
          child: Center(
            child: SizedBox(
              width: cols * cellSize.toDouble(),
              height: rows * cellSize.toDouble(),
              child: CustomPaint(
                painter: _SnakePainter(snake, food, currentFoodIcon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SnakePainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int> food;
  final String foodIcon;

  _SnakePainter(this.snake, this.food, this.foodIcon);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = Size(
      size.width / _SnakeGameState.cols,
      size.height / _SnakeGameState.rows,
    );
    final paintSnake = Paint()..color = Colors.green;

    // Draw snake head (custom image)
    final head = snake.first;
    final headRect = Rect.fromLTWH(
      head.x * cellSize.width,
      head.y * cellSize.height,
      cellSize.width,
      cellSize.height,
    );
    final snakeHeadImage = AssetImage('assets/snake_head.png');
    final paintImageFuture = snakeHeadImage.resolve(ImageConfiguration.empty);

    paintImageFuture.addListener(
      ImageStreamListener((imageInfo, _) {
        final src =
            Offset.zero &
            Size(
              imageInfo.image.width.toDouble(),
              imageInfo.image.height.toDouble(),
            );
        canvas.drawImageRect(imageInfo.image, src, headRect, Paint());
      }),
    );

    // Draw snake body
    for (var i = 1; i < snake.length; i++) {
      final segment = snake[i];
      canvas.drawRect(
        Rect.fromLTWH(
          segment.x * cellSize.width,
          segment.y * cellSize.height,
          cellSize.width,
          cellSize.height,
        ),
        paintSnake,
      );
    }

    // Draw food (icon)
    final foodRect = Rect.fromLTWH(
      food.x * cellSize.width,
      food.y * cellSize.height,
      cellSize.width,
      cellSize.height,
    );
    final foodImage = AssetImage(foodIcon);
    final foodImageFuture = foodImage.resolve(ImageConfiguration.empty);

    foodImageFuture.addListener(
      ImageStreamListener((imageInfo, _) {
        final src =
            Offset.zero &
            Size(
              imageInfo.image.width.toDouble(),
              imageInfo.image.height.toDouble(),
            );
        canvas.drawImageRect(imageInfo.image, src, foodRect, Paint());
      }),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GameOverOverlay extends StatefulWidget {
  final int score;
  final VoidCallback onRestart;
  final VoidCallback onClose;

  const _GameOverOverlay({
    required this.score,
    required this.onRestart,
    required this.onClose,
  });

  @override
  State<_GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<_GameOverOverlay>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: AppDesign.glassmorphicContainer(
              width: 300,
              padding: const EdgeInsets.all(20),
              borderRadius: 16.0,
              blurStrength: 20.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Game Over', style: AppDesign.popupTitle()),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Game Over Image
                  Image.asset('assets/game_over.png', height: 120),
                  const SizedBox(height: 16),

                  // Score
                  Text(
                    'Your score: ${widget.score}',
                    textAlign: TextAlign.center,
                    style: AppDesign.popupBody(),
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: widget.onRestart,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Restart',
                            style: AppDesign.buttonText(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
