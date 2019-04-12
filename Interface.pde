
void makeVectorVisControls(ControlP5 control)
{
  // create a slider
  // parameters:

  //controlWindow = control.addControlWindow("controlP5window",500,160,160,500)
  //                   //.hideCoordinates()
  //                   .setBackground(color(40));
                     
                     
  int sliderHeight = 15;
  int sliderStep = 5;
 
  control.addSlider("scale", 0.5, 20, scale, sliderStep, sliderStep, 100, 15);//.setWindow(controlWindow);
  control.addSlider("step", 2, 20, step, sliderStep, 1 * sliderHeight + 2 * sliderStep, 100, 15);//.setWindow(controlWindow);
  control.addSlider("minVal", 0, 5, minVal, sliderStep, 2 * sliderHeight + 3 * sliderStep, 100, 15);//.setWindow(controlWindow);
  control.addSlider("weight", 0.1, 3.0, weight, sliderStep, 3 * sliderHeight + 4 * sliderStep, 100, 15);//.setWindow(controlWindow);
  control.addSlider("bgblend", 0, 255, bgblend, sliderStep, 4 * sliderHeight + 5 * sliderStep, 100, 15);//.setWindow(controlWindow);
  control.addSlider("lutHue", 0, 360, lutHue, sliderStep, 5 * sliderHeight + 6 * sliderStep, 100, 15);//.setWindow(controlWindow);
  control.addSlider("flowScale", 0.05, 5, flowScale, sliderStep, 6 * sliderHeight + 7 * sliderStep, 100, 15);//.setWindow(controlWindow);
  //sliderFrame = control.addSlider("currentFrame", 0, endIndexVec - startIndexVec + 1, currentFrame, sliderStep, 7 * sliderHeight + 8 * sliderStep, 100, 15);
  sliderFrame = control.addSlider("currentFrame", 0, endIndexImage - startIndexImage + 1, currentFrame, sliderStep, 7 * sliderHeight + 8 * sliderStep, 100, 15);
  //sliderFrame.setWindow(controlWindow);
  
  txtVectorInfo = control.addTextlabel("txtVecInfo").setText("X:0 Y:0 A:0").setPosition(width - 140, 10);
  //txtVectorInfo.setWindow(controlWindow);
  
  // create a new button with name 'buttonA'
  //control.addButton("process").setPosition(width - 50, height - 25).setSize(45,20);
  
}

void drawMask(int x, int y, int value)
{
  //println(width);
  //println(height);
  //println(controlOffsetX);
  
  println(x);
  //println(y);
  println(width -controlOffsetX - maskRadius-1);
  println("");
  
  if (x > maskRadius+1 && y > maskRadius+1 && x < imageW - maskRadius-1 && y < imageH - maskRadius-1) {
    for (int i=y-maskRadius; i<y+maskRadius; i++) {
      for (int j=x-maskRadius; j<x+maskRadius; j++) {
          vectors.masks[i][j] = value;
      }
    }
  }
  
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(controlP5.getController("step"))) {
    update = true;
  }
  if (theEvent.isFrom(controlP5.getController("currentFrame"))) {
    
    // Do not redraw content in a processing mode
    if (runProcessing)
      return;
    
    // ATTENTION! 
    //vectors.readFromFile(pathVec + prefixVec + pad(currentFrame + startIndexVec, maskSizeVec) +".txt");
    backImage = loadImage(pathImage + prefixImage + pad(currentFrame + startIndexImage, maskSizeImage) +".png");
    
  }
}

public void process(int theValue) {
  
//println("Process");
//
//println(currentFrame);
//
//if (currentFrame > endIndexVec - startIndexVec)
//  return;
//  
//runProcessing = true;
//
////int k = 5;
//
//  //for (int k = 0; k < endIndexVec - startIndexVec; k++) {
//  for (int k = 0; k < 10; k++) {
//    
//    currentFrame = k;
//    
//    sliderFrame.setValue(currentFrame);
//    
//    println(currentFrame);
//    
//     vectors.readFromFile(pathVec + prefixVec + pad(currentFrame + startIndexVec, maskSizeVec) +".txt");
//     backImage = loadImage(pathImage + prefixImage + pad(currentFrame + startIndexImage, maskSizeImage) +".png");
//     
//     redraw();
//     delay(3000);
//     
//     save(pathOutput + "result_"+ pad(currentFrame+startIndexImage, maskSizeVec) +".png");
//  }
//  
//  runProcessing = false;
  
  //currentFrame++;

}

public void load(int value) {
    
    println(value);
    
    save(pathOutput + "result_"+ pad(value+startIndexImage, maskSizeVec) +".png");
    
    //sliderFrame.setValue(value);
    
    vectors.readFromFile(pathVec + prefixVec + pad(value + startIndexVec, maskSizeVec) +".txt");
    backImage = loadImage(pathImage + prefixImage + pad(value + startIndexImage, maskSizeImage) +".png");
     
}


String pad(int value, int num)
{
  String s = str(num); 
  return String.format("%0" + s +"d", value);

}



