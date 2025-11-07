/'******************************************************************************************
*
*   raylib [models] example - first person maze
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2024 Ramon Santamaria (@raysan5)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include "raylib.bi"

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [models] example - first person maze")

' Define the camera to look into our 3d world
dim as Camera3D camera 
camera.position = type<Vector3>( 0.2f, 0.4f, 0.2f )    ' Camera position
camera.target = type<Vector3>( 0.185f, 0.4f, 0.0f )    ' Camera looking at point
camera.up = type<Vector3>( 0.0f, 1.0f, 0.0f )          ' Camera up vector (rotation towards target)
camera.fovy = 45.0f                                ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE             ' Camera projection type

var imMap = LoadImage("resources/cubicmap.png")      ' Load cubicmap image (RAM)
var cubicmap = LoadTextureFromImage(imMap)       ' Convert image to texture to display (VRAM)
var mesh = GenMeshCubicmap(imMap, type<Vector3>( 1.0f, 1.0f, 1.0f ))
var model = LoadModelFromMesh(mesh)

' NOTE: By default each cube is mapped to one part of texture atlas
var texture = LoadTexture("resources/cubicmap_atlas.png")    ' Load map texture
model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture    ' Set map diffuse texture

' Get map image data to be used for collision detection
var mapPixels = LoadImageColors(@imMap)
UnloadImage(imMap)             ' Unload image from RAM

var mapPosition = type<Vector3>( -16.0f, 0.0f, -8.0f )  ' Set model position

DisableCursor()                ' Limit cursor to relative movement inside the window

SetTargetFPS(60)               ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())    ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    var oldCamPos = camera.position    ' Store old camera position

    UpdateCamera(@camera, CAMERA_FIRST_PERSON)

    ' Check player collision (we simplify to 2D collision detection)
    var playerPos = type<Vector2>( camera.position.x, camera.position.z )
    var playerRadius = 0.1f  ' Collision radius (player is modelled as a cilinder for collision)

    var playerCellX = clng(playerPos.x - mapPosition.x + 0.5f)
    var playerCellY = clng(playerPos.y - mapPosition.z + 0.5f)

    ' Out-of-limits security check
    if (playerCellX < 0) then
        playerCellX = 0
    elseif (playerCellX >= cubicmap.width_) then
        playerCellX = cubicmap.width_ - 1
    end if

    if (playerCellY < 0) then
        playerCellY = 0
    elseif (playerCellY >= cubicmap.height) then
        playerCellY = cubicmap.height - 1
    end if

    ' Check map collisions using image data and player position
    ' TODO: Improvement: Just check player surrounding cells for collision
    for y as long = 0 to cubicmap.height - 1
        for x as long = 0 to cubicmap.width_ - 1    
        
            if ((mapPixels[y*cubicmap.width_ + x].r = 255) AND _       ' Collision: white pixel, only check R channel
                (CheckCollisionCircleRec(playerPos, playerRadius, _
                type<Rectangle>( mapPosition.x - 0.5f + x*1.0f, mapPosition.z - 0.5f + y*1.0f, 1.0f, 1.0f )))) then
            
                ' Collision detected, reset camera position
                camera.position = oldCamPos
            end if
        next x
    next y
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)
            DrawModel(model, mapPosition, 1.0f, WHITE)                     ' Draw maze map
        EndMode3D()

        DrawTextureEx(cubicmap, type<Vector2>( GetScreenWidth() - cubicmap.width_*4.0f - 20, 20.0f ), 0.0f, 4.0f, WHITE)
        DrawRectangleLines(GetScreenWidth() - cubicmap.width_*4 - 20, 20, cubicmap.width_*4, cubicmap.height*4, GREEN)

        ' Draw player position radar
        DrawRectangle(GetScreenWidth() - cubicmap.width_*4 - 20 + playerCellX*4, 20 + playerCellY*4, 4, 4, RED)

        DrawFPS(10, 10)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadImageColors(mapPixels)   ' Unload color array

UnloadTexture(cubicmap)        ' Unload cubicmap texture
UnloadTexture(texture)         ' Unload map texture
UnloadModel(model)             ' Unload map model

CloseWindow()                  ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
