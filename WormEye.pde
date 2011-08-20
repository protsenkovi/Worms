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
   pushStyle();
   stroke(0);
   strokeWeight(1);
   fill(255);
   ellipse(x, y, 10, 10);
   fill(0);
   strokeWeight(0);
   int d = interested?5:3;
   ellipse(x, y, d, d);
   strokeWeight(1);
   if (isEyelash) {
     line(x+10*cos(phi - 20), y+10*sin(phi - 20), x+eyelash*cos(phi - 20),y+eyelash*sin(phi - 20));
     line(x+10*cos(phi - 5), y+10*sin(phi - 5), x+eyelash*cos(phi - 5),y+eyelash*sin(phi - 5));
     line(x+10*cos(phi ), y+10*sin(phi ), x+eyelash*cos(phi ),y+eyelash*sin(phi ));
   }
   popStyle();
//   bezier(x + 10*cos(phi-30),y + 10*sin(phi-30),
//          x + 10*cos(phi-30),y + 10*sin(phi-30),
//          x + (10 + eyelash)*cos(phi-30),y + (10 + eyelash)*sin(phi-30),
//          x + (10 + eyelash)*cos(phi-30),y + (10 + eyelash)*sin(phi-30));
 }
 
 public void next() {
 }
}
