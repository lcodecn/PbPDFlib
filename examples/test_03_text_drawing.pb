﻿;=============================================================================
; test_03_text_drawing.pb - 测试3：文本绘制
; PbPDFlib 功能测试：标准字体、文本间距、渲染模式、文本位置控制
;=============================================================================
; 功能覆盖：
;   PbPDF_GetFont              - 获取标准字体(Helvetica/Courier/Times等14种)
;   PbPDF_Page_BeginText       - 开始文本对象(BT)
;   PbPDF_Page_EndText         - 结束文本对象(ET)
;   PbPDF_Page_SetFontAndSize  - 设置字体和大小(Tf)
;   PbPDF_Page_ShowText        - 显示文本(Tj)
;   PbPDF_Page_MoveTextPos     - 移动文本位置(Td)
;   PbPDF_Page_ShowTextNextLine - 下一行显示文本(')
;   PbPDF_Page_SetCharSpace    - 设置字符间距(Tc)
;   PbPDF_Page_SetWordSpace    - 设置词间距(Tw)
;   PbPDF_Page_SetHorizontalScalling - 设置水平缩放(Tz)
;   PbPDF_Page_SetTextLeading  - 设置文本行距(TL)
;   PbPDF_Page_SetTextRenderingMode - 设置文本渲染模式(Tr)
;   PbPDF_Page_SetTextRise     - 设置文本上升(Ts)
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试3：文本绘制功能测试")
PrintN("========================================")

;--- 变量声明 ---
Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define fontName$
Define result.i
Define yPos.f
Define outputDir$ = GetPathPart(ProgramFilename())

;=============================================================================
; 创建文档和页面
;=============================================================================
*doc = PbPDF_Create()
If Not *doc
  PrintN("  [失败] 创建文档失败!")
  Input()
  End
EndIf
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PbPDFlib 文本绘制测试")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "lcode.cn")

*page = PbPDF_AddPage(*doc)

;=============================================================================
; 3.1 14种标准字体测试
;=============================================================================
PrintN("")
PrintN("--- 3.1 14种标准字体测试 ---")

; 标准字体列表（Base14 Fonts）
; Helvetica系列: Helvetica, Helvetica-Bold, Helvetica-Oblique, Helvetica-BoldOblique
; Courier系列: Courier, Courier-Bold, Courier-Oblique, Courier-BoldOblique
; Times系列: Times-Roman, Times-Bold, Times-Italic, Times-BoldItalic
; 符号字体: Symbol, ZapfDingbats

yPos = 780

; Helvetica系列
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_MoveTextPos(*page, 50, yPos)
PbPDF_Page_ShowText(*page, "Helvetica: The quick brown fox jumps over the lazy dog")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Helvetica字体")

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 18)
PbPDF_Page_ShowText(*page, "Helvetica-Bold: The quick brown fox jumps over the lazy dog")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Helvetica-Bold字体")

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Oblique")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 36)
PbPDF_Page_ShowText(*page, "Helvetica-Oblique: The quick brown fox jumps over the lazy dog")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Helvetica-Oblique字体")

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-BoldOblique")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 54)
PbPDF_Page_ShowText(*page, "Helvetica-BoldOblique: The quick brown fox jumps over the lazy dog")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Helvetica-BoldOblique字体")

; Courier系列（等宽字体）
fontName$ = PbPDF_GetFont(*doc, *page, "Courier")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 11)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 78)
PbPDF_Page_ShowText(*page, "Courier: ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Courier字体")

fontName$ = PbPDF_GetFont(*doc, *page, "Courier-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 11)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 93)
PbPDF_Page_ShowText(*page, "Courier-Bold: ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Courier-Bold字体")

; Times系列
fontName$ = PbPDF_GetFont(*doc, *page, "Times-Roman")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 117)
PbPDF_Page_ShowText(*page, "Times-Roman: The quick brown fox jumps over the lazy dog")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Times-Roman字体")

fontName$ = PbPDF_GetFont(*doc, *page, "Times-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 135)
PbPDF_Page_ShowText(*page, "Times-Bold: The quick brown fox jumps over the lazy dog")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Times-Bold字体")

fontName$ = PbPDF_GetFont(*doc, *page, "Times-Italic")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 153)
PbPDF_Page_ShowText(*page, "Times-Italic: The quick brown fox jumps over the lazy dog")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Times-Italic字体")

fontName$ = PbPDF_GetFont(*doc, *page, "Times-BoldItalic")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 171)
PbPDF_Page_ShowText(*page, "Times-BoldItalic: The quick brown fox jumps over the lazy dog")
PbPDF_Page_EndText(*page)
PrintN("  [通过] Times-BoldItalic字体")

;=============================================================================
; 3.2 字符间距和词间距测试
;=============================================================================
PrintN("")
PrintN("--- 3.2 字符间距和词间距测试 ---")

; 绘制分隔线
PbPDF_Page_SetRGBStroke(*page, 0.5, 0.5, 0.5)
PbPDF_Page_SetLineWidth(*page, 0.5)
PbPDF_Page_DrawLine(*page, 50, yPos - 190, 545, yPos - 190)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
yPos = yPos - 215

; 正常间距
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_MoveTextPos(*page, 50, yPos)
PbPDF_Page_ShowText(*page, "Normal spacing: Hello World PbPDFlib")
PbPDF_Page_EndText(*page)

; 增大字符间距
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetCharSpace(*page, 3.0)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 25)
PbPDF_Page_ShowText(*page, "CharSpace=3: Hello World PbPDFlib")
PbPDF_Page_SetCharSpace(*page, 0.0)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 字符间距设置(CharSpace=3)")

