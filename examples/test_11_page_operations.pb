﻿;=============================================================================
; test_11_page_operations.pb - PDF页面操作功能测试
; 测试PbPDFlib的PDF合并、拆分、提取、删除页面功能
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole("PbPDFlib - PDF页面操作功能测试")

Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define fontName$
Define result.i
Define outputDir$ = GetPathPart(ProgramFilename())

;--- 第1步：创建两个用于合并测试的PDF文件 ---
PrintN("=== 第1步：创建测试用PDF文件 ===")

; 创建文件A（3页）
*doc = PbPDF_Create()
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Document A")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.8)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document A - Page 1")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This is page 1 of Document A.")
PbPDF_Page_EndText(*page)

; 绘制蓝色矩形
PbPDF_Page_SetRGBFill(*page, 0.7, 0.8, 1.0)
PbPDF_Page_FillRect(*page, 100, 400, 200, 150)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.8)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document A - Page 2")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This is page 2 of Document A.")
PbPDF_Page_EndText(*page)

; 绘制绿色圆形
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.6, 0.0)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_DrawCircle(*page, 300, 450, 60)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.8)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document A - Page 3")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This is page 3 of Document A.")
PbPDF_Page_EndText(*page)

PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_11_doc_a.pdf")
PrintN("文件A已创建：output_test_11_doc_a.pdf（3页）")
PbPDF_Free(*doc)

; 创建文件B（2页）
*doc = PbPDF_Create()
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Document B")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.8, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document B - Page 1")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This is page 1 of Document B.")
PbPDF_Page_EndText(*page)

; 绘制红色矩形
PbPDF_Page_SetRGBFill(*page, 1.0, 0.8, 0.8)
PbPDF_Page_FillRect(*page, 100, 400, 200, 150)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 28)
PbPDF_Page_SetRGBFill(*page, 0.8, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Document B - Page 2")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This is page 2 of Document B.")
PbPDF_Page_EndText(*page)

PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_11_doc_b.pdf")
PrintN("文件B已创建：output_test_11_doc_b.pdf（2页）")
PbPDF_Free(*doc)

;--- 第2步：测试PDF合并 ---
PrintN("")
PrintN("=== 第2步：测试PDF合并 ===")

Define inputFiles$ = outputDir$ + "output_test_11_doc_a.pdf|" + outputDir$ + "output_test_11_doc_b.pdf"
result = PbPDF_MergePDFFiles(outputDir$ + "output_test_11_merged.pdf", inputFiles$)
If result > 0
  PrintN("PDF合并成功！合并后共" + Str(result) + "页")
Else
  PrintN("错误：PDF合并失败")
EndIf

;--- 第3步：测试页面提取 ---
PrintN("")
PrintN("=== 第3步：测试页面提取 ===")

; 从文件A中提取第1-2页
result = PbPDF_ExtractPages(outputDir$ + "output_test_11_doc_a.pdf", outputDir$ + "output_test_11_extract_1_2.pdf", 1, 2)
If result > 0
  PrintN("页面提取成功！提取了" + Str(result) + "页（第1-2页）")
Else
  PrintN("错误：页面提取失败")
EndIf

; 从文件A中提取第3页
result = PbPDF_ExtractPages(outputDir$ + "output_test_11_doc_a.pdf", outputDir$ + "output_test_11_extract_3.pdf", 3, 3)
If result > 0
  PrintN("单页提取成功！提取了" + Str(result) + "页（第3页）")
Else
  PrintN("错误：单页提取失败")
EndIf

;--- 第4步：测试PDF拆分 ---
PrintN("")
PrintN("=== 第4步：测试PDF拆分 ===")

result = PbPDF_SplitPDF(outputDir$ + "output_test_11_doc_a.pdf", outputDir$ + "output_test_11_split")
If result > 0
  PrintN("PDF拆分成功！拆分为" + Str(result) + "个单页文件")
Else
  PrintN("错误：PDF拆分失败")
EndIf

;--- 第5步：测试页面删除 ---
PrintN("")
PrintN("=== 第5步：测试页面删除 ===")

; 从文件A中删除第2页
result = PbPDF_DeletePages(outputDir$ + "output_test_11_doc_a.pdf", outputDir$ + "output_test_11_deleted.pdf", 2, 2)
If result > 0
  PrintN("页面删除成功！删除后剩余" + Str(result) + "页（删除了第2页）")
Else
  PrintN("错误：页面删除失败")
EndIf

; 从文件A中删除第1-2页
result = PbPDF_DeletePages(outputDir$ + "output_test_11_doc_a.pdf", outputDir$ + "output_test_11_deleted_1_2.pdf", 1, 2)
If result > 0
  PrintN("多页删除成功！删除后剩余" + Str(result) + "页（删除了第1-2页）")
Else
  PrintN("错误：多页删除失败")
EndIf

;--- 第6步：验证操作结果 ---
PrintN("")
PrintN("=== 第6步：验证操作结果 ===")

Define *ldoc.PbPDF_LoadedDoc
Define verifyFiles$ = "output_test_11_merged.pdf|output_test_11_extract_1_2.pdf|output_test_11_extract_3.pdf|output_test_11_deleted.pdf"
Define vf.i
For vf = 1 To 4
  Define vfName$ = StringField(verifyFiles$, vf, "|")
  Define vfPath$ = outputDir$ + vfName$
  If FileSize(vfPath$) > 0
    *ldoc = PbPDF_LoadFromFile(vfPath$)
    If *ldoc
      PrintN(vfName$ + "：" + Str(PbPDF_LoadGetPageCount(*ldoc)) + "页")
      PbPDF_FreeLoadedDoc(*ldoc)
    Else
      PrintN(vfName$ + "：无法读取")
    EndIf
  Else
    PrintN(vfName$ + "：文件不存在")
  EndIf
Next

PrintN("")
PrintN("=== PDF页面操作功能测试完成 ===")
PrintN("按回车键退出...")
Input()
CloseConsole()
