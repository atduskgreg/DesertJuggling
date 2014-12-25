Ball ball;
Path path;
int ballStartX = 100;
int maxD = 200;

int totalLife = 10000;
int lifeExpended = 0;

int xOffset = 0;
long lerpStarted = 0;
boolean lerping = false;
int prevOffset = 0;
int newOffset = 0;
float lerpMillis = 1000.0;

int screenTarget = 500;
boolean nextScreenBuilt = false;

void setup() {
  size(1000, 500);
  ball = new Ball(ballStartX, height/2);
  ball.setGroundHeight(height - 50);
  
  screenTarget = width - 100;

  path = new Path();
  path.addPoint(-20, height/2);
  path.addPoint(random(0, width/2), random(0, height));
  path.addPoint(random(width/2, width), random(0, height));
  path.addPoint(width+20, height/2);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      lerping = true;
    }
  }
}

void draw() {
  nextScreen();
  
  pushMatrix();
  translate(-xOffset, 0);

  background(255);
  path.display();

  ball.update();
  ball.draw();

  if (mousePressed) {
    pushStyle();
    if (keyPressed) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    PVector worldMouse = screenToWorld(new PVector(mouseX, mouseY));
    dottedLine(worldMouse.x, worldMouse.y, ball.pos.x, ball.pos.y, 20);
    popStyle();
  }

  float d = distanceToPath(ball.pos, ball.dir, path);
  lifeExpended += d/20.0;

  pushMatrix();
  pushStyle();
  float g = map(d, 0, maxD, 255, 0);
  float r = map(d, 0, maxD, 0, 255);

  fill(r, g, 0);
  translate(ball.pos.x, ball.pos.y);
  text(d, 0, 0);
  popStyle();
  popMatrix();

  popMatrix();
  ball.drawGround();
  drawLifeBar(10, height-30, width-20, 10);
}

void startLerp(){
  lerpStarted = millis();
  prevOffset = xOffset;
  newOffset = (int)ball.pos.x - ballStartX;
  lerping = true;
}

void addPoints(){
  
  
  path.addPoint( path.getEnd().x + width/4 + random(100), height/2 + random(-200,200));
  path.addPoint( path.getEnd().x + width/4 + random(100), height/2 + random(-200,200));
  path.addPoint( path.getEnd().x + width/4 + random(100), height/2 + random(-200,200));
  path.addPoint( path.getEnd().x + width/4 + random(100), height/2 + random(-200,200));
  
 
  nextScreenBuilt = true;
}

void nextScreen() {
  println("bx: " + worldToScreen(ball.pos).x + " t: " + screenTarget);
  if(worldToScreen(ball.pos).x >= screenTarget && !lerping){
    startLerp();
    if(!nextScreenBuilt){
      addPoints();
    }
  }
  
  if (lerping) {
    float l = lerp(prevOffset, newOffset, (millis() - lerpStarted)/lerpMillis);
    xOffset = (int)l;
    if (xOffset >= newOffset) {
      lerping = false;
      nextScreenBuilt = false;
    }
  }
}

void drawLifeBar(int x, int y, int w, int h) {
  pushStyle();
  float percentLeft = (float)(totalLife-lifeExpended)/totalLife;

  if (percentLeft < 0) {
    percentLeft = 0;
  }

  noStroke();
  fill(255, 0, 0);
  rect(x, y, w, h);

  fill(0, 255, 0);
  rect(x, y, w*percentLeft, h);

  noFill();
  stroke(0);
  rect(x, y, w, h);


  popStyle();
}

PVector worldToScreen(PVector p) {  
  return PVector.sub(p, new PVector(xOffset, 0));
}

PVector screenToWorld(PVector p) {
  return PVector.add(p, new PVector(xOffset, 0));
}

void mouseReleased() {
  PVector d = PVector.sub(screenToWorld(new PVector(mouseX, mouseY)), ball.pos);
  float p = map(d.mag(), 0, width+height, 0, 1);
  d.mult(-0.08);
  //println(d.mag());
  if (d.mag() > 7) {
    d.normalize();
    d.mult(7);
  } 

  if (keyPressed == true) {
    d.mult(-1);
  }

  ball.applyForce(d);
}

void dottedLine(float x1, float y1, float x2, float y2, float steps) {
  for (int i=0; i<=steps; i++) {
    float x = lerp(x1, x2, i/steps);
    float y = lerp(y1, y2, i/steps);
    noStroke();
    ellipse(x, y, 2, 2);
  }
}


float distanceToPath(PVector location, PVector velocity, Path p) {
  // Predict location 50 (arbitrary choice) frames ahead
  // This could be based on speed 
  //  PVector predict = velocity.get();
  //  predict.normalize();
  //  predict.mult(50);
  //  PVector predictLoc = PVector.add(location, predict);
  PVector predictLoc = location;
  // Now we must find the normal to the path from the predicted location
  // We look at the normal for each line segment and pick out the closest one

  PVector normal = null;
  PVector target = null;
  float worldRecord = 1000000;  // Start with a very high record distance that can easily be beaten

  PVector bestNormal = new PVector();


  // Loop through all points of the path
  for (int i = 0; i < p.points.size ()-1; i++) {

    // Look at a line segment
    PVector a = p.points.get(i);
    PVector b = p.points.get(i+1);

    // Get the normal point to that line
    PVector normalPoint = getNormalPoint(predictLoc, a, b);
    // This only works because we know our path goes from left to right
    // We could have a more sophisticated test to tell if the point is in the line segment or not
    if (normalPoint.x < a.x || normalPoint.x > b.x) {
      // This is something of a hacky solution, but if it's not within the line segment
      // consider the normal to just be the end of the line segment (point b)
      normalPoint = b.get();
    }

    // How far away are we from the path?
    float distance = PVector.dist(predictLoc, normalPoint);
    // Did we beat the record and find the closest line segment?
    if (distance < worldRecord) {
      worldRecord = distance;
      bestNormal = normalPoint;
    }
  }

  pushStyle();
  float g = map(worldRecord, 0, maxD, 255, 0);
  float r = map(worldRecord, 0, maxD, 0, 255);

  stroke(r, g, 0);
  ellipse(bestNormal.x, bestNormal.y, 4, 4);
  line(bestNormal.x, bestNormal.y, location.x, location.y);
  popStyle();

  return worldRecord;
}
// A function to get the normal point from a point (p) to a line segment (a-b)
// This function could be optimized to make fewer new Vector objects
PVector getNormalPoint(PVector p, PVector a, PVector b) {
  // Vector from a to p
  PVector ap = PVector.sub(p, a);
  // Vector from a to b
  PVector ab = PVector.sub(b, a);
  ab.normalize(); // Normalize the line
  // Project vector "diff" onto line by using the dot product
  ab.mult(ap.dot(ab));
  PVector normalPoint = PVector.add(a, ab);
  return normalPoint;
}

