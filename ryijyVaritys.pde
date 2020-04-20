// ryijy luku 1058
import controlP5.*;

ControlP5 cp5;
ControlFont cp5Font;



PImage img, temp;
PGraphics result;

int myMouseX = 0;
int myMouseY = 0;
int currentMouseX = 0;
int currentMouseY = 0;
int savyt = 2;
int maxSavyt = 40;
int valittuSekoitus = 1;

int previewW = 800;
int previewH = 600;

  int sampleMarginL = 0;
  int sampleMarginT = 0;
  int sampleSize = 0;
  
  Lanka valittuLanka;

color pickColor;

boolean prosessoiKuva = true;
boolean asetaVarit = true;
boolean showResultEnlarged = false;
boolean showResult = true;
boolean lataaKuva = false;
boolean exitApp = false;



String kuvanPolku = "";


Table varikartta;

ArrayList<Lanka> langat = new ArrayList<Lanka>();
ArrayList<Sekoitus> sekoitukset = new ArrayList<Sekoitus>();

class Lanka {
  int r, g, b, l, t;
  color c;
  int x,y,w,h;

  Lanka(int _r, int _g, int _b, int _l, int _t) {
    r=_r;
    g=_g;
    b=_b;
    l=_l;
    t=_t;
    c = color(r, g, b);
  }
  void piirra(int _x, int _y, int _w, int _h) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    fill(r, g, b);
    rect(_x, _y, _w, _h);
    fill(255);
    text(l,x,y+h*2);
  }
  color getC() {
    return c;
  }
  void setC(color _cc) {
    c = _cc;
  }
  
    int getLeftEdge() {
    return x;
  }
  int getRightEdge() {
    return x+w;
  }
    int getTopEdge() {
    return y;
  }
  int getBottomEdge() {
    return y+h;
  }
  
  
}

class Sekoitus {
  Lanka[] langat = new Lanka[4];
  color[] lankojenVarit = new color[4];
  int size = 20;

  int x;
  int y;
  int xP;
  int yP;
  
  boolean isSelected = false;


  Sekoitus(Lanka[] _l) {
    //for (int l = 0; l < langat.length; l++) {
    //  langat[l]=_l[l];
    //}
    langat=_l;
  }

  void piirra(int _x, int _y) {
    x = _x;
    y = _y;
    xP = 0;
    yP = 0;
    
    if(isSelected){
      stroke(0);
      noFill();
      rect(x,y,size*2, size*2);
    } else {
      noStroke();
    }
    for (int l = 0; l < langat.length; l++) {
      fill(langat[l].r, langat[l].g, langat[l].b);
      rect(x+xP, y+yP, size, size);
      fill(255);
      text(langat[l].l, x+xP,y+yP+size*3);
      xP+=size;
      if (xP>size) {
        xP = 0;
        yP += size;
      }
    }
  }

  int getLeftEdge() {
    return x;
  }
  int getRightEdge() {
    return x+(size*2);
  }
    int getTopEdge() {
    return y;
  }
  int getBottomEdge() {
    return y+(size*2);
  }

  void setSize(int _s) {
    size = _s;
  }
  int getSize() {
    return size*2;
  }

  color[] getColors() {
//    color[] lankojenVarit = new color[4];
    for (int i=0; i<lankojenVarit.length; i++) {
      lankojenVarit[i] = langat[i].getC();
    }
    return lankojenVarit;
  }
  Lanka[] getLangat(){
   return langat;
  }
  void updateColors(){
        for (int i=0; i<lankojenVarit.length; i++) {
      lankojenVarit[i] = langat[i].getC();
    }
  }

