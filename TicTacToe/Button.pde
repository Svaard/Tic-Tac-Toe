class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  AudioSample sound;
  boolean condition;
  boolean displayed = false;
  
  Button(String label, float xpos, float ypos, float widthB, float heightB, AudioSample sound, boolean condition) {
    this.label = label;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
    this.sound = sound;
    this.condition = condition;
  }
  
  void display() {
    fill(220);
    stroke(140);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }
  
  void setDisplayed(boolean displayed){
    this.displayed = displayed;
  }
  
  boolean isInside() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h) && displayed) {
      return true;
    }
    return false;
  }
  
  void press() {
    sound.trigger();
    delay(500);
    if(!condition){
      exit();
    }
  }
}
