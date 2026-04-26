# PbPDFlib Library v6.7

PbPDFlib - PureBasic PDF Manipulation Library

- Author  : lcode.cn
- Version : 6.7
- License : Apache 2.0
- Compiler: PureBasic 6.40 (Windows - x86)

***

## Introduction

PbPDFlib is a PureBasic-native PDF manipulation library that can create, read, and modify PDF files without installing Adobe Acrobat or any third-party dependencies.

The library is ported from the Go-language pdfcpu project and the C-language libharu project. It primarily follows libharu's API design style (simple, suitable for PDF creation) while incorporating pdfcpu's advanced features such as reading/modifying/validation, resulting in a fully-featured PureBasic PDF library. All algorithms (MD5, RC4, AES, SHA-256, FlateDecode, PNG parsing, etc.) are implemented natively in PureBasic with no third-party dependencies.

## Features

- PDF Creation   : Create standards-compliant documents from scratch, supporting PDF 1.2-2.0
- PDF Reading    : Parse existing PDF files, extract pages, metadata, and content streams
- Text Drawing   : Standard fonts and TrueType fonts, UTF-8 encoding, char/word/line spacing
- Graphics       : Path construction, stroke/fill, color settings (RGB/CMYK/Gray), transformation matrices
- Image Handling : JPEG and PNG image loading and drawing, with alpha channel support
- Font Subsetting: TrueType font subsetting, embed only used glyphs to reduce file size
- Encryption     : RC4-40/RC4-128/AES-128/AES-256 encryption, password and permission management
- Bookmarks      : Create, modify, and delete multi-level nested outlines
- Annotations    : Text annotations, link annotations, highlight annotations
- Watermarks     : Text watermarks with rotation/opacity/diagonal placement
- Headers/Footers: Add headers and footers to existing PDFs
- Page Operations: Merge, split, extract, and delete pages
- Extended Graphics State: Transparency, blend modes

## System Requirements

- This project compiles with PureBasic 6.40 (Windows x86). Other environments have not been tested.

## Quick Start

See the documentation for details: docs\PbPDFlib_Help_en.html

### Creating a PDF Document

```purebasic
XIncludeFile "PbPDFlib.pb"

; Create a PDF document
*doc.PbPDF_Doc = PbPDF_New()

; Add an A4 page
*page = PbPDF_AddPage(*doc)
PbPDF_Page_SetPredefinedSize(*page, #PbPDF_PAGE_SIZE_A4, #PbPDF_PAGE_PORTRAIT)

; Set font and write text
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, "Helvetica", 24)
PbPDF_Page_MoveTextPos(*page, 50, 750)
PbPDF_Page_ShowText(*page, "Hello PbPDFlib!")
PbPDF_Page_EndText(*page)

; Save file
PbPDF_SaveToFile(*doc, "output.pdf")

; Release resources
PbPDF_Free(*doc)
```

### Using TrueType Fonts for CJK Text

```purebasic
XIncludeFile "PbPDFlib.pb"

*doc.PbPDF_Doc = PbPDF_New()
*page = PbPDF_AddPage(*doc)
PbPDF_Page_SetPredefinedSize(*page, #PbPDF_PAGE_SIZE_A4, #PbPDF_PAGE_PORTRAIT)

; Load TTF font
*font.PbPDF_Font = PbPDF_LoadTTFontFromFile(*doc, "C:\Windows\Fonts\msyh.ttc", #True)
fontName$ = PbPDF_RegisterTTFont(*doc, *page, *font)

; Display CJK text
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "Hello, PbPDFlib!", 24)

PbPDF_SaveToFile(*doc, "chinese.pdf")
PbPDF_Free(*doc)
```

### Reading and Modifying Existing PDFs

