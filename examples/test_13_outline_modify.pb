﻿;=============================================================================
; test_13_outline_modify.pb - 书签修改和删除功能测试
; 测试PbPDFlib的书签修改标题、目标、颜色、样式及删除功能
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole("PbPDFlib - 书签修改/删除功能测试")

Define *doc.PbPDF_Doc
Define *page1.PbPDF_Object
Define *page2.PbPDF_Object
Define *page3.PbPDF_Object
Define *page4.PbPDF_Object
Define fontName$
Define result.i
Define outputDir$ = GetPathPart(ProgramFilename())

;--- 第1步：创建带书签的PDF文件 ---
PrintN("=== 第1步：创建带书签的PDF文件 ===")

*doc = PbPDF_Create()
If Not *doc
  PrintN("错误：无法创建PDF文档")
  Goto EndTest
EndIf

PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Outline Modify Test")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "PbPDFlib")

; 创建4个页面
*page1 = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page1, "Helvetica-Bold")
PbPDF_Page_BeginText(*page1)
PbPDF_Page_SetFontAndSize(*page1, fontName$, 24)
PbPDF_Page_SetRGBFill(*page1, 0.0, 0.3, 0.7)
PbPDF_Page_MoveTextPos(*page1, 100, 750)
PbPDF_Page_ShowText(*page1, "Chapter 1: Introduction")
PbPDF_Page_EndText(*page1)

*page2 = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page2, "Helvetica-Bold")
PbPDF_Page_BeginText(*page2)
PbPDF_Page_SetFontAndSize(*page2, fontName$, 24)
PbPDF_Page_SetRGBFill(*page2, 0.7, 0.3, 0.0)
PbPDF_Page_MoveTextPos(*page2, 100, 750)
PbPDF_Page_ShowText(*page2, "Chapter 2: Methods")
PbPDF_Page_EndText(*page2)

*page3 = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page3, "Helvetica-Bold")
PbPDF_Page_BeginText(*page3)
PbPDF_Page_SetFontAndSize(*page3, fontName$, 24)
PbPDF_Page_SetRGBFill(*page3, 0.0, 0.5, 0.0)
PbPDF_Page_MoveTextPos(*page3, 100, 750)
PbPDF_Page_ShowText(*page3, "Chapter 3: Results")
PbPDF_Page_EndText(*page3)

*page4 = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page4, "Helvetica-Bold")
PbPDF_Page_BeginText(*page4)
PbPDF_Page_SetFontAndSize(*page4, fontName$, 24)
PbPDF_Page_SetRGBFill(*page4, 0.5, 0.0, 0.5)
PbPDF_Page_MoveTextPos(*page4, 100, 750)
PbPDF_Page_ShowText(*page4, "Chapter 4: Conclusion")
PbPDF_Page_EndText(*page4)

