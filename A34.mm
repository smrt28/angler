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

	A34::A34(): A(4){
	}

	
	A34::~A34() {
		freeVector(lines);
		freeVector(spots);
	}
	
	void A34::pushLine(Line l) {
		Line *ll = new Line(l);
		lines.push_back(ll);
	}
	
	
	void A34::cut() {
		Line *l, out[2];
		int i, j, tmp, rv, k;
		i = 0;
		while(i<lines.size()) {
			tmp = lines.size();
			l = lines[i];
			for(j=i+1;j<tmp;j++) {
				rv = l->cutMe(lines[j], out, 0);
				lines[i] = l;
				for(k=0;k<rv;k++) {
					Line *nl = new Line(out[k]);
					lines.push_back(nl);
				}
			}
			
			i++;
		}
		NSLog(@"lines: %d", lines.size());
	}
	
	Spot * A34::getSpot(Point &p) {
		size_t i, size;
		size = spots.size();
		
		for(i=0;i<size;i++) {
			if (spots[i]->p.cmp(&p)) {
				return spots[i];
			}
		}
		Spot *rv = new Spot(p);
		spots.push_back(rv);
		return rv;
	}
	
	Spot::~Spot() {
		LineTo *tmp;
		LineTo * lt = first;
		while (lt) {
			tmp = lt->next;
			delete lt;
			lt = tmp;
		}
	}
	
	bool Spot::isConnected(Spot *spot) {
		LineTo * lt = spot->first;
		while (lt) {
			if (lt->to == this)
				return true;
			lt = lt->next;
		}
		return false;
	}
	
	void Spot::connect(Spot *spot) {
		if (isConnected(spot)) return;
		
		LineTo *lt;
		lt = new LineTo();
		lt->to = this;
		lt->next = spot->first;
		spot->first = lt;
		
		lt = new LineTo();
		lt->to = spot;
		lt->next = first;
		first = lt;
	}
	
	void Spot::disconnect1(Spot *spot) {
		LineTo *lt = first;
		if (!lt) return;
		if (lt->to == spot) {
			first = first->next;
			delete lt;
			return;
		}
		LineTo *prev = lt;
		lt = lt->next;
		
		while(lt) {
			if (lt->to == spot) {
				prev->next = lt->next;
				delete lt;
				return;
			}
			
			prev = lt;
			lt = lt->next;
		}
	}
	
	void Spot::disconnect(Spot *spot) {
		disconnect1(spot);
		spot->disconnect1(this);
	}
	
	void A34::makeSpots() {
		size_t i, ln;
		ln = lines.size();
		Spot *s1, *s2;
		for(i=0;i<ln;i++) {
			s1 = getSpot(lines[i]->p1);
			s2 = getSpot(lines[i]->p2);
			s1->connect(s2);
		}		
	}

	
	void A34::run() {
		cut();
		makeSpots();
		cnt = 0;
		size_t sz = spots.size();
		int i;
		for(i=0;i<sz;i++) {
			find(spots[i]);
		}
		NSLog(@"found: %d", cnt);
		
	}
	
	void A34::signal(int sig) {
		if (sig == 49) {
			run();
		}
	}
	
	void A34::find(Spot *spot) {
		std::vector<Spot *> stack;
		stack.push_back(spot);
		
		for(;;) {
			if (!spot->first) return;
			Spot *to = spot->first->to;
			spot->disconnect(to);
			{
				Spot::Mark mark2(to);
				stack.push_back(to);
				A34::find(spot, stack, 0);
				stack.pop_back();
			}
		}
	}
	
	
	
	void A34::find(Spot * start, std::vector<Spot *> &stack, int dep) {
		if (stack.size() > 2) {
			int i = stack.size() - 3;
			if (!stack[i]->inLineWith(stack[i+1], stack[i+2])) {
				dep++;
			}
		}
/*		
		NSLog(@"spot [%d, %d]; dep=%d, stack.size()=%d", 
			  (int)stack.back()->p.x, 
			  (int)stack.back()->p.y, (int)dep, (int)stack.size());
*/		
		if (stack.size() > 2) {
			if (dep > A) return;
			if (stack.back() == start) {
				
				int j = 0;
				if (!stack[1]->inLineWith(stack[0], stack[stack.size() - 2]))
					j = 1;
				
				if (dep + j == A) {
					
					cnt++;
					return;
				}
			}
			
		}
		
		Spot *top = stack.back();
		LineTo *lt = top->first;
		
		while (lt) {
			if (lt->to->mark) {
				
			} else {
				Spot *to = lt->to;
				to->mark = true;
				stack.push_back(to);			
				find(start, stack, dep);
				stack.pop_back();
				to->mark = false;
			}
			
			lt = lt->next;
		}
	}
}






