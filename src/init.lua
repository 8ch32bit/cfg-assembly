local as       = require('as');
local readFile = require('readFile');
local parser   = require('parser');

local function newAssembler(src, name)
	return as.new(name, parser.parse(src));
end

local function newAssemblerFile(path, name)
	return newAssembler(readFile(path), name);
end

local function wrap(assembler)
	local main = assembler:getProto("main");
	local setup = assembler:getProto("setup");
	return function()
		if setup then
			setup.exec();
		end
		return main.exec();
	end
end

local function wrapSrc(src, name)
	return wrap(newAssembler(src, name))
end

local function wrapFile(src, name)
	return wrap(newAssemblerFile(src, name));
end

return {wrap = wrap, wrapSrc = wrapSrc, wrapFile = wrapFile};
