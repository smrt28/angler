/*
 *  A34.h
 *  Angler
 *
 *  Created by smrt on 2/26/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef A34_H
#define A34_H

#include <vector>

namespace al {
	
	class Error {
	public:
		Error(int id) : id(id) {}
		int id;
	};
	
	class Spot;
	typedef double Float; 
	
	
	const Float SMALL = 0.00001;
	
	class Point {
	public:
		Float x;
		Float y;
		bool cmp(Point *);
	};
	
	class LineTo
	{
	public:
				
		Spot * to;
		LineTo * next;
	};	
	
	
	class Spot
	{
	public:
		Point p;
		LineTo * first;
		LineTo * mark;
	};
	
	class Line {
	public:
		int intersection(Line *l, Point *p);
		int getAb(Float *a, Float *b);

		Point p1;
		Point p2;
	};
	
	
	class A34 {
		static const int MAX_LINES = 500;
	public:
		A34();
		void signal(int sig);
		void run();
		void cutLines();
		void addLine(Line l);
		void reset();
	
	private:
		Line lstack[MAX_LINES];
		int lstack_top;
	};
	
}

#endif