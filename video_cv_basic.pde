import processing.video.*;
import gab.opencv.*;

OpenCV opencv;
Capture cap;
PImage img, dst;
ArrayList<Contour> contours;
ArrayList<PVector> points;
int thresVal = 70;
int blurVal = 5;

void setup() {
  size(640, 480);
  //frameRate(15);
  String[] list = Capture.list();
  cap = new Capture(this, 640, 480, list[0]);

  cap.start();
  opencv = new OpenCV(this, cap.width, cap.height);
  points = new ArrayList<PVector>();
  colorMode(HSB, 100);
}

void draw() {
  background(0);  
  cap.filter(GRAY);
  opencv.loadImage(cap);
  opencv.gray();
  opencv.blur(blurVal);
  opencv.threshold(thresVal);
  dst = opencv.getOutput();
  contours = opencv.findContours();
  image(dst, 0, 0);
  
  noFill();
  strokeWeight(6);
  int contourCount = 0;
  for (Contour contour : contours) {
    int pointsNum = contour.getPolygonApproximation().numPoints();
    contourCount++;
    beginShape();
    stroke(map(contourCount, 1, pointsNum, 1, 100), 100, 100);
    for (int i=0; i<pointsNum; i++) {
      PVector point = contour.getPolygonApproximation().getPoints().get(i);
      vertex(point.x, point.y);
    }
    endShape();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) thresVal = constrain(thresVal+2, 1, 255);
    else if (keyCode == DOWN) thresVal = constrain(thresVal-2, 1, 255);
    else if (keyCode == LEFT) blurVal = constrain(blurVal-2, 1, 50);
    else if (keyCode == RIGHT) blurVal = constrain(blurVal+2, 1, 50);
  }
}

void captureEvent(Capture c) {
  c.read();
}
