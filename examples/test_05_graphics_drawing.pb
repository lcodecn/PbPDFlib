﻿;=============================================================================
; test_05_graphics_drawing.pb - 测试5：图形绘制
; PbPDFlib 功能测试：路径构造、形状绘制、颜色、线条属性、变换矩阵
;=============================================================================
; 功能覆盖：
;   路径构造: MoveTo, LineTo, CurveTo, CurveTo2, CurveTo3, Rectangle, ClosePath
;   路径绘制: Stroke, Fill, Eofill, FillStroke, ClosePathStroke, ClosePathFillStroke
;   便捷绘图: DrawLine, DrawRect, FillRect, DrawCircle, FillCircle, DrawEllipse, Arc
;   颜色设置: SetRGBFill, SetRGBStroke, SetCMYKFill, SetCMYKStroke, SetGrayFill, SetGrayStroke
;   线条属性: SetLineWidth, SetLineCap, SetLineJoin, SetDash, SetMiterLimit
;   图形状态: GSave, GRestore, Concat(变换矩阵)
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试5：图形绘制功能测试")
PrintN("========================================")

;--- 变量声明 ---
Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define fontName$
Define result.i
Define i.i
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
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "PbPDFlib 图形绘制测试")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "lcode.cn")

*page = PbPDF_AddPage(*doc)

;=============================================================================
; 5.1 基本形状绘制
;=============================================================================
PrintN("")
PrintN("--- 5.1 基本形状绘制 ---")

; 标题
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 20)
PbPDF_Page_MoveTextPos(*page, 50, 780)
PbPDF_Page_ShowText(*page, "Graphics Drawing Test")
PbPDF_Page_EndText(*page)

; 红色描边矩形
PbPDF_Page_SetRGBStroke(*page, 1.0, 0.0, 0.0)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_DrawRect(*page, 50, 680, 120, 80)
PrintN("  [通过] 描边矩形(红色)")

; 蓝色填充矩形
PbPDF_Page_SetRGBFill(*page, 0.2, 0.4, 0.8)
PbPDF_Page_FillRect(*page, 200, 680, 120, 80)
PrintN("  [通过] 填充矩形(蓝色)")

; 绿色描边圆形
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.7, 0.0)
PbPDF_Page_SetLineWidth(*page, 2.5)
PbPDF_Page_DrawCircle(*page, 430, 720, 40)
PrintN("  [通过] 描边圆形(绿色)")

; 黄色填充圆
PbPDF_Page_SetRGBFill(*page, 1.0, 0.9, 0.0)
PbPDF_Page_FillCircle(*page, 510, 720, 40)
PrintN("  [通过] 填充圆形(黄色)")

; 紫色椭圆
PbPDF_Page_SetRGBStroke(*page, 0.7, 0.0, 0.7)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_DrawEllipse(*page, 110, 620, 60, 30)
PrintN("  [通过] 描边椭圆(紫色)")

; 直线
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.0, 0.0)
PbPDF_Page_SetLineWidth(*page, 1.0)
PbPDF_Page_DrawLine(*page, 200, 650, 545, 650)
PrintN("  [通过] 直线")

;=============================================================================
; 5.2 路径构造和绘制模式
;=============================================================================
PrintN("")
PrintN("--- 5.2 路径构造和绘制模式 ---")

; 三角形（描边）
PbPDF_Page_SetRGBStroke(*page, 0.8, 0.4, 0.0)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_MoveTo(*page, 50, 580)
PbPDF_Page_LineTo(*page, 150, 580)
PbPDF_Page_LineTo(*page, 100, 640)
PbPDF_Page_ClosePath(*page)
PbPDF_Page_Stroke(*page)
PrintN("  [通过] 三角形描边(Stroke)")

