import org.sqlite.*;
import processing.io.*;
import lord_of_galaxy.timing_utils.*;

Stopwatch stopWatch;

final int GPIO_BUTTON_A = 22;
final int GPIO_BUTTON_B = 23;

final int GPIO_ROTATE_A = 18;
final int GPIO_ROTATE_B = 17;

void initSensor(){
    mpu_6050 = new I2C(I2C.list()[0]);
    
    //accelData =new float[3];
    gyroData = new float[3];
    errorGyroData = new float[3];
    //errorAccelData = new float[3];
    
    //init_Data(mpu_6050,errorAccelData,true);
    init_Data(mpu_6050,errorGyroData,false);
    
    
    GPIO.pinMode(GPIO_BUTTON_A, GPIO.INPUT);
    GPIO.pinMode(GPIO_BUTTON_B, GPIO.INPUT);    
    GPIO.attachInterrupt(GPIO_BUTTON_A, this, "buttonClick", GPIO.FALLING); 
    GPIO.attachInterrupt(GPIO_BUTTON_B, this, "buttonRelease", GPIO.RISING); 
    
    GPIO.pinMode(GPIO_ROTATE_A, GPIO.INPUT);
    GPIO.pinMode(GPIO_ROTATE_B, GPIO.INPUT);    
    GPIO.attachInterrupt(GPIO_ROTATE_A, this, "zoomEvent", GPIO.RISING); 
}

void initSketch(){
   smooth();
   noStroke();
      
   font = loadFont("Comfortaa-Bold-20.vlw");
   helveFont = createFont("HELR45W.ttf",10);
   
   textFont(font);
}

AbstractMapProvider provider1;
AbstractMapProvider provider2;
AbstractMapProvider provider3;

ArrayList<AbstractMapProvider> mapProviders;
void initMap(){
  //String tilesStr = sketchPath("data/AirSimpleMap3.mbtiles");
   String tilesStr;
   
   mapProviders = new ArrayList<AbstractMapProvider>();
   
   tilesStr= sketchPath("data/AirScopeMap/AirScope_z"+ ZOOM_IN +".mbtiles");
   provider1 = new MBTilesMapProvider(tilesStr);
   
   tilesStr= sketchPath("data/AirScopeMap/AirScope_z"+ ZOOM_INIT+".mbtiles");
   provider2 = new MBTilesMapProvider(tilesStr);
   
   tilesStr= sketchPath("data/AirScopeMap/AirScope_z" + ZOOM_OUT+".mbtiles");
   provider3 = new MBTilesMapProvider(tilesStr);
   
   mapProviders.add(provider1);
   mapProviders.add(provider2);
   mapProviders.add(provider3);
   
   //map = new UnfoldingMap(this, new MBTilesMapProvider(tilesStr));
   
   //map = new UnfoldingMap(this, provider2);
   zoomLevel = ZOOM_INIT;
   
   map = new UnfoldingMap(this, mapProviders.get(zoomLevel - mapProviders.size()));
   map.setTweening(true);
   
   //map.setZoomRange(ZOOM_IN,ZOOM_OUT);
   map.setZoomRange(3,5);
   
   map.zoomToLevel((int)zoomLevel);
   map.panTo(STARTING_POINT);
   
   
   MapUtils.createDefaultEventDispatcher(this, map);
   addAirMarkers();
}
long timeStamp;
Date d;

void initData(){
  x_pos = height/2; 
  //z_pos = width/2;
  y_pos = width/2;
  
  screen_x_pos = width/2;
  screen_y_pos = height/2;
  
  Bubbles = new ArrayList<Bubble>();
  makeBubbles();
  
  Date d =new Date();
  timeStamp = d.getTime()/1000 + d.getTimezoneOffset()*60;
  
  stopWatch = new Stopwatch(this);
}