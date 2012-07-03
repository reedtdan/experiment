
import processing.net.*;
import SimpleOpenNI.*;
Server server;
SimpleOpenNI kinect;
int gesture_number;

ArrayList<PVector> handPositions;

PVector currentHand;
PVector previousHand;

void setup() {
  //size(640, 480);
  size(400,350 * 2);
  gesture_number = 0;
  server = new Server(this, 5000);
  println("Starting a server on port 5000");
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableGesture();
  kinect.enableHands();
  
  kinect.addGesture("Wave");
  kinect.addGesture("Click");
  //kinect.addGesture("RaiseHand");
  handPositions = new ArrayList();
  
  stroke(255, 0,0);
  strokeWeight(2);
}

void draw() {
  kinect.update();
  image(kinect.depthImage(),0,0);
  image(kinect.rgbImage(), 0, 350);
  
  for (int i = 1; i < handPositions.size(); i++) {
    currentHand = handPositions.get(i);
    previousHand = handPositions.get(i-1);
    line(previousHand.x,previousHand.y,currentHand.x,currentHand.y);
  }
}

void onCreateHands(int handI, PVector position, float time) {
  kinect.convertRealWorldToProjective(position, position);
  handPositions.add(position);
}

void onUpdateHands(int handId, PVector position, float time) {
  kinect.convertRealWorldToProjective(position, position);
  handPositions.add(position);
}

void onDestroyHands(int handId, float time) {
  handPositions.clear();
  kinect.addGesture("Wave");
  kinect.addGesture("Click");
  //kinect.addGesture("RaiseHand");
}

void onRecognizeGesture(String strGesture, PVector idPosistion, PVector endPosistion)
{
  gesture_number++;
  server.write(strGesture);
  println(strGesture);
}

// The serverEvent function is called whenever a new client connects.
void serverEvent(Server server, Client client) {
  String incomingMessage = "A new client has connected:" + client.ip();
  println(incomingMessage);
}
