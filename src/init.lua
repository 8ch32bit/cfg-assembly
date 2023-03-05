local lmc =        require('lmc');
local readFile =   require('readFile');
local lmc_parser = require('lmcparser');

local function newLMC(src, name)
	return lmc.new(name, lmc_parser.parse(src));
end

local function newLMCFile(path, name)
	return newLMC(readFile(path), name);
end

local function wrap(_lmc)
	local main = _lmc:getProto("main");
	local setup = _lmc:getProto("setup");
	return function()
		if setup then
			setup.exec();
		end
		return main.exec();
	end
end

local function wrapSrc(src, name)
	return wrap(newLMC(src, name))
end

local function wrapFile(src, name)
	return wrap(newLMCFile(src, name));
end

return {wrap = wrap, wrapSrc = wrapSrc, wrapFile = wrapFile};
