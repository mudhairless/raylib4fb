/'******************************************************************************************
*
*   raylib [core] example - 3d cmaera split screen
*
*   Example originally created with raylib 3.7, last time updated with raylib 4.0
*
*   Example contributed by Jeffery Myers (@JeffM2501) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2024 Jeffery Myers (@JeffM2501)
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

InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera split screen")

' Setup player 1 camera and screen
dim as Camera3D cameraPlayer1 
cameraPlayer1.fovy = 45.0f
cameraPlayer1.up.y = 1.0f
cameraPlayer1.target.y = 1.0f
cameraPlayer1.position.z = -3.0f
cameraPlayer1.position.y = 1.0f

var screenPlayer1 = LoadRenderTexture(screenWidth/2, screenHeight)

' Setup player two camera and screen
dim as Camera3D cameraPlayer2 
cameraPlayer2.fovy = 45.0f
cameraPlayer2.up.y = 1.0f
cameraPlayer2.target.y = 3.0f
cameraPlayer2.position.x = -3.0f
cameraPlayer2.position.y = 3.0f

var screenPlayer2 = LoadRenderTexture(screenWidth / 2, screenHeight)

' Build a flipped rectangle the size of the split view to use for drawing later
var splitScreenRect = type<Rectangle>( 0.0f, 0.0f, screenPlayer1.texture.width_, -screenPlayer1.texture.height )

' Grid data
var count = 5
var spacing = 4f

SetTargetFPS(60)               ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())    ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    ' If anyone moves this frame, how far will they move based on the time since the last frame
    ' this moves thigns at 10 world units per second, regardless of the actual FPS
    var offsetThisFrame = 10.0f*GetFrameTime()

    ' Move Player1 forward and backwards (no turning)
    if (IsKeyDown(KEY_W)) then
    
        cameraPlayer1.position.z += offsetThisFrame
        cameraPlayer1.target.z += offsetThisFrame
    
    elseif (IsKeyDown(KEY_S)) then
    
        cameraPlayer1.position.z -= offsetThisFrame
        cameraPlayer1.target.z -= offsetThisFrame
    end if

    ' Move Player2 forward and backwards (no turning)
    if (IsKeyDown(KEY_UP)) then
    
        cameraPlayer2.position.x += offsetThisFrame
        cameraPlayer2.target.x += offsetThisFrame
    
    elseif (IsKeyDown(KEY_DOWN)) then
    
        cameraPlayer2.position.x -= offsetThisFrame
        cameraPlayer2.target.x -= offsetThisFrame
    
    end if
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    ' Draw Player1 view to the render texture
    BeginTextureMode(screenPlayer1)
        ClearBackground(SKYBLUE)
        
        BeginMode3D(cameraPlayer1)
        
            ' Draw scene: grid of cube trees on a plane to make a "world"
            DrawPlane(Vector3Zero, Vector2One * 50, BEIGE) ' Simple world plane

            for x as single = -count * spacing to count * spacing step spacing

                for z as single = -count * spacing to count * spacing step spacing
                
                    DrawCube(type<Vector3>( x, 1.5f, z ), 1, 1, 1, LIME)
                    DrawCube(type<Vector3>( x, 0.5f, z ), 0.25f, 1, 0.25f, BROWN)

                next z
            
            next x

            ' Draw a cube at each player's position
            DrawCube(cameraPlayer1.position, 1, 1, 1, RED)
            DrawCube(cameraPlayer2.position, 1, 1, 1, BLUE)
            
        EndMode3D()
        
        DrawRectangle(0, 0, GetScreenWidth()/2, 40, Fade(RAYWHITE, 0.8f))
        DrawText("PLAYER1: W/S to move", 10, 10, 20, MAROON)
        
    EndTextureMode()

    ' Draw Player2 view to the render texture
    BeginTextureMode(screenPlayer2)
        ClearBackground(SKYBLUE)
        
        BeginMode3D(cameraPlayer2)
        
            ' Draw scene: grid of cube trees on a plane to make a "world"
            DrawPlane(Vector3Zero, Vector2One * 50, BEIGE) ' Simple world plane

            for x as single = -count * spacing to count * spacing step spacing

                for z as single = -count * spacing to count * spacing step spacing
                
                    DrawCube(type<Vector3>( x, 1.5f, z ), 1, 1, 1, LIME)
                    DrawCube(type<Vector3>( x, 0.5f, z ), 0.25f, 1, 0.25f, BROWN)

                next z
            
            next x

            ' Draw a cube at each player's position
            DrawCube(cameraPlayer1.position, 1, 1, 1, RED)
            DrawCube(cameraPlayer2.position, 1, 1, 1, BLUE)
            
        EndMode3D()
        
        DrawRectangle(0, 0, GetScreenWidth()/2, 40, Fade(RAYWHITE, 0.8f))
        DrawText("PLAYER2: UP/DOWN to move", 10, 10, 20, DARKBLUE)
        
    EndTextureMode()

    ' Draw both views render textures to the screen side by side
    BeginDrawing()
        ClearBackground(BLACK)
        
        DrawTextureRec(screenPlayer1.texture, splitScreenRect, Vector2Zero, WHITE)
        DrawTextureRec(screenPlayer2.texture, splitScreenRect, type<Vector2>( screenWidth/2.0f, 0 ), WHITE)
        
        DrawRectangle(GetScreenWidth()/2 - 2, 0, 4, GetScreenHeight(), LIGHTGRAY)
    EndDrawing()

wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadRenderTexture(screenPlayer1) ' Unload render texture
UnloadRenderTexture(screenPlayer2) ' Unload render texture

CloseWindow()                      ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
