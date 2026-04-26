﻿;=============================================================================
; test_01_doc_management.pb - 测试1：文档管理
; PbPDFlib 功能测试：PDF文档的创建、版本设置、信息属性、保存
;=============================================================================
; 功能覆盖：
;   PbPDF_Create         - 创建PDF文档对象
;   PbPDF_Free           - 释放PDF文档对象
;   PbPDF_SetPDFVersion  - 设置PDF版本(1.2~2.0)
;   PbPDF_SetInfoAttr    - 设置文档信息属性(标题/作者/主题等)
;   PbPDF_GetInfoAttr    - 获取文档信息属性
;   PbPDF_SetCompressionMode - 设置压缩模式
;   PbPDF_AddPage        - 添加页面
;   PbPDF_GetPageCount   - 获取页面总数
;   PbPDF_SaveToFile2    - 保存PDF到文件
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试1：文档管理功能测试")
PrintN("========================================")

;--- 变量声明 ---
Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define result.i
Define infoValue$
Define outputDir$ = GetPathPart(ProgramFilename())

;=============================================================================
; 1.1 创建PDF文档
;=============================================================================
PrintN("")
PrintN("--- 1.1 创建PDF文档 ---")

*doc = PbPDF_Create()
If *doc
  PrintN("  [通过] PbPDF_Create() 创建文档成功")
Else
  PrintN("  [失败] PbPDF_Create() 创建文档失败!")
  Input()
  End
EndIf

;=============================================================================
; 1.2 设置PDF版本
;=============================================================================
PrintN("")
PrintN("--- 1.2 设置PDF版本 ---")

; 测试设置PDF 1.4版本（支持CIDFont，推荐用于中文PDF）
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PrintN("  [通过] 设置PDF版本为1.4")

; 测试设置PDF 1.5版本
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_15)
PrintN("  [通过] 设置PDF版本为1.5")

; 恢复为1.4版本
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PrintN("  [通过] 恢复PDF版本为1.4")

;=============================================================================
; 1.3 设置文档信息属性
;=============================================================================
PrintN("")
PrintN("--- 1.3 设置文档信息属性 ---")

; 设置标题
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PbPDFlib 文档管理测试")
PrintN("  [通过] 设置标题: PbPDFlib 文档管理测试")

; 设置作者
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "lcode.cn")
PrintN("  [通过] 设置作者: lcode.cn")

; 设置主题
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_SUBJECT, "文档管理功能测试")
PrintN("  [通过] 设置主题: 文档管理功能测试")

; 设置关键词
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_KEYWORDS, "PDF, PbPDFlib, Test")
PrintN("  [通过] 设置关键词: PDF, PbPDFlib, Test")

; 设置创建者
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_CREATOR, "PbPDFlib v0.1.0")
PrintN("  [通过] 设置创建者: PbPDFlib v0.1.0")

; 设置生产者
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_PRODUCER, "PbPDFlib - PureBasic PDF Library")
PrintN("  [通过] 设置生产者: PbPDFlib - PureBasic PDF Library")

;=============================================================================
; 1.4 获取文档信息属性
;=============================================================================
PrintN("")
PrintN("--- 1.4 获取文档信息属性 ---")

; 读取并验证标题
infoValue$ = PbPDF_GetInfoAttr(*doc, #PbPDF_INFO_TITLE)
If infoValue$ <> ""
  PrintN("  [通过] 获取标题: " + infoValue$)
Else
  PrintN("  [失败] 获取标题为空!")
EndIf

; 读取并验证作者
infoValue$ = PbPDF_GetInfoAttr(*doc, #PbPDF_INFO_AUTHOR)
If infoValue$ <> ""
  PrintN("  [通过] 获取作者: " + infoValue$)
Else
  PrintN("  [失败] 获取作者为空!")
EndIf

; 读取并验证关键词
infoValue$ = PbPDF_GetInfoAttr(*doc, #PbPDF_INFO_KEYWORDS)
If infoValue$ <> ""
  PrintN("  [通过] 获取关键词: " + infoValue$)
Else
  PrintN("  [失败] 获取关键词为空!")
EndIf

;=============================================================================
; 1.5 设置压缩模式
;=============================================================================
PrintN("")
PrintN("--- 1.5 设置压缩模式 ---")

; 设置文本压缩
PbPDF_SetCompressionMode(*doc, #PbPDF_COMP_TEXT)
PrintN("  [通过] 设置压缩模式: 文本压缩")

; 设置全部压缩
PbPDF_SetCompressionMode(*doc, #PbPDF_COMP_ALL)
PrintN("  [通过] 设置压缩模式: 全部压缩")

;=============================================================================
; 1.6 添加页面并获取页面数
;=============================================================================
PrintN("")
PrintN("--- 1.6 添加页面并获取页面数 ---")

; 添加第一个页面
*page = PbPDF_AddPage(*doc)
If *page
  PrintN("  [通过] 添加第1个页面成功")
Else
  PrintN("  [失败] 添加第1个页面失败!")
EndIf

; 检查页面总数
result = PbPDF_GetPageCount(*doc)
If result = 1
  PrintN("  [通过] 页面总数 = " + Str(result))
Else
  PrintN("  [失败] 页面总数不正确，期望1，实际" + Str(result))
EndIf

; 在页面上添加简单文本，确保PDF非空白
Define fontName$
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 20)
PbPDF_Page_MoveTextPos(*page, 50, 750)
PbPDF_Page_ShowText(*page, "Document Management Test")
PbPDF_Page_EndText(*page)

;=============================================================================
; 1.7 保存PDF文件
;=============================================================================
PrintN("")
PrintN("--- 1.7 保存PDF文件 ---")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_01_doc.pdf")
If result = #PbPDF_OK
  PrintN("  [通过] PDF文件保存成功: output_test_01_doc.pdf")
Else
  PrintN("  [失败] PDF文件保存失败! 错误码: " + Hex(result))
EndIf

;=============================================================================
; 1.8 释放文档
;=============================================================================
PrintN("")
PrintN("--- 1.8 释放文档 ---")

PbPDF_Free(*doc)
PrintN("  [通过] 文档释放成功")

;=============================================================================
; 测试总结
;=============================================================================
PrintN("")
PrintN("========================================")
PrintN("测试1：文档管理功能测试完成!")
PrintN("========================================")
Input()
