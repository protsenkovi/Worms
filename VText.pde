class VText extends VObject implements Drawable{
  String s;
  
  public VText(String s, float X, float Y){
    this.s = s;
    this.x = X;
    this.y = Y;
  }
  
  public void draw() {
    fill(230,0,0);
    text(s, x, y);
  }
  public void next() {}
}