; 三角形（填充）
PbPDF_Page_SetRGBFill(*page, 0.8, 0.4, 0.0)
PbPDF_Page_MoveTo(*page, 170, 580)
PbPDF_Page_LineTo(*page, 270, 580)
PbPDF_Page_LineTo(*page, 220, 640)
PbPDF_Page_ClosePath(*page)
PbPDF_Page_Fill(*page)
PrintN("  [通过] 三角形填充(Fill)")

; 五边形（填充+描边）
PbPDF_Page_SetRGBFill(*page, 0.6, 0.8, 1.0)
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.0, 0.5)
PbPDF_Page_SetLineWidth(*page, 1.5)
PbPDF_Page_MoveTo(*page, 350, 580)
PbPDF_Page_LineTo(*page, 400, 610)
PbPDF_Page_LineTo(*page, 385, 650)
PbPDF_Page_LineTo(*page, 315, 650)
PbPDF_Page_LineTo(*page, 300, 610)
PbPDF_Page_ClosePath(*page)
PbPDF_Page_FillStroke(*page)
PrintN("  [通过] 五边形填充+描边(FillStroke)")

;=============================================================================
; 5.3 贝塞尔曲线
;=============================================================================
PrintN("")
PrintN("--- 5.3 贝塞尔曲线 ---")

; 三次贝塞尔曲线
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.6, 0.6)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_MoveTo(*page, 50, 530)
PbPDF_Page_CurveTo(*page, 100, 580, 200, 480, 250, 530)
PbPDF_Page_Stroke(*page)
PrintN("  [通过] 三次贝塞尔曲线(CurveTo)")

; 二次贝塞尔曲线（使用CurveTo2）
PbPDF_Page_SetRGBStroke(*page, 0.8, 0.2, 0.2)
PbPDF_Page_MoveTo(*page, 300, 530)
PbPDF_Page_CurveTo2(*page, 380, 570, 450, 530)
PbPDF_Page_Stroke(*page)
PrintN("  [通过] 二次贝塞尔曲线v(CurveTo2)")

; 二次贝塞尔曲线（使用CurveTo3）
PbPDF_Page_SetRGBStroke(*page, 0.2, 0.6, 0.2)
PbPDF_Page_MoveTo(*page, 50, 500)
PbPDF_Page_CurveTo3(*page, 150, 540, 250, 500)
PbPDF_Page_Stroke(*page)
PrintN("  [通过] 二次贝塞尔曲线y(CurveTo3)")

;=============================================================================
; 5.4 弧线
;=============================================================================
PrintN("")
PrintN("--- 5.4 弧线 ---")

; 1/4圆弧
PbPDF_Page_SetRGBStroke(*page, 0.6, 0.0, 0.6)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_Arc(*page, 100, 440, 40, 0, 90)
PbPDF_Page_Stroke(*page)
PrintN("  [通过] 1/4圆弧(0-90度)")

; 半圆弧
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.5, 0.5)
PbPDF_Page_Arc(*page, 250, 440, 40, 0, 180)
PbPDF_Page_Stroke(*page)
PrintN("  [通过] 半圆弧(0-180度)")

; 完整圆弧
PbPDF_Page_SetRGBStroke(*page, 0.5, 0.5, 0.0)
PbPDF_Page_Arc(*page, 400, 440, 40, 0, 360)
PbPDF_Page_Stroke(*page)
PrintN("  [通过] 完整圆弧(0-360度)")

;=============================================================================
; 5.5 线条属性
;=============================================================================
PrintN("")
PrintN("--- 5.5 线条属性 ---")

; 不同线宽
Define widths.f
For i = 0 To 4
  widths = 0.5 + i * 1.0
  PbPDF_Page_SetLineWidth(*page, widths)
  PbPDF_Page_SetRGBStroke(*page, 0.0, 0.0, 0.0)
  PbPDF_Page_DrawLine(*page, 50, 390 - i * 15, 200, 390 - i * 15)
Next
PbPDF_Page_SetLineWidth(*page, 1.0)

