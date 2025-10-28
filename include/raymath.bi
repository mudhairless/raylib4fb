/'*********************************************************************************************
*
*   raymath v2.0 - Math functions to work with Vector2, Vector3, Matrix and Quaternions
*
*   CONVENTIONS:
*     - Matrix structure is defined as row-major (memory layout) but parameters naming AND all
*       math operations performed by the library consider the structure as it was column-major
*       It is like transposed versions of the matrices are used for all the maths
*       It benefits some functions making them cache-friendly and also avoids matrix
*       transpositions sometimes required by OpenGL
*       Example: In memory order, row0 is [m0 m4 m8 m12] but in semantic math row0 is [m0 m1 m2 m3]
*     - Functions are always self-contained, no function use another raymath function inside,
*       required code is directly re-implemented inside
*     - Functions input parameters are always received by value (2 unavoidable exceptions)
*     - Functions use always a "result" variable for return (except C++ operators)
*     - Functions are always defined inline
*     - Angles are always in radians (DEG2RAD/RAD2DEG macros provided for convenience)
*     - No compound literals used to make sure libray is compatible with C++
*
*   CONFIGURATION:
*       #define RAYMATH_IMPLEMENTATION
*           Generates the implementation of the library into the included file.
*           If not defined, the library is in header only mode and can be included in other headers
*           or source files without problems. But only ONE file should hold the implementation.
*
*
*       #define RAYMATH_DISABLE_FB_OPERATORS
*           Disables FreeBASIC operator overloads for raymath types.
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2015-2024 Ramon Santamaria (@raysan5)
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
'FreeBASIC translation by Ebben Feagan 2025

#ifndef RAYMATH_BI
#define RAYMATH_BI

#include once "crt/math.bi"

'----------------------------------------------------------------------------------
' Defines and Macros
'----------------------------------------------------------------------------------
#ifndef PI
    #define PI 3.14159265358979323846f
#endif

#ifndef EPSILON
    #define EPSILON 0.000001f
#endif

#ifndef DEG2RAD
    #define DEG2RAD (PI/180.0f)
#endif

#ifndef RAD2DEG
    #define RAD2DEG (180.0f/PI)
#endif

#ifndef EPSILON
    #define EPSILON 0.000001f
#endif

' Get float vector for Matrix
#ifndef MatrixToFloat
    #define MatrixToFloat(mat) (MatrixToFloatV(mat).v)
#endif

' Get float vector for Vector3
#ifndef Vector3ToFloat
    #define Vector3ToFloat(vec) (Vector3ToFloatV(vec).v)
#endif

'----------------------------------------------------------------------------------
' Types and Structures Definition
'----------------------------------------------------------------------------------
#ifndef RL_VECTOR2_TYPE
' Vector2 type
type Vector2
    x as single
    y as single
end type
#define RL_VECTOR2_TYPE
#endif

#ifndef RL_VECTOR3_TYPE
' Vector3 type
type Vector3
    x as single
    y as single
    z as single
end type
#define RL_VECTOR3_TYPE
#endif

#ifndef RL_VECTOR4_TYPE
' Vector4 type
type Vector4
	x as single
	y as single
	z as single
	w as single
end type
#define RL_VECTOR4_TYPE
#endif

#ifndef RL_QUATERNION_TYPE
' Quaternion type
type Quaternion
	x as single
	y as single
	z as single
	w as single
end type
#define RL_QUATERNION_TYPE
#endif

#ifndef RL_MATRIX_TYPE
' Matrix type (OpenGL style 4x4 - right_ handed, column major)
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
#define RL_MATRIX_TYPE
#endif

' NOTE: Helper types to be used instead of array return types for *ToFloat functions
type float3 
    v(0 to 2) as single
end type

type float16 
    v(0 to 15) as single
end type

'----------------------------------------------------------------------------------
' Module Functions Declaration - Utils math
'----------------------------------------------------------------------------------

declare function Clamp(byval value as single, byval _min as single, byval _max as single) as single
declare function Lerp(byval start as single, byval end_ as single, byval amount as single) as single
declare function Normalize(byval value as single, byval start as single, byval end_ as single) as single
declare function Remap(byval value as single, byval inputStart as single, byval inputEnd as single, byval outputStart as single, byval outputEnd as single) as single
declare function Wrap(byval value as single, byval _min as single, byval _max as single) as single
declare function FloatEquals(byval a as single, byval b as single) as boolean

'----------------------------------------------------------------------------------
' Module Functions Declarations - Vector2 math
'----------------------------------------------------------------------------------
#define Vector2Zero type<Vector2>(0.0f, 0.0f)
#define Vector2One type<Vector2>(1.0f, 1.0f)
#define Vector2UnitX type<Vector2>(1.0f, 0.0f)
#define Vector2UnitY type<Vector2>(0.0f, 1.0f)

declare function Vector2Add(byval v1 as Vector2, byval v2 as Vector2) as Vector2
declare function Vector2AddValue(byval v as Vector2, byval add as single) as Vector2
declare function Vector2Subtract(byval v1 as Vector2, byval v2 as Vector2) as Vector2
declare function Vector2SubtractValue(byval v as Vector2, byval subtract as single) as Vector2
declare function Vector2Length(byval v as Vector2) as single
declare function Vector2LengthSqr(byval v as Vector2) as single
declare function Vector2DotProduct(byval v1 as Vector2, byval v2 as Vector2) as single
declare function Vector2Distance(byval v1 as Vector2, byval v2 as Vector2) as single
declare function Vector2DistanceSqr(byval v1 as Vector2, byval v2 as Vector2) as single
declare function Vector2Angle(byval v1 as Vector2, byval v2 as Vector2) as single
declare function Vector2LineAngle(byval start as Vector2, byval _end as Vector2) as single
declare function Vector2Scale(byval v as Vector2, byval scale as single) as Vector2
declare function Vector2Multiply(byval v1 as Vector2, byval v2 as Vector2) as Vector2
declare function Vector2Negate(byval v as Vector2) as Vector2
declare function Vector2Divide(byval v1 as Vector2, byval v2 as Vector2) as Vector2
declare function Vector2Normalize(byval v as Vector2) as Vector2
declare function Vector2Transform(byval v as Vector2, byval mat as Matrix) as Vector2
declare function Vector2Lerp(byval v1 as Vector2, byval v2 as Vector2, byval amount as single) as Vector2
declare function Vector2Reflect(byval v as Vector2, byval normal as Vector2) as Vector2
declare function Vector2Min(byval v1 as Vector2, byval v2 as Vector2) as Vector2
declare function Vector2Max(byval v1 as Vector2, byval v2 as Vector2) as Vector2
declare function Vector2Rotate(byval v as Vector2, byval angle as single) as Vector2
declare function Vector2MoveTowards(byval v as Vector2, byval target as Vector2, byval maxDistance as single) as Vector2
declare function Vector2Invert(byval v as Vector2) as Vector2
declare function Vector2Clamp(byval v as Vector2, byval _min as Vector2, byval _max as Vector2) as Vector2
declare function Vector2ClampValue(byval v as Vector2, byval _min as single, byval _max as single) as Vector2
declare function Vector2Equals(byval a as Vector2, byval b as Vector2) as boolean
declare function Vector2Refract(byval v as Vector2, byval n as Vector2, byval r as single) as Vector2

'----------------------------------------------------------------------------------
' Module Functions Declarations - Vector3 math
'----------------------------------------------------------------------------------
#define Vector3Zero type<Vector3>(0.0f, 0.0f, 0.0f)
#define Vector3One type<Vector3>(1.0f, 1.0f, 1.0f)
#define Vector3UnitX type<Vector3>(1.0f, 0.0f, 0.0f)
#define Vector3UnitY type<Vector3>(0.0f, 1.0f, 0.0f)
#define Vector3UnitZ type<Vector3>(0.0f, 0.0f, 1.0f)

