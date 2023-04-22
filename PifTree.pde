class PifTree {
  int iter = 10;
  float len = 150.0;
  float angle1 = PI/4;
  float angle2 = PI/2-angle1;
  float k = 1/pow(2, 0.5); //tree
  float da = 0.005;
  float x = width/2;
  float y = height/5;
  
  int mode  = 0;
  Random_set rnd;
  boolean addNoise = false;
  void switchNoise() { // включить режим с шумом
   addNoise = !addNoise;
   if (addNoise) rnd = new Random_set();
   noiseControl.setValue(rnd.k);
  }
  void changeRnd(int rt) {
    if (rt != rnd.Type){
      float temp = rnd.k;
      rnd = new Random_set(rt);
      rnd.k = temp;
    }
  }
  void fscale(float temp) { // приближение/отдаление со смещением стартовой позиции
    float dx = (x-mouseX)*(temp-1);
    float dy = (height-y-mouseY)*(temp-1);
    if (len*temp > 3 && len*temp < 20*height) {
      len *= temp;
      x += dx;
      y -= dy;
    }
  }
  void drawtree() {
    drawtree(PI/2, len, x, y, 0);
    if (addNoise) rnd.i = 0;
  }
  void drawtree(float angle, float len, float x, float y, int i) {
    if (((millis()-timer)/1000 < i && mode == 1)) return;
    if (i > iter ) {
      timer = millis();
      return;
    }
    stroke(map(i, 0, iter, 255, 64), 255, 255);
    if (addNoise) angle += rnd.getRnd()/3;
    line(x, height-y, x+len*cos(angle), height-(y+len*sin(angle)));
    if (addNoise) {
      drawtree(angle+angle1, len*(k+rnd.getRnd()/5), x+len*cos(angle), y+len*sin(angle), i+1);
      drawtree(angle-angle2, len*(k+rnd.getRnd()/5),  x+len*cos(angle), y+len*sin(angle), i+1);
    } else {
      drawtree(angle+angle1, len*k, x+len*cos(angle), y+len*sin(angle), i+1);
      drawtree(angle-angle2, len*k,  x+len*cos(angle), y+len*sin(angle), i+1);
    }
    
  }
  void information() {
    fill(255); stroke(100);
    rect(13, 10, 250, 70, 7);
    fill(0);
    text(translations[10][language_mode] + str(iter), 20, 50);
  }
}
