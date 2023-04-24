class Effects{
  OpenCV opencv;
  ArrayList<Contour> contours;
  ArrayList<PVector> points;
  PImage thresImg, edgesImg;
  int thresVal, blurVal;
  float volume;

  Effects(OpenCV op, int thres, int blur) {
    opencv = op;
    points = new ArrayList<PVector>();
    thresImg = createImage(op.width, op.height, RGB);
    edgesImg = createImage(op.width, op.height, RGB);
    thresVal = thres;
    blurVal = blur;
  }

  void update(Capture cap, float vol) {
    volume = vol;
    opencv.loadImage(cap);
    opencv.gray();
    opencv.blur(blurVal);
    opencv.threshold(thresVal);
  }

  void updateThreshold() {
    thresImg = opencv.getSnapshot();
  }

  void updateEdges() {
    opencv.findCannyEdges(20, 75);
    edgesImg = opencv.getSnapshot();
  }

  void updateParameters(int thres, int blur) {
    thresVal = thres;
    blurVal = blur;
  }

  void drawBlackAndWhiteImage() {
    updateThreshold();
    image(thresImg, width/2, height/2, width, height);
  }

  void drawEdgeLineImage() {
    updateEdges();
    image(edgesImg, width/2, height/2, width, height);
  }
  
  void drawEffectEdge(float effrctVal, int transX, int transY, int transW, int transH) {
    contours = opencv.findContours();
    pushMatrix();
    translate(transX, transY);
    pushStyle();
    noFill();
    strokeWeight(3);
    for (Contour contour : contours) {
      int pointsNum = contour.getPolygonApproximation().numPoints();
      beginShape();
      stroke(255);
      for (int i=0; i<pointsNum; i++) {
        PVector point = contour.getPolygonApproximation().getPoints().get(i);
        float angle = 360/pointsNum *i;
        float fftX = (effrctVal*100) * cos(radians(angle));
        float fftY = (effrctVal*100) * sin(radians(angle));
        float mx = map(point.x, 0, op.width, 0, transW);
        float my = map(point.y, 0, op.height, 0, transH);
        //vertex(point.x+fftX, point.y+fftY);
        vertex(mx+fftX, my+fftY);
      }
      endShape();
    }
    popStyle();
    popMatrix();
  }
  
  void drawEffectEdgeInage(){
    opencv.findCannyEdges(20, 75);
    drawEffectEdge(volume, 0, 0, width, height);
  }

  void drawImageSettings() {
    updateThreshold();
    updateEdges();
    image(thresImg, width/2+width/2/2, height/2/2, width/2, height/2);
    image(edgesImg, width/2/2, height/2+height/2/2, width/2, height/2);
    drawEffectEdge(volume, width/2, height/2, width/2, height/2);
  }
}
