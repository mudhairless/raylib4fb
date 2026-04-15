/'******************************************************************************************
*
*   rres example - rres load image
*
*   This example has been created using rres 1.0 (github.com/raysan5/rres)
*   This example uses raylib 5.5 (www.raylib.com) to display loaded data
*
*
*   LICENSE: MIT
*
*   Copyright (c) 2022-2024 Ramon Santamaria (@raysan5)
*
*   Permission is hereby granted, free of charge, to any person obtaining a copy
*   of this software and associated documentation files (the "Software"), to deal
*   in the Software without restriction, including without limitation the rights
*   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*   copies of the Software, and to permit persons to whom the Software is
*   furnished to do so, subject to the following conditions:
*
*   The above copyright notice and this permission notice shall be included in all
*   copies or substantial portions of the Software.
*
*   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*   SOFTWARE.
*
*********************************************************************************************'/

#include "raylib.bi"
#include "rres.bi" 'Required to read rres data chunks
#include "rres-raylib.bi" 'Required to map rres data chunks into raylib structs

'' Initialization
''--------------------------------------------------------------------------------------
var screenWidth = 384
var screenHeight = 512

InitWindow(screenWidth, screenHeight, "rres example - rres load image")

dim as Texture2D texture          '' Texture to load our image data

'' Load central directory from .rres file (if available)
dim as rresCentralDir _dir = rresLoadCentralDirectory("resources.rres")

'' Get resource id from original fileName (stored in centra directory)
var id = rresGetResourceId(_dir, "fudesumi.png")

'' Setup password to load encrypted data (if required)
rresSetCipherPassword("password12345")

'' Load resource chunk from file providing the id
var chunk = rresLoadResourceChunk("resources.rres", id)

'' Decompress/decipher resource data (if required)
var result = UnpackResourceChunk(@chunk)

if (result = RRES_SUCCESS) then        '' Data decompressed/decrypted successfully

    '' Load image data from resource chunk
    var image = LoadImageFromResource(chunk)
    texture = LoadTextureFromImage(image)
    UnloadImage(image)
end if

rresUnloadResourceChunk(chunk)     '' Unload resource chunk
rresUnloadCentralDirectory(_dir)    '' Unload central directory, not required any more

SetTargetFPS(60)                   '' Set our game to run at 60 frames-per-second
''--------------------------------------------------------------------------------------

'' Main game loop
while (not WindowShouldClose())        '' Detect window close button or ESC key

    '' Draw
    ''----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)
        DrawTexture(texture, 0, 0, WHITE)  '' Draw loaded texture

    EndDrawing()
    ''----------------------------------------------------------------------------------
wend

'' De-Initialization
''--------------------------------------------------------------------------------------
UnloadTexture(texture)             '' Unload texture (VRAM)
CloseWindow()                      '' Close window and OpenGL context
''--------------------------------------------------------------------------------------

 