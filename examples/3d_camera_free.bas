/'******************************************************************************************
*
*   raylib [core] example - Initialize 3d camera free
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2024 Ramon Santamaria (@raysan5)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include once "raylib.bi"
#DEFINE RAYMATH_IMPLEMENTATION
#include once "raymath.bi"

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera free")

' Define the camera to look into our 3d world
dim as Camera3D camera
camera.position = Vector3One * 10 ' Camera position, equiv to type<Vector3>(10.0f, 10.0f, 10.0f)
camera.target = Vector3Zero      ' Camera looking at point
camera.up = Vector3UnitY          ' Camera up vector (rotation towards target)
camera.fovy = 45.0f                                ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE             ' Camera projection type

var cubePosition = Vector3Zero

DisableCursor()                    ' Limit cursor to relative movement inside the window

SetTargetFPS(60)                   ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())        ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    UpdateCamera(@camera, CAMERA_FREE)

    if (IsKeyPressed(KEY_Z)) then
        camera.target = Vector3Zero
    end if
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)

            DrawCube(cubePosition, 2.0f, 2.0f, 2.0f, RED)
            DrawCubeWires(cubePosition, 2.0f, 2.0f, 2.0f, MAROON)

            DrawGrid(10, 1.0f)

        EndMode3D()

        DrawRectangle( 10, 10, 320, 93, Fade(SKYBLUE, 0.5f))
        DrawRectangleLines( 10, 10, 320, 93, BLUE)

        DrawText("Free camera default controls:", 20, 20, 10, BLACK)
        DrawText("- Mouse Wheel to Zoom in-out", 40, 40, 10, DARKGRAY)
        DrawText("- Mouse Wheel Pressed to Pan", 40, 60, 10, DARKGRAY)
        DrawText("- Z to target (0, 0, 0)", 40, 80, 10, DARKGRAY)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
