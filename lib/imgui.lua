project "Imgui"
	kind "StaticLib"
	language "C++"
	cppdialect "C++17"
	architecture "arm64"
	targetdir "%{wks.location}/build/lib/%{cfg.buildcfg}"
	objdir "%{wks.location}/build/obj"

	includedirs { 
		"imgui/", 
		"$(VULKAN_SDK)/include", 
		"glfw/include/", 
		"imgui/backend/" 
	}

	files {
        "imgui/*.cpp",
		"imgui/backends/imgui_impl_glfw.cpp",
		"imgui/backends/imgui_impl_vulkan.cpp"
    }
	
	defines {
		"IMGUI_IMPL_OPENGL_LOADER_VULKAN"
	}

	filter "system:windows"
		systemversion "latest"
        defines {"_IMGUI_WIN32", "_CRT_SECURE_NO_WARNINGS"}

    filter "system:macosx"
		systemversion "10.14"
        defines "_IMGUI_COCOA"

    filter "system:linux"
		systemversion "latest"
        defines "_IMGUI_X11"

	filter "configurations:debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:release"
		runtime "Release"
		optimize "on"
