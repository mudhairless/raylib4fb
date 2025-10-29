/'******************************************************************************************
*
*   raylib [shaders] example - basic lighting
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   Example originally created with raylib 3.0, last time updated with raylib 4.2
*
*   Example contributed by Chris Camacho (@codifies) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2024 Chris Camacho (@codifies) and Ramon Santamaria (@raysan5)
*
*******************************************************************************************'/

#include "raylib.bi"
#include "raymath.bi"
#define RLIGHTS_IMPLEMENTATION
#include "rlights.bi"

#define GLSL_VERSION            330 '100 and 120 also supported by this shader

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

SetConfigFlags(FLAG_MSAA_4X_HINT)  ' Enable Multi Sampling Anti Aliasing 4x (if available)
InitWindow(screenWidth, screenHeight, "raylib [shaders] example - basic lighting")

' Define the camera to look into our 3d world
dim as Camera3D camera
camera.position = type<Vector3>( 2.0f, 4.0f, 6.0f )    ' Camera position
camera.target = type<Vector3>( 0.0f, 0.5f, 0.0f )      ' Camera looking at point
camera.up = Vector3UnitY         ' Camera up vector (rotation towards target)
camera.fovy = 45.0f                                ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE             ' Camera projection type

' Load basic lighting shader_
var shader_ = LoadShader(TextFormat("resources/shaders/glsl%i/lighting.vs", GLSL_VERSION), _
                            TextFormat("resources/shaders/glsl%i/lighting.fs", GLSL_VERSION))
                            
' Get some required shader_ locations
shader_.locs[SHADER_LOC_VECTOR_VIEW] = GetShaderLocation(shader_, "viewPos")
' NOTE: "matModel" location name is automatically assigned on shader_ loading, 
' no need to get the location again if using that uniform name
'shader_.locs[SHADER_LOC_MATRIX_MODEL] = GetShaderLocation(shader_, "matModel")

' Ambient light level (some basic lighting)
var ambientLoc = GetShaderLocation(shader_, "ambient")
dim as single ambientVals(0 to 3) => { 0.1f, 0.1f, 0.1f, 1.0f }
SetShaderValue(shader_, ambientLoc, @ambientVals(0), SHADER_UNIFORM_VEC4)

' Create lights
dim as Light lights(0 to MAX_LIGHTS - 1) => { _
    CreateLight(LIGHT_POINT, type<Vector3>( -2, 1, -2 ), Vector3Zero, YELLOW, shader_), _
    CreateLight(LIGHT_POINT, type<Vector3>( 2, 1, 2 ), Vector3Zero, RED, shader_), _
    CreateLight(LIGHT_POINT, type<Vector3>( -2, 1, 2 ), Vector3Zero, GREEN, shader_), _
    CreateLight(LIGHT_POINT, type<Vector3>( 2, 1, -2 ), Vector3Zero, BLUE, shader_) _
}

SetTargetFPS(60)                   ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())        ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    UpdateCamera(@camera, CAMERA_ORBITAL)

    ' Update the shader_ with the camera view vector (points towards { 0.0f, 0.0f, 0.0f })
    dim as single cameraPos(0 to 2) => { camera.position.x, camera.position.y, camera.position.z }
    SetShaderValue(shader_, shader_.locs[SHADER_LOC_VECTOR_VIEW], @cameraPos(0), SHADER_UNIFORM_VEC3)
    
    ' Check key inputs to enable/disable lights
    if (IsKeyPressed(KEY_Y)) then 
        lights(0).enabled = not lights(0).enabled 
    end if
    if (IsKeyPressed(KEY_R)) then
        lights(1).enabled = not lights(1).enabled
    end if
    if (IsKeyPressed(KEY_G)) then
        lights(2).enabled = not lights(2).enabled
    end if
    if (IsKeyPressed(KEY_B)) then
        lights(3).enabled = not lights(3).enabled 
    end if
    
    ' Update light values (actually, only enable/disable them)
    for i as integer = 0 to MAX_LIGHTS - 1
        UpdateLightValues(shader_, lights(i))
    next i
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)

            BeginShaderMode(shader_)

                DrawPlane(Vector3Zero, type<Vector2>( 10.0, 10.0 ), WHITE)
                DrawCube(Vector3Zero, 2.0, 4.0, 2.0, WHITE)

            EndShaderMode()

            ' Draw spheres to show where the lights are
            for i as integer = 0 to MAX_LIGHTS - 1
            
                if (lights(i).enabled) then
                    DrawSphereEx(lights(i).position, 0.2f, 8, 8, lights(i).color_)
                else 
                    DrawSphereWires(lights(i).position, 0.2f, 8, 8, ColorAlpha(lights(i).color_, 0.3f))
                end if
            next i

            DrawGrid(10, 1.0f)

        EndMode3D()

        DrawFPS(10, 10)

        DrawText("Use keys [Y][R][G][B] to toggle lights", 10, 40, 20, DARKGRAY)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadShader(shader_)   ' Unload shader_

CloseWindow()          ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

