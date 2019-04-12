class Tracker 
{ 
  ArrayList tracks;    // An arraylist for tracks
  
  int tracksCount; // Number of tracks
  int timeSteps; // Number of time frames
  
  Tracker()
  {
    tracks = new ArrayList(); 
    this.tracksCount = 0;
    this.timeSteps = 0;
    
  }
  
  // Read tracks from the text file
  void readFromFile(String fileName)
  {
   
    String lines[] = loadStrings(fileName);
    
    println("Hi!");
    
    int trackColumn = 2;
    int timeColumn = 3;
    
    // Determine number of track and time steps by finding a max value from corresponding fields
    for(int i = 0; i < lines.length ; i++) {
      int trackNum = int(lines[i].split("\t")[trackColumn]);
      int timeNum = int(lines[i].split("\t")[timeColumn]);
      
      if (trackNum > tracksCount)
        tracksCount = trackNum;
        
      if (timeNum > timeSteps)
        timeSteps = timeNum;    
    }
    
    println("Tracks: " + str(tracksCount));
    println("Time steps: " + str(timeSteps));
 
    for (int i = 0; i < tracksCount ; i++) {
      
      Track track = new Track();
      
      for (int j = 0; j < timeSteps; j++) {
        String t[] = lines[i*timeSteps + j].split("\t");
        
        float x = float(t[4]);
        float y = float(t[5]);
        
        track.AddPoint(x, y);             
      }	
      
      tracks.add(track);		
    } 
     
  }
  
  PVector GetPoint(int trackNum, int stepNum)
  {
    Track t = (Track)tracks.get(trackNum);   
    return (PVector)t.GetPoint(stepNum);
  }
  
  void showTracks()
  {
    
    smooth();
    
    for (int i = 0; i < tracksCount ; i++) {
      
      for (int j = 0; j < currentFrame; j=j+step) {
        
        //(Track)tracks.get(i).GetPoint(j).x;
        
        float x = GetPoint(i,j).x;
        float y = GetPoint(i,j).y;
        
//        ellipseMode(CENTER);
//        fill(150,200);
//        ellipse(x, y, scale, scale);
        
        
        float len = sqrt(sq(x)+sq(y));   
        //float factor = len / flowScale;
        float factor = 1.0;
    
        //colorMode(RGB);
        
        noStroke();
        
        colorMode(HSB, 100, 100, 100);
        
        fill(color(100 * j / timeSteps, 100, 100));
    
    
        ellipse(x, y, scale, scale);
   
      }
       
    }    
  }
  
  // Method to display
//  void renderBubble() {
//      
//    ellipseMode(CENTER);
//    stroke(255,200*timer/particleLifeTime);
//    strokeWeight(1);
//    fill(150,200*timer/particleLifeTime);
//    ellipse(loc.x,loc.y,r,r);
//    //displayVector(vel,loc.x,loc.y,10);
//  }
  
}

class Track
{
  ArrayList positions;    // An arraylist for track positions
  int timeSteps; // Number of time frames in the current track
  
  Track()
  {
    timeSteps = 0;
    positions = new ArrayList();   
  }
  
  void AddPoint(float x, float y)
  {
    positions.add(new PVector(x, y));
    timeSteps++;
  }
  
  PVector GetPoint(int pos)
  {
    return (PVector)positions.get(pos);
  }
  
}
