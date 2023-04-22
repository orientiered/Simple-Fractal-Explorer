public void PifTree() {
  draw_mode = 1;
  hide_buttons();
  if (tree.addNoise != random_mode.getState(0)) random_mode.toggle(0);
  if (tree.addNoise) {
    noiseControl.show();
    noiseControl.setValue(tree.rnd.k); 
    randomType.show();
  }
  stroke(0, 255, 255);
  strokeWeight(4);
}
public void Dragon_curve() {
  draw_mode = 2;
  hide_buttons();
  if (dragon.addNoise != random_mode.getState(0)) random_mode.toggle(0);
  if (dragon.addNoise) {
    noiseControl.show();
    noiseControl.setValue(dragon.rnd.k); 
    randomType.show();
  }
  stroke(0, 255, 255);
  strokeWeight(2);
}
public void Mandelbrot() {
  prev_image.show();
  draw_mode = 3;
  hide_buttons();
  if (dfrac.addNoise != random_mode.getState(0)) random_mode.toggle(0);
  if (dfrac.addNoise) {
    noiseControl.show();
    noiseControl.setValue(dfrac.rnd.k); 
    randomType.show();
  }
  if (dfrac.mode == 2) c_control.show();
  background(0);
  dfrac.rendered_percentage = max(0, dfrac.rendered_percentage-0.1);
  dfrac.global_i = max(0, dfrac.global_i - dfrac.size/10);
  if (dfrac.computed == null) {
    dfrac.frac_fill();
    dfrac.information();
  } else image(dfrac.computed, 0, 0);
}
public void Settings() {
  draw_mode = 10;
  hide_buttons();
  language.show();
  credits.show();
  guide.show();
}
public void language() {
  language_mode = (language_mode + 1) % 2;
  Piftree.setLabel(translations[0][language_mode]);
  Dragon_Curve.setLabel(translations[1][language_mode]);
  Mandelbrot.setLabel(translations[2][language_mode]);
  Settings.setLabel(translations[3][language_mode]);
  Back.setLabel(translations[4][language_mode]);
  reset.setLabel(translations[7][language_mode]);
  save_image.setLabel(translations[6][language_mode]);
  mini_mode.setLabel(translations[5][language_mode]);
  language.setLabel(translations[8][language_mode]);
  guide.setText(translations[11][language_mode]);
}
public void it_plus() {
  switch (draw_mode) {
  case 1:
    if (tree.iter < 18) {
      tree.iter++;
    }
    break;
  case 2:
    if (dragon.iter < 22) {
      dragon.iter++;
    }
    break;
  case 3:
    dfrac.iter *= 2;
    dfrac.rerender();
    break;
  }
}
public void it_minus() {
  switch (draw_mode) {
  case 1:
    if (tree.iter > 0) {
      tree.iter--;
    }
    break;
  case 2:
    if (dragon.iter > 0) {
      dragon.iter--;
    }
    break;
  case 3:
    dfrac.iter /= 2;
    dfrac.rerender();
    break;
  }
}
public void prev_img() {
  if (draw_mode == 3 && dfrac.picture > 0) {
    dfrac.picture--;
    dfrac.estimateIter();
    dfrac.rerender();
  }
}
public void reset() {
  noiseControl.hide();
  switch(draw_mode) {
  case 1:
    tree = new PifTree();
    if (tree.addNoise != random_mode.getState(0)) random_mode.toggle(0);
    break;
  case 2:
    dragon = new DragonCurve();
    if (dragon.addNoise != random_mode.getState(0)) random_mode.toggle(0);
    break;
  case 3:
    dfrac.iter = dfrac.defaultIter;
    dfrac.picture = 0;
    background(0);
    dfrac.rerender();
    dfrac.computed = get(dfrac.picture_width_offset, dfrac.picture_height_offset, dfrac.size, dfrac.size);
    break;
  }
}
public void save_img() {
  String name = "fractal_"+draw_mode+"_"+day()+"-"+hour()+"-"+minute()+"-"+second()+".png";
  get(dfrac.picture_width_offset, dfrac.picture_height_offset, dfrac.size, dfrac.size).save(name);
}
public void mini_mode() {
  switch(draw_mode) {
  case 1:
    tree.mode = (tree.mode+1) % 2;
    timer = millis();
    break;
  case 2:
    dragon.mode = (dragon.mode+1) % 2;
    timer = millis();
    break;
  case 3:
    dfrac.mode = (dfrac.mode +  1) % 3;
    dfrac.picture = 0;
    if (dfrac.mode == 2) c_control.show();
    else c_control.hide();
    background(0);
    dfrac.iter = dfrac.defaultIter;
    dfrac.rerender();
    dfrac.computed = get(dfrac.picture_width_offset, dfrac.picture_height_offset, dfrac.size, dfrac.size);
    break;
  }
}
public void Back() {
  draw_mode = 0;
  hide_buttons();
  prev_image.hide();
}
void hide_buttons() {
  if (draw_mode == 0) {
    Piftree.show();
    Mandelbrot.show();
    Dragon_Curve.show();
    Settings.show();
    credits.show();
    Back.hide();
    guide.hide();
    iteration_plus.hide();
    iteration_minus.hide();
    reset.hide();
    save_image.hide();
    mini_mode.hide();
    language.hide();
    c_control.hide();
    random_mode.hide();
    noiseControl.hide();
    randomType.hide();
  } else {
    Piftree.hide();
    Mandelbrot.hide();
    Dragon_Curve.hide();
    Settings.hide();
    credits.hide();
    guide.hide();
    Back.show();
    if (draw_mode != 10) {
      iteration_plus.show();
      iteration_minus.show();
      reset.show();
      save_image.show();
      mini_mode.show();
      random_mode.show();
    }
  }
}

