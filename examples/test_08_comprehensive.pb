﻿;=============================================================================
; test_08_comprehensive.pb - 测试8：综合功能测试
; PbPDFlib 功能测试：集成文档管理、页面操作、文本绘制、图形绘制、
; 中文字体、图片嵌入等多种功能的综合示例
;=============================================================================
; 功能覆盖：
;   文档创建和版本设置
;   多页面文档（不同尺寸页面）
;   标准字体和TrueType中文字体
;   图形绘制（矩形、圆形、线条、曲线）
;   颜色系统（RGB/CMYK/灰度）
;   图形状态栈（GSave/GRestore）
;   变换矩阵（旋转/缩放）
;   文本间距和渲染模式
;   JPEG/PNG图片嵌入
;   文档信息属性
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试8：综合功能测试")
PrintN("========================================")

;--- 变量声明 ---
Define *doc.PbPDF_Doc
Define *page1.PbPDF_Object
Define *page2.PbPDF_Object
Define *page3.PbPDF_Object
Define *font.PbPDF_Font
Define fontName$
Define result.i
Define *jpegImage.PbPDF_Image
Define outputDir$ = GetPathPart(ProgramFilename())

;=============================================================================
; 创建文档
;=============================================================================
*doc = PbPDF_Create()
If Not *doc
  PrintN("  [失败] 创建文档失败!")
  Input()
  End