declare function Vector3Add(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare function Vector3AddValue(byval v as Vector3, byval add as single) as Vector3
declare function Vector3Subtract(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare function Vector3SubtractValue(byval v as Vector3, byval subtract as single) as Vector3
declare function Vector3Scale(byval v as Vector3, byval scalar as single) as Vector3
declare function Vector3Multiply(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare function Vector3CrossProduct(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare function Vector3Perpendicular(byval v as Vector3) as Vector3
declare function Vector3Length(byval v as Vector3) as single
declare function Vector3LengthSqr(byval v as Vector3) as single
declare function Vector3DotProduct(byval v1 as Vector3, byval v2 as Vector3) as single
declare function Vector3Distance(byval v1 as Vector3, byval v2 as Vector3) as single
declare function Vector3DistanceSqr(byval v1 as Vector3, byval v2 as Vector3) as single
declare function Vector3Angle(byval v1 as Vector3, byval v2 as Vector3) as single
declare function Vector3Negate(byval v as Vector3) as Vector3
declare function Vector3Divide(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare function Vector3Normalize(byval v as Vector3) as Vector3
declare function Vector3Project(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare function Vector3Reject(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare sub Vector3OrthoNormalize(byval v1 as Vector3 ptr, byval v2 as Vector3 ptr)
declare function Vector3Transform(byval v as Vector3, byval mat as Matrix) as Vector3
declare function Vector3RotateByQuaternion(byval v as Vector3, byval q as Quaternion) as Vector3
declare function Vector3RotateByAxisAngle(byval v as Vector3, byval axis as Vector3, byval angle as single) as Vector3
declare function Vector3MoveTowards(byval v as Vector3, byval target as Vector3, byval maxDistance as single) as Vector3
declare function Vector3Lerp(byval v1 as Vector3, byval v2 as Vector3, byval amount as single) as Vector3
declare function Vector3CubicHermite(byval v1 as Vector3, byval tangent1 as Vector3, byval v2 as Vector3, byval tangent2 as Vector3, byval amount as single) as Vector3
declare function Vector3Reflect(byval v as Vector3, byval normal as Vector3) as Vector3
declare function Vector3Min(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare function Vector3Max(byval v1 as Vector3, byval v2 as Vector3) as Vector3
declare function Vector3Barycenter(byval p as Vector3, byval a as Vector3, byval b as Vector3, byval c as Vector3) as Vector3
declare function Vector3Unproject(byval source as Vector3, byval projection as Matrix, byval _view as Matrix) as Vector3
declare function Vector3ToFloatV(byval v as Vector3) as float3
declare function Vector3Invert(byval v as Vector3) as Vector3
declare function Vector3Clamp(byval v as Vector3, byval _min as Vector3, byval _max as Vector3) as Vector3
declare function Vector3ClampValue(byval v as Vector3, byval _min as single, byval _max as single) as Vector3
declare function Vector3Equals(byval a as Vector3, byval b as Vector3) as boolean
declare function Vector3Refract(byval v as Vector3, byval n as Vector3, byval r as single) as Vector3

'----------------------------------------------------------------------------------
' Module Functions Declarations - Vector4 math
'----------------------------------------------------------------------------------
#define Vector4Zero type<Vector4>(0.0f, 0.0f, 0.0f, 0.0f)
#define Vector4One type<Vector4>(1.0f, 1.0f, 1.0f, 1.0f)
#define Vector4UnitX type<Vector4>(1.0f, 0.0f, 0.0f, 0.0f)
#define Vector4UnitY type<Vector4>(0.0f, 1.0f, 0.0f, 0.0f)
#define Vector4UnitZ type<Vector4>(0.0f, 0.0f, 1.0f, 0.0f)
#define Vector4UnitW type<Vector4>(0.0f, 0.0f, 0.0f, 1.0f)

declare function Vector4Add(byval v1 as Vector4, byval v2 as Vector4) as Vector4
declare function Vector4AddValue(byval v as Vector4, byval value as single) as Vector4
declare function Vector4Subtract(byval v1 as Vector4, byval v2 as Vector4) as Vector4
declare function Vector4SubtractValue(byval v as Vector4, byval value as single) as Vector4
declare function Vector4Length(byval v as Vector4) as single
declare function Vector4LengthSqr(byval v as Vector4) as single
declare function Vector4DotProduct(byval v1 as Vector4, byval v2 as Vector4) as single
declare function Vector4Distance(byval v1 as Vector4, byval v2 as Vector4) as single
declare function Vector4DistanceSqr(byval v1 as Vector4, byval v2 as Vector4) as single
declare function Vector4Scale(byval v as Vector4, byval scale as single) as Vector4
declare function Vector4Multiply(byval v1 as Vector4, byval v2 as Vector4) as Vector4
declare function Vector4Negate(byval v as Vector4) as Vector4
declare function Vector4Divide(byval v1 as Vector4, byval v2 as Vector4) as Vector4
declare function Vector4Normalize(byval v as Vector4) as Vector4
declare function Vector4Min(byval v1 as Vector4, byval v2 as Vector4) as Vector4
declare function Vector4Max(byval v1 as Vector4, byval v2 as Vector4) as Vector4
declare function Vector4Lerp(byval v1 as Vector4, byval v2 as Vector4, byval amount as single) as Vector4
declare function Vector4MoveTowards(byval v as Vector4, byval target as Vector4, byval maxDistance as single) as Vector4
declare function Vector4Invert(byval v as Vector4) as Vector4
declare function Vector4Equals(byval a as Vector4, byval b as Vector4) as boolean

'----------------------------------------------------------------------------------
' Module Functions Declarations - Matrix math
'----------------------------------------------------------------------------------
#define MatrixZero type<Matrix>( _
                            0.0f, 0.0f, 0.0f, 0.0f, _
                            0.0f, 0.0f, 0.0f, 0.0f, _
                            0.0f, 0.0f, 0.0f, 0.0f, _
                            0.0f, 0.0f, 0.0f, 0.0f _
                        )
#define MatrixIdentity type<Matrix>( _
                            1.0f, 0.0f, 0.0f, 0.0f, _
                            0.0f, 1.0f, 0.0f, 0.0f, _
                            0.0f, 0.0f, 1.0f, 0.0f, _
                            0.0f, 0.0f, 0.0f, 1.0f _
                        )

declare function MatrixDeterminate(byval mat as Matrix) as single
declare function MatrixTrace(byval mat as Matrix) as single
declare function MatrixTranspose(byval mat as Matrix) as Matrix
declare function MatrixInvert(byval mat as Matrix) as Matrix
declare function MatrixAdd(byval left_ as Matrix, byval right_ as Matrix) as Matrix
declare function MatrixSubtract(byval left_ as Matrix, byval right_ as Matrix) as Matrix
declare function MatrixMultiply(byval left_ as Matrix, byval right_ as Matrix) as Matrix
declare function MatrixTranslate(byval x as single, byval y as single, byval z as single) as Matrix
declare function MatrixRotate(byval axis as Vector3, byval angle as single) as Matrix
declare function MatrixRotateX(byval angle as single) as Matrix
declare function MatrixRotateY(byval angle as single) as Matrix
declare function MatrixRotateZ(byval angle as single) as Matrix
declare function MatrixRotateXYZ(byval angle as Vector3) as Matrix
declare function MatrixRotateZYX(byval angle as Vector3) as Matrix
declare function MatrixScale(byval x as single, byval y as single, byval z as single) as Matrix
declare function MatrixFrustum(byval left_ as double, byval right_ as double, byval bottom as double, byval top as double, byval nearPlane as double, byval farPlane as double) as Matrix
declare function MatrixPerspective(byval fovY as double, byval aspect as double, byval nearPlane as double, byval farPlane as double) as Matrix
declare function MatrixOrtho(byval left_ as double, byval right_ as double, byval bottom as double, byval top as double, byval nearPlane as double, byval farPlane as double) as Matrix
declare function MatrixLookAt(byval eye as Vector3, byval target as Vector3, byval up as Vector3) as Matrix
declare function MatrixToFloatV(byval mat as Matrix) as float16

'----------------------------------------------------------------------------------
' Module Functions Declarations - Quaternion math
'----------------------------------------------------------------------------------
#define QuaternionZero type<Quaternion>(0.0f, 0.0f, 0.0f, 0.0f)
#define QuaternionOne type<Quaternion>(1.0f, 1.0f, 1.0f, 1.0f)
#define QuaternionIdentity type<Quaternion>(0.0f, 0.0f, 0.0f, 1.0f)
#define QuaternionUnitX type<Quaternion>(0.0f, 0.0f, 0.0f, 1.0f)

declare function QuaternionAdd(byval q1 as Quaternion, byval q2 as Quaternion) as Quaternion
declare function QuaternionAddValue(byval q as Quaternion, byval value as single) as Quaternion
declare function QuaternionSubtract(byval q1 as Quaternion, byval q2 as Quaternion) as Quaternion
declare function QuaternionSubtractValue(byval q as Quaternion, byval value as single) as Quaternion
declare function QuaternionLength(byval q as Quaternion) as single
declare function QuaternionNormalize(byval q as Quaternion) as Quaternion
declare function QuaternionInvert(byval q as Quaternion) as Quaternion
declare function QuaternionMultiply(byval q2 as Quaternion, byval q2 as Quaternion) as Quaternion
declare function QuaternionScale(byval q as Quaternion, byval value as single) as Quaternion
declare function QuaternionDivide(byval q1 as Quaternion, byval q2 as Quaternion) as Quaternion
declare function QuaternionLerp(byval q1 as Quaternion, byval q2 as Quaternion, byval amount as single) as Quaternion
declare function QuaternionNlerp(byval q1 as Quaternion, byval q2 as Quaternion, byval amount as single) as Quaternion
declare function QuaternionSlerp(byval q1 as Quaternion, byval q2 as Quaternion, byval amount as single) as Quaternion
declare function QuaternionCubicHermiteSpline(byval q1 as Quaternion, byval outTangent1 as Quaternion, byval q2 as Quaternion, byval inTangent2 as Quaternion, byval t as single) as Quaternion
declare function QuaternionFromVector3ToVector3(byval from_ as Vector3, byval to_ as Vector3) as Quaternion
declare function QuaternionFromMatrix(byval mat as Matrix) as Quaternion
declare function QuaternionToMatrix(byval q as Quaternion) as Matrix
declare function QuaternionFromAxisAngle(byval axis as Vector3, byval angle as single) as Quaternion
declare sub QuaternionToAxisAngle(byval q as Quaternion, byval outAxis as Vector3 ptr, byval outAngle as single ptr)
declare function QuaternionFromEuler(byval pitch as single, byval yaw as single, byval roll as single) as Quaternion
declare function QuaternionToEuler(byval q as Quaternion) as Vector3
declare function QuaternionTransform(byval q as Quaternion, byval mat as Matrix) as Quaternion
declare function QuaternionEquals(byval a as Quaternion, byval b as Quaternion) as boolean
declare sub MatrixDecompose(byval mat as Matrix, byval translation as Vector3 ptr, byval rotation as Quaternion ptr, byval scale as Vector3 ptr)


#ifndef RAYMATH_DISABLE_FB_OPERATORS

declare operator + (byval lhs as const Vector2, byval rhs as const Vector2) as Vector2
declare operator + (byval lhs as const Vector2, byval rhs as const single) as Vector2
declare operator - (byval lhs as const Vector2, byval rhs as const Vector2) as Vector2
declare operator - (byval lhs as const Vector2, byval rhs as const single) as Vector2
declare operator * (byval lhs as const Vector2, byval rhs as const Vector2) as Vector2
declare operator * (byval lhs as const Vector2, byval rhs as const single) as Vector2
declare operator * (byval lhs as const Vector2, byval rhs as const Matrix) as Vector2
declare operator / (byval lhs as const Vector2, byval rhs as const Vector2) as Vector2
declare operator / (byval lhs as const Vector2, byval rhs as const single) as Vector2
declare operator = (byval lhs as const Vector2, byval rhs as const Vector2) as integer
declare operator <> (byval lhs as const Vector2, byval rhs as const Vector2) as integer

declare operator + (byval lhs as const Vector3, byval rhs as const Vector3) as Vector3
declare operator + (byval lhs as const Vector3, byval rhs as const single) as Vector3
declare operator - (byval lhs as const Vector3, byval rhs as const Vector3) as Vector3
declare operator - (byval lhs as const Vector3, byval rhs as const single) as Vector3
declare operator * (byval lhs as const Vector3, byval rhs as const Vector3) as Vector3
declare operator * (byval lhs as const Vector3, byval rhs as const single) as Vector3
declare operator * (byval lhs as const Vector3, byval rhs as const Matrix) as Vector3
declare operator / (byval lhs as const Vector3, byval rhs as const Vector3) as Vector3
declare operator / (byval lhs as const Vector3, byval rhs as const single) as Vector3
declare operator = (byval lhs as const Vector3, byval rhs as const Vector3) as integer
declare operator <> (byval lhs as const Vector3, byval rhs as const Vector3) as integer

declare operator + (byval lhs as const Vector4, byval rhs as const Vector4) as Vector4
declare operator + (byval lhs as const Vector4, byval rhs as const single) as Vector4
declare operator - (byval lhs as const Vector4, byval rhs as const Vector4) as Vector4
declare operator - (byval lhs as const Vector4, byval rhs as const single) as Vector4
declare operator * (byval lhs as const Vector4, byval rhs as const Vector4) as Vector4
declare operator * (byval lhs as const Vector4, byval rhs as const single) as Vector4
declare operator / (byval lhs as const Vector4, byval rhs as const Vector4) as Vector4
declare operator / (byval lhs as const Vector4, byval rhs as const single) as Vector4
declare operator = (byval lhs as const Vector4, byval rhs as const Vector4) as integer
declare operator <> (byval lhs as const Vector4, byval rhs as const Vector4) as integer

declare operator + (byval lhs as const Quaternion, byval rhs as const single) as Quaternion
declare operator - (byval lhs as const Quaternion, byval rhs as const single) as Quaternion
declare operator * (byval lhs as const Quaternion, byval rhs as const Matrix) as Quaternion

declare operator + (byval lhs as const Matrix, byval rhs as const Matrix) as Matrix
declare operator - (byval lhs as const Matrix, byval rhs as const Matrix) as Matrix
declare operator * (byval lhs as const Matrix, byval rhs as const Matrix) as Matrix

#endif 'RAYMATH_DISABLE_FB_OPERATORS

#ifdef RAYMATH_IMPLEMENTATION

function FloatEquals(byval x as single, byval y as single) as boolean
    return (fabsf(x - y)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(x), fabsf(y))))
end function

'----------------------------------------------------------------------------------
' Module Functions Definition - Vector2 math
'----------------------------------------------------------------------------------

function Vector2Add(byval v1 as Vector2, byval v2 as Vector2) as Vector2
    return type<Vector2>(v1.x + v2.x, v1.y + v2.y)
end function

function Vector2AddValue(byval v as Vector2, byval value as single) as Vector2
    return type<Vector2>(v.x + value, v.y + value)
end function

function Vector2Subtract(byval v1 as Vector2, byval v2 as Vector2) as Vector2
    return type<Vector2>(v1.x - v2.x, v1.y - v2.y)
end function

function Vector2SubtractValue(byval v as Vector2, byval value as single) as Vector2
    return type<Vector2>(v.x - value, v.y - value)
end function

function Vector2Length(byval v as Vector2) as single
    return sqrtf((v.x*v.x) + (v.y*v.y))
end function

function Vector2LengthSqr(byval v as Vector2) as single
    return (v.x*v.x) + (v.y*v.y)
end function

function Vector2DotProduct(byval v1 as Vector2, byval v2 as Vector2) as single
    return (v1.x*v2.x + v1.y*v2.y)
end function

function Vector2Distance(byval v1 as Vector2, byval v2 as Vector2) as single
    return sqrtf((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y))
end function

function Vector2DistanceSqr(byval v1 as Vector2, byval v2 as Vector2) as single
    return (v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y)
end function

function Vector2Angle(byval v1 as Vector2, byval v2 as Vector2) as single
    var result = 0.0f

    var dot = v1.x*v2.x + v1.y*v2.y
    var det = v1.x*v2.y - v1.y*v2.x

    result = atan2f(det, dot)

    return result
end function

function Vector2LineAngle(byval start as Vector2, byval end_ as Vector2) as single
    return -atan2f(end_.y - start.y, end_.x - start.x)
end function

function Vector2Scale(byval v as Vector2, byval scale as single) as Vector2
    return type<Vector2>(v.x * scale, v.y * scale)
end function

function Vector2Multiply(byval v1 as Vector2, byval v2 as Vector2) as Vector2
    return type<Vector2>(v1.x * v2.x, v1.y * v2.y)
end function

function Vector2Negate(byval v as Vector2) as Vector2
    return type<Vector2>(-v.x, -v.y)
end function

function Vector2Divide(byval v1 as Vector2, byval v2 as Vector2) as Vector2
    return type<Vector2>(v1.x / v2.x, v1.y / v2.y)
end function

function Vector2Normalize(byval v as Vector2) as Vector2
    var result = Vector2Zero

    var length = sqrtf((v.x*v.x) + (v.y*v.y))

    if (length > 0) then
        var ilength = 1.0f/length
        result.x = v.x*ilength
        result.y = v.y*ilength
    end if

    return result
end function

function Vector2Transform(byval v as Vector2, byval mat as Matrix) as Vector2
    var result = Vector2Zero

    var x = v.x
    var y = v.y
    var z = 0f

    result.x = mat.m0*x + mat.m4*y + mat.m8*z + mat.m12
    result.y = mat.m1*x + mat.m5*y + mat.m9*z + mat.m13

    return result
end function

function Vector2Lerp(byval v1 as Vector2, byval v2 as Vector2, byval amount as single) as Vector2
    var result = Vector2Zero

    result.x = v1.x + amount*(v2.x - v1.x)
    result.y = v1.y + amount*(v2.y - v1.y)

    return result
end function

function Vector2Reflect(byval v as Vector2, byval normal as Vector2) as Vector2
    var result = Vector2Zero

    var dotProduct = (v.x*normal.x + v.y*normal.y) 

    result.x = v.x - (2.0f*normal.x)*dotProduct
    result.y = v.y - (2.0f*normal.y)*dotProduct

    return result
end function

function Vector2Min(byval v1 as Vector2, byval v2 as Vector2) as Vector2
    var result = Vector2Zero

    result.x = fminf(v1.x, v2.x)
    result.y = fminf(v1.y, v2.y)

    return result
end function

function Vector2Max(byval v1 as Vector2, byval v2 as Vector2) as Vector2
    var result = Vector2Zero

    result.x = fmaxf(v1.x, v2.x)
    result.y = fmaxf(v1.y, v2.y)

    return result
end function

function Vector2Rotate(byval v as Vector2, byval angle as single) as Vector2
    var result = Vector2Zero

    var cosres = cosf(angle)
    var sinres = sinf(angle)

    result.x = v.x*cosres - v.y*sinres
    result.y = v.x*sinres + v.y*cosres

    return result
end function

function Vector2MoveTowards(byval v as Vector2, byval target as Vector2, byval maxDistance as single) as Vector2
    var result = Vector2Zero

    var dx = target.x - v.x
    var dy = target.y - v.y
    var value = (dx*dx) + (dy*dy)

    if ((value = 0f) OR ((maxDistance >= 0f) AND (value <= maxDistance*maxDistance))) then
        return target
    end if

    var dist = sqrtf(value)

    result.x = v.x + dx/dist*maxDistance
    result.y = v.y + dy/dist*maxDistance

    return result
end function

function Vector2Invert(byval v as Vector2) as Vector2
    return type<Vector2>(1.0f/v.x, 1.0f/v.y)
end function

function Vector2Clamp(byval v as Vector2, byval min_ as Vector2, byval max_ as Vector2) as Vector2
    var result = Vector2Zero

    result.x = fminf(max_.x, fmaxf(min_.x, v.x))
    result.y = fminf(max_.y, fmaxf(min_.y, v.y))

    return result
end function

function Vector2ClampValue(byval v as Vector2, byval min_ as single, byval max_ as single) as Vector2
    var result = v

    var length = (v.x*v.x) + (v.y*v.y)
    if (length > 0.0f) then

        length = sqrtf(length)

        var scale = 1.0f    ' By default, 1 as the neutral element.
        if (length < min_) then
            scale = min_/length
        elseif (length > max_) then
            scale = max_/length
        end if

        result.x = v.x*scale
        result.y = v.y*scale
    end if

    return result
end function

function Vector2Equals(byval p as Vector2, byval q as Vector2) as boolean
    return ((fabsf(p.x - q.x)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.x), fabsf(q.x))))) AND _
            ((fabsf(p.y - q.y)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.y), fabsf(q.y)))))
