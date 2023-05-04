import g4p_controls.*;
int n = 20;  
int padding = 0;
float framesPerSec = 25; 
String environment = "hot"; // Initial environment set: environment can only be "hot", "normal", or "cold"
                            //Press Key: A to change environment to Hot
                            //Press Key: S to change environment to Normal
                            //Press Key: D to change environment to Cold
                            //**Caution: Click on the models screen before using keys, if not done keys wont work**
int r = 1; // Change value from 1-5: Increasing will reduce conjugation process

boolean pause = false;
float HB, CB, NB, NA;
float cellSize; 

color red = color(255, 0, 0), blue = color(0, 0, 255);
color white = color(255, 255, 255), yellow = color(255, 255, 0); 
color green = color(0, 255, 0), orange = color(255,165,0), purple  = color(255,0,255);

boolean[][] BacteriaNow = new boolean[n][n], BacteriaNext = new boolean[n][n];
float [][] BacteriaFrame = new float[n][n];
int[][] BacteriaType = new int[n][n];
int [][] FfactorNow  = new int [n][n];
int [][] FfactorNext =new int [n][n];
int [][] Plasmid = new int[n][n];
int[][] frame = new int [n][n];
color[][] ColourNow = new color[n][n], ColourNext = new color[n][n];
color [][] PlasColorNow = new color[n][n];
color[][] PlasColorNext = new color [n][n];


void setup(){
  size(800, 800);
  background(0, 0, 0);
  frameRate(framesPerSec); 
  createGUI();
  cellSize = (width-2*padding)/n;
  Survival(); // Checks for initial environment set; to give survival rates to each cell
  startFirstGeneration(); // Sets all the initial starting values for the cells

}

void draw(){ 
  if (!pause){
    frameRate(framesPerSec); 
    //cellSize = (width-2*padding)/n;
    for (int i = 0; i < n; i++) {
      
      float y = padding + i*cellSize; 
      
      for (int j = 0; j < n; j++) {
        
        float x = padding + j*cellSize;
        // Statements check if the cell is alive or not & F+ or F-
          if (BacteriaNow[i][j] == true){
            if (FfactorNow[i][j] == 1){
              fill(ColourNow[i][j]);
              square(x, y, cellSize);
              fill(PlasColorNow[i][j]);
              square(x+(cellSize/4), y+(cellSize/4), cellSize/4);
          }
          
            else{
              fill(ColourNow[i][j]);
              square(x, y, cellSize);
          }
          
          }
          
          else{
            fill(white);
            square(x,y, cellSize);
          }
          
        frame[i][j]++; //Adds frame count to each individual cell after drawing them
    }
    }
    
  CheckFfactor(); //Checks for the process of conjugation
  startNextGeneration(); // Sets next frame values for the cells
  fillNextGeneration();  // Fills the next frame cells
}
}
void Survival(){
  NA = 0;
  //Set survival rates for Bacteria Types
  if (environment == "hot"){
    HB = 75;
    CB = 5; 
    NB = 20;
 }
  if (environment == "cold"){
    HB =5; 
    CB = 75;
    NB = 20;
  }
  
  if (environment == "normal"){
    HB = 13; 
    CB = 13; 
    NB = 75;
}

}

void reset(){
//boolean[][] BacteriaNow = new boolean[n][n], BacteriaNext = new boolean[n][n];
//float [][] BacteriaFrame = new float[n][n];
//int[][] BacteriaType = new int[n][n];
//int [][] FfactorNow  = new int [n][n];
//int [][] FfactorNext =new int [n][n];
//int [][] Plasmid = new int[n][n];
//int[][] frame = new int [n][n];
//color[][] ColourNow = new color[n][n], ColourNext = new color[n][n];
//color [][] PlasColorNow = new color[n][n];
//color[][] PlasColorNext = new color [n][n];
//Survival();
startFirstGeneration();

  
}
void startFirstGeneration(){
  for (int i = 0; i < n; i++) {
    
    for (int j = 0; j < n; j++) {
      
       BacteriaType[i][j] = round(random(1, 3)); // Randomly setting bacteria's type
       Plasmid[i][j] = round(random(0,1)); //Randomly setting F+(Plasmid = 1), F-(Plasmid = 0)
      //Setting Values to F+ and F- Bacteria's 
       if (Plasmid[i][j] == 1) {
         FfactorNow[i][j] = 1; 
         if (BacteriaType[i][j] == 1) 
           PlasColorNow[i][j] = blue;
         else if (BacteriaType[i][j] == 2)
           PlasColorNow[i][j] = orange;
         else if (BacteriaType[i][j] == 3)
           PlasColorNow[i][j] = purple;
       }
       
       else
         FfactorNow[i][j] = 0;
         
     //Setting Specifc Values to different bacteria types    
       if (BacteriaType[i][j] == 1) {
         BacteriaFrame[i][j] = HB;
         BacteriaNow[i][j] = true;
         ColourNow[i][j] = red; 
      }
      
       else if (BacteriaType[i][j] == 2) {
         BacteriaFrame[i][j] = NB;
         BacteriaNow[i][j] = true;
         ColourNow[i][j] = green; 
      }
      
       else if (BacteriaType[i][j] == 3) {
         BacteriaFrame[i][j] = CB;
         BacteriaNow[i][j] = true;
         ColourNow[i][j] = yellow; 
      }

    
    }
  }
  }

