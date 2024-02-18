-- set minimum xmake version
set_xmakever("2.7.8")

-- set project
set_project("OverlayManager")
set_version("0.0.0")
set_license("MIT")
set_languages("c++20")
set_optimize("faster")

-- set allowed
set_allowedarchs("windows|x64")
set_allowedmodes("debug", "releasedbg")

-- set defaults
set_defaultarchs("windows|x64")
set_defaultmode("releasedbg")

-- add rules
add_rules("mode.debug", "mode.releasedbg")
add_rules("plugin.vsxmake.autoupdate")

-- set policies
set_policy("package.requires_lock", true)

-- require packages
add_requires("commonlibsse-ng")
add_requires("magic_enum", "nlohmann_json")

-- targets
target("OverlayManager")
    -- add packages to target
    add_packages("fmt", "spdlog", "commonlibsse-ng", "magic_enum", "nlohmann_json")

    -- add commonlibsse-ng plugin
    add_rules("@commonlibsse-ng/plugin", {
        name = "OverlayManager",
        author = "ponzipyramid",
        description = "SKSE64 plugin template using CommonLibSSE-NG"
    })

    -- add src files
    add_files("src/**.cpp")
    add_headerfiles("src/**.h")
    add_includedirs("src")
    set_pcxxheader("src/pch.h")

    -- copy build files to MODS or SKYRIM paths (remove if not needed)
    after_build(function(target)
        local copy = function(env, ext)
            for _, env in pairs(env:split(";")) do
                if os.exists(env) then
                    local plugins = path.join(env, ext, "SKSE/Plugins")
                    os.mkdir(plugins)
                    os.trycp(target:targetfile(), plugins)
                    os.trycp(target:symbolfile(), plugins)
                end
            end
        end
        if os.getenv("SKYRIM_PATH") then
            copy(os.getenv("SKYRIM_PATH"), "Data")
        end
    end)