  void setColor(color _c, int _x, int _y) {
   // int loc = _x + 2*y;
     println("set color"+_c);
     langat[0].setC(_c);
     lankojenVarit[0] = _c;
    if(_x>x && _x<x+size && _y>y && _y<y+size){
    langat[0].setC(_c);
    }
    if(_x>x+size && _x<x+size*2 && _y>y && _y<y+size){
    langat[1].setC(_c);
    }
    if(_x>x && _x<x+size && _y>y+size && _y<y+size*2){
    langat[2].setC(_c);
    }
    if(_x>x+size && _x<x+size*2 && _y>y+size && _y<y+size*2){
    langat[3].setC(_c);
    }
  }
    void asetaLanka(Lanka _l, int _x, int _y) {
    if(_x>x && _x<x+size && _y>y && _y<y+size){
    langat[0] = _l;;
    }
    if(_x>x+size && _x<x+size*2 && _y>y && _y<y+size){
    langat[1] = _l;;
    }
    if(_x>x && _x<x+size && _y>y+size && _y<y+size*2){
    langat[2] = _l;
    }
    if(_x>x+size && _x<x+size*2 && _y>y+size && _y<y+size*2){
    langat[3] = _l;
    }
  }
    void setThisColor(color _c, int _i) {
      langat[_i].setC(_c);
    }
  void select(){
   isSelected=true; 
  }
  
  void deselect(){
   isSelected=false; 
  }
}

void setup() {
  size(1200, 1080);
  cp5 = new ControlP5(this);
  cp5Font = new ControlFont(createFont("Arial", 18));
  createGui();

  img = loadImage("testi.jpg");
  img.resize(img.width/2, img.height/2);
  temp = img.get();
  result = createGraphics(img.width*4, img.height*4);

  varikartta = loadTable("langat.csv", "header");
  println(varikartta.getRowCount() + " total rows in table");

  for (TableRow vari : varikartta.rows()) {
    int r = vari.getInt("r");
    int g = vari.getInt("g");
    int b = vari.getInt("b");
    int l = vari.getInt("lotta");
    int t = vari.getInt("tuukka");
    langat.add(new Lanka(r, g, b, l, t));
  }
 
  for (int i=0; i<maxSavyt; i++) {
      Lanka[] lankaSekoitus = new Lanka[4];
  for (int j=0; j<lankaSekoitus.length; j++) {
    lankaSekoitus[j] = langat.get(int (random(0,23)));
  }
    sekoitukset.add(new Sekoitus(lankaSekoitus));
  }
    Sekoitus update = sekoitukset.get(valittuSekoitus);
    update.select();
}

