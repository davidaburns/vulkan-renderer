#include <GLFW/glfw3.h>
#include <vulkan/vulkan.h>

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <vector>

#include "imgui.h"

static VKAPI_ATTR VkBool32 VKAPI_CALL debugCallback(
    VkDebugUtilsMessageSeverityFlagBitsEXT severity,
    VkDebugUtilsMessageTypeFlagsEXT type,
    const VkDebugUtilsMessengerCallbackDataEXT* callbackData,
    void* userData
) {
    std::cerr << "validation layer: " << callbackData->pMessage << std::endl;
    return VK_FALSE;
}

class Application {
private:
    const uint32_t WINDOW_WIDTH = 800;
    const uint32_t WINDOW_HEIGHT = 600;
    GLFWwindow* window = nullptr;
    VkInstance instance;
    const std::vector<const char*> validationLayers = {
        "VK_LAYER_KHRONOS_validation"
    };

#ifdef NDEBUG
    const bool validationLayersEnabled = false;
#else
    const bool validationLayersEnabled = true;
#endif

public:
    void run() {
        initWindow();
        initGraphics();
        loop();
        cleanup();
    }

private:
    void init() {}

    void initWindow() {
        std::cout << "Initializing window" << std::endl;

        glfwInit();
        glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
        glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);

        window = glfwCreateWindow(
            WINDOW_WIDTH,
            WINDOW_HEIGHT,
            "vkRend",
            nullptr,
            nullptr
        );
    }

    void initGraphics() {
        std::cout << "Initalizing graphics" << std::endl;
        createGraphicsInstance();
        createGraphicsDebugMessenger();
    }

    void loop() {
        while (!glfwWindowShouldClose(window)) {
            glfwPollEvents();
        }
    }

    void cleanup() {
        vkDestroyInstance(instance, nullptr);
        glfwDestroyWindow(window);
        glfwTerminate();
    }

    void createGraphicsInstance() {
        if (validationLayersEnabled &&
            !checkValidationLayerSupport(validationLayers)) {
            throw std::runtime_error(
                "validation layers requested, but not available"
            );
        }

        std::vector<const char*> extensions = getRequiredExtensions();

        VkApplicationInfo appInfo{};
        appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        appInfo.pApplicationName = "vkRend";
        appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
        appInfo.pEngineName = "Engine";
        appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
        appInfo.apiVersion = VK_API_VERSION_1_0;

        VkInstanceCreateInfo createInfo{};
        createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
        createInfo.pApplicationInfo = &appInfo;
        createInfo.enabledExtensionCount =
            static_cast<uint32_t>(extensions.size());

        createInfo.ppEnabledExtensionNames = extensions.data();
        createInfo.flags |= VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;

        if (validationLayersEnabled) {
            createInfo.enabledLayerCount =
                static_cast<uint32_t>(validationLayers.size());

            createInfo.ppEnabledLayerNames = validationLayers.data();
        } else {
            createInfo.enabledLayerCount = 0;
        }

        VkResult result = vkCreateInstance(&createInfo, nullptr, &instance);
        if (result != VK_SUCCESS) {
            throw std::runtime_error("failed to create graphics instance");
        }

        if (!checkRequiredExtensionSupport(extensions)) {
            throw std::runtime_error("not all required extensions are available"
            );
        }
    }

    void createGraphicsDebugMessenger() {
        if (!validationLayersEnabled) {
            return;
        }

        VkDebugUtilsMessengerCreateInfoEXT createInfo{};
        createInfo.sType =
            VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;

        createInfo.messageSeverity =
            VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT |
            VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
            VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;

        createInfo.messageType =
            VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
            VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
            VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;

        createInfo.pfnUserCallback = debugCallback;
        createInfo.pUserData = nullptr;
    }

    std::vector<const char*> getRequiredExtensions() {
        uint32_t count = 0;
        const char** extensions = glfwGetRequiredInstanceExtensions(&count);

        std::vector<const char*> requiredExtensions(
            extensions,
            extensions + count
        );

        requiredExtensions.emplace_back(
            VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME
        );

        if (validationLayersEnabled) {
            requiredExtensions.emplace_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
        }

        return requiredExtensions;
    }

    bool checkRequiredExtensionSupport(std::vector<const char*>& extensions
    ) const {
        uint32_t extensionCount = 0;
        vkEnumerateInstanceExtensionProperties(
            nullptr,
            &extensionCount,
            nullptr
        );

        std::vector<VkExtensionProperties> vkExtensions(extensionCount);
        vkEnumerateInstanceExtensionProperties(
            nullptr,
            &extensionCount,
            vkExtensions.data()
        );

        for (const char* extension : extensions) {
            bool found = false;

            for (const auto& vkExtension : vkExtensions) {
                if (strcmp(extension, vkExtension.extensionName) == 0) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                return false;
            }
        }

        return true;
    }

    bool checkValidationLayerSupport(const std::vector<const char*>& layers) {
        uint32_t layerCount;
        vkEnumerateInstanceLayerProperties(&layerCount, nullptr);

        std::vector<VkLayerProperties> availableLayers(layerCount);
        vkEnumerateInstanceLayerProperties(&layerCount, availableLayers.data());

        for (const char* layer : layers) {
            bool found = false;

            for (const auto& property : availableLayers) {
                if (strcmp(layer, property.layerName) == 0) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                return false;
            }
        }

        return true;
    }
};

int main() {
    Application app;

    try {
        app.run();
    } catch (const std::exception& e) {
        std::cerr << e.what() << std::endl;
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
