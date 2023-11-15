local io = io;

return function(Path)
	local File = io.open(Path, "r"); -- Only use read mode
	local Data = File:read("a");
	
	File:close();
	
	return Data;
end;