```purebasic
XIncludeFile "PbPDFlib.pb"

; Load a PDF file
*ldoc.PbPDF_LoadedDoc = PbPDF_LoadFromFile("input.pdf")
If *ldoc
  pageCount = PbPDF_LoadGetPageCount(*ldoc)
  version$ = PbPDF_LoadGetVersion(*ldoc)
  Debug "Pages: " + pageCount + " Version: " + version$
EndIf
```

### Merging PDF Files

```purebasic
XIncludeFile "PbPDFlib.pb"

result = PbPDF_MergePDFFiles("merged.pdf", "file1.pdf|file2.pdf|file3.pdf")
If result = #PbPDF_OK
  Debug "Merge successful!"
EndIf
```

## API Reference

### Document Management

| Function | Description |
|----------|-------------|
| `PbPDF_New()` | Create a PDF document object, returns document pointer |
| `PbPDF_Free(*doc)` | Release PDF document object |
| `PbPDF_NewDoc(*doc)` | Create new document on existing object |
| `PbPDF_FreeDoc(*doc)` | Release document content |
| `PbPDF_SaveToFile(*doc, fileName$)` | Save PDF to file |
| `PbPDF_SetCompressionMode(*doc, mode)` | Set compression mode |
| `PbPDF_SetPDFVersion(*doc, version)` | Set PDF version (1.2-2.0) |
| `PbPDF_GetPageCount(*doc)` | Get total page count |

### Page Operations

| Function | Description |
|----------|-------------|
| `PbPDF_AddPage(*doc)` | Add a new page |
| `PbPDF_AddPageA4(*doc)` | Add an A4 portrait page |
| `PbPDF_AddPageCustom(*doc, width, height)` | Add a custom-size page |
| `PbPDF_AddPagePredefined(*doc, pageSize, direction)` | Add a predefined-size page |
| `PbPDF_GetPageByIndex(*doc, index)` | Get page by index |
| `PbPDF_GetCurrentPage(*doc)` | Get current page |
| `PbPDF_Page_SetSize(*page, width, height)` | Set page size |
| `PbPDF_Page_SetPredefinedSize(*page, size, direction)` | Set predefined page size |
| `PbPDF_Page_GetWidth(*page)` | Get page width |
| `PbPDF_Page_GetHeight(*page)` | Get page height |

### Text Drawing

| Function | Description |
|----------|-------------|
| `PbPDF_Page_BeginText(*page)` | Begin text object |
| `PbPDF_Page_EndText(*page)` | End text object |
| `PbPDF_Page_SetFontAndSize(*page, fontName$, fontSize)` | Set font and size |
| `PbPDF_Page_ShowText(*page, text$)` | Show text |
| `PbPDF_Page_ShowTextNextLine(*page, text$)` | Show text on next line |
| `PbPDF_Page_MoveTextPos(*page, x, y)` | Move text position |
| `PbPDF_Page_SetCharSpace(*page, value)` | Set character spacing |
| `PbPDF_Page_SetWordSpace(*page, value)` | Set word spacing |
| `PbPDF_Page_SetHorizontalScalling(*page, value)` | Set horizontal scaling |
| `PbPDF_Page_SetTextLeading(*page, value)` | Set text leading |
| `PbPDF_Page_SetTextRenderingMode(*page, mode)` | Set text rendering mode |
| `PbPDF_Page_SetTextRise(*page, value)` | Set text rise |
| `PbPDF_Page_ShowTextUTF8(*page, text$)` | Show UTF-8 text |
| `PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, text$, fontSize)` | Show UTF-8 text (advanced) |

### Graphics Drawing