end function

function Vector2Refract(byval v as Vector2, byval n as Vector2, byval r as single) as Vector2
    var result = Vector2Zero

    var dot = v.x*n.x + v.y*n.y
    var d = 1.0f - r*r*(1.0f - dot*dot)

    if (d >= 0.0f) then
        d = sqrtf(d)
        result.x = r*v.x - (r*dot + d)*n.x
        result.y = r*v.y - (r*dot + d)*n.y
    end if

    return result
end function

'----------------------------------------------------------------------------------
' Module Functions Definition - Vector3 math
'----------------------------------------------------------------------------------

function Vector3Add(byval v1 as Vector3, byval v2 as Vector3) as Vector3
    return type<Vector3>(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
end function

function Vector3AddValue(byval v as Vector3, byval value as single) as Vector3
    return type<Vector3>(v.x + value, v.y + value, v.z + value)
end function

function Vector3Subtract(byval v1 as Vector3, byval v2 as Vector3) as Vector3
    return type<Vector3>(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
end function

function Vector3SubtractValue(byval v as Vector3, byval value as single) as Vector3
    return type<Vector3>(v.x - value, v.y - value, v.z - value)
end function

function Vector3Scale(byval v as Vector3, byval scalar as single) as Vector3
    return type<Vector3>(v.x * scalar, v.y * scalar, v.z * scalar)
end function

function Vector3Multiply(byval v1 as Vector3, byval v2 as Vector3) as Vector3
    return type<Vector3>(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z)
end function

function Vector3CrossProduct(byval v1 as Vector3, byval v2 as Vector3) as Vector3
    return type<Vector3>(v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x)
end function

function Vector3Perpendicular(byval v as Vector3) as Vector3
    var result = Vector3Zero

    var min_ = fabsf(v.x)
    var cardinalAxis = type<Vector3>(1.0f, 0.0f, 0.0f)

    if (fabsf(v.y) < min_) then
        min_ = fabsf(v.y)
        cardinalAxis = type<Vector3>(0.0f, 1.0f, 0.0f)
    end if

    if (fabsf(v.z) < min_) then
        cardinalAxis = type<Vector3>(0.0f, 0.0f, 1.0f)
    end if

    ' Cross product between vectors
    result.x = v.y*cardinalAxis.z - v.z*cardinalAxis.y
    result.y = v.z*cardinalAxis.x - v.x*cardinalAxis.z
    result.z = v.x*cardinalAxis.y - v.y*cardinalAxis.x

    return result
end function

function Vector3Length(byval v as Vector3) as single
    return sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
end function

function Vector3LengthSqr(byval v as Vector3) as single
    return (v.x*v.x + v.y*v.y + v.z*v.z)
end function

function Vector3DotProduct(byval v1 as Vector3, byval v2 as Vector3) as single
    return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
end function

function Vector3Distance(byval v1 as Vector3, byval v2 as Vector3) as single
    var result = 0.0f

    var dx = v2.x - v1.x
    var dy = v2.y - v1.y
    var dz = v2.z - v1.z
    result = sqrtf(dx*dx + dy*dy + dz*dz)

    return result
end function

function Vector3DistanceSqr(byval v1 as Vector3, byval v2 as Vector3) as single
    var result = 0.0f

    var dx = v2.x - v1.x
    var dy = v2.y - v1.y
    var dz = v2.z - v1.z
    result = (dx*dx + dy*dy + dz*dz)

    return result
end function

function Vector3Angle(byval v1 as Vector3, byval v2 as Vector3) as single
    var cross = type<Vector3>( v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x )
    var _len = sqrtf(cross.x*cross.x + cross.y*cross.y + cross.z*cross.z)
    var dot = (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z)
    return atan2f(_len, dot)
end function

function Vector3Negate(byval v as Vector3) as Vector3
    return type<Vector3>(-v.x, -v.y, -v.z)
end function

function Vector3Divide(byval v1 as Vector3, byval v2 as Vector3) as Vector3
    return type<Vector3>(v1.x / v2.x, v1.y / v2.y, v1.z / v2.z)
end function

function Vector3Normalize(byval v as Vector3) as Vector3
    var result = v

    var length = sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
    if (length <> 0.0f) then
        var ilength = 1.0f/length

        result.x *= ilength
        result.y *= ilength
        result.z *= ilength
    end if

    return result
end function

function Vector3Project(byval v1 as Vector3, byval v2 as Vector3) as Vector3
    var result = Vector3Zero

    var v1dv2 = (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z)
    var v2dv2 = (v2.x*v2.x + v2.y*v2.y + v2.z*v2.z)

    var mag = v1dv2/v2dv2

    result.x = v2.x*mag
    result.y = v2.y*mag
    result.z = v2.z*mag

    return result
end function

sub Vector3OrthoNormalize(byval v1 as Vector3 ptr, byval v2 as Vector3 ptr)
    var length = 0.0f
    var ilength = 0.0f

    var v = *v1
    length = sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
    if (length = 0.0f) then
        length = 1.0f
    end if
    ilength = 1.0f/length
    v1->x *= ilength
    v1->y *= ilength
    v1->z *= ilength

    var vn1 = type<Vector3>( v1->y*v2->z - v1->z*v2->y, v1->z*v2->x - v1->x*v2->z, v1->x*v2->y - v1->y*v2->x )

    v = vn1
    length = sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
    if (length = 0.0f) then
        length = 1.0f
    end if
    ilength = 1.0f/length
    vn1.x *= ilength
    vn1.y *= ilength
    vn1.z *= ilength

    var vn2 = type<Vector3>( vn1.y*v1->z - vn1.z*v1->y, vn1.z*v1->x - vn1.x*v1->z, vn1.x*v1->y - vn1.y*v1->x )

    *v2 = vn2
end sub

function Vector3Transform(byval v as Vector3, byval mat as Matrix) as Vector3
    var result = Vector3Zero

    var x = v.x
    var y = v.y
    var z = v.z

    result.x = mat.m0*x + mat.m4*y + mat.m8*z + mat.m12
    result.y = mat.m1*x + mat.m5*y + mat.m9*z + mat.m13
    result.z = mat.m2*x + mat.m6*y + mat.m10*z + mat.m14

    return result
end function

function Vector3RotateByQuaternion(byval v as Vector3, byval q as Quaternion) as Vector3
    var result = Vector3Zero

    result.x = v.x*(q.x*q.x + q.w*q.w - q.y*q.y - q.z*q.z) + v.y*(2*q.x*q.y - 2*q.w*q.z) + v.z*(2*q.x*q.z + 2*q.w*q.y)
    result.y = v.x*(2*q.w*q.z + 2*q.x*q.y) + v.y*(q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z) + v.z*(-2*q.w*q.x + 2*q.y*q.z)
    result.z = v.x*(-2*q.w*q.y + 2*q.x*q.z) + v.y*(2*q.w*q.x + 2*q.y*q.z)+ v.z*(q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z)

    return result
end function

function Vector3RotateByAxisAngle(byval v as Vector3, byval axis as Vector3, byval angle as single) as Vector3
    ' Using Euler-Rodrigues Formula
    ' Ref.: https://en.wikipedia.org/w/index.php?title=Euler%E2%80%93Rodrigues_formula

    var result = v
    
    var length = sqrtf(axis.x*axis.x + axis.y*axis.y + axis.z*axis.z)
    if (length = 0.0f) then
        length = 1.0f
    end if
    var ilength = 1.0f/length
    axis.x *= ilength
    axis.y *= ilength
    axis.z *= ilength

    angle /= 2.0f
    var a = sinf(angle)
    var b = axis.x*a
    var c = axis.y*a
    var d = axis.z*a
    a = cosf(angle)
    var w = type<Vector3>( b, c, d )

    var wv = type<Vector3>( w.y*v.z - w.z*v.y, w.z*v.x - w.x*v.z, w.x*v.y - w.y*v.x )

    var wwv = type<Vector3>( w.y*wv.z - w.z*wv.y, w.z*wv.x - w.x*wv.z, w.x*wv.y - w.y*wv.x )

    a *= 2
    wv.x *= a
    wv.y *= a
    wv.z *= a

    wwv.x *= 2
    wwv.y *= 2
    wwv.z *= 2

    result.x += wv.x
    result.y += wv.y
    result.z += wv.z

    result.x += wwv.x
    result.y += wwv.y
    result.z += wwv.z

    return result
end function

function Vector3MoveTowards(byval v as Vector3, byval target as Vector3, byval maxDistance as single) as Vector3
    var result = Vector3Zero

    var dx = target.x - v.x
    var dy = target.y - v.y
    var dz = target.z - v.z
    var value = (dx*dx) + (dy*dy) + (dz*dz)

    if ((value = 0) OR ((maxDistance >= 0) AND (value <= maxDistance*maxDistance))) then
        return target
    end if

    var dist = sqrtf(value)

    result.x = v.x + dx/dist*maxDistance
    result.y = v.y + dy/dist*maxDistance
    result.z = v.z + dz/dist*maxDistance

    return result
end function

function Vector3Lerp(byval v1 as Vector3, byval v2 as Vector3, byval amount as single) as Vector3
    var result = Vector3Zero

    result.x = v1.x + amount*(v2.x - v1.x)
    result.y = v1.y + amount*(v2.y - v1.y)
    result.z = v1.z + amount*(v2.z - v1.z)

    return result
end function

' Calculate cubic hermite interpolation between two vectors and their tangents
' as described in the GLTF 2.0 specification: https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#interpolation-cubic
function Vector3CubicHermite(byval v1 as Vector3, byval tangent1 as Vector3, byval v2 as Vector3, byval tangent2 as Vector3, byval amount as single) as Vector3
    var result = Vector3Zero

    var amountPow2 = amount*amount
    var amountPow3 = amount*amount*amount

    result.x = (2*amountPow3 - 3*amountPow2 + 1)*v1.x + (amountPow3 - 2*amountPow2 + amount)*tangent1.x + (-2*amountPow3 + 3*amountPow2)*v2.x + (amountPow3 - amountPow2)*tangent2.x
    result.y = (2*amountPow3 - 3*amountPow2 + 1)*v1.y + (amountPow3 - 2*amountPow2 + amount)*tangent1.y + (-2*amountPow3 + 3*amountPow2)*v2.y + (amountPow3 - amountPow2)*tangent2.y
    result.z = (2*amountPow3 - 3*amountPow2 + 1)*v1.z + (amountPow3 - 2*amountPow2 + amount)*tangent1.z + (-2*amountPow3 + 3*amountPow2)*v2.z + (amountPow3 - amountPow2)*tangent2.z

    return result
end function

function Vector3Reflect(byval v as Vector3, byval normal as Vector3) as Vector3
    var result = Vector3Zero

    ' I is the original vector
    ' N is the normal of the incident plane
    ' R = I - (2*N*(DotProduct[I, N]))

    var dotProduct = (v.x*normal.x + v.y*normal.y + v.z*normal.z)

    result.x = v.x - (2.0f*normal.x)*dotProduct
    result.y = v.y - (2.0f*normal.y)*dotProduct
    result.z = v.z - (2.0f*normal.z)*dotProduct

    return result
end function

function Vector3Min(byval v1 as Vector3, byval v2 as Vector3) as Vector3
    var result = Vector3Zero

    result.x = fminf(v1.x, v2.x)
    result.y = fminf(v1.y, v2.y)
    result.z = fminf(v1.z, v2.z)

    return result
end function

function Vector3Max(byval v1 as Vector3, byval v2 as Vector3) as Vector3
    var result = Vector3Zero

    result.x = fmaxf(v1.x, v2.x)
    result.y = fmaxf(v1.y, v2.y)
    result.z = fmaxf(v1.z, v2.z)

    return result
end function

function Vector3Barycenter(byval p as Vector3, byval a as Vector3, byval b as Vector3, byval c as Vector3) as Vector3
    var result = Vector3Zero

    var v0 = type<Vector3>( b.x - a.x, b.y - a.y, b.z - a.z )
    var v1 = type<Vector3>( c.x - a.x, c.y - a.y, c.z - a.z )
    var v2 = type<Vector3>( p.x - a.x, p.y - a.y, p.z - a.z )
    var d00 = (v0.x*v0.x + v0.y*v0.y + v0.z*v0.z)    
    var d01 = (v0.x*v1.x + v0.y*v1.y + v0.z*v1.z)    
    var d11 = (v1.x*v1.x + v1.y*v1.y + v1.z*v1.z)    
    var d20 = (v2.x*v0.x + v2.y*v0.y + v2.z*v0.z)    
    var d21 = (v2.x*v1.x + v2.y*v1.y + v2.z*v1.z)    

    var denom = d00*d11 - d01*d01

    result.y = (d11*d20 - d01*d21)/denom
    result.z = (d00*d21 - d01*d20)/denom
    result.x = 1.0f - (result.z + result.y)

    return result
end function

function Vector3Unproject(byval source as Vector3, byval projection as Matrix, byval view_ as Matrix) as Vector3
    var result = Vector3Zero

    ' Calculate unprojected matrix (multiply view matrix by projection matrix) and invert it
    var matViewProj = type<Matrix>( _
        view_.m0*projection.m0 + view_.m1*projection.m4 + view_.m2*projection.m8 + view_.m3*projection.m12, _
        view_.m0*projection.m1 + view_.m1*projection.m5 + view_.m2*projection.m9 + view_.m3*projection.m13, _
        view_.m0*projection.m2 + view_.m1*projection.m6 + view_.m2*projection.m10 + view_.m3*projection.m14, _
        view_.m0*projection.m3 + view_.m1*projection.m7 + view_.m2*projection.m11 + view_.m3*projection.m15, _
        view_.m4*projection.m0 + view_.m5*projection.m4 + view_.m6*projection.m8 + view_.m7*projection.m12, _
        view_.m4*projection.m1 + view_.m5*projection.m5 + view_.m6*projection.m9 + view_.m7*projection.m13, _
        view_.m4*projection.m2 + view_.m5*projection.m6 + view_.m6*projection.m10 + view_.m7*projection.m14, _
        view_.m4*projection.m3 + view_.m5*projection.m7 + view_.m6*projection.m11 + view_.m7*projection.m15, _
        view_.m8*projection.m0 + view_.m9*projection.m4 + view_.m10*projection.m8 + view_.m11*projection.m12, _
        view_.m8*projection.m1 + view_.m9*projection.m5 + view_.m10*projection.m9 + view_.m11*projection.m13, _
        view_.m8*projection.m2 + view_.m9*projection.m6 + view_.m10*projection.m10 + view_.m11*projection.m14, _
        view_.m8*projection.m3 + view_.m9*projection.m7 + view_.m10*projection.m11 + view_.m11*projection.m15, _
        view_.m12*projection.m0 + view_.m13*projection.m4 + view_.m14*projection.m8 + view_.m15*projection.m12, _
        view_.m12*projection.m1 + view_.m13*projection.m5 + view_.m14*projection.m9 + view_.m15*projection.m13, _
        view_.m12*projection.m2 + view_.m13*projection.m6 + view_.m14*projection.m10 + view_.m15*projection.m14, _
        view_.m12*projection.m3 + view_.m13*projection.m7 + view_.m14*projection.m11 + view_.m15*projection.m15 )

    ' Calculate inverted matrix -> MatrixInvert(matViewProj);
    ' Cache the matrix values (speed optimization)
    var a00 = matViewProj.m0, a01 = matViewProj.m1, a02 = matViewProj.m2, a03 = matViewProj.m3
    var a10 = matViewProj.m4, a11 = matViewProj.m5, a12 = matViewProj.m6, a13 = matViewProj.m7
    var a20 = matViewProj.m8, a21 = matViewProj.m9, a22 = matViewProj.m10, a23 = matViewProj.m11
    var a30 = matViewProj.m12, a31 = matViewProj.m13, a32 = matViewProj.m14, a33 = matViewProj.m15

    var b00 = a00*a11 - a01*a10
    var b01 = a00*a12 - a02*a10
    var b02 = a00*a13 - a03*a10
    var b03 = a01*a12 - a02*a11
    var b04 = a01*a13 - a03*a11
    var b05 = a02*a13 - a03*a12
    var b06 = a20*a31 - a21*a30
    var b07 = a20*a32 - a22*a30
    var b08 = a20*a33 - a23*a30
    var b09 = a21*a32 - a22*a31
    var b10 = a21*a33 - a23*a31
    var b11 = a22*a33 - a23*a32

    ' Calculate the invert determinant (inlined to avoid double-caching)
    var invDet = 1.0f/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06)

    var matViewProjInv = type<Matrix>( _
        (a11*b11 - a12*b10 + a13*b09)*invDet, _
        (-a01*b11 + a02*b10 - a03*b09)*invDet, _
        (a31*b05 - a32*b04 + a33*b03)*invDet, _
        (-a21*b05 + a22*b04 - a23*b03)*invDet, _
        (-a10*b11 + a12*b08 - a13*b07)*invDet, _
        (a00*b11 - a02*b08 + a03*b07)*invDet, _
        (-a30*b05 + a32*b02 - a33*b01)*invDet, _
        (a20*b05 - a22*b02 + a23*b01)*invDet, _
        (a10*b10 - a11*b08 + a13*b06)*invDet, _
        (-a00*b10 + a01*b08 - a03*b06)*invDet, _
        (a30*b04 - a31*b02 + a33*b00)*invDet, _
        (-a20*b04 + a21*b02 - a23*b00)*invDet, _
        (-a10*b09 + a11*b07 - a12*b06)*invDet, _
        (a00*b09 - a01*b07 + a02*b06)*invDet, _
        (-a30*b03 + a31*b01 - a32*b00)*invDet, _
        (a20*b03 - a21*b01 + a22*b00)*invDet )

    ' Create quaternion from source point
    var quat = type<Quaternion>( source.x, source.y, source.z, 1.0f )

    ' Multiply quat point by unprojecte matrix
    var qtransformed = type<Quaternion>( _
        matViewProjInv.m0*quat.x + matViewProjInv.m4*quat.y + matViewProjInv.m8*quat.z + matViewProjInv.m12*quat.w, _
        matViewProjInv.m1*quat.x + matViewProjInv.m5*quat.y + matViewProjInv.m9*quat.z + matViewProjInv.m13*quat.w, _
        matViewProjInv.m2*quat.x + matViewProjInv.m6*quat.y + matViewProjInv.m10*quat.z + matViewProjInv.m14*quat.w, _
        matViewProjInv.m3*quat.x + matViewProjInv.m7*quat.y + matViewProjInv.m11*quat.z + matViewProjInv.m15*quat.w )

    ' Normalized world points in vectors
    result.x = qtransformed.x/qtransformed.w
    result.y = qtransformed.y/qtransformed.w
    result.z = qtransformed.z/qtransformed.w

    return result
end function

function Vector3ToFloatV(byval v as Vector3) as float3
    dim as float3 buffer
    
    buffer.v(0) = v.x
    buffer.v(1) = v.y
    buffer.v(2) = v.z

    return buffer
end function

function Vector3Invert(byval v as Vector3) as Vector3
    return type<Vector3>(-v.x, -v.y, -v.z)
end function

function Vector3Clamp(byval v as Vector3, byval min_ as Vector3, byval max_ as Vector3) as Vector3
    var result = Vector3Zero

    result.x = fminf(max_.x, fmaxf(min_.x, v.x))
    result.y = fminf(max_.y, fmaxf(min_.y, v.y))
    result.z = fminf(max_.z, fmaxf(min_.z, v.z))

    return result
end function

function Vector3ClampValue(byval v as Vector3, byval min_ as single, byval max_ as single) as Vector3
    var result = v

    var length = (v.x*v.x) + (v.y*v.y) + (v.z*v.z)
    if (length > 0.0f) then

        length = sqrtf(length)

        var scale = 1f    ' By default, 1 as the neutral element.
        if (length < min_) then
            scale = min_/length

        elseif (length > max_) then
            scale = max_/length

        end if

        result.x = v.x*scale
        result.y = v.y*scale
        result.z = v.z*scale
    end if

    return result
end function

function Vector3Equals(byval p as Vector3, byval q as Vector3) as boolean
    return ((fabsf(p.x - q.x)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.x), fabsf(q.x))))) AND _
            ((fabsf(p.y - q.y)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.y), fabsf(q.y))))) AND _
            ((fabsf(p.z - q.z)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.z), fabsf(q.z)))))
