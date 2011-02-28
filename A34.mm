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
	
	
	A34::A34() {
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
			if (i>100) 
				return;
		}
		NSLog(@"lines: %d", lines.size());
	}
	
	void A34::run() {
		cut();

	}
	
	void A34::signal(int sig) {
		if (sig == 49) {
			run();
		}
	}
	
	

}




