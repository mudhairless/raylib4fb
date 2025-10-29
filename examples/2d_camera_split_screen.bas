/'******************************************************************************************
*
*   raylib [core] example - 2d camera split screen
*
*   Addapted from the core_3d_camera_split_screen example: 
*       https:'github.com/raysan5/raylib/blob/master/examples/core/core_3d_camera_split_screen.c
*
*   Example originally created with raylib 4.5, last time updated with raylib 4.5
*
*   Example contributed by Gabriel dos Santos Sanches (@gabrielssanches) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2023 Gabriel dos Santos Sanches (@gabrielssanches)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include "raylib.bi"
#include "raymath.bi"

#define PLAYER_SIZE 40

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 440

InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera split screen")

var player1 = type<Rectangle>( 200, 200, PLAYER_SIZE, PLAYER_SIZE )
var player2 = type<Rectangle>( 250, 200, PLAYER_SIZE, PLAYER_SIZE )

dim as Camera2D camera1
camera1.target = type<Vector2>( player1.x, player1.y )
camera1.offset = type<Vector2>( 200.0f, 200.0f )
camera1.rotation = 0.0f
camera1.zoom = 1.0f

dim as Camera2D camera2 
camera2.target = type<Vector2>( player2.x, player2.y )
camera2.offset = type<Vector2>( 200.0f, 200.0f )
camera2.rotation = 0.0f
camera2.zoom = 1.0f

var screenCamera1 = LoadRenderTexture(screenWidth/2, screenHeight)
var screenCamera2 = LoadRenderTexture(screenWidth/2, screenHeight)

' Build a flipped rectangle the size of the split view to use for drawing later
var splitScreenRect = type<Rectangle>( 0.0f, 0.0f, screenCamera1.texture.width_, -screenCamera1.texture.height )

SetTargetFPS(60)               ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())    ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    if (IsKeyDown(KEY_S)) then 
        player1.y += 3.0f
    elseif (IsKeyDown(KEY_W)) then 
        player1.y -= 3.0f
    end if
    if (IsKeyDown(KEY_D)) then 
        player1.x += 3.0f
    elseif (IsKeyDown(KEY_A)) then 
        player1.x -= 3.0f
    end if

    if (IsKeyDown(KEY_UP)) then 
        player2.y -= 3.0f
    elseif (IsKeyDown(KEY_DOWN)) then 
        player2.y += 3.0f
    end if
    if (IsKeyDown(KEY_RIGHT)) then 
        player2.x += 3.0f
    elseif (IsKeyDown(KEY_LEFT)) then 
        player2.x -= 3.0f
    end if

    camera1.target = type<Vector2>( player1.x, player1.y )
    camera2.target = type<Vector2>( player2.x, player2.y )
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginTextureMode(screenCamera1)
        ClearBackground(RAYWHITE)
        
        BeginMode2D(camera1)
        
            ' Draw full scene with first camera
            for i as integer = 0 to screenWidth / PLAYER_SIZE
                DrawLineV(type<Vector2>(PLAYER_SIZE*i, 0), type<Vector2>( PLAYER_SIZE*i, screenHeight), LIGHTGRAY)
            next i

            for i as integer = 0 to screenHeight / PLAYER_SIZE
                DrawLineV(type<Vector2>(0, PLAYER_SIZE*i), type<Vector2>( screenWidth, PLAYER_SIZE*i), LIGHTGRAY)
            next i

            for i as integer = 0 to screenWidth / PLAYER_SIZE
                for j as integer = 0 to screenHeight / PLAYER_SIZE
                    DrawText(TextFormat("[%i,%i]", i, j), 10 + PLAYER_SIZE*i, 15 + PLAYER_SIZE*j, 10, LIGHTGRAY)
                next j
            next i

            DrawRectangleRec(player1, RED)
            DrawRectangleRec(player2, BLUE)
        EndMode2D()
        
        DrawRectangle(0, 0, GetScreenWidth()/2, 30, Fade(RAYWHITE, 0.6f))
        DrawText("PLAYER1: W/S/A/D to move", 10, 10, 10, MAROON)
        
    EndTextureMode()

    BeginTextureMode(screenCamera2)
        ClearBackground(RAYWHITE)
        
        BeginMode2D(camera2)
        
            ' Draw full scene with second camera
            for i as integer = 0 to screenWidth / PLAYER_SIZE
                DrawLineV(type<Vector2>(PLAYER_SIZE*i, 0), type<Vector2>( PLAYER_SIZE*i, screenHeight), LIGHTGRAY)
            next i

            for i as integer = 0 to screenHeight / PLAYER_SIZE
                DrawLineV(type<Vector2>(0, PLAYER_SIZE*i), type<Vector2>( screenWidth, PLAYER_SIZE*i), LIGHTGRAY)
            next i

            for i as integer = 0 to screenWidth / PLAYER_SIZE
                for j as integer = 0 to screenHeight / PLAYER_SIZE
                    DrawText(TextFormat("[%i,%i]", i, j), 10 + PLAYER_SIZE*i, 15 + PLAYER_SIZE*j, 10, LIGHTGRAY)
                next j
            next i

            DrawRectangleRec(player1, RED)
            DrawRectangleRec(player2, BLUE)
            
        EndMode2D()
        
        DrawRectangle(0, 0, GetScreenWidth()/2, 30, Fade(RAYWHITE, 0.6f))
        DrawText("PLAYER2: UP/DOWN/LEFT/RIGHT to move", 10, 10, 10, DARKBLUE)
        
    EndTextureMode()

    ' Draw both views render textures to the screen side by side
    BeginDrawing()
        ClearBackground(BLACK)
        
        DrawTextureRec(screenCamera1.texture, splitScreenRect, Vector2Zero, WHITE)
        DrawTextureRec(screenCamera2.texture, splitScreenRect, type<Vector2>( screenWidth/2.0f, 0 ), WHITE)
        
        DrawRectangle(GetScreenWidth()/2 - 2, 0, 4, GetScreenHeight(), LIGHTGRAY)
    EndDrawing()

wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadRenderTexture(screenCamera1) ' Unload render texture
UnloadRenderTexture(screenCamera2) ' Unload render texture

CloseWindow()                      ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