void startNextGeneration() {
      for (int i = 0; i < n; i++) {
        
        for (int j = 0; j < n; j++) {
          
          if (BacteriaNow[i][j]==true) {
            if (frame[i][j] >= BacteriaFrame[i][j]) { //Checks if frame count is greater than Bacterias frame life
            frame[i][j] = 0;
            BacteriaNext[i][j] = false;
            FfactorNext[i][j] = 0;
            }
            
          else{
            //Setting next F-factor values to cell that havent been alloted values
            if (FfactorNext[i][j] != 0 && FfactorNext[i][j] != 1){
              if (FfactorNow[i][j] == 0) {
                FfactorNext[i][j] = 0;
                PlasColorNext[i][j] = PlasColorNow[i][j];
                BacteriaNext[i][j] = BacteriaNow[i][j];
              }
              else{
                FfactorNext[i][j] = 1;
                PlasColorNext[i][j] = PlasColorNow[i][j];
                BacteriaNext[i][j] = BacteriaNow[i][j];
              } 
          ColourNext[i][j] = ColourNow[i][j];

          }
          }
          
          }
          
          else {
             BacteriaType[i][j] = round(random(1, 3));
             Plasmid[i][j] = round(random(0,1));
             
             if (Plasmid[i][j] == 1) {
               FfactorNext[i][j] = 1;
               if (BacteriaType[i][j] == 1)
                 PlasColorNext[i][j] = blue;
               else if (BacteriaType[i][j] == 2)
                 PlasColorNext[i][j] = orange;
               else if (BacteriaType[i][j] == 3)
                 PlasColorNext[i][j] = purple;
           }
       
             else{
               FfactorNext[i][j] = 0;
           } 

        
             if (BacteriaType[i][j] == 1) {
               BacteriaFrame[i][j] = HB;
               BacteriaNext[i][j] = true;
               ColourNext[i][j] = red; 
            }
      
             else if (BacteriaType[i][j] == 2) {
               BacteriaFrame[i][j] = NB;
               BacteriaNext[i][j] = true;
               ColourNext[i][j] = green; 
            }
      
             else if (BacteriaType[i][j] == 3) {
               BacteriaFrame[i][j] = CB;
               BacteriaNext[i][j] = true;
               ColourNext[i][j] = yellow; 
            }
    
      }
  }
  }
}
            
          
void fillNextGeneration() {
  //Updating the values for the next frame
  for (int i = 0; i < n; i++) {
     
    for (int j = 0; j < n; j++) {
     BacteriaNow[i][j] = BacteriaNext[i][j]; 
     ColourNow[i][j] = ColourNext[i][j];
     PlasColorNow[i][j] = PlasColorNext[i][j];
     FfactorNow[i][j] = FfactorNext[i][j];
    } 
   }
  }
  
void CheckFfactor() {
  for (int i = 0; i < n; i+=r) {
    for (int j = 0; j < n; j+=r) {
      
      int a = 1;
      int b = 1;
      
     if (FfactorNow[i][j] == 1) { // Checks for recipient cells if the cell is a donor
      try{
        if (BacteriaNow[i-a][j] == true && FfactorNow[i-a][j] == 0){
          FfactorNext[i-a][j] = 1;
          if (BacteriaType[i][j] == 1)
            PlasColorNext[i-a][j] = blue;
          else if(BacteriaType[i][j] == 2)
            PlasColorNext[i-a][j] = orange;
          else if (BacteriaType[i][j] == 3)
            PlasColorNext[i-a][j] = purple;     
         }
      }
     catch (IndexOutOfBoundsException e) { 
      }
      
      try{
         if (BacteriaNow[i+a][j] == true && FfactorNow[i+a][j] == 0){
           FfactorNext[i+a][j] = 1; 
           if (BacteriaType[i][j] == 1)
             PlasColorNext[i+a][j] = blue;
           else if(BacteriaType[i][j] == 2)
             PlasColorNext[i+a][j] = orange;
           else if (BacteriaType[i][j] == 3)
             PlasColorNext[i+a][j] = purple;
          }
       }
       catch (IndexOutOfBoundsException e) { 
       }
       
       try{
         if (BacteriaNow[i][j-b] == true && FfactorNow[i][j-b] == 0){
           FfactorNext[i][j-b] = 1; 
             if (BacteriaType[i][j] == 1)
               PlasColorNext[i][j-b] = blue;
             else if(BacteriaType[i][j] == 2)
               PlasColorNext[i][j-b] = orange;
             else if (BacteriaType[i][j] == 3)
               PlasColorNext[i][j-b] = purple;
           }
        }
        catch (IndexOutOfBoundsException e) { 
        }
        
        try{
          if (BacteriaNow[i][j+b] == true && FfactorNow[i][j+b] == 0){
            FfactorNext[i][j+b] = 1;
            if (BacteriaType[i][j] == 1)
              PlasColorNext[i][j+b] = blue;
            else if(BacteriaType[i][j] == 2)
              PlasColorNext[i][j+b] = orange;
            else if (BacteriaType[i][j] == 3)
              PlasColorNext[i][j+b] = purple;
          }
        }
        catch (IndexOutOfBoundsException e) { 
        }
        
  }
    }
  }
}
// Procedure to change the environment while the program is running
void keyPressed() {
  
  if (key == 'A' || key == 'a') {
    environment = "hot";  
  }
  
  else if (key == 'S' || key == 's') {
   environment = "normal"; 
  }
  
  else if (key == 'D' || key == 'd'){
    environment = "cold";
  }
  
  Survival(); // Updates the survival rates for cells 
}
