﻿;=============================================================================
; test_02_page_operations.pb - 测试2：页面操作
; PbPDFlib 功能测试：页面添加、尺寸设置、多页面文档
;=============================================================================
; 功能覆盖：
;   PbPDF_AddPage              - 添加默认A4页面
;   PbPDF_AddPageA4            - 便捷添加A4页面
;   PbPDF_AddPageCustom        - 添加自定义尺寸页面
;   PbPDF_AddPagePredefined    - 添加预定义尺寸页面
;   PbPDF_Page_SetSize         - 设置页面尺寸
;   PbPDF_Page_SetPredefinedSize - 设置预定义页面尺寸
;   PbPDF_Page_GetWidth        - 获取页面宽度
;   PbPDF_Page_GetHeight       - 获取页面高度
;   PbPDF_GetPageByIndex       - 按索引获取页面
;   PbPDF_GetCurrentPage       - 获取当前页面
;   PbPDF_GetPageCount         - 获取页面总数
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试2：页面操作功能测试")
PrintN("========================================")

;--- 变量声明 ---
Define *doc.PbPDF_Doc
Define *page1.PbPDF_Object
Define *page2.PbPDF_Object
Define *page3.PbPDF_Object
Define *page4.PbPDF_Object
Define result.i
Define pageWidth.f
Define pageHeight.f
Define fontName$
Define outputDir$ = GetPathPart(ProgramFilename())

;=============================================================================
; 2.1 创建文档
;=============================================================================
*doc = PbPDF_Create()
If Not *doc
  PrintN("  [失败] 创建文档失败!")
  Input()
  End
EndIf
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PbPDFlib 页面操作测试")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "lcode.cn")

;=============================================================================
; 2.2 添加默认A4页面
;=============================================================================
PrintN("")
PrintN("--- 2.2 添加默认A4页面 ---")

*page1 = PbPDF_AddPage(*doc)
If *page1
  pageWidth = PbPDF_Page_GetWidth(*page1)
  pageHeight = PbPDF_Page_GetHeight(*page1)
  PrintN("  [通过] 添加A4页面成功，尺寸: " + StrF(pageWidth,1) + " x " + StrF(pageHeight,1))
Else
  PrintN("  [失败] 添加A4页面失败!")
EndIf

; 在第一页添加标题
fontName$ = PbPDF_GetFont(*doc, *page1, "Helvetica-Bold")
PbPDF_Page_BeginText(*page1)
PbPDF_Page_SetFontAndSize(*page1, fontName$, 28)
PbPDF_Page_MoveTextPos(*page1, 50, 760)
PbPDF_Page_ShowText(*page1, "Page 1: A4 Portrait (595 x 842)")
PbPDF_Page_EndText(*page1)

; 绘制页面边框
PbPDF_Page_SetRGBStroke(*page1, 0.8, 0.0, 0.0)
PbPDF_Page_SetLineWidth(*page1, 2.0)
PbPDF_Page_DrawRect(*page1, 30, 30, pageWidth - 60, pageHeight - 60)

;=============================================================================
; 2.3 添加A4横向页面
;=============================================================================
PrintN("")
PrintN("--- 2.3 添加A4横向页面 ---")

