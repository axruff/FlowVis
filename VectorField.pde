
class VectorField 
{ 
  
  PVector[][] data;
  int[][] masks;
  PVector[][] grid;
  
  // dimensions
  int nx;
  int ny;
  
  // grid nodes step
  int stepX = 10;
  int stepY = 10;
  
  // current grid coordinates
  int i;
  int j;
  
  VectorField()
  {
    this.nx = 0;
    this.ny = 0;
    
  }
  
  VectorField(int nx, int ny)
  {
    this.nx = nx;
    this.ny = ny;
    
    data = new PVector[ny][nx];
    
  }
  
  // Read vector field from the text file
  void readFromFile(String fileName)
  {
   
    String lines[] = loadStrings(fileName);
    
    int NY = int(lines[0]);
    int NX = int(lines[1]);
    float n1 = float(lines[6]);
    float n2 = float(lines[7]);
    
    this.nx = NX;
    this.ny = NY;
      
    //println(NX);
    //println(NY);
    
//    if (!((NX > 0) && (NY > 0)))
//	return NULL;
//   
    data = new PVector[NY][NX];
    masks = new int[NY][NX];
    
    // Dimensions offset
    int offsset = 2;
 
    for (int i = 0; i < NY ; i++) {
      for (int j = 0; j < NX; j++) {          
        data[i][j] = new PVector(float(lines[offsset + i*2*NX + 2*j]), float(lines[offsset + i*2*NX + 2*j+1]));
        masks[i][j] = 0;
      }			
    } 
    
    updateGrid();
  
  }
  
  // Init custom vector field
  void init()
  {
    
    // Initialize 2D array values
    for (int i = 0; i < ny; i++) {
      for (int j = 0; j < nx; j++) {
        data[i][j] = new PVector(0, 0);
      }
    }
    

   int w2 = 120;
    
    for (int i = ny/2 - w2/2  ; i < ny/2 + w2/2; i++) {
      for (int j = nx/4 - w2/2  ; j < nx/2 + w2/2; j++) {
        data[i][j] = new PVector(5, 5);
      }
    }

   int w = 80;
    
    for (int i = ny/2 - w/2  ; i < ny/2 + w/2; i++) {
      for (int j = nx/2 - w  ; j < nx/2 + w; j++) {
        data[i][j] = new PVector(-3, 3);
      }
    }    
  }
  
  PVector getVector(int x, int y)
  {
     // Check boundaries
    if (!(x > 0 && y > 0 && x < width && y < height))
      return new PVector(0, 0);
      
    return data[y][x];
  }
  
  void showFlowGrid(int offsetX, int offsetY) {
    // draw each arrow from center of each field "unit"
    smooth();
    
    for (i=stepY; i<ny; i=i+stepY)
      for (j=stepX; j<nx; j=j+stepX) {
        
        if (data[i][j].mag() < minVal || masks[i][j] == 1)
          continue;
        
        pushMatrix();
        translate(j+offsetX, i+offsetY);
        
        if (fixed)
          data[i][j].normalize();

        arrow(data[i][j].x,data[i][j].y);
        //segment(data[i][j].x,data[i][j].y);
        //flowline2(data[i][j].x,data[i][j].y);
        
        
        popMatrix();
      }
  }
  
  void updateGrid()
  {
    grid = new PVector[(int)ny/stepY][(int)nx/stepX];
    
    //println((int)ny/stepY);
    //println((int)nx/stepX);
    
    for (int i=0; i<(int)ny/stepY; i++) {
      for (int j=0; j<(int)nx/stepX; j++) {
        
        int dx = (int)random(-stepX/3, stepX/3);
        int dy = (int)random(-stepY/3, stepY/3);
        
        grid[i][j] = new PVector(stepX/2 + j*stepX + dx, stepY/2 + i*stepY + dy);
        
      }
    }
  }
 
  
  
   void showFlowJitteredGrid(int offsetX, int offsetY, int scale) {
     
    if (update) {
      updateGrid();
      update = false;
    }
     
    // draw each arrow from center of each field "unit"
    smooth();
    
    for (int n=0; n<(int)ny/stepY; n++) {
      for (int m=0; m<(int)nx/stepX; m++) {
        
        i = (int)grid[n][m].y;
        j = (int)grid[n][m].x;
        
        //println(i);
       // println(j);
        

        if (data[i][j].mag() < minVal || masks[i][j] == 1)
          continue;
        
        pushMatrix();
        translate(j*scale+offsetX, i*scale+offsetY);
        
        if (fixed)
          data[i][j].normalize();

        arrow(data[i][j].x*scale,data[i][j].y*scale);
        //segment(data[i][j].x,data[i][j].y);
        //flowline2(data[i][j].x,data[i][j].y);
        
        
        popMatrix();
      }
    }
  } 
  
  void highlight(int x, int y) {
    
    int r = 2;
    
    // Check boundaries
    if (!(x > r && y > r && x < width - r && y < height - r))
      return;
    
    int xc = x + (int)random(-r, r);
    int yc = y + (int)random(-r, r);
    
    smooth();
     
    pushMatrix();
    translate(xc, yc);
    
    float scaleChange = 5.0;
    float strokeChange = 3.0;
    
    // Change stroke and scale values to interactively highlight current vector
    scale = scale * scaleChange;
    weight = weight * strokeChange;
    
    arrow(data[yc][xc].x,data[yc][xc].y);
    //segment(data[yc][xc].x,data[yc][xc].y);
    
    // Change stroke and scale values back
    scale = scale / scaleChange;
    weight = weight / strokeChange;
    
    popMatrix();
  }
  
