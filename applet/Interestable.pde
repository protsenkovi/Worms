interface Interestable {
  int getInterest();
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
      dI = 0.01;
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
  void ai(Object[] obj);
}
