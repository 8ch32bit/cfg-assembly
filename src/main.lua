local lmc =              require('lmc');
local readFile =         require('readFile');
local lmc_assembler =    require('lmcassembler');

local execute = lmc.new():execute(lmc_assembler.assemble(readFile("example.lmc")));

execute(); -- Hello world!
