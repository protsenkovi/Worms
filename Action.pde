abstract class Action implements Drawable {
  private VObject target;
  private String musicurl;
  
  public Action(VObject target) {
    this.target = target;
  }
  
  public void next() {    
  }
  
  public void draw() {
  }
}
