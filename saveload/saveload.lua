-- Title: SaveLoad
-- Author: Kalvin Lyle
-- Version: 1.0
-- Description: Defold module for performing saves and loads

local M = {}

local savefile = {}

function M.save_to_file(folder, filename, table)
	assert(type(folder) == "string", "You must provide `folder` of type `string` to perform `load_data()`")
	assert(type(filename) == "string", "You must provide `filename` of type `string` to perform `load_data()`")
	local r = true
	local filepath = sys.get_save_file(folder, filename)
	if not sys.save(filepath, table) then
		r = false
		print("SAVELOAD: WARNING - Save data could not be written to " .. filepath .. filename)
	end
	return r
end

function M.load_from_JSON(filename)
	assert(type(filename) == "string", "You must provide `filename` of type `string` to perform `load_from_JSON()`")
	return json.decode(sys.load_resource(filename))
end

function M.load_from_file(folder, filename)
	assert(type(folder) == "string", "You must provide `folder` of type `string` to perform `load_from_file()`")
	assert(type(filename) == "string", "You must provide `filename` of type `string` to perform `load_from_file()`")
	local filepath = sys.get_save_file(folder, filename)
	local table = sys.load(filepath)
	if not next(table) then
		table = false
		print("SAVELOAD: WARNING - Save data could not be loaded from" .. filepath)
	end
	return table
end

function M.save_data(folder, filename, data)
	assert(type(folder) == "string", "You must provide `folder` of type `string` to perform `save_data()`")
	assert(type(filename) == "string", "You must provide `filename` of type `string` to perform `save_data()`")
	M.save_to_file(folder, filename, data)
end

function M.load_data(folder, filename, defaultdata)
	assert(type(folder) == "string", "You must provide `folder` of type `string` to perform `load_data()`")
	assert(type(filename) == "string", "You must provide `filename` of type `string` to perform `load_data()`")
	local data = {}
	if M.load_from_file(folder, filename) then 
		data = M.load_from_file(folder, filename)
	elseif defaultdata ~= nil then
		data = defaultdata
		M.save_data(folder, filename, defaultdata)
	end
	return data
end

return M
