/'******************************************************************************************
*
*   raylib [core] example - Picking in 3d mode
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
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

InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d picking")

' Define the camera to look into our 3d world
dim as Camera3D camera
camera.position = Vector3One * 10 ' Camera position
camera.target = Vector3Zero      ' Camera looking at point
camera.up = Vector3UnitY          ' Camera up vector (rotation towards target)
camera.fovy = 45.0f                                ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE             ' Camera projection type

var cubePosition = Vector3UnitY
var cubeSize = Vector3One * 2

dim as Ray ray                     ' Picking line ray
dim as RayCollision collision      ' Ray collision hit info

SetTargetFPS(60)                   ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())        ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    if (IsCursorHidden()) then 
        UpdateCamera(@camera, CAMERA_FIRST_PERSON)
    end if

    ' Toggle camera controls
    if (IsMouseButtonPressed(MOUSE_BUTTON_RIGHT)) then
    
        if (IsCursorHidden()) then
            EnableCursor()
        else 
            DisableCursor()
        end if
    end if

    if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT)) then
    
        if (not collision.hit) then
        
            ray = GetScreenToWorldRay(GetMousePosition(), camera)

            ' Check collision between ray and box
            collision = GetRayCollisionBox(ray, _
                        type<BoundingBox>(type<Vector3>( cubePosition.x - cubeSize.x/2, cubePosition.y - cubeSize.y/2, cubePosition.z - cubeSize.z/2 ), _
                                        type<Vector3>( cubePosition.x + cubeSize.x/2, cubePosition.y + cubeSize.y/2, cubePosition.z + cubeSize.z/2 )))
        
        else 
            collision.hit = false
        end if
    end if
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)

            if (collision.hit) then
            
                DrawCube(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, RED)
                DrawCubeWires(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, MAROON)

                DrawCubeWires(cubePosition, cubeSize.x + 0.2f, cubeSize.y + 0.2f, cubeSize.z + 0.2f, GREEN)
            
            else
            
                DrawCube(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, GRAY)
                DrawCubeWires(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, DARKGRAY)
            
            end if

            DrawRay(ray, MAROON)
            DrawGrid(10, 1.0f)

        EndMode3D()

        DrawText("Try clicking on the box with your mouse!", 240, 10, 20, DARKGRAY)

        if (collision.hit) then
            DrawText("BOX SELECTED", (screenWidth - MeasureText("BOX SELECTED", 30)) / 2, int(screenHeight * 0.1f), 30, GREEN)
        end if

        DrawText("Right click mouse to toggle camera controls", 10, 430, 10, GRAY)

        DrawFPS(10, 10)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