void draw() {
  background(128);
  
    if (exitApp) {
    println("DONE");
    exit();
  }

  if (prosessoiKuva) {

    temp = img.get();
    temp.loadPixels();

    result.beginDraw();
    result.noStroke();
    for (int j=0; j<temp.height; j++) {
      for (int i=0; i<temp.width; i++) {
        int loc = j*temp.width + i;
        int refValue = int((temp.pixels[loc]) >> 8 & 0xFF);
        int scaledRefValue = int(map(refValue, 0, 255, 0, savyt));
        temp.pixels[loc] = color(scaledRefValue*(255.0/(savyt)));
        Sekoitus s = sekoitukset.get(scaledRefValue);
        color c[] = s.getColors();
        int x = 0;
        int y = 0;
        for (int v=0; v<c.length; v++) {
          //result.stroke(0);
          result.noStroke();
          result.fill(c[v]); // c[v]
          if(v==0)result.rect(i*4, j*4, 2, 2);
          if(v==1)result.rect(i*4+2, j*4, 2, 2);
          if(v==2)result.rect(i*4, j*4+1, 2, 2);
          if(v==3)result.rect(i*4+2, j*4+2, 2, 2);
        }
      }
    }
    temp.updatePixels();
    result.endDraw();
    // image(result,0,0);
    prosessoiKuva=false;
  }
//  image(result, 0, 0, img.width*4, img.height*4);
if(showResult){

if(showResultEnlarged){
    image(result, 0, 0, result.width, result.height);
} else {
  image(result, 0, 0, result.width/2, result.height/2);
}

} else {
    image(temp, 0, 0, result.width/2, result.height/2);
 
}


  // img.updatePixels();
  // image(img, 0,0);

  if (asetaVarit) {
    //for (int i = sekoitukset.size() - 1; i >= 0; i--) {
    // // Sekoitus s = sekoitukset.get(i);
    //  sekoitukset.remove(i);
    //}

    //for (int j=0; j<savyt; j++) {

    //  Lanka[] lankaSekoitus = new Lanka[4];
    //  for (int i=0; i<lankaSekoitus.length; i++) {
    //    lankaSekoitus[i] = langat.get(i);
    //  }
    //  sekoitukset.add(new Sekoitus(lankaSekoitus));
    //}
    
    
        //  println("aseta värit draw");



  //for (Sekoitus s : sekoitukset) {
  //  if(s.isSelected){
  //    s.setColor(pickColor, currentMouseX, currentMouseY);
  //    println("aseta värit selected");

  //  }
  //}
    asetaVarit = false;
  } else {
    
    




  color[] c = new color[4];
  int x = 5;
  int y = previewH+60;
  int index = 0;
  int sampleVali = 10;
  
  for (Sekoitus s : sekoitukset) {
    if(index<=savyt){
    s.updateColors();
    s.piirra(x, y);
    x+=s.getSize()+sampleVali;
    } else {
     break; 
    }
    index++;
      if (x>=previewW) {
      x=0;
      y+=s.getSize()*2+sampleVali;
    }
  }


  
  int xPos = 50;
  int yPos = previewH+10;
  int koko = 20;
  
  text("Langat: ", 5,yPos+15);
  noStroke();
  for (Lanka l : langat) {
    l.piirra(xPos, yPos, koko, koko);
    xPos+=koko;
    if (xPos>width) {
      yPos+=koko;
      xPos=0;
    }
  }
  
  }

  //if (mouseX % 2 == 0) {
  //  myMouseX = mouseX;
  //}
  //if (mouseX % 2 == 0) {
  //  myMouseY = mouseX;
  //}

  //color[] c = new color[4];
  //c[0] = get(myMouseX, myMouseY);
  //c[1]  = get(myMouseX+1, myMouseY);
  //c[2] = get(myMouseX, myMouseY+1);
  //c[3]  = get(myMouseX+1, myMouseY+1);

  //int sampleMarginL = 400;
  //int sampleMarginT = img.height+120;
  //int sampleSize = 50;
  //fill(c[0]);
  //rect(sampleMarginL, sampleMarginT, sampleSize, sampleSize);
  //fill(c[1]);
  //rect(sampleMarginL+sampleSize, sampleMarginT,sampleSize, sampleSize);  
  //fill(c[2]);
  //rect(sampleMarginL, sampleMarginT+sampleSize, sampleSize, sampleSize);    
  //fill(c[3]);
  //rect(sampleMarginL+sampleSize, sampleMarginT+sampleSize, sampleSize, sampleSize); 

  //int [] lotta = new int[4];
  //for (int s = 0; s < c.length; s++) {
  //  for (Lanka l : langat) {
  //    float d = dist(l.r, l.g, l.b, red(c[s]), green(c[s]), blue(c[s]));
  //    if (d==0) {
  //      lotta[s] = l.l;
  //    }
  //  }
  //}
  //fill(255);
  //text(lotta[0], 1058+50, 50);     
  //text(lotta[1], 1058+150, 50);     
  //text(lotta[2], 1058+50, 150);     
  //text(lotta[3], 1058+150, 150);
}



void mousePressed() {
  //if(mouseY>result.height && mouseY<result.height+50){
  //pickColor = get(mouseX, mouseY);
  //}
  for (Lanka l : langat) {
         if(mouseX > l.getLeftEdge() && mouseX < l.getRightEdge() && mouseY>l.getTopEdge() && mouseY < l.getBottomEdge()){
          valittuLanka=l;
          println("lanka valittu!");
          }
  }
  
}

void mouseReleased() {

  for (Sekoitus s : sekoitukset) {
    if(s.isSelected){
         if(mouseX > s.getLeftEdge() && mouseX < s.getRightEdge() && mouseY>s.getTopEdge() && mouseY < s.getBottomEdge()){
          //s.setColor(pickColor, mouseX, mouseY);
          s.asetaLanka(valittuLanka, mouseX, mouseY);
          asetaVarit=true;
          currentMouseX=mouseX;
          currentMouseY=mouseY;
          println("aseta värit hiiri");
          }
     }
  }
  
}

