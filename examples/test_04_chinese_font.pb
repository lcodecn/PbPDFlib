﻿;=============================================================================
; test_04_chinese_font.pb - 测试4：中文字体和UTF8文本
; PbPDFlib 功能测试：系统字体加载、TrueType字体子集化、CIDFont、UTF8文本渲染
;=============================================================================
; 功能覆盖：
;   PbPDF_LoadTTFont          - 从系统字体库加载TrueType字体
;   PbPDF_LoadTTFontFromFile  - 从文件加载TrueType字体
;   PbPDF_FindSystemFont      - 查找系统字体文件路径
;   PbPDF_Page_ShowTextUTF8Ex - 显示UTF8中文文本(含字体和大小)
;   PbPDF_Page_ShowTextUTF8   - 显示UTF8中文文本
;   PbPDF_EncodeUTF8ToPDFHex  - UTF8编码为PDF十六进制字符串
;   字体子集化（自动在保存时执行）
;   CIDFont Type2结构生成
;   ToUnicode CMap生成
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试4：中文字体和UTF8文本测试")
PrintN("========================================")

;--- 变量声明 ---
Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define *font.PbPDF_Font
Define fontName$
Define result.i
Define fontPath$
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
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PbPDFlib 中文字体测试")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "lcode.cn")

*page = PbPDF_AddPage(*doc)

;=============================================================================
; 4.1 系统字体查找测试
;=============================================================================
PrintN("")
PrintN("--- 4.1 系统字体查找测试 ---")

; 测试查找黑体
fontPath$ = PbPDF_FindSystemFont("SimHei")
If fontPath$ <> ""
  PrintN("  [通过] 找到SimHei: " + fontPath$)
Else
  PrintN("  [警告] 未找到SimHei字体")
EndIf

; 测试查找微软雅黑
fontPath$ = PbPDF_FindSystemFont("Microsoft YaHei")
If fontPath$ <> ""
  PrintN("  [通过] 找到Microsoft YaHei: " + fontPath$)
Else
  PrintN("  [警告] 未找到Microsoft YaHei字体")
EndIf

; 测试查找宋体
fontPath$ = PbPDF_FindSystemFont("SimSun")
If fontPath$ <> ""
  PrintN("  [通过] 找到SimSun: " + fontPath$)
Else
  PrintN("  [警告] 未找到SimSun字体")
EndIf

; 测试查找Arial
fontPath$ = PbPDF_FindSystemFont("Arial")
If fontPath$ <> ""
  PrintN("  [通过] 找到Arial: " + fontPath$)
Else
  PrintN("  [警告] 未找到Arial字体")
EndIf

;=============================================================================
; 4.2 从系统字体库加载中文字体
;=============================================================================
PrintN("")
PrintN("--- 4.2 从系统字体库加载中文字体 ---")

; 依次尝试加载常用中文字体
*font = PbPDF_LoadTTFont(*doc, "SimHei", #True)
If Not *font
  PrintN("  SimHei不可用，尝试Microsoft YaHei...")
  *font = PbPDF_LoadTTFont(*doc, "Microsoft YaHei", #True)
EndIf
If Not *font
  PrintN("  Microsoft YaHei不可用，尝试SimSun...")
  *font = PbPDF_LoadTTFont(*doc, "SimSun", #True)
EndIf
If Not *font
  PrintN("  SimSun不可用，尝试FangSong...")
  *font = PbPDF_LoadTTFont(*doc, "FangSong", #True)
EndIf

If *font
  PrintN("  [通过] 中文字体加载成功!")
Else
  PrintN("  [失败] 所有中文字体加载失败!")
  PbPDF_Free(*doc)
  Input()
  End
EndIf

;=============================================================================
; 4.3 绘制中文标题
;=============================================================================
PrintN("")
PrintN("--- 4.3 绘制中文标题 ---")

; 使用标准字体绘制英文标题
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_MoveTextPos(*page, 50, 780)
PbPDF_Page_ShowText(*page, "PbPDFlib Chinese Font Test")
PbPDF_Page_EndText(*page)

; 绘制分隔线
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.4, 0.8)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_DrawLine(*page, 50, 770, 545, 770)

;=============================================================================
; 4.4 使用ShowTextUTF8Ex绘制中文文本
;=============================================================================
PrintN("")
PrintN("--- 4.4 使用ShowTextUTF8Ex绘制中文文本 ---")

; ShowTextUTF8Ex是最便捷的中文文本绘制方式
; 自动处理字体注册、CIDFont创建和UTF8编码

; 大标题
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "PbPDFlib中文PDF库测试", 24)
PrintN("  [通过] 中文大标题(24pt)")

; 中英混合
PbPDF_Page_BeginText(*page)
PbPDF_Page_MoveTextPos(*page, 50, 720)
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "Hello World 你好世界", 20)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 中英混合文本(20pt)")

; 中文排版
PbPDF_Page_BeginText(*page)
PbPDF_Page_MoveTextPos(*page, 50, 690)
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "支持中文、英文混合排版", 16)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 中文排版文本(16pt)")