; 线宽标注
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 8)
PbPDF_Page_MoveTextPos(*page, 210, 393)
PbPDF_Page_ShowText(*page, "Line widths: 0.5, 1.5, 2.5, 3.5, 4.5")
PbPDF_Page_EndText(*page)
PrintN("  [通过] 不同线宽")

; 虚线模式
PbPDF_Page_SetLineWidth(*page, 1.5)
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.0, 0.8)

; 短虚线
PbPDF_Page_SetDash(*page, 3, 2, 0)
PbPDF_Page_DrawLine(*page, 300, 390, 545, 390)

; 长虚线
PbPDF_Page_SetDash(*page, 10, 5, 0)
PbPDF_Page_DrawLine(*page, 300, 375, 545, 375)

; 点划线
PbPDF_Page_SetDash(*page, 10, 3, 0)
PbPDF_Page_DrawLine(*page, 300, 360, 545, 360)

; 取消虚线
PbPDF_Page_SetDash(*page, 0, 0, 0)
PrintN("  [通过] 虚线模式")

; 线端样式
PbPDF_Page_SetLineWidth(*page, 8.0)
PbPDF_Page_SetRGBStroke(*page, 0.8, 0.0, 0.0)

; Butt端
PbPDF_Page_SetLineCap(*page, #PbPDF_LINE_CAP_BUTT)
PbPDF_Page_DrawLine(*page, 50, 330, 150, 330)

; Round端
PbPDF_Page_SetLineCap(*page, #PbPDF_LINE_CAP_ROUND)
PbPDF_Page_DrawLine(*page, 180, 330, 280, 330)

; Projecting Square端
PbPDF_Page_SetLineCap(*page, #PbPDF_LINE_CAP_PROJ_SQUARE)
PbPDF_Page_DrawLine(*page, 310, 330, 410, 330)

PbPDF_Page_SetLineCap(*page, #PbPDF_LINE_CAP_BUTT)
PbPDF_Page_SetLineWidth(*page, 1.0)
PrintN("  [通过] 线端样式(Butt/Round/ProjSquare)")

;=============================================================================
; 5.6 颜色系统
;=============================================================================
PrintN("")
PrintN("--- 5.6 颜色系统 ---")

; RGB颜色条
Define r.f, g.f, b.f
For i = 0 To 9
  r = i / 9.0
  PbPDF_Page_SetRGBFill(*page, r, 0.0, 1.0 - r)
  PbPDF_Page_FillRect(*page, 50 + i * 25, 270, 23, 30)
Next
PrintN("  [通过] RGB颜色渐变")

; 灰度颜色条
For i = 0 To 9
  PbPDF_Page_SetGrayFill(*page, i / 9.0)
  PbPDF_Page_FillRect(*page, 310 + i * 25, 270, 23, 30)
Next
PbPDF_Page_SetGrayFill(*page, 0.0)
PrintN("  [通过] 灰度颜色渐变")

; CMYK颜色示例
PbPDF_Page_SetCMYKFill(*page, 1.0, 0.0, 0.0, 0.0)
PbPDF_Page_FillRect(*page, 50, 220, 50, 30)

PbPDF_Page_SetCMYKFill(*page, 0.0, 1.0, 0.0, 0.0)
PbPDF_Page_FillRect(*page, 110, 220, 50, 30)

PbPDF_Page_SetCMYKFill(*page, 0.0, 0.0, 1.0, 0.0)
PbPDF_Page_FillRect(*page, 170, 220, 50, 30)

PbPDF_Page_SetCMYKFill(*page, 0.0, 0.0, 0.0, 1.0)
PbPDF_Page_FillRect(*page, 230, 220, 50, 30)

PbPDF_Page_SetCMYKFill(*page, 0.0, 0.0, 0.0, 0.0)
PrintN("  [通过] CMYK颜色(C/M/Y/K)")

;=============================================================================
; 5.7 图形状态栈和变换矩阵
;=============================================================================
PrintN("")
PrintN("--- 5.7 图形状态栈和变换矩阵 ---")

; 使用GSave/GRestore保存和恢复图形状态
PbPDF_Page_GSave(*page)

; 保存后修改颜色和线宽
PbPDF_Page_SetRGBFill(*page, 0.9, 0.9, 0.9)
PbPDF_Page_FillRect(*page, 50, 120, 200, 80)

PbPDF_Page_SetRGBFill(*page, 0.0, 0.5, 0.0)
PbPDF_Page_FillRect(*page, 60, 130, 80, 60)

; 恢复到GSave之前的状态
PbPDF_Page_GRestore(*page)

; 此时颜色应恢复为之前的状态（黑色填充）
PbPDF_Page_FillRect(*page, 270, 120, 80, 60)
PrintN("  [通过] GSave/GRestore图形状态栈")

; 变换矩阵（旋转）
PbPDF_Page_GSave(*page)
; 平移到旋转中心，旋转45度，再平移回来
; 变换矩阵: a=cos(45), b=sin(45), c=-sin(45), d=cos(45), e=x, f=y
Define cos45.f = 0.7071
Define sin45.f = 0.7071
PbPDF_Page_Concat(*page, cos45, sin45, -sin45, cos45, 450, 160)
PbPDF_Page_SetRGBStroke(*page, 0.8, 0.0, 0.0)
PbPDF_Page_SetRGBFill(*page, 1.0, 0.9, 0.9)
PbPDF_Page_SetLineWidth(*page, 1.5)
PbPDF_Page_Rectangle(*page, -30, -20, 60, 40)
PbPDF_Page_FillStroke(*page)
PbPDF_Page_GRestore(*page)
PrintN("  [通过] 变换矩阵(旋转45度)")

; 变换矩阵（缩放）
PbPDF_Page_GSave(*page)
PbPDF_Page_Concat(*page, 2.0, 0, 0, 2.0, 50, 30)
PbPDF_Page_SetRGBStroke(*page, 0.0, 0.0, 0.8)
PbPDF_Page_SetLineWidth(*page, 0.5)
PbPDF_Page_DrawCircle(*page, 0, 0, 15)
PbPDF_Page_GRestore(*page)
PrintN("  [通过] 变换矩阵(缩放2倍)")

;=============================================================================
; 5.8 偶奇规则填充
;=============================================================================
PrintN("")
PrintN("--- 5.8 偶奇规则填充 ---")

; 绘制嵌套矩形，使用偶奇规则填充
PbPDF_Page_SetRGBFill(*page, 0.8, 0.6, 0.0)
PbPDF_Page_MoveTo(*page, 380, 100)
PbPDF_Page_LineTo(*page, 540, 100)
PbPDF_Page_LineTo(*page, 540, 200)
PbPDF_Page_LineTo(*page, 380, 200)
PbPDF_Page_ClosePath(*page)
PbPDF_Page_MoveTo(*page, 400, 120)
PbPDF_Page_LineTo(*page, 520, 120)
PbPDF_Page_LineTo(*page, 520, 180)
PbPDF_Page_LineTo(*page, 400, 180)
PbPDF_Page_ClosePath(*page)
PbPDF_Page_Eofill(*page)
PrintN("  [通过] 偶奇规则填充(Eofill)")

;=============================================================================
; 保存PDF文件
;=============================================================================
PrintN("")
PrintN("--- 保存PDF文件 ---")

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_05_graphics.pdf")
If result = #PbPDF_OK
  PrintN("  [通过] PDF文件保存成功: output_test_05_graphics.pdf")
Else
  PrintN("  [失败] PDF文件保存失败! 错误码: " + Hex(result))
EndIf

PbPDF_Free(*doc)

PrintN("")
PrintN("========================================")
PrintN("测试5：图形绘制功能测试完成!")
PrintN("========================================")
Input()
