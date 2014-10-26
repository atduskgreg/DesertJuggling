import java.util.Iterator;

class Ball {
  PVector pos;
  PVector dir;
  boolean hit;
  boolean prevHit;
  ArrayList<Dust> dusts;

  Ball(float x, float y) {
    pos = new PVector(x, y);
    dir = new PVector();
    hit = false;
    prevHit = false;
    dusts = new ArrayList<Dust>();
  }

  void applyForce(PVector f) {
    dir.add(f);
  }

  void update() {
    prevHit = hit;
    
    if (pos.y >= 300 - 2.5) {
      pos.y = 297;
      dir.y *= -0.5;
      dir.x *= 0.9;
      hit = true;
    } else {
      hit = false;
    }
    
    if(hit && !prevHit){
      if(dir.mag() > 1.5){
        int num = (int)map(dir.mag(), 1.5, 7, 1, 30);
        dusts.add(new Dust(num, pos, dir));
      }
    }
    
    PVector gravity = new PVector(0, 0.1);
    dir.add(gravity);
    pos.add(dir);
  }
  
  void removeDeadDust(){
    for(Iterator<Dust> iterator = dusts.iterator(); iterator.hasNext();){
      Dust dust = iterator.next();
      if(dust.isExpired()){
        iterator.remove();
      }
    }
  }


  void draw() {
    removeDeadDust();
    for(Dust dust : dusts){
      dust.draw();
    }
    
    
    pushStyle();
    fill(0);
    noStroke();
    ellipse(pos.x, pos.y, 5, 5);
    popStyle();
  }
}