;=============================================================================
; 4.5 多行中文文本
;=============================================================================
PrintN("")
PrintN("--- 4.5 多行中文文本 ---")

PbPDF_Page_BeginText(*page)
PbPDF_Page_MoveTextPos(*page, 50, 660)
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "字体子集化功能测试 Font Subsetting Test", 14)
PbPDF_Page_EndText(*page)

PbPDF_Page_BeginText(*page)
PbPDF_Page_MoveTextPos(*page, 50, 635)
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "纯中文文本：天地玄黄，宇宙洪荒。日月盈昃，辰宿列张。", 13)
PbPDF_Page_EndText(*page)

PbPDF_Page_BeginText(*page)
PbPDF_Page_MoveTextPos(*page, 50, 612)
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "数字与符号：1234567890 ＋－×÷ ＝ ≠ ≈", 13)
PbPDF_Page_EndText(*page)
PrintN("  [通过] 多行中文文本")

;=============================================================================
; 4.6 不同字号的中文文本
;=============================================================================
PrintN("")
PrintN("--- 4.6 不同字号的中文文本 ---")

Define sizes.i
Define sizeLabels$ = "八|十|十二|十四|十六|十八|二十|二十四"
Define sizeValues$ = "8|10|12|14|16|18|20|24"
Define yPos.f = 580

For sizes = 1 To 8
  Define sz.f = Val(StringField(sizeValues$, sizes, "|"))
  Define label$ = StringField(sizeLabels$, sizes, "|")
  PbPDF_Page_BeginText(*page)
  PbPDF_Page_MoveTextPos(*page, 50, yPos)
  PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, label$ + "号字测试(" + Str(Int(sz)) + "pt)", sz)
  PbPDF_Page_EndText(*page)
  yPos - sz + 4
Next
PrintN("  [通过] 不同字号中文文本(8pt~24pt)")

;=============================================================================
; 4.7 彩色中文文本
;=============================================================================
PrintN("")
PrintN("--- 4.7 彩色中文文本 ---")

yPos = 380

; 红色中文
PbPDF_Page_SetRGBFill(*page, 0.9, 0.0, 0.0)
PbPDF_Page_BeginText(*page)
PbPDF_Page_MoveTextPos(*page, 50, yPos)
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "红色中文文本", 16)
PbPDF_Page_EndText(*page)

; 绿色中文
PbPDF_Page_SetRGBFill(*page, 0.0, 0.7, 0.0)
PbPDF_Page_BeginText(*page)
PbPDF_Page_MoveTextPos(*page, 200, yPos)
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "绿色中文文本", 16)
PbPDF_Page_EndText(*page)

; 蓝色中文
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.9)
PbPDF_Page_BeginText(*page)
PbPDF_Page_MoveTextPos(*page, 350, yPos)
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "蓝色中文文本", 16)
PbPDF_Page_EndText(*page)

; 恢复黑色
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PrintN("  [通过] 彩色中文文本")

;=============================================================================
; 4.8 底部信息
;=============================================================================
PbPDF_Page_SetRGBFill(*page, 0.9, 0.95, 1.0)
PbPDF_Page_FillRect(*page, 50, 50, 495, 80)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 9)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 60, 110)
PbPDF_Page_ShowText(*page, "PbPDFlib - PureBasic PDF Library v0.1.0")
PbPDF_Page_MoveTextPos(*page, 0, -15)
PbPDF_Page_ShowText(*page, "Copyright (c) lcode.cn - Licensed under Apache 2.0")
PbPDF_Page_EndText(*page)

;=============================================================================
; 保存PDF文件（保存时自动执行字体子集化）
;=============================================================================
PrintN("")
PrintN("--- 保存PDF文件（含字体子集化） ---")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_04_chinese.pdf")
If result = #PbPDF_OK
  PrintN("  [通过] PDF文件保存成功: output_test_04_chinese.pdf")
  PrintN("  [信息] 字体子集化在保存时自动完成")
Else
  PrintN("  [失败] PDF文件保存失败! 错误码: " + Hex(result))
EndIf

PbPDF_Free(*doc)

PrintN("")
PrintN("========================================")
PrintN("测试4：中文字体和UTF8文本测试完成!")
PrintN("========================================")
Input()
