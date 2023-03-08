#ifndef AS_H
#define AS_H

#include <iostream>
#include <string>

using std::string;
using std::map;

typedef void PROTO;

typedef struct INSTRUCTION {
	uint8_t op;
	double a;
	double b;
	double c;
}

typedef struct AS {
	string name;
	map<uint8_t, PROTO> protos;
}

namespace as {
	const string instruction2String(INSTRUCTION *inst);
	const PROTO getProto(string *name);
	const void wrap(PROTO *proto);
};

#endif
