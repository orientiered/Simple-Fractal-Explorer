class DynamicFractal {
  PImage computed;
  int frames_per_second = 30;
  int iter = 250, defaultIter = 250; //максимальное количество итераций
  int mode = 0;
  boolean m_locked = false;
  double R = 2, R2 = R*R;
  double re_s = -2, re_e = 2, im_s = -2, im_e = 2; //границы координатной плоскости
  double[][] borders;
  int picture = 0;
  float x0 = 0, y0= 0;
  float X0 = 0, Y0 = 0;
  float scale = 1;
  int size, picture_height_offset, picture_width_offset; //размер отображаемой квадратного множества, сдвиги по осям х и у
  int global_i = 0;
  boolean is_rendered = false;
  float rendered_percentage = 0;

  boolean addNoise = false;
  Random_set rnd;

  Complex julia_c = new Complex(-0.4, 0.6);

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
  DynamicFractal() {
    size = min(width, height);
    picture_height_offset = (height-size)/2;
    picture_width_offset = (width-size)/2;
    borders = new double[100][4];
    borders[0][0] = re_s;
    borders[0][1] = re_e;
    borders[0][2] = im_s;
    borders[0][3] = im_e;
    computed = get(picture_width_offset, picture_height_offset, size, size);
  }

  int mandelbrot(Complex c) { //определяем цвет точки
    int it = 0;
    Complex z = new Complex(0, 0);
    while (z.real*z.real+z.im*z.im < R2 && it < iter) {
      if (mode == 1) { // горящий корабль
        z.real = abs(z.real);
        z.im = abs(z.im);
      }
      z = z.multi(z); //z = z*z+c
      z = z.add(c);
      if (addNoise) {
        z.real += rnd.getRnd()/20;
        z.im += rnd.getRnd()/20;
      }

      it++;
    }
    return it; //итерация, на которой ушли в "бесконечность", либо макс. итерация
  }


  int julia(Complex z) { //определяем цвет точки
    int it = 0;
    while (z.real*z.real+z.im*z.im < R2 && it < iter) {
      z = z.multi(z); //z = z*z+c
      z = z.add(julia_c);
      if (addNoise) {
        z.real += rnd.getRnd()/20;
        z.im += rnd.getRnd()/20;
      }
      it++;
    }
    return it; //итерация, на которой ушли в "бесконечность", либо макс. итерация
  }

  float selection_square() {
    float d = mouseX-x0;
    float mY = (mouseY > y0) ? y0+abs(d) : y0-abs(d);
    line(x0, y0, x0, mY);
    line(x0, y0, mouseX, y0);
    line(x0, mY, mouseX, mY);
    line(mouseX, y0, mouseX, mY);
    X0 = (d > 0) ? x0: x0+d;
    Y0 = (mY < y0) ? y0: mY;
    return abs(d);
  }
  void update_borders(float d) {
    borders[picture][0] = map(X0, picture_width_offset, picture_width_offset+size, borders[picture-1][0], borders[picture-1][1]);
    borders[picture][1] = map(X0+d, picture_width_offset, picture_width_offset+size, borders[picture-1][0], borders[picture-1][1]);
    borders[picture][3] = map(Y0, picture_height_offset, picture_height_offset+size, borders[picture-1][2], borders[picture-1][3]);
    borders[picture][2] = map(Y0-d, picture_height_offset, picture_height_offset+size, borders[picture-1][2], borders[picture-1][3]);
  }
  void estimateIter() {
    int estimate = defaultIter + round(10*pow(get_scale(), 0.4));
    iter = max(estimate, iter);
  }
  float get_scale() {
    return  4.0/(float)(borders[picture][1]-borders[picture][0]);
  }

  boolean isInBorders() {
    if (mouseX >= picture_width_offset && mouseX <= picture_width_offset + size
      && mouseY >= picture_height_offset && mouseY <= picture_height_offset + size) return true;
    else return false;
  }

  void information() {
    fill(255);
    stroke(100);
    rect(30, 16, 300, (mode == 2) ? 110 : 90, 7);
    scale = get_scale();
    fill(0);
    String info = translations[9][language_mode] + str(scale) + "\n" + translations[10][language_mode] + str(iter);
    if (mode == 2) info += "\nC = " + round3(julia_c.real) + " + " + round3(julia_c.im) + "j";
    text(info, 50, 50);
    computed = get(picture_width_offset, picture_height_offset, size, size);
  }

  void frac_fill() {
    is_rendered = false;
    strokeWeight(1.3);
    for (; global_i < size; global_i++) {
      for (int j = 0; j < size; j++) {
        float dotColor;

        switch (mode) {
        case 2:
          Complex z = new Complex(map(global_i, 0, size, borders[picture][0], borders[picture][1]),
            map(j, 0, size, borders[picture][2], borders[picture][3])); //создаём с в зависимости от точки на экране
          dotColor = map(julia(z), 0, iter, 135, 230);
          break;
        default:
          Complex c = new Complex(map(global_i, 0, size, borders[picture][0], borders[picture][1]),
            map(j, 0, size, borders[picture][2], borders[picture][3])); //создаём с в зависимости от точки на экране
          dotColor = map(mandelbrot(c), 0, iter, 5, 230);
          break;
        }

        stroke(dotColor, 190, (dotColor == 230) ? 0 : 220);
        point(global_i+picture_width_offset, j + picture_height_offset);
      }
      if (global_i == size - 1) { // если ддошли до конца, то изображение готово, сохраняем его
        is_rendered = true;
        global_i = 0;
        computed = get(dfrac.picture_width_offset, dfrac.picture_height_offset, dfrac.size, dfrac.size);
      }
      if (millis() - timer > 1000/frames_per_second) { // если время на кадр закончилось то выходим. Если сгенерировано больше 10 процентов, то сохраняем изображение.
        if (float(global_i) / size > rendered_percentage + 0.1) {
          computed = get(dfrac.picture_width_offset, dfrac.picture_height_offset, dfrac.size, dfrac.size);
          rendered_percentage = float(global_i) / size;
        }
        timer = millis();
        break;
      }
    }
  }
  void rerender() {
   global_i = 0;
   rendered_percentage = 0;
   frac_fill();
   information();
  }
}