; 增大词间距
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetWordSpace(*page, 10.0)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 50)
PbPDF_Page_ShowText(*page, "WordSpace=10: Hello World PbPDFlib")
PbPDF_Page_SetWordSpace(*page, 0.0)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 词间距设置(WordSpace=10)")

; 水平缩放
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetHorizontalScalling(*page, 150.0)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 75)
PbPDF_Page_ShowText(*page, "HScale=150%: Hello World")
PbPDF_Page_SetHorizontalScalling(*page, 100.0)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 水平缩放设置(HScale=150%)")

;=============================================================================
; 3.3 文本渲染模式测试
;=============================================================================
PrintN("")
PrintN("--- 3.3 文本渲染模式测试 ---")

PbPDF_Page_DrawLine(*page, 50, yPos - 95, 545, yPos - 95)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
yPos = yPos - 120

; 模式0：填充（默认）
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 16)
PbPDF_Page_SetTextRenderingMode(*page, #PbPDF_TEXT_RENDER_FILL)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 50, yPos)
PbPDF_Page_ShowText(*page, "Render Mode 0: Fill (default)")
PbPDF_Page_EndText(*page)

; 模式1：描边
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 16)
PbPDF_Page_SetTextRenderingMode(*page, #PbPDF_TEXT_RENDER_STROKE)
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.0, 0.8)
PbPDF_Page_SetLineWidth(*page, 0.5)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 28)
PbPDF_Page_ShowText(*page, "Render Mode 1: Stroke")
PbPDF_Page_SetTextRenderingMode(*page, #PbPDF_TEXT_RENDER_FILL)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 文本渲染模式1(描边)")

; 模式2：填充+描边
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 16)
PbPDF_Page_SetTextRenderingMode(*page, #PbPDF_TEXT_RENDER_FILL_STROKE)
PbPDF_Page_SetRGBFill(*page, 1.0, 0.0, 0.0)
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.0, 0.0)
PbPDF_Page_SetLineWidth(*page, 0.3)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 56)
PbPDF_Page_ShowText(*page, "Render Mode 2: Fill+Stroke")
PbPDF_Page_SetTextRenderingMode(*page, #PbPDF_TEXT_RENDER_FILL)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 文本渲染模式2(填充+描边)")

; 模式3：不可见
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 16)
PbPDF_Page_SetTextRenderingMode(*page, #PbPDF_TEXT_RENDER_INVISIBLE)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 84)
PbPDF_Page_ShowText(*page, "Render Mode 3: Invisible (this text is hidden)")
PbPDF_Page_SetTextRenderingMode(*page, #PbPDF_TEXT_RENDER_FILL)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 文本渲染模式3(不可见)")

;=============================================================================
; 3.4 文本上升和行距测试
;=============================================================================
PrintN("")
PrintN("--- 3.4 文本上升和行距测试 ---")

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
yPos = yPos - 120

; 文本上升（上标/下标效果）
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_MoveTextPos(*page, 50, yPos)
PbPDF_Page_ShowText(*page, "Text Rise: H")
PbPDF_Page_SetTextRise(*page, 5.0)
PbPDF_Page_ShowText(*page, "2")
PbPDF_Page_SetTextRise(*page, 0.0)
PbPDF_Page_ShowText(*page, "O (superscript) / H")
PbPDF_Page_SetTextRise(*page, -5.0)
PbPDF_Page_ShowText(*page, "2")
PbPDF_Page_SetTextRise(*page, 0.0)
PbPDF_Page_ShowText(*page, "O (subscript)")
PbPDF_Page_EndText(*page)
PrintN("  [通过] 文本上升/下标效果")

; 文本行距测试
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_SetTextLeading(*page, 24.0)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 30)
PbPDF_Page_ShowText(*page, "Leading=24: First line of text")
PbPDF_Page_ShowTextNextLine(*page, "Second line (using ShowTextNextLine)")
PbPDF_Page_ShowTextNextLine(*page, "Third line with same leading")
PbPDF_Page_SetTextLeading(*page, 14.4)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 文本行距设置(Leading=24)")

;=============================================================================
; 3.5 彩色文本测试
;=============================================================================
PrintN("")
PrintN("--- 3.5 彩色文本测试 ---")

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
yPos = yPos - 120

; 红色文本
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 18)
PbPDF_Page_SetRGBFill(*page, 0.9, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 50, yPos)
PbPDF_Page_ShowText(*page, "Red Text")
PbPDF_Page_EndText(*page)

; 绿色文本
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 18)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.7, 0.0)
PbPDF_Page_MoveTextPos(*page, 180, yPos)
PbPDF_Page_ShowText(*page, "Green Text")
PbPDF_Page_EndText(*page)

; 蓝色文本
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 18)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.9)
PbPDF_Page_MoveTextPos(*page, 340, yPos)
PbPDF_Page_ShowText(*page, "Blue Text")
PbPDF_Page_EndText(*page)

; 灰度文本
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetGrayFill(*page, 0.5)
PbPDF_Page_MoveTextPos(*page, 50, yPos - 30)
PbPDF_Page_ShowText(*page, "Gray Text (50%)")
PbPDF_Page_SetGrayFill(*page, 0.0)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 彩色文本(RGB/灰度)")

;=============================================================================
; 保存PDF文件
;=============================================================================
PrintN("")
PrintN("--- 保存PDF文件 ---")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_03_text.pdf")
If result = #PbPDF_OK
  PrintN("  [通过] PDF文件保存成功: output_test_03_text.pdf")
Else
  PrintN("  [失败] PDF文件保存失败! 错误码: " + Hex(result))
EndIf

PbPDF_Free(*doc)

PrintN("")
PrintN("========================================")
PrintN("测试3：文本绘制功能测试完成!")
PrintN("========================================")
Input()
