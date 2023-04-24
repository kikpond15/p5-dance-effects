import processing.sound.*;
import processing.video.*;
import gab.opencv.*;
import controlP5.*;

AudioIn in;
Amplitude amp;
Waveform waveform;
Capture cp;
OpenCV op;
ControlP5 gui;
ControlFont font;
Group guiGroup;
Effects effects;
int preview_index = 0;
boolean isGuiShow = true;

void setup() {
  size(640*2, 480*2);
  surface.setResizable(true);
  imageMode(CENTER);
  float fontSize = 15;
  font = new ControlFont(createFont("Osaka-Mono-48", fontSize));
  setupGui();
  String[] cameras = Capture.list();
  cp = new Capture(this, 640, 480, cameras[0]);
  //cp = new Capture(this, 1280, 720, cameras[0]);
  op = new OpenCV(this, cp.width, cp.height);
  in = new AudioIn(this);
  amp = new Amplitude(this);
  cp.start();
  in.start();
  amp.input(in);
  effects = new Effects(op, int(gui.getController("Threshold").getValue()), int(gui.getController("Blur").getValue())) ;
}


void draw() {
  background(0);
  if (cp.available()) {
    cp.read();
  }
  effects.update(cp, amp.analyze());

  switch(preview_index) {
  case 0:
    image(cp, width/2/2, height/2/2, width/2, height/2);
    effects.drawImageSettings();
    break;
  case 1:
    image(cp, width/2, height/2, width, height);
    break;
  case 2:
    effects.drawBlackAndWhiteImage();
    break;
  case 3:
    effects.drawEdgeLineImage();
    break;
  case 4:
    effects.drawEffectEdgeInage();
    break;
  case 5:
    break;
  }
}


void keyPressed() {
  switch(key) {
  case '0':
    preview_index = 0;
    break;
  case '1':
    preview_index = 1;
    break;
  case '2':
    preview_index = 2;
    break;
  case '3':
    preview_index = 3;
    break;
  case '4':
    preview_index = 4;
    break;
  case '5':
    preview_index = 5;
    break;
  }

  if (key == 'm') {
    if (isGuiShow) {
      isGuiShow = false;
      guiGroup.hide();
    } else {
      isGuiShow = true;
      guiGroup.show();
    }
  }
}

void setupGui() {
  gui= new ControlP5(this);
  fill(0);
  guiGroup = gui.addGroup("Menu")
    .setPosition(5, 15)
    .setWidth(400)
    .setBackgroundHeight(100)
    .activateEvent(true)
    .setBackgroundColor(color(255, 180))
    .setLabel("Menu")
    ;

  gui.addSlider("Threshold")
    .setGroup(guiGroup)
    .setPosition(3, 10)
    .setSize(180, 20)
    .setRange(0, 255)
    .setValue(100)
    .setNumberOfTickMarks(256)
    .setColorLabel(0)
    .snapToTickMarks(true)
    .setFont(font)
    ;

  gui.addSlider("Blur")
    .setGroup(guiGroup)
    .setPosition(3, 40)
    .setSize(180, 20)
    .setRange(1, 100)
    .setValue(10)
    .setNumberOfTickMarks(100)
    .setColorLabel(0)
    .snapToTickMarks(true)
    //.getCaptionLabel()
    .setFont(font)
    ;
   
    //guiGroup.addTextlabel("myLabel", "This is my label!", 0, 0, 100, 20);
   gui.addTextlabel("myText")
   .setText("[0~4]:change image,  [m]:show/hide menu")
   .setGroup(guiGroup)
   .setPosition(3, 80)
   .setColorValue(0)
   .setFont(font)
   ;
}


void controlEvent(ControlEvent event) {
  if (event.isFrom("Threshold")) {
    effects.thresVal = int(gui.getController("Threshold").getValue());
  } else if (event.isFrom("Blur")) {
    effects.blurVal = int(gui.getController("Blur").getValue());
  }
}
