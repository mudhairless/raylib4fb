/'*********************************************************************************************
*
*   rres v1.0 - A simple and easy-to-use file-format to package resources
*
*   Packer:
*   Online version available for free @ https://raylibtech.itch.io/rrespacker
*
*   FEATURES:
* 
*     - Multi-resource files: Some files could end-up generating multiple connected resources in
*       the rres output file (i.e TTF files could generate RRES_DATA_FONT_GLYPHS and RRES_DATA_IMAGE).
*     - File packaging as raw resource data: Avoid data processing and just package the file bytes.
*     - Per-file data compression/encryption: Configure compression/encription for every input file.
*     - Externally linked files: Package only the file path, to be loaded from external file when the
*       specific id is requested. WARNING: Be careful with path, it should be relative to application dir.
*     - Central Directory resource (optional): Create a central directory with the input filename relation
*       to the resource(s) id. This is the default option but it can be avoided; in that case, a header
*       file (.h) is generated with the file ids definitions.
*
*   FILE STRUCTURE:
*
*   rres files consist of a file header followed by a number of resource chunks.
*
*   Optionally it can contain a Central Directory resource chunk (usually at the end) with the info
*   of all the files processed into the rres file.
*
*   NOTE: Chunks count could not match files count, some processed files (i.e Font, Mesh)
*   could generate multiple chunks with the same id related by the rresResourceChunkInfo.nextOffset
*   Those chunks are loaded together when resource is loaded
*
*   rresFileHeader               (16 bytes)
*       Signature Id              (4 bytes)     '' File signature id: 'rres'
*       Version                   (2 bytes)     '' Format version
*       Resource Count            (2 bytes)     '' Number of resource chunks contained
*       CD Offset                 (4 bytes)     '' Central Directory offset (if available)
*       Reserved                  (4 bytes)     '' <reserved>
*
*   rresResourceChunk[]
*   {
*       rresResourceChunkInfo   (32 bytes)
*           Type                  (4 bytes)     '' Resource type (FourCC)
*           Id                    (4 bytes)     '' Resource identifier (CRC32 filename hash or custom)
*           Compressor            (1 byte)      '' Data compression algorithm
*           Cipher                (1 byte)      '' Data encryption algorithm
*           Flags                 (2 bytes)     '' Data flags (if required)
*           Data Packed Size      (4 bytes)     '' Data packed size (compressed/encrypted + custom data appended)
*           Data Base Size        (4 bytes)     '' Data base size (uncompressed/unencrypted)
*           Next Offset           (4 bytes)     '' Next resource chunk offset (if required)
*           Reserved              (4 bytes)     '' <reserved>
*           CRC32                 (4 bytes)     '' Resource Data Chunk CRC32
*
*       rresResourceChunkData     (n bytes)     '' Packed data
*           Property Count        (4 bytes)     '' Number of properties contained
*           Properties[]          (4*i bytes)   '' Resource data required properties, depend on Type
*           Data                  (m bytes)     '' Resource data
*   }
*
*   rresResourceChunk: RRES_DATA_DIRECTORY      '' Central directory (special resource chunk)
*   {
*       rresResourceChunkInfo   (32 bytes)
*
*       rresCentralDir            (n bytes)     '' rresResourceChunkData
*           Entries Count         (4 bytes)     '' Central directory entries count (files)
*           rresDirEntry[]
*           {
*               Id                (4 bytes)     '' Resource id
*               Offset            (4 bytes)     '' Resource global offset in file
*               reserved          (4 bytes)     '' <reserved>
*               FileName Size     (4 bytes)     '' Resource fileName size (NULL terminator and 4-bytes align padding considered)
*               FileName          (m bytes)     '' Resource original fileName (NULL terminated and padded to 4-byte alignment)
*           }
*    }
*
*   DESIGN DECISIONS / LIMITATIONS:
*
*     - rres file maximum chunks: 65535 (16bit chunk count in rresFileHeader)
*     - rres file maximum size: 4GB (chunk offset and Central Directory Offset is 32bit, so it can not address more than 4GB
*     - Chunk search by ID is done one by one, starting at first chunk and accessed with fread() function
*     - Endianness: rres does not care about endianness, data is stored as desired by the host platform (most probably Little Endian)
*       Endianness won't affect chunk data but it will affect rresFileHeader and rresResourceChunkInfo
*     - CRC32 hash is used to to generate the rres file identifier from filename
*       There is a "small" probability of random collision (1 in 2^32 approx.) but considering
*       the chance of collision is related to the number of data inputs, not the size of the inputs, we assume that risk
*       Also note that CRC32 is not used as a security/cryptographic hash, just an identifier for the input file
*     - CRC32 hash is also used to detect chunk data corruption. CRC32 is smaller and computationally much less complex than MD5 or SHA1.
*       Using a hash function like MD5 is probably overkill for random error detection
*     - Central Directory rresDirEntry.fileName is NULL terminated and padded to 4-byte, rresDirEntry.fileNameSize considers the padding
*     - Compression and Encryption. rres supports chunks data compression and encryption, it provides two fields in the rresResourceChunkInfo to
*       note it, but in those cases is up to the user to implement the desired compressor/uncompressor and encryption/decryption mechanisms
*       In case of data encryption, it's recommended that any additional resource data (i.e. MAC) to be appended to data chunk and properly
*       noted in the packed data size field of rresResourceChunkInfo. Data compression should be applied before encryption.
*
*
*   VERSION HISTORY:
*
*     - 1.0 (12-May-2022): Implementation review for better alignment with rres specs
*     - 0.9 (28-Apr-2022): Initial implementation of rres specs
*
*
*   LICENSE: MIT
*
*   Copyright (c) 2016-2022 Ramon Santamaria (@raysan5)
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

#ifndef RRES_BI
#define RRES_BI

#inclib "rres"

#define RRES_MAX_FILENAME_SIZE      1024

extern "C"

''----------------------------------------------------------------------------------
'' Types and Structures Definition
''----------------------------------------------------------------------------------
'' rres file header (16 bytes)
type rresFileHeader 
    id(0 to 3) as ubyte            '' File identifier: rres
    version as ushort         '' File version: 100 for version 1.0
    chunkCount as ushort      '' Number of resource chunks in the file (MAX: 65535)
    cdOffset as ulong          '' Central Directory offset in file (0 if not available)
    reserved as ulong          '' <reserved>
end type

'' rres resource chunk info header (32 bytes)
type rresResourceChunkInfo 
    type_(0 to 3) as ubyte          '' Resource chunk type (FourCC)
    id as ulong                '' Resource chunk identifier (generated from filename CRC32 hash)
    compType as ubyte         '' Data compression algorithm
    cipherType as ubyte      '' Data encription algorithm
    flags as ushort           '' Data flags (if required)
    packedSize as ulong        '' Data chunk size (compressed/encrypted + custom data appended)
    baseSize as ulong          '' Data base size (uncompressed/unencrypted)
    nextOffset as ulong        '' Next resource chunk global offset (if resource has multiple chunks)
    reserved as ulong          '' <reserved>
    crc32 as ulong             '' Data chunk CRC32 (propCount + props[] + data)
end type

'' rres resource chunk data
type rresResourceChunkData 
    propCount as ulong         '' Resource chunk properties count
    props as ulong ptr           '' Resource chunk properties
    raw as any ptr                     '' Resource chunk raw data
end type

'' rres resource chunk
type rresResourceChunk 
    info as rresResourceChunkInfo     '' Resource chunk info
    data_ as rresResourceChunkData     '' Resource chunk packed data, contains propCount, props[] and raw data
end type

'' rres resource multi
'' NOTE: It supports multiple resource chunks
type rresResourceMulti 
    count as ulong             '' Resource chunks count
    chunks as rresResourceChunk ptr     '' Resource chunks
end type

'' Useful data types for specific chunk types
''----------------------------------------------------------------------
'' CDIR: rres central directory entry
type rresDirEntry 
    id as ulong                '' Resource id
    offset as ulong            '' Resource global offset in file
    reserved as ulong          '' reserved
    fileNameSize as ulong      '' Resource fileName size (NULL terminator and 4-byte alignment padding considered)
    fileName as zstring * RRES_MAX_FILENAME_SIZE  '' Resource original fileName (NULL terminated and padded to 4-byte alignment)
end type

'' CDIR: rres central directory
'' NOTE: This data conforms the rresResourceChunkData
type rresCentralDir 
    count as ulong            '' Central directory entries count
    entries as rresDirEntry ptr         '' Central directory entries
end type

'' FNTG: rres font glyphs info (32 bytes)
'' NOTE: And array of this type conforms the rresResourceChunkData
type rresFontGlyphInfo
    as long x, y, width_, height        '' Glyph rectangle in the atlas image
    as long value                      '' Glyph codepoint value
    as long offsetX, offsetY           '' Glyph drawing offset (from base line)
    as long advanceX                   '' Glyph advance X for next character
end type

''----------------------------------------------------------------------------------
'' Enums Definition
'' The following enums are useful to fill some fields of the rresResourceChunkInfo
'' and also some fields of the different data types properties
''----------------------------------------------------------------------------------

'' rres resource chunk data type
'' NOTE 1: Data type determines the properties and the data included in every chunk
'' NOTE 2: This enum defines the basic resource data types,
'' some input files could generate multiple resource chunks:
''   Fonts processed could generate (2) resource chunks:
''   - [FNTG] rres[0]: RRES_DATA_FONT_GLYPHS
''   - [IMGE] rres[1]: RRES_DATA_IMAGE
''
''   Mesh processed could generate (n) resource chunks:
''   - [VRTX] rres[0]: RRES_DATA_VERTEX
''   ...
''   - [VRTX] rres[n]: RRES_DATA_VERTEX
enum rresResourceDataType 
    RRES_DATA_NULL         = 0             '' FourCC: NULL - Reserved for empty chunks, no props/data
    RRES_DATA_RAW          = 1             '' FourCC: RAWD - Raw file data, 4 properties
                                            ''    props[0]:size (bytes)
                                            ''    props[1]:extension01 (big-endian: ".png" = 0x2e706e67)
                                            ''    props[2]:extension02 (additional part, extensions with +3 letters)
                                            ''    props[3]:reserved
                                            ''    data: raw bytes
    RRES_DATA_TEXT         = 2             '' FourCC: TEXT - Text file data, 4 properties
                                            ''    props[0]:size (bytes)
                                            ''    props[1]:rresTextEncoding
                                            ''    props[2]:rresCodeLang
                                            ''    props[3]:cultureCode
                                            ''    data: text
    RRES_DATA_IMAGE        = 3             '' FourCC: IMGE - Image file data, 4 properties
                                            ''    props[0]:width
                                            ''    props[1]:height
                                            ''    props[2]:rresPixelFormat
                                            ''    props[3]:mipmaps
                                            ''    data: pixels
    RRES_DATA_WAVE         = 4             '' FourCC: WAVE - Audio file data, 4 properties
                                            ''    props[0]:frameCount
                                            ''    props[1]:sampleRate
                                            ''    props[2]:sampleSize
                                            ''    props[3]:channels
                                            ''    data: samples
    RRES_DATA_VERTEX       = 5             '' FourCC: VRTX - Vertex file data, 4 properties
                                            ''    props[0]:vertexCount
                                            ''    props[1]:rresVertexAttribute
                                            ''    props[2]:componentCount
                                            ''    props[3]:rresVertexFormat
                                            ''    data: vertex
    RRES_DATA_FONT_GLYPHS  = 6             '' FourCC: FNTG - Font glyphs info data, 4 properties
                                            ''    props[0]:baseSize
                                            ''    props[1]:glyphCount
                                            ''    props[2]:glyphPadding
                                            ''    props[3]:rresFontStyle
                                            ''    data: rresFontGlyphInfo[0..glyphCount]
    RRES_DATA_LINK         = 99            '' FourCC: LINK - External linked file, 1 property
                                            ''    props[0]:size (bytes)
                                            ''    data: filepath (as provided on input)
    RRES_DATA_DIRECTORY    = 100           '' FourCC: CDIR - Central directory for input files
                                            ''    props[0]:entryCount, 1 property
                                            ''    data: rresDirEntry[0..entryCount]

    '' TODO: 2.0: Support resource package types (muti-resource)
    '' NOTE: They contains multiple rresResourceChunk in rresResourceData.raw
    ''RRES_DATA_PACK_FONT    = 110,         '' FourCC: PFNT - Resources Pack: Font data, 1 property (2 resource chunks: RRES_DATA_GLYPHS, RRES_DATA_IMAGE)
                                            ''    props[0]:chunkCount
    ''RRES_DATA_PACK_MESH    = 120,         '' FourCC: PMSH - Resources Pack: Mesh data, 1 property (n resource chunks: RRES_DATA_VERTEX)
                                            ''    props[0]:chunkCount

    '' TODO: Add additional resource data types if required (define props + data)

end enum

'' Compression algorithms
'' Value required by rresResourceChunkInfo.compType
'' NOTE 1: This enum just list some common data compression algorithms for convenience,
'' The rres packer tool and the engine-specific library are responsible to implement the desired ones,
'' NOTE 2: rresResourceChunkInfo.compType is a byte-size value, limited to [0..255]
enum rresCompressionType 
    RRES_COMP_NONE          = 0            '' No data compression
    RRES_COMP_RLE           = 1            '' RLE compression
    RRES_COMP_DEFLATE       = 10           '' DEFLATE compression
    RRES_COMP_LZ4           = 20           '' LZ4 compression
    RRES_COMP_LZMA2         = 30           '' LZMA2 compression
    RRES_COMP_QOI           = 40           '' QOI compression, useful for RGB(A) image data
    '' TODO: Add additional compression algorithms if required
end enum

'' Encryption algoritms
'' Value required by rresResourceChunkInfo.cipherType
'' NOTE 1: This enum just lists some common data encryption algorithms for convenience,
'' The rres packer tool and the engine-specific library are responsible to implement the desired ones,
'' NOTE 2: Some encryption algorithm could require/generate additional data (seed, salt, nonce, MAC...)
'' in those cases, that extra data must be appended to the original encrypted message and added to the resource data chunk
'' NOTE 3: rresResourceChunkInfo.cipherType is a byte-size value, limited to [0..255]
enum rresEncryptionType 
    RRES_CIPHER_NONE        = 0            '' No data encryption
    RRES_CIPHER_XOR         = 1            '' XOR encryption, generic using 128bit key in blocks
    RRES_CIPHER_DES         = 10           '' DES encryption
    RRES_CIPHER_TDES        = 11           '' Triple DES encryption
    RRES_CIPHER_IDEA        = 20           '' IDEA encryption
    RRES_CIPHER_AES         = 30           '' AES (128bit or 256bit) encryption
    RRES_CIPHER_AES_GCM     = 31           '' AES Galois/Counter Mode (Galois Message Authentification Code - GMAC)
    RRES_CIPHER_XTEA        = 40           '' XTEA encryption
    RRES_CIPHER_BLOWFISH    = 50           '' BLOWFISH encryption
    RRES_CIPHER_RSA         = 60           '' RSA asymmetric encryption
    RRES_CIPHER_SALSA20     = 70           '' SALSA20 encryption
    RRES_CIPHER_CHACHA20    = 71           '' CHACHA20 encryption
    RRES_CIPHER_XCHACHA20   = 72           '' XCHACHA20 encryption
    RRES_CIPHER_XCHACHA20_POLY1305 = 73    '' XCHACHA20 with POLY1305 for message authentification (MAC)
    '' TODO: Add additional encryption algorithm if required
end enum

'' TODO: rres error codes (not used at this moment)
'' NOTE: Error codes when processing rres files
enum rresErrorType 
    RRES_SUCCESS = 0                       '' rres file loaded/saved successfully
    RRES_ERROR_FILE_NOT_FOUND              '' rres file can not be opened (spelling issues, file actually does not exist...)
    RRES_ERROR_FILE_FORMAT                 '' rres file format not a supported (wrong header, wrong identifier)
    RRES_ERROR_MEMORY_ALLOC                '' Memory could not be allocated for operation.
end enum

'' Enums required by specific resource types for its properties
''----------------------------------------------------------------------------------
'' TEXT: Text encoding property values
enum rresTextEncoding 
    RRES_TEXT_ENCODING_UNDEFINED = 0       '' Not defined, usually UTF-8
    RRES_TEXT_ENCODING_UTF8      = 1       '' UTF-8 text encoding
    RRES_TEXT_ENCODING_UTF8_BOM  = 2       '' UTF-8 text encoding with Byte-Order-Mark
    RRES_TEXT_ENCODING_UTF16_LE  = 10      '' UTF-16 Little Endian text encoding
    RRES_TEXT_ENCODING_UTF16_BE  = 11      '' UTF-16 Big Endian text encoding
    '' TODO: Add additional encodings if required
end enum

'' TEXT: Text code language
'' NOTE: It could be useful for code script resources
enum rresCodeLang 
    RRES_CODE_LANG_UNDEFINED = 0           '' Undefined code language, text is plain text
    RRES_CODE_LANG_C                       '' Text contains C code
    RRES_CODE_LANG_CPP                     '' Text contains C++ code
    RRES_CODE_LANG_CS                      '' Text contains C# code
    RRES_CODE_LANG_LUA                     '' Text contains Lua code
    RRES_CODE_LANG_JS                      '' Text contains JavaScript code
    RRES_CODE_LANG_PYTHON                  '' Text contains Python code
    RRES_CODE_LANG_RUST                    '' Text contains Rust code
    RRES_CODE_LANG_ZIG                     '' Text contains Zig code
    RRES_CODE_LANG_ODIN                    '' Text contains Odin code
    RRES_CODE_LANG_JAI                     '' Text contains Jai code
    RRES_CODE_LANG_GDSCRIPT                '' Text contains GDScript (Godot) code
    RRES_CODE_LANG_GLSL                    '' Text contains GLSL shader code
    '' TODO: Add additional code languages if required
end enum

'' IMGE: Image/Texture pixel formats
enum rresPixelFormat 
    RRES_PIXELFORMAT_UNDEFINED = 0
    RRES_PIXELFORMAT_UNCOMP_GRAYSCALE = 1  '' 8 bit per pixel (no alpha)
    RRES_PIXELFORMAT_UNCOMP_GRAY_ALPHA     '' 16 bpp (2 channels)
    RRES_PIXELFORMAT_UNCOMP_R5G6B5         '' 16 bpp
    RRES_PIXELFORMAT_UNCOMP_R8G8B8         '' 24 bpp
    RRES_PIXELFORMAT_UNCOMP_R5G5B5A1       '' 16 bpp (1 bit alpha)
    RRES_PIXELFORMAT_UNCOMP_R4G4B4A4       '' 16 bpp (4 bit alpha)
    RRES_PIXELFORMAT_UNCOMP_R8G8B8A8       '' 32 bpp
    RRES_PIXELFORMAT_UNCOMP_R32            '' 32 bpp (1 channel - float)
    RRES_PIXELFORMAT_UNCOMP_R32G32B32      '' 32*3 bpp (3 channels - float)
    RRES_PIXELFORMAT_UNCOMP_R32G32B32A32   '' 32*4 bpp (4 channels - float)
    RRES_PIXELFORMAT_COMP_DXT1_RGB         '' 4 bpp (no alpha)
    RRES_PIXELFORMAT_COMP_DXT1_RGBA        '' 4 bpp (1 bit alpha)
    RRES_PIXELFORMAT_COMP_DXT3_RGBA        '' 8 bpp
    RRES_PIXELFORMAT_COMP_DXT5_RGBA        '' 8 bpp
    RRES_PIXELFORMAT_COMP_ETC1_RGB         '' 4 bpp
    RRES_PIXELFORMAT_COMP_ETC2_RGB         '' 4 bpp
    RRES_PIXELFORMAT_COMP_ETC2_EAC_RGBA    '' 8 bpp
    RRES_PIXELFORMAT_COMP_PVRT_RGB         '' 4 bpp
    RRES_PIXELFORMAT_COMP_PVRT_RGBA        '' 4 bpp
    RRES_PIXELFORMAT_COMP_ASTC_4x4_RGBA    '' 8 bpp
    RRES_PIXELFORMAT_COMP_ASTC_8x8_RGBA     '' 2 bpp
    '' TOO: Add additional pixel formats if required
end enum

'' VRTX: Vertex data attribute
'' NOTE: The expected number of components for every vertex attributes is provided as a property to data,
'' the listed components count are the expected/default ones
enum rresVertexAttribute 
    RRES_VERTEX_ATTRIBUTE_POSITION   = 0   '' Vertex position attribute: [x, y, z]
    RRES_VERTEX_ATTRIBUTE_TEXCOORD1  = 10  '' Vertex texture coordinates attribute: [u, v]
    RRES_VERTEX_ATTRIBUTE_TEXCOORD2  = 11  '' Vertex texture coordinates attribute: [u, v]
    RRES_VERTEX_ATTRIBUTE_TEXCOORD3  = 12  '' Vertex texture coordinates attribute: [u, v]
    RRES_VERTEX_ATTRIBUTE_TEXCOORD4  = 13  '' Vertex texture coordinates attribute: [u, v]
    RRES_VERTEX_ATTRIBUTE_NORMAL     = 20  '' Vertex normal attribute: [x, y, z]
    RRES_VERTEX_ATTRIBUTE_TANGENT    = 30  '' Vertex tangent attribute: [x, y, z, w]
    RRES_VERTEX_ATTRIBUTE_COLOR      = 40  '' Vertex color attribute: [r, g, b, a]
    RRES_VERTEX_ATTRIBUTE_INDEX      = 100 '' Vertex index attribute: [i]
    '' TODO: Add additional attributes if required
end enum

'' VRTX: Vertex data format type
enum rresVertexFormat 
    RRES_VERTEX_FORMAT_UBYTE = 0           '' 8 bit unsigned integer data
    RRES_VERTEX_FORMAT_BYTE                '' 8 bit signed integer data
    RRES_VERTEX_FORMAT_USHORT              '' 16 bit unsigned integer data
    RRES_VERTEX_FORMAT_SHORT               '' 16 bit signed integer data
    RRES_VERTEX_FORMAT_UINT                '' 32 bit unsigned integer data
    RRES_VERTEX_FORMAT_INT                 '' 32 bit integer data
    RRES_VERTEX_FORMAT_HFLOAT              '' 16 bit float data
    RRES_VERTEX_FORMAT_FLOAT               '' 32 bit float data
    '' TODO: Add additional required vertex formats (i.e. normalized data)
end enum

'' FNTG: Font style
enum rresFontStyle
    RRES_FONT_STYLE_UNDEFINED = 0          '' Undefined font style
    RRES_FONT_STYLE_REGULAR                '' Regular font style
    RRES_FONT_STYLE_BOLD                   '' Bold font style
    RRES_FONT_STYLE_ITALIC                 '' Italic font style
    '' TODO: Add additional font styles if required
end enum

''----------------------------------------------------------------------------------
'' Module Functions Declaration
''----------------------------------------------------------------------------------

'' Load only one resource chunk (first resource id found)
declare function rresLoadResourceChunk(byval fileName as const zstring ptr, byval rresId as long) as rresResourceChunk  '' Load one resource chunk for provided id
declare sub rresUnloadResourceChunk(byval chunk as rresResourceChunk)                      '' Unload resource chunk from memory

'' Load multi resource chunks for a specified rresId
declare function rresLoadResourceMulti(byval fileName as const zstring ptr, byval rresId as long) as rresResourceMulti  '' Load resource for provided id (multiple resource chunks)
declare sub rresUnloadResourceMulti(byval multi as rresResourceMulti)                      '' Unload resource from memory (multiple resource chunks)

'' Load resource(s) chunk info from file
declare function rresLoadResourceChunkInfo(byval fileName as const zstring ptr, byval rresId as long) as rresResourceChunkInfo  '' Load resource chunk info for provided id
declare function rresLoadResourceChunkInfoAll(byval fileName as const zstring ptr, byval chunkCount as ulong ptr) as rresResourceChunkInfo ptr '' Load all resource chunks info

declare function rresLoadCentralDirectory(byval fileName as const zstring ptr) as rresCentralDir              '' Load central directory resource chunk from file
declare sub rresUnloadCentralDirectory(byval dir_ as rresCentralDir)                        '' Unload central directory resource chunk

declare function rresGetDataType(byval fourCC as const ubyte ptr) as ulong                  '' Get rresResourceDataType from FourCC code
declare function rresGetResourceId(byval dir_ as rresCentralDir, byval fileName as const zstring ptr) as long            '' Get resource id for a provided filename
                                                                                    '' NOTE: It requires CDIR available in the file (it's optinal by design)
declare function rresComputeCRC32(byval data_ as ubyte ptr, byval len_ as long) as ulong                '' Compute CRC32 for provided data

'' Manage password for data encryption/decryption
'' NOTE: The cipher password is kept as an internal pointer to provided string, it's up to the user to manage that sensible data properly
'' Password should be to allocate and set before loading an encrypted resource and it should be cleaned/wiped after the encrypted resource has been loaded
'' TODO: Move this functionality to engine-library, after all rres.h does not manage data decryption
declare sub rresSetCipherPassword(byval pass as const zstring ptr)                 '' Set password to be used on data decryption
declare function rresGetCipherPassword() as const zstring ptr                      '' Get password to be used on data decryption

end extern

#endif '' RRES_BI