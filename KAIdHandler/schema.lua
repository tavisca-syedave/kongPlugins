return {
  no_consumer = true, -- this plugin will only be API-wide,
  fields = {
    -- Describe your plugin's configuration's schema here.
    data_api_url = {type = "string", required = true},
    api_keys = {type = "array", required = true}    
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    -- perform any custom verification
    return true
  end
}
