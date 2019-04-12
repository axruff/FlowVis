// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles
 
class ParticleSystem {
 
  ArrayList particles;    // An arraylist for all the particles
  ArrayList sources;    // An arraylist for particle sources
  //PVector origin;        // An origin point for where particles are born
  boolean cycle = true;  // Particle will appear on its origin after its disappearence
 
  ParticleSystem(int num, int mode) {
    particles = new ArrayList();              // Initialize the arraylist
    sources = new ArrayList();  
    
    // Random distribution mode
    if (mode == 1)
      for (int i = 0; i < num; i++) {
        particles.add(new Particle(new PVector(random(width), random(height))));    // Add "num" amount of particles to the arraylist
      }
    else
    // Grid distribution mode
    for (int x=0; x<width; x+=num) {
      for(int y=0; y<height; y+=num) {
        particles.add(new Particle(new PVector(x,y)));    // Add a particle at this point to the arraylist
      }
    }
    
  }
 
  void run() {
    //if (frameCount%3 == 0) {  // Every second time
    //  Dots.addParticle(random(width), random(height)); // Add a new Particle every frame
   // }
   
    for (int i=0; i<sources.size(); i++) {
     Source src = (Source) sources.get(i);
     src.generate();
    }
   
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
      if (p.dead()) {
        if (cycle)
          p.reset();
        else
          particles.remove(i);
      }
    }
  }
   
  void addParticle(float x, float y) {
    particles.add(new Particle(new PVector(x,y)));
  }
 
  void addParticle(Particle p) {
    particles.add(p);
  }
  
  void addSource(float x, float y) {
    sources.add(new Source(new PVector(x,y)));
  }
 
  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
};


//---------------------------------------
// A simple Particle class
//---------------------------------------
 
class Particle {
  PVector locInit;
  PVector loc;
  PVector vel;
  float r;
  float timer;
  boolean dead;
   
  // Another constructor (the one we are using here)
  Particle(PVector origin) {
    vel = new PVector(0,0);
    locInit = origin.get();
    loc = origin.get();
    r = particleSize;
    timer = particleLifeTime;
    dead = false;
  }
  
  // Another constructor (the one we are using here)
  Particle(PVector origin, int size) {
    vel = new PVector(0,0);
    locInit = origin.get();
    loc = origin.get();
    r = size;
    timer = particleLifeTime;
    dead = false;
  }

  void run() {
    update();
    
    if (dead)
      return;
    
    //renderBubble();
    renderDot();
  }
  
  void reset()
  {
    vel = new PVector(0,0);
    loc = locInit.get();
    r = particleSize;
    timer = particleLifeTime;
    dead = false;
    
  }
   
  // Method to update location
  void update() {
    
    if (loc.x <= 0 || loc.x >= width - 1 || loc.y <= 0 || loc.y >= height - 1) {
      dead = true;
      return;
    }
    
    vel.x = vectors.data[ceil(loc.y)][ceil(loc.x)].x;
    vel.y = vectors.data[ceil(loc.y)][ceil(loc.x)].y;
    
    loc.add(vel);
    timer -= 0.5;
  }
 
  // Method to display
  void renderBubble() {
      
    ellipseMode(CENTER);
    stroke(255,200*timer/particleLifeTime);
    strokeWeight(1);
    fill(150,200*timer/particleLifeTime);
    ellipse(loc.x,loc.y,r,r);
    //displayVector(vel,loc.x,loc.y,10);
  }
  
  // Method to display
  void renderDot() {
    
    float len = sqrt(sq(vel.x)+sq(vel.y));   
    float factor = len / flowScale;
    //float factor = 1.0;
    
    colorMode(RGB);
    
    color c = convertToRGB(vel.x*factor, vel.y*factor);
    strokeWeight(2);
    stroke(c);
    
    point(loc.x,loc.y);
    
  }
   
  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
   
   void displayVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }
 
};

//---------------------------------------
// A simple Particle class
//---------------------------------------
 
class Source 
{
  PVector loc;
  float interval;
   
  // Another constructor (the one we are using here)
  Source(PVector origin) {
    loc = origin.get();
    //r = particleSize;
    //timer = particleLifeTime;
  }
  
  // Method to display
  void render() {
      
    ellipseMode(CENTER);
    stroke(255,255);
    strokeWeight(1);
    fill(150,255);
    ellipse(loc.x,loc.y,10,10);
    //displayVector(vel,loc.x,loc.y,10);
  }
  
  void generate()
  {
    if (frameCount%5 == 0)
      particles.addParticle(new Particle(loc, 5)); 
     
    render(); 
  }
};
