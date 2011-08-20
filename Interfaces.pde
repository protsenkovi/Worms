interface Interestable {
  int getInterest();
}

interface Intellectual {
  void ai(Object[] obj);
}

interface Drawable {
  void draw();
  void next();
}

interface Movable {
  float getDx();
  float getDy();
  float getPhi();
}

interface Intersectable {
  boolean isIntersected(float x, float y);
}