end function

function Vector3Refract(byval v as Vector3, byval n as Vector3, byval r as single) as Vector3
    var result = Vector3Zero

    var dot = v.x*n.x + v.y*n.y + v.z*n.z
    var d = 1.0f - r*r*(1.0f - dot*dot)

    if (d >= 0.0f) then
        d = sqrtf(d)
        v.x = r*v.x - (r*dot + d)*n.x
        v.y = r*v.y - (r*dot + d)*n.y
        v.z = r*v.z - (r*dot + d)*n.z

        result = v
    end if

    return result
end function

'----------------------------------------------------------------------------------
' Module Functions Definition - Vector4 math
'----------------------------------------------------------------------------------

function Vector4Add(byval v1 as Vector4, byval v2 as Vector4) as Vector4
    return type<Vector4>(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w)
end function

function Vector4AddValue(byval v as Vector4, byval value as single) as Vector4
    return type<Vector4>(v.x + value, v.y + value, v.z + value, v.w + value)
end function

function Vector4Subtract(byval v1 as Vector4, byval v2 as Vector4) as Vector4
    return type<Vector4>(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w)
end function

function Vector4SubtractValue(byval v as Vector4, byval value as single) as Vector4
    return type<Vector4>(v.x - value, v.y - value, v.z - value, v.w - value)
