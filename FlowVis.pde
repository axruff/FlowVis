import controlP5.*;

//-----------------------------------------------
// Parameters
//-----------------------------------------------

// Visualization mode. 1 - Vectros visuaization, 2 - Tracking visualization
int visMode = 1;

//------------------------
// Vectors visualization
//------------------------

// vectors length scaling (for drawing only) 
float scale = 3.5;
// max amplitude scale for color coding 
float flowScale = 1.0;
// vector field grid step
int step = 5;
// minimum amlitude value to be displayed
float minVal = 0.0;
// stroke weight
float weight = 1.6;
// fixed length shapes (normalized), show onlz direction
boolean fixed = false;
// Masking brush radius
int maskRadius = 10;
// Background image transparency
int bgblend = 0;
// Look up table hue value
int lutHue = 30;


// masking mode: 0 - off, 1 - Erase mode, 2 - Add mask mode
int modeMasking = 0;

//------------------------
// Particles visualization
//------------------------
// masking mode: 0 - off, 1 - Erase mode, 2 - Add mask mode
int modeAddParticle = 0;
// Particle life time
float particleLifeTime = 100;
// Particle size
float particleSize = 10;
// Particle disribution parameter
int particleParam = 50;


//------------------------
// Window parameters
//------------------------
// Automatically adjust window size for the data image dimensions
int windowAdjusted = 0;
// Windows dimensions
int windowWidth = 600;
int windowHeight = 400;

int controlOffsetX = 180;
int controlOffsetY = 5;

int imageW = 0;
int imageH = 0;


//-----------------------------------------------
// Controls
//-----------------------------------------------

ControlP5 controlP5;
ControlWindow controlWindow;
Slider sliderFrame;
CheckBox checkbox;
PImage backImage;
Textlabel txtVectorInfo;
boolean update = true;
boolean updateFrame = false;
boolean runProcessing = false;

//-----------------------------------------------
// Input
//-----------------------------------------------

// Input mode. 1 - Single file, 2 - sequence using file masks
int inputMode = 1;

String pathVec = "c:\\Users\\fe0968\\Documents\\FlowVis\\data\\boom\\vec_pat\\";
String pathImage = "c:\\Users\\fe0968\\Documents\\FlowVis\\data\\boom\\image\\";
String pathMask = "c:\\Users\\fe0968\\Documents\\FlowVis\\data\\boom\\mask\\";
String pathOutput = "c:\\Users\\fe0968\\Documents\\FlowVis\\data\\boom\\output\\";

// Melting results processing
//String pathVec = "/Users/aleksejersov/data/melting/vec_txt/";
//String pathImage = "/Volumes/Transcend/DATA/melting/Input/ecap_05_520C/final_8bit_png/";
//String pathOutput = "/Volumes/Transcend/DATA/melting/Output/ecap_05_520C/2012_05_24/viz/";

// Tracking results processing
//String pathVec = "/Users/aleksejersov/data/melting/vec_txt/";
//String pathImage = "/Users/aleksejersov/mac_data/simulated/radios_png/";
//String pathOutput = "/Volumes/Transcend/DATA/melting/Output/ecap_05_520C/2012_05_24/viz/";


int startIndexVec = 0;
int endIndexVec = 77;
int maskSizeVec = 2;
String prefixVec = "vec_";

//int startIndexImage = 0;
//int endIndexImage = 698;
//int maskSizeImage = 4;
//String prefixImage = "ecap";

int startIndexImage = 0;
int endIndexImage = 77;
int maskSizeImage = 3;
String prefixImage = "frame";

int startIndexMask = 0;
int endIndexMask = 77;
int maskSizeMask = 3;
String prefixMask = "mask";

int currentFrame = 0;

//-----------------------------------------------
// Vector field parameters
//-----------------------------------------------

//VectorField vec = new VectorField(windowWidth, windowHeight);
VectorField vectors = new VectorField();
ParticleSystem particles;
// Temporal vector
PVector vec; 

PImage maskImage;

int vec_scale = 4;

//-----------------------------------------------
// Tracker parameters
//-----------------------------------------------
Tracker tracks = new Tracker();


//-----------------------------------------------
// Initialization
//-----------------------------------------------
void setup() 
{  
  setupVectors();
  //setupTracks(); 
}

