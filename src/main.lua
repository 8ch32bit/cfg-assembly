local lmc =        require('lmc');
local readFile =   require('readFile');
local lmc_parser = require('lmcparser');

local file = readFile("example.lmc");
local process = lmc.new("Monkey", lmc_parser.parse(file));
local execute = process:wrap(process:getProto("main"));

execute();
