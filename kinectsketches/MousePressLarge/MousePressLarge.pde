import processing.net.*;
import SimpleOpenNI.*;
Server server;
SimpleOpenNI kinect;
int gesture_number;

ArrayList<PVector> handPositions;

PVector currentHand;
PVector previousHand;

void setup() {
  size(1280, 800);
  background(0);
  
  gesture_number = 0;
  server = new Server(this, 5204);
  println("Starting a server on port 5204");
  kinect = newSimpleOpenNI(this);
  kinect.setMirror(true);
  
  kinect.enableGesture();
  kinect.enableHands();
  
  kinect.addGesture("RaiseHand");
  handPosistions = new ArrayList();
  
  stroke(255, 0,0);
  strokeWeight(2);
 
}

void draw() {
  if(mousePressed) {
    kinect.update();
    image(kinect.depthImage(),0,0);
  
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
  String msg = String.format("Gesture \"%s\" detected, number %d.", strGesture, gesture_number);
  server.write(msg);
  println(msg);
}

// The serverEvent function is called whenever a new client connects.
void serverEvent(Server server, Client client) {
  String incomingMessage = "A new client has connected:" + client.ip();
  println(incomingMessage);
}
