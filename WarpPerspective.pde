import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Size;

import org.opencv.core.Mat;
import org.opencv.core.CvType;
import processing.video.*;

//change

OpenCV opencv;
PImage src;
PImage focus;
Capture cam;
int focusWidth = 480;
int focusHeight = 480;

SelectionWindow window = new SelectionWindow();

Contour contour;

void setup() {
  size(640+focusWidth, 480);
  cam = new Capture(this, 640, 480);
  // Start capturing the images from the camera
  cam.start();  
  
  src = createImage(640, 480, RGB);
  opencv = new OpenCV(this, 640, 480);

  focus = createImage(focusWidth, focusHeight, ARGB); 
  opencv.toPImage(warpPerspective(window.getPoints(), focusWidth, focusHeight), focus);
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
  if (cam.available()) { 
    // Reads the new frame
    cam.read(); 
    
  } 
  
  opencv.loadImage(cam);
  
  image(cam, 0, 0); 
  noFill(); 
  stroke(0, 255, 0); 
  strokeWeight(4);
  fill(255, 0);
  ArrayList<PVector> points = window.getPoints();
  for (int i = 0; i < points.size(); i++) {
    text(i, points.get(i).x, points.get(i).y);
  }
  opencv.toPImage(warpPerspective(window.getPoints(), focusWidth, focusHeight), focus);

  pushMatrix();
  translate(640, 0);
  image(focus, 0, 0);
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

