/*
 *  A34.cpp
 *  Angler
 *
 *  Created by smrt on 2/26/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "A34.h"

#define MAX_COMPLEXITY 1100000

namespace al {
    
    class Error {
    public:
    enum A34ErrorId { 
        A34ERR_TOO_COMPLICATED
    };

    public:
        Error(A34ErrorId err) : err(err) { }
        A34ErrorId err;
    };

	Float Polygon::area(void) {
		if (polygon->area >= 0)
			return polygon->area;
		Point *p = getPoints();

		Float ar = 0;
		int i,j, N;
		N = getEdgesCount();
		
		for (i=0;i<N;i++) {
			j = (i + 1) % N;
			ar += p[i].x * p[j].y;
			ar -= p[i].y * p[j].x;
		}
		
		ar /= 2;
		polygon->area = (ar < 0 ? -ar : ar);
		return polygon->area;
	}
	
	
	A34::A34(Lines &lns, int edges): A(edges){
		size_t i;
		for(i=0;i<lns.size();i++) {
			pushLine(lns[i]);
		}
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
		int i, j, tmp, rv, k, cnt;
		i = 0; cnt = 0;
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
                
                if (cnt++ > 8000) {
                    throw Error(Error::A34ERR_TOO_COMPLICATED);
                }
			}
			
			i++;
		}
	//	NSLog(@"lines: %lu %d", lines.size(), cnt);
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
	
	namespace {
	struct CmpAreas {
		bool operator ()(const al::Polygon  &a, const al::Polygon  &b)  {
			return ((Polygon &)a).area() < ((Polygon &)b).area();
		}
	};
		
	}

	
	A34Result * A34::run() {
        std::auto_ptr<A34Result> result(new A34Result());

        try {
		cut();
		makeSpots();
		cnt = 0;
		size_t sz = spots.size();
		int i;
        complexity = 0;
		for(i=0;i<sz;i++) {
			find(result.get(), spots[i]);
		}
	//	NSLog(@"found: %d; complexity: %d", cnt, complexity);
		std::sort(result->begin(), result->end(), CmpAreas());
		return result.release();
        } catch(Error e) {
            result.get()->clear();
            result->errorMessage = "Too complicated picture, please undo lines...";
            return result.release();
        }
	}

	
	void A34::find(A34Result *result, Spot *spot) {
        
		std::vector<Spot *> stack;
		stack.push_back(spot);
		
		for(;;) {
			if (!spot->first) return;
			Spot *to = spot->first->to;
			spot->disconnect(to);
			{
				Spot::Mark mark2(to);
				stack.push_back(to);
				A34::find(result, spot, stack, 0);
				stack.pop_back();
			}
		}
	}
	
	
	Polygon A34::makeResult(std::vector<Spot *> &stack) {
		Polygon result(A);
		size_t sz = stack.size() - 1;
		int i;
		Spot *fspot = 0;
		Spot *spot;
		Point *points = result.getPoints();
		for(i=0;;i++) {
			spot = stack[(i+1) % sz];
			if (!stack[i % sz]->inLineWith(spot, stack[(i+2) % sz])) {

				if (fspot == spot)
					break;
				
				*points = spot->p;
				points++;
				
				if (!fspot)
					fspot = spot;
			}
		}
		return result;
	}
	
	void A34::find(A34Result *result, Spot * start, std::vector<Spot *> &stack, int dep) {
        if (complexity++ > MAX_COMPLEXITY)
            throw Error(Error::A34ERR_TOO_COMPLICATED);
        
		if (stack.size() > 2) {
			int i = stack.size() - 3;
			if (!stack[i]->inLineWith(stack[i+1], stack[i+2])) {
				dep++;
			}
		}
	
		if (stack.size() > 2) {
			if (dep > A) return;
			if (stack.back() == start) {
				
				int j = 0;
				if (!stack[1]->inLineWith(stack[0], stack[stack.size() - 2]))
					j = 1;
				
				if (dep + j == A) {
                 //   if (cnt > 7000)
                 //       throw Error(Error::A34ERR_TOO_COMPLICATED);
					result->push_back(makeResult(stack));
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
				find(result, start, stack, dep);
				stack.pop_back();
				to->mark = false;
			}
			
			lt = lt->next;
		}
	}
}






