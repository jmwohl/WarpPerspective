import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Size;

import org.opencv.core.Mat;
import org.opencv.core.CvType;


OpenCV opencv;
PImage src;
PImage card;
int cardWidth = 250;
int cardHeight = 350;

SelectionWindow window = new SelectionWindow();

Contour contour;

void setup() {
  src = loadImage("cards.png");
  size(src.width + cardWidth, src.height);
  opencv = new OpenCV(this, src);

  opencv.blur(1);
  opencv.threshold(120);

//  contour = opencv.findContours(false, true).get(3).getPolygonApproximation();

  card = createImage(cardWidth, cardHeight, ARGB); 
  opencv.toPImage(warpPerspective(window.getPoints(), cardWidth, cardHeight), card);
}

Mat getPerspectiveTransformation(ArrayList<PVector> inputPoints, int w, int h) {
  Point[] canonicalPoints = new Point[4];
  canonicalPoints[0] = new Point(w, 0);
  canonicalPoints[1] = new Point(0, 0);
  canonicalPoints[2] = new Point(0, h);
  canonicalPoints[3] = new Point(w, h);

  MatOfPoint2f canonicalMarker = new MatOfPoint2f();
  canonicalMarker.fromArray(canonicalPoints);

  Point[] points = new Point[4];
  for (int i = 0; i < 4; i++) {
    points[i] = new Point(inputPoints.get(i).x, inputPoints.get(i).y);
  }
  MatOfPoint2f marker = new MatOfPoint2f(points);
  return Imgproc.getPerspectiveTransform(marker, canonicalMarker);
}

Mat warpPerspective(ArrayList<PVector> inputPoints, int w, int h) {
  Mat transform = getPerspectiveTransformation(inputPoints, w, h);
  Mat unWarpedMarker = new Mat(w, h, CvType.CV_8UC1);    
  Imgproc.warpPerspective(opencv.getColor(), unWarpedMarker, transform, new Size(w, h));
  return unWarpedMarker;
}


void draw() {
  clear();
  image(src, 0, 0);
  noFill(); 
  stroke(0, 255, 0); 
  strokeWeight(4);
//  contour.draw();
  fill(255, 0);
  ArrayList<PVector> points = window.getPoints();
  for (int i = 0; i < points.size(); i++) {
    text(i, points.get(i).x, points.get(i).y);
  }
  opencv.toPImage(warpPerspective(window.getPoints(), cardWidth, cardHeight), card);

  pushMatrix();
  translate(src.width, 0);
  image(card, 0, 0);
  popMatrix();
  
  window.draw();
}

void mousePressed() {
  window.mousePressed();
}

void mouseReleased() {
  window.mouseReleased();
}

void mouseDragged() {
  window.mouseDragged();
  ArrayList<PVector> points = window.getPoints();
  
  println("");
  
  for (int i=0; i<points.size(); i++) {
    println(points.get(i).x + ", " + points.get(i).y);
  }
  
  println("");
}

void keyPressed() {
  window.keyPressed();
}

