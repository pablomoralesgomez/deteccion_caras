
import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
//Máscara del rostro
import org.opencv.face.Face;
import org.opencv.face.Facemark;

Capture cam;
CVImage img;

//Detectores
CascadeClassifier face;
//Máscara del rostro
Facemark fm;
//Nombres
String faceFile, modelFile;

String[] mensaje = {"RGB Maximo", "Umbralizado"};
int selector = 0;

boolean boca = false;
int dim;

void setup() {
  size(640, 480);
  //Cámara
  cam = new Capture(this, width , height);
  cam.start(); 
  
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);
  
  //Detectores
  faceFile = "haarcascade_frontalface_default.xml";
  //Modelo de máscara
  modelFile = "face_landmark_model.dat";
  fm = Face.createFacemarkKazemi();
  fm.loadModel(dataPath(modelFile));
  
  dim = cam.width * cam.height;
}

void draw() {  
  if (cam.available()) {
    background(0);
    cam.read();
    
    if(boca) {
      switch(selector) {
        case 0:
          rgbMax();
          break;
        case 1:
          umbraliza();
          break;
      }
    }
    
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    image(img,0,0);
    
    
    Point [] pts = {};
    ArrayList<MatOfPoint2f> shapes = detectFacemarks(cam);
    PVector origin = new PVector(0, 0);
    for (MatOfPoint2f sh : shapes) {
        pts = sh.toArray();
        //drawFacemarks(pts, origin);
    }
    
    boca = bocaAbierta(pts, origin);
  }
  
  pushMatrix();
  stroke(0);
  fill(128);
  rect(width/30, height/30, width/5*1.5, height/30 * 3);
  
  fill(0);
  text(mensaje[selector], width/29 *3.5, height/30 *2.65);
  
  triangle(width/29 *1.5, height/33 * 2.83, width/29 *1.7, height/33 * 3.03,  width/29 *1.7, height/33 * 2.63);
  triangle(width/5*1.53, height/33 * 2.83, width/5*1.5, height/33 * 3.03,width/5*1.5, height/33 * 2.63);
  popMatrix();
}

void keyPressed() {
  if (key == CODED && keyCode == RIGHT) {
    selector++;
    if(selector > 1) selector = 0;
  }
  if (key == CODED && keyCode == LEFT) {
    selector--;
    if(selector < 0) selector = 1;
  }
}

void umbraliza() {
  for (int i = 0; i < dim; i++) {
      float  suma=red(cam.pixels[i])+green(cam.pixels[i])+blue(cam.pixels[i]);
      
      if (suma<255*1.5) {
        cam.pixels[i]=color(0, 0, 0);
      } else {
        cam.pixels[i]=color(255, 255, 255);
      }
  }
  cam.updatePixels();
}

void rgbMax() {
  for (int i = 0; i < dim; i++) {
    
    if(red(cam.pixels[i]) >= blue(cam.pixels[i])) {
      if(red(cam.pixels[i]) >= green(cam.pixels[i])) {
        cam.pixels[i]=color(255, 0, 0);
        
      } else {
        cam.pixels[i]=color(0, 255, 0);
      } 
    } else {
      if(blue(cam.pixels[i]) >= green(cam.pixels[i])) {
        cam.pixels[i]=color(0, 0, 255);
        
      } else {
        cam.pixels[i]=color(0, 255, 0);
      }
    }
  }
  cam.updatePixels();
}

boolean bocaAbierta(Point [] p, PVector o) {
  if(p.length >= 68) return p[67].y + o.y -( p[61].y + o.y) > 10  && p[66].y + o.y -( p[62].y + o.y) > 10 && p[65].y + o.y -( p[63].y + o.y) > 10;
  return false;
}

private ArrayList<MatOfPoint2f> detectFacemarks(PImage i) {
  ArrayList<MatOfPoint2f> shapes = new ArrayList<MatOfPoint2f>();
  CVImage im = new CVImage(i.width, i.height);
  im.copyTo(i);
  MatOfRect faces = new MatOfRect();
  Face.getFacesHAAR(im.getBGR(), faces, dataPath(faceFile)); 
  if (!faces.empty()) {
    fm.fit(im.getBGR(), faces, shapes);
  }
  return shapes;
}
/*
private void drawFacemarks(Point [] p, PVector o) {
  pushStyle();
  noStroke();
  fill(255);
  for (int i = 0; i < p.length; i++) {
    ellipse((float)p[i].x + o.x, (float)p[i].y + o.y, 3, 3);
    if(i == 64) {
      fill(0);
      ellipse((float)p[i].x + o.x, (float)p[i].y + o.y, 3, 3);
      fill(255);
    }
    
  }
  popStyle();
}*/
