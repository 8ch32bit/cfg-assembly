--!nonstrict

local Package: Folder = script.Parent;

local InstructionIndex: { [string]: number } = require(Package:FindFirstChild("Instructions")).InstructionIndex;

local function IsNumber(__string: string): (boolean)
	return typeof(__string) == "number";
end;

local function IsLetter(__string: string): (boolean)
	if not (typeof(__string) == "string" and #String == 1) then
		return false;
	end;
	
	return string.match(string.lower(__string), "[a-z]") ~= nil;
end;

local function GetProtos(source: string): { { [string]: unknown } }
	source = `{source}\n`;
	
	local Length:   number = #source;
	local Position: number = 0;
	
	local function Next(): (string)
		Position += 1;
		
		return string.sub(source, Position, Position);
	end;
	
	local Line:  string     = "";
	local Lines: { string } = {};
		
	while Position <= Length do
		local Substring: string = Next();
			
		if Substring == "\n" then
			if Line ~= "" then
				table.insert(Lines, Line);
				
				Line = "";
			end
		else
			Line = `{Line}{Sub}`;
		end;
	end;
		
	local Found: boolean    = false;
	
	local Protos: { { [string]: unknown } } = {};

	local Proto: { [string]: unknown } = {
		Instructions = {},
	};

	local LineAmount = #Lines;
	
	for Idx: number, Line: string in Lines do
		local Last: string = string.sub(Line, -1);
		local Rest: string = string.sub(Line, 1, -2);
		
		if Last == ":" then
			if not Found then
				Proto.Name = Rest;
				Found      = true;
			else
				table.insert(Protos, Proto);
				
				Proto = {
					Name         = Rest;
					Instructions = {};
				};
			end;
		elseif Last == ";" or Last == "\n" then
			table.insert(Proto.Instructions, Rest);
		end;
		
		if Idx == LineAmount then
			table.insert(Protos, Proto);
		end;
	end;
	
	return Protos;
end;

local function Parse(source: string): { { [string]: any } }
	local Protos: { { [string]: any } } = GetProtos(source);
	
	for Idx: number, Proto in Lines do
		local Name: string = Proto.Name;
		
		local Instructions: { string } = Proto.Instructions;
		
		for __Idx, Instruction: string in Instructions do
			local Length: number = #instruction;
			
			local New:      {}     = {};
			local Position: number = 0;
			
			local OpFound: boolean = false;
			
			while (Position <= Length and #New <= 4) do
				Position += 1;
				
				local Substring: string = string.sub(Instruction, Position, Position);
				
				if IsLetter(Substring) then
					Position -= 1;
					
					if not OpFound then
						local Op: string = "";
						
						while Position <= Length do
							Pos += 1;
							
							local __Substring: string = string.sub(Instruction, Position, Position);
							
							if IsLetter(__Substring) then
								Op = `{Op}{__Substring}`;
							else
								break;
							end
						end
						
						OpFound = true;
						table.insert(New, InstructionIdx[Op]);
					else
						local Arg = "";
						
						while Position <= Length do
							Position += 1;
							
							local __Substring: string = string.sub(Instruction, Position, Position);
							
							if IsLetter(__Substring) or IsNumber(__Substring) or __Substring == "_" then
								Op = `{Op}{__Substring}`;
							else
								break;
							end;
						end;
						
						table.insert(New, Arg);
					end;
				elseif IsNumber(sub) then
					Position -= 1;
					
					local Arg: string = "";
					
					if string.sub(Instruction, Position, Position) == "-" then
						Arg = `{Arg}-`;
					end;
					
					while Position <= Length do
						Position += 1;
						
						local __Substring = string.sub(Instruction, Position, Position);
						
						if IsNumber(__Substring) or __Substring == "." then
							Arg = `{Arg}{__Substring}`;
						else
							break;
						end;
					end;

					Arg = tonumber(Arg) or ARg;
					
					table.insert(New, Arg);
				end;
			end;
			
			Instructions[__Idx] = New;
		end;
	end;
	
	return protos;
end;

return Parse;