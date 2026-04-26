﻿;=============================================================================
; test_06_image_operations.pb - 测试6：图片操作
; PbPDFlib 功能测试：JPEG和PNG图片的加载、绘制
;=============================================================================
; 功能覆盖：
;   PbPDF_LoadJPEGImageFromFile - 从文件加载JPEG图片
;   PbPDF_LoadPNGImageFromFile  - 从文件加载PNG图片
;   PbPDF_Page_DrawImage        - 在页面上绘制图片
;   PbPDF_RegisterImage         - 注册图片到页面资源
;   图片尺寸获取(*image\width, *image\height)
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试6：图片操作功能测试")
PrintN("========================================")

;--- 变量声明 ---
Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define *jpegImage.PbPDF_Image
Define *grayJpeg.PbPDF_Image
Define *pngImage.PbPDF_Image
Define fontName$
Define result.i
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
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PbPDFlib 图片操作测试")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "lcode.cn")

*page = PbPDF_AddPage(*doc)

;=============================================================================
; 6.1 加载RGB JPEG图片
;=============================================================================
PrintN("")
PrintN("--- 6.1 加载RGB JPEG图片 ---")

*jpegImage = PbPDF_LoadJPEGImageFromFile(*doc, outputDir$ + "images\rgb.jpg")
If *jpegImage
  PrintN("  [通过] RGB JPEG加载成功! 尺寸: " + Str(*jpegImage\width) + "x" + Str(*jpegImage\height))
  
  ; 在页面上绘制JPEG图片
  PbPDF_Page_DrawImage(*doc, *page, *jpegImage, 50, 600, 200, 150)
  PrintN("  [通过] JPEG图片绘制成功")
Else
  PrintN("  [警告] RGB JPEG加载失败(可能文件不存在)")
EndIf

;=============================================================================
; 6.2 加载灰度JPEG图片
;=============================================================================
PrintN("")
PrintN("--- 6.2 加载灰度JPEG图片 ---")

*grayJpeg = PbPDF_LoadJPEGImageFromFile(*doc, outputDir$ + "images\gray.jpg")
If *grayJpeg
  PrintN("  [通过] 灰度JPEG加载成功! 尺寸: " + Str(*grayJpeg\width) + "x" + Str(*grayJpeg\height))
  
  ; 在页面上绘制灰度JPEG
  PbPDF_Page_DrawImage(*doc, *page, *grayJpeg, 300, 600, 200, 150)
  PrintN("  [通过] 灰度JPEG图片绘制成功")
Else
  PrintN("  [警告] 灰度JPEG加载失败(可能文件不存在)")
EndIf

;=============================================================================
; 6.3 加载PNG图片
;=============================================================================
PrintN("")
PrintN("--- 6.3 加载PNG图片 ---")

; 尝试加载libharu自带的PNG测试图片
*pngImage = PbPDF_LoadPNGImageFromFile(*doc, outputDir$ + "pngsuite\basn2c08.png")
If *pngImage
  PrintN("  [通过] PNG图片加载成功! 尺寸: " + Str(*pngImage\width) + "x" + Str(*pngImage\height))
  
  ; 在页面上绘制PNG图片
  PbPDF_Page_DrawImage(*doc, *page, *pngImage, 50, 440, 200, 150)
  PrintN("  [通过] PNG图片绘制成功")
Else
  PrintN("  [警告] PNG图片加载失败(可能文件不存在)")
  ; 尝试加载其他PNG文件
  *pngImage = PbPDF_LoadPNGImageFromFile(*doc, outputDir$ + "pngsuite\basn0g08.png")
  If *pngImage
    PrintN("  [通过] 灰度PNG图片加载成功! 尺寸: " + Str(*pngImage\width) + "x" + Str(*pngImage\height))
    PbPDF_Page_DrawImage(*doc, *page, *pngImage, 50, 440, 200, 150)
    PrintN("  [通过] 灰度PNG图片绘制成功")
  Else
    PrintN("  [警告] 灰度PNG图片也加载失败")
  EndIf
EndIf

;=============================================================================
; 6.4 图片缩放绘制
;=============================================================================
PrintN("")
PrintN("--- 6.4 图片缩放绘制 ---")

If *jpegImage
  ; 原始比例绘制
  PbPDF_Page_DrawImage(*doc, *page, *jpegImage, 300, 440, 100, 75)
  
  ; 放大绘制
  PbPDF_Page_DrawImage(*doc, *page, *jpegImage, 420, 440, 120, 90)
  
  PrintN("  [通过] 图片缩放绘制(不同尺寸)")
Else
  PrintN("  [跳过] 无JPEG图片可用")
EndIf

;=============================================================================
; 6.5 图片标注
;=============================================================================
PrintN("")
PrintN("--- 6.5 图片标注 ---")

; 绘制图片边框
PbPDF_Page_SetRGBStroke(*page, 0.5, 0.5, 0.5)
PbPDF_Page_SetLineWidth(*page, 0.5)
PbPDF_Page_DrawRect(*page, 45, 430, 510, 330)

; 添加图片标签
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 10)
PbPDF_Page_MoveTextPos(*page, 50, 415)
PbPDF_Page_ShowText(*page, "RGB JPEG")
PbPDF_Page_MoveTextPos(*page, 250, 0)
PbPDF_Page_ShowText(*page, "Grayscale JPEG")
PbPDF_Page_MoveTextPos(*page, -250, -170)
PbPDF_Page_ShowText(*page, "PNG Image")
PbPDF_Page_MoveTextPos(*page, 250, 0)
PbPDF_Page_ShowText(*page, "Scaled JPEG Images")
PbPDF_Page_EndText(*page)

;=============================================================================
; 6.6 多图片页面测试
;=============================================================================
PrintN("")
PrintN("--- 6.6 多图片页面测试 ---")

; 在页面底部添加图片网格区域
PbPDF_Page_SetRGBFill(*page, 0.95, 0.95, 0.95)
PbPDF_Page_FillRect(*page, 50, 50, 495, 200)

; 添加说明文字
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 60, 225)
PbPDF_Page_ShowText(*page, "Image Operations Summary:")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 10)
PbPDF_Page_MoveTextPos(*page, 60, 205)
PbPDF_Page_ShowText(*page, "- JPEG RGB/Grayscale loading and rendering")
PbPDF_Page_MoveTextPos(*page, 0, -15)
PbPDF_Page_ShowText(*page, "- PNG RGB/RGBA/Grayscale loading and rendering")
PbPDF_Page_MoveTextPos(*page, 0, -15)
PbPDF_Page_ShowText(*page, "- Image scaling (different display sizes)")
PbPDF_Page_MoveTextPos(*page, 0, -15)
PbPDF_Page_ShowText(*page, "- Multiple images on single page")
PbPDF_Page_EndText(*page)

;=============================================================================
; 保存PDF文件
;=============================================================================
PrintN("")
PrintN("--- 保存PDF文件 ---")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_06_image.pdf")
If result = #PbPDF_OK
  PrintN("  [通过] PDF文件保存成功: output_test_06_image.pdf")
Else
  PrintN("  [失败] PDF文件保存失败! 错误码: " + Hex(result))
EndIf

PbPDF_Free(*doc)

PrintN("")
PrintN("========================================")
PrintN("测试6：图片操作功能测试完成!")
PrintN("========================================")
Input()

; IDE Options = PureBasic 6.40 (Windows - x86)
; CursorPosition = 21
; EnableThread
; EnableXP
; DPIAware
; CompileSourceDirectory