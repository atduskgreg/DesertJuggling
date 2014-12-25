class Dust {
  ArrayList<Particle> particles;
  long tStart;
  int groundHeight;

  Dust(int n, PVector pos, PVector dir, int groundHeight) {
    particles = new ArrayList<Particle>();
    for (int i = 0; i < n; i++) {
      particles.add(new Particle(pos, dir, groundHeight));
    }

    tStart = millis();
    this.groundHeight = groundHeight;
  }
  
  void setGroundHeight(int groundHeight){
    this.groundHeight = groundHeight;
  }

  void draw() {
    pushStyle();
    noStroke();
    int a = (int)map(millis() - tStart, 0, 1000, 255, 0);
    fill(0, a);
    for (Particle particle : particles) {
      particle.draw();
    }

    popStyle();
  }

  boolean isExpired() {
    return (millis() - tStart) > 1000;
  }
}

class Particle {
  PVector pos;
  PVector dir;
  int groundHeight;

  Particle(PVector startPos, PVector startDir, int groundHeight) {
    pos = new PVector(startPos.x, startPos.y+2.5);
    dir = new PVector(startDir.x * random(-1, 0.5), startDir.y * random(-1,0));
    this.groundHeight = groundHeight;
  }

  void draw() {
    if (pos.y >= groundHeight - 0.5) {
      pos.y=groundHeight-1;
      dir.y *= -0.5;
      dir.x *= 0.9;
    }
    
    dir.y += 0.2;

    pos.add(dir);
//    pos.add(new PVector(0, 1.2));

    ellipse(pos.x, pos.y, 1, 1);
  }
}