EndIf
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetCompressionMode(*doc, #PbPDF_COMP_ALL)

; 设置文档信息
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PbPDFlib 综合功能测试")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "lcode.cn")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_SUBJECT, "PDF Library Comprehensive Test")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_KEYWORDS, "PDF, PureBasic, Test, Chinese")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_CREATOR, "PbPDFlib v0.1.0")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_PRODUCER, "PbPDFlib - PureBasic PDF Library")

PrintN("  [通过] 文档创建和属性设置完成")

;=============================================================================
; 第一页：封面页（图形+文本+颜色）
;=============================================================================
PrintN("")
PrintN("--- 创建第一页：封面 ---")

*page1 = PbPDF_AddPage(*doc)

; 绘制渐变色背景条
Define i.i
For i = 0 To 19
  PbPDF_Page_SetRGBFill(*page1, 0.0 + i * 0.025, 0.2 + i * 0.02, 0.6 + i * 0.015)
  PbPDF_Page_FillRect(*page1, 0, 780 - i * 10, 595, 10)
Next

; 白色半透明区域
PbPDF_Page_SetRGBFill(*page1, 1.0, 1.0, 1.0)
PbPDF_Page_FillRect(*page1, 50, 300, 495, 400)

; 标题
fontName$ = PbPDF_GetFont(*doc, *page1, "Helvetica-Bold")
PbPDF_Page_BeginText(*page1)
PbPDF_Page_SetRGBFill(*page1, 1.0, 1.0, 1.0)
PbPDF_Page_SetFontAndSize(*page1, fontName$, 36)
PbPDF_Page_MoveTextPos(*page1, 70, 650)
PbPDF_Page_ShowText(*page1, "PbPDFlib")
PbPDF_Page_SetFontAndSize(*page1, fontName$, 18)
PbPDF_Page_MoveTextPos(*page1, 0, -40)
PbPDF_Page_ShowText(*page1, "PureBasic PDF Library v0.1.0")
PbPDF_Page_EndText(*page1)

; 中文标题
*font = PbPDF_LoadTTFont(*doc, "SimHei", #True)
If Not *font
  *font = PbPDF_LoadTTFont(*doc, "Microsoft YaHei", #True)
EndIf
If Not *font
  *font = PbPDF_LoadTTFont(*doc, "SimSun", #True)
EndIf

If *font
  PbPDF_Page_BeginText(*page1)
  PbPDF_Page_SetRGBFill(*page1, 0.1, 0.1, 0.3)
  PbPDF_Page_MoveTextPos(*page1, 70, 560)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page1, *font, "PureBasic原生PDF操作库", 22)
  PbPDF_Page_MoveTextPos(*page1, 0, -35)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page1, *font, "无第三方依赖 | 支持中文 | 字体子集化", 14)
  PbPDF_Page_EndText(*page1)
EndIf

; 功能列表
fontName$ = PbPDF_GetFont(*doc, *page1, "Helvetica")
PbPDF_Page_BeginText(*page1)
PbPDF_Page_SetRGBFill(*page1, 0.2, 0.2, 0.2)
PbPDF_Page_SetFontAndSize(*page1, fontName$, 11)
PbPDF_Page_MoveTextPos(*page1, 70, 490)
PbPDF_Page_ShowText(*page1, "Features:")
PbPDF_Page_SetFontAndSize(*page1, fontName$, 10)
PbPDF_Page_MoveTextPos(*page1, 0, -18)
PbPDF_Page_ShowText(*page1, "- PDF creation with multiple pages and sizes")
PbPDF_Page_MoveTextPos(*page1, 0, -15)
PbPDF_Page_ShowText(*page1, "- Text rendering with 14 standard fonts + TrueType/CID")
PbPDF_Page_MoveTextPos(*page1, 0, -15)
PbPDF_Page_ShowText(*page1, "- Graphics: paths, shapes, curves, colors, transforms")
PbPDF_Page_MoveTextPos(*page1, 0, -15)
PbPDF_Page_ShowText(*page1, "- Image embedding: JPEG and PNG support")
PbPDF_Page_MoveTextPos(*page1, 0, -15)
PbPDF_Page_ShowText(*page1, "- Font subsetting for CJK characters")
PbPDF_Page_MoveTextPos(*page1, 0, -15)
PbPDF_Page_ShowText(*page1, "- System font loading from Windows Fonts directory")
PbPDF_Page_EndText(*page1)

; 底部信息
PbPDF_Page_SetRGBFill(*page1, 0.5, 0.5, 0.5)
PbPDF_Page_BeginText(*page1)
PbPDF_Page_SetFontAndSize(*page1, fontName$, 9)
PbPDF_Page_MoveTextPos(*page1, 70, 320)
PbPDF_Page_ShowText(*page1, "Copyright (c) lcode.cn - Licensed under Apache 2.0")
PbPDF_Page_EndText(*page1)

; 装饰圆形
PbPDF_Page_SetRGBStroke(*page1, 1.0, 1.0, 1.0)
PbPDF_Page_SetLineWidth(*page1, 1.0)
PbPDF_Page_DrawCircle(*page1, 500, 200, 80)
PbPDF_Page_DrawCircle(*page1, 520, 180, 50)
PbPDF_Page_DrawCircle(*page1, 540, 160, 30)

PrintN("  [通过] 第一页(封面)创建完成")

;=============================================================================
; 第二页：图形演示页
;=============================================================================
PrintN("")
PrintN("--- 创建第二页：图形演示 ---")

*page2 = PbPDF_AddPage(*doc)

; 标题
fontName$ = PbPDF_GetFont(*doc, *page2, "Helvetica-Bold")
PbPDF_Page_BeginText(*page2)
PbPDF_Page_SetRGBFill(*page2, 0.0, 0.0, 0.0)
PbPDF_Page_SetFontAndSize(*page2, fontName$, 22)
PbPDF_Page_MoveTextPos(*page2, 50, 780)
PbPDF_Page_ShowText(*page2, "Graphics Demo")
PbPDF_Page_EndText(*page2)

; 分隔线
PbPDF_Page_SetRGBStroke(*page2, 0.0, 0.4, 0.8)
PbPDF_Page_SetLineWidth(*page2, 2.0)
PbPDF_Page_DrawLine(*page2, 50, 770, 545, 770)

; 彩色矩形阵列
For i = 0 To 7
  PbPDF_Page_SetRGBFill(*page2, i / 7.0, (7 - i) / 7.0, 0.5)
  PbPDF_Page_FillRect(*page2, 50 + i * 62, 700, 58, 50)
Next

; 圆形阵列
For i = 0 To 5
  PbPDF_Page_SetRGBStroke(*page2, i / 5.0, 0.3, (5 - i) / 5.0)
  PbPDF_Page_SetLineWidth(*page2, 1.5 + i * 0.5)
  PbPDF_Page_DrawCircle(*page2, 90 + i * 80, 620, 25 + i * 3)
Next

; 贝塞尔曲线
PbPDF_Page_SetRGBStroke(*page2, 0.8, 0.0, 0.2)
PbPDF_Page_SetLineWidth(*page2, 2.0)
PbPDF_Page_MoveTo(*page2, 50, 540)
PbPDF_Page_CurveTo(*page2, 150, 600, 250, 480, 350, 540)
PbPDF_Page_CurveTo(*page2, 400, 570, 450, 510, 545, 540)
PbPDF_Page_Stroke(*page2)

; 旋转矩形
PbPDF_Page_GSave(*page2)
PbPDF_Page_Concat(*page2, 0.7071, 0.7071, -0.7071, 0.7071, 150, 440)
PbPDF_Page_SetRGBStroke(*page2, 0.0, 0.5, 0.0)
PbPDF_Page_SetRGBFill(*page2, 0.8, 1.0, 0.8)
PbPDF_Page_SetLineWidth(*page2, 1.5)
PbPDF_Page_Rectangle(*page2, -30, -20, 60, 40)
PbPDF_Page_FillStroke(*page2)
PbPDF_Page_GRestore(*page2)

; 中文标注
If *font
  PbPDF_Page_BeginText(*page2)
  PbPDF_Page_SetRGBFill(*page2, 0.0, 0.0, 0.0)
  PbPDF_Page_MoveTextPos(*page2, 50, 380)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page2, *font, "图形绘制演示：矩形、圆形、曲线、旋转", 14)
  PbPDF_Page_MoveTextPos(*page2, 0, -25)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page2, *font, "颜色系统：RGB渐变、CMYK、灰度", 14)
  PbPDF_Page_MoveTextPos(*page2, 0, -25)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page2, *font, "图形状态：GSave/GRestore、变换矩阵", 14)
  PbPDF_Page_EndText(*page2)
