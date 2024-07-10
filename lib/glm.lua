project "GLM"
	kind "StaticLib"
	language "C"
	architecture "arm64"
	targetdir "%{wks.location}/build/lib/%{cfg.buildcfg}"
	objdir "%{wks.location}/build/obj"
	includedirs { "glm/" }

	files {
        "glm/glm/**",
    }

	filter "system:windows"
		systemversion "latest"
        defines {"_GLM_WIN32", "_CRT_SECURE_NO_WARNINGS"}

    filter "system:macosx"
		systemversion "10.14"
        defines "_GLM_COCOA"

    filter "system:linux"
		systemversion "latest"
        defines "_GLM_X11"

	filter "configurations:debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:release"
		runtime "Release"
		optimize "on"
