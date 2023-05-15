import java.util.Arrays;

class Snake implements Comparable {
  // variables
  private Food food;
  private Queue snake;  //all snakeparts as queue
  private NeuralNetwork brain;
  private int direction;
  private int fieldwidth;
  private float tilewidth;

  private int score;
  private boolean dead;
  private boolean win;
  private float dist;

  //----------------------------------------------------------------------
  // constructor
  public Snake(int fieldwidth) {
    direction = 0;
    // Breite und Anzahl an Kästchen
    this.fieldwidth = fieldwidth;
    // Snake mit 4 Startteilen erstellen
    snake = new Queue();
    getStarted(1);
    // Essen erzeugen
    food = createFood();
    // Neuronales Netz generieren
    brain = new NeuralNetwork(6, 8, 3);
    score = 0;
    dead = false;
    win = false;
    dist = dist(food.pos.x, food.pos.y, snake.tail().x, snake.tail().y);
  }

  //----------------------------------------------------------------------
  // functions

  // creates start parts and places them int the middle of the field
  private void getStarted(int count) {
    snake.clear();
    for (int i = count - 1; i >= 0; i--) {
      snake.enqueue(new PVector(fieldwidth / 2, i + fieldwidth / 2 - count / 2));
    }
  }

  // creates a new position for the food which is not in the snake
  private Food createFood() {
    //if (fieldwidth * fieldwidth == snake.length())  
    PVector newFood;
    do {
      newFood = new PVector(floor(random(fieldwidth)), floor(random(fieldwidth)));
    } while (snake.contains(newFood));
    return new Food(newFood);
  }

  // draws all snake parts
  public void drawBig(float realfieldwidth) {
    tilewidth = realfieldwidth / float(fieldwidth);
    //Hintergrund
    fill(125);
    stroke(0);
    rect(0, 0, realfieldwidth, realfieldwidth);
    rect(realfieldwidth, 0, realfieldwidth * 2, realfieldwidth);
    //Essen, Snake, und Neuronales Netz
    food.draw(0, 0, tilewidth);
    snake.draw(0, 0, tilewidth, color(255));
    brain.draw(int(realfieldwidth), 0, int(realfieldwidth) * 2, int(realfieldwidth));
  }

  public void drawSmall(float x, float y, float fwidth, color back, color snakec) {
    fill(back);
    stroke(0);
    rect(x, y, fwidth, fwidth);
    food.draw(x, y, fwidth / float(fieldwidth));
    snake.draw(x, y, fwidth / float(fieldwidth), snakec);
  }

  public int compareTo(Object o) {
    Snake s = (Snake) o;
    return s.score - score;
  }

  public void update() {
    if (win || dead)
      return;

    // Brain's Decision
    float[] input = new float[6];
    input[0] = isWayClear(0);
    input[1] = isWayClear(3);
    input[2] = isWayClear(1);
    input[3] = isFood(0);
    input[4] = isFood(3);
    input[5] = isFood(1);
    float[] output = brain.output(input);

    int index = 0;
    float value = output[0];
    for (int i = 1; i < 3; i++) {
      if (output[i] > value) {
        index = i;
        value = output[i];
      }
    }

    if (index == 1)
      direction = (--direction + 4) % 4;
    else if (index == 2)
      direction = (++direction) % 4;

    PVector p = snake.tail().copy();
    if (direction == 0)
      p.y--;
    else if (direction == 1)
      p.x++;
    else if (direction == 2)
      p.y++;
    else if (direction == 3)
      p.x--;

    if (snake.contains(p) || p.x < 0 || p.x >= fieldwidth || p.y < 0 || p.y >= fieldwidth) {
      dead = true;
      return;
    } else if (snake.length() + 1 == fieldwidth * fieldwidth) {
      if (p.x == food.pos.x && p.y == food.pos.y) {
        //win = true;
        getStarted(4);
        food = createFood();
        dist = dist(food.pos.x, food.pos.y, snake.tail().x, snake.tail().y);
        score *= 2;
      } else
        dead = true; 
      return;
    }

    snake.enqueue(p);

    if (p.x == food.pos.x && p.y == food.pos.y) {
      food = createFood();
      score += 10;
    } else
      snake.dequeue();

    float newdist = dist(food.pos.x, food.pos.y, snake.tail().x, snake.tail().y);
    if (newdist >= dist)
      score -= 2;
    else
      score += 1;
    dist = newdist;
  }

  private int isWayClear(int dir) {
    PVector p;
    if (dir == 1)
      p = getPoint((direction + 1) % 4);
    else if (dir == 3)
      p = getPoint((direction + 3) % 4); // + 4 - 1
    else
      p = getPoint(direction);
    return (snake.contains(p) || (p.x < 0 || p.x >= fieldwidth || p.y < 0 || p.y >= fieldwidth)) ? 1 : 0;
  }

  private int isFood(int dir) {
    PVector p1, p3, p0;
    p1 = getPoint((direction + 1) % 4);
    p3 = getPoint((direction + 3) % 4); // + 4 - 1
    p0 = getPoint(direction);
    PVector[] points = new PVector[] { p0, p1, p3 };

    PVector f = food.pos;
    int index = 0;
    float value = dist(points[0].x, points[0].y, f.x, f.y);
    for (int i = 1; i < 3; i++) {
      float t = dist(points[i].x, points[i].y, f.x, f.y);
      if (t < value) {
        index = i;
        value = t;
      }
    }

    if (dir == 3 && index == 2)
      return 1;
    else if (dir == index)
      return 1;
    return 0;
  }

  private PVector getPoint(int dir) {
    PVector p = snake.tail().copy();
    if (dir == 0)
      p.y--;
    else if (dir == 1)
      p.x++;
    else if (dir == 2)
      p.y++;
    else if (dir == 3)
      p.x--;
    return p;
  }

  public Snake copy() {
    Snake result = new Snake(fieldwidth);
    result.direction = direction;
    result.snake = snake.copy();
    result.food = food.copy();
    result.brain = brain.clone();
    result.score = score;
    result.dead = dead;
    result.win = win;
    result.dist = dist;
    return result;
  }

  public Snake clone() {
    Snake result = new Snake(fieldwidth);
    result.brain = brain.clone();
    return result;
  }
}
