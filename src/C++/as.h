#ifndef AS_H
#define AS_H

#include <iostream>
#include <string>

using std::string;
using std::map;

typedef void PROTO;
typedef map<uint8_t, PROTO> PROTO_LIST;

typedef struct INSTRUCTION {
	uint8_t op;
	double a;
	double b;
	double c;
}

typedef struct AS {
	string name;
	PROTO_LIST protos;
}

namespace as {
	const AS newAs(string name, PROTO_LIST *protos);
	const string instruction2String(INSTRUCTION *inst);
	const PROTO getProto(string *name);
	const void wrap(PROTO *proto);
};

#endif
