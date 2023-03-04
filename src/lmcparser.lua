local instr =            require('lmcinstructions');
local instruction_idx =  instr.instruction_idx;
local instruction_tidx = instr.instruction_tidx;

local function isWhitespace(str) -- Excepting tabs
	return str == " " or str == "\r" or str == "\n";
end

local function isNumber(str)
	local byte = string.byte(str);
	return byte >= 48 and byte <= 57;
end

local function isLetter(str)
	local byte = string.byte(str);
	return byte >= 97 and byte <= 122;
end

local function getProtos(src)
	src = src .. "\n";
	local len =    #src;
	local v =      0;
	local function add(x)
		v = v + (x or 1);
	end
	local function next()
		add();
		return string.sub(src, v, v);
	end
	local function getLines()
		local line = "";
		local lines = {};
		while true do
			if v > len then
				break;
			end
			local sub = next();
			if sub == "\n" then
				if line ~= "" then
					table.insert(lines, line);
					line = "";
				end
			else
				line = line .. sub;
			end
		end
		return lines;
	end
	local lines =        getLines();
	local found =        false;
	local proto =        {instructions = {}};
	local protos =       {};
	for idx = 1, #lines do
		local line = lines[idx];
		local last = string.sub(string.reverse(line), 1, 1);
		local rest = string.reverse(string.sub(string.reverse(line), 2, #line));
		if last == ":" then
			if not found then
				proto.name = rest;
				found = true;
			else
				table.insert(protos, proto);
				proto = {instructions = {}};
				proto.name = rest;
			end
		elseif last == ";" or last == "\n" then
			table.insert(proto.instructions, rest);
		end
		if idx == #lines then
			table.insert(protos, proto);
		end
	end
	return protos;
end

local function parse(src)
	local protos = getProtos(src);
	for idx = 1, #protos do
		local proto =        protos[idx];
		local name =         proto.name;
		local instructions = proto.instructions;
		for _idx = 1, #instructions do
			local instruction = instructions[_idx];
			local new =         {};
			local len =         #instruction;
			local pos =         0;
			local opFound =     false;
			while true do
				pos = pos + 1;
				if pos > len or #new > 4 then
					break;
				end
				local sub = string.sub(instruction, pos, pos);
				if isLetter(sub) then
					pos = pos - 1;
					if not opFound then
						local op = "";
						while true do
							pos = pos + 1;
							if pos > len then
								break;
							end
							local _sub = string.sub(instruction, pos, pos);
							if isLetter(_sub) then
								op = op .. _sub;
							else
								break;
							end
						end
						opFound = true;
						new[1] = instruction_idx[op];
					else
						local arg = "";
						while true do
							pos = pos + 1;
							if pos > len then
								break;
							end
							local _sub = string.sub(instruction, pos, pos);
							if isLetter(_sub) or isNumber(_sub) or _sub == "_" then
								arg = arg .. _sub;
							else
								break;
							end
						end
						table.insert(new, arg);
					end
				elseif isNumber(sub) then
					pos = pos - 1;
					local arg = "";
					while true do
						pos = pos + 1;
						if pos > len then
							break;
						end
						local _sub = string.sub(instruction, pos, pos);
						if isNumber(_sub) or _sub == "-" then
							
							arg = arg .. _sub;
						else
							break;
						end
					end
					table.insert(new, tonumber(arg) or arg); --print(arg)
				end
			end
			instructions[_idx] = new;
		end
	end
	return protos;
end

return {parse = parse};
