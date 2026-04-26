﻿;=============================================================================
; test_14_watermark_highlight_header.pb - 水印/高亮/页眉页脚功能测试
; 测试PbPDFlib的水印、高亮注释、页眉页脚功能
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole("PbPDFlib - 水印/高亮/页眉页脚功能测试")

Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define fontName$
Define result.i
Define outputDir$ = GetPathPart(ProgramFilename())

;--- 第1步：创建带水印的PDF ---
PrintN("=== 第1步：创建带水印的PDF ===")

*doc = PbPDF_Create()
If Not *doc
  PrintN("错误：无法创建PDF文档")
  Goto EndTest
EndIf

PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Watermark Test")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "PbPDFlib")

; 创建3个页面
*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.3, 0.7)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Page 1 - Watermark Demo")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This page has a diagonal watermark.")
PbPDF_Page_EndText(*page)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.7, 0.0, 0.3)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Page 2 - Another Watermark")
PbPDF_Page_EndText(*page)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.5, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Page 3 - Final Page")
PbPDF_Page_EndText(*page)

; 添加对角线水印（所有页面）
PbPDF_AddTextWatermark(*doc, "CONFIDENTIAL", 60, 45, 0.15, 0.8, 0.0, 0.0, 1)
PrintN("  对角线水印已添加")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_14_watermark.pdf")
If result = #PbPDF_OK
  PrintN("  水印PDF已保存：output_test_14_watermark.pdf")
Else
  PrintN("  错误：保存失败，错误码=" + Str(result))
EndIf
PbPDF_Free(*doc)

;--- 第2步：创建带高亮注释的PDF ---
PrintN("")
PrintN("=== 第2步：创建带高亮注释的PDF ===")

*doc = PbPDF_Create()
If Not *doc
  PrintN("错误：无法创建PDF文档")
  Goto EndTest
EndIf

PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Highlight Annotation Test")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "This is a sample text with highlight annotations.")
PbPDF_Page_MoveTextPos(*page, 0, -25)
PbPDF_Page_ShowText(*page, "The yellow area below is a highlight annotation.")
PbPDF_Page_MoveTextPos(*page, 0, -25)
PbPDF_Page_ShowText(*page, "You can add multiple highlights on a single page.")
PbPDF_Page_EndText(*page)

; 添加黄色高亮注释
PbPDF_CreateHighlightAnnot(*doc, *page, 100, 735, 350, 15, "Reviewer", "Important text highlighted", 1.0, 1.0, 0.0)
PrintN("  黄色高亮注释已添加")

; 添加绿色高亮注释
PbPDF_CreateHighlightAnnot(*doc, *page, 100, 710, 300, 15, "Reviewer", "Secondary highlight", 0.0, 1.0, 0.0)
PrintN("  绿色高亮注释已添加")

; 添加文本注释（便签式）
PbPDF_CreateTextAnnot(*doc, *page, 460, 740, 100, 20, "Note Author", "This is a sticky note comment attached to the page.")
PrintN("  文本注释已添加")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_14_highlight.pdf")
If result = #PbPDF_OK
  PrintN("  高亮注释PDF已保存：output_test_14_highlight.pdf")
Else
  PrintN("  错误：保存失败，错误码=" + Str(result))
EndIf
PbPDF_Free(*doc)

;--- 第3步：创建带页眉页脚的PDF ---
PrintN("")
PrintN("=== 第3步：创建带页眉页脚的PDF ===")

*doc = PbPDF_Create()
If Not *doc
  PrintN("错误：无法创建PDF文档")
  Goto EndTest
EndIf

PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Header Footer Test")

; 创建5个页面
Define pi.i
For pi = 1 To 5
  *page = PbPDF_AddPage(*doc)
  fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
  PbPDF_Page_BeginText(*page)
  PbPDF_Page_SetFontAndSize(*page, fontName$, 20)
  PbPDF_Page_SetRGBFill(*page, 0.2, 0.2, 0.2)
  PbPDF_Page_MoveTextPos(*page, 100, 700)
  PbPDF_Page_ShowText(*page, "Page " + Str(pi) + " of Header/Footer Demo")
  PbPDF_Page_EndText(*page)
  
  fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
  PbPDF_Page_BeginText(*page)
  PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
  PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
  PbPDF_Page_MoveTextPos(*page, 100, 660)
  PbPDF_Page_ShowText(*page, "This is the content area of page " + Str(pi) + ".")
  PbPDF_Page_EndText(*page)
