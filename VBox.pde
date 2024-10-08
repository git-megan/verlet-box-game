class VBox {

  /*
     6------7
   /|     /|
   3-|----2 |
   | |    | |
   | 5----|-4
   |/     |/
   0------1
   */

  PVector dim;
  PVector elasticityRange;

  // control initial position
  PVector position;

  // color
  color boxColor;


  Tup2i[] contours = {
    new Tup2i(0, 1),
    new Tup2i(1, 2),
    new Tup2i(2, 3),
    new Tup2i(3, 0),
    new Tup2i(6, 7),
    new Tup2i(7, 4),
    new Tup2i(4, 5),
    new Tup2i(5, 6),
    new Tup2i(0, 5),
    new Tup2i(1, 4),
    new Tup2i(2, 7),
    new Tup2i(3, 6)
  };

  // the 8 unique vertices in the cube
  PVector[] verts = new PVector[8];

  Tup3i[] inds = {
    new Tup3i(0, 5, 1),
    new Tup3i(1, 5, 4),
    new Tup3i(4, 2, 1),
    new Tup3i(4, 7, 2),
    new Tup3i(6, 7, 5),
    new Tup3i(7, 4, 5),
    new Tup3i(0, 3, 5),
    new Tup3i(5, 3, 6),
    new Tup3i(0, 2, 3),
    new Tup3i(0, 1, 2),
    new Tup3i(3, 7, 6),
    new Tup3i(3, 2, 7)
  };

  Face3[] faces = new Face3[12];

  VBall[] vbs = new VBall[8];

  // all surface sticks
  ArrayList<VStick> vss = new ArrayList<VStick>();

  VBox() {
    this(100, 100, 100, new PVector(.01, .08), 0, 0, 0, #cbf078);
  }

  VBox(PVector dim, PVector elasticityRange, PVector position, color boxColor) {
    this.dim = dim;
    this.elasticityRange = elasticityRange;
    this.position = position;
    this.boxColor = boxColor;


    verts[0] = new PVector(-.5*this.dim.x, .5*this.dim.y, .5*this.dim.z).add(position); //0
    verts[1] = new PVector(.5*this.dim.x, .5*this.dim.y, .5*this.dim.z).add(position); //1
    verts[2] = new PVector(.5*this.dim.x, -.5*this.dim.y, .5*this.dim.z).add(position); //2
    verts[3] = new PVector(-.5*this.dim.x, -.5*this.dim.y, .5*this.dim.z).add(position); //3
    verts[4] = new PVector(.5*this.dim.x, .5*this.dim.y, -.5*this.dim.z).add(position); //4
    verts[5] = new PVector(-.5*this.dim.x, .5*this.dim.y, -.5*this.dim.z).add(position); //5
    verts[6] = new PVector(-.5*this.dim.x, -.5*this.dim.y, -.5*this.dim.z).add(position); //6
    verts[7] = new PVector(.5*this.dim.x, -.5*this.dim.y, -.5*this.dim.z).add(position); //7


    for (int i=0; i<vbs.length; i++) {
   
      vbs[i] = new VBall(verts[i], 5);
    }

    create();
  }

  // convenience cstr
  VBox(float w, float h, float d, PVector elasticityRange, float posX, float posY, float posZ, color boxColor) {
    this(new PVector(w, h, d), elasticityRange, new PVector(posX, posY, posZ), boxColor);
  }

  color getColor() {
    return this.boxColor;
  }

  void setColor(color newColor) {
    this.boxColor = newColor;
  }

  void setColor(float r, float g, float b, int a) {
    this.boxColor = color(r, g, b, a);
  }

  void create() {
    for (int i=0; i< inds.length; i++) {
      faces[i] = new Face3(verts[inds[i].i0], verts[inds[i].i1], verts[inds[i].i2]);
    }

    for (int i=0; i<vbs.length; i++) {
      for (int j=i; j<vbs.length-1; j++) {
        vss.add(new VStick(vbs[i], vbs[j+1], random(elasticityRange.x, elasticityRange.y)));
      }
    }
  }

  void push(int index, PVector v) {
    vbs[index].push(v);
  }

  void push(int[] indices, PVector v) {
    for (int i=0; i<indices.length; i++) {
      vbs[ indices[i] ].push(v);
    }
  }

  // requires parallel arrays
  void push(int[] indices, PVector[] vs) {
    for (int i=0; i<indices.length; i++) {
      vbs[ indices[i] ].push(vs[i]);
    }
  }


  void move() {
    for (int i=0; i<vbs.length; i++) {
      vbs[i].verlet();
    }

    for (int i=0; i<vss.size(); i++) {
      vss.get(i).constrainLen();
    }
  }



  void draw() {
    noStroke();
    fill(this.boxColor);
    for (int i=0; i< faces.length; i++) {
      faces[i].draw();
    }
  }

  void drawContour() {
    noFill();
    stroke(this.boxColor);
    beginShape(LINES);
    for (int i=0; i<contours.length; i++) {
      vertex(verts[contours[i].i0].x, verts[contours[i].i0].y, verts[contours[i].i0].z);
      vertex(verts[contours[i].i1].x, verts[contours[i].i1].y, verts[contours[i].i1].z);
    }
    endShape();
  }

  void drawVBalls() {
    for (int i=0; i< vbs.length; i++) {
      vbs[i].draw(this.boxColor);
    }
  }

  void drawVSticks() {
    noFill();
    for (int i=0; i<vss.size(); i++) {
      vss.get(i).draw(this.boxColor);
    }
  }



  boolean constrainBounds(PVector bounds, float offset) {

    boolean hitGround = false;
    for (int i=0; i<verts.length; i++) {
      if (verts[i].x >= bounds.x/2) {
        verts[i].x = bounds.x/2;
        verts[i].x -= offset;
      } else if (verts[i].x <= -bounds.x/2) {
        verts[i].x = -bounds.x/2;
        verts[i].x += offset;
      }

      if (verts[i].y >= bounds.y/2) {
        verts[i].y = bounds.y/2;
        verts[i].y -= offset;
        hitGround = true;
      } else if (verts[i].y <= -bounds.y/2) {
        verts[i].y = -bounds.y/2;
        verts[i].y += offset;
      }

      if (verts[i].z >= bounds.z/2) {
        verts[i].z = bounds.z/2;
        verts[i].z -= offset;
      } else if (verts[i].z <= -bounds.z/2) {
        verts[i].z = -bounds.z/2;
        verts[i].z += offset;
      }
    }
    return hitGround;
  }
}
