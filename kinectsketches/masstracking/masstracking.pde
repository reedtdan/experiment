import SimpleOpenNI.*;
SimpleOpenNI kinect;
void setup() {
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE); 
}

void draw() {
      kinect.update();
      image(kinect.depthImage(), 0, 0);
      
      IntVector userList = new IntVector();
      kinect.getUsers(userList);
      
      for (int i=0; i<userList.size(); i++) { 
        int userID = userList.get(i);
        
        PVector position = new PVector();
        kinect.getCoM(userID, position);
        kinect.convertRealWorldToProjective(position, position);
        fill(255, 0, 0);
        textSize(40);
        text(userID, position.x, position.y);
} }