end function

function Vector4Length(byval v as Vector4) as single
    return sqrtf((v.x*v.x) + (v.y*v.y) + (v.z*v.z) + (v.w*v.w))
end function

function Vector4LengthSqr(byval v as Vector4) as single
    return (v.x*v.x) + (v.y*v.y) + (v.z*v.z) + (v.w*v.w)
end function

function Vector4DotProduct(byval v1 as Vector4, byval v2 as Vector4) as single
    return (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z + v1.w*v2.w)
end function

function Vector4Distance(byval v1 as Vector4, byval v2 as Vector4) as single
    return sqrtf( _
        (v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + _
        (v1.z - v2.z)*(v1.z - v2.z) + (v1.w - v2.w)*(v1.w - v2.w))
end function

function Vector4DistanceSqr(byval v1 as Vector4, byval v2 as Vector4) as single
    return (v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + _
            (v1.z - v2.z)*(v1.z - v2.z) + (v1.w - v2.w)*(v1.w - v2.w)
end function

function Vector4Scale(byval v as Vector4, byval scale as single) as Vector4
    return type<Vector4>(v.x*scale, v.y*scale, v.z*scale, v.w*scale)
end function

function Vector4Multiply(byval v1 as Vector4, byval v2 as Vector4) as Vector4
    return type<Vector4>(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z, v1.w*v2.w)
end function

function Vector4Negate(byval v as Vector4) as Vector4
    return type<Vector4>(-v.x, -v.y, -v.z, -v.w)
end function

function Vector4Divide(byval v1 as Vector4, byval v2 as Vector4) as Vector4
    return type<Vector4>(v1.x/v2.x, v1.y/v2.y, v1.z/v2.z, v1.w/v2.w)
end function

function Vector4Normalize(byval v as Vector4) as Vector4
    var result = Vector4Zero

    var length = sqrtf((v.x*v.x) + (v.y*v.y) + (v.z*v.z) + (v.w*v.w))

    if (length > 0) then
        var ilength = 1.0f/length
        result.x = v.x*ilength
        result.y = v.y*ilength
        result.z = v.z*ilength
        result.w = v.w*ilength
    end if

    return result
end function

function Vector4Min(byval v1 as Vector4, byval v2 as Vector4) as Vector4
    var result = Vector4Zero

    result.x = fminf(v1.x, v2.x)
    result.y = fminf(v1.y, v2.y)
    result.z = fminf(v1.z, v2.z)
    result.w = fminf(v1.w, v2.w)

    return result
end function

function Vector4Max(byval v1 as Vector4, byval v2 as Vector4) as Vector4
    var result = Vector4Zero

    result.x = fmaxf(v1.x, v2.x)
    result.y = fmaxf(v1.y, v2.y)
    result.z = fmaxf(v1.z, v2.z)
    result.w = fmaxf(v1.w, v2.w)

    return result
end function

function Vector4Lerp(byval v1 as Vector4, byval v2 as Vector4, byval amount as single) as Vector4
    var result = Vector4Zero

    result.x = v1.x + amount*(v2.x - v1.x)
    result.y = v1.y + amount*(v2.y - v1.y)
    result.z = v1.z + amount*(v2.z - v1.z)
    result.w = v1.w + amount*(v2.w - v1.w)

    return result
end function

function Vector4MoveTowards(byval v as Vector4, byval target as Vector4, byval maxDistance as single) as Vector4
    var result = Vector4Zero

    var dx = target.x - v.x
    var dy = target.y - v.y
    var dz = target.z - v.z
    var dw = target.w - v.w
    var value = (dx*dx) + (dy*dy) + (dz*dz) + (dw*dw)

    if ((value = 0) OR ((maxDistance >= 0) AND (value <= maxDistance*maxDistance))) then
        return target
    end if

    var dist = sqrtf(value)

    result.x = v.x + dx/dist*maxDistance
    result.y = v.y + dy/dist*maxDistance
    result.z = v.z + dz/dist*maxDistance
    result.w = v.w + dw/dist*maxDistance

    return result
end function

function Vector4Invert(byval v as Vector4) as Vector4
    return type<Vector4>(1.0f/v.x, 1.0f/v.y, 1.0f/v.z, 1.0f/v.w)
end function

function Vector4Equals(byval p as Vector4, byval q as Vector4) as boolean
    return ((fabsf(p.x - q.x)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.x), fabsf(q.x))))) AND _
            ((fabsf(p.y - q.y)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.y), fabsf(q.y))))) AND _
            ((fabsf(p.z - q.z)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.z), fabsf(q.z))))) AND _
            ((fabsf(p.w - q.w)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.w), fabsf(q.w)))))
end function

'----------------------------------------------------------------------------------
' Module Functions Definition - Matrix math
'----------------------------------------------------------------------------------

function MatrixDeterminate(byval mat as Matrix) as single
    var result = 0.0f

    ' Cache the matrix values (speed optimization)
    var a00 = mat.m0, a01 = mat.m1, a02 = mat.m2, a03 = mat.m3
    var a10 = mat.m4, a11 = mat.m5, a12 = mat.m6, a13 = mat.m7
    var a20 = mat.m8, a21 = mat.m9, a22 = mat.m10, a23 = mat.m11
    var a30 = mat.m12, a31 = mat.m13, a32 = mat.m14, a33 = mat.m15

    result = a30*a21*a12*a03 - a20*a31*a12*a03 - a30*a11*a22*a03 + a10*a31*a22*a03 + _
             a20*a11*a32*a03 - a10*a21*a32*a03 - a30*a21*a02*a13 + a20*a31*a02*a13 + _
             a30*a01*a22*a13 - a00*a31*a22*a13 - a20*a01*a32*a13 + a00*a21*a32*a13 + _
             a30*a11*a02*a23 - a10*a31*a02*a23 - a30*a01*a12*a23 + a00*a31*a12*a23 + _
             a10*a01*a32*a23 - a00*a11*a32*a23 - a20*a11*a02*a33 + a10*a21*a02*a33 + _
             a20*a01*a12*a33 - a00*a21*a12*a33 - a10*a01*a22*a33 + a00*a11*a22*a33

    return result
end function

function MatrixTrace(byval mat as Matrix) as single
    return (mat.m0 + mat.m5 + mat.m10 + mat.m15)
end function

function MatrixTranspose(byval mat as Matrix) as Matrix
    var result = MatrixZero

    result.m0 = mat.m0
    result.m1 = mat.m4
    result.m2 = mat.m8
    result.m3 = mat.m12
    result.m4 = mat.m1
    result.m5 = mat.m5
    result.m6 = mat.m9
    result.m7 = mat.m13
    result.m8 = mat.m2
    result.m9 = mat.m6
    result.m10 = mat.m10
    result.m11 = mat.m14
    result.m12 = mat.m3
    result.m13 = mat.m7
    result.m14 = mat.m11
    result.m15 = mat.m15

    return result
end function

function MatrixInvert(byval mat as Matrix) as Matrix
    var result = MatrixZero

    ' Cache the matrix values (speed optimization)
    var a00 = mat.m0, a01 = mat.m1, a02 = mat.m2, a03 = mat.m3
    var a10 = mat.m4, a11 = mat.m5, a12 = mat.m6, a13 = mat.m7
    var a20 = mat.m8, a21 = mat.m9, a22 = mat.m10, a23 = mat.m11
    var a30 = mat.m12, a31 = mat.m13, a32 = mat.m14, a33 = mat.m15

    var b00 = a00*a11 - a01*a10
    var b01 = a00*a12 - a02*a10
    var b02 = a00*a13 - a03*a10
    var b03 = a01*a12 - a02*a11
    var b04 = a01*a13 - a03*a11
    var b05 = a02*a13 - a03*a12
    var b06 = a20*a31 - a21*a30
    var b07 = a20*a32 - a22*a30
    var b08 = a20*a33 - a23*a30
    var b09 = a21*a32 - a22*a31
    var b10 = a21*a33 - a23*a31
    var b11 = a22*a33 - a23*a32

    ' Calculate the invert determinant (inlined to avoid double-caching)
    var invDet = 1.0f/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06)

    result.m0 = (a11*b11 - a12*b10 + a13*b09)*invDet
    result.m1 = (-a01*b11 + a02*b10 - a03*b09)*invDet
    result.m2 = (a31*b05 - a32*b04 + a33*b03)*invDet
    result.m3 = (-a21*b05 + a22*b04 - a23*b03)*invDet
    result.m4 = (-a10*b11 + a12*b08 - a13*b07)*invDet
    result.m5 = (a00*b11 - a02*b08 + a03*b07)*invDet
    result.m6 = (-a30*b05 + a32*b02 - a33*b01)*invDet
    result.m7 = (a20*b05 - a22*b02 + a23*b01)*invDet
    result.m8 = (a10*b10 - a11*b08 + a13*b06)*invDet
    result.m9 = (-a00*b10 + a01*b08 - a03*b06)*invDet
    result.m10 = (a30*b04 - a31*b02 + a33*b00)*invDet
    result.m11 = (-a20*b04 + a21*b02 - a23*b00)*invDet
    result.m12 = (-a10*b09 + a11*b07 - a12*b06)*invDet
    result.m13 = (a00*b09 - a01*b07 + a02*b06)*invDet
    result.m14 = (-a30*b03 + a31*b01 - a32*b00)*invDet
    result.m15 = (a20*b03 - a21*b01 + a22*b00)*invDet

    return result
end function

function MatrixAdd(byval left_ as Matrix, byval right_ as Matrix) as Matrix
    var result = MatrixZero

    result.m0 = left_.m0 + right_.m0
    result.m1 = left_.m1 + right_.m1
    result.m2 = left_.m2 + right_.m2
    result.m3 = left_.m3 + right_.m3
    result.m4 = left_.m4 + right_.m4
    result.m5 = left_.m5 + right_.m5
    result.m6 = left_.m6 + right_.m6
    result.m7 = left_.m7 + right_.m7
    result.m8 = left_.m8 + right_.m8
    result.m9 = left_.m9 + right_.m9
    result.m10 = left_.m10 + right_.m10
    result.m11 = left_.m11 + right_.m11
    result.m12 = left_.m12 + right_.m12
    result.m13 = left_.m13 + right_.m13
    result.m14 = left_.m14 + right_.m14
    result.m15 = left_.m15 + right_.m15

    return result
