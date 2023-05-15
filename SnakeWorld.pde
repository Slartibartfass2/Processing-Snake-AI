import java.util.Arrays;

class SnakeWorld {
  private Snake[] snakes;
  private int verticalSnakeAmount;
  private int horizontalSnakeAmount;
  private int totalSnakes;
  private int theight;
  private int bestcount;
  private int generation;
  private boolean showFPS;
  private PFont font;
  private int fontSize;
  private int highscore;
  private int highscoregen;
  private float avgscore;

  public SnakeWorld(int verticalSnakeAmount, int theight, int fieldwidth) {
    this.verticalSnakeAmount = verticalSnakeAmount;
    this.horizontalSnakeAmount = verticalSnakeAmount * 3;
    totalSnakes = verticalSnakeAmount * horizontalSnakeAmount;
    this.theight = theight;
    snakes = new Snake[totalSnakes];
    for (int i = 0; i < snakes.length; i++) {
      snakes[i] = new Snake(fieldwidth);
    }
    bestcount = floor(snakes.length * 0.1);
    generation = 1;
    showFPS = true;
    fontSize = 20;
    font = createFont("Arial", fontSize, true);  //Font
    highscore = 0;
    avgscore = 0.0;
    highscoregen = 1;
  }

  public void draw() {
    int deadSnakes = 0;
    int negativSnakes = 0;
    float tilewidth = theight / 2.0 / float(verticalSnakeAmount);

    // Update all Snakes
    for (int i = 0; i < totalSnakes; i++)
      snakes[i].update();

    Snake[] sortedSnakes = snakes.clone();
    Arrays.sort(sortedSnakes);


    int totalScore = 0;

    // Draw all Snakes
    for (int i = 0; i < totalSnakes; i++) {
      Snake s = snakes[i];
      totalScore += snakes[i].score;

      if (s.dead)
        deadSnakes++;
      else if (s.score < 0)
        negativSnakes++;

      color snakec = color(255);
      if (s.equals(sortedSnakes[0])) { // beste Snake
        snakec = color(255, 0, 0);
        s.drawBig(theight / 2.0);
      } 
      else if (oneOfTheBest(s, sortedSnakes))  // Top 10%
        snakec = color(0, 0, 255);
        else if (s.dead)
        snakec = color(0);
      else if (s.score < 0)
        snakec = color(255, 255, 125);

      int x = i % horizontalSnakeAmount;
      int y = i / horizontalSnakeAmount;

      s.drawSmall(x * tilewidth, y * tilewidth + theight / 2.0 + 1, tilewidth, color(125), snakec);
    }
    
    avgscore = totalScore / float(totalSnakes);
    
    if (sortedSnakes[0].score > highscore) {
      highscore = sortedSnakes[0].score;
      highscoregen = generation;
    }
    
    if (showFPS) {
      textFont(font);
      fill(255);
      int line = 1;
      text("FPS: " + round(frameRate), 2, line++ * fontSize);
      text("Gen: " + generation, 2, line++ * fontSize);
      text("Score: " + sortedSnakes[0].score, 2, line++ * fontSize);
      text("HS: " + highscore, 2, line++ * fontSize);
      text("HSG: " + highscoregen, 2, line++ * fontSize);
      text("Avg: " + nf(avgscore, 1, 1), 2, line++ * fontSize);
    }
    
    // next Gen
    if (deadSnakes + negativSnakes == totalSnakes) {
      Snake[] bestSnakes = new Snake[bestcount];
      float[] prop = new float[bestcount];
      int allScore = 0;
      for (int i = 0; i < bestcount; i++) {
        bestSnakes[i] = sortedSnakes[i].copy();
        allScore += bestSnakes[i].score;
      }
      
      int[] copySnakes = new int[bestcount];
      int sum = 0;
      for (int i = 0; i < bestcount; i++) {
        prop[i] = bestSnakes[i].score / float(allScore);
        copySnakes[i] = round(prop[i] * totalSnakes);
        sum += copySnakes[i];
      }
      copySnakes[0] += totalSnakes - sum;
      int offset = 0;
      for (int i = 0; i < bestcount; i++) {
        for (int j = offset; j < offset + copySnakes[i]; j++) {
          snakes[j] = bestSnakes[i].clone();
          snakes[j].brain.mutate(0.1);
        }
        offset += copySnakes[i];
      }
      generation++;
    }
  }

  private boolean oneOfTheBest(Snake s, Snake[] bestSnakes) {
    for (int i = 1; i < bestcount; i++) {
      if (s.equals(bestSnakes[i]))
        return true;
    }
    return false;
  }
}
