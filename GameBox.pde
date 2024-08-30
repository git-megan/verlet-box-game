// class for the boxes to fly around in the game

class GameBox extends VBox {
  int lifespan;
  final int lifeUnits = 40; // number of units the lifespan changes at a time

  // color indicators for hitting the ground
  boolean flashing = false;
  int flashDuration = 60; // duration of flash in framse ie 1 second at 60FPS
  int flashCounter = 0;
  color normalColor;


  GameBox() {
    super();
    this.lifespan = 255;
    this.normalColor = this.boxColor;
  }

  GameBox(PVector dim, PVector elasticityRange, PVector position, color boxColor, int lifespan) {
    super(dim, elasticityRange, position, boxColor);
    this.lifespan = lifespan;
    this.normalColor = boxColor;

    // set every game box into motion when it is created
    this.standardPush(5);
  }

  // convenience constructor
  GameBox(float w, float h, float d, PVector elasticityRange, float posX, float posY, float posZ, color boxColor, int lifespan) {
    this(new PVector (w, h, d), elasticityRange, new PVector(posX, posY, posZ), boxColor, lifespan);
  }

  boolean isDead() {
    return this.lifespan <= 0;
  }

  void decreaseLife() {
    this.lifespan -= lifeUnits;

    // cannot be less than 0
    if (this.lifespan <= 0) {
      this.lifespan = 0;
    }

    updateColor();
  }

  void increaseLife() {
    this.lifespan += lifeUnits;

    // cannot be less than 0
    if (this.lifespan >= 255) {
      this.lifespan = 255;
    }

    updateColor();
  }
  
  void standardPush(float maxForce) {
    // set the push behavior
    int[] inds = {0, 2, 4, 6};
    
    if (maxForce <= 0) {
      maxForce = 5;
    }
    float vecsMax = maxForce;
    PVector[] vecs = {
      new PVector(random(-vecsMax, vecsMax), random(-vecsMax, vecsMax), random(-vecsMax, vecsMax)),
      new PVector(random(-vecsMax, vecsMax), random(-vecsMax, vecsMax), random(-vecsMax, vecsMax)),
      new PVector(random(-vecsMax, vecsMax), random(-vecsMax, vecsMax), random(-vecsMax, vecsMax)),
      new PVector(random(-vecsMax, vecsMax), random(-vecsMax, vecsMax), random(-vecsMax, vecsMax))
    };
    super.push(inds, vecs);
  }

  /**
   Update the color based on the lifespan
   lifespan value is the color's alpha
   */
  void updateColor() {
    color oldCol = super.getColor();
    super.setColor(red(oldCol), green(oldCol), blue(oldCol), this.lifespan);
  }

  boolean platformCollision(Platform platform) {
    // assume it hasn't hit the platform until we know it has
    boolean hitPlatform = false;

    for (int i=0; i<verts.length; i++) {
      // check if the vertex is within the platform's vertical range
      if (verts[i].y >= (platform.gameSpace.y / 2 - platform.pHeight)) {
        // check if the vert is within the platform's width - note that the platform can move along the x axis
        if ((verts[i].x <= (platform.posX + platform.pWidth / 2)) && (verts[i].x >= (platform.posX - platform.pWidth / 2))) {
          // check if the vert is within the platform's depth
          if ((verts[i].z <= (platform.pDepth / 2)) && (verts[i].z >= -(platform.pDepth / 2))) {

            // adjust the vert's y location to to vertically hit the top of the platform
            verts[i].y = platform.gameSpace.y / 2 - platform.pHeight;
            // send the box up in the air
            verts[i].y -= platform.bounceBack;
            hitPlatform = true;
            this.increaseLife();
          }
        }
      }
    }
    return hitPlatform;
  }

  @Override
    boolean constrainBounds(PVector wallBounds, float wallBounce) {
    boolean hitGround = super.constrainBounds(wallBounds, wallBounce);

    if (hitGround && (this.isDead() != true)) {
      this.decreaseLife();
      startFlashing();
    }
    return (hitGround && this.flashing);
  }

  void startFlashing() {
    this.flashing = true;
    this.flashCounter = 0;
  }

  void updateFlash() {
    if (flashing) {
      if (flashCounter < flashDuration) {
        this.boxColor = color(255, 0, 0); // flash red
        flashCounter++;
      } else {
        // reset
        super.setColor(red(normalColor), green(normalColor), blue(normalColor), this.lifespan);
        flashing = false;
      }
    }
  }

  @Override
    void move() {
    super.move();
    updateFlash();
  }
}
