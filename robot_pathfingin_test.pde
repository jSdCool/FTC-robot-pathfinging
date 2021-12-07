import java.util.*;
void setup(){
 size(1800,1000); 
 field=loadImage("data/Capture.PNG");
  println(width/2-field.width/2);
}

PImage field;
float fieldX0=442,fieldY0=930,fieldXmax=1359,fieldYmax=11,segmentDist=1,hubexclousionRadious=11;
ArrayList<Position> path = new ArrayList<Position>(),path2,path3;
boolean validPath=false,point1=false,point2=false;
Position start,end;
ArrayList<ArrayList<Position>> tp=new ArrayList();
int viewPath=0;

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
    line(fieldToScreenX((float)path.get(i).location.x),fieldToScreenY((float)path.get(i).location.y),fieldToScreenX((float)path.get(i+1).location.x),fieldToScreenY((float)path.get(i+1).location.y));
   }
   
   stroke(#362BB9);
   for(int i=0;i<path2.size()-1;i++){
    line(fieldToScreenX((float)path2.get(i).location.x),fieldToScreenY((float)path2.get(i).location.y),fieldToScreenX((float)path2.get(i+1).location.x),fieldToScreenY((float)path2.get(i+1).location.y));
   }
   stroke(#08BFFF);
   for(int i=0;i<path3.size()-1;i++){
    line(fieldToScreenX((float)path3.get(i).location.x),fieldToScreenY((float)path3.get(i).location.y),fieldToScreenX((float)path3.get(i+1).location.x),fieldToScreenY((float)path3.get(i+1).location.y));
   }
   
   if(tp.size()>0){
    if(viewPath>tp.size()-1){
     viewPath=0; 
    }
    stroke(#FF0000);
   for(int i=0;i<tp.get(viewPath).size()-1;i++){
    line(fieldToScreenX((float)tp.get(viewPath).get(i).location.x),fieldToScreenY((float)tp.get(viewPath).get(i).location.y),fieldToScreenX((float)tp.get(viewPath).get(i+1).location.x),fieldToScreenY((float)tp.get(viewPath).get(i+1).location.y));
   }
   fill(0);
   textSize(40);
   text(pathlength(tp.get(viewPath))+"",1400,300);
   
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
  if(mouseButton==LEFT){
  if(mouseX>=fieldX0&&mouseX<=fieldXmax&&mouseY>=fieldYmax&&mouseY<=fieldY0){//if mouse inside the field
    if(point1==false){
      point1=true;
      start=new Position(new Point(screenToFieldX(mouseX),screenToFieldY(mouseY),""),0);
      validPath=false;
    }else{
      tp=new ArrayList();
      point1=false;
      end=new Position(new Point(screenToFieldX(mouseX),screenToFieldY(mouseY),""),0);
      
      path = createPath(start,end);
      println(path.size());
      path2=optimisePath1(path);
      println(path2.size());
      path3=optimisePath2(path2);
      validPath=true;
      println(path.size()+" "+path2.size()+" "+path3.size());
      
    }
  }
  }
  if(mouseButton==RIGHT){
   viewPath++; 
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

/**generates a path as an array llist of points that goes from start to end without running into any obsticals
     *
     * @param start the point to start the path at (usualy the robots current position)
     * @param end the point to end the path at
     * @return an arraylist of points that form a path between the provided point
     */
ArrayList<Position> createPath(Position start,Position end){
 ArrayList<Position> p=new ArrayList<Position>();
       p.add(start);
      boolean working=true;
      int itteration=0;
      double anglein=start.rotation;
      while(working){
        double angle=Math.atan2((end.location.y-p.get(p.size()-1).location.y),(end.location.x-p.get(p.size()-1).location.x));//find the absoult angle to the next point in a straightvliine to the end point
        Point work;
        do{
          
        work =new Point(Math.cos(angle)*segmentDist+p.get(p.size()-1).location.x,Math.sin(angle)*segmentDist+p.get(p.size()-1).location.y,"");//create the next point
        angle += 0.01;//add 0.01 radians to the teroretical angle
        
        }while(insideHub(work));//if the created point was indide of a hub then calcuate the point again with the new agale and check again
        if(insideBarrierH(work)){//if the  calculated point is inside the horozontal barrier
          ArrayList<Position> temp;//create a temporary array list of points
          
          if(angle>0){//if the robot is heading up ish
            if(work.x>72){//if it is on the right side of the field
             temp=createPath(p.get(p.size()-1).setRotation(Math.PI),new Position(new Point(137,92,""),Math.PI));//crate a path that goes to a pre defined point at the side of the barrier
            }else{
              temp=createPath(p.get(p.size()-1).setRotation(0),new Position(new Point(6,92,""),0));//crate a path that goes to a pre defined point at the side of the barrier
            }
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge generated path into the current working path
            }
            if(work.x>72){//if it is on the right side of the fiels
             temp=createPath(p.get(p.size()-1).setRotation(Math.PI),new Position(new Point(137,104,""),Math.PI));//make a path going past the barrier
            }else{
              temp=createPath(p.get(p.size()-1).setRotation(0),new Position(new Point(6,104,""),0));//make a path going past the barrier
            }
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge path into main path
            }
          }else{//if the robot is heading down ish
          if(work.x>72){//if it is on the right
             temp=createPath(p.get(p.size()-1).setRotation(Math.PI),new Position(new Point(137,104,""),Math.PI));//crate a path that goes to a pre defined point at the side of the barrier
            }else{
              temp=createPath(p.get(p.size()-1).setRotation(0),new Position(new Point(6,104,""),0));//crate a path that goes to a pre defined point at the side of the barrier
            }
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            }
            if(work.x>72){//if on the right side of the field
             temp=createPath(p.get(p.size()-1).setRotation(Math.PI),new Position(new Point(137,92,""),Math.PI));//make a path going past the barrier
            }else{
              temp=createPath(p.get(p.size()-1).setRotation(0),new Position(new Point(6,92,""),0));//make a path going past the barrier
            }
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            }
          }
        }else if (insideBarrierVL(work)){//path arround the left verticle barrier
          ArrayList<Position> temp;
          if(angle<Math.PI/2&&angle>-Math.PI/2){//if it is heading right
            temp=createPath(p.get(p.size()-1).setRotation(-Math.PI/2),new Position(new Point(42,137,""),-Math.PI/2));//crate a path that goes to a pre defined point at the side of the barrier
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            }
            temp=createPath(p.get(p.size()-1).setRotation(-Math.PI/2),new Position(new Point(54,137,""),-Math.PI/2));//make a path going past the barrier
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            }
          }else{//if the robot in heading left
            temp=createPath(p.get(p.size()-1).setRotation(-Math.PI/2),new Position(new Point(54,137,""),-Math.PI/2));//crate a path that goes to a pre defined point at the side of the barrier
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            }
            temp=createPath(p.get(p.size()-1).setRotation(-Math.PI/2),new Position(new Point(42,137,""),-Math.PI/2));//make a path going past the barrier
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            } 
          }
          
        }else if (insideBarrierVR(work)){//path arropunf the right varticle barrier
          ArrayList<Position> temp;
          if(angle>Math.PI/2||angle<-Math.PI/2){//if the robot is heading left
            temp=createPath(p.get(p.size()-1).setRotation(-Math.PI/2),new Position(new Point(101,137,""),-Math.PI/2));//crate a path that goes to a pre defined point at the side of the barrier
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            }
            temp=createPath(p.get(p.size()-1).setRotation(-Math.PI/2),new Position(new Point(91,137,""),-Math.PI/2));//make a path going past the barrier
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            }
          }else{
            temp=createPath(p.get(p.size()-1).setRotation(-Math.PI/2),new Position(new Point(91,137,""),-Math.PI/2));//crate a path that goes to a pre defined point at the side of the barrier
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            }
            temp=createPath(p.get(p.size()-1).setRotation(-Math.PI/2),new Position(new Point(101,137,""),-Math.PI/2));//make a path going past the barrier
            for(int i=0;i<temp.size();i++){
              p.add(temp.get(i));//merge the temporary path into the main path
            } 
          }
        }else{
        p.add(new Position(work,anglein));//add the current working point to the path
        }
        if(Math.sqrt(Math.pow(end.location.x-p.get(p.size()-1).location.x,2)+Math.pow(end.location.y-p.get(p.size()-1).location.y,2))<segmentDist)//if the point is less than the distacne of the segments from the end point
          working=false;//tell the loop to stop
          

        itteration++;//increase the itteration
        if(itteration>1000){//if the program is stuck in an infinite loop(too many itterations)
          return null;
        }
      }
      p.add(end);//add the final point to the path
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
ArrayList<Position> optimisePath1(ArrayList<Position> p){
  ArrayList<Position> o=new ArrayList<Position>();//the object to return
  o.add(p.get(0));//add the first point of the path to the new path
  int beginindex=0;
  double devation=0.01;//how far(in radians) is a line allowed to lean in either direction bfore it is consited a new line
  double angle=Math.atan2(p.get(1).location.y-p.get(0).location.y,p.get(1).location.x-p.get(0).location.x);//calcuate the inital angle that the line is going in
  for(int i=1;i<p.size();i++){
    double newAngle=Math.atan2(p.get(i).location.y-p.get(beginindex).location.y,p.get(i).location.x-p.get(beginindex).location.x);//calculate the angle between the base point of the current line and the next point in the list
    if(newAngle>=angle-devation&&newAngle<=angle+devation){//if the angle is inside the acceptable range
      continue;
    }else{
      o.add(p.get(i-1));//add the prevous point to the optimsed path
      beginindex=i;//set the current point as the new base point
       angle=Math.atan2(p.get(i).location.y-p.get(i-1).location.y,p.get(i).location.x-p.get(i-1).location.x);//calculate the new angle of the next line 
    }
  }
  o.add(p.get(p.size()-1));//add the  final point to the new path
  return o;
}

