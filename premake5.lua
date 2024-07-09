workspace "vkrend"
    configurations { "debug", "release" }
    architecture "x86_64"

project "vkrend"
    location "build"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++20"
    targetdir "bin/%{cfg.buildcfg}"

    files { "src/**.cpp", "src/**.h" }
    includedirs { "src/" }
    libdirs { "lib/" }

    filter "configurations:debug"
        defines { "DEBUG" }
        runtime "Debug"
        symbols "on"

    filter "configurations:release"
        defines { "RELEASE" }
        runtime "Release"
        optimize "on"