| Function | Description |
|----------|-------------|
| `PbPDF_Page_MoveTo(*page, x, y)` | Move to specified point |
| `PbPDF_Page_LineTo(*page, x, y)` | Draw line to specified point |
| `PbPDF_Page_CurveTo(*page, x1, y1, x2, y2, x3, y3)` | Cubic Bezier curve |
| `PbPDF_Page_CurveTo2(*page, x2, y2, x3, y3)` | Simplified Bezier curve |
| `PbPDF_Page_CurveTo3(*page, x1, y1, x3, y3)` | Simplified Bezier curve |
| `PbPDF_Page_Rectangle(*page, x, y, w, h)` | Draw rectangle |
| `PbPDF_Page_Arc(*page, x, y, radius, angle1, angle2)` | Draw arc |
| `PbPDF_Page_ClosePath(*page)` | Close path |
| `PbPDF_Page_Stroke(*page)` | Stroke path |
| `PbPDF_Page_Fill(*page)` | Fill path |
| `PbPDF_Page_Eofill(*page)` | Fill path (even-odd rule) |
| `PbPDF_Page_FillStroke(*page)` | Fill and stroke path |
| `PbPDF_Page_ClosePathStroke(*page)` | Close path and stroke |
| `PbPDF_Page_ClosePathFillStroke(*page)` | Close path, fill and stroke |
| `PbPDF_Page_EndPath(*page)` | End path without painting |

### Color and Line

| Function | Description |
|----------|-------------|
| `PbPDF_Page_SetRGBFill(*page, r, g, b)` | Set RGB fill color |
| `PbPDF_Page_SetRGBStroke(*page, r, g, b)` | Set RGB stroke color |
| `PbPDF_Page_SetCMYKFill(*page, c, m, y, k)` | Set CMYK fill color |
| `PbPDF_Page_SetCMYKStroke(*page, c, m, y, k)` | Set CMYK stroke color |
| `PbPDF_Page_SetGrayFill(*page, value)` | Set gray fill color |
| `PbPDF_Page_SetGrayStroke(*page, value)` | Set gray stroke color |
| `PbPDF_Page_SetLineWidth(*page, width)` | Set line width |
| `PbPDF_Page_SetLineCap(*page, capStyle)` | Set line cap style |
| `PbPDF_Page_SetLineJoin(*page, joinStyle)` | Set line join style |
| `PbPDF_Page_SetMiterLimit(*page, limit)` | Set miter limit |
| `PbPDF_Page_SetDash(*page, dashOn, dashOff, phase)` | Set dash pattern |

### Graphics State

| Function | Description |
|----------|-------------|
| `PbPDF_Page_GSave(*page)` | Save graphics state |
| `PbPDF_Page_GRestore(*page)` | Restore graphics state |
| `PbPDF_Page_Concat(*page, a, b, c, d, x, y)` | Concatenate transformation matrix |
| `PbPDF_Page_SetExtGState(*doc, *page, *gstate)` | Apply extended graphics state |
| `PbPDF_GStateNewEx(*doc, fillAlpha, strokeAlpha, blendMode)` | Create extended graphics state |

### Convenience Drawing

| Function | Description |
|----------|-------------|
| `PbPDF_Page_DrawLine(*page, x1, y1, x2, y2)` | Draw a line |
| `PbPDF_Page_DrawRect(*page, x, y, w, h)` | Draw rectangle (stroke) |
| `PbPDF_Page_FillRect(*page, x, y, w, h)` | Fill rectangle |
| `PbPDF_Page_DrawCircle(*page, x, y, radius)` | Draw circle (stroke) |
| `PbPDF_Page_FillCircle(*page, x, y, radius)` | Fill circle |
| `PbPDF_Page_DrawEllipse(*page, x, y, rx, ry)` | Draw ellipse (stroke) |

### Image Operations

| Function | Description |
|----------|-------------|
| `PbPDF_LoadJPEGImageFromFile(*doc, fileName$)` | Load JPEG image from file |
| `PbPDF_LoadPNGImageFromFile(*doc, fileName$)` | Load PNG image from file |
| `PbPDF_LoadCompressedImage(*doc, fileName$, scaleFactor, jpegQuality)` | Load and compress image |
| `PbPDF_Page_DrawImage(*doc, *page, *image, x, y, w, h)` | Draw image on page |

### Font Operations

