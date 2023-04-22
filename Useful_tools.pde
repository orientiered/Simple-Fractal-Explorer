static double map(double value, double start1, double stop1, double start2, double stop2) {
  return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2;
}
double abs(double v) {
  return (v < 0) ? -v: v;
}
float round3(double a) {
  return float(round((float)a*1000.0))/1000;
}
class Complex { //класс комплексных чисел
  double real;
  double im;
  public Complex(double real, double img) {
    this.real = real;
    this.im = img;
  }
  public Complex add(Complex b) {
    double real = this.real + b.real;
    double img = this.im + b.im;
    return new Complex(real, img);
  }
  public Complex sub(Complex b) { //сложение
    double real = this.real - b.real;
    double img = this.im - b.im;
    return new Complex(real, img);
  }
  public boolean isEqual(Complex a, Complex b) { //равенство
    return a.real == b.real && a.im == b.im;
  }
  public Complex multi(Complex b) { //умножение
    double real = this.real * b.real-this.im * b.im;
    double img = this.real*b.im+this.im*b.real;
    return new Complex(real, img);
  }
  public Complex asqr() {
    double real = this.real*this.real-this.im*this.im;
    double img = 2*(abs(this.real*this.im));
    return new Complex(real, img);
  }
}

class Random_set {
  public int i = 0;
  float k = 1;
  float[] rnd;
  int Type = 0;
  public Random_set() {
    rnd = new float[height*width];
    rnd[0] = 0;
    for (int j = 1; j < rnd.length; j++)
      rnd[j] = random(-1, 1);
  }
  //distType 0           1
  //        равномерное биномиальное
  public Random_set(int distType) {
    Type = distType;
    rnd = new float[height*width];
    rnd[0] = 0;
    for (int j = 1; j < rnd.length; j++) {
      switch (distType) {
      case 0:
        rnd[j] = random(-1, 1);
        break;
      case 1:
        rnd[j] = randomGaussian()/3; // так как стандартное отклонение равно 1, то уменьшаем его вручную
        break;
      }
    }
  }
  float getRnd() {
    float t = rnd[i];
    i = (i+1) % rnd.length;
    return t*k;
  }
}

boolean inSliderBorders() {
  return (mouseX > width/40 && mouseX < width/40 + 4*height/22 && mouseY > height*7/22 && mouseY < height*8/22);
}
