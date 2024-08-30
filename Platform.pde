class Platform {
  // space boundaries for the game (platform must stay within here)
  PVector gameSpace;
  
  // dimensions of the platform
  float pWidth;
  float pHeight;
  float pDepth;
  
  // platform's location on X axis
  float posX;
  final float moveIncrement = 20;
  
  // color
  color pColor;
  
  // how much push happens when something bounces off the platform
  float bounceBack;
  
  Platform() {
    this.gameSpace = new PVector(800, 800, 800);
    this.pWidth = 400;
    this.pHeight = 50;
    this.pDepth = 400;
    
    this.posX = 0;
    
    this.pColor = #f1b963;
    this.bounceBack = 28;
  }
  
  Platform(PVector gameSpace, float w, float h, float d, float startX, color pColor, float bounceBack) {
    this.gameSpace = gameSpace;
    this.pWidth = w;
    this.pHeight = h;
    this.pDepth = d;
    
    if ((startX >= (gameSpace.x - w / 2)) || (startX <= (-gameSpace.x + w / 2))) {
      this.posX = 0; // start in the center
    } else {
      this.posX = startX;
    }
    
    this.pColor = pColor;
    this.bounceBack = bounceBack;
  }
  
  void moveRight() {
    this.posX += moveIncrement;
    boundsCollision();
  }
  
  void moveLeft() {
    this.posX -= moveIncrement;
    boundsCollision();
  }
  
  void boundsCollision() {
    float rightWall = this.gameSpace.x / 2;
    float leftWall = -rightWall;
    
    float halfWidth = this.pWidth / 2;
    
    if ((this.posX + halfWidth) >= rightWall) {
      this.posX = rightWall - halfWidth;
    }
    else if ((this.posX - halfWidth) <= leftWall) {
      this.posX = leftWall + halfWidth;
    }
  }
  
  void draw() {
    noStroke();
    fill(this.pColor);
    
     // Translate to the bottom of the game space before drawing
    pushMatrix();
    translate(this.posX, gameSpace.y / 2 - this.pHeight / 2, 0);
    box(this.pWidth, this.pHeight, this.pDepth);
    popMatrix();
  }
  
  
}