| Function | Description |
|----------|-------------|
| `PbPDF_LoadTTFontFromFile(*doc, fileName$, embedding)` | Load TTF font from file |
| `PbPDF_LoadTTFont(*doc, fontName$, embedding)` | Load TTF font by name |
| `PbPDF_FindSystemFont(fontName$)` | Find system font file |
| `PbPDF_RegisterTTFont(*doc, *page, *font)` | Register TTF font to page |
| `PbPDF_RegisterCIDFont(*doc, *page, *font)` | Register CID font to page |
| `PbPDF_GetFont(*doc, *page, fontName$)` | Get font name |

### Bookmarks / Outlines

| Function | Description |
|----------|-------------|
| `PbPDF_CreateOutline(*doc, title$, *parent, *dest, opened)` | Create outline entry |
| `PbPDF_SetOutlineOpened(*outline, opened)` | Set expanded/collapsed |
| `PbPDF_CreateDestination(*page, destType, left, top, right, bottom, zoom)` | Create destination |
| `PbPDF_ModifyOutlineTitle(*outline, newTitle$)` | Modify outline title |
| `PbPDF_ModifyOutlineDest(*outline, *newDest)` | Modify outline destination |
| `PbPDF_ModifyOutlineColor(*outline, r, g, b)` | Modify outline color |
| `PbPDF_ModifyOutlineStyle(*outline, styleFlags)` | Modify outline style |
| `PbPDF_DeleteOutline(*doc, *outline)` | Delete outline |
| `PbPDF_GetFirstOutline(*doc)` | Get first outline |
| `PbPDF_GetOutlineFirst(*outline)` | Get first child outline |
| `PbPDF_GetOutlineNext(*outline)` | Get next sibling outline |
| `PbPDF_GetOutlineTitle(*outline)` | Get outline title |

### Annotations

| Function | Description |
|----------|-------------|
| `PbPDF_CreateTextAnnot(*doc, *page, x, y, w, h, title$, contents$)` | Create text annotation |
| `PbPDF_CreateLinkAnnot(*doc, *page, x, y, w, h, *dest)` | Create link annotation |
| `PbPDF_CreateURILinkAnnot(*doc, *page, x, y, w, h, uri$)` | Create URI link annotation |
| `PbPDF_CreateHighlightAnnot(*doc, *page, x, y, w, h, title$, contents$, r, g, b)` | Create highlight annotation |
| `PbPDF_SetAnnotBorder(*annot, borderStyle, borderWidth, dashOn, dashOff)` | Set annotation border |

### Encryption / Permissions

| Function | Description |
|----------|-------------|
| `PbPDF_SetPassword(*doc, userPwd$, ownerPwd$, permission, encryptionMode)` | Set password and encryption |
| `PbPDF_SetDecryptPassword(*ldoc, password$)` | Decrypt PDF document |
| `PbPDF_RemovePassword(inputFile$, outputFile$, ownerPwd$)` | Remove PDF password |
| `PbPDF_ChangePassword(inputFile$, outputFile$, oldOwnerPwd$, newUserPwd$, newOwnerPwd$, permission, encryptionMode)` | Change PDF password |

### Watermarks / Headers & Footers

| Function | Description |
|----------|-------------|
| `PbPDF_AddTextWatermark(*doc, text$, fontSize, rotation, opacity, r, g, b, diagonal, fontName$)` | Add text watermark |
| `PbPDF_AddWatermarkToFile(inputFile$, outputFile$, text$, fontSize, angle, r, g, b)` | Add watermark to file |
| `PbPDF_AddHeaderFooter(inputFile$, outputFile$, headerText$, footerText$, fontSize)` | Add header and footer |

### PDF Reading / Parsing

