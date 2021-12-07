public class Point {
    protected double x;
    protected double y;
    protected String name;
    Point(double X,double Y,String Name){
        x=X;
        y=Y;
        name=Name;
    }
    void setX(double X){
        x=X;
    }
    void setY(double Y){
        y=Y;
    }
}

public class Position {

    /** Stores an x/y coordinate.
     *  @see Point for more information
     */
    public Point location;
    public double rotation;
    
    Position(Point p,double r){
     rotation=r;
     location=p;
    }

    public boolean equals(Position a) {
        return a.location.x == this.location.x && a.location.y == this.location.y;
    }
    
    public Position setRotation(double rot){
      rotation=rot;
      return this;
    }
}
