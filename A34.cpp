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
		lines.push_back(l);
	}
	
	
	void A34::run() {
		

	}
	
	void A34::signal(int sig) {
		if (sig == 49) {
			run();
		}
	}
	
	

}




