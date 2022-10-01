let maxIterations = 50;

function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(220);
  
  for(let x = 0; x < width; x++){
    for(let y = 0; y < height; y++){
      
      let i = 0;
      
      let a = map(x, 0, width, -2.5, 1);
      let b = map(y, 0, height, -1.5, 1.5);
      
      let aa = a;
      let bb = b;
      
      let za = a;
      let zb = b;
      
      while (i < maxIterations){
        
        aa = za*za - zb*zb;
        bb = 2 * (za * zb);
        
        za = aa + a;
        zb = bb + b;
        
        if(abs(za*za + zb*zb) > 4){
          break;
        }
        
        i++;
      }
      colorMode(HSB)
      let c = color(i / maxIterations * 255, 255, 255)
      
      if (i == maxIterations) c = color(0,0,0);
      
      set(x, y, c);
    }
  }
  updatePixels();
  
  noLoop();
}
