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
      worms.add(new Worm(width/2 + int(random(100)), height/2 + int(random(100)), "m"));
    }
  }

  public Worm CreateWorm(String type, Map<Object, Interest> ihash) {
    if (type == "mordinary") {
      Worm worm = new Worm(width/2 + int(random(100)), height/2 + int(random(100)), "m");
      worm.inteHash = ihash;
      worms.add(worm);
      wormcount++;
      return worm;
    } else if (type == "wordinary") {
      Worm worm = new Worm(width/2 + int(random(100)), height/2 + int(random(100)), "w");
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


