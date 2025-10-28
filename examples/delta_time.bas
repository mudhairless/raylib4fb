/'******************************************************************************************
*
*   raylib [core] example - delta time
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 5.5, last time updated with raylib 5.6-dev
*
*   Example contributed by Robin (@RobinsAviary) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Robin (@RobinsAviary)
*
*******************************************************************************************'/

#include "raylib.bi"

' Initialization
'--------------------------------------------------------------------------------------
dim screenWidth as long = 800
dim screenHeight as long = 450

InitWindow(screenWidth, screenHeight, "raylib [core] example - delta time")

dim as long currentFps = 60

' Store the position for the both of the circles
dim deltaCircle as Vector2 = type<Vector2>( 0, csng(screenHeight/3.0f) )
dim frameCircle as Vector2 = type<Vector2>( 0, csng(screenHeight*(2.0f/3.0f)) )

' The speed applied to both circles
var speed  = 10.0f
var circleRadius  = 32.0f

SetTargetFPS(currentFps)
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose()) ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    ' Adjust the FPS target based on the mouse wheel
    var mouseWheel = GetMouseWheelMove()
    if (mouseWheel <> 0) then
        currentFps += clng(mouseWheel)
        if (currentFps < 0) then
            currentFps = 0
        end if
        SetTargetFPS(currentFps)
    end if

    ' GetFrameTime() returns the time it took to draw the last frame, in seconds (usually called delta time)
    ' Uses the delta time to make the circle look like it's moving at a "consistent" speed regardless of FPS

    ' Multiply by 6.0 (an arbitrary value) in order to make the speed 
    ' visually closer to the other circle (at 60 fps), for comparison
    deltaCircle.x += GetFrameTime()*6.0f*speed
    ' This circle can move faster or slower visually depending on the FPS
    frameCircle.x += 0.1f*speed

    ' If either circle is off the screen, reset it back to the start
    if (deltaCircle.x > screenWidth) then
        deltaCircle.x = 0
    end if
    if (frameCircle.x > screenWidth) then
        frameCircle.x = 0
    end if
    
    ' Reset both circles positions
    if (IsKeyPressed(KEY_R)) then
        deltaCircle.x = 0
        frameCircle.x = 0
    end if

    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()
        ClearBackground(RAYWHITE)

        ' Draw both circles to the screen
        DrawCircleV(deltaCircle, circleRadius, RED)
        DrawCircleV(frameCircle, circleRadius, BLUE)

        ' Draw the help text
        ' Determine what help text to show depending on the current FPS target
        var fpsText = TextFormat("FPS: %i (target: %i)", GetFPS(), currentFps)
        if (currentFps <= 0) then
            fpsText = TextFormat("FPS: unlimited (%i)", GetFPS())
       
            
        end if
        DrawText(fpsText, 10, 10, 20, DARKGRAY)
        DrawText(TextFormat("Frame time: %02.02f ms", GetFrameTime()), 10, 30, 20, DARKGRAY)
        DrawText("Use the scroll wheel to change the fps limit, r to reset", 10, 50, 20, DARKGRAY)

        ' Draw the text above the circles
        DrawText("FUNC: x += GetFrameTime()*speed", 10, 90, 20, RED)
        DrawText("FUNC: x += speed", 10, 240, 20, BLUE)
    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

