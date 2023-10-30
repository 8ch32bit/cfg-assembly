--!nonstrict

local TypeDefs = require(script.Parent.TypeDefs);

local function DeconstructInstr(instr: Instr): (number, number?, number?, number?)
	return inst[1], inst[2], inst[3], inst[4];
end

local function InstructionToString(instr: Instr): (string)
	return `instruction: [opcode: {instr[1]}, a: {instr[2] or null}, b: {instr[3] or null}, c: {instr[4] or null}]`;
end

local function Concat(__table: {}, encode: boolean?, a: number?, b: number?): (string) -- Concat function with encodability
	a = if a then a else 1;
	b = if b then b else #__table;
	
	local String: string = if encode then "" else table.concat(t, "", a, b);
	
	for Idx: number = a, b do
		String = `{String}{if encode then string.char(__table[Idx]) else ""}`;
	end;
	
	return String;
end;

local Assembler: { [string]: any } = {};
Assembler.__index = as;

local null = "null";

function Assembler.new(name: string, protos: { [string]: any }?, memory: { number }?): { [string]: any }
	local self: {} = setmetatable(
		{
			Name   = name or "as-main" :: string,
			
			Memory = memory or {} :: { number },
			Protos = protos or {} :: { [string]: any },
		},
		Assembler
	);
	
	for _, Proto: { [string]: any } in self.Protos do
		Proto.Execute = self:Wrap(Proto);
	end;
	
	for Idx: number = 0, 2048 do
		self.Memory[Idx] = 0;
	end;
	
	return self;
end

function Assembler:GetProto(name: string): { [string]: any }?
	for _, Proto: { [string]: any } in self.Protos do
		if Proto.Name == name then
			return Proto;
		end;
	end;
end

function Assembler:Wrap(proto: { [string]: any }?): () -> ()
	proto = proto or self:GetProto();
	
	local Instructions: { { number } } = proto.Instructions;
				
	local Max: number = #Instructions;
	
	return function(): {}
		local PC: number = 0;
		
		local function SetPC(x: number): ()
			PC = x;
		end;
		
		local function AddPC(x: number): ()
			PC += x;
		end;

		local Memory: { number } = self.Memory;
		
		while PC <= Max do
			AddPC(1);
			
			local Opcode: number, A: number, B: number, C: number = DeconstructInstr(Instructions[PC]);
				
			if opcode == 0 then -- ADD
				Memory[A] = Memory[B] + Memory[C];
			elseif opcode == 1 then -- SUB
				Memory[A] = Memory[B] - Memory[C];
			elseif opcode == 2 then -- MUL
				Memory[A] = Memory[B] * Memory[C];
			elseif opcode == 3 then -- DIV
				Memory[A] = Memory[B] / Memory[C];
			elseif opcode == 4 then -- GET
				local Index: number = if B ~= null then B else A;
				
				Memory[A] = Memory[Index];
			elseif opcode == 5 then -- CLEAR
				Memory[A] = 0;
			elseif opcode == 6 then -- MOVE
				Memory[A] = Memory[B];
			elseif opcode == 7 then -- SET
				Memory[A] = B;
			elseif opcode == 8 then -- COUT
				print(Memory[A]);
			elseif opcode == 9 then -- COUTNL
				print(Memory[A]);
			elseif opcode == 10 then -- COUTNLRANGE
				print(concat(Memory, false, a, b));
			elseif opcode == 11 then -- COUTNLRANGESTR
				print(concat(Memory, true, a, b));
			elseif opcode == 12 then -- JMP
				AddPC(A);
			elseif opcode == 13 then -- SETPC
				SetPC(A);
			elseif opcode == 14 then -- RESETPC
				SetPC(0);
			elseif opcode == 15 then -- HALT
				task.wait(A);
			elseif opcode == 16 then -- KILL
				break;
			elseif opcode == 17 then -- TESTLT
				if not (Memory[A] < Memory[B]) then
					AddPC(C);
				end
			elseif opcode == 18 then -- TESTGT
				if not (Memory[A] > Memory[B]) then
					AddPC(C);
				end
			elseif opcode == 19 then -- TESTLE
				if not (Memory[A] <= Memory[B]) then
					AddPC(C);
				end
			elseif opcode == 20 then -- TESTGE
				if not (Memory[A] >= Memory[B]) then
					AddPC(C);
				end
			elseif opcode == 21 then -- TESTEQ
				if not (self.memory[a] == self.memory[b]) then
					AddPC(C);
				end
			elseif opcode == 22 then -- CALL
				local Proto = self:GetProto(A);

				if Proto then
					Proto.Execute();
				end;
			elseif opcode == 23 then -- RETURN
				return table.move(Memory, A, B, 1, {});
			end;
		end;

		return {};
	end;
end;

return {
	Assembler = Assembler :: {},

	DeconstructInstr    = DeconstructInstr    :: ({ number }) -> (number, number?, number?, number?),
	InstructionToString = InstructionToString :: ({ number }) -> (string),
};
