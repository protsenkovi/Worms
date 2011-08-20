class Worm extends ICircle implements Drawable, Interestable, Intellectual, Intersectable, Movable {
  float dx, dy;
  int nX, nY;
  float lDist;  
  
  public float getDx() {
    return dx;
  }
  
  public float getDy() {
    return dy;
  }
  
  public float getPhi() {
    return atan2(dy,dx);
  }

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
    ICircle cuObject = null;
	for (ICircle c : iobjects.keySet())  {
		interest = iobjects.get(c);
		if (interest.curInterest > curMaxInterest) {
		  curMaxInterest = interest.curInterest;
		  cuObject = c;
		}
	}

    if (isLog) {
      println("CurMaxInterest = " + curMaxInterest);
      println("R of iobject = " + cuObject.ir);
    }
    
    if ((curMaxInterest > 0) && !((cuObject.x == this.x) && (cuObject.y == this.y))) {
      if (((dx == 0) && (dy == 0)) || lostObjorFound) { 
        if (cuObject instanceof Movable) {
          Movable cuo = (Movable)cuObject;
          if (!((cuo.getDx() == 0) && (cuo.getDy() == 0)))
            move(int(cuObject.x + random(cuObject.ir)*cos(random(cuo.getPhi() - 2*PI/3,cuo.getPhi() + 2*PI/3))), int(cuObject.y + random(cuObject.ir)*sin(random(cuo.getPhi() - 2*PI/3,cuo.getPhi() + 2*PI/3))), curMaxInterest + 1);
          else
            move(int(cuObject.x + random(cuObject.ir)*cos(random(2*PI))), int(cuObject.y + random(cuObject.ir)*sin(random(2*PI))), curMaxInterest + 1);
        } else {
          move(int(cuObject.x + random(cuObject.ir)*cos(random(2*PI))), int(cuObject.y + random(cuObject.ir)*sin(random(2*PI))), curMaxInterest + 1);
        }
      } else {
        setVelocity(curMaxInterest + 1);
      }
    } 
    if (curMaxInterest == 0) {
      if ((dx == 0) && (dy == 0))  
        move(int(random(width)), int(random(height)), 1);
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
    pushStyle();
    //println("Worm. draw method.");
    super.draw();
    stroke(0);
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
    popStyle();
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



