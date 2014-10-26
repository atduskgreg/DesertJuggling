Ball ball;

void setup() {
  size(1000, 500);
  ball = new Ball(100, 298);
//  ball.applyForce(new PVector(1, 0));
}

void draw() {
  background(255);
  fill(0);
  noStroke();
  rect(0, 300, width, height-300);

  ball.update();
  ball.draw();
  if (mousePressed) {
    pushStyle();
    fill(255,0,0);
    dottedLine(ball.pos.x, ball.pos.y, mouseX, mouseY, 20);
    popStyle();
  }
}

void mouseReleased(){
  PVector d = PVector.sub(new PVector(mouseX, mouseY), ball.pos);
  float p = map(d.mag(), 0, width+height, 0, 1);
  d.mult(-0.08);
  println(d.mag());
  if(d.mag() > 7){
    d.normalize();
    d.mult(7);
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

