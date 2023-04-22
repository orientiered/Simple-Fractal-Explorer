class DragonCurve {
  int iter = 10, prev_iter = iter;
  float len = 20.0, defaultLen = 20.0;
  int[] rotations;
  int[] colors;
  float x = width*2/5, // начальные координаты.
    y = height/3;
  float speed = 1000;
  int mode = 0;

  boolean addNoise = false;
  Random_set rnd;
  DragonCurve() {
    init();
  }
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
  void fscale(float temp) {
    float dx = (x-mouseX)*(temp-1);
    float dy = (mouseY-y)*(temp-1);
    if (len*temp > 0.2 && len*temp < height) {
      len *= temp;
      x += dx;
      y -= dy;
    }
  }

  void init() { // пересчитывает массив поворотов и цветов
    rotations = new int[int(pow(2, iter))];
    rotations[0] = 0;
    colors = new int[int(pow(2, iter))];
    filldragon(0);
  }
  void filldragon(int i) {
    if (i == iter) return;
    int pow2 = int(pow(2, i));
    for (int j = 0; j < pow2; j++) {
      rotations[2*pow2-j-1] = (rotations[j] + 1) % 4;
      colors[2*pow2-j-1] = i;
    }

    filldragon(i+1);
  }

  void drawdragon() {
    if (iter != prev_iter) { // если изменили количество итераций, то пересчитываем массив поворотов
      init();
      prev_iter = iter;
    }
    float posx = x, posy = y;
    float endx = 0, endy = 0;
    int steps_to_draw = (mode == 0) ? rotations.length 
                      : int(pow(2, int((millis()-timer) / speed))); // если режим пошагового построения, то нужно построить 2^время отрезков
    for (int k = 0; k < min(steps_to_draw, rotations.length); k++) {
      switch(rotations[k]) {
      case 0:
        endx = posx;
        endy = posy + len;
        break;
      case 1:
        endx = posx + len;
        endy = posy;
        break;
      case 2:
        endx = posx;
        endy = posy - len;
        break;
      case 3:
        endx = posx - len;
        endy = posy;
        break;
      }
      stroke(map(colors[k], 0, iter, 255, 0), 255, 200);
      if (addNoise) {
        //endx += rnd.getRnd() * len/defaultLen;
        //endy += rnd.getRnd() * len/defaultLen;
        endx += rnd.getRnd();
        endy += rnd.getRnd();
      }
      line(posx, posy, endx, endy);
      posx = endx;
      posy = endy;
    }
    if (addNoise) rnd.i = 0;
    if (steps_to_draw > rotations.length) timer = millis();
  }
  void information() {
    fill(255);
    stroke(100);
    rect(13, 10, 250, 70, 7);
    fill(0);
    text(translations[10][language_mode] + str(iter), 20, 50);
  }
}
