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
#include <boost/shared_ptr.hpp>

#include "AAtoms.h"

namespace al {
		
	class Spot;
	
	class LineTo
	{
	public:
				
		Spot * to;
		LineTo * next;
	};	
	
	
	class Spot
	{
	public:
		class Mark {
		public:
			Mark(Spot *spot): spot(spot) { spot->mark = true; }
			~Mark() { spot->mark = false; }
		private:
			Spot *spot;
		};
		
		Spot(Point &p) : p(p), first(0), mark(false) {}
		~Spot();
		bool inLineWith(Spot *s1, Spot *s2) {
			return p.inLineWith(s1->p, s2->p);
		}
		void connect(Spot *spot);
		void disconnect(Spot *spot);
		bool isConnected(Spot *spot);
		Point p;
		LineTo * first;
//		LineTo * mark;
		bool mark;
	private:
		void disconnect1(Spot *spot);

	};
	
	class A34SingleResult : public std::vector<Line> {
	};
	
	class A34Result : public std::vector< boost::shared_ptr<A34SingleResult> > {
		
	};
	
	class A34 {
		static const int MAX_LINES = 500;
	public:
		A34();
		~A34();
		void signal(int sig);
		A34Result * run();
		void cutLines();
		void makeSpots();
		void pushLine(Line l);
		void reset();
		
		Spot * getSpot(Point &p);
		
		void cut();
		
		void getLines(std::vector<Line *> &ll) {
			ll = lines;
		}
	private:
		void find(A34Result *result, Spot *first);
		void find(A34Result *result, Spot *start, std::vector<Spot *> &stack, int dep);
	private:
		template <typename T>
		void freeVector(std::vector<T *> v) {
			int i;
			size_t size = v.size();
			for(i=0;i<size;i++)
				delete v[i];
			v.clear();
		}
		A34SingleResult * makeResult(std::vector<Spot *> stack);
		std::vector<Line *> lines;
		std::vector<Spot *> spots;
		
		int cnt;
		int A;
	};
	
}

#endif