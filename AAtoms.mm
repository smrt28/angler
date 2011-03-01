/*
 *  AAtoms.cpp
 *  Angler
 *
 *  Created by smrt on 2/27/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "AAtoms.h"

namespace al {
	

#define dcmp(x, y) ((x)+SMALL > y && (x)-SMALL < y)
	
	bool Point::cmp(Point *p) {
		if (dcmp(p->x, x) && dcmp(p->y, y)) return true;
		return false;
	}
	
	bool Point::inLineWith(Point &p1, Point &p2) {
		Float a, b;
		Float x1, y1, x2, y2;
		
		x1 = p1.x - x;
		y1 = p1.y - y;
		x2 = p2.x - p1.x;
		y2 = p2.y - p1.y;
		
		a = (x1 * y2);	
		b = (x2 * y1);
		
		if (dcmp(a, b))	return true;
		return false;
	}
	
	bool Line::hasPoint(Point &p) {
		return p.x+SMALL >= MIN(p1.x, p2.x) && p.x-SMALL <= MAX(p1.x, p2.x) &&
		p.y+SMALL >= MIN(p1.y, p2.y) && p.y-SMALL <= MAX(p1.y, p2.y);
	
	}
	
	
	void Line::abc(Float *A, Float *B, Float *C) {
		*A = p2.y - p1.y;
		*B = p1.x - p2.x;
		*C = *A * p1.x + *B * p1.y;
	}
	
	int Line::cutMe(Line *l, Line *out, Point *pout) {
		Float a1, b1, c1;
		Float a2, b2, c2;
		abc(&a1, &b1, &c1);
		l->abc(&a2, &b2, &c2);
		Float det = a1*b2 - a2*b1;
		
		Point p;
		int rv = 0;
		
		if (det == 0) {
			return 0;
		} else {
			p.x = (b2*c1 - b1*c2)/det;
			p.y = (a1*c2 - a2*c1)/det;
		}
		
		if (! (hasPoint(p) && l->hasPoint(p)) ) 
				return 0;
		
		if (p.cmp(&p1) || p.cmp(&p2)) {
			
			
		} else {
		
			out[rv] = Line(p1, p);
			rv++;
			
			p1 = p;
		}
		
		if (p.cmp(&l->p1) || p.cmp(&l->p2)) {
			
			
		} else {
		
			out[rv] = Line(l->p1, p);
			rv++;
			
			l->p1 = p;
		}
		
		if (pout)
			*pout = p;
		
		return rv;
	}
	
	
}