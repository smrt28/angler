/*
 *  AAtoms.h
 *  Angler
 *
 *  Created by smrt on 2/27/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef AATOMS_H
#define AATOMS_H

#include <vector>
namespace al {
	
	typedef double Float; 
	
	const Float SMALL = 0.0001;
	
	class Point {
	public:
		Point() {}
		Point(Float x, Float y) : x(x), y(y) {}
		Float x;
		Float y;
		bool cmp(Point *);
        bool cmp(Point &p) { return cmp(&p); }
		bool inLineWith(Point &p1, Point &p2);
	};
	
	class Line {
	public:
		Line() {}
		
        Line(const Point &p1, const Point &p2) : p1(p1), p2(p2) {}
        
        bool rmOverlap(Line &l);
        
		bool hasPoint(Point &p);
        bool hasPoint2(Point &p);
		int cutMe(Line *l, Line *out, Point *pout);
        
        bool cmp(Line *l) { return l->p1.cmp(&p1) && l->p2.cmp(&p2); }
        
		Point p1;
		Point p2;
		
	private:
		void abc(Float *A, Float *B, Float *C);
	};
	
	
}

#endif