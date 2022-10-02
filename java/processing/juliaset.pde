// Kinda Slow

// Controls
// Mouse Move:        Change "C" value of Set
// L:                 Lock the C value
// Mouse Drag:        Move Around
// Scroll Wheel:      Zoom
// Middle Mouse Drag: Increase Iterations
// Right Mouse Drag:  Offset Colors
// S:                 Save What is on screen to a png file

int maxIterations = 50;
float minRangeX = -2.5;
float maxRangeX = 2.5;
float minRangeY = -2.5;
float maxRangeY = 2.5;

float scale = 1;

float hueShift = 0;

float juliaX;
float juliaY;

boolean lock = false;

void setup() {
  size(1080, 1080);
  //surface.setResizable(true);
}

void draw(){
  if(scale > 1){
    minRangeX = -2.5;
    maxRangeX = 2.5;
    minRangeY = -2.5;
    maxRangeY = 2.5;
    scale = 1;
  }
  if(!lock){
    juliaX = map(mouseX, 0, width, minRangeX, maxRangeX);
    juliaY = map(mouseY, 0, height, minRangeY, maxRangeY);
  }
  
  background(0, 0, 0);
  drawMandel();
  
  //noLoop();
}

void drawMandel () {
  loadPixels();
  
  colorMode(HSB);
  for(int ind = 0; ind < pixels.length; ind += 1){
    int y = floor(ind / width);
    int x = ind - (y * width);
    
    float a = map(x, 0, width, minRangeX, maxRangeX);
    float b = map(y, 0, height, minRangeY, maxRangeY);
     
    float aa = a;
    float bb = b;
    
    float za = a;
    float zb = b;
    
    int iterations = 0;
    while(iterations < maxIterations ){
      aa = za*za - zb*zb;
      bb = 2 * (za*zb);
      
      za = aa + juliaX;
      zb = bb + juliaY;
      
      if(za*za + zb*zb > 16){
        break;
      }
      
      iterations++;
    }
    float smoothIter = maxIterations;
    if(iterations < maxIterations){
      float logz = log(za*za + zb*zb);
      float n = log(logz / log(2))/ log(2);
      
      smoothIter = iterations + 1.0 - n;
    }
    
    float hue = float(floor(smoothIter)) / maxIterations * 255;
    float color2 = float(floor(smoothIter) + 1) / maxIterations * 255;
    
    hue = lerp(hue, color2, fract(smoothIter));
    hue += hueShift;

    color c = color(hue, 255, 255);
    
    if(iterations != maxIterations)
      pixels[ind] = c;
  }
  
  updatePixels();
}

void mouseDragged() {
  if(mouseButton == LEFT){
    minRangeX -= map(mouseX - pmouseX, -width, width, -1, 1) * scale;
    maxRangeX -= map(mouseX - pmouseX, -width, width, -1, 1) * scale;
    minRangeY -= map(mouseY - pmouseY, -height, height, -1, 1) * scale;
    maxRangeY -= map(mouseY - pmouseY, -height, height, -1, 1) * scale;
  }
  else if(mouseButton == RIGHT) {
    hueShift -= map(mouseX - pmouseX, -width, width, -255, 255);
  }
  else {
    maxIterations += ceil(float( mouseX - pmouseX ) / 1);
    maxIterations = constrain(maxIterations, 4, 1000);
  }
}

void mouseWheel(MouseEvent e){
  int dir = e.getCount();
  
  float s = 0;
  
  if(dir == -1)
    s = 0.5;
  else 
    s = 2;
    
   float avgX = (maxRangeX + minRangeX) / 2;
   float avgY = (maxRangeY + minRangeY) / 2;
   
   maxRangeX -= avgX;
   minRangeX -= avgX;
   maxRangeY -= avgY;
   minRangeY -= avgY;
   maxRangeX*= s;
   minRangeX*= s;
   maxRangeY*= s;
   minRangeY*= s;
   
   scale *= s;
   
   maxRangeX += avgX;
   minRangeX += avgX;
   maxRangeY += avgY;
   minRangeY += avgY;
}

void keyPressed(){
  if(key == 's')
    saveFrame("juliaset-" + year() + "-" + month() + "-" + day() + "_" + hour() + "h" + minute() + "m" + second() + ".png");
  if(key == 'l')
    lock = !lock;
}

float fract(float n){
  return n - floor(n);
}