void keyPressed(){
    if(keyCode == SHIFT){
  showResultEnlarged=!showResultEnlarged;
    }
        if(keyCode == ALT){
  showResult=!showResult;
    }
  if(keyCode == LEFT){
    valittuSekoitus--;
  }
  if(keyCode == RIGHT){
    valittuSekoitus++; 
  }
  if(valittuSekoitus<0){
    valittuSekoitus = 0;
  }
  if(valittuSekoitus>savyt){
    valittuSekoitus = 0;
  }
    for (Sekoitus s : sekoitukset) {
        s.deselect();   
    }
    Sekoitus update = sekoitukset.get(valittuSekoitus);
    update.select();
    
      println(valittuSekoitus);

if(key=='1'){
    println("set this color");

  for (Sekoitus s : sekoitukset) {
    if(s.isSelected){
          pickColor = get(mouseX, mouseY);
          s.setThisColor(pickColor, 0);
          }
     }
  }


}



void createGui() {

  PFont pfont = createFont("Arial", 12, true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 12);

  int x = width-350;
  int y = 20;
  cp5.addButton("Valitse")
    .setPosition(x, y)
    .setSize(195, 30)
    .setCaptionLabel("Avaa kuva")
    .setFont(font)
  ;
  y+=35;
  cp5.addSlider("tones")
    .setPosition(x, y)
    .setRange(1, maxSavyt)
    .setSize(195, 20)
    .setCaptionLabel("Sävyjen määrä")
    .setFont(font)
    .showTickMarks(true)
    .setNumberOfTickMarks(38)
    ;  
  y+=50;
  // create a new button with name 'buttonA'
  cp5.addButton("Prosessoi")
    .setPosition(x, y)
    .setSize(195, 30)
    .setCaptionLabel("Prosessoi")
    .setFont(font)
    ;
  y+=35;
    // create a new button with name 'buttonA'
  cp5.addButton("Tallenna")
    .setPosition(x, y)
    .setSize(195, 30)
    .setCaptionLabel("Tallenna")
    .setFont(font)
    ;
  y+=35;
  
  cp5.addButton("Sulje")
    .setPosition(x, y)
    .setSize(195, 30)
    .setCaptionLabel("Sulje ohjelma")
    .setFont(font);
  ;
}

public void Valitse(int theValue) {
  println("ValitseKuva "+theValue);
  selectInput("Valitse rasteroitava kuva", "fileSelected"); 
}

void tones(float res) {
  println("a slider event. resolution "+res);
  savyt = round(res);
  println("a slider event. resolution "+savyt);

}

public void Prosessoi(int theValue) {
  prosessoiKuva=!prosessoiKuva;
  println("Prosessoi Kuva ");
}

public void Tallenna(int theValue) {
  result.save("ryijy"+"-"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".png");
  String[] lines = new String[maxSavyt];

  for (int i = 0; i < savyt; i++) {
    lines[i] = "Sekoitus: "+i+"\n";
    Sekoitus s = sekoitukset.get(i);
    Lanka l[] = s.getLangat();
      String[] lankaKoodit = new String[l.length];
      for (int j = 0; j < l.length; j++) {
        lankaKoodit[j] = "LottaCode:"+l[j].l + "\t" + "TuukkaCode:"+l[j].t+"\n";
      }
      lines[i] = lankaKoodit[0]+"-"+lankaKoodit[1]+"-"+lankaKoodit[2]+"-"+lankaKoodit[3]+"\n";
//      lines[i] ="\nEi käytössä:\n"; 
  }
  saveStrings("ryijy"+"-"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+".txt", lines);
}

public void Sulje(int theValue) {
  println("Suljetaan "+theValue);
  exitApp = true;
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    //   exit();
  } else {
    println("User selected " + selection.getAbsolutePath());
    kuvanPolku = selection.getAbsolutePath();
    lataaKuva=true;
    kuvanLataus();

    prosessoiKuva=false;
    cp5.getController("Valitse").setCaptionLabel("1. Vaihda kuva");
  }
}


void kuvanLataus() {
  println("setup");
    if (lataaKuva) {
        img = loadImage(kuvanPolku);
        img.resize(img.width/2, img.height/2);
        temp = img.get();
        result = createGraphics(img.width*4, img.height*4);
        lataaKuva=false;
        prosessoiKuva=true;
    } else {
//       piirraOhje();
    }
}
