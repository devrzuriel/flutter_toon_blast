import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Puzzle Game',
      home: PuzzleGame(),
    );
  }
}

class PuzzleGame extends StatefulWidget {
  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  static const int gridCount = 5;
  late List<List<Color>> grid;

  @override
  void initState() {
    super.initState();
    initializeGrid();
  }

  void initializeGrid() {
    grid = List.generate(
      gridCount,
          (i) => List.generate(gridCount, (j) => getRandomColor()),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple
    ];
    return colors[random.nextInt(colors.length)];
  }

  void handleTap(int i, int j) {
    Color selectedColor = grid[i][j];
    clearSameColorBlocks(i, j, selectedColor);
    dropAndRefillBlocks();
    setState(() {}); // Update the UI
  }

  void clearSameColorBlocks(int i, int j, Color color) {
    if (i < 0 || i >= gridCount || j < 0 || j >= gridCount || grid[i][j] != color || grid[i][j] == Colors.transparent) {
      return; // Boundary condition, color check, and transparent check
    }

    grid[i][j] = Colors.transparent; // Clear the block

    // Recursively check adjacent blocks
    clearSameColorBlocks(i + 1, j, color);
    clearSameColorBlocks(i - 1, j, color);
    clearSameColorBlocks(i, j + 1, color);
    clearSameColorBlocks(i, j - 1, color);
  }

  void dropAndRefillBlocks() {
    for (int j = 0; j < gridCount; j++) {
      int emptyIndex = -1; // Track the index of the first empty (transparent) block
      for (int i = gridCount - 1; i >= 0; i--) {
        if (grid[i][j] == Colors.transparent && emptyIndex == -1) {
          emptyIndex = i; // Found the first empty block in this column
        } else if (grid[i][j] != Colors.transparent && emptyIndex != -1) {
          // Swap the block with the empty block
          grid[emptyIndex][j] = grid[i][j];
          grid[i][j] = Colors.transparent;
          emptyIndex--; // Move the empty index up
        }
      }
      // Fill the top blocks with new colors if there are any empty blocks
      for (int i = emptyIndex; i >= 0; i--) {
        grid[i][j] = getRandomColor();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Puzzle Game'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridCount,
        ),
        itemCount: gridCount * gridCount,
        itemBuilder: (context, index) {
          int i = index ~/ gridCount;
          int j = index % gridCount;
          return GestureDetector(
            onTap: () => handleTap(i, j),
            child: Container(
              decoration: BoxDecoration(
                color: grid[i][j],
                border: Border.all(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
