void setup(){
 size(1800,1000); 
 field=loadImage("data/Capture.PNG");
  println(width/2-field.width/2);
}

PImage field;
float fieldX0=442,fieldY0=930,fieldXmax=1359,fieldYmax=11,segmentDist=1,hubexclousionRadious=11;
ArrayList<Point> path = new ArrayList<Point>(),path2;
boolean validPath=false,point1=false,point2=false;
Point start,end;

void draw(){

  background(250);
  image(field,width/2-field.width/2,0);
  stroke(#1FF600);
  strokeWeight(2);
  line(fieldX0,fieldYmax,fieldX0,fieldY0);
  line(fieldX0,fieldY0,fieldXmax,fieldY0);
  line(fieldXmax,fieldYmax,fieldXmax,fieldY0);
  line(fieldX0,fieldYmax,fieldXmax,fieldYmax);
  strokeWeight(0);
  fill(#FF3B76,127.5);
  rect(fieldToScreenX(13.68),fieldToScreenY(99.5),fieldToScreenX(116.32)-fieldX0,fieldY0-fieldToScreenY(5.77));
  rect(fieldToScreenX(44.6),fieldToScreenY(130.2),fieldToScreenX(5.77)-fieldX0,fieldY0-fieldToScreenY(30.75));
  rect(fieldToScreenX(93.75),fieldToScreenY(130.2),fieldToScreenX(5.77)-fieldX0,fieldY0-fieldToScreenY(30.75));
  fill(#1F33FF,127);
  ellipse(fieldToScreenX(72),fieldToScreenY(120),fieldToScreenX(18)-fieldX0,fieldY0-fieldToScreenY(18));
  ellipse(fieldToScreenX(48),fieldToScreenY(60),fieldToScreenX(18)-fieldX0,fieldY0-fieldToScreenY(18));
  ellipse(fieldToScreenX(96),fieldToScreenY(60),fieldToScreenX(18)-fieldX0,fieldY0-fieldToScreenY(18));
  
  strokeWeight(2);
  stroke(#A700C1);
  if(validPath){
   for(int i=0;i<path.size()-1;i++){
    line(fieldToScreenX((float)path.get(i).x),fieldToScreenY((float)path.get(i).y),fieldToScreenX((float)path.get(i+1).x),fieldToScreenY((float)path.get(i+1).y));
   }
   
   stroke(#362BB9);
   for(int i=0;i<path2.size()-1;i++){
    line(fieldToScreenX((float)path2.get(i).x),fieldToScreenY((float)path2.get(i).y),fieldToScreenX((float)path2.get(i+1).x),fieldToScreenY((float)path2.get(i+1).y));
   }
  }
  
  
  if(mouseX>=fieldX0&&mouseX<=fieldXmax&&mouseY>=fieldYmax&&mouseY<=fieldY0){
    strokeWeight(2);
    stroke(#FF8503);
    line(fieldX0,mouseY,fieldXmax,mouseY);
    line(mouseX,fieldY0,mouseX,fieldYmax);
    fill(0);
    textSize(40);
    text("("+screenToFieldX(mouseX)+","+screenToFieldY(mouseY)+")",1400,100);
  }
  
  fill(200);
  strokeWeight(0);
  rect(50,100,200,200);
  fill(0);
  textSize(50);
  text(segmentDist,100,150);
  textSize(30);
  text("segment distance\n(scroll here)",60,180);
}

float screenToFieldX(float x){
  //max=144
  x-=fieldX0;
  x/=fieldXmax-fieldX0;
  x*=144;
  return x;
}
float screenToFieldY(float y){
  //max=144
  y-=fieldY0;
  y/=fieldYmax-fieldY0;
  y*=144;
  return y;
}

float fieldToScreenX(float x){
  //max=144
  x/=144;
  x*=fieldXmax-fieldX0;
  x+=fieldX0;
  return x;
}
float fieldToScreenY(float y){
  //max=144
  y/=144;
  y*=fieldYmax-fieldY0;
  y+=fieldY0;
  return y;
}

void mouseClicked(){
  if(mouseX>=fieldX0&&mouseX<=fieldXmax&&mouseY>=fieldYmax&&mouseY<=fieldY0){//if mouse inside the field
    if(point1==false){
      point1=true;
      start=new Point(screenToFieldX(mouseX),screenToFieldY(mouseY),"");
      validPath=false;
      println("point 1 "+start.x+" "+start.y);
    }else{
      point1=false;
      end=new Point(screenToFieldX(mouseX),screenToFieldY(mouseY),"");
      
      path = createPath(start,end);
      path2=optimisePath1(path);
      println();
      for(int i=0;i<path2.size();i++){
       println("point "+i+" "+path2.get(i).x+" "+path2.get(i).x);
      }
      validPath=true;
    }
  }
}

boolean insideHub(Point p){
 if(Math.sqrt(Math.pow(p.x-72,2)+Math.pow(p.y-120,2))<=hubexclousionRadious){
   return true;
 }
 if(Math.sqrt(Math.pow(p.x-48,2)+Math.pow(p.y-60,2))<=hubexclousionRadious){
   return true;
 }
 if(Math.sqrt(Math.pow(p.x-96,2)+Math.pow(p.y-60,2))<=hubexclousionRadious){
   return true;
 }
  return false;
}

boolean insideBarrierH(Point p){
  //13.68 99.5 116.32 5.77
  if(p.x>=13.68&&p.x<=13.68+116.32&&p.y>=99.5-5.77&&p.y<=99.5){
    return true;
  }
  return false;
}
boolean insideBarrierVL(Point p){
  //13.68 99.5 116.32 5.77
  if(p.x>=44.6&&p.x<=44.6+5.77&&p.y>=130.2-30.75&&p.y<=130.2){
    return true;
  }
  return false;
}
boolean insideBarrierVR(Point p){
  //13.68 99.5 116.32 5.77
  if(p.x>=93.75&&p.x<=93.75+5.77&&p.y>=130.2-30.75&&p.y<=130.2){
    return true;
  }
  return false;
}

ArrayList<Point> createPath(Point start,Point end){
 ArrayList<Point> p=new ArrayList<Point>();
       p.add(start);
      boolean working=true;
      int itteration=0;
      while(working){
        float angle=atan2((float)(end.y-p.get(p.size()-1).y),(float)(end.x-p.get(p.size()-1).x));
        Point work;
        do{
          
        work =new Point(cos(angle)*segmentDist+p.get(p.size()-1).x,sin(angle)*segmentDist+p.get(p.size()-1).y,"");
        angle += 0.01;
        
        }while(insideHub(work));
        if(insideBarrierH(work)){
          ArrayList<Point> temp;
          
          if(angle>0){
            if(work.x>72){
             temp=createPath(p.get(p.size()-1),new Point(137,92,""));
            }else{
              temp=createPath(p.get(p.size()-1),new Point(6,92,""));
            }
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
            if(work.x>72){
             temp=createPath(p.get(p.size()-1),new Point(137,104,""));
            }else{
              temp=createPath(p.get(p.size()-1),new Point(6,104,""));
            }
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
          }else{
          if(work.x>72){
             temp=createPath(p.get(p.size()-1),new Point(137,104,""));
            }else{
              temp=createPath(p.get(p.size()-1),new Point(6,104,""));
            }
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
            if(work.x>72){
             temp=createPath(p.get(p.size()-1),new Point(137,92,""));
            }else{
              temp=createPath(p.get(p.size()-1),new Point(6,92,""));
            }
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
          }
        }else if (insideBarrierVL(work)){//path arround the left verticle barrier
          ArrayList<Point> temp;
          if(angle<Math.PI/2&&angle>-Math.PI/2){
            temp=createPath(p.get(p.size()-1),new Point(42,137,""));
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
            temp=createPath(p.get(p.size()-1),new Point(54,137,""));
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
          }else{
            temp=createPath(p.get(p.size()-1),new Point(54,137,""));
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
            temp=createPath(p.get(p.size()-1),new Point(42,137,""));
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            } 
          }
          
        }else if (insideBarrierVR(work)){//path arropunf the right varticle barrier
          ArrayList<Point> temp;
          if(angle>Math.PI/2||angle<-Math.PI/2){
            temp=createPath(p.get(p.size()-1),new Point(101,137,""));
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
            temp=createPath(p.get(p.size()-1),new Point(91,137,""));
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
          }else{
            temp=createPath(p.get(p.size()-1),new Point(91,137,""));
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            }
            temp=createPath(p.get(p.size()-1),new Point(101,137,""));
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));
            } 
          }
        }else{
        p.add(work);
        }
        if(Math.sqrt(Math.pow(end.x-p.get(p.size()-1).x,2)+Math.pow(end.y-p.get(p.size()-1).y,2))<segmentDist)
          working=false;
          
        println("point "+p.size()+" "+p.get(p.size()-1).x+" "+p.get(p.size()-1).y);
        itteration++;
        if(itteration>1000){
          return null;
        }
      }
      path.add(end);
      println("point "+p.size()+" "+end.x+" "+end.y);
 return p;
}

void mouseWheel(MouseEvent event) {
  float wheel_direction = event.getCount()*-0.5;
  if(wheel_direction<0&&segmentDist==1)
  return;
  if(mouseX>=50&&mouseX<=250&&mouseY>=100&&mouseY<=300){
  segmentDist+=wheel_direction;
  }
  
  
}

/**the first step in optimising a path, this function reduces the numbers of point in a path by detecting straight lines and removing the points that make them up
@param p the path that you want to optimise
@return a path that contains less points
*/
ArrayList<Point> optimisePath1(ArrayList<Point> p){
  ArrayList<Point> o=new ArrayList<Point>();//the object to return
  o.add(p.get(0));//add the first point of the path to the new path
  int beginindex=0;
  double devation=0.01;//how far(in radians) is a line allowed to lean in either direction bfore it is consited a new line
  double angle=Math.atan2(p.get(1).y-p.get(0).y,p.get(1).x-p.get(0).x);//calcuate the inital angle that the line is going in
  for(int i=1;i<p.size();i++){
    double newAngle=Math.atan2(p.get(i).y-p.get(beginindex).y,p.get(i).x-p.get(beginindex).x);//calculate the angle between the base point of the current line and the next point in the list
    if(newAngle>=angle-devation&&newAngle<=angle+devation){//if the angle is inside the acceptable range
      continue;
    }else{
      o.add(p.get(i-1));//add the prevous point to the optimsed path
      beginindex=i;//set the current point as the new base point
       angle=Math.atan2(p.get(i).y-p.get(i-1).y,p.get(i).x-p.get(i-1).x);//calculate the new angle of the next    line 
    }
  }
  o.add(p.get(p.size()-1));//add the  final point to the new path
  return o;
}
