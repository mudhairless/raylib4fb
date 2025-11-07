/'******************************************************************************************
*
*   raylib [models] example - Detect basic 3d collisions (box vs sphere vs box)
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2024 Ramon Santamaria (@raysan5)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include "raylib.bi"

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [models] example - box collisions")

' Define the camera to look into our 3d world
dim as Camera3D camera = type<Camera3D>( type<Vector3>( 0.0f, 10.0f, 10.0f ), type<Vector3>( 0.0f, 0.0f, 0.0f ), type<Vector3>( 0.0f, 1.0f, 0.0f ), 45.0f, 0 )

var playerPosition = type<Vector3>( 0.0f, 1.0f, 2.0f )
var playerSize = type<Vector3>( 1.0f, 2.0f, 1.0f )
var playerColor = GREEN

var enemyBoxPos = type<Vector3>( -4.0f, 1.0f, 0.0f )
var enemyBoxSize = type<Vector3>( 2.0f, 2.0f, 2.0f )

var enemySpherePos = type<Vector3>( 4.0f, 0.0f, 0.0f )
var enemySphereSize = 1.5f

var collision = false

SetTargetFPS(60)               ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())    ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------

    ' Move player
    if (IsKeyDown(KEY_D)) then
        playerPosition.x += 0.2f
    elseif (IsKeyDown(KEY_A)) then
        playerPosition.x -= 0.2f
    elseif (IsKeyDown(KEY_S)) then
        playerPosition.z += 0.2f
    elseif (IsKeyDown(KEY_W)) then
        playerPosition.z -= 0.2f
    end if

    collision = false

    ' Check collisions player vs enemy-box
    if (CheckCollisionBoxes( _
        type<BoundingBox>( _
            type<Vector3>( playerPosition.x - playerSize.x/2, _
                            playerPosition.y - playerSize.y/2, _
                            playerPosition.z - playerSize.z/2 ), _
            type<Vector3>( playerPosition.x + playerSize.x/2, _
                            playerPosition.y + playerSize.y/2, _
                            playerPosition.z + playerSize.z/2 ) _
        ), _
        type<BoundingBox>( _
            type<Vector3>( enemyBoxPos.x - enemyBoxSize.x/2, _
                            enemyBoxPos.y - enemyBoxSize.y/2, _
                            enemyBoxPos.z - enemyBoxSize.z/2 ), _
            type<Vector3>( enemyBoxPos.x + enemyBoxSize.x/2, _
                        enemyBoxPos.y + enemyBoxSize.y/2, _
                        enemyBoxPos.z + enemyBoxSize.z/2 ) _
        ))) then
            collision = true
    end if

    ' Check collisions player vs enemy-sphere
    if (CheckCollisionBoxSphere( _
        type<BoundingBox>( _
            type<Vector3>( playerPosition.x - playerSize.x/2, _
                            playerPosition.y - playerSize.y/2, _
                            playerPosition.z - playerSize.z/2 ), _
            type<Vector3>( playerPosition.x + playerSize.x/2, _
                            playerPosition.y + playerSize.y/2, _
                            playerPosition.z + playerSize.z/2 ) _
        ), _
        enemySpherePos, enemySphereSize) _
        ) then
            collision = true
        end if

    if (collision) then
        playerColor = RED
    else 
        playerColor = GREEN
    end if
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)

            ' Draw enemy-box
            DrawCube(enemyBoxPos, enemyBoxSize.x, enemyBoxSize.y, enemyBoxSize.z, GRAY)
            DrawCubeWires(enemyBoxPos, enemyBoxSize.x, enemyBoxSize.y, enemyBoxSize.z, DARKGRAY)

            ' Draw enemy-sphere
            DrawSphere(enemySpherePos, enemySphereSize, GRAY)
            DrawSphereWires(enemySpherePos, enemySphereSize, 16, 16, DARKGRAY)

            ' Draw player
            DrawCubeV(playerPosition, playerSize, playerColor)

            DrawGrid(10, 1.0f)        ' Draw a grid

        EndMode3D()

        DrawText("Move player with WASD keys to collide", 220, 40, 20, GRAY)

        DrawFPS(10, 10)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
