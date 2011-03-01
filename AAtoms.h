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
	
	class Error {
	public:
		Error(int id) : id(id) {}
		int id;
	};
	
	typedef double Float; 
	
	const Float SMALL = 0.00001;
	
	class Point {
	public:
		Point() {}
		Point(Float x, Float y) : x(x), y(y) {}
		Float x;
		Float y;
		bool cmp(Point *);
		bool inLineWith(Point &p1, Point &p2);
	};
	
	class Line {
	public:
		Line() {}
		Line(const Point &p1, const Point &p2) : p1(p1), p2(p2) {}
		bool hasPoint(Point &p);
		int cutMe(Line *l, Line *out, Point *pout);
		Point p1;
		Point p2;
		
	private:
		void abc(Float *A, Float *B, Float *C);
	};
	
	
}

#endif