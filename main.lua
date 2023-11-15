local require = require;

local Assembler = require('src/Assembler');
local Parser    = require('src/Parser');
local ReadFile  = require('src/ReadFile');

local Module = {};

function Module.WrapString(Source, Name)
	local ASM = Assembler.new(Name, Parser(Source));
	
	local Main  = ASM:GetProto("main");
	local Setup = ASM:GetProto("setup");
	
	return function()
		if Setup then
			Setup.Execute();
		end;
		
		return Main.Execute();
	end;
end;

function Module.WrapFile(Path, Name)
	local ASM = Assembler.new(Name, Parser(ReadFile(Path)));
	
	local Main  = ASM:GetProto("main");
	local Setup = ASM:GetProto("setup");
	
	return function()
		if Setup then
			Setup.Execute();
		end;
		
		return Main.Execute();
	end;
end;

return Module;
