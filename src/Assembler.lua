local null = "null";

local table  = table;
local string = string;
local io     = io;
local os     = os;
local print  = print;

local function Concat(Table, Encode, A, B) -- Concat function that can do ascii chars
	A = A or 1;
	B = B or #Table;

	if not Encode then
		return table.concat(Table, "", A, B);
	end;

	local String = "";
	
	for Idx = A, B do
		String = String .. (encode and string.char(Table[idx]) or "");
	end;

	return String;
end;

local Assembler = {};
Assembler.__index = as;

function Assembler.new(Name, Protos, AllocSize)
	local self = setmetatable({}, Assembler);
	
	Protos = Protos or {};

	self.Name = Name or "as-main";
	
	local Memory = table.create(AllocSize or 1024);

	self.Memory = Memory;
	self.Protos = Protos;
	
	for Idx = 1, Protos do
		local Proto = Protos[Idx];
		
		Proto.Execute = self:WrapProto(Proto);
	end;
	
	return self;
end;

function Assembler:GetProto(Name)
	local Protos = self.Protos;
	local Amount = #Protos;
	
	for Idx = 1, Amount do
		local Proto = Protos[Idx];
		
		if Proto.Name == Name then
			return Proto;
		end;
	end;
end;

function Assembler:WrapProto(Proto)
	Proto = Proto or self:GetProto();

	local Memory       = self.Memory;
	local Instructions = Proto.Instructions;
	local Limit        = #Instructions;
	
	local function Execute()
		local PC = 0;
		
		while PC <= Limit do
			PC = PC + 1;

			local Instr = Instructions[PC];
				
			if OpCode == 0 then -- ADD
				Memory[Instr[2]] = Memory[Instr[3]] + Memory[Instr[4]];
			elseif OpCode == 1 then -- SUB
				Memory[Instr[2]] = Memory[Instr[3]] - Memory[Instr[4]];
			elseif OpCode == 2 then -- MUL
				Memory[Instr[2]] = Memory[Instr[3]] * Memory[Instr[4]];
			elseif OpCode == 3 then -- DIV
				Memory[Instr[2]] = Memory[Instr[3]] // Memory[Instr[4]];
			elseif OpCode == 4 then -- GET
				local A = Instr[2];
				local B = Instr[3];
				
				Memory[A] = Memory[(B ~= nil and B) or A];
			elseif OpCode == 5 then -- CLEAR
				Memory[Instr[2]] = 0;
			elseif OpCode == 6 then -- MOVE
				Memory[Instr[2]] = Memory[Instr[3]];
			elseif OpCode == 7 then -- SET
				Memory[Instr[2]] = Instr[3];
			elseif OpCode == 8 then -- COUT
				io.write(Memory[a]);
			elseif OpCode == 9 then -- COUTNL
				print(Memory[Instr[2]]);
			elseif OpCode == 10 then -- COUTNLRANGE
				print(Concat(Memory, false, Instr[2], Instr[3]));
			elseif OpCode == 11 then -- COUTNLRANGESTR
				print(Concat(Memory, true, Instr[2], Instr[3]));
			elseif OpCode == 12 then -- JMP
				PC = PC + Instr[2];
			elseif OpCode == 13 then -- SETPC
				PC = Instr[2];
			elseif OpCode == 14 then -- RESETPC
				PC = 0;
			elseif OpCode == 15 then -- HALT
				os.execute("sleep " .. Instr[2]);
			elseif OpCode == 16 then -- KILL
				break;
			elseif OpCode == 17 then -- TESTLT
				if not (Memory[Instr[2]] < Memory[Instr[3]]) then
					PC = PC + Instr[4];
				end
			elseif OpCode == 18 then -- TESTGT
				if not (Memory[Instr[2]] > Memory[Instr[3]]) then
					PC = PC + Instr[4];
				end
			elseif OpCode == 19 then -- TESTLE
				if not (Memory[Instr[2]] <= Memory[Instr[3]]) then
					PC = PC + Instr[4];
				end
			elseif OpCode == 20 then -- TESTGE
				if not (Memory[Instr[2]] >= Memory[Instr[3]]) then
					PC = PC + Instr[4];
				end
			elseif OpCode == 21 then -- TESTEQ
				if not (Memory[Instr[2]] == Memory[Instr[3]]) then
					PC = PC + Instr[4];
				end
			elseif OpCode == 22 then -- CALL
				local Proto = self:GetProto(Instr[2]);

				if not Proto.Wrapped then
					self:WrapProto(Proto);
				end;

				Proto.Execute();
			elseif OpCode == 23 then -- RETURN
				return table.move(Memory, Instr[2], Instr[3], 1, {});
			end;
		end;
	end;

	Proto.Wrapped = true;
end;

return Assembler;