void random_mode(float[] val) {
  if (random_mode.getState(0)) {
    randomType.show();
    noiseControl.show();
  }
  else {
    randomType.hide();
    noiseControl.hide();
  }
  switch (draw_mode) {
  case 1:
    tree.switchNoise();
    break;
  case 2:
    dragon.switchNoise();
    break;
  case 3:
    dfrac.switchNoise();
    dfrac.rerender();
    break;
  }
}

void noiseControl(float val) {
  switch (draw_mode) {
  case 1:
    tree.rnd.k = val;
    break;
  case 2:
    dragon.rnd.k = val;
    break;
  case 3:
  dfrac.rnd.k = val;
  dfrac.rerender();
    break;
  }
}

void randomType(int n) {
 switch(draw_mode) {
   case 1:
    tree.changeRnd(n);
    break;
  case 2:
    dragon.changeRnd(n);
    break;
  case 3:
  dfrac.changeRnd(n);
  dfrac.rerender();
    break;
 }
}

void mousePressed() {
  locked = true;
  switch(draw_mode) {
  case 1:
  if (inSliderBorders() && noiseControl.isVisible()) locked = false;
    xOffset = mouseX-tree.x;
    yOffset = height-mouseY-tree.y;
    break;
  case 2:
  if (inSliderBorders() && noiseControl.isVisible()) locked = false;
    xOffset = mouseX-dragon.x;
    yOffset = mouseY-dragon.y;
    break;
  case 3:
    if (dfrac.isInBorders()) {
      dfrac.m_locked = true;
      dfrac.x0 = mouseX;
      dfrac.y0 = mouseY;
    }
    break;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  float temp = map(e, -1, 1, 1/k, k); // коэффициент увеличения(уменьшения)
  switch (draw_mode) {
  case 1:
    tree.fscale(temp);
    break;
  case 2:
    dragon.fscale(temp);
    break;
  }
}

void mouseDragged() {
  switch(draw_mode) {
  case 1:
    if (locked) {
      tree.x = mouseX-xOffset;
      tree.y = height-mouseY-yOffset;
    }
    break;
  case 2:
    if (locked) {
      dragon.x = mouseX-xOffset;
      dragon.y = mouseY-yOffset;
    }
    break;
  case 3:
    stroke(255);
    strokeWeight(3);
    break;
  }
}

void mouseReleased() {
  locked = false;
  switch(draw_mode) {
  case 3:
    if (dfrac.m_locked) {
      stroke(255);
      strokeWeight(3);
      float d = dfrac.selection_square();
      dfrac.picture++;
      dfrac.update_borders(d);
      dfrac.estimateIter();
      copy(dfrac.computed, int(dfrac.X0)-dfrac.picture_width_offset, int(dfrac.Y0-d)-dfrac.picture_height_offset, int(d), int(d), dfrac.picture_width_offset, dfrac.picture_height_offset, dfrac.size, dfrac.size);
      fill(0);
      dfrac.rerender();
    }
    if (c_control.getArrayValue()[0] != dfrac.julia_c.real || c_control.getArrayValue()[1] != dfrac.julia_c.im) {
      dfrac.julia_c.real =  c_control.getArrayValue()[0];
      dfrac.julia_c.im = c_control.getArrayValue()[1];
      dfrac.rerender();
    }
    break;
  }
  dfrac.m_locked = false;
}


void keyPressed() {
  switch (draw_mode) {
  case 1:
    if (keyCode == LEFT) {
      tree.angle1 += tree.da;
      tree.angle2 -= tree.da;
    } else if (keyCode == RIGHT) {
      tree.angle1 -= tree.da;
      tree.angle2 += tree.da;
    } else if (key == 'm') {
      tree.mode = 1 - tree.mode;
    }
    break;
  }
}