end function

function MatrixSubtract(byval left_ as Matrix, byval right_ as Matrix) as Matrix
    var result = MatrixZero

    result.m0 = left_.m0 - right_.m0
    result.m1 = left_.m1 - right_.m1
    result.m2 = left_.m2 - right_.m2
    result.m3 = left_.m3 - right_.m3
    result.m4 = left_.m4 - right_.m4
    result.m5 = left_.m5 - right_.m5
    result.m6 = left_.m6 - right_.m6
    result.m7 = left_.m7 - right_.m7
    result.m8 = left_.m8 - right_.m8
    result.m9 = left_.m9 - right_.m9
    result.m10 = left_.m10 - right_.m10
    result.m11 = left_.m11 - right_.m11
    result.m12 = left_.m12 - right_.m12
    result.m13 = left_.m13 - right_.m13
    result.m14 = left_.m14 - right_.m14
    result.m15 = left_.m15 - right_.m15

    return result
end function

function MatrixMultiply(byval left_ as Matrix, byval right_ as Matrix) as Matrix
    var result = MatrixZero

    result.m0 = left_.m0*right_.m0 + left_.m1*right_.m4 + left_.m2*right_.m8 + left_.m3*right_.m12
    result.m1 = left_.m0*right_.m1 + left_.m1*right_.m5 + left_.m2*right_.m9 + left_.m3*right_.m13
    result.m2 = left_.m0*right_.m2 + left_.m1*right_.m6 + left_.m2*right_.m10 + left_.m3*right_.m14
    result.m3 = left_.m0*right_.m3 + left_.m1*right_.m7 + left_.m2*right_.m11 + left_.m3*right_.m15
    result.m4 = left_.m4*right_.m0 + left_.m5*right_.m4 + left_.m6*right_.m8 + left_.m7*right_.m12
    result.m5 = left_.m4*right_.m1 + left_.m5*right_.m5 + left_.m6*right_.m9 + left_.m7*right_.m13
    result.m6 = left_.m4*right_.m2 + left_.m5*right_.m6 + left_.m6*right_.m10 + left_.m7*right_.m14
    result.m7 = left_.m4*right_.m3 + left_.m5*right_.m7 + left_.m6*right_.m11 + left_.m7*right_.m15
    result.m8 = left_.m8*right_.m0 + left_.m9*right_.m4 + left_.m10*right_.m8 + left_.m11*right_.m12
    result.m9 = left_.m8*right_.m1 + left_.m9*right_.m5 + left_.m10*right_.m9 + left_.m11*right_.m13
    result.m10 = left_.m8*right_.m2 + left_.m9*right_.m6 + left_.m10*right_.m10 + left_.m11*right_.m14
    result.m11 = left_.m8*right_.m3 + left_.m9*right_.m7 + left_.m10*right_.m11 + left_.m11*right_.m15
    result.m12 = left_.m12*right_.m0 + left_.m13*right_.m4 + left_.m14*right_.m8 + left_.m15*right_.m12
    result.m13 = left_.m12*right_.m1 + left_.m13*right_.m5 + left_.m14*right_.m9 + left_.m15*right_.m13
    result.m14 = left_.m12*right_.m2 + left_.m13*right_.m6 + left_.m14*right_.m10 + left_.m15*right_.m14
    result.m15 = left_.m12*right_.m3 + left_.m13*right_.m7 + left_.m14*right_.m11 + left_.m15*right_.m15

    return result
end function

function MatrixTranslate(byval x as single, byval y as single, byval z as single) as Matrix
    return type<Matrix>( 1.0f, 0.0f, 0.0f, x, _
                        0.0f, 1.0f, 0.0f, y, _
                        0.0f, 0.0f, 1.0f, z, _
                        0.0f, 0.0f, 0.0f, 1.0f )
end function

function MatrixRotate(byval axis as Vector3, byval angle as single) as Matrix
    var result = MatrixZero

    dim as single x = axis.x, y = axis.y, z = axis.z

    dim as single lengthSquared = x*x + y*y + z*z

    if ((lengthSquared <> 1.0f) AND (lengthSquared <> 0.0f)) then
        dim as single ilength = 1.0f/sqrtf(lengthSquared)
        x *= ilength
        y *= ilength
        z *= ilength
    end if

    var sinres = sinf(angle)
    var cosres = cosf(angle)
    var t = 1.0f - cosres

    result.m0 = x*x*t + cosres
    result.m1 = y*x*t + z*sinres
    result.m2 = z*x*t - y*sinres
    result.m3 = 0.0f

    result.m4 = x*y*t - z*sinres
    result.m5 = y*y*t + cosres
    result.m6 = z*y*t + x*sinres
    result.m7 = 0.0f

    result.m8 = x*z*t + y*sinres
    result.m9 = y*z*t - x*sinres
    result.m10 = z*z*t + cosres
    result.m11 = 0.0f

    result.m12 = 0.0f
    result.m13 = 0.0f
    result.m14 = 0.0f
    result.m15 = 1.0f

    return result
end function

function MatrixRotateX(byval angle as single) as Matrix
    var result = MatrixIdentity
    
    var cosres = cosf(angle)
    var sinres = sinf(angle)

    result.m5 = cosres
    result.m6 = sinres
    result.m9 = -sinres
    result.m10 = cosres

    return result
end function

function MatrixRotateY(byval angle as single) as Matrix
    var result = MatrixIdentity

    var cosres = cosf(angle)
    var sinres = sinf(angle)

    result.m0 = cosres
    result.m2 = -sinres
    result.m8 = sinres
    result.m10 = cosres

    return result
end function

function MatrixRotateZ(byval angle as single) as Matrix
    var result = MatrixIdentity

    var cosres = cosf(angle)
    var sinres = sinf(angle)

    result.m0 = cosres
    result.m1 = sinres
    result.m4 = -sinres
    result.m5 = cosres

    return result
end function

function MatrixRotateXYZ(byval angle as Vector3) as Matrix
    var result = MatrixIdentity

    var cosz = cosf(-angle.z)
    var sinz = sinf(-angle.z)
    var cosy = cosf(-angle.y)
    var siny = sinf(-angle.y)
    var cosx = cosf(-angle.x)
    var sinx = sinf(-angle.x)

    result.m0 = cosz*cosy
    result.m1 = (cosz*siny*sinx) - (sinz*cosx)
    result.m2 = (cosz*siny*cosx) + (sinz*sinx)

    result.m4 = sinz*cosy
    result.m5 = (sinz*siny*sinx) + (cosz*cosx)
    result.m6 = (sinz*siny*cosx) - (cosz*sinx)

    result.m8 = -siny
    result.m9 = cosy*sinx
    result.m10= cosy*cosx

    return result
end function

function MatrixRotateZYX(byval angle as Vector3) as Matrix
    var result = MatrixZero

    var cz = cosf(angle.z)
    var sz = sinf(angle.z)
    var cy = cosf(angle.y)
    var sy = sinf(angle.y)
    var cx = cosf(angle.x)
    var sx = sinf(angle.x)

    result.m0 = cz*cy
    result.m4 = cz*sy*sx - cx*sz
    result.m8 = sz*sx + cz*cx*sy
    result.m12 = 0

    result.m1 = cy*sz
    result.m5 = cz*cx + sz*sy*sx
    result.m9 = cx*sz*sy - cz*sx
    result.m13 = 0

    result.m2 = -sy
    result.m6 = cy*sx
    result.m10 = cy*cx
    result.m14 = 0

    result.m3 = 0
    result.m7 = 0
    result.m11 = 0
    result.m15 = 1

    return result
end function

function MatrixScale(byval x as single, byval y as single, byval z as single) as Matrix
    return type<Matrix>( x, 0.0f, 0.0f, 0.0f, _
                      0.0f, y, 0.0f, 0.0f, _
                      0.0f, 0.0f, z, 0.0f, _
                      0.0f, 0.0f, 0.0f, 1.0f )
end function

function MatrixFrustum(byval left_ as double, byval right_ as double, byval bottom as double, byval top as double, byval nearPlane as double, byval farPlane as double) as Matrix
    var result = MatrixZero

    var rl = csng(right_ - left_)
    var tb = csng(top - bottom)
    var fn = csng(farPlane - nearPlane)

    result.m0 = (csng(nearPlane)*2.0f)/rl
    result.m1 = 0.0f
    result.m2 = 0.0f
    result.m3 = 0.0f

    result.m4 = 0.0f
    result.m5 = (csng(nearPlane)*2.0f)/tb
    result.m6 = 0.0f
    result.m7 = 0.0f

    result.m8 = (csng(right_) + csng(left_))/rl
    result.m9 = (csng(top) + csng(bottom))/tb
    result.m10 = -(csng(farPlane) + csng(nearPlane))/fn
    result.m11 = -1.0f

    result.m12 = 0.0f
    result.m13 = 0.0f
    result.m14 = -(csng(farPlane)*csng(nearPlane)*2.0f)/fn
    result.m15 = 0.0f

    return result
end function

function MatrixPerspective(byval fovY as double, byval aspect as double, byval nearPlane as double, byval farPlane as double) as Matrix
    var result = MatrixZero

    var top = nearPlane*tan(fovY*0.5)
    var bottom = -top
    var right_ = top*aspect
    var left_ = -right_

    var rl = csng(right_ - left_)
    var tb = csng(top - bottom)
    var fn = csng(farPlane - nearPlane)

    result.m0 = (csng(nearPlane)*2.0f)/rl
    result.m5 = (csng(nearPlane)*2.0f)/tb
    result.m8 = (csng(right_) + csng(left_))/rl
    result.m9 = (csng(top) + csng(bottom))/tb
    result.m10 = -(csng(farPlane) + csng(nearPlane))/fn
    result.m11 = -1.0f
    result.m14 = -(csng(farPlane)*csng(nearPlane)*2.0f)/fn

    return result
end function

function MatrixOrtho(byval left_ as double, byval right_ as double, byval bottom as double, byval top as double, byval nearPlane as double, byval farPlane as double) as Matrix
    var result = MatrixZero

    var rl = csng(right_ - left_)
    var tb = csng(top - bottom)
    var fn = csng(farPlane - nearPlane)

    result.m0 = 2.0f/rl
    result.m1 = 0.0f
    result.m2 = 0.0f
    result.m3 = 0.0f
    result.m4 = 0.0f
    result.m5 = 2.0f/tb
    result.m6 = 0.0f
    result.m7 = 0.0f
    result.m8 = 0.0f
    result.m9 = 0.0f
    result.m10 = -2.0f/fn
    result.m11 = 0.0f
    result.m12 = -(csng(left_) + csng(right_))/rl
    result.m13 = -(csng(top) + csng(bottom))/tb
    result.m14 = -(csng(farPlane) + csng(nearPlane))/fn
    result.m15 = 1.0f

    return result
end function

function MatrixLookAt(byval eye as Vector3, byval target as Vector3, byval up as Vector3) as Matrix
    var result = MatrixZero

    var length = 0.0f
    var ilength = 0.0f

    var vz = type<Vector3>( eye.x - target.x, eye.y - target.y, eye.z - target.z )

    var v = vz
    length = sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
    if (length = 0.0f) then
        length = 1.0f
    end if
    ilength = 1.0f/length
    vz.x *= ilength
    vz.y *= ilength
    vz.z *= ilength

    var vx = type<Vector3>( up.y*vz.z - up.z*vz.y, up.z*vz.x - up.x*vz.z, up.x*vz.y - up.y*vz.x )

    v = vx
    length = sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
    if (length = 0.0f) then
        length = 1.0f
    end if
    ilength = 1.0f/length
    vx.x *= ilength
    vx.y *= ilength
    vx.z *= ilength

    var vy = type<Vector3>( vz.y*vx.z - vz.z*vx.y, vz.z*vx.x - vz.x*vx.z, vz.x*vx.y - vz.y*vx.x )

    result.m0 = vx.x
    result.m1 = vy.x
    result.m2 = vz.x
    result.m3 = 0.0f
    result.m4 = vx.y
    result.m5 = vy.y
    result.m6 = vz.y
    result.m7 = 0.0f
    result.m8 = vx.z
    result.m9 = vy.z
    result.m10 = vz.z
    result.m11 = 0.0f
    result.m12 = -(vx.x*eye.x + vx.y*eye.y + vx.z*eye.z)
    result.m13 = -(vy.x*eye.x + vy.y*eye.y + vy.z*eye.z)
    result.m14 = -(vz.x*eye.x + vz.y*eye.y + vz.z*eye.z)
    result.m15 = 1.0f

    return result
