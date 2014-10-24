class SelectionWindow {
  ArrayList<Vertex> vertices;
  boolean display = true;
  
  SelectionWindow() {
    vertices = new ArrayList<Vertex>();
    
    // top right
    vertices.add(new Vertex(200, 100));
    // top left
    vertices.add(new Vertex(100, 100));
    // bottom left
    vertices.add(new Vertex(100, 200));
    // bottom right
    vertices.add(new Vertex(200, 200));
    
    
  }
  
  void draw() {
    if (!display) {
      return;
    }
    stroke(200, 200, 255);
    fill(100);
    strokeWeight(2);
    
    int size = vertices.size();
    
    // draw lines
    for (int i = 0; i < size; i++) {
      Vertex a;
      Vertex b;
      a = vertices.get(i);
      if (i < vertices.size() - 1) {
        b = vertices.get(i+1);
      } else {
        b = vertices.get(0);
      }
      
      line(a.x(), a.y(), b.x(), b.y());
    }
    
    // draw vertices
    for (int i = 0; i < size; i++) {
      vertices.get(i).draw();
    }
  }
  
  ArrayList<PVector> getPoints() {
    ArrayList<PVector> points = new ArrayList<PVector>();
    for (int i = 0; i < vertices.size(); i++) {
      points.add(vertices.get(i).point);
    }
    
    return points;
  }
  
  void mousePressed() {
    for (int i = 0; i < vertices.size(); i++) {
      vertices.get(i).mousePressed();
    }
  }
  
  void mouseReleased() {
    for (int i = 0; i < vertices.size(); i++) {
      vertices.get(i).mouseReleased();
    }
  }
  
  void mouseDragged() {
    for (int i = 0; i < vertices.size(); i++) {
      vertices.get(i).mouseDragged();
    }
  }
  
  void keyPressed() {
     if (key == 'w') {
       display = !display;
     }
  }
}
