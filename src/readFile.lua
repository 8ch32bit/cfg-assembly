return function(path)
	local file = io.open(path, "r");
	local data = file:read("a");
	file:close() return data;
end
