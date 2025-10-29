/'******************************************************************************************
*
*   raylib [core] example - 2D Camera system
*
*   Example originally created with raylib 1.5, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2024 Ramon Santamaria (@raysan5)
*
*******************************************************************************************'/

#include "raylib.bi"

#define MAX_BUILDINGS   100

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")

var player = type<Rectangle>( 400, 280, 40, 40 )
dim as Rectangle buildings(0 to MAX_BUILDINGS - 1)
dim as RayColor buildColors(0 to MAX_BUILDINGS - 1)

var spacing = 0

for i as integer = 0 to MAX_BUILDINGS - 1

    buildings(i).width_ = GetRandomValue(50, 200)
    buildings(i).height = GetRandomValue(100, 800)
    buildings(i).y = screenHeight - 130.0f - buildings(i).height
    buildings(i).x = -6000.0f + spacing

    spacing += int(buildings(i).width_)

    buildColors(i) = type<RayColor>( GetRandomValue(200, 240), GetRandomValue(200, 240), GetRandomValue(200, 250), 255 )

next i

dim as Camera2D camera
camera.target = type<Vector2>( player.x + 20.0f, player.y + 20.0f )
camera.offset = type<Vector2>( screenWidth/2.0f, screenHeight/2.0f )
camera.rotation = 0.0f
camera.zoom = 1.0f

SetTargetFPS(60)                   ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())        ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    ' Player movement
    if (IsKeyDown(KEY_D)) then
        player.x += 2
    elseif (IsKeyDown(KEY_A)) then 
        player.x -= 2
    end if

    ' Camera target follows player
    camera.target = type<Vector2>( player.x + 20, player.y + 20 )

    ' Camera rotation controls
    if (IsKeyDown(KEY_LEFT)) then
        camera.rotation -= 1
    elseif (IsKeyDown(KEY_RIGHT)) then
        camera.rotation += 1
    end if

    ' Limit camera rotation to 80 degrees (-40 to 40)
    if (camera.rotation > 40) then 
        camera.rotation = 40
    elseif (camera.rotation < -40) then 
        camera.rotation = -40
    end if

    ' Camera zoom controls
    camera.zoom += (GetMouseWheelMove()*0.05f)

    if (camera.zoom > 3.0f) then 
        camera.zoom = 3.0f
    elseif (camera.zoom < 0.1f) then
        camera.zoom = 0.1f
    end if

    ' Camera reset (zoom and rotation)
    if (IsKeyPressed(KEY_R)) then
        camera.zoom = 1.0f
        camera.rotation = 0.0f
    end if
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode2D(camera)

            DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY)

            for i as integer = 0 to MAX_BUILDINGS - 1
                DrawRectangleRec(buildings(i), buildColors(i))
            next i

            DrawRectangleRec(player, RED)

            DrawLine(int(camera.target.x), -screenHeight*10, int(camera.target.x), screenHeight*10, GREEN)
            DrawLine(-screenWidth*10, int(camera.target.y), screenWidth*10, int(camera.target.y), GREEN)

        EndMode2D()

        DrawText("SCREEN AREA", 640, 10, 20, RED)

        DrawRectangle(0, 0, screenWidth, 5, RED)
        DrawRectangle(0, 5, 5, screenHeight - 10, RED)
        DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, RED)
        DrawRectangle(0, screenHeight - 5, screenWidth, 5, RED)

        DrawRectangle( 10, 10, 250, 113, Fade(SKYBLUE, 0.5f))
        DrawRectangleLines( 10, 10, 250, 113, BLUE)

        DrawText("Free 2d camera controls:", 20, 20, 10, BLACK)
        DrawText("- A/D to move Offset", 40, 40, 10, DARKGRAY)
        DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, DARKGRAY)
        DrawText("- LEFT / RIGHT to Rotate", 40, 80, 10, DARKGRAY)
        DrawText("- R to reset Zoom and Rotation", 40, 100, 10, DARKGRAY)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