end function

function MatrixToFloatV(byval mat as Matrix) as float16
    dim as float16 result

    result.v(0) = mat.m0
    result.v(1) = mat.m1
    result.v(2) = mat.m2
    result.v(3) = mat.m3
    result.v(4) = mat.m4
    result.v(5) = mat.m5
    result.v(6) = mat.m6
    result.v(7) = mat.m7
    result.v(8) = mat.m8
    result.v(9) = mat.m9
    result.v(10) = mat.m10
    result.v(11) = mat.m11
    result.v(12) = mat.m12
    result.v(13) = mat.m13
    result.v(14) = mat.m14
    result.v(15) = mat.m15

    return result
end function

'----------------------------------------------------------------------------------
' Module Functions Definition - Quaternion math
'----------------------------------------------------------------------------------

function QuaternionAdd(byval q1 as Quaternion, byval q2 as Quaternion) as Quaternion   
    return type<Quaternion>(q1.x + q2.x, q1.y + q2.y, q1.z + q2.z, q1.w + q2.w)
end function

function QuaternionAddValue(byval q as Quaternion, byval value as single) as Quaternion
    return type<Quaternion>(q.x + value, q.y + value, q.z + value, q.w + value)
end function

function QuaternionSubtract(byval q1 as Quaternion, byval q2 as Quaternion) as Quaternion
    return type<Quaternion>(q1.x - q2.x, q1.y - q2.y, q1.z - q2.z, q1.w - q2.w)
end function

function QuaternionSubtractValue(byval q as Quaternion, byval value as single) as Quaternion
    return type<Quaternion>(q.x - value, q.y - value, q.z - value, q.w - value)
end function

function QuaternionLength(byval q as Quaternion) as single
    return sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
end function

function QuaternionNormalize(byval q as Quaternion) as Quaternion
    var result = QuaternionZero

    var length = sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
    if (length = 0.0f) then
        length = 1.0f
    end if
    var ilength = 1.0f/length

    result.x = q.x*ilength
    result.y = q.y*ilength
    result.z = q.z*ilength
    result.w = q.w*ilength

    return result
end function

function QuaternionInvert(byval q as Quaternion) as Quaternion
    var result = q
    var lengthSq = q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w

    if (lengthSq <> 0.0f) then
        var invLength = 1.0f/lengthSq

        result.x *= -invLength
        result.y *= -invLength
        result.z *= -invLength
        result.w *= invLength
    end if
    return result
end function

function QuaternionMultiply(byval q1 as Quaternion, byval q2 as Quaternion) as Quaternion
    var result = QuaternionZero

    var qax = q1.x, qay = q1.y, qaz = q1.z, qaw = q1.w
    var qbx = q2.x, qby = q2.y, qbz = q2.z, qbw = q2.w

    result.x = qax*qbw + qaw*qbx + qay*qbz - qaz*qby
    result.y = qay*qbw + qaw*qby + qaz*qbx - qax*qbz
    result.z = qaz*qbw + qaw*qbz + qax*qby - qay*qbx
    result.w = qaw*qbw - qax*qbx - qay*qby - qaz*qbz

    return result
end function

function QuaternionScale(byval q as Quaternion, byval mul as single) as Quaternion
    var result = QuaternionZero

    result.x = q.x*mul
    result.y = q.y*mul
    result.z = q.z*mul
    result.w = q.w*mul

    return result
end function

function QuaternionDivide(byval q1 as Quaternion, byval q2 as Quaternion) as Quaternion
    return type<Quaternion>(q1.x/q2.x, q1.y/q2.y, q1.z/q2.z, q1.w/q2.w)
end function

function QuaternionLerp(byval q1 as Quaternion, byval q2 as Quaternion, byval amount as single) as Quaternion
    var result = QuaternionZero

    result.x = q1.x + amount*(q2.x - q1.x)
    result.y = q1.y + amount*(q2.y - q1.y)
    result.z = q1.z + amount*(q2.z - q1.z)
    result.w = q1.w + amount*(q2.w - q1.w)

    return result
end function

function QuaternionNlerp(byval q1 as Quaternion, byval q2 as Quaternion, byval amount as single) as Quaternion
    var result = QuaternionZero

    result.x = q1.x + amount*(q2.x - q1.x)
    result.y = q1.y + amount*(q2.y - q1.y)
    result.z = q1.z + amount*(q2.z - q1.z)
    result.w = q1.w + amount*(q2.w - q1.w)

    var q = result
    var length = sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
    if (length = 0.0f) then
        length = 1.0f
    end if
    var ilength = 1.0f/length

    result.x = q.x*ilength
    result.y = q.y*ilength
    result.z = q.z*ilength
    result.w = q.w*ilength

    return result
end function

function QuaternionSlerp(byval q1 as Quaternion, byval q2 as Quaternion, byval amount as single) as Quaternion
    var result = QuaternionZero

    var cosHalfTheta = q1.x*q2.x + q1.y*q2.y + q1.z*q2.z + q1.w*q2.w

    if (cosHalfTheta < 0) then
        q2.x = -q2.x
        q2.y = -q2.y
        q2.z = -q2.z
        q2.w = -q2.w
        cosHalfTheta = -cosHalfTheta
    end if

    if (fabsf(cosHalfTheta) >= 1.0f) then
        result = q1
    elseif (cosHalfTheta > 0.95f) then
        result = QuaternionNlerp(q1, q2, amount)
    else
        var halfTheta = acosf(cosHalfTheta)
        var sinHalfTheta = sqrtf(1.0f - cosHalfTheta*cosHalfTheta)

        if (fabsf(sinHalfTheta) < EPSILON) then
            result.x = (q1.x*0.5f + q2.x*0.5f)
            result.y = (q1.y*0.5f + q2.y*0.5f)
            result.z = (q1.z*0.5f + q2.z*0.5f)
            result.w = (q1.w*0.5f + q2.w*0.5f)
        else
            var ratioA = sinf((1 - amount)*halfTheta)/sinHalfTheta
            var ratioB = sinf(amount*halfTheta)/sinHalfTheta

            result.x = (q1.x*ratioA + q2.x*ratioB)
            result.y = (q1.y*ratioA + q2.y*ratioB)
            result.z = (q1.z*ratioA + q2.z*ratioB)
            result.w = (q1.w*ratioA + q2.w*ratioB)
        end if
    end if

    return result
end function

function QuaternionCubicHermiteSpline(byval q1 as Quaternion, byval outTangent1 as Quaternion, byval q2 as Quaternion, byval inTangent2 as Quaternion, byval t as single) as Quaternion

    var t2 = t*t
    var t3 = t2*t
    var h00 = 2*t3 - 3*t2 + 1
    var h10 = t3 - 2*t2 + t
    var h01 = -2*t3 + 3*t2
    var h11 = t3 - t2

    var p0 = QuaternionScale(q1, h00)
    var m0 = QuaternionScale(outTangent1, h10)
    var p1 = QuaternionScale(q2, h01)
    var m1 = QuaternionScale(inTangent2, h11)

    var result = QuaternionZero

    result = QuaternionAdd(p0, m0)
    result = QuaternionAdd(result, p1)
    result = QuaternionAdd(result, m1)
    result = QuaternionNormalize(result)

    return result

end function

function QuaternionFromVector3ToVector3(byval from_ as Vector3, byval to_ as Vector3) as Quaternion
    var result = QuaternionZero

    var cos2Theta = (from_.x*to_.x + from_.y*to_.y + from_.z*to_.z)   
    var cross = type<Vector3>( from_.y*to_.z - from_.z*to_.y, from_.z*to_.x - from_.x*to_.z, from_.x*to_.y - from_.y*to_.x )

    result.x = cross.x
    result.y = cross.y
    result.z = cross.z
    result.w = 1.0f + cos2Theta

    ' NOTE: Normalize to essentially nlerp the original and identity to 0.5
    var q = result
    var length = sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
    if (length = 0.0f) then
        length = 1.0f
    end if
    var ilength = 1.0f/length

    result.x = q.x*ilength
    result.y = q.y*ilength
    result.z = q.z*ilength
    result.w = q.w*ilength

    return result
end function

function QuaternionFromMatrix(byval mat as Matrix) as Quaternion
    var result = QuaternionZero

    var fourWSquaredMinus1 = mat.m0  + mat.m5 + mat.m10
    var fourXSquaredMinus1 = mat.m0  - mat.m5 - mat.m10
    var fourYSquaredMinus1 = mat.m5  - mat.m0 - mat.m10
    var fourZSquaredMinus1 = mat.m10 - mat.m0 - mat.m5

    var biggestIndex = 0
    var fourBiggestSquaredMinus1 = fourWSquaredMinus1
    if (fourXSquaredMinus1 > fourBiggestSquaredMinus1) then
        fourBiggestSquaredMinus1 = fourXSquaredMinus1
        biggestIndex = 1
    end if

    if (fourYSquaredMinus1 > fourBiggestSquaredMinus1) then
        fourBiggestSquaredMinus1 = fourYSquaredMinus1
        biggestIndex = 2
    end if

    if (fourZSquaredMinus1 > fourBiggestSquaredMinus1) then
        fourBiggestSquaredMinus1 = fourZSquaredMinus1
        biggestIndex = 3
    end if

    var biggestVal = sqrtf(fourBiggestSquaredMinus1 + 1.0f)*0.5f
    var mult = 0.25f/biggestVal

    select case (biggestIndex)
        case 0
            result.w = biggestVal
            result.x = (mat.m6 - mat.m9)*mult
            result.y = (mat.m8 - mat.m2)*mult
            result.z = (mat.m1 - mat.m4)*mult
            
        case 1
            result.x = biggestVal
            result.w = (mat.m6 - mat.m9)*mult
            result.y = (mat.m1 + mat.m4)*mult
            result.z = (mat.m8 + mat.m2)*mult
            
        case 2
            result.y = biggestVal
            result.w = (mat.m8 - mat.m2)*mult
            result.x = (mat.m1 + mat.m4)*mult
            result.z = (mat.m6 + mat.m9)*mult
            
        case 3
            result.z = biggestVal
            result.w = (mat.m1 - mat.m4)*mult
            result.x = (mat.m8 + mat.m2)*mult
            result.y = (mat.m6 + mat.m9)*mult
            
    end select

    return result
end function

function QuaternionToMatrix(byval q as Quaternion) as Matrix
    var result = MatrixIdentity

    var a2 = q.x*q.x
    var b2 = q.y*q.y
    var c2 = q.z*q.z
    var ac = q.x*q.z
    var ab = q.x*q.y
    var bc = q.y*q.z
    var ad = q.w*q.x
    var bd = q.w*q.y
    var cd = q.w*q.z

    result.m0 = 1 - 2*(b2 + c2)
    result.m1 = 2*(ab + cd)
    result.m2 = 2*(ac - bd)

    result.m4 = 2*(ab - cd)
    result.m5 = 1 - 2*(a2 + c2)
    result.m6 = 2*(bc + ad)

    result.m8 = 2*(ac + bd)
    result.m9 = 2*(bc - ad)
    result.m10 = 1 - 2*(a2 + b2)

    return result
end function