; 创建目标链接
Define *dest1 = PbPDF_CreateDestination(*page1, #PbPDF_DEST_XYZ, 0, 760, -1, -1, 1.0)
Define *dest2 = PbPDF_CreateDestination(*page2, #PbPDF_DEST_XYZ, 0, 760, -1, -1, 1.0)
Define *dest3 = PbPDF_CreateDestination(*page3, #PbPDF_DEST_XYZ, 0, 760, -1, -1, 1.0)
Define *dest4 = PbPDF_CreateDestination(*page4, #PbPDF_DEST_XYZ, 0, 760, -1, -1, 1.0)

; 创建书签（大纲）
Define *outline1 = PbPDF_CreateOutline(*doc, "1. Introduction", 0, *dest1, #True)
Define *outline11 = PbPDF_CreateOutline(*doc, "1.1 Background", *outline1, *dest1, #False)
Define *outline12 = PbPDF_CreateOutline(*doc, "1.2 Objectives", *outline1, *dest1, #False)

Define *outline2 = PbPDF_CreateOutline(*doc, "2. Methods", 0, *dest2, #True)
Define *outline21 = PbPDF_CreateOutline(*doc, "2.1 Data Collection", *outline2, *dest2, #False)
Define *outline22 = PbPDF_CreateOutline(*doc, "2.2 Analysis", *outline2, *dest2, #False)

Define *outline3 = PbPDF_CreateOutline(*doc, "3. Results", 0, *dest3, #False)
Define *outline4 = PbPDF_CreateOutline(*doc, "4. Conclusion", 0, *dest4, #False)

; 保存初始书签PDF
result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_13_outlines_original.pdf")
If result = #PbPDF_OK
  PrintN("原始书签PDF已创建：output_test_13_outlines_original.pdf")
EndIf

;--- 第2步：遍历并显示所有书签 ---
PrintN("")
PrintN("=== 第2步：遍历所有书签 ===")

Define *current.PbPDF_Outline = PbPDF_GetFirstOutline(*doc)
Define level.i = 0
While *current
  PrintN(Space(level * 2) + "- " + PbPDF_GetOutlineTitle(*current))
  ; 检查子书签
  Define *child.PbPDF_Outline = PbPDF_GetOutlineFirst(*current)
  While *child
    PrintN(Space((level + 1) * 2) + "- " + PbPDF_GetOutlineTitle(*child))
    *child = PbPDF_GetOutlineNext(*child)
  Wend
  *current = PbPDF_GetOutlineNext(*current)
Wend

;--- 第3步：修改书签标题 ---
PrintN("")
PrintN("=== 第3步：修改书签标题 ===")

PbPDF_ModifyOutlineTitle(*outline1, "1. Introduction (Revised)")
PbPDF_ModifyOutlineTitle(*outline3, "3. Results and Discussion")
PrintN("书签1标题修改为：" + PbPDF_GetOutlineTitle(*outline1))
PrintN("书签3标题修改为：" + PbPDF_GetOutlineTitle(*outline3))

;--- 第4步：修改书签颜色和样式 ---
PrintN("")
PrintN("=== 第4步：修改书签颜色和样式 ===")

; 将第1章书签设为蓝色粗体
PbPDF_ModifyOutlineColor(*outline1, 0.0, 0.0, 0.8)
PbPDF_ModifyOutlineStyle(*outline1, 2)  ; 粗体
PrintN("书签1颜色设为蓝色，样式设为粗体")

; 将第3章书签设为绿色斜体
PbPDF_ModifyOutlineColor(*outline3, 0.0, 0.6, 0.0)
PbPDF_ModifyOutlineStyle(*outline3, 1)  ; 斜体
PrintN("书签3颜色设为绿色，样式设为斜体")

; 将第4章书签设为红色粗斜体
PbPDF_ModifyOutlineColor(*outline4, 0.8, 0.0, 0.0)
PbPDF_ModifyOutlineStyle(*outline4, 3)  ; 粗斜体
PrintN("书签4颜色设为红色，样式设为粗斜体")

; 保存修改后的PDF
result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_13_outlines_modified.pdf")
If result = #PbPDF_OK
  PrintN("修改书签后的PDF已保存：output_test_13_outlines_modified.pdf")
EndIf

;--- 第5步：修改书签目标页面 ---
PrintN("")
PrintN("=== 第5步：修改书签目标页面 ===")

; 将书签2的目标从第2页改为第4页
Define *newDest2 = PbPDF_CreateDestination(*page4, #PbPDF_DEST_XYZ, 0, 760, -1, -1, 1.0)
PbPDF_ModifyOutlineDest(*outline2, *newDest2)
PrintN("书签2的目标页面已修改为第4页")

;--- 第6步：修改书签展开状态 ---
PrintN("")
PrintN("=== 第6步：修改书签展开状态 ===")

PbPDF_ModifyOutlineOpened(*outline2, #False)
PrintN("书签2的展开状态已修改为折叠")

; 保存修改后的PDF
result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_13_outlines_dest_changed.pdf")
If result = #PbPDF_OK
  PrintN("修改目标后的PDF已保存：output_test_13_outlines_dest_changed.pdf")
EndIf

;--- 第7步：删除书签 ---
PrintN("")
PrintN("=== 第7步：删除书签 ===")

; 删除书签3（Results and Discussion）
PrintN("删除书签：" + PbPDF_GetOutlineTitle(*outline3))
PbPDF_DeleteOutline(*doc, *outline3)
; outline3已被释放，不能再访问

; 遍历剩余书签
PrintN("删除后的书签列表：")
*current = PbPDF_GetFirstOutline(*doc)
While *current
  PrintN("  - " + PbPDF_GetOutlineTitle(*current))
  Define *sub.PbPDF_Outline = PbPDF_GetOutlineFirst(*current)
  While *sub
    PrintN("    - " + PbPDF_GetOutlineTitle(*sub))
    *sub = PbPDF_GetOutlineNext(*sub)
  Wend
  *current = PbPDF_GetOutlineNext(*current)
Wend

; 保存删除书签后的PDF
result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_13_outlines_deleted.pdf")
If result = #PbPDF_OK
  PrintN("删除书签后的PDF已保存：output_test_13_outlines_deleted.pdf")
EndIf

;--- 第8步：删除子书签 ---
PrintN("")
PrintN("=== 第8步：删除子书签 ===")

; 删除书签2下的"2.1 Data Collection"
PrintN("删除子书签：" + PbPDF_GetOutlineTitle(*outline21))
PbPDF_DeleteOutline(*doc, *outline21)

; 遍历剩余书签
PrintN("删除子书签后的书签列表：")
*current = PbPDF_GetFirstOutline(*doc)
While *current
  PrintN("  - " + PbPDF_GetOutlineTitle(*current))
  Define *sub2.PbPDF_Outline = PbPDF_GetOutlineFirst(*current)
  While *sub2
    PrintN("    - " + PbPDF_GetOutlineTitle(*sub2))
    *sub2 = PbPDF_GetOutlineNext(*sub2)
  Wend
  *current = PbPDF_GetOutlineNext(*current)
Wend

; 保存最终PDF
result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_13_outlines_final.pdf")
If result = #PbPDF_OK
  PrintN("最终PDF已保存：output_test_13_outlines_final.pdf")
EndIf

PbPDF_Free(*doc)

EndTest:
PrintN("")
PrintN("=== 书签修改/删除功能测试完成 ===")
PrintN("按回车键退出...")
Input()
CloseConsole()
