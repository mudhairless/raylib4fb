/'******************************************************************************************
*
*   raylib [core] example - Initialize 3d camera mode
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2024 Ramon Santamaria (@raysan5)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include once "raylib.bi"
#include once "raymath.bi"

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera mode")

' Define the camera to look into our 3d world
dim as Camera3D camera
camera.position = type<Vector3>( 0.0f, 10.0f, 10.0f )  ' Camera position
camera.target = Vector3Zero     ' Camera looking at point
camera.up = Vector3UnitY          ' Camera up vector (rotation towards target)
camera.fovy = 45.0f                                ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE             ' Camera mode type

var cubePosition = Vector3Zero

SetTargetFPS(60)               ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())    ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    ' TODO: Update your variables here
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)

            DrawCube(cubePosition, 2.0f, 2.0f, 2.0f, RED)
            DrawCubeWires(cubePosition, 2.0f, 2.0f, 2.0f, GRAY)

            DrawGrid(10, 1.0f)

        EndMode3D()

        DrawText("Welcome to the third dimension!", 10, 40, 20, DARKGRAY)

        DrawFPS(10, 10)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
