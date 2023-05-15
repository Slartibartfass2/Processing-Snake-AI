Snake snake;
SnakeWorld snakeWorld;
int tiles = 20;
int VSA = 4;

void setup() {
  size(1276, 852);
  snakeWorld = new SnakeWorld(VSA, 850, tiles);
}

void draw() {
  snakeWorld.draw();
}

void keyPressed() {
  if (key == ' ')
    snakeWorld = new SnakeWorld(VSA, 850, tiles);
  else if (key == 'f')
    snakeWorld.showFPS = !snakeWorld.showFPS;
}
