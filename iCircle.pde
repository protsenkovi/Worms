  class ICircle extends VObject implements Drawable, Intersectable {
    public float ir;

    
    public ICircle() {
    }
    
    public ICircle(float x, float y, float r) {
      this.x = x;
      this.y = y;
      this.ir = r;
    }
    
    public void draw() {
      pushStyle();
      noFill();
      stroke(0);
      if (isDebug) ellipse(x, y, 2*ir, 2*ir);
      if (selected) ellipse(x, y, 2*ir, 2*ir);
      popStyle();
    }
    
    public void next() {}
    
    public boolean isIntersected(float x, float y) {
      return (ir > sqrt(sq(x - this.x) + sq(y - this.y)));
    }
    
    public String toString(){
      return "ICircle: " + "x = " + x + " y = " + y + " r = " + ir;
    }
  }
