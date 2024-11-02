int cols, rows;
int w = 20; // Width and height of each cell
int totalMines; // Total number of mines
int[][] board;
boolean[][] revealed;
boolean[][] flagged;
int counter_revealed=0;
boolean gameOver = false;

void setup() {
  size(400, 400);
  cols = width / w;
  rows = height / w;
  totalMines = (int)cols*rows/10;
  board = new int[cols][rows];
  revealed = new boolean[cols][rows];
  flagged = new boolean[cols][rows];
  generateBoard();
}

void draw() {
  background(255);
  drawBoard();
}

void mousePressed() {
  if (!gameOver) {
    int x = mouseX / w;
    int y = mouseY / w;
    if (mouseButton == LEFT) {
      if (!flagged[x][y]) {
        revealCell(x, y);
        if (board[x][y] == -1) {
          gameOver = true;
          revealAll();
          println("Game Over!");
        }
      }
    } else if (mouseButton == RIGHT) {
      flagged[x][y] = !flagged[x][y];
    }
  }
}

void drawBoard() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (revealed[i][j]) {
        if (board[i][j] == -1) {
          fill(127);
          ellipse(i * w + w / 2, j * w + w / 2, w * 0.5, w * 0.5);
        } else {
          fill(200);
          rect(i * w, j * w, w, w);
          if (board[i][j] != 0) {
            fill(0);
            textAlign(CENTER, CENTER);
            text(board[i][j], i * w + w / 2, j * w + w / 2);
          }
        }
      } else {
        fill(100);
        rect(i * w, j * w, w, w);
        if (flagged[i][j]) {
          fill(255, 0, 0);
          textAlign(CENTER, CENTER);
          text("F", i * w + w / 2, j * w + w / 2);
        }
      }
    }
  }
}

void revealCell(int x, int y) {
  if (x < 0 || x >= cols || y < 0 || y >= rows || revealed[x][y])
    return;

  revealed[x][y] = true;
  counter_revealed++;
  if (board[x][y] == 0) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        revealCell(x + i, y + j);
      }
    }
  }
  if (counter_revealed == cols*rows-totalMines) {
    gameOver = true;
    revealAll();
    println("You Win!");
  }
}

void generateBoard() {
  // Initialize board with empty cells
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      board[i][j] = 0;
    }
  }

  // Place mines randomly
  for (int n = 0; n < totalMines; n++) {
    int i = floor(random(cols));
    int j = floor(random(rows));
    if (board[i][j] == -1) {
      n--;
    } else {
      board[i][j] = -1;
      // Increment count of adjacent cells
      for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
          if (i + x >= 0 && i + x < cols && j + y >= 0 && j + y < rows && board[i + x][j + y] != -1) {
            board[i + x][j + y]++;
          }
        }
      }
    }
  }
}

void revealAll() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      revealed[i][j] = true;
    }
  }
}
