// Mandelbrot png image maker using png_encode_mini
// This program writes to out.png, and will overwrite anything in that file
// Jame 11/30/22

extern crate png_encode_mini;
use std::fs::File;

const SIZE: i32 = 512;
const MAX_ITER: i32 = 1000;

fn mandelbrot(size_x: f32, size_y: f32) -> Vec<u8> {
  let image_size: usize = (size_x * size_y) as usize;
  let mut image = Vec::with_capacity(image_size * 4);

  for y in 0..size_x as usize {
    for x in 0..size_y as usize {
      let a = (x as f32 / size_x - 0.75) * 2.1;
      let b = (y as f32 / size_y - 0.5) * 2.1;
      let mut za = a;
      let mut zb = b;

      let mut i: i32 = 0;
      loop {
        if za*za + zb*zb > 4.0 || i >= MAX_ITER { break; }
        let aa = za*za - zb*zb;
        let bb = 2.0*za*zb;
        za = aa + a;
        zb = bb + b;

        i+=1;
      }
      if i >= MAX_ITER {
        image.append(&mut vec![0_u8, 0_u8, 0_u8, 255_u8]);
      }
      else {
        let _col: u8 = (i as f32 / MAX_ITER as f32 * 255.0) as u8;
        image.append(&mut grad((i as f32 % 100.0 ) / 100.0));
      }
    }
  }
  
  return image;
}

fn main() {
    let mut file = File::create("out.png").unwrap();
    let image: &[u8] = &mandelbrot(SIZE as f32, SIZE as f32) as &[u8];
    match png_encode_mini::write_rgba_from_u8(&mut file, &image[..], SIZE as u32, SIZE as u32) {
        Ok(_) => {},
        Err(e) => {println!("Error at image write: {:?}", e)}
    };
}

fn grad (v : f32) -> Vec<u8>{
  assert_eq!(v <= 1.0, true);
  assert_eq!(v >= 0.0, true);
  let palette : [Vec<f32>; 5] = [
                  vec!(  0.0,   7.0, 100.0),
                  vec!( 32.0, 107.0, 203.0),
                  vec!(237.0, 255.0, 255.0),
                  vec!(255.0, 170.0,   0.0),
                  vec!(  0.0,   2.0,   0.0)
  ];
  let pl: usize = palette.len() - 1;
  let mp: f32  = v * pl as f32;
  
  let start : Vec<f32> = palette[mp.floor() as usize].to_vec();
  let end : Vec<f32> = palette[mp.ceil() as usize].to_vec();
  let start_min : f32 = mp.floor() as f32 / pl as f32;
  let end_max : f32 =   mp.ceil()  as f32 / pl as f32;

  let new_v = map(v, start_min, end_max, 0.0, 1.0);
  let v_vec = vec![new_v, new_v, new_v];

  // Lerp Algorithm
  let diff = add(mul(sub(end, start.to_vec()), v_vec), start);
  
  return vec!(diff[0] as u8, diff[1] as u8, diff[2] as u8, 255);
}

// Ripped straight from p5.js
// (n - start1) / (stop1 - start1) * (stop2 - start2) + start2
fn map (v : f32, start1 : f32, stop1 : f32, start2 : f32, stop2 : f32) -> f32 {
  if stop1 - start1 == 0.0 {
    return (v - start1) / 0.01 * (stop2 - start2) + start2;
  }
  return (v - start1) / (stop1 - start1) * (stop2 - start2) + start2;
}

fn sub(v1 : Vec<f32>, v2 : Vec<f32>) -> Vec<f32> {
  assert_eq!(v1.len(), v2.len());
  let ret = (0..v1.len()).map(|i| (v1[i] - v2[i])).collect();
  return ret
}

fn mul (v1 : Vec<f32>, v2 : Vec<f32>) -> Vec<f32> {
  assert_eq!(v1.len(), v2.len());
  let ret = (0..v1.len()).map(|i| v1[i] * v2[i]).collect();
  return ret
}

fn add(v1 : Vec<f32>, v2 : Vec<f32>) -> Vec<f32> {
  assert_eq!(v1.len(), v2.len());
  let ret = (0..v1.len()).map(|i| v1[i] + v2[i]).collect();
  return ret
}