*page2 = PbPDF_AddPage(*doc)
If *page2
  ; 设置为A4横向
  PbPDF_Page_SetPredefinedSize(*page2, #PbPDF_PAGE_SIZE_A4, #PbPDF_PAGE_LANDSCAPE)
  pageWidth = PbPDF_Page_GetWidth(*page2)
  pageHeight = PbPDF_Page_GetHeight(*page2)
  PrintN("  [通过] 添加A4横向页面成功，尺寸: " + StrF(pageWidth,1) + " x " + StrF(pageHeight,1))
Else
  PrintN("  [失败] 添加A4横向页面失败!")
EndIf

; 在第二页添加标题
fontName$ = PbPDF_GetFont(*doc, *page2, "Helvetica-Bold")
PbPDF_Page_BeginText(*page2)
PbPDF_Page_SetFontAndSize(*page2, fontName$, 28)
PbPDF_Page_MoveTextPos(*page2, 50, 555)
PbPDF_Page_ShowText(*page2, "Page 2: A4 Landscape (842 x 595)")
PbPDF_Page_EndText(*page2)

; 绘制页面边框
PbPDF_Page_SetRGBStroke(*page2, 0.0, 0.6, 0.0)
PbPDF_Page_SetLineWidth(*page2, 2.0)
PbPDF_Page_DrawRect(*page2, 30, 30, pageWidth - 60, pageHeight - 60)

;=============================================================================
; 2.4 添加Letter尺寸页面
;=============================================================================
PrintN("")
PrintN("--- 2.4 添加Letter尺寸页面 ---")

*page3 = PbPDF_AddPage(*doc)
If *page3
  PbPDF_Page_SetPredefinedSize(*page3, #PbPDF_PAGE_SIZE_LETTER, #PbPDF_PAGE_PORTRAIT)
  pageWidth = PbPDF_Page_GetWidth(*page3)
  pageHeight = PbPDF_Page_GetHeight(*page3)
  PrintN("  [通过] 添加Letter页面成功，尺寸: " + StrF(pageWidth,1) + " x " + StrF(pageHeight,1))
Else
  PrintN("  [失败] 添加Letter页面失败!")
EndIf

fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica-Bold")
PbPDF_Page_BeginText(*page3)
PbPDF_Page_SetFontAndSize(*page3, fontName$, 28)
PbPDF_Page_MoveTextPos(*page3, 50, 730)
PbPDF_Page_ShowText(*page3, "Page 3: Letter Portrait (612 x 792)")
PbPDF_Page_EndText(*page3)

PbPDF_Page_SetRGBStroke(*page3, 0.0, 0.0, 0.8)
PbPDF_Page_SetLineWidth(*page3, 2.0)
PbPDF_Page_DrawRect(*page3, 30, 30, pageWidth - 60, pageHeight - 60)

;=============================================================================
; 2.5 添加自定义尺寸页面
;=============================================================================
PrintN("")
PrintN("--- 2.5 添加自定义尺寸页面 ---")

*page4 = PbPDF_AddPage(*doc)
If *page4
  ; 设置为正方形页面 400x400 点
  PbPDF_Page_SetSize(*page4, 400, 400)
  pageWidth = PbPDF_Page_GetWidth(*page4)
  pageHeight = PbPDF_Page_GetHeight(*page4)
  PrintN("  [通过] 添加自定义尺寸页面成功，尺寸: " + StrF(pageWidth,1) + " x " + StrF(pageHeight,1))
Else
  PrintN("  [失败] 添加自定义尺寸页面失败!")
EndIf

fontName$ = PbPDF_GetFont(*doc, *page4, "Helvetica-Bold")
PbPDF_Page_BeginText(*page4)
PbPDF_Page_SetFontAndSize(*page4, fontName$, 20)
PbPDF_Page_MoveTextPos(*page4, 50, 360)
PbPDF_Page_ShowText(*page4, "Page 4: Custom 400x400")
PbPDF_Page_EndText(*page4)

PbPDF_Page_SetRGBStroke(*page4, 0.8, 0.0, 0.8)
PbPDF_Page_SetLineWidth(*page4, 2.0)
PbPDF_Page_DrawRect(*page4, 20, 20, 360, 360)

;=============================================================================
; 2.6 验证页面总数和索引访问
;=============================================================================
PrintN("")
PrintN("--- 2.6 验证页面总数和索引访问 ---")

result = PbPDF_GetPageCount(*doc)
If result = 4
  PrintN("  [通过] 页面总数 = " + Str(result) + " (期望4)")
Else
  PrintN("  [失败] 页面总数 = " + Str(result) + " (期望4)")
EndIf

; 通过索引获取第2个页面
Define *pageByIndex.PbPDF_Object
*pageByIndex = PbPDF_GetPageByIndex(*doc, 1)
If *pageByIndex
  pageWidth = PbPDF_Page_GetWidth(*pageByIndex)
  PrintN("  [通过] 通过索引获取第2个页面，宽度 = " + StrF(pageWidth,1))
Else
  PrintN("  [失败] 通过索引获取第2个页面失败!")
EndIf

; 获取当前页面
Define *curPage.PbPDF_Object
*curPage = PbPDF_GetCurrentPage(*doc)
If *curPage
  PrintN("  [通过] 获取当前页面成功")
Else
  PrintN("  [失败] 获取当前页面失败!")
EndIf

;=============================================================================
; 2.7 保存PDF文件
;=============================================================================
PrintN("")
PrintN("--- 2.7 保存PDF文件 ---")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_02_pages.pdf")
If result = #PbPDF_OK
  PrintN("  [通过] PDF文件保存成功: output_test_02_pages.pdf")
Else
  PrintN("  [失败] PDF文件保存失败! 错误码: " + Hex(result))
EndIf

PbPDF_Free(*doc)

PrintN("")
PrintN("========================================")
PrintN("测试2：页面操作功能测试完成!")
PrintN("========================================")
Input()
