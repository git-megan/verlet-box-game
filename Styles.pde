class Styles {
  
  color[] myColors;
  
  // colors for: dark, light, box, ui
  color[][] colorOptions = {
  {#000000, #ffffff, #cbf078, #f1b963}, //original
  {#172573, #F2D43D, #854AD9, #F2388F},
  {#0D0D0D, #F2F2F2, #D99748, #73614C},
  {#1A2620, #60A6A6, #D94A4A, #F26680},
  {#027313, #1DF2DD, #D929BB, #07F22B},
  {#010626, #30A8F2, #7C05F2, #0B59BF},
  {#184D59, #B4D9CE, #308C83, #659FA6},
  {#260801, #F2EB80, #BF6A1F, #401A04},
  };
  
  Styles() {
    setNewPalette();
  }
  
  void setNewPalette() {
    int randomIndex = int(random(colorOptions.length));
    myColors = colorOptions[randomIndex];
  }
  
  color getDarkCol() {
    return myColors[0];
  }
  
  color getLightCol() {
    return myColors[1];
  }
  
  color getBoxCol() {
    return myColors[2];
  }
  
  color getUICol() {
    return myColors[3];
  }
}
