package = "tavisca-ip-restriction"
version = "0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
 url = "git://github.com/brndmg/kong-plugin-hello-world",
 tag = "v0.1-1"
}
description = {
 summary = "The tavisca-ip-restriction Plugin",
 license = "Apache 2.0",
 homepage = "https://github.com/brndmg/kong-plugin-hello-world",
 detailed = [[
     An example tavisca-ip-restriction plugin.
 ]],
}
dependencies = {
 "lua ~> 5.1"
}
build = {
 type = "builtin",
 modules = {
    ["kong.plugins.tavisca-ip-restriction.migrations.cassandra"] = "migrations/cassandra.lua",
    ["kong.plugins.tavisca-ip-restriction.migrations.postgres"] = "migrations/postgres.lua",
    ["kong.plugins.tavisca-ip-restriction.handler"] = "handler.lua",
    ["kong.plugins.tavisca-ip-restriction.hooks"] = "hooks.lua",
    ["kong.plugins.tavisca-ip-restriction.schema"] = "schema.lua",
    ["kong.plugins.tavisca-ip-restriction.api"] = "api.lua",
    ["kong.plugins.tavisca-ip-restriction.daos"] = "daos.lua",
 }
}