const instr =           require('instructions.js');
const instruction_idx = instr.instruction_idx;

function parseNumber(src) {
	if (src.match(".")) return parseFloat(src);
	return parseInt(src);
}

const isNumber = function(src) {return parseNumber(src) != NaN;}
const isLetter = function(src) {return src.match(/[a-z]/) != null;}

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

function parse(src) {
	var protos = getProtos(src);
	for (var idx = 0; idx < protos.length; idx++) {
		var proto =        protos[idx];
		var name =         proto.name;
		var instructions = proto.instructions;
		for (var _idx = 0; _idx < instructions.length; _idx++) {
			var instruction = instructions[_idx];
			var _new =        [];
			var len =         instruction.length;
			var pos =         0;
			var opFound =     false;
			while(true) {
				pos++;
				if (pos > len || _new > 4) break;
				const sub = instruction.slice(pos - 1, pos);
				if (isLetter(sub)) {
					pos--;
					if (!opFound) {
						var op = "";
						while(true) {
							pos++;
							if (pos > len) break;
							const _sub = instruction.slice(pos - 1, pos);
							if (isLetter(_sub)) {
								op = op + sub;
							} else {
								break;
							}
						}
						opFound = true;
						_new[1] = instruction_idx[op];
					} else {
						var arg = "";
						while(true) {
							pos++;
							if (pos > len) break;
							const _sub = instruction.slice(pos - 1, pos);
							if (isLetter(_sub) || isNumber(_sub) || _sub === "_") {
								arg = arg + sub;
							} else {
								break;
							}
						}
						_new[_new.length] = arg;
					}
				} else if (isNumber(sub)) {
					pos--;
					if (instruction.slice(pos - 1, pos) === "-") arg = arg .. "-";
					var arg = "";
					while(true) {
						pos++;
						if (pos > len) break;
						const _sub = instruction.slice(pos - 1, pos);
						if (isNumber(_sub) || _sub === ".") {
							arg = arg + sub;
						} else {
							break;
						}
					}
					_new[_new.length] = parseNumber(arg);
				}
			}
			instructions[_idx] = _new;
		}
	}
	return protos;
}

module.exports = {parse: parse};
