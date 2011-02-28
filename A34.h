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
		Point p;
		LineTo * first;
		LineTo * mark;
	};
	
	
	class A34 {
		static const int MAX_LINES = 500;
	public:
		A34();
		void signal(int sig);
		void run();
		void cutLines();
		void pushLine(Line l);
		void reset();
		
		void cut();
		
		void getLines(std::vector<Line *> &ll) {
			ll = lines;
		}
		
	private:
		std::vector<Line *> lines;
	};
	
}

#endif