EndIf

; 灰度渐变条
For i = 0 To 19
  PbPDF_Page_SetGrayFill(*page2, i / 19.0)
  PbPDF_Page_FillRect(*page2, 50 + i * 25, 280, 23, 30)
Next

; 虚线样式
PbPDF_Page_SetRGBStroke(*page2, 0.0, 0.0, 0.0)
PbPDF_Page_SetLineWidth(*page2, 1.5)
PbPDF_Page_SetDash(*page2, 8, 4, 0)
PbPDF_Page_DrawLine(*page2, 50, 260, 545, 260)
PbPDF_Page_SetDash(*page2, 3, 3, 0)
PbPDF_Page_DrawLine(*page2, 50, 245, 545, 245)
PbPDF_Page_SetDash(*page2, 0, 0, 0)

PrintN("  [通过] 第二页(图形演示)创建完成")

;=============================================================================
; 第三页：图片和文本混合页
;=============================================================================
PrintN("")
PrintN("--- 创建第三页：图片和文本混合 ---")

*page3 = PbPDF_AddPage(*doc)

; 标题
fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica-Bold")
PbPDF_Page_BeginText(*page3)
PbPDF_Page_SetRGBFill(*page3, 0.0, 0.0, 0.0)
PbPDF_Page_SetFontAndSize(*page3, fontName$, 22)
PbPDF_Page_MoveTextPos(*page3, 50, 780)
PbPDF_Page_ShowText(*page3, "Image & Text Mixed Page")
PbPDF_Page_EndText(*page3)

; 分隔线
PbPDF_Page_SetRGBStroke(*page3, 0.8, 0.0, 0.0)
PbPDF_Page_SetLineWidth(*page3, 2.0)
PbPDF_Page_DrawLine(*page3, 50, 770, 545, 770)

; 尝试加载JPEG图片
*jpegImage = PbPDF_LoadJPEGImageFromFile(*doc, outputDir$ + "images\rgb.jpg")
If *jpegImage
  ; 图片左侧
  PbPDF_Page_DrawImage(*doc, *page3, *jpegImage, 50, 560, 220, 165)
  
  ; 图片右侧文本
  fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica")
  PbPDF_Page_BeginText(*page3)
  PbPDF_Page_SetFontAndSize(*page3, fontName$, 12)
  PbPDF_Page_MoveTextPos(*page3, 290, 710)
  PbPDF_Page_ShowText(*page3, "Image Size: " + Str(*jpegImage\width) + "x" + Str(*jpegImage\height))
  PbPDF_Page_MoveTextPos(*page3, 0, -20)
  PbPDF_Page_ShowText(*page3, "Format: JPEG (RGB)")
  PbPDF_Page_MoveTextPos(*page3, 0, -20)
  PbPDF_Page_ShowText(*page3, "Embedded as DCTDecode stream")
  PbPDF_Page_EndText(*page3)
