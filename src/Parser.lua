-- 8ch_32bit

local string = string;
local table = table;

local InstructionIdx = require('Instructions').InstructionIdx;

local function Parse(Source)
	if not Source then
		return;
	end;
	
	Source = Source .. "\n";

	local Found        = false;
	local Proto        = {};
	local Instructions = {};
	local Protos       = {};
	local Lines        = {};
	
	local Length   = #Source;
	local Position = 0;
	
	local CurrentLine = "";

	::continue::
		
	while Position <= Length do
		Position = Position + 1;
		local Substring = string.sub(Source, Position, Position);
			
		if CurrentLine ~= "" then
			if Substring == "\n" then
				CurrentLine = CurrentLine .. Substring;

				goto continue;
			end;
		end;
		
		table.insert(Lines, CurrentLine);
				
		CurrentLine = "";
	end;

	local LineCount = #Lines;
	
	for Idx = 1, LineCount, 1 do
		local Line = Lines[Idx];
		
		local Last = string.sub(Line, -1);
		local Rest = string.sub(Line, 1, -2);

		if Last == ";" or Last == "\n" then
			table.insert(Instructions, string.lower(Rest));
		end;
		
		if Last == ":" then
			if not Found then
				Proto.Name = Rest;
				Found      = true;
			else
				Proto.Instructions = Instructions;
				table.insert(Protos, Proto);
				
				Proto        = { Name = Rest };
				Instructions = {};
			end;
		end;
		
		if Idx == LineCount then
			Proto.Instructions = Instructions;
			table.insert(Protos, Proto);
		end;
	end;
	
	local ProtoCount = #Protos;
	
	for Idx = 1, ProtoCount, 1 do
		local Proto        = Protos[idx];
		local Name         = Proto.Name;
		local Instructions = Proto.Instructions;
		local InstrCount   = #Instructions
		
		for _idx = 1, #instructions do
			local Instruction = Instructions[_idx];
			local Length      = #Instruction;
			local Position    = 0;
			local New         = {};
			
			local OpcodeFound = false;
			
			while Position <= Length do
				Position = Position + 1;
				
				local Substring = string.sub(Instruction, Position, Position);
				
				if string.find(Substring, "[a-z]") then
					Position = Position - 1;
					
					if OpcodeFound then
						local Arg = "";
						
						while Position <= Length do
							Position = Position + 1;
							local Substring2 = string.sub(Instruction, Position, posPosition
							
							if string.find(Substring2, "[a-z]") or tonumber(Substring2) or Substring2 == "_" then
								Arg = Arg .. Substring2;
							else
								break;
							end;
						end;
						
						table.insert(New, Arg);
					else
						local Opcode = "";
						
						while Position <= Length do
							Position = Position + 1;
							local Substring2 = string.sub(Instruction, Position, Position);
							
							if isLetter(Substring2) then
								Opcode = Opcode .. _sub;
							else
								break;
							end;
						end;
						
						OpcodeFound = true;
						New[1] = InstructionIdx[Opcode];
					end;
				elseif tonumber(Substring) then
					Position = Position - 1;
					
					local Arg = "";
					
					if string.sub(Instruction, Position, Position) == "-" then
						Arg = Arg .. "-";
					end
					
					while Position <= Length do
						Position = Position + 1;
						local Substring2 = string.sub(Instruction, Position, Position);
						
						if tonumber(Substring2) or Substring2 == "." then
							Arg = Arg .. Substring2;
						else
							break;
						end;
					end;
					
					table.insert(New, tonumber(Arg) or Arg);
				end;

				if #New > 4 then
					break;
				end;
			end
			
			instructions[_idx] = new;
		end
	end
	
	return protos;
end;

return {parse = parse};
