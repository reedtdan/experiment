import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;

float lastX;
float lastY;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  background(0);
}

void draw()
{
  closestValue = 8000;
  
  kinect.update();
  
  int[] depthValues = kinect.depthMap();
  
  for(int y = 0; y < 480; y++){
    for(int x = 0; x < 640; x++){
      
      //reverse x by moving in from 
      // the right side of the image
      int reversedX = 640 - x - 1;
      
      //use reversedX to calculate the
      // array index
      int i = reversedX + y * 640;
      int currentDepthValue = depthValues[i];
      
      //only look for the closestValue within a range
      //610 (2 feet) minimum
      //1525 (5 feet) maximum
      if (currentDepthValue > 610 && currentDepthValue < 1525 && currentDepthValue < closestValue){
        
        closestValue = currentDepthValue;
        closestX = x;
        closestY = y;
      }
    }
  }
  
  float interpolatedX = lerp(lastX, closestX, 0.3f);
  float interpolatedY = lerp(lastY, closestY, 0.3f);
  
  stroke(255,0,0);
  
  //make thicker line
  strokeWeight(3);
  
  line(lastX, lastY, interpolatedX, interpolatedY);
  lastX = interpolatedX;
  lastY = interpolatedY;
  
}

void mousePressed()
{
  background(0);
}

      
