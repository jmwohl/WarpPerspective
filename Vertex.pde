class Vertex {
  boolean hovered = false;
  boolean selected = false;
  PVector point;
  float radius = 10;
  float hoveredRadius = 12;
  
  Vertex(int x, int y) {
    point = new PVector(x, y);
  }
  
  float x() {
    return point.x;
  }
  
  float y() {
    return point.y;
  }
  
  void update() {

  }
  
  void draw() {
    float finalRad = radius;
    int fillColor = g.fillColor;
    if (isHovering()) {
      finalRad = hoveredRadius;
      fill(255);
    }
    
    ellipse(point.x, point.y, finalRad, finalRad);
    fill(fillColor);
  }
  
  boolean isHovering() {
    float dist = sqrt(sq(mouseX - point.x) + sq(mouseY - point.y));
    return dist <= radius;
  }
  
  void mousePressed() {
//    println("mouse pressed");
    if(isHovering()) { 
      selected = true;
    } else {
      selected = false;
    }
  }
  
  void mouseDragged() {
//    println("mouse dragged");
    if(selected) {
      point.x = mouseX;
      point.y = mouseY;
    }
  }
  
  void mouseReleased() {
    selected = false;
  }
}
