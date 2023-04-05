const { exec } = require('child_process');

function sleep(time) {
	exec(`sleep ${time}`);
}

function _concat(t, seperator, a, b) {
	a = a || 1; b = b || t.length;
	seperator = seperator || "";
	var s = "";
	for (var idx = a; idx <= b; idx++) {
		s = s + t[idx] + seperator;
	}
	return s;
}

function concat(t, encode, a, b) { // Experimental concanation functions for better use
	if (encode === true) return _concat(t, "", a, b);
	a = a || 1; b = b || t.length;
	seperator = seperator || "";
	var s = "";
	for (var idx = a; idx <= b; idx++) {
		s = s + (encode && t[idx].charCodeAt())|| "";
	}
	return s;
}

function splitArr(t, a, b) {
	var newArr = [];
	for (var idx = a; idx <= b; idx++) {
		newArr[idx] = t[idx];
	}
	return newArr;
}

class instruction {
	constructor(op, a, b, c) {
		this.op = op;
		this.a = a;
		this.b = b;
		this.c = c;
	}
	
	deconstruct() {
		const op, a, b, c = this.op, this.a || null, this.b || null, this.c || null;
		return op, a, b, c;
	}
	
	stringify() {
		const op, a, b, c = this.deconstruct();
		return `instruction: [opcode: ${op}, a: ${a}, b: ${b}, c: ${b}]`;
	}
}

class as {
	constructor(name, protos) {
		this.name = name || "as-main";
		this.memory = [];
		this.protos = [];
		for (var idx = 1; idx <= protos.length; idx++) {
			this.protos[idx] = this.wrap(this.protos[idx]);
		}
		for (var idx = 1; idx <= 2048; idx++) {
			this.memory[idx] = 0;
		}
	}
	
	getProto(name) {
		for (var idx = 1; idx <= this.protos.length; idx++) {
			if (this.protos[idx].name === name) return self.protos[idx];
		}
	}
	
	wrap(proto) {
		proto = proto || this.getProto(proto) || this.getProto();
		const instructions = proto.instructions;
		const max = instructions.length;
		return function() {
			var pc = 0;
			const addpc = (x) => pc = pc + (x || 1);
			const setpc = (x) => pc = x;
			while(true) {
				addpc();
				if (pc > max) {
					break;
				} else {
					const opcode, a, b, c = instructions[pc].deconstruct();
					switch(opcode) {
						case 0:
							this.memory[a] = this.memory[b] + this.memory[c]; break;
						case 1:
							this.memory[a] = this.memory[b] + this.memory[c]; break;
						case 2:
							this.memory[a] = this.memory[b] - this.memory[c]; break;
						case 3:
							this.memory[a] = Math.floor(this.memory[b] / this.memory[c]); break;
						case 4:
							this.memory[a] = this.memory[b || a]; break;
						case 5:
							this.memory[a] = 0; break;
						case 6:
							this.memory[a] = this.memory[b]; break;
						case 7:
							this.memory[a] = b; break;
						case 8: // COUT
							process.stdout.write(JSON.stringify(this.memory[a])); break;
						case 9: // COUTNL
							process.stdout.write(JSON.stringify(this.memory[a]) + "\n"); break;
						case 10: // COUTNLRANGE
							process.stdout.write(concat(this.memory, false, a, b) + "\n"); break;
						case 11: // COUTNLRANGESTR
							process.stdout.write(concat(this.memory, true, a, b) + "\n"); break;
						case 12: // JMP
							addpc(a); break;
						case 13: // SETPC
							setpc(a); break;
						case 14: // RESETPC
							setpc(0); break;
						case 15: // HALT
							sleep(a); break;
						case 16:
							setpc(max); break;
						case 17:
							if (!(this.memory[a] < this.memory[b])) {addpc(c);} break;
						case 18:
							if (!(this.memory[a] > this.memory[b])) {addpc(c);} break;
						case 19:
							if (!(this.memory[a] <= this.memory[b])) {addpc(c);} break;
						case 20:
							if (!(this.memory[a] >= this.memory[b])) {addpc(c);} break;
						case 21:
							if (!(this.memory[a] === this.memory[b])) {addpc(c);} break;
						case 22:
							this.getProto(a).exec(); break;
						case 23:
							setpc(max);
							return splitArr(this.memory, a || 0, b || this.memory.length);
					}
				}
			}
		}
	}
}

module.exports = {as: as, instruction: instruction};