/**the seccond step in optomizing paths this function generates paths between point in a given path to see if it can find a shorter path between them
@param p the path that you want to optimise that has been run through optimisePath1
@return a path that has a shorter overall travel
*/
ArrayList<Position> optimisePath2(ArrayList<Position> path){
  ArrayList<Position> p=new ArrayList(path);//copy the input path

  if(p.size()==2){//if the path only consists of 2 points then the path can not be optimised so do nothing
    return p;
  }
  
  ArrayList<Position> o=new ArrayList<Position>();//the object to return

  for(int i=0;i<p.size()-1;){//seek through the path
   int curbest=i+1,sigbest=-1; 
   for(int j=i+1;j<p.size();j++){//check every point in the path ahead of this point
     double l1,l2;
     ArrayList<Position> temp=new ArrayList<Position>(),temp2;//create temporary paths
     for(int n=i;n<=j;n++){//make the temp paht the section of the main path between the 2 points
      temp.add(p.get(n)); 
     }
     temp2=optimisePath1(createPath(p.get(i),p.get(j)));//generate a new path directly between the 2 selected points
     l1=pathlength(temp2);
     l2=pathlength(temp);
     tp.add(temp2);
     if(l1<l2){//compair the lengths of the paths, if the new path is less than the orginal 
       curbest=j;//set the current best index to j
       if(sigbest==-1){//if the best siginificant is -1 then set it to the current best
         sigbest=curbest;
       }
     }
     
     if(l1<=l2*0.7){//if this path is siginificanly shorter then the old best then set sigbest to this path      this value may need to be tweeked
       sigbest=j;
     }
     
   }//end of loop
   if(sigbest==-1){//if the best siginificant is -1 then set it to the current best
     sigbest=curbest;
   }
   ArrayList<Position> temp=new ArrayList<Position>();//create a temp path
   temp=optimisePath1(createPath(p.get(i),p.get(sigbest)));//set the temp path to the new best path
   for(int j=0;j<temp.size();j++){
     o.add(temp.get(j));//add the new best path to the output
   }
   i=sigbest;
  }
  
  return o;
}

/*gets the total travel distance of a path
@param p the path you wnat the length of
@return the lengtgh of the path
*/
double pathlength(ArrayList<Position> p){
 double length=0;
 for(int i=0;i<p.size()-1;i++){
   length+=Math.sqrt(Math.pow(p.get(i+1).location.y-p.get(i).location.y,2)+Math.pow(p.get(i+1).location.x-p.get(i).location.x,2));
 }
 return length;
}
