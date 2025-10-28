/'******************************************************************************************
*
*   raylib [shapes] example - kaleidoscope
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.5, last time updated with raylib 5.6
*
*   Example contributed by Hugo ARNAL (@hugoarnal) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Hugo ARNAL (@hugoarnal)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include "raylib.bi"
#define RAYMATH_IMPLEMENTATION
#include "raymath.bi"

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [shapes] example - kaleidoscope")

var symmetry = 6
var angle = 360.0f/csng(symmetry)
var thickness = 3.0f
var prevMousePos = Vector2Zero

SetTargetFPS(60)
'ClearBackground(BLACK) ' uncomment here and comment the other one on line 62 for a trippy pattern

var offset = type<Vector2>( screenWidth/2.0f, screenHeight/2.0f )
dim as Camera2D camera
camera.target = Vector2Zero
camera.offset = offset
camera.rotation = 0.0f
camera.zoom = 1.0f

var scaleVector = type<Vector2>( 1.0f, -1.0f )
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())    ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    var mousePos = GetMousePosition()
    var lineStart = Vector2Subtract(mousePos, offset)
    var lineEnd = Vector2Subtract(prevMousePos, offset)
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()
        ClearBackground(BLACK)
        BeginMode2D(camera)
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
                for i as integer = 0 to symmetry - 1
                
                    lineStart = Vector2Rotate(lineStart, angle*DEG2RAD)
                    lineEnd = Vector2Rotate(lineEnd, angle*DEG2RAD)

                    DrawLineEx(lineStart, lineEnd, thickness, WHITE)

                    var reflectLineStart = Vector2Multiply(lineStart, scaleVector)
                    var reflectLineEnd = Vector2Multiply(lineEnd, scaleVector)

                    DrawLineEx(reflectLineStart, reflectLineEnd, thickness, WHITE)
                next i
            end if

            prevMousePos = mousePos
        EndMode2D()
    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------

CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
