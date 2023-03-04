local lmc = {};
lmc.__index = lmc;

local lmc_instructions = require('lmcinstructions');
local instruction_idx =  lmc_instructions.instruction_idx;
local instruction_tidx = lmc_instructions.instruction_tidx;
local instruction_ridx = {}; for idx, val in pairs(instruction_idx) do instruction_ridx[val] = idx; end

local function yield(x)
	local c = os.clock();
	repeat until os.clock() - c >= x;
end

function lmc.new(name)
	local self =    setmetatable({}, lmc);
	self.name =     name or "lmc-main";
	self.memory =   {RAM = {}, ACC = {}};
	for idx = 0, 4096 do self.memory.RAM[idx] = 0; self.memory.ACC[idx] = 0; end
	return self;
end

function lmc:instruction2String(inst)
	local op = inst[1];
	local a =  inst[2] or "null";
	local b =  inst[3] or "null";
	local c =  inst[4] or "null";
	return string.format("instruction: [opcode: %s, a: %s, b: %s, c: %s]", instruction_ridx[op], a, b, c);
end

function lmc:execute(instructions, protos)
	local pc =  0;
	local max = #instructions;
	local function setpc(x) pc = x; end
	local function addpc(x)	pc = pc + (x and x or 1); end
	return function(proto)
		local RAM = {};
		local ACC = {};
		local killed = false;
		while true do
			setpc(0);
			::loop::
			addpc();
			if pc > max then
				break;
			else
				local instruction = instructions[pc];
				local opcode =      instruction[1];
				local a =           tonumber(instruction[2]) or "null";
				local b =           tonumber(instruction[3]) or "null";
				local c =           tonumber(instruction[4]) or "null";
				if opcode == 0 then -- ADD
					self.memory.ACC[a] = self.memory.ACC[b] + self.memory.ACC[c];
				elseif opcode == 1 then -- SUB
					self.memory.ACC[a] = self.memory.ACC[b] - self.memory.ACC[c];
				elseif opcode == 2 then -- MUL
					self.memory.ACC[a] = self.memory.ACC[b] * self.memory.ACC[c];
				elseif opcode == 3 then -- DIV
					self.memory.ACC[a] = math.floor(self.memory.ACC[b] / self.memory.ACC[c]);
				elseif opcode == 4 then -- ADDRAM
					self.memory.RAM[a] = self.memory.RAM[b] + self.memory.RAM[c];
				elseif opcode == 5 then -- SUBRAM
					self.memory.RAM[a] = self.memory.RAM[b] - self.memory.RAM[c];
				elseif opcode == 6 then -- MULRAM
					self.memory.RAM[a] = self.memory.RAM[b] * self.memory.RAM[c];
				elseif opcode == 7 then -- DIVRAM
					self.memory.RAM[a] = math.floor(self.memory.RAM[b] / self.memory.RAM[c]);
				elseif opcode == 8 then -- GETRAM
					self.memory.ACC[a] = self.memory.RAM[(b ~= "NULL" and b) or a];
				elseif opcode == 9 then -- GETACC
					self.memory.RAM[a] = self.memory.ACC[(b ~= "NULL" and b) or a];
				elseif opcode == 10 then -- ACCSTDOUT
					io.write(tostring(self.memory.ACC[a]));
				elseif opcode == 11 then -- RAMSTDOUT
					io.write(tostring(self.memory.RAM[a]));
				elseif opcode == 12 then -- CLEARACCCH
					self.memory.ACC[a] = 0;
				elseif opcode == 13 then -- CLEARRAMCH
					self.memory.RAM[a] = 0;
				elseif opcode == 14 then -- MOVEACC
					self.memory.ACC[a] = self.memory.ACC[b];
				elseif opcode == 15 then -- MOVERAM
					self.memory.RAM[a] = self.memory.RAM[b];
				elseif opcode == 16 then -- SETACC
					self.memory.ACC[a] = b;
				elseif opcode == 17 then -- SETRAM
					self.memory.RAM[a] = b;
				elseif opcode == 18 then -- ACCSTDOUTNL
					print(tostring(self.memory.ACC[a]));
				elseif opcode == 19 then -- RAMSTDOUTNL
					print(tostring(self.memory.RAM[a]));
				elseif opcode == 20 then -- RAMSTDOUTRANGENL
					local v = ""; for idx = a, b do
						v = v .. tostring(self.memory.RAM[idx]);
					end
					print(v);
				elseif opcode == 21 then -- RAMSTDOUTRANGESTRNL
					local v = ""; for idx = a, b do
						v = v .. string.char(self.memory.RAM[idx]);
					end
					print(v);
				elseif opcode == 22 then -- CALL
					self.memory.RAM[b] = self:execute(protos[b] or proto)();
				elseif opcode == 23 then -- JMP
					addpc(a);
				elseif opcode == 24 then -- SETPC
					setpc(a);
				elseif opcode == 25 then -- RESETPC
					setpc(0);
				elseif opcode == 26 then -- HALT
					yield(a);
				elseif opcode == 27 then -- KILL
					break;
				end
				goto loop;
			end
		end
	end
end

return lmc;
