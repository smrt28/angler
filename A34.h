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
		bool mark;
	private:
		void disconnect1(Spot *spot);

	};
	
	class Polygon {
		
	private:
		class PPolygon {
			friend class Polygon;
		public:
			PPolygon(int edges):edges(edges), area(-1) {
				p = new Point[edges];
			}

			~PPolygon() {
				delete [] p;
			}

			int edges;
			Point * p;
			Float area;

		};
		
		boost::shared_ptr<PPolygon> polygon;
	public:

		Polygon(int edges): polygon(new PPolygon(edges)) {}
		
		Float area(void);
		
		Point * getPoints() {
			return polygon->p;
		}
		
		int getEdgesCount() { return polygon->edges; }
		
	};
	
	class A34Result : public std::vector<Polygon> {
	public:
		A34Result() : areaValid(false), errorMessage(0) {}
	
		void checkAreas() {
			if (areaValid) return;

			if (size() == 0) {
				smallestArea = biggestArea = -1;
				return;
			}
			
			int i;
			smallestArea = 1000000;
			biggestArea = -1;
			CGFloat tmp;
			for(i=0;i<size();i++) {
				tmp = (*this)[i].area();
				if (tmp < smallestArea) smallestArea = tmp;
				if (tmp > biggestArea) biggestArea = tmp;
			}
			areaValid = true;
		}
		
        int clasifySize(int idx) {
            if (idx >= size())
                return 1;
            Float f = (*this)[idx].area();
            if (f == getSmallestArea()) {
                if (f == getBiggestArea())
                    return 1;
                return 0;
            }
            if (f == getBiggestArea())
                return 2;
            return 1;
        }
        
		Float getSmallestArea() { checkAreas(); return smallestArea; }
		Float getBiggestArea() { checkAreas(); return biggestArea; }
        const char * errorMessage;
	private:
		bool areaValid;
		Float smallestArea;
		Float biggestArea;
	};
	
	typedef std::vector<Line> Lines;
	
	class A34 {
		static const int MAX_LINES = 500;

	public:
		A34(Lines &lns, int edges);
		~A34();
		A34Result * run();
		
	private:
		void pushLine(Line l);
		void signal(int sig);
		void cutLines();
		void makeSpots();
		void reset();
		Spot * getSpot(Point &p);
		void cut();
		void find(A34Result *result, Spot *first);
		void find(A34Result *result, Spot *start, std::vector<Spot *> &stack, int dep);

		template <typename T>
		void freeVector(std::vector<T *> v) {
			int i;
			size_t size = v.size();
			for(i=0;i<size;i++)
				delete v[i];
			v.clear();
		}
		Polygon makeResult(std::vector<Spot *> &stack);		
		std::vector<Line *> lines;
		std::vector<Spot *> spots;
		
        int complexity;
		int cnt;
		int A;
	};
	
}

#endif