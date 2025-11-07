/'******************************************************************************************
*
*   raylib [core] example - Smooth Pixel-perfect camera
*
*   Example originally created with raylib 3.7, last time updated with raylib 4.0
*   
*   Example contributed by Giancamillo Alessandroni (@NotManyIdeasDev) and
*   reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2024 Giancamillo Alessandroni (@NotManyIdeasDev) and Ramon Santamaria (@raysan5)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include "raylib.bi"

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

const virtualScreenWidth = 160
const virtualScreenHeight = 90

const virtualRatio = csng(screenWidth/virtualScreenWidth)

InitWindow(screenWidth, screenHeight, "raylib [core] example - smooth pixel-perfect camera")

dim as Camera2D worldSpaceCamera   ' Game world camera
worldSpaceCamera.zoom = 1.0f

dim as Camera2D screenSpaceCamera  ' Smoothing camera
screenSpaceCamera.zoom = 1.0f

var target = LoadRenderTexture(virtualScreenWidth, virtualScreenHeight) ' This is where we'll draw all our objects.

var rec01 = type<Rectangle>( 70.0f, 35.0f, 20.0f, 20.0f )
var rec02 = type<Rectangle>( 90.0f, 55.0f, 30.0f, 10.0f )
var rec03 = type<Rectangle>( 80.0f, 65.0f, 15.0f, 25.0f )

' The target's height is flipped (in the source Rectangle), due to OpenGL reasons
var sourceRec = type<Rectangle>( 0.0f, 0.0f, target.texture.width_, -target.texture.height )
var destRec = type<Rectangle>( -virtualRatio, -virtualRatio, screenWidth + (virtualRatio*2), screenHeight + (virtualRatio*2) )

var origin = type<Vector2>( 0.0f, 0.0f )

var rotation = 0.0f

var cameraX = 0.0f
var cameraY = 0.0f

SetTargetFPS(60)
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())    ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    rotation += 60.0f*GetFrameTime()   ' Rotate the rectangles, 60 degrees per second

    ' Make the camera move to demonstrate the effect
    cameraX = (sin(GetTime())*50.0f) - 10.0f
    cameraY = cos(GetTime())*30.0f

    ' Set the camera's target to the values computed above
    screenSpaceCamera.target = type<Vector2>( cameraX, cameraY )

    ' Round worldSpace coordinates, keep decimals into screenSpace coordinates
    worldSpaceCamera.target.x = fix(screenSpaceCamera.target.x)
    screenSpaceCamera.target.x -= worldSpaceCamera.target.x
    screenSpaceCamera.target.x *= virtualRatio

    worldSpaceCamera.target.y = fix(screenSpaceCamera.target.y)
    screenSpaceCamera.target.y -= worldSpaceCamera.target.y
    screenSpaceCamera.target.y *= virtualRatio
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginTextureMode(target)
        ClearBackground(RAYWHITE)

        BeginMode2D(worldSpaceCamera)
            DrawRectanglePro(rec01, origin, rotation, BLACK)
            DrawRectanglePro(rec02, origin, -rotation, RED)
            DrawRectanglePro(rec03, origin, rotation + 45.0f, BLUE)
        EndMode2D()
    EndTextureMode()

    BeginDrawing()
        ClearBackground(RED)

        BeginMode2D(screenSpaceCamera)
            DrawTexturePro(target.texture, sourceRec, destRec, origin, 0.0f, WHITE)
        EndMode2D()

        DrawText(TextFormat("Screen resolution: %ix%i", screenWidth, screenHeight), 10, 10, 20, DARKBLUE)
        DrawText(TextFormat("World resolution: %ix%i", virtualScreenWidth, virtualScreenHeight), 10, 40, 20, DARKGREEN)
        DrawFPS(GetScreenWidth() - 95, 10)
    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadRenderTexture(target)    ' Unload render texture

CloseWindow()                  ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
