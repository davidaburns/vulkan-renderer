project "GLFW"
	kind "StaticLib"
	language "C"
	architecture "arm64"
	targetdir "../build/lib/%{cfg.buildcfg}"
	objdir "../build/obj"

	files {
        "glfw/src/*.c",
		"glfw/src/*.h",
		"glfw/src/*.m",
        "glfw/include/GLFW/glfw3.h",
        "glfw/include/GLFW/glfw3native.h"
    }

	includedirs {
		"glfw/include"
	}

	filter "system:windows"
		systemversion "latest"
        defines {"_GLFW_WIN32", "_CRT_SECURE_NO_WARNINGS"}

    filter "system:macosx"
		systemversion "10.14"
        defines "_GLFW_COCOA"

    filter "system:linux"
		systemversion "latest"
        defines "_GLFW_X11"

	filter "configurations:debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:release"
		runtime "Release"
		optimize "on"
