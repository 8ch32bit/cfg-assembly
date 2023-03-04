local lmc = {};
lmc.__index = lmc;

local lmc_instructions = require('lmcinstructions');
local instruction_idx =  lmc_instructions.instruction_idx;
local instruction_tidx = lmc_instructions.instruction_tidx;
local instruction_ridx = {}; for idx, val in pairs(instruction_idx) do instruction_ridx[val] = idx; end

local null = "null";

local function yield(x)
	local c = os.clock();
	repeat until os.clock() - c >= x;
end

function lmc.new(name, protos)
	local self =  setmetatable({}, lmc);
	self.name =   name or "lmc-main";
	self.memory = {};
	self.protos = protos or {};
	for idx = 0, 2048 do
		self.memory[idx] = 0;
	end
	return self;
end

function lmc:deconstructInstruction(inst)
	local op = inst[1];
	local a =  inst[2] or null;
	local b =  inst[3] or null;
	local c =  inst[4] or null;
	return op, a, b, c;
end

function lmc:instruction2String(inst)
	local op, a, b, c = self:deconstructInstruction(inst);
	return string.format("instruction: [opcode: %s, a: %s, b: %s, c: %s]", instruction_ridx[op], a, b, c);
end

function lmc:getProto(name)
	name = name or "main";
	for idx, val in pairs(self.protos) do
		if val.name == name then
			return val;
		end
	end
end

function lmc:wrap(proto)
	proto = proto or self:getProto(proto) or self:getProto();
	local instructions = proto.instructions;
	local max = #instructions;
	return function()
		local pc =  0;
		local function setpc(x) pc = x; end
		local function addpc(x)	pc = pc + (x and x or 1); end
		while true do
			addpc();
			if pc > max then
				break;
			else
				local opcode, a, b, c = self:deconstructInstruction(instructions[pc]);
				if opcode == 0 then -- ADD
					self.memory[a] = self.memory[b] + self.memory[c];
				elseif opcode == 1 then -- SUB
					self.memory[a] = self.memory[b] - self.memory[c];
				elseif opcode == 2 then -- MUL
					self.memory[a] = self.memory[b] * self.memory[c];
				elseif opcode == 3 then -- DIV
					self.memory[a] = math.floor(self.memory[b] / self.memory[c]);
				elseif opcode == 4 then -- GET
					self.memory[a] = self.memory[(b ~= null and b) or a];
				elseif opcode == 5 then -- CLEAR
					self.memory[a] = 0;
				elseif opcode == 6 then -- MOVE
					self.memory[a] = self.memory[b];
				elseif opcode == 7 then -- SET
					self.memory[a] = b;
				elseif opcode == 8 then -- COUT
					io.write(tostring(self.memory[a]));
				elseif opcode == 9 then -- COUTNL
					print(tostring(self.memory[a]));
				elseif opcode == 10 then -- COUTNLRANGE
					local v = "";
					for idx = a, b do
						v = v .. tostring(self.memory[idx]);
					end
					print(v);
				elseif opcode == 11 then -- COUTNLRANGESTR
					local v = "";
					for idx = a, b do
						v = v .. string.char(self.memory[idx]);
					end
					print(v);
				elseif opcode == 12 then -- JMP
					addpc(a);
				elseif opcode == 13 then -- SETPC
					setpc(a);
				elseif opcode == 14 then -- RESETPC
					setpc(0);
				elseif opcode == 15 then -- HALT
					yield(a);
				elseif opcode == 16 then -- KILL
					break;
				elseif opcode == 17 then -- TESTLT
					if not (self.memory[a] < self.memory[b]) then
						addpc(c);
					end
				elseif opcode == 18 then -- TESTGT
					if not (self.memory[a] > self.memory[b]) then
						addpc(c);
					end
				elseif opcode == 19 then -- TESTLE
					if not (self.memory[a] <= self.memory[b]) then
						addpc(c);
					end
				elseif opcode == 20 then -- TESTGE
					if not (self.memory[a] >= self.memory[b]) then
						addpc(c);
					end
				elseif opcode == 21 then -- TESTEQ
					if not (self.memory[a] == self.memory[b]) then
						addpc(c);
					end
				elseif opcode == 22 then -- CALL
					self:wrap(self:getProto(a))();
				end
			end
		end
	end
end

return lmc;
