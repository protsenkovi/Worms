void setup() {
  size(width, height);
  stroke(255);
  strokeWeight(0);
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
  translate(100,0);
}
  
  int width = screen.width - 300;
  int height = screen.height - 300;
  int worldwidth = screen.width;
  int worldheight = screen.height;
  DrawableQueue dqueue = new DrawableQueue();
  ICircle icircle;
  //int translateX = (worldwidth - screen.width)/2;
  //int translateY = (worldheight - screen.height)/2;
  
void draw() {
    //rect(-translateX, -translateY, screen.width + translateX, screen.height + translateY);
    //translate(translateX, translateY);
    background(#4D814D);
    dqueue.ai(null);
    dqueue.draw();
}

boolean rightpressed = false;
boolean leftpressed = false;
ICircle c ;
List<VObject> selectedObjects = null;
int leftButtonPressedX = 0;
int leftButtonPressedY = 0;
int lastTrX = 0;
int lastTrY = 0;

void mouseDragged() 
{  
  if (rightpressed) {
    c.ir = sqrt(sq(c.x - mouseX) + sq(c.y - mouseY));
    line(c.x,c.y,mouseX,mouseY);
  }
  if (leftpressed) {
//    translateX = mouseX - leftButtonPressedX + lastTrX;
//    translateY = mouseY - leftButtonPressedY + lastTrY;
//    if (translateX < -(worldwidth - screen.width)/2)
//      translateX = -(worldwidth - screen.width)/2;
//    if (translateX > (worldwidth - screen.width))
//      translateX = worldwidth - screen.width;
//    if (translateY < -(worldheight - screen.height)/2)
//      translateX = -(worldheight - screen.height)/2;
//    if (translateY > (worldheight - screen.height))
//      translateX = worldheight - screen.height;    
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    c = (ICircle)dqueue.pick("icircle");
    rightpressed = true;
    c.x = mouseX;
    c.y = mouseY;
    c.ir = 0;
  } else if (mouseButton == LEFT) {
    leftpressed = true;
    leftButtonPressedX = mouseX;
    leftButtonPressedY = mouseY;
    
    if (selectedObjects != null)
      for(VObject vobj:selectedObjects) {
        vobj.selected = false;
        vobj.isLog = false;
      }
        
    selectedObjects = dqueue.selectObjects(mouseX, mouseY);
    println(selectedObjects);
    for(VObject vobj:selectedObjects) {
//      vobj.isLog = true;
      vobj.selected = true;
    }
  }
}
void mouseReleased() {
  if (mouseButton == RIGHT) {
     rightpressed = false;     
  } else if (mouseButton == LEFT) {
    leftpressed = false;
//    lastTrX = translateX;
//    lastTrY = translateY;
  }
}