void setupVectors()
{
    //frameRate(1);

  // Create GUI controls
  controlP5 = new ControlP5(this);
  
  //vec.init();
  
  // Ruberwhale example
  
  // Burst sequence
  //vectors.readFromFile(pathVec + "vec_0.txt");
  //backImage = loadImage(pathImage + "image_boom0000_scale4.png");
  //maskImage = loadImage(pathMask + "mask.png");
  
  // Embryou Neural crest cells
  //vectors.readFromFile(path + "vec_slice_0090.txt");
  //backImage = loadImage("ncc_slice_90.png");
  
  // Dancing sequence
  //vectors.readFromFile(path + "dance_vec_1.txt");
  //backImage = loadImage("dancing.png");
  
  // Simulated flow test
  //vectors.readFromFile(path + "flow_0001.txt");
  //backImage = loadImage("radio_000000.png");
  
  // Metal films test
  //vectors.readFromFile(path + "films_vec_1.txt");
  //backImage = loadImage("film.png");
  
  
  // Load vector field using masking mode
  vectors.readFromFile(pathVec + prefixVec + pad(currentFrame + startIndexVec, maskSizeVec) +".txt"); 
  // Load backround image
  backImage = loadImage(pathImage + prefixImage + pad(currentFrame + startIndexImage, maskSizeImage) +".png");
  // Load mask
  maskImage = loadImage(pathMask + prefixMask + pad(currentFrame + startIndexMask, maskSizeMask) +".png");
  
  imageW = vectors.nx;
  imageH = vectors.ny;
  
  applyMask(vectors.nx, vectors.ny);
  
  if (windowAdjusted == 1)
    size(imageW*vec_scale, imageH*vec_scale);
  else {
    size(controlOffsetX+imageW*vec_scale + 100,controlOffsetY+imageH*vec_scale + 100);
  }
  
  // Setup particles system  
  //initParticles(0);
  
  makeVectorVisControls(controlP5); 
  
  
}

void setupTracks()
{
  // Create GUI controls
  controlP5 = new ControlP5(this);
  
  step = 4;
  
  // Simulated flow test
  tracks.readFromFile(pathImage + "tracks_output.txt");
  //backImage = loadImage("radio_000000.png");
  
  // Load vector field using masking mode
  //vectors.readFromFile(pathVec + prefixVec + pad(currentFrame + startIndexVec, maskSizeVec) +".txt"); 
  
  // Load backround image
  backImage = loadImage(pathImage + prefixImage + pad(currentFrame + startIndexImage, maskSizeImage) +".png");
    
  if (windowAdjusted == 1)
    size(backImage.width, backImage.height);
  else
    size(windowWidth,windowHeight);
  
  makeVectorVisControls(controlP5);
}

void initParticles(int number)
{
  particles = new ParticleSystem(number, 1); 
}

//-----------------------------------------------
// Drawing routines
//-----------------------------------------------
void draw() 
{
  
  drawVectors();
  //drawTracks();

}

void drawVectors() 
{
  // Set Background  
  // Black Background
  background(0); 
  // Use Background image without blending
  image(backImage,controlOffsetX,controlOffsetY);
  
  //vec.scale = scale;
  vectors.stepX = step;
  vectors.stepY = step;
  
  // Show vector field
  //vectors.showFlowGrid(controlOffsetX,controlOffsetY);
  vectors.showFlowJitteredGrid(controlOffsetX,controlOffsetY, vec_scale);
  
  // Blend background image with transparency
  //tint(255, bgblend); 
  //image(backImage, 0, 0);
  //tint(255, 255);
  
  // Run particles rendering
  //particles.run();
  
  // Highlight currect flow vector
  //vectors.highlight(mouseX, mouseY);
  
  // Draw vector information  
  //drawVecInfo();
  
  
  // Handle keyboard shortcuts
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == UP) {       
 
        if (currentFrame < endIndexVec - startIndexVec) {
          println("2");
          
          load(currentFrame);
          currentFrame=currentFrame+1;
        }
     }
        
     
    }
    else {
      switch (key) {
        case ' ':         
          initParticles(particleParam);
          break;
        case 's':         
          save("result_image.png");
          break;
        case 'x':         
          runProcessing = true;
          break;
        // Experimental  
        case 'a':         // Add Particle mode
          if (modeAddParticle == 0)
            modeAddParticle = 1;
          else
            modeAddParticle = 0;     
          break;
        case 'm':         // Masking Erase mode
          if (modeMasking == 0 || modeMasking == 2) {
            modeMasking = 1;
            println("Masking: ERASE");
          }
          else {
            modeMasking = 0; 
           println("Masking: OFF"); 
          }   
          break;
      case 'n':         // Masking Add mode
          if (modeMasking == 0 || modeMasking == 1) {
            modeMasking = 2;
            println("Masking: ADD");
          }
          else {
            modeMasking = 0;
            println("Masking: OFF");  
          }   
          break;
      }
    }
 }
  
  
  if (runProcessing) {
    if ((frameCount % 120 == 0) &&  (currentFrame < endIndexVec - startIndexVec)) {
      load(currentFrame);
      currentFrame=currentFrame+1;
    }
      
  }
  
}

