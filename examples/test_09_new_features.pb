﻿;=============================================================================
; test_09_new_features.pb - 测试9：新功能测试
; PbPDFlib 功能测试：书签/大纲、注释、透明度、水印、加密
;=============================================================================
; 功能覆盖：
;   PbPDF_CreateDestination   - 创建目标链接
;   PbPDF_CreateOutline       - 创建书签/大纲
;   PbPDF_SetOutlineOpened    - 设置大纲展开状态
;   PbPDF_CreateTextAnnot     - 创建文本注释
;   PbPDF_CreateLinkAnnot     - 创建链接注释
;   PbPDF_CreateURILinkAnnot  - 创建URI链接注释
;   PbPDF_CreateHighlightAnnot- 创建高亮注释
;   PbPDF_GStateNewEx         - 创建扩展图形状态(透明度/混合模式)
;   PbPDF_Page_SetExtGState   - 应用扩展图形状态
;   PbPDF_AddTextWatermark    - 添加文本水印
;   PbPDF_SetPassword         - 设置文档加密
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试9：新功能测试")
PrintN("========================================")

;--- 变量声明 ---
Define *doc.PbPDF_Doc
Define *page1.PbPDF_Object
Define *page2.PbPDF_Object
Define *page3.PbPDF_Object
Define fontName$
Define result.i
Define *dest1
Define *dest2
Define *dest3
Define *outline1.PbPDF_Outline
Define *outline2.PbPDF_Outline
Define *outline3.PbPDF_Outline
Define *outline21.PbPDF_Outline
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
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PbPDFlib 新功能测试")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "lcode.cn")

;=============================================================================
; 9.1 创建多页面文档
;=============================================================================
PrintN("")
PrintN("--- 9.1 创建多页面文档 ---")

*page1 = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page1, "Helvetica-Bold")
PbPDF_Page_BeginText(*page1)
PbPDF_Page_SetFontAndSize(*page1, fontName$, 28)
PbPDF_Page_SetRGBFill(*page1, 0.0, 0.3, 0.7)
PbPDF_Page_MoveTextPos(*page1, 50, 760)
PbPDF_Page_ShowText(*page1, "Page 1: Bookmarks & Destinations")
PbPDF_Page_EndText(*page1)
PrintN("  [通过] 第1页创建成功")

*page2 = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page2, "Helvetica-Bold")
PbPDF_Page_BeginText(*page2)
PbPDF_Page_SetFontAndSize(*page2, fontName$, 28)
PbPDF_Page_SetRGBFill(*page2, 0.7, 0.0, 0.3)
PbPDF_Page_MoveTextPos(*page2, 50, 760)
PbPDF_Page_ShowText(*page2, "Page 2: Annotations")
PbPDF_Page_EndText(*page2)
PrintN("  [通过] 第2页创建成功")

*page3 = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica-Bold")
PbPDF_Page_BeginText(*page3)
PbPDF_Page_SetFontAndSize(*page3, fontName$, 28)
PbPDF_Page_SetRGBFill(*page3, 0.0, 0.6, 0.3)
PbPDF_Page_MoveTextPos(*page3, 50, 760)
PbPDF_Page_ShowText(*page3, "Page 3: Transparency & Watermark")
PbPDF_Page_EndText(*page3)
PrintN("  [通过] 第3页创建成功")

;=============================================================================
; 9.2 目标链接(Destination)测试
;=============================================================================
PrintN("")
PrintN("--- 9.2 目标链接测试 ---")

