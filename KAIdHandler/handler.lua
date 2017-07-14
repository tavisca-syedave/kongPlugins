-- Extending the Base Plugin handler is optional, as there is no real
-- concept of interface in Lua, but the Base Plugin handler's methods
-- can be called from your child implementation and will print logs
-- really
-- in your `error.log` file (where all logs are printed).
local httpClient = require "socket.http"
local json = require "kong.plugins.KAIdHandler.json"
local BasePlugin = require "kong.plugins.base_plugin"
local KAIdHandler = BasePlugin:extend()
local _realm = 'Key realm="' .. _KONG._NAME .. '"'

-- Your plugin handler's constructor. If you are extending the
-- Base Plugin handler, it's only role is to instanciate itself
-- with a name. The name is your plugin name as it will be printed in the logs.
function KAIdHandler:new()
  KAIdHandler.super.new(self, "KAIdHandler")
end

function KAIdHandler:init_worker(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  KAIdHandler.super.init_worker(self)

  -- Implement any custom logic here
end

function KAIdHandler:certificate(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  KAIdHandler.super.certificate(self)

  -- Implement any custom logic here
end

function KAIdHandler:rewrite(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  KAIdHandler.super.rewrite(self)

  -- Implement any custom logic here
end

local function resolve_access_key(config, access_key)
    if access_key == nil or access_key == "" then
	    return false, { status = 401, message = "Invalid CAPI Access Key" }
    end
    local turl = string.format(config.data_api_url .. "%s", access_key)
    local response, code, resheaders, status = httpClient.request(turl)
    if code > 499 or response == nil then 
	return false, { status = 401, message = "Unable To Authenticate" } 
    end
	
    local hierarchy = json.parse(response)
    if code > 299 then
	return false, { status = 401, message = hierarchy.message }
    end
    if hierarchy == nil 
    	or hierarchy["clientId"] == nil or hierarchy["clientId"] == "" 
    	or hierarchy["clientProgramGroupId"] == nil or hierarchy["clientProgramGroupId"] == "" 
    	or hierarchy["programId"] == nil or hierarchy["programId"] == "" then
		return false, { status = 401, message = "Invalid CAPI Access Key" }
    end
    -- Set the client detail headers in the request
    ngx.req.set_header("capi-clientId", hierarchy["clientId"])
    ngx.req.set_header("capi-clientProgramGroupId", hierarchy["clientProgramGroupId"])
    ngx.req.set_header("capi-programId", hierarchy["programId"])
    return true, nil
end

local function verify_api_key(config, api_key)
    local does_key_match = false
    for k,v in pairs(config.api_keys) do
        if api_key == v then
	    does_key_match = true
	    break
	end
    end
    if does_key_match then
	return true, nil
    else
	return false, { status = 401, message = "Incorrect API Key" }
    end
end

function send_response(status, message) 
    ngx.header["WWW-Authenticate"] = _realm
    ngx.status = status
    ngx.print('{"message":"' .. message ..'"}')
    ngx.flush(true)
    ngx.exit(status)
end

function check_failure(isSuccessful, err)
    if not isSuccessful then
	send_response(err.status, err.message)
    end
end

function KAIdHandler:access(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
    KAIdHandler.super.access(self)

    local headers = ngx.req.get_headers()
    local access_key_header = "capi-accesskey"
    local api_key_header = "oski-apikey"
    local isCapiAccessIdFound = false
    local isApiKeyFound = false
    for k,v in pairs(headers) do
    	if k == access_key_header then
    	    isCapiAccessIdFound = true
	    local isSuccessful, err = resolve_access_key(config, v)
	    check_failure(isSuccessful, err)
	    -- Remove the capi access key header from request headers
	    ngx.req.clear_header(access_key_header)
	    break
    	elseif k == api_key_header then
	    isApiKeyFound = true
	    local isSuccessful, err = verify_api_key(config, v)
	    check_failure(isSuccessful, err)
	    -- Remove the api key header from request headers
	    ngx.req.clear_header(api_key_header)
	    break
	end
    end
    if isCapiAccessIdFound == false and isApiKeyFound == false then
	send_response(401, "Authentication Parameters Missing")
    end
end

function KAIdHandler:header_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  KAIdHandler.super.header_filter(self)

  -- Implement any custom logic here
end

function KAIdHandler:body_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  KAIdHandler.super.body_filter(self)

  -- Implement any custom logic here
end

function KAIdHandler:log(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  KAIdHandler.super.log(self)

  -- Implement any custom logic here
end

-- This module needs to return the created table, so that Kong
-- can execute those functions.
return KAIdHandler
