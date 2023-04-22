
import controlP5.*;
import java.util.List;
import java.util.Arrays;
ControlP5 cp5;
Button Piftree;
Button Dragon_Curve;
Button Mandelbrot;
Button Settings;
Button Back;
Button iteration_plus, iteration_minus;
Button reset;
Button save_image;
Button prev_image;
Button mini_mode;
Button language;
Textarea credits, guide, information;
Slider2D c_control;
CheckBox random_mode;
Slider noiseControl;
ScrollableList randomType;

int button_count = 4;
int draw_mode;
int language_mode = 1; // 0 - English, 1 - Русский

String[][] translations = {
  {"Pifagor's Tree", "Дерево Пифагора"}, //0
  {"Dragon's curve", "Кривая дракона"}, // 1
  {"Mandelbrot set", "Множество Мандельброта"}, //2
  {"Settings", "Настройки"}, //3
  {"Back", "Назад"}, //4
  {"Mode", "Режим"}, //5
  {"Save image", "Скриншот"}, //6
  {"Reset", "Сброс"}, //7
  {"Change language", "Сменить язык" }, //8
  {"Scale: ", "Увеличение: "}, //9
  {"Iterations: ", "Кол-во итераций: "}, //10
  {"Not translated yet", "Краткая инструкция:\n1.Дерево Пифагора: клавиши ←, → на клавиатуре меняют угол, на который поворачиваются стороны на каждой итерации.\n2.Множество Мандельброта: для увеличения выделите интересующую область мышкой, затем отспустите зажатую кнопку.\n3.Общие для всех режимов кнопки:\n- и +: уменьшают(увеличивают) кол-во итераций на 1 для дерева Пифагора и кривой дракона, в 2 раза для множества Мандельброта.\nСброс: возвращает к параметрам по умолчанию.\nСкриншот: делает скриншот квадратной области посередине, сохраняет в папку с программой.\n" +
  "Режим:\nДля дерева Пифагора и кривой дракона включает пошаговое построение фрактала: каждую секунду добавляется одна итерация.\nВ множестве Мандельброта переключает между его разновидностями: стандартное, горящий корабль и множество Жюлиа. "} 
};


/* dragon curve variables*/
DragonCurve dragon;

/*mandelbrot variables*/
DynamicFractal dfrac;


/*pifagor tree variables*/
PifTree tree;

float k = 1/pow(2, 0.5);
float xOffset = 0, yOffset = 0; // для сдвига фрактала
boolean locked = false;

