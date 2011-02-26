/*
 *  A34.cpp
 *  Angler
 *
 *  Created by smrt on 2/26/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "A34.h"

namespace al {
	
	#define MAX(x, y)	((x) > (y) ? (x) : (y))
	#define MIN(x, y)	((x) < (y) ? (x) : (y))
	#define dcmp(x, y) ((x)+SMALL > y && (x)-SMALL < y)

	bool Point::cmp(Point *p) {
		if (dcmp(p->x, x) && dcmp(p->y, y)) return true;
		return false;
	}
	
	
	int Line::getAb(double *a, double *b)
	{
		Float vx, vy;
		
		vx = p2.x - p1.x;
		vy = p2.y - p1.y;
		
		if (dcmp(vx, 0)) 
		{
			*a = p1.x;
			return 1;
		}
		*a = vy / vx;
		*b = p2.y - (*a * p2.x);
		return 0;
	}
	
	int Line::intersection(Line * l2, Point *p)
	{
		int n1, n2;
		Float a1, b1, a2, b2;
		
		int ret = 0;
		
		n1 = getAb(&a1, &b1);
		n2 = l2->getAb(&a2, &b2);
		
		if (dcmp(a1, a2)) return 0; // jsou rovnobezne!
		
		if (n1)
		{
			p->x = a1;
			p->y = a2 * p->x + b2;
		} else if (n2)
		{
			p->x = a2;
			p->y = a1 * p->x + b1;
		} else
		{
			p->x = (b2 - b1) / (a1 - a2);
			p->y = a1 * p->x + b1;
		}
		if (MIN(p1.x, p2.x) < p->x + SMALL &&
            MAX(p1.x, p2.x) > p->x - SMALL &&
			
            MIN(p1.y, p2.y) < p->y + SMALL &&
            MAX(p1.y, p2.y) > p->y - SMALL &&
			
            MIN(l2->p1.x, l2->p2.x) < p->x + SMALL &&
            MAX(l2->p1.x, l2->p2.x) > p->x - SMALL &&
			
            MIN(l2->p1.y, l2->p2.y) < p->y + SMALL &&
            MAX(l2->p1.y, l2->p2.y) > p->y - SMALL )
		{
			
			if (!(p1.cmp(p) || p2.cmp(p)))
				ret |= (1 << 1);
			
			if (!(l2->p1.cmp(p) || l2->p2.cmp(p)))
				ret |= (1 << 0);
		}
		return ret;
	}
	
	
	A34::A34() {
		lstack_top = 0;
	}
	
	void A34::addLine(Line l) {
		if (lstack_top >= MAX_LINES)
			throw Error(__LINE__);
		lstack[lstack_top] = l;
		lstack_top++;
	}
	
	void A34::cutLines() {
		Line l1, l2;
		Line * l;
		Point p;
		int r, i, j;
		
		for (i=0;i<lstack_top;i++)
		{
			l = &lstack[i];
			for (j=0;j<lstack_top;j++)
			{
				r = l->intersection(&lstack[j], &p);
				if (r & (1 << 1))
				{
					l1.p1 = l->p1;
					l1.p2 = p;
					
					l2.p1 = p;
					l2.p2 = l->p2;
					*l = l1;
					
					addLine(l2);
					i--; break;
				} 
			}
		}
	}
	
	void A34::run() {
		cutLines();
	}
	
	void A34::signal(int sig) {
		if (sig == 49) {
			run();
		}
		
	}

}




