const instr =           require('instructions.js');
const instruction_idx = instr.instruction_idx;

function parseNumber(src) {
	if (src.match(".")) return parseFloat(src);
	return parseInt(src);
}

const isNumber = function(src) {return parseNumber(src) != NaN;}
const isLetter = function(src) {return src.match(/[a-z]/ != null;}

function getProtos(src) {
	src = src + "\n";
	const len =  #src;
	var v =      0;
	const add =  function(x) {v = v + (x || 1);}
	const next = function() {add(); return src.slice(v - 1, v);}
	function getLines() {
		var line = "";
		var lines = [];
		while(true) {
			if (v > len) break;
			const sub = next();
			if (sub === "\n") {
				if (line != "") lines[lines.length] = line;
			} else {
				line = line + sub;
			}
		}
		return lines;
	}
	const lines = getLines();
	var found =   false;
	var proto =   {name: "", instructions: []};
	var protos =  [];
	for (var idx = 0; idx < lines.length; idx++) {
		const line = lines[idx];
		const last = line.slice(-1);
		const rest = line.slice(0, -2):
		if (last === ":") {
			if (!found) {
				proto.name = rest;
				found =      true;
			} else {
				protos[protos.length] = proto;
				proto =                 {name: "", instructions: []};
				proto.name =            rest;
			}
		}
	}
	return protos;
}