function QuaternionFromAxisAngle(byval axis as Vector3, byval angle as single) as Quaternion
    var result = QuaternionIdentity

    var axisLength = sqrtf(axis.x*axis.x + axis.y*axis.y + axis.z*axis.z)

    if (axisLength <> 0.0f) then
        angle *= 0.5f

        var length = 0.0f
        var ilength = 0.0f

        length = axisLength
        if (length = 0.0f) then
            length = 1.0f
        end if
        ilength = 1.0f/length
        axis.x *= ilength
        axis.y *= ilength
        axis.z *= ilength

        var sinres = sinf(angle)
        var cosres = cosf(angle)

        result.x = axis.x*sinres
        result.y = axis.y*sinres
        result.z = axis.z*sinres
        result.w = cosres

        var q = result
        length = sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
        if (length = 0.0f) then 
            length = 1.0f
        end if
        ilength = 1.0f/length
        result.x = q.x*ilength
        result.y = q.y*ilength
        result.z = q.z*ilength
        result.w = q.w*ilength
    end if

    return result
end function

sub QuaternionToAxisAngle(byval q as Quaternion, byval outAxis as Vector3 ptr, byval outAngle as single ptr)
    if (fabsf(q.w) > 1.0f) then
    
        var length = sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
        if (length = 0.0f) then
            length = 1.0f
        end if
        var ilength = 1.0f/length

        q.x = q.x*ilength
        q.y = q.y*ilength
        q.z = q.z*ilength
        q.w = q.w*ilength
    end if

    var resAxis = Vector3Zero
    var resAngle = 2.0f*acosf(q.w)
    var den = sqrtf(1.0f - q.w*q.w)

    if (den > EPSILON) then
    
        resAxis.x = q.x/den
        resAxis.y = q.y/den
        resAxis.z = q.z/den
    
    else
    
        ' This occurs when the angle is zero.
        ' Not a problem: just set an arbitrary normalized axis.
        resAxis.x = 1.0f
    end if

    *outAxis = resAxis
    *outAngle = resAngle
end sub

function QuaternionFromEuler(byval pitch as single, byval yaw as single, byval roll as single) as Quaternion
    var result = QuaternionZero

    var x0 = cosf(pitch*0.5f)
    var x1 = sinf(pitch*0.5f)
    var y0 = cosf(yaw*0.5f)
    var y1 = sinf(yaw*0.5f)
    var z0 = cosf(roll*0.5f)
    var z1 = sinf(roll*0.5f)

    result.x = x1*y0*z0 - x0*y1*z1
    result.y = x0*y1*z0 + x1*y0*z1
    result.z = x0*y0*z1 - x1*y1*z0
    result.w = x0*y0*z0 + x1*y1*z1

    return result
end function

function QuaternionToEuler(byval q as Quaternion) as Vector3
    var result = Vector3Zero
    ' Roll (x-axis rotation)
    dim as single x0 = 2.0f*(q.w*q.x + q.y*q.z)
    dim as single x1 = 1.0f - 2.0f*(q.x*q.x + q.y*q.y)
    result.x = atan2f(x0, x1)

    ' Pitch (y-axis rotation)
    dim as single y0 = 2.0f*(q.w*q.y - q.z*q.x)
    y0 = iif(y0 > 1.0f , 1.0f , y0)
    y0 = iif(y0 < -1.0f , -1.0f , y0)
    result.y = asinf(y0)

    ' Yaw (z-axis rotation)
    dim as single z0 = 2.0f*(q.w*q.z + q.x*q.y)
    dim as single z1 = 1.0f - 2.0f*(q.y*q.y + q.z*q.z)
    result.z = atan2f(z0, z1)

    return result
end function

function QuaternionTransform(byval q as Quaternion, byval mat as Matrix) as Quaternion
    var result = QuaternionZero

    result.x = mat.m0*q.x + mat.m4*q.y + mat.m8*q.z + mat.m12*q.w
    result.y = mat.m1*q.x + mat.m5*q.y + mat.m9*q.z + mat.m13*q.w
    result.z = mat.m2*q.x + mat.m6*q.y + mat.m10*q.z + mat.m14*q.w
    result.w = mat.m3*q.x + mat.m7*q.y + mat.m11*q.z + mat.m15*q.w

    return result
end function

function QuaternionEquals(byval p as Quaternion, byval q as Quaternion) as boolean
    return (((fabsf(p.x - q.x)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.x), fabsf(q.x))))) AND _
            ((fabsf(p.y - q.y)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.y), fabsf(q.y))))) AND _
            ((fabsf(p.z - q.z)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.z), fabsf(q.z))))) AND _
            ((fabsf(p.w - q.w)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.w), fabsf(q.w)))))) OR _
            (((fabsf(p.x + q.x)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.x), fabsf(q.x))))) AND _
            ((fabsf(p.y + q.y)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.y), fabsf(q.y))))) AND _
            ((fabsf(p.z + q.z)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.z), fabsf(q.z))))) AND _
            ((fabsf(p.w + q.w)) <= (EPSILON*fmaxf(1.0f, fmaxf(fabsf(p.w), fabsf(q.w))))))
end function

sub MatrixDecompose(byval mat as Matrix, byval translation as Vector3 ptr, byval rotation as Quaternion ptr, byval scale as Vector3 ptr)
    translation->x = mat.m12
    translation->y = mat.m13
    translation->z = mat.m14

    var a = mat.m0
    var b = mat.m4
    var c = mat.m8
    var d = mat.m1
    var e = mat.m5
    var f = mat.m9
    var g = mat.m2
    var h = mat.m6
    var i = mat.m10
    var bigA = e * i - f * h
    var bigB = f * g - d * i
    var bigC = d * h - e * g

    var det = a * bigA + b * bigB + c * bigC

    var scalex = Vector3Length(type<Vector3>(a, b, c))
    var scaley = Vector3Length(type<Vector3>(d, e, f))
    var scalez = Vector3Length(type<Vector3>(g, h, i))

    var s = type<Vector3>(scalex, scaley, scalez)
    
    if (det < 0) then
        s = Vector3Negate(s)
    end if

    *scale = s

    var clone = mat
    if (not FloatEquals(det, 0)) then
        clone.m0 /= s.x
        clone.m4 /= s.x
        clone.m8 /= s.x
        clone.m1 /= s.y
        clone.m5 /= s.y
        clone.m9 /= s.y
        clone.m2 /= s.z
        clone.m6 /= s.z
        clone.m10 /= s.z

        *rotation = QuaternionFromMatrix(clone)
    else
        *rotation = QuaternionIdentity
    end if


end sub

#ifndef RAYMATH_DISABLE_FB_OPERATORS

operator + (byval lhs as const Vector2, byval rhs as const Vector2) as Vector2
    return Vector2Add(lhs, rhs)
end operator

operator + (byval lhs as const Vector2, byval rhs as const single) as Vector2
    return Vector2AddValue(lhs, rhs)
end operator

operator - (byval lhs as const Vector2, byval rhs as const Vector2) as Vector2
    return Vector2Subtract(lhs, rhs)
end operator

operator - (byval lhs as const Vector2, byval rhs as const single) as Vector2
    return Vector2SubtractValue(lhs, rhs)
end operator

operator * (byval lhs as const Vector2, byval rhs as const Vector2) as Vector2
    return Vector2Multiply(lhs, rhs)
end operator

operator * (byval lhs as const Vector2, byval rhs as const single) as Vector2
    return Vector2Scale(lhs, rhs)
end operator

operator * (byval lhs as const Vector2, byval rhs as const Matrix) as Vector2
    return Vector2Transform(lhs, rhs)
end operator

operator / (byval lhs as const Vector2, byval rhs as const Vector2) as Vector2
    return Vector2Divide(lhs, rhs)
end operator

operator / (byval lhs as const Vector2, byval rhs as const single) as Vector2
    return Vector2Scale(lhs, 1.0f / rhs)
end operator

operator = (byval lhs as const Vector2, byval rhs as const Vector2) as integer
    return iif(Vector2Equals(lhs, rhs), -1, 0)
end operator

operator <> (byval lhs as const Vector2, byval rhs as const Vector2) as integer
    return iif(Vector2Equals(lhs, rhs), 0, -1)
end operator


operator + (byval lhs as const Vector3, byval rhs as const Vector3) as Vector3
    return Vector3Add(lhs, rhs)
end operator

operator + (byval lhs as const Vector3, byval rhs as const single) as Vector3
    return Vector3AddValue(lhs, rhs)
end operator

operator - (byval lhs as const Vector3, byval rhs as const Vector3) as Vector3
    return Vector3Subtract(lhs, rhs)
end operator

operator - (byval lhs as const Vector3, byval rhs as const single) as Vector3
    return Vector3SubtractValue(lhs, rhs)
end operator

operator * (byval lhs as const Vector3, byval rhs as const Vector3) as Vector3
    return Vector3Multiply(lhs, rhs)
end operator

operator * (byval lhs as const Vector3, byval rhs as const single) as Vector3
    return Vector3Scale(lhs, rhs)
end operator

operator * (byval lhs as const Vector3, byval rhs as const Matrix) as Vector3
    return Vector3Transform(lhs, rhs)
end operator

operator / (byval lhs as const Vector3, byval rhs as const Vector3) as Vector3
    return Vector3Divide(lhs, rhs)
end operator

operator / (byval lhs as const Vector3, byval rhs as const single) as Vector3
    return Vector3Scale(lhs, 1.0f / rhs)
end operator

operator = (byval lhs as const Vector3, byval rhs as const Vector3) as integer
    return iif(Vector3Equals(lhs, rhs), -1, 0)
end operator

operator <> (byval lhs as const Vector3, byval rhs as const Vector3) as integer
    return iif(Vector3Equals(lhs, rhs), 0, -1)
end operator


operator + (byval lhs as const Vector4, byval rhs as const Vector4) as Vector4
    return Vector4Add(lhs, rhs)
end operator

operator + (byval lhs as const Vector4, byval rhs as const single) as Vector4
    return Vector4AddValue(lhs, rhs)
end operator

operator - (byval lhs as const Vector4, byval rhs as const Vector4) as Vector4
    return Vector4Subtract(lhs, rhs)
end operator

operator - (byval lhs as const Vector4, byval rhs as const single) as Vector4
    return Vector4SubtractValue(lhs, rhs)
end operator

operator * (byval lhs as const Vector4, byval rhs as const Vector4) as Vector4
    return Vector4Multiply(lhs, rhs)
end operator

operator * (byval lhs as const Vector4, byval rhs as const single) as Vector4
    return Vector4Scale(lhs, rhs)
end operator

operator / (byval lhs as const Vector4, byval rhs as const Vector4) as Vector4
    return Vector4Divide(lhs, rhs)
end operator

operator / (byval lhs as const Vector4, byval rhs as const single) as Vector4
    return Vector4Scale(lhs, 1.0f / rhs)
end operator

operator = (byval lhs as const Vector4, byval rhs as const Vector4) as integer
    return iif(Vector4Equals(lhs, rhs), -1, 0)
end operator

operator <> (byval lhs as const Vector4, byval rhs as const Vector4) as integer
    return iif(Vector4Equals(lhs, rhs), 0, -1)
end operator


operator + (byval lhs as const Quaternion, byval rhs as const single) as Quaternion
    return QuaternionAddValue(lhs, rhs)
end operator

operator - (byval lhs as const Quaternion, byval rhs as const single) as Quaternion
    return QuaternionSubtractValue(lhs, rhs)
end operator

operator * (byval lhs as const Quaternion, byval rhs as const Matrix) as Quaternion
    return QuaternionTransform(lhs, rhs)
end operator


operator + (byval lhs as const Matrix, byval rhs as const Matrix) as Matrix
    return MatrixAdd(lhs, rhs)
end operator

operator - (byval lhs as const Matrix, byval rhs as const Matrix) as Matrix
    return MatrixSubtract(lhs, rhs)
end operator

operator * (byval lhs as const Matrix, byval rhs as const Matrix) as Matrix
    return MatrixMultiply(lhs, rhs)
end operator


#endif 'RAYMATH_DISABLE_FB_OPERATORS
#endif 'RAYMATH_IMPLEMENTATION

#endif 'RAYMATH_BI