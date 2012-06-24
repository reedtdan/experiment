import SimpleOpenNI.*;
SimpleOpenNI  kinect;
void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  background(225);
  size(640, 480);
  fill(255, 0, 0);
  strokeWeight(5);
  textSize(20);
}
void draw() {
  kinect.update();
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    if ( kinect.isTrackingSkeleton(userId)) {
      PVector leftHand = new PVector();
      PVector rightHand = new PVector();
      kinect.getJointPositionSkeleton(userId,
                                      SimpleOpenNI.SKEL_LEFT_HAND,
                                      leftHand);
      kinect.getJointPositionSkeleton(userId,
                                      SimpleOpenNI.SKEL_RIGHT_HAND,
                                      rightHand);
     PVector differenceVector = PVector.sub(leftHand, rightHand);
     float magnitude = differenceVector.mag();
     differenceVector.normalize();
     stroke(differenceVector.x * 255,
            differenceVector.y * 255,
            differenceVector.z * 255);
     strokeWeight(map(magnitude, 100, 1200, 1, 8));
     kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HAND,
                     SimpleOpenNI.SKEL_RIGHT_HAND);
     
      pushMatrix(); 
      fill(abs(differenceVector.x) * 255, abs(differenceVector.y) * 255, abs(differenceVector.z) * 255);
      text("m: " + magnitude, 10, 50); 
      popMatrix();
    }
  } 
}

// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}
void onEndCalibration(int userId, boolean successful) {
  if (successful) {
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  }
  else {
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
      println("Started pose for user");
      kinect.stopPoseDetection(userId);
      kinect.requestCalibrationSkeleton(userId, true);
}
