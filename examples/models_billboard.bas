/'******************************************************************************************
*
*   raylib [models] example - Drawing billboards
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
#define RAYMATH_IMPLEMENTATION
#include "raymath.bi"

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [models] example - drawing billboards")

' Define the camera to look into our 3d world
dim as Camera3D camera 
camera.position = type<Vector3>( 5.0f, 4.0f, 5.0f )    ' Camera position
camera.target = type<Vector3>( 0.0f, 2.0f, 0.0f )      ' Camera looking at point
camera.up = Vector3UnitY          ' Camera up vector (rotation towards target)
camera.fovy = 45.0f                                ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE             ' Camera projection type

var bill = LoadTexture("resources/billboard.png")    ' Our billboard texture
var billPositionStatic = type<Vector3>( 0.0f, 2.0f, 0.0f )          ' Position of static billboard
var billPositionRotating = type<Vector3>( 1.0f, 2.0f, 1.0f )        ' Position of rotating billboard

' Entire billboard texture, source is used to take a segment from a larger texture.
var source = type<Rectangle>( 0.0f, 0.0f, bill.width_, bill.height )

' NOTE: Billboard locked on axis-Y
var billUp = Vector3UnitY

' Set the height of the rotating billboard to 1.0 with the aspect ratio fixed
var size = type<Vector2>( source.width_/source.height, 1.0f )

' Rotate around origin
' Here we choose to rotate around the image center
var origin = Vector2Scale(size, 0.5f)

' Distance is needed for the correct billboard draw order
' Larger distance (further away from the camera) should be drawn prior to smaller distance.
var distanceStatic = 0.0f
var distanceRotating = 0.0f
var rotation = 0.0f

SetTargetFPS(60)                   ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())        ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    UpdateCamera(@camera, CAMERA_ORBITAL)

    rotation += 0.4f
    distanceStatic = Vector3Distance(camera.position, billPositionStatic)
    distanceRotating = Vector3Distance(camera.position, billPositionRotating)
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)

            DrawGrid(10, 1.0f)        ' Draw a grid

            ' Draw order matters!
            if (distanceStatic > distanceRotating) then
            
                DrawBillboard(camera, bill, billPositionStatic, 2.0f, WHITE)
                DrawBillboardPro(camera, bill, source, billPositionRotating, billUp, size, origin, rotation, WHITE)
             
            else
            
                DrawBillboardPro(camera, bill, source, billPositionRotating, billUp, size, origin, rotation, WHITE)
                DrawBillboard(camera, bill, billPositionStatic, 2.0f, WHITE)
            end if
            
        EndMode3D()

        DrawFPS(10, 10)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadTexture(bill)        ' Unload texture

CloseWindow()              ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
