import 'package:flutter/material.dart';

import '../../../res/color/colors.dart';

class GridPainter extends CustomPainter {
  final double decalage = 4.0;
  final List<List<int>> board;
  final double tileSize;

  GridPainter(this.board, this.tileSize);

  @override
  void paint(Canvas canvas, Size size) {
    var tCase = ((size.width - (decalage * 2)) / 4);

    Paint gridPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;


    Paint tilePaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = tCase
      ..style = PaintingStyle.fill;


    // Dessiner les cases de la grille
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        double x = j * tileSize;
        double y = i * tileSize;

        tilePaint.color = getTileColor(board[i][j]);

        // Dessiner les cases avec les bordures
        Rect rect = Rect.fromLTWH(x, y, tileSize, tileSize);
        canvas.drawRect(rect, tilePaint);
        canvas.drawRect(rect, gridPaint);

        //print("board[i][j]ToString==>${board[i][j].toString()}");
        //tilePaint.color = Colors.red;
        // Dessiner le texte des tuiles (si la valeur n'est pas 0)
        if (board[i][j] != 0) {
          drawTileValue(canvas, board[i][j], x, y, tileSize);
        }
      }
    }
  }

  // Fonction pour dessiner la valeur de la tuile
  void drawTileValue(
      Canvas canvas, int value, double x, double y, double size) {
    TextSpan span = TextSpan(
      text: value.toString(),
      style: TextStyle(
        fontSize: size / 2,
        fontWeight: FontWeight.bold,
      ),
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset(x + (size - tp.width) / 2, y + (size - tp.height) / 2),
    );
  }

  // Fonction pour obtenir la couleur de la tuile en fonction de sa valeur
  Color getTileColor(int value) {
    switch (value) {
      case 2:
        return color2;
      case 4:
        return color4;
      case 8:
        return color8;
      case 16:
        return color16;
      case 32:
        return color32;
      case 64:
        return color64;
      case 128:
        return color128;
      case 256:
        return color256;
      case 512:
        return color512;
      case 1024:
        return color1024;
      case 2048:
        return color2048;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}