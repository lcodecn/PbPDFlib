﻿;=============================================================================
; test_15_page_operations.pb - PDF页面操作功能测试
; 测试PbPDFlib的合并、拆分、提取、删除页面功能
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole("PbPDFlib - 页面操作功能测试")

Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define fontName$
Define result.i
Define outputDir$ = GetPathPart(ProgramFilename())

;--- 第1步：创建3个独立的PDF文件用于后续操作 ---
PrintN("=== 第1步：创建3个测试PDF文件 ===")

; 文件A：3页
*doc = PbPDF_Create()
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Document A")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.8, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document A - Page 1")
PbPDF_Page_EndText(*page)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.8, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document A - Page 2")
PbPDF_Page_EndText(*page)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.8)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document A - Page 3")
PbPDF_Page_EndText(*page)

PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_15_docA.pdf")
PrintN("  文档A已创建（3页）：output_test_15_docA.pdf")
PbPDF_Free(*doc)

; 文件B：2页
*doc = PbPDF_Create()
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Document B")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.8, 0.5, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document B - Page 1")
PbPDF_Page_EndText(*page)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.5, 0.8)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document B - Page 2")
PbPDF_Page_EndText(*page)

PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_15_docB.pdf")
PrintN("  文档B已创建（2页）：output_test_15_docB.pdf")
PbPDF_Free(*doc)

; 文件C：1页
*doc = PbPDF_Create()
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Document C")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.5, 0.0, 0.5)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document C - Page 1")
PbPDF_Page_EndText(*page)

PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_15_docC.pdf")
PrintN("  文档C已创建（1页）：output_test_15_docC.pdf")
PbPDF_Free(*doc)

;--- 第2步：合并PDF文件 ---
PrintN("")
PrintN("=== 第2步：合并PDF文件 ===")

; 使用 | 分隔多个文件路径
Define mergeFiles$ = outputDir$ + "output_test_15_docA.pdf" + "|" + outputDir$ + "output_test_15_docB.pdf" + "|" + outputDir$ + "output_test_15_docC.pdf"
result = PbPDF_MergePDFFiles(outputDir$ + "output_test_15_merged.pdf", mergeFiles$)
If result > 0
  PrintN("  合并成功！已保存：output_test_15_merged.pdf")
  ; 验证合并后的文件
  Define *ldoc.PbPDF_LoadedDoc = PbPDF_LoadFromFile(outputDir$ + "output_test_15_merged.pdf")
  If *ldoc
    PrintN("  合并后页数：" + Str(PbPDF_LoadGetPageCount(*ldoc)) + "页（预期6页）")
    PbPDF_FreeLoadedDoc(*ldoc)
  EndIf
Else
  PrintN("  错误：合并失败")
EndIf

;--- 第3步：提取页面 ---
PrintN("")
PrintN("=== 第3步：提取页面 ===")

; 从文档A中提取第2~3页
result = PbPDF_ExtractPages(outputDir$ + "output_test_15_docA.pdf", outputDir$ + "output_test_15_extracted.pdf", 2, 3)
If result > 0
  PrintN("  提取成功！已保存：output_test_15_extracted.pdf")
  Define *ldoc2.PbPDF_LoadedDoc = PbPDF_LoadFromFile(outputDir$ + "output_test_15_extracted.pdf")
  If *ldoc2
    PrintN("  提取后页数：" + Str(PbPDF_LoadGetPageCount(*ldoc2)) + "页（预期2页）")
    PbPDF_FreeLoadedDoc(*ldoc2)
  EndIf
Else
  PrintN("  错误：提取失败")
EndIf

;--- 第4步：删除页面 ---
PrintN("")
PrintN("=== 第4步：删除页面 ===")

; 从文档A中删除第2页
result = PbPDF_DeletePages(outputDir$ + "output_test_15_docA.pdf", outputDir$ + "output_test_15_deleted.pdf", 2, 2)
If result > 0
  PrintN("  删除成功！已保存：output_test_15_deleted.pdf")
  Define *ldoc3.PbPDF_LoadedDoc = PbPDF_LoadFromFile(outputDir$ + "output_test_15_deleted.pdf")
  If *ldoc3
    PrintN("  删除后页数：" + Str(PbPDF_LoadGetPageCount(*ldoc3)) + "页（预期2页）")
    PbPDF_FreeLoadedDoc(*ldoc3)
  EndIf
Else
  PrintN("  错误：删除失败")
EndIf

;--- 第5步：拆分PDF ---
PrintN("")
PrintN("=== 第5步：拆分PDF ===")

result = PbPDF_SplitPDF(outputDir$ + "output_test_15_docA.pdf", outputDir$ + "output_test_15_split")
If result > 0
  PrintN("  拆分成功！")
  ; 验证拆分后的文件
  Define si.i
  For si = 1 To 3
    Define splitFile$ = outputDir$ + "output_test_15_split_" + RSet(Str(si), 3, "0") + ".pdf"
    If FileSize(splitFile$) > 0
      Define *ldoc4.PbPDF_LoadedDoc = PbPDF_LoadFromFile(splitFile$)
      If *ldoc4
        PrintN("  拆分文件" + Str(si) + "：" + Str(PbPDF_LoadGetPageCount(*ldoc4)) + "页")
        PbPDF_FreeLoadedDoc(*ldoc4)
      EndIf
    EndIf
  Next
Else
  PrintN("  错误：拆分失败")
EndIf

;--- 第6步：文件大小比较 ---
PrintN("")
PrintN("=== 第6步：文件大小比较 ===")

Define sizeA.i = FileSize(outputDir$ + "output_test_15_docA.pdf")
Define sizeB.i = FileSize(outputDir$ + "output_test_15_docB.pdf")
Define sizeC.i = FileSize(outputDir$ + "output_test_15_docC.pdf")
Define sizeMerged.i = FileSize(outputDir$ + "output_test_15_merged.pdf")
Define sizeExtracted.i = FileSize(outputDir$ + "output_test_15_extracted.pdf")
Define sizeDeleted.i = FileSize(outputDir$ + "output_test_15_deleted.pdf")

PrintN("  文档A大小：" + Str(sizeA) + "字节")
PrintN("  文档B大小：" + Str(sizeB) + "字节")
PrintN("  文档C大小：" + Str(sizeC) + "字节")
PrintN("  合并后大小：" + Str(sizeMerged) + "字节")
PrintN("  提取后大小：" + Str(sizeExtracted) + "字节")
PrintN("  删除后大小：" + Str(sizeDeleted) + "字节")

EndTest:
PrintN("")
PrintN("=== 页面操作功能测试完成 ===")
PrintN("按回车键退出...")
Input()
CloseConsole()
