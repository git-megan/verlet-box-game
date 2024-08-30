class Button3D {

  // position
  PVector pos;

  // dimensions
  float w;
  float h;
  float d;

  // color
  color fillColor;

  Button3D() {
  }

  Button3D(PVector pos, float w, float h, float d, color fillColor) {
    this.pos = pos;
    this.w = w;
    this.h = h;
    this.d = d;
    this.fillColor = fillColor;
  }

  /**
   Draws the button
   */
  void draw() {
    // draw left button
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(fillColor);
    noStroke();
    box(w, h, d);
    popMatrix();
  }

  /**
   Checks if the button has just been clicked
   */

  boolean isClicked() {
    PVector screenPos = new PVector(pos.x + width / 2, pos.y + height / 2, pos.z);
    PVector screenMouse = new PVector(mouseX, mouseY, 0);

    float halfWidth = w / 2;
    float halfHeight = h / 2;

    return (screenMouse.x >= screenPos.x - halfWidth && screenMouse.x <= screenPos.x + halfWidth &&
      screenMouse.y >= screenPos.y - halfHeight && screenMouse.y <= screenPos.y + halfHeight);
  }
}
