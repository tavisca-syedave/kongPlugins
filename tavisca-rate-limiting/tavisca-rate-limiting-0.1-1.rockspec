package = "tavisca-rate-limiting"
version = "0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
 url = "git://github.com/brndmg/kong-plugin-hello-world",
 tag = "v0.1-1"
}
description = {
 summary = "The tavisca-rate-limiting Plugin",
 license = "Apache 2.0",
 homepage = "https://github.com/brndmg/kong-plugin-hello-world",
 detailed = [[
     An example tavisca-rate-limiting plugin.
 ]],
}
dependencies = {
 "lua ~> 5.1"
}
build = {
 type = "builtin",
 modules = {
    ["kong.plugins.tavisca-rate-limiting.migrations.cassandra"] = "migrations/cassandra.lua",
    ["kong.plugins.tavisca-rate-limiting.migrations.postgres"] = "migrations/postgres.lua",
    ["kong.plugins.tavisca-rate-limiting.handler"] = "handler.lua",
    ["kong.plugins.tavisca-rate-limiting.schema"] = "schema.lua",
    ["kong.plugins.tavisca-rate-limiting.daos"] = "daos.lua",
 }
}