void applyMask(int w, int h)
{
  for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) { 
        float val = red(maskImage.get(j,i));
        
        if (val == 255.0) {
           vectors.masks[i][j] = 0; 
    
        }
        else {
          vectors.masks[i][j] = 1; 
        }      
      }
  }
  
  
  //println(red(maskImage.get(112,139)));
}

void drawTracks() 
{
  // Set Background  
  // Black Background
  //background(0); 
  // Use Background image without blending
  image(backImage,0,0);
  
  // Blend background image with transparency
  //tint(255, bgblend); 
  //image(backImage, 0, 0);
  //tint(255, 255);
  
  tracks.showTracks();
  
  
  // Handle keyboard shortcuts
//  if (keyPressed) {
//    switch (key) {
//      case ' ':         
//        initParticles(particleParam);
//        break;
//      case 's':         
//        save("result_image.png");
//        break;
//      case 'x':         
//        runProcessing = true;
//        break;
//      // Experimental  
//      case 'a':         // Add Particle mode
//        if (modeAddParticle == 0)
//          modeAddParticle = 1;
//        else
//          modeAddParticle = 0;     
//        break;
//      case 'm':         // Masking Erase mode
//        if (modeMasking == 0 || modeMasking == 2)
//          modeMasking = 1;
//        else
//          modeMasking = 0;     
//        break;
//    case 'n':         // Masking Add mode
//        if (modeMasking == 0 || modeMasking == 1)
//          modeMasking = 2;
//        else
//          modeMasking = 0;     
//        break;
//    }
//  }
  
//  if (runProcessing) {
//    if ((frameCount % 120 == 0) &&  (currentFrame < endIndexVec - startIndexVec)) {
//      load(currentFrame);
//      currentFrame=currentFrame+1;
//    }
//      
//  }
  
}

// Does not work, check why!
void drawVecInfo()
{
  vec = vectors.getVector(mouseX, mouseY);
  noStroke();
  fill(0,0,0);
  rect(width - 140, 5, 130, 17);
  txtVectorInfo.setColorBackground(255);
  txtVectorInfo.setText("X:"+nfp(vec.x, 2, 2) + " Y:"+nfp(vec.y, 2, 2) + " A:"+nf(vec.mag(), 2, 2));
  
}

//-----------------------------------------------
// Events handling
//-----------------------------------------------

void mouseClicked() {
 // if (modeAddParticle == 1)
 //   particles.addParticle(mouseX, mouseY);
 
//  particles.addSource(mouseX, mouseY);
}

void mouseDragged() {
  // Masking Erase Mode
  if(modeMasking==1 && mousePressed) { 
    //drawMask((mouseX-controlOffsetX)*vec_scale, (mouseY-controlOffsetY)*vec_scale, 1);
    drawMask(mouseX, mouseY, controlOffsetX, controlOffsetY, vec_scale, 1);
  }  
  // Masking Add Mode
  if(modeMasking==2 && mousePressed) {
    //drawMask((mouseX-controlOffsetX)*vec_scale, (mouseY-controlOffsetY)*vec_scale, 0);
    drawMask(mouseX, mouseY, controlOffsetX, controlOffsetY, vec_scale, 0);
  }
}
