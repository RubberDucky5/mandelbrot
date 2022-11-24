// Mandelbrot commandline renderer

use std::time::Instant;
use std::io::Stdin;

const RES_X : i32 = 100;
const RES_Y : i32 = 50; 
const MAX_ITERATIONS: i32 = 250;


fn main() {
    let mut image = String::new();
    let now = Instant::now();

    for y in 0..RES_Y {
      for x in 0..RES_X {
        let mut a: f32 = x as f32 - RES_X as f32 / 2.0;
        a = a / RES_X as f32 * 3.0 - 0.0;
        let mut b: f32 = y as f32 - RES_Y as f32 / 2.0;
        b = b / RES_Y as f32 * 3.0;
        let mut za: f32 = a;
        let mut zb: f32 = b;

        let mut iterations: i32 = 0_i32; 
        loop {
            if iterations >= MAX_ITERATIONS || za.powf(2.0) + zb.powf(2.0) > 4.0 {
                break;
            }
            let aa: f32 = za*za - zb*zb;
            let bb: f32 = 2.0 * (za * zb);

            za = aa + a;
            zb = bb + b;
            
            iterations = iterations + 1_i32;
        }

        let i: f32 = iterations as f32;
        let mi: f32 = MAX_ITERATIONS as f32;
        match iterations {
            //MAX_ITERATIONS => image.push(ascii_ify(0.0)),
            _ => image.push(ascii_ify(i/mi)),
        }
        
      }
      image.push('\n');
    }

    println!("{}", image);
    println!("{:?}", now.elapsed());
}

fn ascii_ify (v : f32) -> char {
  let chars: &str = " .,:iwlHNW";
  let res: f32 = chars.chars().count() as f32;
  
  let i: usize = (v * res).round().clamp(0.0, res-1.0) as usize;
  let b: u8 = chars.as_bytes()[i];
  return b as char;
}
