-- This would be the parent of the other modules in this folder

--!nonstrict

local AS:     {} = require(script:FindFirstChild("Assembler"));
local Parser: {} = require(script:FindFirstChild("Parser"));

local Assembler: {} = AS.Assembler;

local function NewAssembler(source: string, name: string?): {}
	return Assembler.new(name, parser.parse(src));
end;

local function Wrap(assembler: {}): () -> (any)
	local main:  { [string]: any } = assembler:GetProto("main");
	local setup: { [string]: any } = assembler:GetProto("setup");
	
	return function();
		if setup then
			setup.Execute();
		end;
		
		return main.Execute();
	end;
end;

local function WrapString(src, name)
	return Wrap(NewAssembler(src, name))
end

return {
	NewAssembler = NewAssembler :: (string, string?) -> ({}),
	Wrap         = Wrap         :: ({}) -> (() -> (any)),
	WrapString   = WrapString   :: (string, string?) -> (() -> (any)),
};