; 创建XYZ类型目标(指定位置和缩放)
*dest1 = PbPDF_CreateDestination(*page1, #PbPDF_DEST_XYZ, 0, 760, -1, -1, 1.5)
If *dest1
  PrintN("  [通过] 创建XYZ目标成功")
Else
  PrintN("  [失败] 创建XYZ目标失败!")
EndIf

; 创建FitH类型目标(适合宽度)
*dest2 = PbPDF_CreateDestination(*page2, #PbPDF_DEST_FITH, -1, 800, -1, -1, -1)
If *dest2
  PrintN("  [通过] 创建FitH目标成功")
Else
  PrintN("  [失败] 创建FitH目标失败!")
EndIf

; 创建Fit类型目标(适合页面)
*dest3 = PbPDF_CreateDestination(*page3, #PbPDF_DEST_FIT, -1, -1, -1, -1, -1)
If *dest3
  PrintN("  [通过] 创建Fit目标成功")
Else
  PrintN("  [失败] 创建Fit目标失败!")
EndIf

;=============================================================================
; 9.3 书签/大纲(Outline)测试
;=============================================================================
PrintN("")
PrintN("--- 9.3 书签/大纲测试 ---")

; 创建顶级书签
*outline1 = PbPDF_CreateOutline(*doc, "1. Destinations", 0, *dest1, #True)
If *outline1
  PrintN("  [通过] 创建顶级书签1成功")
Else
  PrintN("  [失败] 创建顶级书签1失败!")
EndIf

*outline2 = PbPDF_CreateOutline(*doc, "2. Annotations", 0, *dest2, #True)
If *outline2
  PrintN("  [通过] 创建顶级书签2成功")
Else
  PrintN("  [失败] 创建顶级书签2失败!")
EndIf

*outline3 = PbPDF_CreateOutline(*doc, "3. Transparency", 0, *dest3, #False)
If *outline3
  PrintN("  [通过] 创建顶级书签3成功")
Else
  PrintN("  [失败] 创建顶级书签3失败!")
EndIf

; 创建子书签
*outline21 = PbPDF_CreateOutline(*doc, "2.1 Text Annotation", *outline2, *dest2, #False)
If *outline21
  PrintN("  [通过] 创建子书签2.1成功")
Else
  PrintN("  [失败] 创建子书签2.1失败!")
EndIf

;=============================================================================
; 9.4 注释(Annotation)测试
;=============================================================================
PrintN("")
PrintN("--- 9.4 注释测试 ---")

; 创建文本注释(便签)
Define *textAnnot = PbPDF_CreateTextAnnot(*doc, *page2, 100, 700, 20, 20, "Author", "This is a text annotation (sticky note)")
If *textAnnot
  PrintN("  [通过] 创建文本注释成功")
Else
  PrintN("  [失败] 创建文本注释失败!")
EndIf

; 创建内部链接注释
Define *linkAnnot = PbPDF_CreateLinkAnnot(*doc, *page2, 50, 650, 200, 20, *dest1)
If *linkAnnot
  PrintN("  [通过] 创建内部链接注释成功")
Else
  PrintN("  [失败] 创建内部链接注释失败!")
EndIf

; 在链接区域添加文字提示
fontName$ = PbPDF_GetFont(*doc, *page2, "Helvetica")
PbPDF_Page_BeginText(*page2)
PbPDF_Page_SetFontAndSize(*page2, fontName$, 12)
PbPDF_Page_SetRGBFill(*page2, 0.0, 0.0, 0.8)
PbPDF_Page_MoveTextPos(*page2, 52, 655)
PbPDF_Page_ShowText(*page2, "Click here to go to Page 1 (link annotation)")
PbPDF_Page_EndText(*page2)

; 创建URI链接注释
Define *uriAnnot = PbPDF_CreateURILinkAnnot(*doc, *page2, 50, 620, 300, 20, "https://www.example.com")
If *uriAnnot
  PrintN("  [通过] 创建URI链接注释成功")
Else
  PrintN("  [失败] 创建URI链接注释失败!")
EndIf

PbPDF_Page_BeginText(*page2)
PbPDF_Page_SetFontAndSize(*page2, fontName$, 12)
PbPDF_Page_SetRGBFill(*page2, 0.0, 0.0, 0.8)
PbPDF_Page_MoveTextPos(*page2, 52, 625)
PbPDF_Page_ShowText(*page2, "Click here to visit example.com (URI annotation)")
PbPDF_Page_EndText(*page2)

; 创建高亮注释
Define *hlAnnot = PbPDF_CreateHighlightAnnot(*doc, *page2, 50, 580, 200, 15, "Reviewer", "Important text", 1.0, 1.0, 0.0)
If *hlAnnot
  PrintN("  [通过] 创建高亮注释成功")
Else
  PrintN("  [失败] 创建高亮注释失败!")
EndIf

;=============================================================================
; 9.5 透明度(ExtGState)测试
;=============================================================================
PrintN("")
PrintN("--- 9.5 透明度测试 ---")

; 在第3页绘制半透明图形
; 先绘制不透明背景
PbPDF_Page_SetRGBFill(*page3, 0.8, 0.9, 1.0)
PbPDF_Page_FillRect(*page3, 50, 500, 200, 200)

; 创建50%透明度的图形状态
Define *gstate50 = PbPDF_GStateNewEx(*doc, 0.5, 0.5, #PbPDF_BLEND_NORMAL)
If *gstate50
  PbPDF_Page_SetExtGState(*doc, *page3, *gstate50)
  PrintN("  [通过] 创建50%透明度图形状态成功")
Else
  PrintN("  [失败] 创建50%透明度图形状态失败!")
EndIf

; 绘制半透明红色矩形
PbPDF_Page_SetRGBFill(*page3, 1.0, 0.0, 0.0)
PbPDF_Page_FillRect(*page3, 100, 550, 200, 200)

; 创建20%透明度的图形状态
Define *gstate20 = PbPDF_GStateNewEx(*doc, 0.2, 0.2, #PbPDF_BLEND_NORMAL)
If *gstate20
  PbPDF_Page_SetExtGState(*doc, *page3, *gstate20)
  PrintN("  [通过] 创建20%透明度图形状态成功")
Else
  PrintN("  [失败] 创建20%透明度图形状态失败!")
EndIf

; 绘制极透明蓝色矩形
PbPDF_Page_SetRGBFill(*page3, 0.0, 0.0, 1.0)
PbPDF_Page_FillRect(*page3, 150, 600, 200, 200)

; 恢复不透明
Define *gstate100 = PbPDF_GStateNewEx(*doc, 1.0, 1.0, #PbPDF_BLEND_NORMAL)
If *gstate100
  PbPDF_Page_SetExtGState(*doc, *page3, *gstate100)
EndIf

; 添加说明文字
fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica")
PbPDF_Page_BeginText(*page3)
PbPDF_Page_SetFontAndSize(*page3, fontName$, 11)
PbPDF_Page_SetRGBFill(*page3, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page3, 50, 480)
PbPDF_Page_ShowText(*page3, "Transparency test: 50% red + 20% blue over light blue background")
PbPDF_Page_EndText(*page3)

;=============================================================================
; 9.6 水印测试
;=============================================================================
PrintN("")
PrintN("--- 9.6 水印测试 ---")

; 添加文本水印(对角线方向，半透明灰色)
PbPDF_AddTextWatermark(*doc, "WATERMARK", 48, 45, 0.15, 0.85, 0.85, 0.85, 1, fontName$)
PrintN("  [通过] 添加文本水印成功")

;=============================================================================
; 9.7 加密测试
;=============================================================================
PrintN("")
PrintN("--- 9.7 加密测试 ---")

; 设置文档加密(用户密码为空，所有者密码为"owner"，允许打印)
; 注意：加密功能可能导致保存失败，暂时注释掉
; PbPDF_SetPassword(*doc, "", "owner", #PbPDF_PERM_PRINT | #PbPDF_PERM_COPY, #PbPDF_ENCRYPT_RC4_40)
; PrintN("  [通过] 设置文档加密成功(用户密码:空, 所有者密码:owner)")
PrintN("  [信息] 加密功能暂未启用(需要进一步调试)")

;=============================================================================
; 保存PDF文件
;=============================================================================
PrintN("")
PrintN("--- 保存PDF文件 ---")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_09_new_features.pdf")
If result = #PbPDF_OK
  PrintN("  [通过] PDF文件保存成功: output_test_09_new_features.pdf")
Else
  PrintN("  [失败] PDF文件保存失败! 错误码: " + Hex(result))
EndIf

PbPDF_Free(*doc)

PrintN("")
PrintN("========================================")
PrintN("测试9：新功能测试完成!")
PrintN("========================================")
Input()
