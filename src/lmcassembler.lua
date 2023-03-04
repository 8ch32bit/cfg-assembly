local instr =    require('lmcinstructions');
local instruction_idx =  instr.instruction_idx;
local instruction_tidx = instr.instruction_tidx;

local function isWhitespace(str)
	return str == " " or str == "\r" or str == "\n";
end

local function assemble(src)
	local instructions = {};
	local instrPoints =  {};
	local argPoints =    {};
	local len =          #src;
	local v =            0;
	local argOffset =    1;
	repeat v = v + 1;
		local sub =  string.sub(src, v, v);
		local byte = string.byte(sub);
		if byte >= 97 and byte <= 122 then
			local str = "";
			v = v - 1;
			while true do
				v = v + 1;
				local _sub = string.sub(src, v, v);
				if v > len or isWhitespace(_sub) or _sub == ";" then break;
				else str = str .. _sub; end
			end
			if instruction_idx[str] then
				table.insert(instrPoints, str);
			end
		elseif byte >= 48 and byte <= 57 then
			local num = "";
			v = v - 1;
			while true do
				v = v + 1;
				local _sub = string.sub(src, v, v);
				local _byte = string.byte(_sub);
				if v > len or not (_byte >= 48 and _byte <= 57) then break;
				else num = num .. _sub; end
			end
			table.insert(argPoints, num);
		end
	until v == len;
	for idx = 1, #instrPoints do
		local inst = {};
		local op =   instrPoints[idx];
		if instruction_idx[op] then inst[1] = instruction_idx[op]; end
		if instruction_tidx[op] == 3 then
			inst[2] = argPoints[argOffset];
			inst[3] = argPoints[argOffset + 1];
			inst[4] = argPoints[argOffset + 2];
			argOffset = argOffset + 3;
		elseif instruction_tidx[op] == 2 then
			inst[2] = argPoints[argOffset];
			inst[3] = argPoints[argOffset + 1];
			argOffset = argOffset + 2;
		elseif instruction_tidx[op] == 1 then
			inst[2] = argPoints[argOffset];
			argOffset = argOffset + 1;
		end
		table.insert(instructions, inst);
	end
	return instructions;
end

return {assemble = assemble};
