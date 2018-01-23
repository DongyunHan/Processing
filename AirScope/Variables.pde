
final String GOOGLE_TIMEZONE_API_KEY = "AIzaSyAxPrkF5hzEHOhbYrWnuopXmrRjCb9il7A";

final float screenMargin = 150;
final int TIME_INTERVAL = 800;

final Location STARTING_POINT = new Location(37.53f, 127.76f);

final int ZOOM_OUT = 3;
final int ZOOM_INIT = 4;
final int ZOOM_IN = 5;

color BACKGROUND = color(255, 255, 255);

boolean zoomIn = false;
boolean zoomOut = false;

UnfoldingMap map;
I2C mpu_6050;

int zoomLevel;

float[] accelData ={0,0,0};
float[] gyroData = {0,0,0};

float[] errorAccelData;
float[] errorGyroData;

float x_rotate;
float y_rotate;
float z_rotate;

float x_pos;
float y_pos;
float z_pos;

float screen_x_pos;
float screen_y_pos;

PFont font;
PFont helveFont;