| Function | Description |
|----------|-------------|
| `PbPDF_LoadFromFile(fileName$)` | Read PDF from file |
| `PbPDF_LoadGetPageCount(*ldoc)` | Get page count of loaded PDF |
| `PbPDF_LoadGetPageSize(*ldoc, pageIndex, *width, *height)` | Get page size |
| `PbPDF_LoadGetInfoAttr(*ldoc, attrKey$)` | Get document attribute |
| `PbPDF_LoadGetVersion(*ldoc)` | Get PDF version |
| `PbPDF_LoadGetPageContent(*ldoc, pageIndex)` | Get page content stream |

### PDF Page Operations

| Function | Description |
|----------|-------------|
| `PbPDF_MergePDFFiles(outputFileName$, inputFiles$)` | Merge multiple PDFs |
| `PbPDF_ExtractPages(inputFile$, outputFile$, startPage, endPage)` | Extract pages |
| `PbPDF_SplitPDF(inputFile$, outputPrefix$)` | Split PDF |
| `PbPDF_DeletePages(inputFile$, outputFile$, startPage, endPage)` | Delete pages |

### Document Information

| Function | Description |
|----------|-------------|
| `PbPDF_SetInfoAttr(*doc, attrType, value$)` | Set document attribute |
| `PbPDF_GetInfoAttr(*doc, attrType)` | Get document attribute |

## File Structure

The PbPDFlib.pb file is organized into the following sections:

| Section | Content |
|---------|---------|
| Part 1  | Constants and enumerations (PDF version, object types, graphics modes, encryption modes, etc.) |
| Part 2  | Basic data structures (Point/Rect/Matrix/Color/DashMode, etc.) |
| Part 3  | Core algorithms (MD5/RC4/ASCIIHex/UTF8/CRC32/Random, etc.) |
| Part 4  | Memory management and utility functions (List/Error/Stream) |
| Part 5  | PDF object model (Null/Boolean/Number/Real/Name/String/Binary/Array/Dict) |
| Part 6  | Cross-reference table (XRef) |
| Part 7  | Object serialization (WriteToStream/WriteIndirectObj) |
| Part 8  | Document management (New/Free/NewDoc/FreeDoc/SaveToFile) |
| Part 9  | Page management (AddPage/PageSize) |
| Part 10 | Destinations |
| Part 11 | Bookmarks / Outlines |
| Part 12 | Annotations |
| Part 13 | Extended graphics state |
| Part 14 | Watermarks |
| Part 15 | Encryption (Encrypt/Password) |
| Part 16 | TTF font handling (FontLoad/Subset/GlyphMap) |
| Part 17 | CID fonts and UTF-8 encoding |
| Part 18 | Compression modes |
| Part 19 | Image processing (JPEG/PNG) |
| Part 20 | Page operators (path/text/color/transform) |
| Part 21 | PDF reading and parsing (Lexer/Parser/XRef) |
| Part 22 | PDF page operations (Merge/Extract/Split/Delete) |
| Part 23 | Headers/Footers / File watermarks |
| Part 24 | PDF decryption / Password management |
| Part 25 | Outline modification / deletion |
| Part 26 | Public API |

## Version History

### v6.7 (2026-04-26)

- \[Fix] PDF standard password padding string (PbPDF_EncryptPadding) was incorrect, causing encrypted PDFs to be unopenable by third-party software
- \[Fix] PbPDF_SetDecryptPassword function was missing 50x MD5 iteration for R3 (RC4-128)
- \[Fix] Test file path issues, unified use of GetPathPart(ProgramFilename()) for output directory
- \[New] Donation/sponsor information
- \[New] English README and help documentation

### v6.6 (2026-04-26)

- \[New] Generated HTML help documentation (PbPDFlib_Help.html)
- \[New] Added README.md documentation
- \[New] Feature reference source comparison table (infos.md)
- \[Improved] Enhanced code comments and documentation

### v6.5 (2026-03-05)

- \[New] Outline deletion (PbPDF_DeleteOutline)
- \[New] Outline tree release and unlink functions
- \[New] Outline traversal API (GetFirstOutline/GetOutlineFirst/GetOutlineNext/GetOutlineTitle)

