class VBall {

  PVector pos, posOld;
  float radius;

  VBall() {
  }

  VBall(PVector pos, float radius) {
    this.pos = pos;
    this.radius = radius;
    this.posOld  = new PVector(pos.x, pos.y, pos.z);
  }

  void push(PVector push_vec) {
    this.pos.add(push_vec);
  }

  void verlet() {
    PVector posTemp = new PVector(pos.x, pos.y, pos.z);
    pos.x += (pos.x-posOld.x);

    pos.y += (pos.y - posOld.y);

    pos.z += (pos.z-posOld.z);
    posOld.set(posTemp);
  }

  void draw(color _fill) {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    noStroke();
    fill(_fill);
    sphere(radius*2);
    popMatrix();
  }

  void boundsCollision(PVector push) {
    if (pos.x>width-radius) {
      pos.x = width-radius;
      posOld.x = pos.x;
      pos.x -= push.x;
    } else if (pos.x<radius) {
      pos.x = radius;
      posOld.x = pos.x;
      pos.x += push.x;
    }

    if (pos.y<radius) {
      pos.y = radius;
      posOld.y = pos.y;
      pos.y += push.y;
    }

    if (pos.y>height-radius) {
      pos.y = height-radius;
      posOld.y = pos.y;
      pos.y -= push.y;
    }
  }
}
