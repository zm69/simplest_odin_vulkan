/*
    The simplest Odin Vulkan app (or almost the simplest)

    If you are able to successfully run this app it means everything it setuped correctly.

    Created by: https://github.com/zm69
*/

package main

// Need this to print results
import "core:fmt"

// To log errors
import "core:log"

// Simple API for creating windows, contexts and surfaces, 
// receiving input and events for OpenGL, OpenGL ES and Vulkan development
// We need this to create platform independent windows and also to initialize Vulkan.
import "vendor:glfw"

// Vulkan 
import vk "vendor:vulkan"

main :: proc() {
    // Log into console when panic happens
    context.logger = log.create_console_logger()

    // STEP 1: Initialize glfw library, we must do it, or glfw.GetInstanceProcAddress will not be set in STEP 2
    if !glfw.Init() {
        log.panicf("glfw Init() failure %s %d", glfw.GetError())
    }
    defer glfw.Terminate() // Also terminate glfw at the end of main() scope
    
    // STEP 2: We need this proc address to load Vulkan global procs in STEP 3
    instance_proc_addr := rawptr(glfw.GetInstanceProcAddress)
    if instance_proc_addr == nil {
        log.panicf("glfw.GetInstanceProcAddress is nil")
    }

    // STEP 3: Load global vk procs. Without this step you will not be able to run vk.EnumerateInstanceExtensionProperties()
    vk.load_proc_addresses_global(instance_proc_addr)
    
    // STEP 4: Test if Vulkan procedures work
    extension_count : u32
    result := vk.EnumerateInstanceExtensionProperties(nil, &extension_count, nil)
    if result != vk.Result.SUCCESS {
        log.panicf("vk.EnumerateInstanceExtensionProperties failed %v", result)
    }

    // STEP 5: Print results
    fmt.println(extension_count, "extensions supported. Result = ", result)

    // NOTE: When you will create vk.Instance you will need to load vk procs related to vk.Instance like this:
    //
    // vk.load_proc_addresses_instance(g_instance)
    //
    // where g_instance is instance of vk.Instance type
    
    // For full triangle example check this Gist: https://gist.github.com/laytan/ba57af3e5a59ab5cb2fca9e25bcfe262
}