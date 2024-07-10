workspace "vkrend"
    configurations { "debug", "release" }
    architecture "arm64"
	flags { "MultiProcessorCompile" }
	startproject "vkrend"

include "lib/glm.lua"
include "lib/glfw.lua"
include "lib/imgui.lua"

project "vkrend"
    location "build"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++20"
    targetdir "build/bin/%{cfg.buildcfg}"
	objdir "build/obj"

    files { 
		"src/**.cpp", 
		"src/**.h",
		"src/**.hpp"
	}

    includedirs { 
		"src/",
		"$(VULKAN_SDK)/include",
		"lib/glm/glm",
		"lib/glfw/include",
		"lib/imgui"
	}

    libdirs {
		"build/lib/%{cfg.buildcfg}"
	}

	links {
		"vulkan",
		"GLFW",
		"GLM",
		"Imgui"
	}

	filter "system:macosx"
		systemversion "10.14"
		links { 
			"Cocoa.framework", 
			"Metal.framework", 
			"QuartzCore.framework", 
			"IOKit.framework",
			"MoltenVK"
		}
		linkoptions { 
			"-rpath @executable_path/lib"  
		}
		prebuildcommands{
			"{MKDIR} %{wks.location}/build/bin/%{cfg.buildcfg}/lib",
			"{COPY} $(VULKAN_SDK)/lib/libMoltenVK.dylib %{wks.location}/build/bin/%{cfg.buildcfg}/lib",
			"{COPY} $(VULKAN_SDK)/lib/libvulkan.1.dylib %{wks.location}/build/bin/%{cfg.buildcfg}/lib"
		}

    filter "configurations:debug"
        defines { "DEBUG" }
        runtime "Debug"
        symbols "on"

    filter "configurations:release"
        defines { "RELEASE" }
        runtime "Release"
        optimize "on"
