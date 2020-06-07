import drop.*;
import test.*;

SDrop drop;
StringList targetPath;
String targetName;
PImage img;
int posx;
int posy;
int sizex;
int sizey;
String log="start log";
String workLog="Waiting...";

void setup() {
  targetPath=new StringList();
  drop=new SDrop(this);
  surface.setAlwaysOnTop(true);
  size(200, 200);
  String[] setup=loadStrings("data/setup.txt");
  posx=int(setup[0].substring(5));
  posy=int(setup[1].substring(5));
  sizex=int(setup[2].substring(6));
  sizey=int(setup[3].substring(6));
}

void draw() {
  background(0);
  if (targetPath.size()>0)
    println("workspace: ", targetPath);
  if (img==null) {
    if (targetPath.size()>0) {
      String target=targetPath.get(0);
      int index=target.lastIndexOf('/');
      targetName=target.substring(index+1);
      targetPath.remove(0);
      println("target to work:"+target);
      img=requestImage(target);
    } else {
      log="Empty workspace\nDrop images here";
    }
  } else {
    if (img.width==0) {
      // image is not yet loaded
      log="On working...";
    } else if (img.width==-1) {
      // error occurred
      log="Error occurred";
      workLog="Load image failed:\n"+targetName;
      targetName=null;
      img=null;
    } else { // ready to go
      log="cropping...";
      PGraphics pg=createGraphics(sizex, sizey);
      pg.beginDraw();
      pg.image(img, -posx, -posy);
      pg.save("result/"+targetName);
      pg.endDraw();
      workLog="crop well :)\n"+targetName;
      pg=null;
      targetName=null;
      img=null;
    }
  }
  text(log, 0, 0, width, height/2);
  text(workLog, 0, height/2, width, height/2);
}

void dropEvent(DropEvent theDropEvent) {
  if (theDropEvent.isImage())
    targetPath.append(trim(theDropEvent.url().substring(7)));
  else {
    File[] targets=theDropEvent.file().listFiles();
    for (int i=0, j=targets.length; i<j; i++) {
      targetPath.append(trim(targets[i].toString()));
    }
  }
}
