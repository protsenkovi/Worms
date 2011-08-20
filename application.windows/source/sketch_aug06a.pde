void setup() {
  size(width, height);
  stroke(255);
  strokeWeight(2);
  //noStroke();
  fill(0);
  smooth();
  worldInitialize();
}

void worldInitialize() {
  icircle = new ICircle(width/2, height/2, 150);
  Worms worms = new Worms();
  
  Map<Object, Interest> ihash1 = new HashMap<Object, Interest>();
  Map<Object, Interest> ihash2 = new HashMap<Object, Interest>();
  Map<Object, Interest> ihash3 = new HashMap<Object, Interest>();
  Worm worm1 = worms.CreateWorm("wordinary", ihash1);
  Worm worm2 = worms.CreateWorm("mordinary", ihash2);
  Worm worm3 = worms.CreateWorm("mordinary", ihash3);
  ihash1.put(worm3, new Interest(1.5, 0.00001));
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
  
void draw() {
  background(200);
  dqueue.ai(null);
  dqueue.draw();
}

void mouseDragged() 
{  
  if (rightpressed) {
    c.ir = sqrt(sq(c.x - mouseX) + sq(c.y - mouseY));
    line(c.x,c.y,mouseX,mouseY);
  }
}

boolean rightpressed = false;
ICircle c ;

void mousePressed() {
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



void mouseReleased() {
  if (mouseButton == RIGHT) {
     rightpressed = false;     
  }
}

