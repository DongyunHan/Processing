void readFrom_MPU6050(I2C d, float[] a, boolean dataMode)
{
  if(dataMode)
   readAccelData(d,a); 
  else
    readGyroData(d,a);
}

void readAccelData(I2C d, float[] a)
{
  d.write(0x3B);
  //read 6 byte from mpu6050
  //accel_xout = register 3B / 3C
  //accel_yout = register 3D / 3E
  //accel_zout = register 3F / 40
  byte[] data = d.read(6); 
  
  int accel_xout = ((data[0] & 0xff) << 8 | (data[1] & 0xff));
  int accel_yout = ((data[2] & 0xff) << 8 | (data[3] & 0xff));
  int accel_zout = ((data[4] & 0xff) << 8 | (data[5] & 0xff));
  
  accel_xout= complementCheck(accel_xout);
  accel_yout= complementCheck(accel_yout);
  accel_zout= complementCheck(accel_zout);
  
  a[0] = (accel_xout/16384.0);
  a[1] = (accel_yout/16384.0);
  a[2] = (accel_zout/16384.0);
}

void readGyroData(I2C d, float[] a){
  d.write(0x43);
  //read 6 byte from mpu6050
  //gyro_xout = register 43 / 44
  //gyro_yout = register 45 / 46
  //gyro_zout = register 47 / 48
  byte[] data = d.read(6); 
  
  int gyro_xout = ((data[0] & 0xff) << 8 | (data[1] & 0xff));
  int gyro_yout = ((data[2] & 0xff) << 8 | (data[3] & 0xff));
  int gyro_zout = ((data[4] & 0xff) << 8 | (data[5] & 0xff));
  
  gyro_xout= complementCheck(gyro_xout);
  gyro_yout= complementCheck(gyro_yout);
  gyro_zout= complementCheck(gyro_zout);
  
  a[0] = (gyro_xout/131.0);
  a[1] = (gyro_yout/131.0);
  a[2] = (gyro_zout/131.0);
}

int complementCheck(int val){
   if (val >= 0x8000)
        return -((65535 - val) + 1);
    else
        return val;
}

void init_Data(I2C d, float[] errorData, boolean dataMode){
  float[] temp = new float[3];
  int n = 100;
  
  if(dataMode){
    for(int i=0; i<n; i++){
      mpu_6050.beginTransmission(0x68);
      readFrom_MPU6050(mpu_6050, temp, true);
    
     errorData[0] += temp[0]; 
     errorData[1] += temp[1];
     errorData[2] += temp[2];
   }
  }else{
    for(int i=0; i<n; i++){
      mpu_6050.beginTransmission(0x68);
      readFrom_MPU6050(mpu_6050, temp, false);
    
     errorData[0] += temp[0]; 
     errorData[1] += temp[1];
     errorData[2] += temp[2];
   }
  }
 errorData[0] = errorData[0]/n;
 errorData[1] = errorData[1]/n;
 errorData[2] = errorData[2]/n;
}

float dist(float a,float b){
    return sqrt(sq(a)+sq(b));
}
 
float get_x_rotation(float x,float y,float z){
    return degrees(
        atan(x / dist(y,z))
    );
}

float get_y_rotation(float x,float y,float z){
    return degrees(
        atan(y / dist(x,z))
    );
}

float get_z_rotation(float x,float y,float z){
    return degrees(
        atan(z / dist(x,y))
    );
}