long timer = 0;
/**/
void setup() {
  draw_mode = 0;
  language_mode = 1;
  fullScreen();
  int button_height = height/10;
  int button_width = width/6;
  int height_offset = (height-button_count*button_height)/(button_count+1);
  int width_offset = (width-button_width)/2;
  colorMode(HSB);
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("arial", 20));
  Piftree = cp5.addButton("PifTree")
    .setPosition(width_offset, height_offset)
    .setSize(button_width, button_height)
    .setLabel(translations[0][language_mode]);
  Dragon_Curve = cp5.addButton("Dragon_curve")
    .setPosition(width_offset, 2*height_offset+button_height)
    .setSize(button_width, button_height)
    .setLabel(translations[1][language_mode])
    ;
  Mandelbrot = cp5.addButton("Mandelbrot")
    .setPosition(width_offset, 3*height_offset+2*button_height)
    .setSize(button_width, button_height)
    .setLabel(translations[2][language_mode])
    ;
  Settings = cp5.addButton("Settings")
    .setPosition(width_offset, 4*height_offset+3*button_height)
    .setSize(button_width, button_height)
    .setLabel(translations[3][language_mode])
    ;
  Back = cp5.addButton("Back")
    .setLabel(translations[4][language_mode])
    .setSize(button_width, button_height)
    .setPosition(width/40, height*8/10)
    .hide();
  iteration_plus = cp5.addButton("it_plus")
    .setLabel("+")
    .setSize(height/22, height/22)
    .setPosition(width/40, height*13/22)
    .hide();
  iteration_minus = cp5.addButton("it_minus")
    .setLabel("-")
    .setSize(height/22, height/22)
    .setPosition(width/40, height*15/22)
    .hide();
  prev_image = cp5.addButton("prev_img")
    .setLabel("<--")
    .setSize(3*height/22, height/22)
    .setPosition(width/40 + height/11, height*15/22)
    .hide();
  save_image = cp5.addButton("save_img")
    .setLabel(translations[6][language_mode])
    .setSize(3*height/22, height/22)
    .setPosition(width/40, height*11/22)
    .hide();
  mini_mode = cp5.addButton("mini_mode")
    .setLabel(translations[5][language_mode])
    .setSize(2*height/22, height/22)
    .setPosition(width/40 + 4*height/22, height*11/22)
    .hide();
  language = cp5.addButton("language")
    .setLabel(translations[8][language_mode])
    .setPosition(width_offset, height_offset)
    .setSize(button_width, button_height)
    .hide();
  reset = cp5.addButton("reset")
    .setLabel(translations[7][language_mode])
    .setSize(4*height/22, height/22)
    .setPosition(width/40 + height/11, height*13/22)
    .hide();
  c_control = cp5.addSlider2D("c_control")
    .setPosition(width/40, height*3/22)
    .setSize(3*height/22, 3*height/22)
    .setMinMax(-1.50, -1.50, 1.50, 1.50)
    .setValue(-0.4, 0.6)
    .setLabel("C")
    .hide();
  ;
  random_mode = cp5.addCheckBox("random_mode")
     .setPosition(width/40, height*9/22)
     .setSize(height/22, height/22)
     .addItem("Добавить шум", 0)
     .hide();
  ;
  noiseControl = cp5.addSlider("noiseControl")
    .setPosition(width/40, height*7/22)
    .setSize(4*height/22, height/22)
    .setLabel("Уровень шума")
    .setRange(0, 3)
    .hide();
  List listitems = Arrays.asList("Равномерное", "Биномиальное");
  randomType = cp5.addScrollableList("randomType")
    .setLabel("Вид распределения")
    .setPosition(width/40, 55*height/220)
    .setSize(5*height/22, 3*height/22)
    .setBarHeight(height/22)
    .setItemHeight(height/22)
    .close()
    .addItems(listitems)
    .hide()
  ;

  credits = cp5.addTextarea("credits").setPosition(width/40, height*20/22).setSize(width*6/40, height/11).setText("Моргачев Дмитрий, 2023\n@orientiered");
  guide = cp5.addTextarea("guide").setPosition(width/4, height*7/22).setSize(width/2, height/3).setText(translations[11][language_mode]);
  background(0);
  tree = new PifTree();
  dragon = new DragonCurve();
  dfrac = new DynamicFractal();
  
  c_control.setPosition(dfrac.picture_width_offset+dfrac.size+width/40, 3*height/22);
  hide_buttons();
}
//draw mode 0             1                2                3                  10
//meaning   title screen  pifagor's tree   dragon's curve   mandelbrot set     settings 
void draw() {
  switch(draw_mode) {
  case 0:
    background(0);
    break;
  case 1:
    background(200);
    tree.drawtree(); //<>//
    tree.information();
    break;
  case 2:
    background(200);
    dragon.drawdragon();
    dragon.information();
    break;
  case 3:
    if (dfrac.m_locked && dfrac.isInBorders()) {
      background(0);
      image(dfrac.computed, dfrac.picture_width_offset, dfrac.picture_height_offset);
      dfrac.information();
      dfrac.selection_square();
    }
    else if (!dfrac.is_rendered) dfrac.frac_fill();
    else {
     background(0);
     image(dfrac.computed, dfrac.picture_width_offset, dfrac.picture_height_offset);
     dfrac.information(); 
    }
    break;
  default:
    background(0);
    break;
  }
}

    
    
