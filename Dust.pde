class Dust {
  ArrayList<Particle> particles;
  long tStart;

  Dust(int n, PVector pos, PVector dir) {
    particles = new ArrayList<Particle>();
    for (int i = 0; i < n; i++) {
      particles.add(new Particle(pos, dir));
    }

    tStart = millis();
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

  Particle(PVector startPos, PVector startDir) {
    pos = new PVector(startPos.x, startPos.y);

    dir = new PVector(startDir.x * random(-1, 0.3), startDir.y * random(-1,0.3));
//    dir.mult(-1);
  }

  void draw() {
    if (pos.y >= 300 - 2.5) {
      pos.y=297;
      dir.y *= -0.5;
      dir.x *= 0.9;
    }
    
    dir.y += 0.2;

    pos.add(dir);
//    pos.add(new PVector(0, 1.2));

    ellipse(pos.x, pos.y, 1, 1);
  }
}

