﻿;=============================================================================
; test_10_pdf_read_modify.pb - PDF读取与修改功能测试
; 测试PbPDFlib的PDF文件加载、信息读取和修改功能
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole("PbPDFlib - PDF读取与修改功能测试")

Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define fontName$
Define result.i
Define outputDir$ = GetPathPart(ProgramFilename())

;--- 第1步：创建一个用于后续读取测试的PDF文件 ---
PrintN("=== 第1步：创建测试用PDF文件 ===")

*doc = PbPDF_Create()
If Not *doc
  PrintN("错误：无法创建PDF文档")
  End
EndIf

PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PDF读取测试文档")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "PbPDFlib测试")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_SUBJECT, "用于测试PDF读取功能")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_KEYWORDS, "测试,读取,PbPDFlib")

; 创建第1页
*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.3, 0.7)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "PDF Read/Modify Test - Page 1")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This is the first page of the test document.")
PbPDF_Page_MoveTextPos(*page, 0, -20)
PbPDF_Page_ShowText(*page, "It contains text content for reading test.")
PbPDF_Page_EndText(*page)

; 创建第2页
*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.7, 0.0, 0.3)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "PDF Read/Modify Test - Page 2")
PbPDF_Page_EndText(*page)

; 在第2页绘制图形
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.5, 0.0)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_DrawCircle(*page, 300, 500, 80)
PbPDF_Page_SetRGBFill(*page, 0.8, 0.9, 1.0)
PbPDF_Page_FillRect(*page, 100, 350, 200, 100)

; 创建第3页
*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.5, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "PDF Read/Modify Test - Page 3")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 14)
PbPDF_Page_SetRGBFill(*page, 0.2, 0.2, 0.2)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This is the third page.")
PbPDF_Page_MoveTextPos(*page, 0, -20)
PbPDF_Page_ShowText(*page, "The end of the test document.")
PbPDF_Page_EndText(*page)

; 保存测试文件
result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_10_source.pdf")
If result = #PbPDF_OK
  PrintN("测试PDF文件已创建：output_test_10_source.pdf")
Else
  PrintN("错误：无法保存测试PDF文件，错误码=" + Hex(result))
EndIf
PbPDF_Free(*doc)

;--- 第2步：测试PDF文件加载和读取 ---
PrintN("")
PrintN("=== 第2步：测试PDF文件加载和读取 ===")

Define *ldoc.PbPDF_LoadedDoc
Define pageWidth.f, pageHeight.f
Define pageCount.i
Define i.i

*ldoc = PbPDF_LoadFromFile(outputDir$ + "output_test_10_source.pdf")
If *ldoc
  PrintN("PDF文件加载成功！")
  
  ; 读取PDF版本
  PrintN("PDF版本：" + PbPDF_LoadGetVersion(*ldoc))
  
  ; 读取页面数量
  pageCount = PbPDF_LoadGetPageCount(*ldoc)
  PrintN("页面数量：" + Str(pageCount))
  
  ; 读取文档信息
  PrintN("标题：" + PbPDF_LoadGetInfoAttr(*ldoc, "Title"))
  PrintN("作者：" + PbPDF_LoadGetInfoAttr(*ldoc, "Author"))
  PrintN("主题：" + PbPDF_LoadGetInfoAttr(*ldoc, "Subject"))
  PrintN("关键词：" + PbPDF_LoadGetInfoAttr(*ldoc, "Keywords"))
  
  ; 读取每页尺寸
  For i = 0 To pageCount - 1
    If PbPDF_LoadGetPageSize(*ldoc, i, @pageWidth, @pageHeight)
      PrintN("第" + Str(i + 1) + "页尺寸：" + StrF(pageWidth, 1) + " x " + StrF(pageHeight, 1))
    EndIf
  Next
  
  PbPDF_FreeLoadedDoc(*ldoc)
  PrintN("PDF文件读取测试完成！")
Else
  PrintN("错误：无法加载PDF文件")
EndIf

;--- 第3步：测试读取已有的测试PDF文件 ---
PrintN("")
PrintN("=== 第3步：测试读取其他已有PDF文件 ===")

Define testFiles$ = "output_test_01_doc.pdf|output_test_08_comprehensive.pdf|output_test_09_new_features.pdf"
Define tf.i
For tf = 1 To 3
  Define tfName$ = StringField(testFiles$, tf, "|")
  Define fullPath$ = outputDir$ + tfName$
  If FileSize(fullPath$) > 0
    *ldoc = PbPDF_LoadFromFile(fullPath$)
    If *ldoc
      PrintN("文件：" + tfName$)
      PrintN("  版本：" + PbPDF_LoadGetVersion(*ldoc))
      PrintN("  页数：" + Str(PbPDF_LoadGetPageCount(*ldoc)))
      Define tfTitle$ = PbPDF_LoadGetInfoAttr(*ldoc, "Title")
      If tfTitle$ <> ""
        PrintN("  标题：" + tfTitle$)
      EndIf
      PbPDF_FreeLoadedDoc(*ldoc)
    Else
      PrintN("  无法加载：" + tfName$)
    EndIf
  Else
    PrintN("  文件不存在：" + tfName$)
  EndIf
Next

;--- 第4步：测试添加页眉页脚 ---
PrintN("")
PrintN("=== 第4步：测试添加页眉页脚 ===")

result = PbPDF_AddHeaderFooter(outputDir$ + "output_test_10_source.pdf", outputDir$ + "output_test_10_header_footer.pdf", "PbPDFlib Test Document", "Confidential", 10.0)
If result > 0
  PrintN("页眉页脚添加成功！处理了" + Str(result) + "页")
Else
  PrintN("错误：无法添加页眉页脚")
EndIf

;--- 第5步：测试添加水印 ---
PrintN("")
PrintN("=== 第5步：测试添加水印 ===")

result = PbPDF_AddWatermarkToFile(outputDir$ + "output_test_10_source.pdf", outputDir$ + "output_test_10_watermark.pdf", "WATERMARK", 48, 45, 0.85, 0.85, 0.85)
If result > 0
  PrintN("水印添加成功！处理了" + Str(result) + "页")
Else
  PrintN("错误：无法添加水印")
EndIf

PrintN("")
PrintN("=== PDF读取与修改功能测试完成 ===")
PrintN("按回车键退出...")
Input()
CloseConsole()
