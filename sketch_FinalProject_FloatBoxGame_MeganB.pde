/*
Game Final Project for Principles of Digital Design (CRCP 6320)

How to Play:
Keep boxes from touching the ground,
click to add more boxes,
click side blocks to move the platform around

Next Steps:
- Add a soundtrack
- Create a database to store the score history (high scores)
- Make boxes smaller as levels increase
- Add particle effect when box hit the ceiling

References:
Color palettes from: https://color.adobe.com/trends/Game-design
*/

// colors for game environment
color darkCol;
color lightCol;
color boxCol;
color uiCol;

// track box objects
ArrayList<GameBox> boxes;
// track platform
Platform platform0;
// buttons
Button3D leftButton;
Button3D rightButton;

// track user interactions
int clickCount = 0;
// track game mechanics
int level = 1;
int clicksPerLevel = 30;
int score = 10; // start with some points
boolean gameIsOver = false;

// track when to play title scene and for how long
boolean titleScene = true;
int titleDuration = 120;
int titleCounter = 0;

void setup() {
  size(1000, 1000, P3D);
  
  // select game colors
  Styles style = new Styles();
  darkCol = style.getDarkCol();
  lightCol = style.getLightCol();
  boxCol = style.getBoxCol();
  uiCol = style.getUICol();

  // initialize storage for boxes
  boxes = new ArrayList<GameBox>();

  GameBox box = new GameBox(100, 100, 100, new PVector(.01, .04), 0, 0, 0, boxCol, 255);
  boxes.add(box);

  // initialize platform
  platform0 = new Platform(new PVector(800, 800, 800), 400, 50, 400, 0, uiCol, 28);

  // initialize buttons
  leftButton = new Button3D(new PVector(-300, 300, 0), 80, 40, 20, uiCol);
  rightButton = new Button3D(new PVector(300, 300, 0), 80, 40, 20, uiCol);
}

void draw() {

  if (titleScene) {
    background(darkCol);
    // draw title scene or next level introduction
    if (titleCounter < titleDuration) {
      // show title
      drawTitleInfo();
      titleCounter++;
    } else {
      // reset so the game shows up
      titleScene = false;
      titleCounter = 0;
    }
  } else {
    // draw the game
    lights();
    noFill();

    // set colors depending on if the game is running or it is over
    if (!gameIsOver) {
      background(darkCol);
      stroke(lightCol, 75);
    } else {
      // inverse colors show
      background(lightCol);
      stroke(darkCol, 75);
      displayGameOver();
      noFill();
    }

    // draw grid boundaries and platform
    translate(width/2, height/2, 0);
    box(800);
    platform0.draw();

    // draw all boxes
    for (GameBox myBox : boxes) {
      myBox.move();
      if (level == 1) {
        myBox.draw();
      } else if (level % 5 == 0) {
        myBox.drawVSticks();
      } else if (level % 3 == 0) {
        myBox.drawVBalls();
      } else if (level % 2 == 0) {
        myBox.drawVBalls();
        myBox.drawContour();
      } else {
        myBox.draw();
      }
      
      if (level >= 4) {
        myBox.standardPush(1);
      }

      boolean hitPlatform = myBox.platformCollision(platform0);
      boolean hitGround = myBox.constrainBounds(new PVector(800, 800, 800), 7);


      if (!gameIsOver) {
        // update the score
        if (hitPlatform) {
          score += 10 * level;
        } else if (hitGround) {
          score -= 4 * level;
        }

        if ((score <= 0) || (clickCount >= 290)) {
          gameIsOver = true;
        }
      }
    }

    // draw 3D buttons
    leftButton.draw();
    rightButton.draw();

    // draw text information
    drawGameInfo();
  }
}

void mousePressed() {
  // increase click count
  clickCount++;
  // check if the left 3D button is clicked
  if (leftButton.isClicked()) {
    platform0.moveLeft();
  }
  // check if the right 3D button is clicked
  else if (rightButton.isClicked()) {
    platform0.moveRight();
  }

  // create a new VBox on click (if not on button)
  else {
    // get mouse position
    PVector mousePos = new PVector(mouseX - width / 2, mouseY - height / 2, 0);
    GameBox newBox = new GameBox(new PVector(100, 100, 100), new PVector(.01, .04), mousePos, boxCol, 255);

    boxes.add(newBox);
  }

  if (!gameIsOver) {
    setLevel();
  }
}

void setLevel() {
  if (clickCount % clicksPerLevel == 0) {
    level++;
    titleScene = true; // show the title intro

    float newWidth = platform0.pWidth * 0.8; // get 80% smaller
    float posX = platform0.posX;
    color newColor = color(red(platform0.pColor) - 10*level, green(platform0.pColor) + 10*level, blue(platform0.pColor) + 10*level);

    platform0 = new Platform(new PVector(800, 800, 800), newWidth, 50, newWidth, posX, newColor, 28);

    // update buttons to match in color
    leftButton = new Button3D(new PVector(-300, 300, 0), 80, 40, 20, newColor);
    rightButton = new Button3D(new PVector(300, 300, 0), 80, 40, 20, newColor);
    
    // increase box speed
    for (GameBox myBox : boxes) {
      myBox.standardPush(float(level * 2));
    }
  }
}


void drawGameInfo() {
  // Switch to 2D mode
  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();

  if (!gameIsOver) {
    fill(lightCol);
  } else {
    fill(darkCol);
  }
  textAlign(RIGHT, TOP);
  textSize(24);

  // count boxes in the game
  int boxesInPlay = 0;
  for (GameBox box : boxes) {
    if (box.isDead() != true) {
      boxesInPlay++;
    }
  }

  String info = "Boxes in Play: " + boxesInPlay + "\n";
  info += "Clicks: " + clickCount + "\n";
  info += "Level: " + level + "\n";
  info += "Score: " + score + "\n";

  text(info, width - 10, 10);

  hint(ENABLE_DEPTH_TEST);
}

void drawTitleInfo() {
  // Switch to 2D mode
  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();

  fill(lightCol);
  textAlign(CENTER, CENTER);
  textSize(64);

  String info = "";

  if (level == 1) {
    info = "Float Box" + "\n";
    info += "Don't touch the ground...";
  } else {
    info = "Level " + level;
  }

  text(info, width/2, height/2);

  hint(ENABLE_DEPTH_TEST);
}

void displayGameOver() {
  // Switch to 2D mode
  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();
  textAlign(CENTER, CENTER);
  textSize(64);
  // disply GAME OVER in center of the screen
  fill(darkCol);
  text("GAME OVER", width/2, height/2);
  hint(ENABLE_DEPTH_TEST);
}