Next

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_14_noheader.pdf")
If result = #PbPDF_OK
  PrintN("  无页眉页脚PDF已保存：output_test_14_noheader.pdf")
EndIf
PbPDF_Free(*doc)

; 使用PbPDF_AddHeaderFooter添加页眉页脚
result = PbPDF_AddHeaderFooter(outputDir$ + "output_test_14_noheader.pdf", outputDir$ + "output_test_14_header_footer.pdf", "PbPDFlib Test Document", "Page", 10)
If result > 0
  PrintN("  页眉页脚PDF已保存：output_test_14_header_footer.pdf")
Else
  PrintN("  错误：添加页眉页脚失败")
EndIf

;--- 第4步：创建带链接注释的PDF ---
PrintN("")
PrintN("=== 第4步：创建带链接注释的PDF ===")

*doc = PbPDF_Create()
If Not *doc
  PrintN("错误：无法创建PDF文档")
  Goto EndTest
EndIf

PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Link Annotation Test")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.8)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Click here to visit example.com")
PbPDF_Page_EndText(*page)

; 添加URI链接注释
PbPDF_CreateURILinkAnnot(*doc, *page, 100, 745, 250, 18, "https://www.example.com")
PrintN("  URI链接注释已添加")

; 添加第二个页面用于内部链接
Define *page2.PbPDF_Object = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page2, "Helvetica-Bold")
PbPDF_Page_BeginText(*page2)
PbPDF_Page_SetFontAndSize(*page2, fontName$, 18)
PbPDF_Page_SetRGBFill(*page2, 0.8, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page2, 100, 750)
PbPDF_Page_ShowText(*page2, "This is Page 2 - Link Target")
PbPDF_Page_EndText(*page2)

; 添加内部链接注释（跳转到第2页）
Define *dest2 = PbPDF_CreateDestination(*page2, #PbPDF_DEST_XYZ, 0, 760, -1, -1, 1.0)
PbPDF_CreateLinkAnnot(*doc, *page, 100, 720, 200, 18, *dest2)
PrintN("  内部链接注释已添加")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_14_links.pdf")
If result = #PbPDF_OK
  PrintN("  链接注释PDF已保存：output_test_14_links.pdf")
Else
  PrintN("  错误：保存失败，错误码=" + Str(result))
EndIf
PbPDF_Free(*doc)

;--- 第5步：创建带自定义旋转水印的PDF ---
PrintN("")
PrintN("=== 第5步：创建带自定义旋转水印的PDF ===")

*doc = PbPDF_Create()
If Not *doc
  PrintN("错误：无法创建PDF文档")
  Goto EndTest
EndIf

PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Custom Watermark Test")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 20)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Custom Angle Watermark Demo")
PbPDF_Page_EndText(*page)

; 添加45度旋转水印
PbPDF_AddTextWatermark(*doc, "DRAFT", 80, 45, 0.2, 0.5, 0.5, 0.5, 0)
PrintN("  45度旋转水印已添加")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_14_custom_watermark.pdf")
If result = #PbPDF_OK
  PrintN("  自定义水印PDF已保存：output_test_14_custom_watermark.pdf")
EndIf
PbPDF_Free(*doc)

;--- 第6步：为已有PDF添加水印 ---
PrintN("")
PrintN("=== 第6步：为已有PDF添加水印 ===")

result = PbPDF_AddWatermarkToFile(outputDir$ + "output_test_14_noheader.pdf", outputDir$ + "output_test_14_file_watermark.pdf", "SAMPLE", 50, 30, 0.7, 0.0, 0.0)
If result > 0
  PrintN("  文件级水印PDF已保存：output_test_14_file_watermark.pdf")
Else
  PrintN("  错误：添加文件级水印失败")
EndIf

EndTest:
PrintN("")
PrintN("=== 水印/高亮/页眉页脚功能测试完成 ===")
PrintN("按回车键退出...")
Input()
CloseConsole()