  void arrow(float x, float y) {
    // draws a simple arrow (assumes a translated origin)  
    strokeWeight(weight);
    
    float len = sqrt(sq(x)+sq(y));   
    float factor = len / flowScale;
    //float factor = 1.0;
    
    color c = convertToRGB(x*factor, y*factor);
    stroke(c);
    
    float arrowLen = len * 0.3*scale;
    line(0,0, x*scale,y*scale);
    pushMatrix();
    translate(x*scale, y*scale);
    rotate(atan2(y, x));
    line (0,0, -arrowLen, arrowLen * 0.35);
    line (0,0, -arrowLen, arrowLen * -0.35);
    popMatrix();
  }
  
  void segment(float x, float y) 
  {
    float maxWeight = 4.0;
    
    float len = sqrt(sq(x)+sq(y));   
    float factor = len / flowScale;
    
    // Stroke weight, adjusted to amplitude
    //float weightScale = sqrt(sq(x)+sq(y)) / maxWeight;
    float weightScale = 1; // Fixed stroke weight
    
    // draws a simple arrow (assumes a translated origin)
    strokeWeight(weight*4.0*weightScale);
    
    // Color codes
    color c = convertToRGB(x*factor, y*factor);
    //color c = makeLUT(x, y);
    
    stroke(c);
    
    line(0,0, x*scale,y*scale);
  }
  
  // EXPERIMENTAL
  void flowline(int ix, int iy, float x, float y) 
  {
    float maxWeight = 4.0;
    
    int dx = 0;
    int dy = 0;
    
    //color c = convertToRGB(x, y);
    strokeWeight(weight*4.0);   
    //stroke(c);
    
    beginShape();
    
    curveVertex(0,  0);
    curveVertex(0,  0);
    
    int curvePoints = 3;
      
    for (int k=0; k<curvePoints; k++) {
    
    float len = sqrt(sq(x)+sq(y));   
    float factor = len / flowScale;
    
    // Adjusted to amplitude
    //float weightScale = sqrt(sq(x)+sq(y)) / maxWeight;
    //float weightScale = 1; // Fixed stroke weight
    
    //strokeWeight(weight*4.0*weightScale);
   
    // Color codes
    color c = convertToRGB(x*factor, y*factor);
    //color c = makeLUT(x, y);
    
    stroke(c);
    
    //line(0,0, x*scale,y*scale);
    
    curveVertex(dx + x*scale, dy + y*scale);
    
    if (k==curvePoints-1)
      curveVertex(dx + x*scale, dy +  y*scale);
    
    dx = floor(dx + x*scale);
    dy = floor(dy + y*scale);
    
    if (ix+dx < 0 || iy+dy < 0 || ix+dx >= nx || iy+dy >= ny - 1)
      continue;
    
    x = data[iy+dy][ix+dx].x;
    y = data[iy+dy][ix+dx].y;
    
    }
       
    endShape();
    
  }
  
  // // EXPERIMENTAL:  Draw a flowline. ix, iy - specifies current grid locations, x, y - vector components 
  void flowline2(float x, float y) 
  {
    float maxWeight = 4.0;
    
    float len;
    float factor;
    float weightScale;
    color c;
    
    float dx = 0;
    float dy = 0;
    
    len = sqrt(sq(x)+sq(y));   
    factor = len / flowScale;
    
    // Adjusted to amplitude
    //float weightScale = sqrt(sq(x)+sq(y)) / maxWeight;
    weightScale = 1; // Fixed stroke weight
    
    strokeWeight(weight*4.0*weightScale);
    
    // Color codes
    c = convertToRGB(x*factor, y*factor);
    //color c = makeLUT(x, y);
    stroke(c);
    
    if (j+x*scale < 0 || i+y*scale < 0 || j+x*scale >= nx || i+y*scale >= ny - 1)
      return;
    
    dx = data[floor(i+y*scale)][floor(j+x*scale)].x;
    dy = data[floor(i+y*scale)][floor(j+x*scale)].y;
    
    //line(0,0, x*scale,y*scale);
    //curve(0, 0, 0, 0, x*scale, y*scale, (x+dx)*scale, (y+dy)*scale);
   
    bezier(0, 0, x*scale, y*scale, x*scale, y*scale, (x+dx)*scale, (y+dy)*scale);  
    
    // ---------- 2 ------------
    
//    len = sqrt(sq(dx)+sq(dy));   
//    factor = len / flowScale;
//    
//    // Adjusted to amplitude
//    //float weightScale = sqrt(sq(x)+sq(y)) / maxWeight;
//    weightScale = 1; // Fixed stroke weight
//    
//    strokeWeight(weight*4.0*weightScale);
//    
//    // Color codes
//    c = convertToRGB(dx*factor, dy*factor);
//    //color c = makeLUT(x, y);
//    stroke(c);
//    
//    //line(x*scale,y*scale, (x+dx)*scale, (y+dy)*scale);
//    
//    float x2 = x+dx;
//    float y2 = y+dy;
//    
//    if (j+x2*scale < 0 || i+y2*scale < 0 || j+x2*scale >= nx || i+y2*scale >= ny - 1)
//      return;
//    
//    dx = data[floor(i+y2*scale)][floor(j+x2*scale)].x;
//    dy = data[floor(i+y2*scale)][floor(j+x2*scale)].y;
//        
//    bezier(x*scale, y*scale, (x+dx)*scale, (y+dy)*scale, (x+dx)*scale, (y+dy)*scale, (x2+dx)*scale, (y2+dy)*scale );
    
   
    
    
  
     
    
  }
     
  
};

