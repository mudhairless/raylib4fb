/'*********************************************************************************************
*
*   rres-raylib v1.2 - rres loaders specific for raylib data structures
*
*   CONFIGURATION:
*
*       Support data compression algorithm LZ4, provided by lz4.h/lz4.c library
*       Support data encryption algorithm AES, provided by aes.h/aes.c library
*       Support data encryption algorithm XChaCha20-Poly1305,
*       provided by monocypher.h/monocypher.c library
*
*   DEPENDENCIES:
*
*     - raylib.bi: Data types definition and data loading from memory functions
*                 WARNING: raylib.bi MUST be included before including rres-raylib.bi
*     - rres.bi:   Base implementation of rres specs, required to read rres files and resource chunks
*
*   VERSION HISTORY:
*
*     - 1.2 (15-Apr-2023): Updated to monocypher 4.0.1
*     - 1.0 (11-May-2022): Initial implementation release
*
*
*   LICENSE: MIT
*
*   Copyright (c) 2020-2023 Ramon Santamaria (@raysan5)
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

#ifndef RRES_RAYLIB_BI
#define RRES_RAYLIB_BI

#inclib "rres-raylib"

#ifndef RRES_BI
    #include once "rres.bi"
#endif

#ifndef RAYLIB_BI
    #include once "raylib.bi"
#endif

extern "C"
''----------------------------------------------------------------------------------
'' Module Functions Declaration
''----------------------------------------------------------------------------------

'' rres data loading to raylib data structures
'' NOTE: Chunk data must be provided uncompressed/unencrypted
declare function LoadDataFromResource(byval chunk as rresResourceChunk, byval size as ulong ptr) as any ptr '' Load raw data from rres resource chunk
declare function LoadTextFromResource(byval chunk as rresResourceChunk) as byte ptr      '' Load text data from rres resource chunk
declare function LoadImageFromResource(byval chunk as rresResourceChunk) as Image     '' Load Image data from rres resource chunk
declare function LoadWaveFromResource(byval chunk as rresResourceChunk) as Wave       '' Load Wave data from rres resource chunk
declare function LoadFontFromResource(byval multi as rresResourceMulti) as Font       '' Load Font data from rres resource multiple chunks
declare function LoadMeshFromResource(byval multi as rresResourceMulti) as Mesh      '' Load Mesh data from rres resource multiple chunks

'' Unpack resource chunk data (decompres/decrypt data)
'' NOTE: Function return 0 on success or other value on failure
declare function UnpackResourceChunk(byval chunk as rresResourceChunk ptr) as long        '' Unpack resource chunk data (decompress/decrypt)
                                                            
'' Set base directory for externally linked data
'' NOTE: When resource chunk contains an external link (FourCC: LINK, Type: RRES_DATA_LINK),
'' a base directory is required to be prepended to link path
'' If not provided, the application path is prepended to link by default 
declare sub SetBaseDirectory(byval baseDir as const zstring ptr)               '' Set base directory for externally linked data

end extern

#endif '' RRES_RAYLIB_BI