lc = 1;


Point(1) = {0,0,0,lc};
Point(2) = {0,20,0,lc};
Point(3) = {100,20,0,lc};
Point(4) = {100,0,0,lc};
Point(5) = {60,0,0,lc};
Point(6) = {60,-100,0,lc};
Point(7) = {40,-100,0,lc};
Point(8) = {40,0,0,lc};


Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,5};
Line(5) = {5,6};
Line(6) = {6,7};
Line(7) = {7,8};
Line(8) = {8,1};


Curve Loop(1) = {1,2,3,4,5,6,7,8};


Plane Surface(1) = {1};
//+
SetFactory("Built-in");
