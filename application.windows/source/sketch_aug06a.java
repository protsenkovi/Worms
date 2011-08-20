import processing.core.*; 
import processing.xml.*; 

import java.util.Collection; 
import java.util.Collections; 
import java.util.HashMap; 
import java.util.List; 
import java.util.Map; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class sketch_aug06a extends PApplet {

public void setup() {
  size(width, height);
  stroke(255);
  strokeWeight(2);
  //noStroke();
  fill(0);
  smooth();
  worldInitialize();
}

public void worldInitialize() {
  icircle = new ICircle(width/2, height/2, 150);
  Worms worms = new Worms();
  
  Map<Object, Interest> ihash1 = new HashMap<Object, Interest>();
  Map<Object, Interest> ihash2 = new HashMap<Object, Interest>();
  Map<Object, Interest> ihash3 = new HashMap<Object, Interest>();
  Worm worm1 = worms.CreateWorm("wordinary", ihash1);
  Worm worm2 = worms.CreateWorm("mordinary", ihash2);
  Worm worm3 = worms.CreateWorm("mordinary", ihash3);
  ihash1.put(worm3, new Interest(1.5f, 0.00001f));
  ihash2.put(worm1, new Interest(4));
  ihash3.put(worm2, new Interest(3));
  ihash1.put(icircle, new Interest(3));
  ihash2.put(icircle, new Interest(3));
  ihash3.put(icircle, new Interest(3));
//  for(int i = 0; i < worms.wormcount; i++) {
//    ihash = new HashMap<Object, Interest>();
//    for(int j = 0; j < worms.wormcount; j++) {
//      ihash.put(worms.worms.get(j), new Interest(0));  
//    }
//    ihash.put(icircle, new Interest(4));
//    (worms.worms.get(i)).inteHash = ihash;
//  }    
  //worm1.isLog = true;
  dqueue.push("worms", worms);  
  dqueue.push("icircle", icircle);
}

  int width = 800;
  int height = 600;
  DrawableQueue dqueue = new DrawableQueue();
  ICircle icircle;
  
public void draw() {
  background(200);
  dqueue.ai(null);
  dqueue.draw();
}

public void mouseDragged() 
{  
  if (rightpressed) {
    c.ir = sqrt(sq(c.x - mouseX) + sq(c.y - mouseY));
    line(c.x,c.y,mouseX,mouseY);
  }
}

boolean rightpressed = false;
ICircle c ;

public void mousePressed() {
  if (mouseButton == RIGHT) {
    c = (ICircle)dqueue.pick("icircle");
    rightpressed = true;
    c.x = mouseX;
    c.y = mouseY;
    c.ir = 0;
  } else if (mouseButton == LEFT) {
    if (selectedObjects != null)
      for(VObject vobj:selectedObjects) {
        vobj.selected = false;
        vobj.isLog = false;
      }
        
    selectedObjects = dqueue.selectObjects(mouseX, mouseY);
    println(selectedObjects);
    for(VObject vobj:selectedObjects) {
      vobj.isLog = true;
      vobj.selected = true;
    }
  }
}

List<VObject> selectedObjects = null;



public void mouseReleased() {
  if (mouseButton == RIGHT) {
     rightpressed = false;     
  }
}







interface Drawable {
  public void draw();
  public void next();
}


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

interface Interestable {
  public int getInterest();
}

final class Interest {
    public float curInterest;
    public float maxInterest;
    public float dI;

    public Interest(float interest, float dI) {
      curInterest = interest;
      maxInterest = interest;
      this.dI = dI;
    }

    public Interest(float interest) {
      curInterest = interest;
      maxInterest = interest;
      dI = 0.01f;
    }

    public float computeInterest() {
      curInterest = curInterest + dI;
      if (curInterest > maxInterest) curInterest  = maxInterest;
      //if (curInterest < 0.00001) curInterest = 0.000000001;
      return curInterest;
    }
    
    public String toString() {
      return "Interest: Max = " + maxInterest + " Cur = " + curInterest; 
    }
}

interface Intellectual {
  public void ai(Object[] obj);
}


interface Iterable {
  public Iterator getIterator();
}
interface Intersectable {
  public boolean isIntersected(float x, float y);
}
class Text extends VObject implements Drawable{
  String s;
  
  public Text(String s, float X, float Y){
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
class VObject {
  public float x, y;
  public boolean isLog = false;
  public boolean selected = false;
  
  protected VObject() {
    x = 0;
    y = 0;
  }
}
class Wormeye extends VObject implements Drawable {
 public boolean interested = false;
 boolean isEyelash = false;
 float eyelash = 0;
 public float phi;
 
 public Wormeye (float x, float y, float eyelash) {
   this.x = x; 
   this.y = y;
   this.eyelash = eyelash;
   if (eyelash>0)
     isEyelash = true;
 }

 public void draw() {
   stroke(0);
   strokeWeight(1);
   fill(255);
   ellipse(x, y, 10, 10);
   fill(0);
   strokeWeight(0);
   int d = interested?5:3;
   ellipse(x, y, d, d);
   if (isEyelash) {
     line(x+10*cos(phi - 20), y+10*sin(phi - 20), x+eyelash*cos(phi - 20),y+eyelash*sin(phi - 20));
     line(x+10*cos(phi - 5), y+10*sin(phi - 5), x+eyelash*cos(phi - 5),y+eyelash*sin(phi - 5));
     line(x+10*cos(phi ), y+10*sin(phi ), x+eyelash*cos(phi ),y+eyelash*sin(phi ));
   }
//   bezier(x + 10*cos(phi-30),y + 10*sin(phi-30),
//          x + 10*cos(phi-30),y + 10*sin(phi-30),
//          x + (10 + eyelash)*cos(phi-30),y + (10 + eyelash)*sin(phi-30),
//          x + (10 + eyelash)*cos(phi-30),y + (10 + eyelash)*sin(phi-30));
 }
 
 public void next() {
 }
}
class Worms implements Drawable, Intellectual {
  public int wormcount;
  public List<Worm> worms;

  public Worms() {
    wormcount = 0;
    worms = new ArrayList<Worm>();
  }

  public Worms(int count) {
    wormcount = count;
    worms = new ArrayList<Worm>(count);
    for (int i = 0; i < wormcount; i++) {
      worms.add(new Worm(width/2 + PApplet.parseInt(random(100)), height/2 + PApplet.parseInt(random(100)), "m"));
    }
  }

  public Worm CreateWorm(String type, Map<Object, Interest> ihash) {
    if (type == "mordinary") {
      Worm worm = new Worm(width/2 + PApplet.parseInt(random(100)), height/2 + PApplet.parseInt(random(100)), "m");
      worm.inteHash = ihash;
      worms.add(worm);
      wormcount++;
      return worm;
    } else if (type == "wordinary") {
      Worm worm = new Worm(width/2 + PApplet.parseInt(random(100)), height/2 + PApplet.parseInt(random(100)), "w");
      worm.inteHash = ihash;
      worms.add(worm);
      wormcount++;
      return worm;
      
    }
    return null;
  }

  public void setWormCrowdInterest(Map<Object, Interest> ihash) {
    //println("setWormCrowdInterest method");
    //println(ihash);
    for (Worm worm : worms) {
      if (worm.inteHash == null) {
        worm.inteHash = ihash;
      }
    }
  }

  public void draw() {
    //println("Worms queue. draw method.  count = " + wormcount);
    for (int i = 0; i < wormcount; i++) {
      worms.get(i).next();
      worms.get(i).draw();
    }
  }

  public void next() {
  }

  public void move(int x, int y, float v, int worm) {
    if ((worm >=0) && (worm < wormcount)) {
      worms.get(worm).move(x, y, v);
    }
  }

  public void ai(Object[] obj) {
    for (int i = 0; i < wormcount; i++) {
      worms.get(i).ai(obj);
    }
  }
}

class Worm extends ICircle implements Drawable, Interestable, Intellectual, Intersectable {
  float dx, dy;
  int nX, nY;
  float lDist;  

  public void setX(int x) {
    this.x = x; 
    this.nX = x;
  }

  public void setY(int y) {
    this.y = y; 
    this.nY = y;
  }

  class Query {
    float x[];
    float y[];
    int ind;
    public int cap;
    public Query(int capacity) {
      if (capacity > 0) {
        x = new float[capacity];
        y = new float[capacity];
        ind = capacity - 1;
        cap = capacity;
      }
    }

    public void push(float x, float y) {
      this.x[ind] = x;
      this.y[ind] = y;
      ind--;
      if (ind < 0) {
        ind = this.cap - 1;
      }
    }

    public float nX;
    public float nY;

    public void getN(int i) {
      int j = ind + i + 1;
      if (j >= cap) j = j - cap  ;
      nX = x[j]; 
      nY = y[j];
    }
  }

  Query tail = new Query(10);
  Wormeye eyeleft = null;
  Wormeye eyeright = null;

  public Worm() {
    dx = 0; 
    dy = 0;
    lDist = 0;
    interest = 0;
    ir = 3*R;
    eyeleft = new Wormeye(0, 0, 0);
    eyeright = new Wormeye(0, 0, 0);
  }

  String gender = null;

  public Worm(int x, int y, String gender) {
    this.x = x; 
    this.y = y;
    this.nX = x;
    this.nY = y;
    this.gender = gender;
    dx = 0; 
    dy = 0;
    lDist = 0;
    interest = 0;
    ir = 3*R;
    if ("w".equals(gender)) {
      eyeleft = new Wormeye(0, 0, 5);
      eyeright = new Wormeye(0, 0, 5);
    } else  {
      eyeleft = new Wormeye(0, 0, 0);
      eyeright = new Wormeye(0, 0, 0);
    }      
  }
  //current interesting objects in range
  Map<ICircle, Interest> iobjects = new HashMap<ICircle, Interest>();
  public Map<Object, Interest> inteHash = null;

  public void ai(Object[] objects) {
	Interest interest = null;
	float r = 0;
        boolean lostObjorFound = false;
        if (isLog) {
          println("ai method of Worm: gender =" + gender + " x = " + this.x + " y = " + y); 
          println("\nIObjects:");
        }
        
        Object[] keys = iobjects.keySet().toArray();
        ICircle key;
	for (int i = 0; i < keys.length; i++)  {
                key = (ICircle)keys[i];
                if (isLog) println(" " + key); 
		r = sqrt(sq(key.x - this.x) + sq(key.y - this.y));
		if (r > key.ir) {
			interest = inteHash.get(key);
			interest.dI = -interest.dI;
			iobjects.remove(key);
                        lostObjorFound = true;
		}
	}
	
	if (inteHash != null) {
		for (Interest i : inteHash.values())  {
			i.computeInterest();
		}
	}

    if (isLog) println(inteHash);

    if (isLog) println("Objects:"); 
      
    for (Object obj:objects) {
      //if (isLog) println(" " + obj);
      if (obj instanceof ICircle) {        
        if (isLog) println(" " + obj);
        ICircle c = (ICircle)obj;
        r = sqrt(sq(c.x - this.x) + sq(c.y - this.y));
        if ((r < c.ir) && (inteHash != null) && (inteHash.containsKey(c)))
			if (!(iobjects.containsKey(c))) {
				interest = inteHash.get(c);
				interest.dI = -interest.dI;
				iobjects.put(c, interest);
                                lostObjorFound = true;
			}
      } else if (obj instanceof Worms) {
        Worms worms = (Worms)obj;
        for(Worm worm : worms.worms) {
          if (isLog) println(" " + worm);
          r = sqrt(sq(worm.x - this.x) + sq(worm.y - this.y));
          if ((r < worm.ir) && (inteHash != null) && (inteHash.containsKey(worm)))
			if (!(iobjects.containsKey(worm))) {
				interest = inteHash.get(worm);
				interest.dI = -interest.dI;
				iobjects.put(worm, interest);
                                lostObjorFound = true;
			}
        }
      }
    }
    
    if(isLog) {
      println("\nAfter looking through objects");
      for(Object o: iobjects.keySet())
        println(o);
    }
    
      float curMaxInterest = 0;
      float x = this.x;
      float y = this.y;
	for (ICircle c : iobjects.keySet())  {
		interest = iobjects.get(c);
		if (interest.curInterest > curMaxInterest) {
			curMaxInterest = interest.curInterest;
			r = c.ir;
			x = c.x;
			y = c.y;
		}
	}
    if (isLog) {
      println("CurMaxInterest = " + curMaxInterest);
      println("R of iobject = " + r);
    }
    if ((curMaxInterest > 0) && !((x == this.x) && (y == this.y))) {
      if (((dx == 0) && (dy == 0)) || lostObjorFound) { 
        move(PApplet.parseInt(x + random(r)*cos(random(2*PI))), PApplet.parseInt(y + random(r)*sin(random(2*PI))), curMaxInterest + 1);
      } else {
        setVelocity(curMaxInterest + 1);
      }
    } 
    if (curMaxInterest == 0) {
      if ((dx == 0) && (dy == 0))  
        move(PApplet.parseInt(random(width)), PApplet.parseInt(random(height)), 1);
      else
        setVelocity(1);
    }
    if (isLog) {
      for (int i = 0; i < 80; i++) 
        print(".");
      println();
    }
  }

  public void setVelocity(float v){
    float A = nY - y;
    float B = nX - x;
    this.dx = v*B/sqrt(sq(A) + sq(B));
    this.dy = v*A/sqrt(sq(A) + sq(B));
    if (v > 2) {
      eyeleft.interested = true;
      eyeright.interested = true;
    } 
    else {
      eyeleft.interested = false;
      eyeright.interested = false;
    }
  }

  public void move(int newX, int newY, float v) {
    this.nX = newX;
    this.nY = newY;
    setVelocity(v);
  }

  public void next() {
    lDist = sqrt(sq(nY - y) + sq(nX - x));
    tail.push(x, y);
    x = x + dx;
    y = y + dy;    
    if (lDist < sqrt(sq(nY - y) + sq(nX - x))) {
      x = x - dx;
      y = y - dy;
      this.dx = 0;
      this.dy = 0;
    }
    float c = sqrt(sq(dx) + sq(dy));
    eyeleft.x = x + (R-5)*(sqrt(3)/2*dx/c - dy/c/2);
    eyeleft.y = y + (R-5)*(sqrt(3)/2*dy/c + dx/2/c);
    eyeright.x = x + (R-5)*(sqrt(3)/2*dx/c + dy/c/2);
    eyeright.y =  y + (R-5)*(sqrt(3)/2*dy/c - dx/2/c);
    eyeleft.phi = eyeright.phi = atan2(dy,dx);
  }

  int R = 20;

  public void draw() {
    //println("Worm. draw method.");
    super.draw();
    stroke(255);
    strokeWeight(2);
    if (selected) fill(255,0,0,100); else fill(0);
    ellipse(x, y, R, R);
    strokeWeight(1);
    int r;
    for (int i = 0; i < tail.cap; i++) {
      tail.getN(i);
      r = 20 - (i + 1)*20/(tail.cap + 1); 
      ellipse(tail.nX, tail.nY, r, r);
    }
    eyeleft.draw();
    eyeright.draw();
  }

  int interest;

  public int getInterest() {
    return interest;
  }
  
  public boolean isIntersected(float x, float y) {
    return (R > sqrt(sq(x - this.x) + sq(y - this.y)));
  }
  
  public String toString() {
    return "Worm: x = " + x + " y = " + y;
  }
}



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
      noFill();
      stroke(0);
      ellipse(x, y, 2*ir, 2*ir);
    }
    
    public void next() {}
    
    public boolean isIntersected(float x, float y) {
      return (ir > sqrt(sq(x - this.x) + sq(y - this.y)));
    }
    
    public String toString(){
      return "ICircle: " + "x = " + x + " y = " + y + " r = " + ir;
    }
  }
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "sketch_aug06a" });
  }
}
