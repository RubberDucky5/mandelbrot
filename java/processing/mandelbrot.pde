// This is Fairly Slow

// Controls
// Mouse Drag:        Move Around
// Scroll Wheel:      Zoom
// Middle Mouse Drag: Increase Iterations
// Right Mouse Drag:  Offset Colors

int maxIterations = 50;
float minRangeX = -2.1;
float maxRangeX = 0.9;
float minRangeY = -1.5;
float maxRangeY = 1.5;

float scale = 1;

float hueShift = 0;

void setup() {
  size(1080, 1080);
  //surface.setResizable(true);
}

void draw(){
  if(scale >= 2){
    minRangeX = -2.1;
    maxRangeX = 0.9;
    minRangeY = -1.5;
    maxRangeY = 1.5;
    scale = 1;
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
    
    float za = 0;
    float zb = 0;
    
    int iterations = 0;
    while(iterations < maxIterations ){
      aa = za*za - zb*zb;
      bb = 2 * (za*zb);
      
      za = aa + a;
      zb = bb + b;
      
      if(za*za + zb*zb  > 16){
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
    
    float hue = float(floor(smoothIter) + int(hueShift)) % 255;
    float color2 = float(floor(smoothIter) + 1 + int(hueShift)) % 255;
    
    hue = lerp(hue, color2, fract(smoothIter));
  
    color c = palette(hue);
    
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
  saveFrame("mandelbrot-" + year() + "-" + month() + "-" + day() + "_" + hour() + "h" + minute() + "m" + second() + ".png");
}

float fract(float n){
  return n - floor(n);
}

color palette(float n){
  colorMode(HSB);
  return color(n, 255, 255);
  
  //return color(0.5 + 0.5*cos(n + 1.));
}