### v6.4 (2026-01-29)

- \[New] Outline color modification (PbPDF_ModifyOutlineColor)
- \[New] Outline style modification (PbPDF_ModifyOutlineStyle)
- \[New] Outline expanded state modification (PbPDF_ModifyOutlineOpened)

### v6.3 (2025-12-27)

- \[New] Outline title modification (PbPDF_ModifyOutlineTitle)
- \[New] Outline destination modification (PbPDF_ModifyOutlineDest)
- \[Fix] Object reference error when saving PDF after modifying outlines

### v6.2 (2025-11-24)

- \[New] PDF version setting (PbPDF_SetPDFVersion), supporting PDF 1.2-2.0
- \[New] Compression mode setting (PbPDF_SetCompressionMode)
- \[Improved] SaveToFile2 supports content stream compression

### v6.1 (2025-10-22)

- \[New] Convenience drawing functions (DrawLine/DrawRect/FillRect/DrawCircle/FillCircle/DrawEllipse)
- \[New] Arc drawing (PbPDF_Page_Arc)

### v6.0 (2025-09-19)

- \[New] PDF password change (PbPDF_ChangePassword)
- \[New] PDF password removal (PbPDF_RemovePassword)
- \[Improved] Encryption workflow refactored, supporting incremental updates

### v5.9 (2025-08-17)

- \[New] PDF decryption (PbPDF_SetDecryptPassword)
- \[New] Encrypted PDF file reading support
- \[Fix] Object key calculation error during RC4 decryption

### v5.0 (2024-10-24)

- \[New] PDF file reading framework
- \[Improved] Overall architecture adjustment, supporting read mode

### v4.0 (2023-11-29)

- \[New] Bookmark/outline creation (PbPDF_CreateOutline)
- \[New] Destinations (PbPDF_CreateDestination)

### v3.6 (2023-07-20)

- \[New] PDF encryption (PbPDF_SetPassword)
- \[New] RC4-40 encryption support
- \[New] MD5 hash algorithm implementation

### v3.0 (2023-01-03)

- \[New] UTF-8 text advanced display (PbPDF_Page_ShowTextUTF8Ex)
- \[Improved] UTF-8 encoding workflow refactored

### v2.4 (2022-06-19)

- \[New] TTF font loading (PbPDF_LoadTTFontFromFile)
- \[New] TTF file header and table parsing

### v2.0 (2022-02-07)

- \[New] Graphics state stack (GSave/GRestore)
- \[New] Transformation matrix (PbPDF_Page_Concat)

### v1.4 (2021-07-25)

- \[New] Text drawing (BeginText/EndText/ShowText, etc.)
- \[New] Font and size settings

### v1.0 (2021-03-15)

- \[New] Initial project creation, based on pdfcpu and libharu
- \[New] PDF object model
- \[New] Memory management and stream processing modules
- \[New] Cross-reference table structure
- \[New] Core algorithms (CRC32/ASCIIHex/UTF8 decoding, etc.)

## Sponsor / Donate

If PbPDFlib is helpful to you, please consider sponsoring to support the continued development and maintenance of this project!

- **PayPal** : https://www.paypal.me/lcodecn
- **WeChat Pay** : #付款:lcodecn(经营_lcodecn)/openlib/003

Every bit of support motivates the author to keep improving this open-source project. Thank you!

## License

This library is licensed under the Apache 2.0 License.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

The referenced pdfcpu project is licensed under the Apache 2.0 License.

```
Copyright 2018 The pdfcpu Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

The referenced libharu project is licensed under the ZLIB/LIBPNG License.

```
Copyright (C) 1999-2006 Takeshi Kanno
Copyright (C) 2007-2008 li da

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
```

## Acknowledgments

- Thanks to the pdfcpu project for providing an excellent PDF reading/modification reference implementation
- Thanks to the libharu project for providing an excellent PDF creation reference implementation
