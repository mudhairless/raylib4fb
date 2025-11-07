/'******************************************************************************************
*
*   raylib [core] example - Using bones as socket for calculating the positioning of something
* 
*   Example originally created with raylib 4.5, last time updated with raylib 4.5
*
*   Example contributed by iP (@ipzaur) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2024 iP (@ipzaur)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include "raylib.bi"
#define RAYMATH_IMPLEMENTATION
#include "raymath.bi"

#define BONE_SOCKETS        3
#define BONE_SOCKET_HAT     0
#define BONE_SOCKET_HAND_R  1
#define BONE_SOCKET_HAND_L  2


' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [models] example - bone socket")

' Define the camera to look into our 3d world
dim as Camera3D camera
camera.position = Vector3One * 5 ' Camera position
camera.target = Vector3UnitY * 2  ' Camera looking at point
camera.up = Vector3UnitY      ' Camera up vector (rotation towards target)
camera.fovy = 45.0f                            ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE         ' Camera projection type

' Load gltf model
var characterModel = LoadModel("resources/models/gltf/greenman.glb") ' Load character model
dim as Model equipModel(0 to BONE_SOCKETS - 1) = { _
    LoadModel("resources/models/gltf/greenman_hat.glb"), _   ' Index for the hat model is the same as BONE_SOCKET_HAT
    LoadModel("resources/models/gltf/greenman_sword.glb"), _  ' Index for the sword model is the same as BONE_SOCKET_HAND_R
    LoadModel("resources/models/gltf/greenman_shield.glb") _ ' Index for the shield model is the same as BONE_SOCKET_HAND_L
}

dim as boolean showEquip(0 to BONE_SOCKETS -1) = { true, true, true }   ' Toggle on/off equip

' Load gltf model animations
var animsCount = 0l
var animIndex = 0l
var animCurrentFrame = 0l
var modelAnimations = LoadModelAnimations("resources/models/gltf/greenman.glb", @animsCount)

' indices of bones for sockets
dim as long boneSocketIndex(0 to BONE_SOCKETS - 1) = { -1, -1, -1 }

' search bones for sockets 
for i as long = 0 to characterModel.boneCount - 1

    if (TextIsEqual(characterModel.bones[i].name_, "socket_hat")) then
    
        boneSocketIndex(BONE_SOCKET_HAT) = i
        continue for
    end if
    
    if (TextIsEqual(characterModel.bones[i].name_, "socket_hand_R")) then
    
        boneSocketIndex(BONE_SOCKET_HAND_R) = i
        continue for
    end if
    
    if (TextIsEqual(characterModel.bones[i].name_, "socket_hand_L")) then
    
        boneSocketIndex(BONE_SOCKET_HAND_L) = i
        continue for
    end if
next i

var position = Vector3Zero ' Set model position
dim as ushort angle = 0           ' Set angle for rotate character

DisableCursor()                    ' Limit cursor to relative movement inside the window

SetTargetFPS(60)                   ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())        ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    UpdateCamera(@camera, CAMERA_THIRD_PERSON)
    
    ' Rotate character
    if (IsKeyDown(KEY_F)) then
        angle = (angle + 1) mod 360
    elseif (IsKeyDown(KEY_H)) then
        angle = (360 + angle - 1) mod 360
    end if

    ' Select current animation
    if (IsKeyPressed(KEY_T)) then
        animIndex = (animIndex + 1) mod animsCount
    elseif (IsKeyPressed(KEY_G)) then
        animIndex = (animIndex + animsCount - 1) mod animsCount
    end if

    ' Toggle shown of equip
    if (IsKeyPressed(KEY_ONE)) then
        showEquip(BONE_SOCKET_HAT) = not showEquip(BONE_SOCKET_HAT)
    end if
    if (IsKeyPressed(KEY_TWO)) then
        showEquip(BONE_SOCKET_HAND_R) = not showEquip(BONE_SOCKET_HAND_R)
    end if
    if (IsKeyPressed(KEY_THREE)) then
        showEquip(BONE_SOCKET_HAND_L) = not showEquip(BONE_SOCKET_HAND_L)
    end if
    
    ' Update model animation
    var anim = modelAnimations[animIndex]
    animCurrentFrame = (animCurrentFrame + 1) mod anim.frameCount
    UpdateModelAnimation(characterModel, anim, animCurrentFrame)
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)
            ' Draw character
            var characterRotate = QuaternionFromAxisAngle(Vector3UnitY, angle*DEG2RAD)
            characterModel.transform = MatrixMultiply(QuaternionToMatrix(characterRotate), MatrixTranslate(position.x, position.y, position.z))
            UpdateModelAnimation(characterModel, anim, animCurrentFrame)
            DrawMesh(characterModel.meshes[0], characterModel.materials[1], characterModel.transform)

            ' Draw equipments (hat, sword, shield)
            for i as long = 0 to BONE_SOCKETS - 1
            
                if (not showEquip(i)) then
                    continue for
                end if

                var transform = @anim.framePoses[animCurrentFrame][boneSocketIndex(i)]
                var inRotation = characterModel.bindPose[boneSocketIndex(i)].rotation
                var outRotation = transform->rotation
                
                ' Calculate socket rotation (angle between bone in initial pose and same bone in current animation frame)
                var rotate = QuaternionMultiply(outRotation, QuaternionInvert(inRotation))
                var matrixTransform = QuaternionToMatrix(rotate)
                ' Translate socket to its position in the current animation
                matrixTransform = MatrixMultiply(matrixTransform, MatrixTranslate(transform->translation.x, transform->translation.y, transform->translation.z))
                ' Transform the socket using the transform of the character (angle and translate)
                matrixTransform = MatrixMultiply(matrixTransform, characterModel.transform)
                
                ' Draw mesh at socket position with socket angle rotation
                DrawMesh(equipModel(i).meshes[0], equipModel(i).materials[1], matrixTransform)
            next i

            DrawGrid(10, 1.0f)
        EndMode3D()

        DrawText("Use the T/G to switch animation", 10, 10, 20, GRAY)
        DrawText("Use the F/H to rotate character left/right", 10, 35, 20, GRAY)
        DrawText("Use the 1,2,3 to toggle shown of hat, sword and shield", 10, 60, 20, GRAY)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadModelAnimations(modelAnimations, animsCount)
UnloadModel(characterModel)         ' Unload character model and meshes/material

' Unload equipment model and meshes/material
for i as long = 0 to BONE_SOCKETS - 1
    UnloadModel(equipModel(i))
next i

CloseWindow()              ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
