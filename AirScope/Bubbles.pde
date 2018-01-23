final float RADIUS_PM10 = PI*8;
final float RADIUS_PM25 = PI*4;

final int centerX = width/2;
final int centerY = height/2;

float SPEED = 0.5;
float N= 30;

float FOCAL_LENGTH = 0.5;
float BLUR_AMOUNT = 70;

int MIN_BLUR_LEVELS = 2;
int BLUR_LEVEL_COUNT = 5; //higher is better, however will be slow

ArrayList<Bubble> Bubbles;

void blurred_circle(float x, float y, float rad, float blur, color col, float levels) {
    float level_distance = BLUR_AMOUNT*(blur)/levels;
    pushMatrix();
    noStroke();
    
    for (float i = 0.0; i< levels*2; i++) {
      fill(col, 255*(levels*2-i)/(levels*2));
      
      ellipse(x, y, rad+(i-levels)*level_distance, rad+(i-levels)*level_distance);
    }
    popMatrix();
}


void dust_line(float x, float y, float len, float blur, color col, float levels, float angle){
    float level_distance = BLUR_AMOUNT*(blur)/levels;
    
    float cosX = cos(PI/angle);
    float sinY = sin(PI/angle);
    
    pushMatrix();
    stroke(col,255*level_distance);
    
    line(x, y, x-cosX*len/4, y-sinY*len/4);
    line(x, y, x+cosX*len/4, y+sinY*len/4);
      
    popMatrix();
}

void makeBubbles(){
   for (int i = 0; i< N; i++) {
          Bubbles.add(new Bubble(random(1.0f)*width, random(1.0f)*height, random(1.0f), 
                          color(random(204.0, 255.0), random(100.0, 150.0), random(0.0, 100.0)),
                                color(random(150, 230.0), random(100.0, 150.0), random(200.0, 250.0)))
                );
   }
}

void updateBubbles(){
    int size = Bubbles.size();
    int val = (int)N - size;
   
    if(val >= 0){
      for (int i = 0; i< val; i++) {
          Bubbles.add(new Bubble(random(1.0f)*width, random(1.0f)*height, random(1.0f), 
                          color(random(204.0, 255.0), random(100.0, 150.0), random(0.0, 100.0)),
                                color(random(150, 230.0), random(100.0, 150.0), random(200.0, 250.0)))); 
      }
    }else{
       int d = size + val;
      
       for(int i = size-1; i >= d; i--){
           Bubbles.remove(i);
       }
    }
}

public class Bubble{
  float loc_x, loc_y, depth;
  float radius;
  
  float moveBy_x, moveBy_y, moveBy_z;
  
  float angle, tiltBy_angle;
  
  color bubble_color;
  color dust_color;
  color shaded_color_orange;
  color shaded_color_purple;
  
  //float SPEED = 0.0008; //0.0003

  public Bubble(float loc_x, float loc_y, float depth, color bubble_color, color dust_color ){
    this.loc_x = loc_x;
    this.loc_y = loc_y;
    this.depth = depth;
    
    angle = PI/random(-4.0, 4.0);
    
    this.radius = RADIUS_PM10;
    
    this.bubble_color = bubble_color;
    this.dust_color = dust_color;
    setColor();
    
    moveBy_x = random(-1.0, 1.0);
    moveBy_y = random(-1.0, 1.0);
    moveBy_z = random(-1.0, 1.0);
    
    tiltBy_angle = random(-1.0/30, 1.0/30);
    
    float magnitude = sqrt(sq(moveBy_x) + sq(moveBy_y) + sq(moveBy_z));
    
    moveBy_x = SPEED * moveBy_x / magnitude;
    moveBy_y = SPEED * moveBy_y / magnitude;
    moveBy_z = SPEED * moveBy_z / magnitude;
  }
  
  void setColor() {
    float shade = depth;
    float shadeinv = 1.0-shade;
    
    shaded_color_orange = color( (red(bubble_color)*shade)+(red(BACKGROUND)*shadeinv),
                    (green(bubble_color)*shade)+(green(BACKGROUND)*shadeinv),
                    (blue(bubble_color)*shade)+(blue(BACKGROUND)*shadeinv));
                    
    shaded_color_purple = color( (red(dust_color)*shade)+(red(BACKGROUND)*shadeinv),
                    (green(dust_color)*shade)+(green(BACKGROUND)*shadeinv),
                    (blue(dust_color)*shade)+(blue(BACKGROUND)*shadeinv));                             
  }
  
   void update() {
     
    if (depth < 0 || depth > 1.0) {
        depth = depth % 1.0;
    }
    
    if(dustIndex == 0){
      this.radius = RADIUS_PM10;
    }else if(dustIndex == 1){
      this.radius = RADIUS_PM25;
    }
    
    loc_x += moveBy_x;
    loc_y += moveBy_y;
    
    angle += tiltBy_angle;
    
    if(loc_x < -screenMargin){   
      loc_x = width + radius*2;
      loc_y = random(0,height);
      this.depth = random(0,1);
    }else if(loc_x > width + screenMargin){
      loc_x = 0;                
      loc_y = random(0,height);
      this.depth = random(0,1);
    }
    
    if(loc_y < -screenMargin){
      loc_x = random(0,width);
      loc_y = height + radius*2;
      this.depth = random(0,1);
    }else if(loc_y > height + screenMargin){
      
      loc_x = random(0,width);
      loc_y = -radius*2;
      this.depth = random(0,1);
    }
    
    setColor();
  }
  
  void draw(float sensorX, float sensorY) {
    loc_x -= sensorX;
    loc_y -= sensorY;
    
    if(dustIndex == 0){
      
      blurred_circle(loc_x, loc_y, depth*radius, abs(depth-FOCAL_LENGTH), shaded_color_orange, MIN_BLUR_LEVELS + (depth * BLUR_LEVEL_COUNT));
      dust_line(loc_x+400, loc_y+400, radius, abs(depth-FOCAL_LENGTH), shaded_color_purple, MIN_BLUR_LEVELS + (depth*BLUR_LEVEL_COUNT), angle);
      dust_line(loc_x-400, loc_y-400, radius, abs(depth-FOCAL_LENGTH), shaded_color_purple, MIN_BLUR_LEVELS + (depth*BLUR_LEVEL_COUNT), angle);
   
    }else if(dustIndex == 1){
      
      blurred_circle(loc_x, loc_y, depth*radius, abs(depth-FOCAL_LENGTH), shaded_color_purple, MIN_BLUR_LEVELS + (depth * BLUR_LEVEL_COUNT));
      dust_line(loc_x+400, loc_y+400, radius, abs(depth-FOCAL_LENGTH), shaded_color_orange, MIN_BLUR_LEVELS + (depth*BLUR_LEVEL_COUNT), angle);    
      dust_line(loc_x-400, loc_y-400, radius, abs(depth-FOCAL_LENGTH), shaded_color_orange, MIN_BLUR_LEVELS + (depth*BLUR_LEVEL_COUNT), angle);    
 
    }
  }
}