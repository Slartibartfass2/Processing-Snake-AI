class Food {
  // variables
  private PVector pos;

  //--------------------------------------------------------------------
  // constructor
  public Food(float x, float y) {
    pos.x = x;
    pos.y = y;
  }

  public Food(PVector p) {
    pos = p.copy();
  }

  //--------------------------------------------------------------------
  // functions

  // draws food at its position
  public void draw(float xoff, float yoff, float tilewidth) {
    fill(0, 255, 0);
    PVector realpos = new PVector(pos.x * tilewidth, pos.y * tilewidth);
    noStroke();
    rect(realpos.x + xoff, realpos.y + yoff, tilewidth, tilewidth);
  }

  public Food copy() {
    return new Food(pos);
  }
}
