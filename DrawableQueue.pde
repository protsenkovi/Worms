import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class DrawableQueue implements Drawable, Intellectual {
  Map<String, Drawable> map = new HashMap<String, Drawable>();
  
  public DrawableQueue(){}
  
  public void push(String name, Drawable dobject) {
    map.put(name, dobject);
  }
  
  public void ai(Object[] obj) {
    Collection<Drawable> col = map.values();
    for(Object obje:col) {
      if (obje instanceof Worms){
        Worms worms = (Worms)obje;
        worms.ai(col.toArray());
      }
    }
  }
  
  public List<VObject> selectObjects(float x, float y) {
    Collection<Drawable> col = map.values();
    List<VObject> selectedObj = new ArrayList<VObject>();
    for(Object obje:col) {
      if (obje instanceof Intersectable){
        Intersectable sobj = (Intersectable)obje;
//        println(sobj);
        if ((sobj.isIntersected(x,y)) && (sobj instanceof VObject)) 
          selectedObj.add((VObject)sobj);
      } else if (obje instanceof Worms) {
          Worms worms = (Worms)obje;
          for(Worm wobj:worms.worms) {
//            println(wobj);
            if (wobj.isIntersected(x,y)) 
              selectedObj.add(wobj);
          }
      }
    }
    return selectedObj;
  }
  
  //public Drawable selectObjects(float x1, float y1, float x2, float y2) {
  //}
    
  public Drawable pop(String name) {
    Drawable dobj = map.get(name);
    map.remove(name);
    return dobj;
  }
  
  public Drawable pick(String name) {
    return map.get(name);
  }
  
  public void next() {}
  
  public void draw() {
    //println("Drawable queue. draw method.");
    Collection<Drawable> col = map.values();
    for(Drawable dobj:col) {
      dobj.draw();
    }
  }
}  