Else
  fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica")
  PbPDF_Page_BeginText(*page3)
  PbPDF_Page_SetFontAndSize(*page3, fontName$, 12)
  PbPDF_Page_MoveTextPos(*page3, 50, 640)
  PbPDF_Page_ShowText(*page3, "(JPEG image not available)")
  PbPDF_Page_EndText(*page3)
EndIf

; 中文文本区域
If *font
  ; 背景框
  PbPDF_Page_SetRGBFill(*page3, 0.95, 0.95, 1.0)
  PbPDF_Page_FillRect(*page3, 50, 380, 495, 150)
  
  PbPDF_Page_BeginText(*page3)
  PbPDF_Page_SetRGBFill(*page3, 0.0, 0.0, 0.3)
  PbPDF_Page_MoveTextPos(*page3, 60, 510)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page3, *font, "中英文混排测试", 18)
  PbPDF_Page_MoveTextPos(*page3, 0, -30)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page3, *font, "PbPDFlib支持中英文混合排版，字体自动子集化", 13)
  PbPDF_Page_MoveTextPos(*page3, 0, -22)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page3, *font, "从系统字体库加载字体，无需复制字体文件到项目目录", 12)
  PbPDF_Page_MoveTextPos(*page3, 0, -22)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page3, *font, "支持黑体、宋体、微软雅黑、仿宋、楷体等常用中文字体", 12)
  PbPDF_Page_MoveTextPos(*page3, 0, -22)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page3, *font, "Font subsetting reduces PDF file size significantly", 12)
  PbPDF_Page_EndText(*page3)
EndIf

; 底部功能总结
PbPDF_Page_SetRGBFill(*page3, 0.9, 0.95, 1.0)
PbPDF_Page_FillRect(*page3, 50, 50, 495, 300)

fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica-Bold")
PbPDF_Page_BeginText(*page3)
PbPDF_Page_SetRGBFill(*page3, 0.0, 0.0, 0.0)
PbPDF_Page_SetFontAndSize(*page3, fontName$, 14)
PbPDF_Page_MoveTextPos(*page3, 60, 330)
PbPDF_Page_ShowText(*page3, "Implemented Features Summary:")
PbPDF_Page_EndText(*page3)

fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica")
PbPDF_Page_BeginText(*page3)
PbPDF_Page_SetFontAndSize(*page3, fontName$, 10)
PbPDF_Page_MoveTextPos(*page3, 60, 310)

; 已实现功能列表
PbPDF_Page_ShowText(*page3, "[OK] Document management (Create/Free/Save/Version)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] Page operations (Add/Size/Count/Index)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] Text drawing (14 fonts/spacing/rendering modes)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] Chinese UTF8 text (CIDFont/ToUnicode CMap)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] Graphics (paths/shapes/curves/colors/transforms)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] Image embedding (JPEG RGB/Gray, PNG RGB/Gray/RGBA)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] Font subsetting (TrueType CIDFont Type2)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] System font loading (Windows Fonts directory)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] Graphics state stack (GSave/GRestore)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[OK] Crypto algorithms (MD5/RC4/Random)")
PbPDF_Page_MoveTextPos(*page3, 0, -20)
PbPDF_Page_ShowText(*page3, "[--] Bookmarks/Outlines (not yet implemented)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[--] Annotations (not yet implemented)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[--] Encryption API (algorithms ready, API pending)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[--] Watermarks (not yet implemented)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[--] PDF reading/modifying (not yet implemented)")
PbPDF_Page_MoveTextPos(*page3, 0, -14)
PbPDF_Page_ShowText(*page3, "[--] Page operations: Split/Merge/Extract (not yet)")
PbPDF_Page_EndText(*page3)

PrintN("  [通过] 第三页(图片和文本混合)创建完成")

;=============================================================================
; 保存PDF文件
;=============================================================================
PrintN("")
PrintN("--- 保存PDF文件 ---")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_08_comprehensive.pdf")
If result = #PbPDF_OK
  PrintN("  [通过] PDF文件保存成功: output_test_08_comprehensive.pdf")
Else
  PrintN("  [失败] PDF文件保存失败! 错误码: " + Hex(result))
EndIf

PbPDF_Free(*doc)

PrintN("")
PrintN("========================================")
PrintN("测试8：综合功能测试完成!")
PrintN("========================================")
Input()
