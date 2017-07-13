package = "key-auth"
version = "0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
 url = "git://github.com/brndmg/kong-plugin-hello-world",
 tag = "v0.1-1"
}
description = {
 summary = "The key-auth Plugin",
 license = "Apache 2.0",
 homepage = "https://github.com/brndmg/kong-plugin-hello-world",
 detailed = [[
     An example key-auth plugin.
 ]],
}
dependencies = {
 "lua ~> 5.1"
}
build = {
 type = "builtin",
 modules = {
    ["kong.plugins.key-auth.migrations.cassandra"] = "migrations/cassandra.lua",
    ["kong.plugins.key-auth.migrations.postgres"] = "migrations/postgres.lua",
    ["kong.plugins.key-auth.handler"] = "handler.lua",
    ["kong.plugins.key-auth.hooks"] = "hooks.lua",
    ["kong.plugins.key-auth.schema"] = "schema.lua",
    ["kong.plugins.key-auth.api"] = "api.lua",
    ["kong.plugins.key-auth.daos"] = "daos.lua",
 }
}