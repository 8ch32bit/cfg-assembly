class instruction {
	constructor(op, a, b, c) {
		this.op = op;
		this.a = a;
		this.b = b;
		this.c = c;
	}
	
	deconstruct() {
		const op = this.op;
		const a = this.a || null;
		const b = this.b || null;
		const c = this.c || null;
		return op, a, b, c;
	}
	
	stringify() {
		const op, a, b, c = this.deconstruct();
		return `instruction: [op: ${op}, a: ${a}, b: ${b}, c: ${b}]`;
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
				
			}
		}
	}
};

module.exports = as;
