/'*********************************************************************************************
*
*   raylib v5.5 - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
*
*   FEATURES:
*       - NO external dependencies, all required libraries included with raylib
*       - Multiplatform: Windows, Linux, FreeBSD, OpenBSD, NetBSD, DragonFly,
*                        MacOS, Haiku, Android, Raspberry Pi, DRM native, HTML5.
*       - Written in plain C code (C99) in PascalCase/camelCase notation
*       - Hardware accelerated with OpenGL (1.1, 2.1, 3.3, 4.3, ES2, ES3 - choose at compile)
*       - Unique OpenGL abstraction layer (usable as standalone module): [rlgl]
*       - Multiple Fonts formats supported (TTF, OTF, FNT, BDF, Sprite fonts)
*       - Outstanding texture formats support, including compressed formats (DXT, ETC, ASTC)
*       - Full 3d support for 3d Shapes, Models, Billboards, Heightmaps and more!
*       - Flexible Materials system, supporting classic maps and PBR maps
*       - Animated 3D models supported (skeletal bones animation) (IQM, M3D, GLTF)
*       - Shaders support, including Model shaders and Postprocessing shaders
*       - Powerful math module for Vector, Matrix and Quaternion operations: [raymath]
*       - Audio loading and playing with streaming support (WAV, OGG, MP3, FLAC, QOA, XM, MOD)
*       - VR stereo rendering with configurable HMD device parameters
*       - Bindings to multiple programming languages available!
*
*   NOTES:
*       - One default Font is loaded on InitWindow()->LoadFontDefault() [core, text]
*       - One default Texture2D is loaded on rlglInit(), 1x1 white pixel R8G8B8A8 [rlgl] (OpenGL 3.3 or ES2)
*       - One default Shader is loaded on rlglInit()->rlLoadShaderDefault() [rlgl] (OpenGL 3.3 or ES2)
*       - One default RenderBatch is loaded on rlglInit()->rlLoadRenderBatch() [rlgl] (OpenGL 3.3 or ES2)
*
*   DEPENDENCIES (included):
*       [rcore][GLFW] rglfw (Camilla Löwy - github.com/glfw/glfw) for window/context management and input
*       [rcore][RGFW] rgfw (ColleagueRiley - github.com/ColleagueRiley/RGFW) for window/context management and input
*       [rlgl] glad/glad_gles2 (David Herberth - github.com/Dav1dde/glad) for OpenGL 3.3 extensions loading
*       [raudio] miniaudio (David Reid - github.com/mackron/miniaudio) for audio device/context management
*
*   OPTIONAL DEPENDENCIES (included):
*       [rcore] msf_gif (Miles Fogle) for GIF recording
*       [rcore] sinfl (Micha Mettke) for DEFLATE decompression algorithm
*       [rcore] sdefl (Micha Mettke) for DEFLATE compression algorithm
*       [rcore] rprand (Ramon Snatamaria) for pseudo-random numbers generation
*       [rtextures] qoi (Dominic Szablewski - https://phoboslab.org) for QOI image manage
*       [rtextures] stb_image (Sean Barret) for images loading (BMP, TGA, PNG, JPEG, HDR...)
*       [rtextures] stb_image_write (Sean Barret) for image writing (BMP, TGA, PNG, JPG)
*       [rtextures] stb_image_resize2 (Sean Barret) for image resizing algorithms
*       [rtextures] stb_perlin (Sean Barret) for Perlin Noise image generation
*       [rtext] stb_truetype (Sean Barret) for ttf fonts loading
*       [rtext] stb_rect_pack (Sean Barret) for rectangles packing
*       [rmodels] par_shapes (Philip Rideout) for parametric 3d shapes generation
*       [rmodels] tinyobj_loader_c (Syoyo Fujita) for models loading (OBJ, MTL)
*       [rmodels] cgltf (Johannes Kuhlmann) for models loading (glTF)
*       [rmodels] m3d (bzt) for models loading (M3D, https://bztsrc.gitlab.io/model3d)
*       [rmodels] vox_loader (Johann Nadalutti) for models loading (VOX)
*       [raudio] dr_wav (David Reid) for WAV audio file loading
*       [raudio] dr_flac (David Reid) for FLAC audio file loading
*       [raudio] dr_mp3 (David Reid) for MP3 audio file loading
*       [raudio] stb_vorbis (Sean Barret) for OGG audio loading
*       [raudio] jar_xm (Joshua Reisenauer) for XM audio module loading
*       [raudio] jar_mod (Joshua Reisenauer) for MOD audio module loading
*       [raudio] qoa (Dominic Szablewski - https://phoboslab.org) for QOA audio manage
*
*
*   LICENSE: zlib/libpng
*
*   raylib is licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software:
*
*   Copyright (c) 2013-2024 Ramon Santamaria (@raysan5)
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented; you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*
*********************************************************************************************'/
' FreeBASIC binding translated by Ebben Feagan (sir_mud) 2025

#pragma once

#ifndef RAYLIB_BI
#define RAYLIB_BI

#inclib "raylib"

#include once "crt/stdarg.bi"

#if defined(__FB_CYGWIN__) or defined(__FB_LINUX__) or defined(__FB_FREEBSD__) or defined(__FB_OPENBSD__) or defined(__FB_NETBSD__)
	#inclib "GL"
	#inclib "X11"
#endif

#ifdef __FB_LINUX__
	#inclib "dl"
	#inclib "rt"
#elseif defined(__FB_CYGWIN__) or defined(__FB_FREEBSD__) or defined(__FB_OPENBSD__) or defined(__FB_NETBSD__)
	#inclib "Xrandr"
	#inclib "Xinerama"
	#inclib "Xi"
	#inclib "Xxf86vm"
	#inclib "Xcursor"
#elseif defined(__FB_DARWIN__)
	#inclib "OpenGL"
	#inclib "Cocoa"
#elseif defined(__FB_WIN32__)
	#inclib "opengl32"
	#inclib "gdi32"
	#inclib "winmm"
	#inclib "shell32"
#endif

extern "C"

#define RAYLIB_VERSION_MAJOR 5
#define RAYLIB_VERSION_MINOR 5
#define RAYLIB_VERSION_PATCH 0
#define RAYLIB_VERSION  "5.5"

'----------------------------------------------------------------------------------
' Some basic Defines
'----------------------------------------------------------------------------------
#ifndef PI
#define PI 3.14159265358979323846
#endif

#ifndef DEG2RAD
#define DEG2RAD (PI / 180.0f)
#endif

#ifndef RAD2DEG
#define RAD2DEG (180.0f / PI)
#endif

#define RL_COLOR_TYPE
#define RL_RECTANGLE_TYPE
#define RL_VECTOR2_TYPE
#define RL_VECTOR3_TYPE
#define RL_VECTOR4_TYPE
#define RL_QUATERNION_TYPE
#define RL_MATRIX_TYPE

#define LIGHTGRAY    type<RayColor>( 200, 200, 200, 255 )
#define GRAY         type<RayColor>( 130, 130, 130, 255 )
#define DARKGRAY     type<RayColor>( 80, 80, 80, 255 )
#define YELLOW       type<RayColor>( 253, 249, 0, 255 )
#define GOLD         type<RayColor>( 255, 203, 0, 255 )
#define ORANGE       type<RayColor>( 255, 161, 0, 255 )
#define PINK         type<RayColor>( 255, 109, 194, 255 )
#define RED          type<RayColor>( 230, 41, 55, 255 )
#define MAROON       type<RayColor>( 190, 33, 55, 255 )
#define GREEN        type<RayColor>( 0, 228, 48, 255 )
#define LIME         type<RayColor>( 0, 158, 47, 255 )
#define DARKGREEN    type<RayColor>( 0, 117, 44, 255 )
#define SKYBLUE      type<RayColor>( 102, 191, 255, 255 )
#define BLUE         type<RayColor>( 0, 121, 241, 255 )
#define DARKBLUE     type<RayColor>( 0, 82, 172, 255 )
#define PURPLE       type<RayColor>( 200, 122, 255, 255 )
#define VIOLET       type<RayColor>( 135, 60, 190, 255 )
#define DARKPURPLE   type<RayColor>( 112, 31, 126, 255 )
#define BEIGE        type<RayColor>( 211, 176, 131, 255 )
#define BROWN        type<RayColor>( 127, 106, 79, 255 )
#define DARKBROWN    type<RayColor>( 76, 63, 47, 255 )
#define WHITE        type<RayColor>( 255, 255, 255, 255 )
#define BLACK        type<RayColor>( 0, 0, 0, 255 )
#define BLANK        type<RayColor>( 0, 0, 0, 0 )
#define MAGENTA      type<RayColor>( 255, 0, 255, 255 )
#define RAYWHITE     type<RayColor>( 245, 245, 245, 255 )

type Vector2
    x as single
    y as single
end type

type Vector3
    x as single
    y as single
    z as single
end type

type Vector4
	x as single
	y as single
	z as single
	w as single
end type

type Quaternion
	x as single
	y as single
	z as single
	w as single
end type

type Matrix
    m0 as single
    m4 as single
    m8 as single
    m12 as single
    m1 as single
    m5 as single
    m9 as single
    m13 as single
    m2 as single
    m6 as single
    m10 as single
    m14 as single
    m3 as single
    m7 as single
    m11 as single
    m15 as single
end type

type RayColor
	r as ubyte
	g as ubyte
	b as ubyte
	a as ubyte
end type

type Rectangle
	x as single
	y as single
	width_ as single
	height as single
end type

type Image
	data_ as any ptr
	width_ as long
	height as long
	mipmaps as long
	format_ as long
end type

type Texture2D
	id as ulong
	width_ as long
	height as long
	mipmaps as long
	format_ as long
end type

type TextureCubemap as Texture2D

type RenderTexture
	id as ulong
	texture as Texture2D
	depth as Texture2D
end type

type RenderTexture2D as RenderTexture

type NPatchInfo
	sourceRec as Rectangle
	left_ as long
	top as long
	right_ as long
	bottom as long
	as long type_
end type

type GlyphInfo
	value as long
	offsetX as long
	offsetY as long
	advanceX as long
	image as Image
end type

type Font
	baseSize as long
	glyphCount as long
    glyphPadding as long
	texture as Texture2D
	recs as Rectangle ptr
	glyphs as GlyphInfo ptr
end type

type Camera3D
	position as Vector3
	target as Vector3
	up as Vector3
	fovy as single
	as long projection
end type

type Camera2D
	offset as Vector2
	target as Vector2
	rotation as single
	zoom as single
end type

type Mesh
	vertexCount as long
	triangleCount as long
	vertices as single ptr
	texcoords as single ptr
	texcoords2 as single ptr
	normals as single ptr
	tangents as single ptr
	colors as ubyte ptr
	indices as ushort ptr
	animVertices as single ptr
	animNormals as single ptr
	boneIds as ubyte ptr
	boneWeights as single ptr
    boneMatrices as Matrix ptr
    boneCount as long
	vaoId as ulong
	vboId as ulong ptr
end type

type Shader
	id as ulong
	locs as long ptr
end type

type MaterialMap
	texture as Texture2D
	_color as RayColor
	value as single
end type

type Material
	shader as Shader
	maps as MaterialMap ptr
	params(0 to 3) as single
end type

type Transform
	translation as Vector3
	rotation as Quaternion
	scale as Vector3
end type

type BoneInfo
	name_ as zstring * 32
	parent as long
end type

type Model
	transform as Matrix
	meshCount as long
    materialCount as long
	meshes as Mesh ptr
	materials as Material ptr
	meshMaterial as long ptr
	boneCount as long
	bones as BoneInfo ptr
	bindPose as Transform ptr
end type

type ModelAnimation
	boneCount as long
    frameCount as long
	bones as BoneInfo ptr
	
	framePoses as Transform ptr ptr
    name_ as zstring * 32
end type

type Ray
	position as Vector3
	direction as Vector3
end type

type RayCollision
	hit as boolean
	distance as single
	position as Vector3
	normal as Vector3
end type

type BoundingBox
	min as Vector3
	max as Vector3
end type

type Wave
	frameCount as ulong
	sampleRate as ulong
	sampleSize as ulong
	channels as ulong
	data_ as any ptr
end type

type rAudioBuffer as rAudioBuffer_
type rAudioProcessor as rAudioProcessor_

type AudioStream
    buffer as rAudioBuffer ptr
    processor as rAudioProcessor ptr
	sampleRate as ulong
	sampleSize as ulong
	channels as ulong
end type

type Sound
    stream as AudioStream
	frameCount as ulong
end type

type Music
    stream as AudioStream
	frameCount as ulong
	looping as boolean
    ctxType as long
    ctxData as any ptr
end type

type VrDeviceInfo
	hResolution as long
	vResolution as long
	hScreenSize as single
	vScreenSize as single
	eyeToScreenDistance as single
	lensSeparationDistance as single
	interpupillaryDistance as single
	lensDistortionValues(0 to 3) as single
	chromaAbCorrection(0 to 3) as single
end type

type VrStereoConfig
    projection(0 to 1) as Matrix
    viewOffset(0 to 1) as Matrix
    leftLensCenter(0 to 1) as single
    rightLensCenter(0 to 1) as single
    leftScreenCenter(0 to 1) as single
    rightScreenCenter(0 to 1) as single
    scale(0 to 1) as single
    scaleIn(0 to 1) as single
end type

type FilePathList
    capacity as ulong
    count as ulong
    paths as zstring ptr ptr
end type

type AutomationEvent
    frame as ulong
    type as ulong
    params(0 to 3) as long
end type

type AutomationEventList
    capacity as ulong
    count as ulong
    events as AutomationEvent ptr
end type

enum ConfigFlags
    FLAG_VSYNC_HINT         = &h00000040   ' Set to try enabling V-Sync on GPU
    FLAG_FULLSCREEN_MODE    = &h00000002   ' Set to run program in fullscreen
    FLAG_WINDOW_RESIZABLE   = &h00000004   ' Set to allow resizable window
    FLAG_WINDOW_UNDECORATED = &h00000008   ' Set to disable window decoration (frame and buttons)
    FLAG_WINDOW_HIDDEN      = &h00000080   ' Set to hide window
    FLAG_WINDOW_MINIMIZED   = &h00000200   ' Set to minimize window (iconify)
    FLAG_WINDOW_MAXIMIZED   = &h00000400   ' Set to maximize window (expanded to monitor)
    FLAG_WINDOW_UNFOCUSED   = &h00000800   ' Set to window non focused
    FLAG_WINDOW_TOPMOST     = &h00001000   ' Set to window always on top
    FLAG_WINDOW_ALWAYS_RUN  = &h00000100   ' Set to allow windows running while minimized
    FLAG_WINDOW_TRANSPARENT = &h00000010   ' Set to allow transparent framebuffer
    FLAG_WINDOW_HIGHDPI     = &h00002000   ' Set to support HighDPI
    FLAG_WINDOW_MOUSE_PASSTHROUGH = &h00004000 ' Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
    FLAG_BORDERLESS_WINDOWED_MODE = &h00008000 ' Set to run program in borderless windowed mode
    FLAG_MSAA_4X_HINT       = &h00000020   ' Set to try enabling MSAA 4X
    FLAG_INTERLACED_HINT    = &h00010000    ' Set to try enabling interlaced video format_ (for V3D)
end enum

enum TraceLogLevel
	LOG_ALL = 0
	LOG_TRACE
	LOG_DEBUG
	LOG_INFO
	LOG_WARNING
	LOG_ERROR
	LOG_FATAL
	LOG_NONE
end enum

enum KeyboardKey
    KEY_NULL = 0
	KEY_APOSTROPHE = 39
	KEY_COMMA = 44
	KEY_MINUS = 45
	KEY_PERIOD = 46
	KEY_SLASH = 47
	KEY_ZERO = 48
	KEY_ONE = 49
	KEY_TWO = 50
	KEY_THREE = 51
	KEY_FOUR = 52
	KEY_FIVE = 53
	KEY_SIX = 54
	KEY_SEVEN = 55
	KEY_EIGHT = 56
	KEY_NINE = 57
	KEY_SEMICOLON = 59
	KEY_EQUAL = 61
	KEY_A = 65
	KEY_B = 66
	KEY_C = 67
	KEY_D = 68
	KEY_E = 69
	KEY_F = 70
	KEY_G = 71
	KEY_H = 72
	KEY_I = 73
	KEY_J = 74
	KEY_K = 75
	KEY_L = 76
	KEY_M = 77
	KEY_N = 78
	KEY_O = 79
	KEY_P = 80
	KEY_Q = 81
	KEY_R = 82
	KEY_S = 83
	KEY_T = 84
	KEY_U = 85
	KEY_V = 86
	KEY_W = 87
	KEY_X = 88
	KEY_Y = 89
	KEY_Z = 90
	KEY_SPACE = 32
	KEY_ESCAPE = 256
	KEY_ENTER = 257
	KEY_TAB = 258
	KEY_BACKSPACE = 259
	KEY_INSERT = 260
	KEY_DELETE = 261
	KEY_RIGHT = 262
	KEY_LEFT = 263
	KEY_DOWN = 264
	KEY_UP = 265
	KEY_PAGE_UP = 266
	KEY_PAGE_DOWN = 267
	KEY_HOME = 268
	KEY_END = 269
	KEY_CAPS_LOCK = 280
	KEY_SCROLL_LOCK = 281
	KEY_NUM_LOCK = 282
	KEY_PRINT_SCREEN = 283
	KEY_PAUSE = 284
	KEY_F1 = 290
	KEY_F2 = 291
	KEY_F3 = 292
	KEY_F4 = 293
	KEY_F5 = 294
	KEY_F6 = 295
	KEY_F7 = 296
	KEY_F8 = 297
	KEY_F9 = 298
	KEY_F10 = 299
	KEY_F11 = 300
	KEY_F12 = 301
	KEY_LEFT_SHIFT = 340
	KEY_LEFT_CONTROL = 341
	KEY_LEFT_ALT = 342
	KEY_LEFT_SUPER = 343
	KEY_RIGHT_SHIFT = 344
	KEY_RIGHT_CONTROL = 345
	KEY_RIGHT_ALT = 346
	KEY_RIGHT_SUPER = 347
	KEY_KB_MENU = 348
	KEY_LEFT_BRACKET = 91
	KEY_BACKSLASH = 92
	KEY_RIGHT_BRACKET = 93
	KEY_GRAVE = 96
	KEY_KP_0 = 320
	KEY_KP_1 = 321
	KEY_KP_2 = 322
	KEY_KP_3 = 323
	KEY_KP_4 = 324
	KEY_KP_5 = 325
	KEY_KP_6 = 326
	KEY_KP_7 = 327
	KEY_KP_8 = 328
	KEY_KP_9 = 329
	KEY_KP_DECIMAL = 330
	KEY_KP_DIVIDE = 331
	KEY_KP_MULTIPLY = 332
	KEY_KP_SUBTRACT = 333
	KEY_KP_ADD = 334
	KEY_KP_ENTER = 335
	KEY_KP_EQUAL = 336

    ' Android
    KEY_BACK = 4
    KEY_MENU = 5
    KEY_VOLUME_UP = 24
    KEY_VOLUME_DOWN = 25
end enum

'Add backwards compatibility support for deprecated names
#define MOUSE_LEFT_BUTTON   MOUSE_BUTTON_LEFT
#define MOUSE_RIGHT_BUTTON  MOUSE_BUTTON_RIGHT
#define MOUSE_MIDDLE_BUTTON MOUSE_BUTTON_MIDDLE

enum MouseButton
	MOUSE_BUTTON_LEFT    = 0       ' Mouse button left_
    MOUSE_BUTTON_RIGHT   = 1       ' Mouse button right_
    MOUSE_BUTTON_MIDDLE  = 2       ' Mouse button middle (pressed wheel)
    MOUSE_BUTTON_SIDE    = 3       ' Mouse button side (advanced mouse device)
    MOUSE_BUTTON_EXTRA   = 4       ' Mouse button extra (advanced mouse device)
    MOUSE_BUTTON_FORWARD = 5       ' Mouse button forward (advanced mouse device)
    MOUSE_BUTTON_BACK    = 6       ' Mouse button back (advanced mouse device)
end enum

enum MouseCursor
    MOUSE_CURSOR_DEFAULT       = 0     ' Default pointer shape
    MOUSE_CURSOR_ARROW         = 1     ' Arrow shape
    MOUSE_CURSOR_IBEAM         = 2     ' Text writing cursor shape
    MOUSE_CURSOR_CROSSHAIR     = 3     ' Cross shape
    MOUSE_CURSOR_POINTING_HAND = 4     ' Pointing hand cursor
    MOUSE_CURSOR_RESIZE_EW     = 5     ' Horizontal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NS     = 6     ' Vertical resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NWSE   = 7     ' Top-left_ to bottom-right_ diagonal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NESW   = 8     ' The top-right_ to bottom-left_ diagonal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_ALL    = 9     ' The omnidirectional resize/move cursor shape
    MOUSE_CURSOR_NOT_ALLOWED   = 0     ' The operation-not-allowed shape
end enum

enum GamepadButton
	GAMEPAD_BUTTON_UNKNOWN = 0
	GAMEPAD_BUTTON_LEFT_FACE_UP
	GAMEPAD_BUTTON_LEFT_FACE_RIGHT
	GAMEPAD_BUTTON_LEFT_FACE_DOWN
	GAMEPAD_BUTTON_LEFT_FACE_LEFT
	GAMEPAD_BUTTON_RIGHT_FACE_UP
	GAMEPAD_BUTTON_RIGHT_FACE_RIGHT
	GAMEPAD_BUTTON_RIGHT_FACE_DOWN
	GAMEPAD_BUTTON_RIGHT_FACE_LEFT
	GAMEPAD_BUTTON_LEFT_TRIGGER_1
	GAMEPAD_BUTTON_LEFT_TRIGGER_2
	GAMEPAD_BUTTON_RIGHT_TRIGGER_1
	GAMEPAD_BUTTON_RIGHT_TRIGGER_2
	GAMEPAD_BUTTON_MIDDLE_LEFT
	GAMEPAD_BUTTON_MIDDLE
	GAMEPAD_BUTTON_MIDDLE_RIGHT
	GAMEPAD_BUTTON_LEFT_THUMB
	GAMEPAD_BUTTON_RIGHT_THUMB
end enum

enum GamepadAxis
	GAMEPAD_AXIS_LEFT_X = 0
	GAMEPAD_AXIS_LEFT_Y = 1
	GAMEPAD_AXIS_RIGHT_X = 2
	GAMEPAD_AXIS_RIGHT_Y = 3
	GAMEPAD_AXIS_LEFT_TRIGGER = 4
	GAMEPAD_AXIS_RIGHT_TRIGGER = 5
end enum

enum MaterialMapIndex
    MATERIAL_MAP_ALBEDO = 0        ' Albedo material (same as: MATERIAL_MAP_DIFFUSE)
    MATERIAL_MAP_METALNESS         ' Metalness material (same as: MATERIAL_MAP_SPECULAR)
    MATERIAL_MAP_NORMAL            ' Normal material
    MATERIAL_MAP_ROUGHNESS         ' Roughness material
    MATERIAL_MAP_OCCLUSION         ' Ambient occlusion material
    MATERIAL_MAP_EMISSION          ' Emission material
    MATERIAL_MAP_HEIGHT            ' Heightmap material
    MATERIAL_MAP_CUBEMAP           ' Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    MATERIAL_MAP_IRRADIANCE        ' Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    MATERIAL_MAP_PREFILTER         ' Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    MATERIAL_MAP_BRDF               ' Brdf material
end enum

#define MATERIAL_MAP_DIFFUSE      MATERIAL_MAP_ALBEDO
#define MATERIAL_MAP_SPECULAR     MATERIAL_MAP_METALNESS

enum ShaderLocationIndex
	SHADER_LOC_VERTEX_POSITION = 0 ' Shader location: vertex attribute: position
    SHADER_LOC_VERTEX_TEXCOORD01   ' Shader location: vertex attribute: texcoord01
    SHADER_LOC_VERTEX_TEXCOORD02   ' Shader location: vertex attribute: texcoord02
    SHADER_LOC_VERTEX_NORMAL       ' Shader location: vertex attribute: normal
    SHADER_LOC_VERTEX_TANGENT      ' Shader location: vertex attribute: tangent
    SHADER_LOC_VERTEX_COLOR        ' Shader location: vertex attribute: color_
    SHADER_LOC_MATRIX_MVP          ' Shader location: matrix uniform: model-view-projection
    SHADER_LOC_MATRIX_VIEW         ' Shader location: matrix uniform: view (camera transform)
    SHADER_LOC_MATRIX_PROJECTION   ' Shader location: matrix uniform: projection
    SHADER_LOC_MATRIX_MODEL        ' Shader location: matrix uniform: model (transform)
    SHADER_LOC_MATRIX_NORMAL       ' Shader location: matrix uniform: normal
    SHADER_LOC_VECTOR_VIEW         ' Shader location: vector uniform: view
    SHADER_LOC_COLOR_DIFFUSE       ' Shader location: vector uniform: diffuse color_
    SHADER_LOC_COLOR_SPECULAR      ' Shader location: vector uniform: specular color_
    SHADER_LOC_COLOR_AMBIENT       ' Shader location: vector uniform: ambient color_
    SHADER_LOC_MAP_ALBEDO          ' Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
    SHADER_LOC_MAP_METALNESS       ' Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
    SHADER_LOC_MAP_NORMAL          ' Shader location: sampler2d texture: normal
    SHADER_LOC_MAP_ROUGHNESS       ' Shader location: sampler2d texture: roughness
    SHADER_LOC_MAP_OCCLUSION       ' Shader location: sampler2d texture: occlusion
    SHADER_LOC_MAP_EMISSION        ' Shader location: sampler2d texture: emission
    SHADER_LOC_MAP_HEIGHT          ' Shader location: sampler2d texture: height
    SHADER_LOC_MAP_CUBEMAP         ' Shader location: samplerCube texture: cubemap
    SHADER_LOC_MAP_IRRADIANCE      ' Shader location: samplerCube texture: irradiance
    SHADER_LOC_MAP_PREFILTER       ' Shader location: samplerCube texture: prefilter
    SHADER_LOC_MAP_BRDF            ' Shader location: sampler2d texture: brdf
    SHADER_LOC_VERTEX_BONEIDS      ' Shader location: vertex attribute: boneIds
    SHADER_LOC_VERTEX_BONEWEIGHTS  ' Shader location: vertex attribute: boneWeights
    SHADER_LOC_BONE_MATRICES        ' Shader location: array of matrices uniform: boneMatrices
end enum

#define SHADER_LOC_MAP_DIFFUSE      SHADER_LOC_MAP_ALBEDO
#define SHADER_LOC_MAP_SPECULAR     SHADER_LOC_MAP_METALNESS

enum ShaderUniformDataType
	SHADER_UNIFORM_FLOAT = 0       ' Shader uniform type: float
    SHADER_UNIFORM_VEC2            ' Shader uniform type: vec2 (2 float)
    SHADER_UNIFORM_VEC3            ' Shader uniform type: vec3 (3 float)
    SHADER_UNIFORM_VEC4            ' Shader uniform type: vec4 (4 float)
    SHADER_UNIFORM_INT             ' Shader uniform type: int
    SHADER_UNIFORM_IVEC2           ' Shader uniform type: ivec2 (2 int)
    SHADER_UNIFORM_IVEC3           ' Shader uniform type: ivec3 (3 int)
    SHADER_UNIFORM_IVEC4           ' Shader uniform type: ivec4 (4 int)
    SHADER_UNIFORM_SAMPLER2D        ' Shader uniform type: sampler2d
end enum

enum ShaderAttributeDataType
    SHADER_ATTRIB_FLOAT = 0        ' Shader attribute type: float
    SHADER_ATTRIB_VEC2             ' Shader attribute type: vec2 (2 float)
    SHADER_ATTRIB_VEC3             ' Shader attribute type: vec3 (3 float)
    SHADER_ATTRIB_VEC4              ' Shader attribute type: vec4 (4 float)
end enum

enum PixelFormat
	PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1 ' 8 bit per pixel (no alpha)
    PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA    ' 8*2 bpp (2 channels)
    PIXELFORMAT_UNCOMPRESSED_R5G6B5        ' 16 bpp
    PIXELFORMAT_UNCOMPRESSED_R8G8B8        ' 24 bpp
    PIXELFORMAT_UNCOMPRESSED_R5G5B5A1      ' 16 bpp (1 bit alpha)
    PIXELFORMAT_UNCOMPRESSED_R4G4B4A4      ' 16 bpp (4 bit alpha)
    PIXELFORMAT_UNCOMPRESSED_R8G8B8A8      ' 32 bpp
    PIXELFORMAT_UNCOMPRESSED_R32           ' 32 bpp (1 channel - float)
    PIXELFORMAT_UNCOMPRESSED_R32G32B32     ' 32*3 bpp (3 channels - float)
    PIXELFORMAT_UNCOMPRESSED_R32G32B32A32  ' 32*4 bpp (4 channels - float)
    PIXELFORMAT_UNCOMPRESSED_R16           ' 16 bpp (1 channel - half float)
    PIXELFORMAT_UNCOMPRESSED_R16G16B16     ' 16*3 bpp (3 channels - half float)
    PIXELFORMAT_UNCOMPRESSED_R16G16B16A16  ' 16*4 bpp (4 channels - half float)
    PIXELFORMAT_COMPRESSED_DXT1_RGB        ' 4 bpp (no alpha)
    PIXELFORMAT_COMPRESSED_DXT1_RGBA       ' 4 bpp (1 bit alpha)
    PIXELFORMAT_COMPRESSED_DXT3_RGBA       ' 8 bpp
    PIXELFORMAT_COMPRESSED_DXT5_RGBA       ' 8 bpp
    PIXELFORMAT_COMPRESSED_ETC1_RGB        ' 4 bpp
    PIXELFORMAT_COMPRESSED_ETC2_RGB        ' 4 bpp
    PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA   ' 8 bpp
    PIXELFORMAT_COMPRESSED_PVRT_RGB        ' 4 bpp
    PIXELFORMAT_COMPRESSED_PVRT_RGBA       ' 4 bpp
    PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA   ' 8 bpp
    PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA    ' 2 bpp
end enum

enum TextureFilter
	TEXTURE_FILTER_POINT = 0               ' No filter, just pixel approximation
    TEXTURE_FILTER_BILINEAR                ' Linear filtering
    TEXTURE_FILTER_TRILINEAR               ' Trilinear filtering (linear with mipmaps)
    TEXTURE_FILTER_ANISOTROPIC_4X          ' Anisotropic filtering 4x
    TEXTURE_FILTER_ANISOTROPIC_8X          ' Anisotropic filtering 8x
    TEXTURE_FILTER_ANISOTROPIC_16X         ' Anisotropic filtering 16x
end enum

enum TextureWrap
    TEXTURE_WRAP_REPEAT = 0                ' Repeats texture in tiled mode
    TEXTURE_WRAP_CLAMP                     ' Clamps texture to edge pixel in tiled mode
    TEXTURE_WRAP_MIRROR_REPEAT             ' Mirrors and repeats the texture in tiled mode
    TEXTURE_WRAP_MIRROR_CLAMP               ' Mirrors and clamps to border the texture in tiled mode
end enum

enum CubemapLayout
	CUBEMAP_LAYOUT_AUTO_DETECT = 0         ' Automatically detect layout type
    CUBEMAP_LAYOUT_LINE_VERTICAL           ' Layout is defined by a vertical line with faces
    CUBEMAP_LAYOUT_LINE_HORIZONTAL         ' Layout is defined by a horizontal line with faces
    CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR     ' Layout is defined by a 3x4 cross with cubemap faces
    CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE     ' Layout is defined by a 4x3 cross with cubemap faces
end enum

enum FontType
	FONT_DEFAULT = 0
	FONT_BITMAP
	FONT_SDF
end enum

enum BlendMode
	BLEND_ALPHA = 0                ' Blend textures considering alpha (default)
    BLEND_ADDITIVE                 ' Blend textures adding colors
    BLEND_MULTIPLIED               ' Blend textures multiplying colors
    BLEND_ADD_COLORS               ' Blend textures adding colors (alternative)
    BLEND_SUBTRACT_COLORS          ' Blend textures subtracting colors (alternative)
    BLEND_ALPHA_PREMULTIPLY        ' Blend premultiplied textures considering alpha
    BLEND_CUSTOM                   ' Blend textures using custom src/dst factors (use rlSetBlendFactors())
    BLEND_CUSTOM_SEPARATE           ' Blend textures using custom rgb/alpha separate src/dst factors (use rlSetBlendFactorsSeparate())
end enum

enum Gesture
	GESTURE_NONE = 0
	GESTURE_TAP = 1
	GESTURE_DOUBLETAP = 2
	GESTURE_HOLD = 4
	GESTURE_DRAG = 8
	GESTURE_SWIPE_RIGHT = 16
	GESTURE_SWIPE_LEFT = 32
	GESTURE_SWIPE_UP = 64
	GESTURE_SWIPE_DOWN = 128
	GESTURE_PINCH_IN = 256
	GESTURE_PINCH_OUT = 512
end enum

enum CameraMode
	CAMERA_CUSTOM = 0
	CAMERA_FREE
	CAMERA_ORBITAL
	CAMERA_FIRST_PERSON
	CAMERA_THIRD_PERSON
end enum

enum CameraProjection
	CAMERA_PERSPECTIVE = 0
	CAMERA_ORTHOGRAPHIC
end enum

enum NPatchLayout
	NPATCH_NINE_PATCH = 0          ' Npatch layout: 3x3 tiles
    NPATCH_THREE_PATCH_VERTICAL    ' Npatch layout: 1x3 tiles
    NPATCH_THREE_PATCH_HORIZONTAL   ' Npatch layout: 3x1 tiles
end enum

' Callbacks to hook some internal functions
'WARNING: These callbacks are intended for advanced users
type TraceLogCallback as sub(byval logType as long, byval text as const zstring ptr, byval args as va_list)
type LoadFileDataCallback as function(byval fileName as const zstring ptr, byval dataSize as long ptr) as ubyte ptr
type SaveFileDataCallback as function(byval fileName as const zstring ptr, byval data_ as any ptr, byval dataSize as long) as boolean
type LoadFileTextCallback as function(byval fileName as const zstring ptr) as zstring ptr
type SaveFileTextCallback as function(byval fileName as const zstring ptr, byval text as zstring ptr) as boolean

' Window-related functions
declare sub InitWindow(byval width_ as long, byval height as long, byval title as const zstring ptr)
declare sub CloseWindow()
declare function WindowShouldClose() as boolean
declare function IsWindowReady() as boolean
declare function IsWindowFullscreen() as boolean
declare function IsWindowHidden() as boolean
declare function IsWindowMinimized() as boolean
declare function IsWindowMaximized() as boolean
declare function IsWindowFocused() as boolean
declare function IsWindowResized() as boolean
declare function IsWindowState(byval flag as ulong) as boolean
declare sub SetWindowState(byval flag as ulong)
declare sub ClearWindowState(byval flag as ulong)
declare sub ToggleFullscreen()
declare sub ToggleBorderlessWindowed()
declare sub MaximizeWindow()
declare sub MinimizeWindow()
declare sub RestoreWindow()
declare sub SetWindowIcon(byval image as Image)
declare sub SetWindowIcons(byval images as Image ptr, byval count as long)
declare sub SetWindowTitle(byval title as const zstring ptr)
declare sub SetWindowPosition(byval x as long, byval y as long)
declare sub SetWindowMonitor(byval monitor as long)
declare sub SetWindowMinSize(byval width_ as long, byval height as long)
declare sub SetWindowMaxSize(byval width_ as long, byval height as long)
declare sub SetWindowSize(byval width_ as long, byval height as long)
declare sub SetWindowOpacity(byval opacity as single)
declare sub SetWindowFocused()
declare function GetWindowHandle() as any ptr
declare function GetScreenWidth() as long
declare function GetScreenHeight() as long
declare function GetRenderWidth() as long
declare function GetRenderHeight() as long
declare function GetMonitorCount() as long
declare function GetCurrentMonitor() as long
declare function GetMonitorPosition(byval monitor as long) as Vector2
declare function GetMonitorWidth(byval monitor as long) as long
declare function GetMonitorHeight(byval monitor as long) as long
declare function GetMonitorPhysicalWidth(byval monitor as long) as long
declare function GetMonitorPhysicalHeight(byval monitor as long) as long
declare function GetMonitorRefreshRate(byval monitor as long) as long
declare function GetWindowPosition() as Vector2
declare function GetWindowScaleDPI() as Vector2
declare function GetMonitorName(byval monitor as long) as const zstring ptr
declare sub SetClipboardText(byval text as const zstring ptr)
declare function GetClipboardText() as const zstring ptr
declare function GetClipboardImage() as Image
declare sub EnableEventWaiting()
declare sub DisableEventWaiting()

' Cursor-related functions
declare sub ShowCursor()
declare sub HideCursor()
declare function IsCursorHidden() as boolean
declare sub EnableCursor()
declare sub DisableCursor()
declare function IsCursorOnScreen() as boolean

' Drawing-related functions
declare sub ClearBackground(byval color_ as RayColor)
declare sub BeginDrawing()
declare sub EndDrawing()
declare sub BeginMode2D(byval camera as Camera2D)
declare sub EndMode2D()
declare sub BeginMode3D(byval camera as Camera3D)
declare sub EndMode3D()
declare sub BeginTextureMode(byval target as RenderTexture2D)
declare sub EndTextureMode()
declare sub BeginShaderMode(byval shader as Shader)
declare sub EndShaderMode()
declare sub BeginBlendMode()
declare sub EndBlendMode()
declare sub BeginScissorMode(byval x as long, byval y as long, byval width_ as long, byval height as long)
declare sub EndScissorMode()
declare sub BeginVrStereoMode(byval config as VrStereoConfig)
declare sub EndVrSterioMode()

' VR stereo config functions for VR simulator
declare function LoadVrStereoConfig(byval device as VrDeviceInfo) as VrStereoConfig
declare sub UnloadVrStereoConfig(byval config as VrStereoConfig)

' Shader management functions
' NOTE: Shader fucntionality is not available on OpenGL 1.1
declare function LoadShader(byval vsFileName as const zstring ptr, byval fsFileName as const zstring ptr) as Shader
declare function LoadShaderFromMemory(byval vsCode as const zstring ptr, byval fsCode as const zstring ptr) as Shader
declare function IsShaderValid(byval _shader as Shader) as boolean
declare function GetShaderLocation(byval _shader as Shader, byval uniformName as const zstring ptr) as long
declare function GetShaderLocationAttrib(byval _shader as Shader, byval attribName as const zstring ptr) as long
declare sub SetShaderValue(byval _shader as Shader, byval locIndex as long, byval value as const any ptr, byval uniformType as long)
declare sub SetShaderValueV(byval _shader as Shader, byval locIndex as long, byval value as const any ptr, byval uniformType as long, byval count as long)
declare sub SetShaderValueMatrix(byval _shader as Shader, byval locIndex as long, byval mat as Matrix)
declare sub SetShaderValueTexture(byval _shader as Shader, byval locIndex as long, byval texture as Texture2D)
declare sub UnloadShader(byval _shader as Shader)

' Screen-space-related functions
#define GetMouseRay GetScreenToWorldRay
declare function GetScreenToWorldRay(byval position as Vector2, byval _camera as Camera3D) as Ray
declare function GetScreenToWorldRayEx(byval position as Vector2, byval _camera as Camera3D, byval width_ as long, byval height as long) as Ray
declare function GetWorldToScreen(byval position as Vector3, byval _camera as Camera3D) as Vector2
declare function GetWorldToScreenEx(byval position as Vector3, byval _camera as Camera3D, byval width_ as long, byval height as long) as Vector2
declare function GetWorldToScreen2D(byval position as Vector2, byval _camera as Camera2D) as Vector2
declare function GetScreenToWorld2D(byval position as Vector2, byval _camera as Camera2D) as Vector2
declare function GetCameraMatrix(byval _camera as Camera3D) as Matrix
declare function GetCameraMatrix2D(byval _camera as Camera2D) as Matrix

' Timing-related functions
declare sub SetTargetFPS(byval fps as long)
declare function GetFrameTime() as single
declare function GetTime() as double
declare function GetFPS() as long

' Custom frame control functions
' NOTE: Those functions are intended for advanced users that want full control over the frame processing
' By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
' To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL
declare sub SwapScreenBuffer()
declare sub PollInputEvents()
declare sub WaitTime(byval seconds as double)

' Random values generation functions
declare sub SetRandomSeed(byval seed as ulong)
declare function GetRandomValue(byval _min as long, byval _max as long) as long
declare function LoadRandomSequence(byval count as ulong, byval _min as long, _max as long) as long ptr
declare sub UnloadRandomSequence(byval sequence as long ptr)

' Misc. functions
declare sub TakeScreenshot(byval fileName as const zstring ptr)
declare sub SetConfigFlags(byval flags as ulong)
declare sub OpenURL(byval url as const zstring ptr)

' utils
declare sub TraceLog(byval logLevel as long, byval text as const zstring ptr, ...)
declare sub SetTraceLogLevel(byval logLevel as long)
declare function MemAlloc(byval size as ulong) as any ptr
declare function MemRealloc(byval _ptr as any ptr, byval size as ulong) as any ptr
declare sub MemFree(byval _ptr as any ptr)

' Set customer callbacks
' WARNING: Callbacks setup is intended for advanced users
declare sub SetTraceLogCallback(byval callback as TraceLogCallback)
declare sub SetLoadFileDataCallback(byval callback as LoadFileDataCallback)
declare sub SetSaveFileDataCallback(byval callback as SaveFileDataCallback)
declare sub SetLoadFileTextCallback(byval callback as LoadFileTextCallback)
declare sub SetSaveFileTextCallback(byval callback as SaveFileTextCallback)

' Files management functions
declare function LoadFileData(byval fileName as const zstring ptr, byval bytesRead as ulong ptr) as ubyte ptr
declare sub UnloadFileData(byval data_ as ubyte ptr)
declare function SaveFileData(byval fileName as const zstring ptr, byval data_ as any ptr, byval dataSize as ulong) as boolean
declare function ExportDataAsCode(byval data_ as const ubyte ptr, byval dataSize as long, byval fileName as const zstring ptr) as boolean
declare function LoadFileText(byval fileName as const zstring ptr) as zstring ptr
declare sub UnloadFileText(byval text as zstring ptr)
declare function SaveFileText(byval fileName as const zstring ptr, byval text as zstring ptr) as boolean

' File system functions
declare function _FileExists alias "FileExists" (byval fileName as const zstring ptr) as boolean
declare function DirectoryExists(byval dirPath as const zstring ptr) as boolean
declare function IsFileExtension(byval fileName as const zstring ptr, byval ext as const zstring ptr) as boolean
declare function GetFileLength(byval filename as const zstring ptr) as long
declare function GetFileExtension(byval fileName as const zstring ptr) as const zstring ptr
declare function GetFileName(byval filePath as const zstring ptr) as const zstring ptr
declare function GetFileNameWithoutExt(byval filePath as const zstring ptr) as const zstring ptr
declare function GetDirectoryPath(byval filePath as const zstring ptr) as const zstring ptr
declare function GetPrevDirectoryPath(byval dirPath as const zstring ptr) as const zstring ptr
declare function GetWorkingDirectory() as const zstring ptr
declare function GetApplicationDirectory() as const zstring ptr
declare function MakeDirectory(byval dirPath as const zstring ptr) as long
declare function ChangeDirectory(byval dir as const zstring ptr) as boolean
declare function IsPathFile(byval path as const zstring ptr) as boolean
declare function IsFileNameValid(byval fileName as const zstring ptr) as boolean
declare function LoadDirectoryFiles(byval dirPath as const zstring ptr) as FilePathList
declare function LoadDirectoryFilesEx(byval basePath as const zstring ptr, byval filter as const zstring ptr, byval scanSubdirs as boolean) as FilePathList
declare function IsFileDropped() as boolean
declare function LoadDroppedFiles() as FilePathList
declare sub UnloadDroppedFiles(byval files as FilePathList)
declare function GetFileModTime(byval fileName as const zstring ptr) as integer

' Compression/Encoding Functionality
declare function CompressData(byval data_ as const ubyte ptr, byval dataSize as long, byval compDataSize as long ptr) as ubyte ptr
declare function DecompressData(byval compData as const ubyte ptr, byval compDataSize as long, byval dataSize as long ptr) as ubyte ptr
declare function EncodeDataBase64(byval data_ as const ubyte ptr, byval dataSize as long, byval outputSize as long ptr) as ubyte ptr
declare function DecodeDataBase64(byval data_ as const ubyte ptr, byval outputSize as long ptr) as ubyte ptr
declare function ComputeCRC32(byval data_ as ubyte ptr, byval dataSize as long) as ulong
declare function ComputeMD5(byval data_ as ubyte ptr, byval dataSize as long) as ulong ptr
declare function ComputeSHA1(byval data_ as ubyte ptr, byval dataSize as long) as ulong ptr

' Automation events functionality
declare function LoadAutomationEventList(byval fileName as const zstring ptr) as AutomationEventList
declare sub UnloadAutomationEventList(byval list as AutomationEventList)
declare function ExportAutomationEventList(byval list as AutomationEventList, byval fileName as const zstring ptr) as boolean
declare sub SetAutomationEventList(byval list as AutomationEventList ptr)
declare sub SetAutomationEventBaseFrame(byval frame as long)
declare sub StartAutomationEventRecording()
declare sub StopAutomationEventRecording()
declare sub PlayAutomationEvent(byval event as AutomationEvent)

' Input-related functions: keyboard
declare function IsKeyPressed(byval key as long) as boolean
declare function IsKeyPressedRepeat(byval key as long) as boolean
declare function IsKeyDown(byval key as long) as boolean
declare function IsKeyReleased(byval key as long) as boolean
declare function IsKeyUp(byval key as long) as boolean
declare function GetKeyPressed() as long
declare function GetCharPressed() as long
declare sub SetExitKey(byval key as long)

' Input-related functions: gamepads
declare function IsGamepadAvailable(byval gamepad as long) as boolean
declare function GetGamepadName(byval gamepad as long) as const zstring ptr
declare function IsGamepadButtonPressed(byval gamepad as long, byval button as long) as boolean
declare function IsGamepadButtonDown(byval gamepad as long, byval button as long) as boolean
declare function IsGamepadButtonReleased(byval gamepad as long, byval button as long) as boolean
declare function IsGamepadButtonUp(byval gamepad as long, byval button as long) as boolean
declare function GetGamepadButtonPressed() as long
declare function GetGamepadAxisCount(byval gamepad as long) as long
declare function GetGamepadAxisMovement(byval gamepad as long, byval axis as long) as single
declare function SetGamepadMappings(byval mappings as const zstring ptr) as long
declare sub SetGamepadVibration(byval gamepad as long, byval leftMotor as single, byval rightMotor as single, byval duration as single)

' Input-related functions: mouse
declare function IsMouseButtonPressed(byval button as long) as boolean
declare function IsMouseButtonDown(byval button as long) as boolean
declare function IsMouseButtonReleased(byval button as long) as boolean
declare function IsMouseButtonUp(byval button as long) as boolean
declare function GetMouseX() as long
declare function GetMouseY() as long
declare function GetMousePosition() as Vector2
declare function GetMouseDelta() as Vector2
declare sub SetMousePosition(byval x as long, byval y as long)
declare sub SetMouseOffset(byval offsetX as long, byval offsetY as long)
declare sub SetMouseScale(byval scaleX as single, byval scaleY as single)
declare function GetMouseWheelMove() as single
declare function GetMouseWheelMoveV() as Vector2
declare sub SetMouseCursor(byval cursor as long)

' Input-related functions touch
declare function GetTouchX() as long
declare function GetTouchY() as long
declare function GetTouchPosition(byval index as long) as Vector2
declare function GetTouchPointId(byval index as long) as long
declare function GetTouchPointCount() as long

' Gestures and Touch Handling functions
declare sub SetGesturesEnabled(byval gestureFlags as ulong)
declare function IsGestureDetected(byval gesture as ulong) as boolean
declare function GetGestureDetected() as long
declare function GetGestureHoldDuration() as single
declare function GetGestureDragVector() as Vector2
declare function GetGestureDragAngle() as single
declare function GetGesturePinchVector() as Vector2
declare function GetGesturePinchAngle() as single

' Camera System Functions
declare sub UpdateCamera( byval _camera as Camera3D ptr, byval mode as long)
declare sub UpdateCameraPro(byval _camera as Camera3D ptr, byval movement as Vector3, byval rotation as Vector3, byval zoom as single)

'------------------------------------------------------------------------------------
' Basic Shapes Drawing Functions (Module: shapes)
'------------------------------------------------------------------------------------
' Set texture and rectangle to be used on shapes drawing
' NOTE: It can be useful when using basic shapes and one single font,
' defining a font char white rectangle would allow drawing everything in a single draw call
declare sub SetShapesTexture(byval texture as Texture2D, byval source as Rectangle)
declare function GetShapesTexture() as Texture2D
declare function GetShapesTextureRectangle() as Rectangle

' Basic shapes drawing functions
declare sub DrawPixel(byval posX as long, byval posY as long, byval _color as RayColor)
declare sub DrawPixelV(byval position as Vector2, byval _color as RayColor)
declare sub DrawLine(byval startPosX as long, byval startPosY as long, byval endPosX as long, byval endPosY as long, byval _color as RayColor)
declare sub DrawLineV(byval startPos as Vector2, byval endPos as Vector2, byval _color as RayColor)
declare sub DrawLineEx(byval startPos as Vector2, byval endPos as Vector2, byval thick as single, byval _color as RayColor)
declare sub DrawLineStrip(byval points as Vector2 ptr, byval numPoints as long, byval _color as RayColor)
declare sub DrawLineBezier(byval startPos as Vector2, byval endPos as Vector2, byval thick as single, byval _color as RayColor)
declare sub DrawCircle(byval centerX as long, byval centerY as long, byval radius as single, byval _color as RayColor)
declare sub DrawCircleSector(byval center as Vector2, byval radius as single, byval startAngle as long, byval endAngle as long, byval segments as long, byval color_ as RayColor)
declare sub DrawCircleSectorLines(byval center as Vector2, byval radius as single, byval startAngle as long, byval endAngle as long, byval segments as long, byval color_ as RayColor)
declare sub DrawCircleGradient(byval centerX as long, byval centerY as long, byval radius as single, byval color1 as RayColor, byval color2 as RayColor)
declare sub DrawCircleV(byval center as Vector2, byval radius as single, byval _color as RayColor)
declare sub DrawCircleLines(byval centerX as long, byval centerY as long, byval radius as single, byval _color as RayColor)
declare sub DrawCircleLinesV(byval center as Vector2, byval radius as single, byval _color as RayColor)
declare sub DrawEllipse(byval centerX as long, byval centerY as long, byval radiusH as single, byval radiusV as single, byval _color as RayColor)
declare sub DrawEllipseLines(byval centerX as long, byval centerY as long, byval radiusH as single, byval radiusV as single, byval _color as RayColor)
declare sub DrawRing(byval center as Vector2, byval innerRadius as single, byval outerRadius as single, byval startAngle as long, byval endAngle as long, byval segments as long, byval color_ as RayColor)
declare sub DrawRingLines(byval center as Vector2, byval innerRadius as single, byval outerRadius as single, byval startAngle as long, byval endAngle as long, byval segments as long, byval color_ as RayColor)
declare sub DrawRectangle(byval posX as long, byval posY as long, byval width_ as long, byval height as long, byval _color as RayColor)
declare sub DrawRectangleV(byval position as Vector2, byval size as Vector2, byval _color as RayColor)
declare sub DrawRectangleRec(byval rec as Rectangle, byval _color as RayColor)
declare sub DrawRectanglePro(byval rec as Rectangle, byval origin as Vector2, byval rotation as single, byval color_ as RayColor)
declare sub DrawRectangleGradientV(byval posX as long, byval posY as long, byval width_ as long, byval height as long, byval color1 as RayColor, byval color2 as RayColor)
declare sub DrawRectangleGradientH(byval posX as long, byval posY as long, byval width_ as long, byval height as long, byval color1 as RayColor, byval color2 as RayColor)
declare sub DrawRectangleGradientEx(byval rec as Rectangle, byval col1 as RayColor, byval col2 as RayColor, byval col3 as RayColor, byval col4 as RayColor)
declare sub DrawRectangleLines(byval posX as long, byval posY as long, byval width_ as long, byval height as long, byval _color as RayColor)
declare sub DrawRectangleLinesEx(byval rec as Rectangle, byval lineThick as long, byval _color as RayColor)
declare sub DrawRectangleRounded(byval rec as Rectangle, byval roundness as single, byval segments as long, byval _color as RayColor)
declare sub DrawRectangleRoundedLines(byval rec as Rectangle, byval roundness as single, byval segments as long, byval _color as RayColor)
declare sub DrawRectangleRoundedLinesEx(byval rec as Rectangle, byval roundness as single, byval segments as long, byval lineThick as long, byval _color as RayColor)
declare sub DrawTriangle(byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval _color as RayColor)
declare sub DrawTriangleLines(byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval _color as RayColor)
declare sub DrawTriangleFan(byval points as Vector2 ptr, byval numPoints as long, byval _color as RayColor)
declare sub DrawTriangleStrip(byval points as Vector2 ptr, byval pointsCount as long, byval _color as RayColor)
declare sub DrawPoly(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval _color as RayColor)
declare sub DrawPolyLines(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval _color as RayColor)
declare sub DrawPolyLinesEx(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval lineThick as single, byval _color as RayColor)

' Splines drawing functions
declare sub DrawSplineLinear( byval points as const Vector2 ptr, byval pointCount as long, byval thick as single, byval _color as RayColor)
declare sub DrawSplineBasis( byval points as const Vector2 ptr, byval pointCount as long, byval thick as single, byval _color as RayColor)
declare sub DrawSplineCatmullRom( byval points as const Vector2 ptr, byval pointCount as long, byval thick as single, byval _color as RayColor)
declare sub DrawSplineBezierQuadratic( byval points as const Vector2 ptr, byval pointCount as long, byval thick as single, byval _color as RayColor)
declare sub DrawSplineBezierCubic( byval points as const Vector2 ptr, byval pointCount as long, byval thick as single, byval _color as RayColor)
declare sub DrawSplineSegmentLinear(byval p1 as Vector2, byval p2 as Vector2, byval thick as single, byval _color as RayColor)
declare sub DrawSplineSegmentBasis(byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2, byval p4 as Vector2, byval thick as single, byval _color as RayColor)
declare sub DrawSplineSegmentCatmullRom(byval p1 as Vector2, byval p2 as Vector2,byval p3 as Vector2, byval p4 as Vector2, byval thick as single, byval _color as RayColor)
declare sub DrawSplineSegmentBezierQuadratic(byval p1 as Vector2, byval c2 as Vector2, byval p3 as Vector2, byval thick as single, byval _color as RayColor)
declare sub DrawSplineSegmentBezierCubic(byval p1 as Vector2, byval c2 as Vector2, byval c3 as Vector2, byval p4 as Vector2, byval thick as single, byval _color as RayColor)

' Spline segment point evaluation functions, for a given t [0.0f .. 1.0f]
declare function GetSplinePointLinear(byval startPos as Vector2, byval endPos as Vector2, byval t as single) as Vector2
declare function GetSplinePointBasis(byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2, byval p4 as Vector2, byval t as single) as Vector2
declare function GetSplinePointCatmullRom(byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2, byval p4 as Vector2, byval t as single) as Vector2
declare function GetSplinePointBezierQuad(byval p1 as Vector2, byval c2 as Vector2, byval p3 as Vector2, byval t as single) as Vector2
declare function GetSplinePointBezierCubic(byval p1 as Vector2, byval c2 as Vector2, byval c3 as Vector2, byval p4 as Vector2, byval t as single) as Vector2

' Basic shapes collision detection functions
declare function CheckCollisionRecs(byval rec1 as Rectangle, byval rec2 as Rectangle) as boolean
declare function CheckCollisionCircles(byval center1 as Vector2, byval radius1 as single, byval center2 as Vector2, byval radius2 as single) as boolean
declare function CheckCollisionCircleRec(byval center as Vector2, byval radius as single, byval rec as Rectangle) as boolean
declare function CheckCollisionCircleLine(byval center as Vector2, byval radius as single, byval p1 as Vector2, byval p2 as Vector2) as boolean
declare function CheckCollisionPointRec(byval _point as Vector2, byval rec as Rectangle) as boolean
declare function CheckCollisionPointCircle(byval _point as Vector2, byval center as Vector2, byval radius as single) as boolean
declare function CheckCollisionPointTriangle(byval _point as Vector2, byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2) as boolean
declare function CheckCollisionPointLine(byval _point as Vector2, byval p1 as Vector2, byval p2 as Vector2, byval threshold as long) as boolean
declare function CheckCollisionPointPoly(byval _point as Vector2, byval points as const Vector2 ptr, byval pointCount as long) as boolean
declare function CheckCollisionPointLines(byval startPos1 as Vector2, byval endPos1 as Vector2, byval startPos2 as Vector2, byval endPos2 as Vector2, byval collisionPoint as Vector2 ptr) as boolean
declare function GetCollisionRec(byval rec1 as Rectangle, byval rec2 as Rectangle) as Rectangle

' Image loading functions
' NOTE: These functions do not require GPU access
declare function LoadImage(byval fileName as const zstring ptr) as Image
declare function LoadImageRaw(byval fileName as const zstring ptr, byval width_ as long, byval height as long, byval format_ as long, byval headerSize as long) as Image
declare function LoadImageAnim(byval fileName as const zstring ptr, byval frames as long ptr) as Image
declare function LoadImageAnimFromMemory(byval filetype as const zstring ptr, byval fileData as const ubyte ptr, byval dataSize as long, byval frames as long ptr) as Image
declare function LoadImageFromMemory(byval filetype as const zstring ptr, byval fileData as const ubyte ptr, byval dataSize as long) as Image
declare function LoadImageFromScreen() as Image
declare function IsImageValid(byval _image as Image) as boolean
declare sub UnloadImage(byval _image as Image)
declare sub ExportImage(byval _image as Image, byval fileName as const zstring ptr)
declare function ExportImageToMemory(byval _image as Image, byval fileType as const zstring ptr, byval fileSize as long ptr) as ubyte ptr
declare sub ExportImageAsCode(byval _image as Image, byval fileName as const zstring ptr)

' Image generation functions
declare function GenImageColor(byval width_ as long, byval height as long, byval color_ as RayColor) as Image
declare function GenImageGradientLinear(byval width_ as long, byval height as long, byval direction as long, byval start as RayColor, byval _end as RayColor) as Image
declare function GenImageGradientRadial(byval width_ as long, byval height as long, byval density as single, byval inner as RayColor, byval outer as RayColor) as Image
declare function GenImageGradientSquare(byval width_ as long, byval height as long, byval density as single, byval inner as RayColor, byval outer as RayColor) as Image
declare function GenImageChecked(byval width_ as long, byval height as long, byval checksX as long, byval checksY as long, byval col1 as RayColor, byval col2 as RayColor) as Image
declare function GenImageWhiteNoise(byval width_ as long, byval height as long, byval factor as single) as Image
declare function GenImagePerlinNoise(byval width_ as long, byval height as long, byval offsetX as long, byval offsetY as long, byval scale as single) as Image
declare function GenImageCellular(byval width_ as long, byval height as long, byval tileSize as long) as Image
declare function GenImageText(byval width_ as long, byval height as long, byval text as const zstring ptr) as Image

' Image manipulation function
declare function ImageCopy(byval _image as Image) as Image
declare function ImageFromImage(byval _image as Image, byval rec as Rectangle) as Image
declare function ImageText(byval text as const zstring ptr, byval fontSize as long, byval color_ as RayColor) as Image
declare function ImageTextEx(byval _font as Font, byval text as const zstring ptr, byval fontSize as single, byval spacing as single, byval tint as RayColor) as Image
declare sub ImageFormat(byval _image as Image ptr, byval newFormat as long)
declare sub ImageToPOT(byval _image as Image ptr, byval fillColor as RayColor)
declare sub ImageCrop(byval _image as Image ptr, byval crop as Rectangle)
declare sub ImageAlphaCrop(byval _image as Image ptr, byval threshold as single)
declare sub ImageAlphaClear(byval _image as Image ptr, byval color_ as RayColor, byval threshold as single)
declare sub ImageAlphaMask(byval _image as Image ptr, byval alphaMask as Image)
declare sub ImageAlphaPremultiply(byval _image as Image ptr)
declare sub ImageBlurGaussian(byval _image as Image ptr, byval blurSize as long)
declare sub ImageKernelConvolution(byval _image as Image ptr, byval kernel as const single ptr, byval kernelSize as long)
declare sub ImageResize(byval _image as Image ptr, byval newWidth as long, byval newHeight as long)
declare sub ImageResizeNN(byval _image as Image ptr, byval newWidth as long, byval newHeight as long)
declare sub ImageResizeCanvas(byval _image as Image ptr, byval newWidth as long, byval newHeight as long, byval offsetX as long, byval offsetY as long, byval color_ as RayColor)
declare sub ImageMipmaps(byval _image as Image ptr)
declare sub ImageDither(byval _image as Image ptr, byval rBpp as long, byval gBpp as long, byval bBpp as long, byval aBpp as long)
declare sub ImageFlipVertical(byval _image as Image ptr)
declare sub ImageFlipHorizontal(byval _image as Image ptr)
declare sub ImageRotateCW(byval _image as Image ptr)
declare sub ImageRotateCCW(byval _image as Image ptr)
declare sub ImageColorTint(byval _image as Image ptr, byval _color as RayColor)
declare sub ImageColorInvert(byval _image as Image ptr)
declare sub ImageColorGrayscale(byval _image as Image ptr)
declare sub ImageColorContrast(byval _image as Image ptr, byval contrast as single)
declare sub ImageColorBrightness(byval _image as Image ptr, byval brightness as long)
declare sub ImageColorReplace(byval _image as Image ptr, byval _color as RayColor, byval replace as RayColor)
declare function LoadImageColors(byval _image as Image ptr) as RayColor ptr
declare function LoadImagePalette(byval _image as Image ptr, byval maxPaletteSize as long, byval colorCount as long ptr) as RayColor ptr
declare sub UnloadImageColors(byval colors as RayColor ptr)
declare sub UnloadImagePalette(byval colors as RayColor ptr)
declare function GetImageAlphaBorder(byval _image as Image, byval threshold as single) as Rectangle
declare function GetImageColor(byval _image as Image, byval x as long, byval y as long) as RayColor

' Image drawing functions
' NOTE: Image software-rendering functions (CPU) 
declare sub ImageClearBackground(byval dst as Image ptr, byval _color as RayColor)
declare sub ImageDrawPixel(byval dst as Image ptr, byval posX as long, byval posY as long, byval _color as RayColor)
declare sub ImageDrawPixelV(byval dst as Image ptr, byval position as Vector2, byval _color as RayColor)
declare sub ImageDrawLine(byval dst as Image ptr, byval startPosX as long, byval startPosY as long, byval endPosX as long, byval endPosY as long, byval _color as RayColor)
declare sub ImageDrawLineV(byval dst as Image ptr, byval start as Vector2, byval end_ as Vector2, byval _color as RayColor)
declare sub ImageDrawLineEx(byval dst as Image ptr, byval start as Vector2, byval end_ as Vector2, byval thick as long, byval _color as RayColor)
declare sub ImageDrawCircle(byval dst as Image ptr, byval centerX as long, byval centerY as long, byval radius as long, byval _color as RayColor)
declare sub ImageDrawCircleV(byval dst as Image ptr, byval center as Vector2, byval radius as long, byval _color as RayColor)
declare sub ImageDrawCircleLines(byval dst as Image ptr, byval centerX as long, byval centerY as long, byval radius as long, byval _color as RayColor)
declare sub ImageDrawCircleLinesV(byval dst as Image ptr, byval center as Vector2, byval radius as long, byval _color as RayColor)
declare sub ImageDrawRectangle(byval dst as Image ptr, byval posX as long, byval posY as long, byval width_ as long, byval height as long, byval _color as RayColor)
declare sub ImageDrawRectangleV(byval dst as Image ptr, byval position as Vector2, byval size as Vector2, byval _color as RayColor)
declare sub ImageDrawRectangleRec(byval dst as Image ptr, byval rec as Rectangle, byval _color as RayColor)
declare sub ImageDrawRectangleLines(byval dst as Image ptr, byval rec as Rectangle, byval thick as long, byval _color as RayColor)
declare sub ImageDrawTriangle(byval dst as Image ptr, byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval _color as RayColor)
declare sub ImageDrawTriangleEx(byval dst as Image ptr, byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval c1 as RayColor, byval c2 as RayColor, byval c3 as RayColor)
declare sub ImageDrawTriangleLines(byval dst as Image ptr, byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval _color as RayColor)
declare sub ImageDrawTrinagleFan(byval dst as Image ptr, byval points as Vector2 ptr, byval pointCount as long, byval _color as RayColor)
declare sub ImageDrawTrinagleStrip(byval dst as Image ptr, byval points as Vector2 ptr, byval pointCount as long, byval _color as RayColor)
declare sub ImageDraw(byval dst as Image ptr, byval src as Image, byval srcRec as Rectangle, byval dstRec as Rectangle, byval tint as RayColor)
declare sub ImageDrawText(byval dst as Image ptr, byval text as const zstring ptr, byval posX as long, byval posY as long, byval fontSize as long, byval _color as RayColor)
declare sub ImageDrawTextEx(byval dst as Image ptr, byval font as Font, byval text as const zstring ptr, byval position as Vector2, byval fontSize as single, byval spacing as single, byval tint as RayColor)

' Texture loading functions
' NOTE: These functions require GPU access
declare function LoadTexture(byval fileName as const zstring ptr) as Texture2D
declare function LoadTextureFromImage(byval _image as Image) as Texture2D
declare function LoadTextureCubemap(byval _image as Image, byval layoutType as long) as TextureCubemap
declare function LoadRenderTexture(byval width_ as long, byval height as long) as RenderTexture2D
declare function IsTextureValid(byval _texture as Texture2D) as boolean
declare sub UnloadTexture(byval _texture as Texture2D)
declare function IsRenderTextureValid(byval target as RenderTexture2D) as boolean
declare sub UnloadRenderTexture(byval target as RenderTexture2D)
declare sub UpdateTexture(byval _texture as Texture2D, byval pixels as const any ptr)
declare sub UpdateTextureRec(byval _texture as Texture2D, byval rec as Rectangle, byval pixels as const any ptr)

' Texture configuration functions
declare sub GenTextureMipmaps(byval _texture as Texture2D ptr)
declare sub SetTextureFilter(byval _texture as Texture2D, byval filterMode as long)
declare sub SetTextureWrap(byval _texture as Texture2D, byval wrapMode as long)

' Texture drawing functions
declare sub DrawTexture(byval _texture as Texture2D, byval posX as long, byval posY as long, byval tint as RayColor)
declare sub DrawTextureV(byval _texture as Texture2D, byval position as Vector2, byval tint as RayColor)
declare sub DrawTextureEx(byval _texture as Texture2D, byval position as Vector2, byval rotation as single, byval scale as single, byval tint as RayColor)
declare sub DrawTextureRec(byval _texture as Texture2D, byval sourceRec as Rectangle, byval position as Vector2, byval tint as RayColor)
declare sub DrawTexturePro(byval _texture as Texture2D, byval sourceRec as Rectangle, byval destRec as Rectangle, byval origin as Vector2, byval rotation as single, byval tint as RayColor)
declare sub DrawTextureNPatch(byval _texture as Texture2D, byval nPatchInfo as NPatchInfo, byval destRec as Rectangle, byval origin as Vector2, byval rotation as single, byval tint as RayColor)

' RayColor/pixel related functions
declare function ColorIsEqual(byval col1 as RayColor, byval col2 as RayColor) as boolean
declare function Fade(byval _color as RayColor, byval alpha as single) as RayColor
declare function ColorToInt(byval _color as RayColor) as long
declare function ColorNormalize(byval _color as RayColor) as Vector4
declare function ColorFromNormalized(byval normalized as Vector4) as RayColor
declare function ColorToHSV(byval _color as RayColor) as Vector3
declare function ColorFromHSV(byval hsv as Vector3) as RayColor
declare function ColorTint(byval _color as RayColor, byval tint as RayColor) as RayColor
declare function ColorBrightness(byval _color as RayColor, byval factor as single) as RayColor
declare function ColorContrast(byval _color as RayColor, byval contrast as single) as RayColor
declare function ColorAlpha(byval _color as RayColor, byval alpha as single) as RayColor
declare function ColorAlphaBlend(byval dst as RayColor, byval src as RayColor, byval tint as RayColor) as RayColor
declare function ColorLerp(byval color1 as RayColor, byval color2 as RayColor, byval factor as single) as RayColor
declare function GetColor(byval hexValue as ulong) as RayColor
declare function GetPixelColor(byval src as any ptr, byval format_ as long) as RayColor
declare sub SetPixelColor(byval dest as any ptr, byval _color as RayColor, byval format_ as long)
declare function GetPixelDataSize(byval width_ as long, byval height as long, byval format_ as long) as long

'------------------------------------------------------------------------------------
' Font Loading and Text Drawing Functions (Module: text)
'------------------------------------------------------------------------------------

' Font loading/unloading functions
declare function GetFontDefault() as Font
declare function LoadFont(byval fileName as const zstring ptr) as Font
declare function LoadFontEx(byval fileName as const zstring ptr, byval fontSize as long, byval codepoints as long ptr, byval codepointCount as long) as Font
declare function LoadFontFromImage(byval _image as Image, byval key as RayColor, byval firstChar as long) as Font
declare function LoadFontFromMemory(byval fileType as const zstring ptr, byval fileData as const ubyte ptr, byval dataSize as long, byval fontSize as long, byval codepoints as long ptr, byval codepointCount as long) as Font
declare function IsFontValid(byval _font as Font) as boolean
declare function LoadFontData(byval filedata as const ubyte ptr, byval dataSize as long, byval fontSize as long, byval codepoints as long ptr, byval codepointCount as long, byval fontType as long) as GlyphInfo ptr
declare function GenImageFontAtlas(byval glyphs as const GlyphInfo ptr, byval glyphRecs as Rectangle ptr ptr, byval glyphCount as long, byval fontSize as long, byval padding as long, byval packMethod as long) as Image
declare sub UnloadFontData(byval glyphs as GlyphInfo ptr, byval glyphCount as long)
declare sub UnloadFont(byval _font as Font)
declare function ExportFontAsCode(byval _font as Font, byval fileName as const zstring ptr) as boolean

' Text drawing functions
declare sub DrawFPS(byval posX as long, byval posY as long)
declare sub DrawText(byval text as const zstring ptr, byval posX as long, byval posY as long, byval fontSize as long, byval _color as RayColor)
declare sub DrawTextEx(byval _font as Font, byval text as const zstring ptr, byval position as Vector2, byval fontSize as single, byval spacing as single, byval tint as RayColor)
declare sub DrawTextPro(byval _font as Font, byval text as const zstring ptr, byval position as Vector2, byval origin as Vector2, byval rotation as single, byval fontSize as single, byval spacing as single, byval tint as RayColor)
declare sub DrawTextCodepoint(byval _font as Font, byval codepoint as long, byval position as Vector2, byval fontSize as single, byval tint as RayColor)
declare sub DrawTextCodepoints(byval _font as Font, byval codepoints as const long ptr, byval codepointCount as long, byval position as Vector2, byval fontSize as single, byval spacing as single, byval tint as RayColor)

' Text font info functions
declare sub SetTextLineSpacing(byval spacing as long)
declare function MeasureText(byval text as const zstring ptr, byval fontSize as long) as long
declare function MeasureTextEx(byval _font as Font, byval text as const zstring ptr, byval fontSize as single, byval spacing as single) as Vector2
declare function GetGlyphIndex(byval _font as Font, byval codepoint as long) as long
declare function GetGlyphInfo(byval _font as Font, byval codepoint as long) as GlyphInfo
declare function GetGlyphAtlasRec(byval _font as Font, byval codepoint as long) as Rectangle

' Text codepoints management functions (unicode characters)
declare function LoadUTF8(byval codepoints as const long ptr, byval length as long) as zstring ptr
declare sub UnloadUTF8(byval text as zstring ptr)
declare function LoadCodepoints(byval text as const zstring ptr, byval count as long ptr) as long ptr
declare sub UnloadCodepoints(byval codepoints as long ptr)
declare function GetCodepointCount(byval text as const zstring ptr) as long
declare function GetCodepoint(byval text as const zstring ptr, byval codepointSize as long ptr) as long
declare function GetCodepointNext(byval text as const zstring ptr, byval codepointSize as long ptr) as long
declare function GetCodepointPrevious(byval text as const zstring ptr, byval codepointSize as long ptr) as long
declare function CodepointToUTF8(byval codepoint as long, byval utf8Size as long ptr) as const zstring ptr

' Text strings management functions (no UTF-8 strings, only byte chars)
' NOTE: Some strings allocate memory internally for returned strings, just be careful!
declare function TextCopy(byval dst as zstring ptr, byval src as const zstring ptr) as long
declare function TextIsEqual(byval text1 as const zstring ptr, byval text2 as const zstring ptr) as boolean
declare function TextLength(byval text as const zstring ptr) as ulong
declare function TextFormat(byval text as const zstring ptr, ...) as const zstring ptr
declare function TextSubtext(byval text as const zstring ptr, byval position as long, byval length as long) as const zstring ptr
declare function TextReplace(byval text as zstring ptr, byval replace as const zstring ptr, byval by as const zstring ptr) as zstring ptr
declare function TextInsert(byval text as const zstring ptr, byval insert as const zstring ptr, byval position as long) as zstring ptr
declare function TextJoin(byval textList as const zstring ptr ptr, byval count as long, byval delimiter as const zstring ptr) as const zstring ptr
declare function TextSplit(byval text as const zstring ptr, byval delimiter as byte, byval count as long ptr) as const zstring ptr ptr
declare sub TextAppend(byval text as zstring ptr, byval _append as const zstring ptr, byval position as long ptr)
declare function TextFindIndex(byval text as const zstring ptr, byval find as const zstring ptr) as long
declare function TextToUpper(byval text as const zstring ptr) as const zstring ptr
declare function TextToLower(byval text as const zstring ptr) as const zstring ptr
declare function TextToPascal(byval text as const zstring ptr) as const zstring ptr
declare function TextToSnake(byval text as const zstring ptr) as const zstring ptr
declare function TextToCamel(byval text as const zstring ptr) as const zstring ptr

declare function TextToInteger(byval text as const zstring ptr) as long
declare function TextToFloat(byval text as const zstring ptr) as single

'------------------------------------------------------------------------------------
' Basic 3d Shapes Drawing Functions (Module: models)
'------------------------------------------------------------------------------------

' Basic geometric 3D shapes drawing functions
declare sub DrawLine3D(byval startPos as Vector3, byval endPos as Vector3, byval _color as RayColor)
declare sub DrawPoint3D(byval position as Vector3, byval _color as RayColor)
declare sub DrawCircle3D(byval center as Vector3, byval radius as single, byval rotationAxis as Vector3, byval rotationAngle as single, byval _color as RayColor)
declare sub DrawTriangle3D(byval v1 as Vector3, byval v2 as Vector3, byval v3 as Vector3, byval _color as RayColor)
declare sub DrawTriangleStrip3D(byval points as const Vector3 ptr, byval pointCount as long, byval _color as RayColor)
declare sub DrawCube(byval position as Vector3, byval width_ as single, byval height as single, byval length as single, byval _color as RayColor)
declare sub DrawCubeV(byval position as Vector3, byval size as Vector3, byval _color as RayColor)
declare sub DrawCubeWires(byval position as Vector3, byval width_ as single, byval height as single, byval length as single, byval _color as RayColor)
declare sub DrawCubeWiresV(byval position as Vector3, byval size as Vector3, byval _color as RayColor)
declare sub DrawSphere(byval centerPos as Vector3, byval radius as single, byval _color as RayColor)
declare sub DrawSphereEx(byval centerPos as Vector3, byval radius as single, byval rings as long, byval slices as long, byval _color as RayColor)
declare sub DrawSphereWires(byval centerPos as Vector3, byval radius as single, byval rings as long, byval slices as long, byval _color as RayColor)
declare sub DrawCylinder(byval position as Vector3, byval radiusTop as single, byval radiusBottom as single, byval height as single, byval slices as long, byval _color as RayColor)
declare sub DrawCylinderEx(byval startPos as Vector3, byval endPos as Vector3, byval startRadius as single, byval endRadius as single, byval sides as long, byval _color as RayColor)
declare sub DrawCylinderWires(byval position as Vector3, byval radiusTop as single, byval radiusBottom as single, byval height as single, byval slices as long, byval _color as RayColor)
declare sub DrawCylinderWiresEx(byval startPos as Vector3, byval endPos as Vector3, byval startRadius as single, byval endRadius as single, byval sides as long, byval _color as RayColor)
declare sub DrawCapsule(byval startPos as Vector3, byval endPos as Vector3, byval radius as single, byval slices as long, byval rings as long, byval _color as RayColor)
declare sub DrawCapsuleWires(byval startPos as Vector3, byval endPos as Vector3, byval radius as single, byval slices as long, byval rings as long, byval _color as RayColor)
declare sub DrawPlane(byval centerPos as Vector3, byval size as Vector2, byval _color as RayColor)
declare sub DrawRay(byval _ray as Ray, byval _color as RayColor)
declare sub DrawGrid(byval slices as long, byval spacing as single)

'------------------------------------------------------------------------------------
' Model 3d Loading and Drawing Functions (Module: models)
'------------------------------------------------------------------------------------

' Model management functions
declare function LoadModel(byval fileName as const zstring ptr) as Model
declare function LoadModelFromMesh(byval mesh as Mesh) as Model
declare function IsModelValid(byval _model as Model) as boolean
declare sub UnloadModel(byval _model as Model)
declare function GetModelBoundingBox(byval _model as Model) as BoundingBox

' Model drawing functions
declare sub DrawModel(byval _model as Model, byval position as Vector3, byval scale as single, byval tint as RayColor)
declare sub DrawModelEx(byval _model as Model, byval position as Vector3, byval rotationAxis as Vector3, byval rotationAngle as single, byval scale as Vector3, byval tint as RayColor)
declare sub DrawModelWires(byval _model as Model, byval position as Vector3, byval scale as single, byval tint as RayColor)
declare sub DrawModelWiresEx(byval _model as Model, byval position as Vector3, byval rotationAxis as Vector3, byval rotationAngle as single, byval scale as Vector3, byval tint as RayColor)
declare sub DrawModelPoints(byval _model as Model, byval position as Vector3, byval scale as single, byval tint as RayColor)
declare sub DrawModelPointsEx(byval _model as Model, byval position as Vector3, byval rotationAxis as Vector3, byval rotationAngle as single, byval scale as Vector3, byval tint as RayColor)
declare sub DrawBoundingBox(byval box as BoundingBox, byval _color as RayColor)
declare sub DrawBillboard(byval _camera as Camera3D, byval _texture as Texture2D, byval center as Vector3, byval size as single, byval tint as RayColor)
declare sub DrawBillboardRec(byval _camera as Camera3D, byval _texture as Texture2D, byval sourceRec as Rectangle, byval center as Vector3, byval size as single, byval tint as RayColor)
declare sub DrawBillboardPro(byval _camera as Camera3D, byval _texture as Texture2D, byval source as Rectangle, byval position as Vector3, byval up as Vector3, byval size as Vector2, byval origin as Vector2, byval rotation as single, byval tint as RayColor)

' Mesh management functions
declare sub UploadMesh(byval _mesh as Mesh, byval _dynamic as boolean)
declare sub UpdateMeshBuffer(byval _mesh as Mesh, byval index as long, byval _data as const any ptr, byval dataSize as long, byval offset as long)
declare sub UnloadMesh(byval _mesh as Mesh)
declare sub DrawMesh(byval _mesh as Mesh, byval _material as Material, byval transform as Matrix)
declare sub DrawMeshInstanced(byval _mesh as Mesh, byval _material as Material, byval transforms as const Matrix ptr, byval instances as long)
declare function GetMeshBoundingBox(byval _mesh as Mesh) as BoundingBox
declare sub GenMeshTangents(byval _mesh as Mesh ptr)
declare sub ExportMesh(byval _mesh as Mesh, byval fileName as const zstring ptr)
declare sub ExportMeshAsCode(byval _mesh as Mesh, byval filename as const zstring ptr)

' Mesh generation functions
declare function GenMeshPoly(byval sides as long, byval radius as single) as Mesh
declare function GenMeshPlane(byval width_ as single, byval length as single, byval resX as long, byval resZ as long) as Mesh
declare function GenMeshCube(byval width_ as single, byval height as single, byval length as single) as Mesh
declare function GenMeshSphere(byval radius as single, byval rings as long, byval slices as long) as Mesh
declare function GenMeshHemiSphere(byval radius as single, byval rings as long, byval slices as long) as Mesh
declare function GenMeshCylinder(byval radius as single, byval height as single, byval slices as long) as Mesh
declare function GenMeshCone(byval radius as single, byval height as single, byval slices as long) as Mesh
declare function GenMeshTorus(byval radius as single, byval size as single, byval radSeg as long, byval sides as long) as Mesh
declare function GenMeshKnot(byval radius as single, byval size as single, byval radSeg as long, byval sides as long) as Mesh
declare function GenMeshHeightmap(byval heightmap as Image, byval size as Vector3) as Mesh
declare function GenMeshCubicmap(byval cubicmap as Image, byval cubeSize as Vector3) as Mesh

' Material loading/unloading functions
declare function LoadMaterials(byval fileName as const zstring ptr, byval materialCount as long ptr) as Material ptr
declare function LoadMaterialDefault() as Material
declare function IsMaterialValid(byval _material as Material) as boolean
declare sub UnloadMaterial(byval _material as Material)
declare sub SetMaterialTexture(byval _material as Material ptr, byval mapType as long, byval _texture as Texture2D)
declare sub SetModelMeshMaterial(byval _model as Model ptr, byval meshId as long, byval materialId as long)

' Model animations loading/unloading functions
declare function LoadModelAnimations(byval fileName as const zstring ptr, byval animsCount as long ptr) as ModelAnimation ptr
declare sub UpdateModelAnimation(byval _model as Model, byval anim as ModelAnimation, byval frame as long)
declare sub UpdateModelAnimationBones(byval _model as Model, byval anim as ModelAnimation, byval frame as long)
declare sub UnloadModelAnimation(byval anim as ModelAnimation)
declare sub UnloadModelAnimations(byval anims as ModelAnimation ptr, byval animCount as long)
declare function IsModelAnimationValid(byval _model as Model, byval anim as ModelAnimation) as boolean

' Collision detection functions
declare function CheckCollisionSpheres(byval centerA as Vector3, byval radiusA as single, byval centerB as Vector3, byval radiusB as single) as boolean
declare function CheckCollisionBoxes(byval box1 as BoundingBox, byval box2 as BoundingBox) as boolean
declare function CheckCollisionBoxSphere(byval box as BoundingBox, byval center as Vector3, byval radius as single) as boolean
declare function GetRayCollisionSphere(byval _ray as Ray, byval center as Vector3, byval radius as single) as RayCollision
declare function GetRayCollisionBox(byval _ray as Ray, byval box as BoundingBox) as RayCollision
declare function GetRayCollisionRayMesh(byval _ray as Ray, byval _mesh as Mesh, byval transform as Matrix) as RayCollision
declare function GetRayCollisionTriangle(byval _ray as Ray, byval p1 as Vector3, byval p2 as Vector3, byval p3 as Vector3) as RayCollision
declare function GetRayCollisionQuad(byval _ray as Ray, byval p1 as Vector3, byval p2 as Vector3, byval p3 as Vector3, byval p4 as Vector3) as RayCollision

'------------------------------------------------------------------------------------
' Audio Loading and Playing Functions (Module: audio)
'------------------------------------------------------------------------------------
type AudioCallback as sub(byval bufferData as any ptr, byval frames as ulong)

' Audio device management functions
declare sub InitAudioDevice()
declare sub CloseAudioDevice()
declare function IsAudioDeviceReady() as boolean
declare sub SetMasterVolume(byval volume as single)
declare function GetMasterVolume() as single

' Wave/Sound loading/unloading functions
declare function LoadWave(byval fileName as const zstring ptr) as Wave
declare function LoadWaveFromMemory(byval fileType as const zstring ptr, byval fileData as const ubyte ptr, byval dataSize as long) as Wave
declare function IsWaveValid(byval _wave as Wave) as boolean
declare function LoadSound(byval fileName as const zstring ptr) as Sound
declare function LoadSoundFromWave(byval _wave as Wave) as Sound
declare function LoadSoundAlias(byval source as Sound) as Sound
declare function IsSoundValid(byval _sound as Sound) as boolean
declare sub UpdateSound(byval _sound as Sound, byval _data as const any ptr, byval samplesCount as long)
declare sub UnloadWave(byval _wave as Wave)
declare sub UnloadSound(byval _sound as Sound)
declare sub UnloadSoundAlias(byval _alias as Sound)
declare sub ExportWave(byval _wave as Wave, byval fileName as const zstring ptr)
declare sub ExportWaveAsCode(byval _wave as Wave, byval fileName as const zstring ptr)

' Wave/Sound management functions
declare sub PlaySound(byval _sound as Sound)
declare sub StopSound(byval _sound as Sound)
declare sub PauseSound(byval _sound as Sound)
declare sub ResumeSound(byval _sound as Sound)
declare function IsSoundPlaying(byval _sound as Sound) as boolean
declare sub SetSoundVolume(byval _sound as Sound, byval volume as single)
declare sub SetSoundPitch(byval _sound as Sound, byval pitch as single)
declare sub SetSoundPan(byval _sound as Sound, byval pan as single)
declare function WaveCopy(byval _wave as Wave) as Wave
declare sub WaveCrop(byval _wave as Wave ptr, byval initFrame as long, byval finalFrame as long)
declare sub WaveFormat(byval _wave as Wave ptr, byval sampleRate as long, byval sampleSize as long, byval channels as long)
declare function LoadWaveSamples(byval _wave as Wave) as single ptr
declare sub UnloadWaveSamples(byval samples as single ptr)

' Music management functions
declare function LoadMusicStream(byval fileName as const zstring ptr) as Music
declare function LoadMusicStreamFromMemory(byval fileType as const zstring ptr, byval _data as const ubyte ptr, byval dataSize as long) as Music
declare function IsMusicValid(byval _music as Music) as boolean
declare sub UnloadMusicStream(byval _music as Music)
declare sub PlayMusicStream(byval _music as Music)
declare function IsMusicStreamPlaying(byval _music as Music) as boolean
declare sub UpdateMusicStream(byval _music as Music)
declare sub StopMusicStream(byval _music as Music)
declare sub PauseMusicStream(byval _music as Music)
declare sub ResumeMusicStream(byval _music as Music)
declare sub SeekMusicStream(byval _music as Music, byval position as single)
declare sub SetMusicVolume(byval _music as Music, byval volume as single)
declare sub SetMusicPitch(byval _music as Music, byval pitch as single)
declare sub SetMusicPan(byval _music as Music, byval pan as single)
declare function GetMusicTimeLength(byval _music as Music) as single
declare function GetMusicTimePlayed(byval _music as Music) as single

' AudioStream management functions
declare function LoadAudioStream(byval sampleRate as ulong, byval sampleSize as ulong, byval channels as ulong) as AudioStream
declare function IsAudioStreamValid(byval stream as AudioStream) as boolean
declare sub UnloadAudioStream(byval stream as AudioStream)
declare sub UpdateAudioStream(byval stream as AudioStream, byval _data as const any ptr, byval frameCount as long)
declare function IsAudioStreamProcessed(byval stream as AudioStream) as boolean
declare sub PlayAudioStream(byval stream as AudioStream)
declare sub PauseAudioStream(byval stream as AudioStream)
declare sub ResumeAudioStream(byval stream as AudioStream)
declare function IsAudioStreamPlaying(byval stream as AudioStream) as boolean
declare sub StopAudioStream(byval stream as AudioStream)
declare sub SetAudioStreamVolume(byval stream as AudioStream, byval volume as single)
declare sub SetAudioStreamPitch(byval stream as AudioStream, byval pitch as single)
declare sub SetAudioStreamPan(byval stream as AudioStream, byval pan as single)
declare sub SetAudioStreamBufferSizeDefault(byval size as long)
declare sub SetAudioStreamCallback(byval stream as AudioStream, byval callback as AudioCallback)

declare sub AttachAudioStreamProcessor(byval stream as AudioStream, byval processor as AudioCallback)
declare sub DetachAudioStreamProcessor(byval stream as AudioStream, byval processor as AudioCallback)

declare sub AttachAudioMixedProcessor(byval processor as AudioCallback)
declare sub DetachAudioMixedProcessor(byval processor as AudioCallback)

end extern

#endif 'RAYLIB_BI