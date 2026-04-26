# PbPDFlib Library v6.6

PbPDFlib \- PureBasic PDF 操作库

- 作者  : lcode.cn
- 版本  : 6.7
- 许可证  : Apache 2.0
- 编译器  : PureBasic 6.40 (Windows - x86)

***

## 简介

PbPDFlib 是一个纯 PureBasic 实现的 PDF 文件操作库，无需安装 Adobe Acrobat 或任何第三方依赖，即可创建、读取和修改 PDF 文件。

该库基于 Go 语言的 pdfcpu 项目和 C 语言的 libharu 项目移植而来，以 libharu 的 API 设计风格为主要参考（简洁、适合创建 PDF），同时融合 pdfcpu 的读取/修改/验证等高级功能，实现一个功能完备的 PureBasic PDF 库。所有算法（MD5、RC4、AES、SHA-256、FlateDecode、PNG 解析等）均用 PureBasic 原生实现，无第三方依赖。

## 主要功能

- 创建PDF文件  : 从零创建符合 PDF 标准的文档，支持 PDF 1.2-2.0
- 读取PDF文件  : 解析现有 PDF 文件内容，提取页面、信息、内容流
- 文本绘制  : 支持标准字体和 TrueType 字体，UTF-8 编码，字符间距/词间距/行距等
- 图形绘制  : 路径构造、描边/填充、颜色设置（RGB/CMYK/灰度）、变换矩阵
- 图片处理  : 支持 JPEG 和 PNG 图片加载与绘制，含透明通道
- 字体子集化  : TrueType 字体子集化，仅嵌入使用的字形，减小文件体积
- 加密/解密  : 支持 RC4-40/RC4-128/AES-128/AES-256 加密，密码和权限管理
- 书签/大纲  : 创建、修改、删除多级嵌套书签
- 注释  : 文本注释、链接注释、高亮注释等
- 水印  : 文本水印，支持旋转/透明度/对角线
- 页眉/页脚  : 为已有 PDF 添加页眉和页脚
- 页面操作  : 合并、拆分、提取、删除页面
- 扩展图形状态  : 透明度、混合模式

## 系统要求

- 本项目在 PureBasic 6.40 （Windows x86）中编译通过，其他环境请自行测试。

## 快速开始

具体可参考开发文档：docs\PbPDFlib\_Help.html

### 创建PDF文档

```purebasic
XIncludeFile "PbPDFlib.pb"

; 创建PDF文档
*doc.PbPDF_Doc = PbPDF_New()

; 添加A4页面
*page = PbPDF_AddPage(*doc)
PbPDF_Page_SetPredefinedSize(*page, #PbPDF_PAGE_SIZE_A4, #PbPDF_PAGE_PORTRAIT)

; 设置字体并写入文本
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, "Helvetica", 24)
PbPDF_Page_MoveTextPos(*page, 50, 750)
PbPDF_Page_ShowText(*page, "Hello PbPDFlib!")
PbPDF_Page_EndText(*page)

; 保存文件
PbPDF_SaveToFile(*doc, "output.pdf")

; 释放资源
PbPDF_Free(*doc)
```

### 使用TrueType字体显示中文

```purebasic
XIncludeFile "PbPDFlib.pb"

*doc.PbPDF_Doc = PbPDF_New()
*page = PbPDF_AddPage(*doc)
PbPDF_Page_SetPredefinedSize(*page, #PbPDF_PAGE_SIZE_A4, #PbPDF_PAGE_PORTRAIT)

; 加载TTF字体
*font.PbPDF_Font = PbPDF_LoadTTFontFromFile(*doc, "C:\Windows\Fonts\msyh.ttc", #True)
fontName$ = PbPDF_RegisterTTFont(*doc, *page, *font)

; 显示中文文本
PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, "你好，PbPDFlib！", 24)

PbPDF_SaveToFile(*doc, "chinese.pdf")
PbPDF_Free(*doc)
```

### 读取并修改已有PDF

```purebasic
XIncludeFile "PbPDFlib.pb"

; 加载PDF文件
*ldoc.PbPDF_LoadedDoc = PbPDF_LoadFromFile("input.pdf")
If *ldoc
  pageCount = PbPDF_LoadGetPageCount(*ldoc)
  version$ = PbPDF_LoadGetVersion(*ldoc)
  Debug "页数: " + pageCount + " 版本: " + version$
EndIf
```

### 合并PDF文件

```purebasic
XIncludeFile "PbPDFlib.pb"

result = PbPDF_MergePDFFiles("merged.pdf", "file1.pdf|file2.pdf|file3.pdf")
If result = #PbPDF_OK
  Debug "合并成功！"
EndIf
```

## API 文档

### 文档管理

| 函数 | 说明 |
|------|------|
| `PbPDF_New()` | 创建PDF文档对象，返回文档指针 |
| `PbPDF_Free(*doc)` | 释放PDF文档对象 |
| `PbPDF_NewDoc(*doc)` | 在已有对象上创建新文档 |
| `PbPDF_FreeDoc(*doc)` | 释放文档内容 |
| `PbPDF_SaveToFile(*doc, fileName$)` | 保存PDF到文件 |
| `PbPDF_SetCompressionMode(*doc, mode)` | 设置压缩模式 |
| `PbPDF_SetPDFVersion(*doc, version)` | 设置PDF版本（1.2-2.0） |
| `PbPDF_GetPageCount(*doc)` | 获取页面总数 |

### 页面操作

| 函数 | 说明 |
|------|------|
| `PbPDF_AddPage(*doc)` | 添加新页面 |
| `PbPDF_AddPageA4(*doc)` | 添加A4纵向页面 |
| `PbPDF_AddPageCustom(*doc, width, height)` | 添加自定义尺寸页面 |
| `PbPDF_AddPagePredefined(*doc, pageSize, direction)` | 添加预定义尺寸页面 |
| `PbPDF_GetPageByIndex(*doc, index)` | 按索引获取页面 |
| `PbPDF_GetCurrentPage(*doc)` | 获取当前页面 |
| `PbPDF_Page_SetSize(*page, width, height)` | 设置页面尺寸 |
| `PbPDF_Page_SetPredefinedSize(*page, size, direction)` | 设置预定义页面尺寸 |
| `PbPDF_Page_GetWidth(*page)` | 获取页面宽度 |
| `PbPDF_Page_GetHeight(*page)` | 获取页面高度 |

### 文本绘制

| 函数 | 说明 |
|------|------|
| `PbPDF_Page_BeginText(*page)` | 开始文本对象 |
| `PbPDF_Page_EndText(*page)` | 结束文本对象 |
| `PbPDF_Page_SetFontAndSize(*page, fontName$, fontSize)` | 设置字体和大小 |
| `PbPDF_Page_ShowText(*page, text$)` | 显示文本 |
| `PbPDF_Page_ShowTextNextLine(*page, text$)` | 下一行显示文本 |
| `PbPDF_Page_MoveTextPos(*page, x, y)` | 移动文本位置 |
| `PbPDF_Page_SetCharSpace(*page, value)` | 设置字符间距 |
| `PbPDF_Page_SetWordSpace(*page, value)` | 设置词间距 |
| `PbPDF_Page_SetHorizontalScalling(*page, value)` | 设置水平缩放 |
| `PbPDF_Page_SetTextLeading(*page, value)` | 设置文本行距 |
| `PbPDF_Page_SetTextRenderingMode(*page, mode)` | 设置文本渲染模式 |
| `PbPDF_Page_SetTextRise(*page, value)` | 设置文本上升 |
| `PbPDF_Page_ShowTextUTF8(*page, text$)` | 显示UTF-8文本 |
| `PbPDF_Page_ShowTextUTF8Ex(*doc, *page, *font, text$, fontSize)` | 显示UTF-8文本（高级） |

### 图形绘制

| 函数 | 说明 |
|------|------|
| `PbPDF_Page_MoveTo(*page, x, y)` | 移动到指定点 |
| `PbPDF_Page_LineTo(*page, x, y)` | 画直线到指定点 |
| `PbPDF_Page_CurveTo(*page, x1, y1, x2, y2, x3, y3)` | 三次贝塞尔曲线 |
| `PbPDF_Page_CurveTo2(*page, x2, y2, x3, y3)` | 简化贝塞尔曲线 |
| `PbPDF_Page_CurveTo3(*page, x1, y1, x3, y3)` | 简化贝塞尔曲线 |
| `PbPDF_Page_Rectangle(*page, x, y, w, h)` | 绘制矩形 |
| `PbPDF_Page_Arc(*page, x, y, radius, angle1, angle2)` | 绘制弧线 |
| `PbPDF_Page_ClosePath(*page)` | 闭合路径 |
| `PbPDF_Page_Stroke(*page)` | 描边 |
| `PbPDF_Page_Fill(*page)` | 填充 |
| `PbPDF_Page_Eofill(*page)` | 奇偶规则填充 |
| `PbPDF_Page_FillStroke(*page)` | 填充并描边 |
| `PbPDF_Page_ClosePathStroke(*page)` | 闭合路径并描边 |
| `PbPDF_Page_ClosePathFillStroke(*page)` | 闭合路径填充并描边 |
| `PbPDF_Page_EndPath(*page)` | 结束路径不绘制 |

### 颜色与线条

| 函数 | 说明 |
|------|------|
| `PbPDF_Page_SetRGBFill(*page, r, g, b)` | 设置RGB填充色 |
| `PbPDF_Page_SetRGBStroke(*page, r, g, b)` | 设置RGB描边色 |
| `PbPDF_Page_SetCMYKFill(*page, c, m, y, k)` | 设置CMYK填充色 |
| `PbPDF_Page_SetCMYKStroke(*page, c, m, y, k)` | 设置CMYK描边色 |
| `PbPDF_Page_SetGrayFill(*page, value)` | 设置灰度填充色 |
| `PbPDF_Page_SetGrayStroke(*page, value)` | 设置灰度描边色 |
| `PbPDF_Page_SetLineWidth(*page, width)` | 设置线宽 |
| `PbPDF_Page_SetLineCap(*page, capStyle)` | 设置线端样式 |
| `PbPDF_Page_SetLineJoin(*page, joinStyle)` | 设置线连接样式 |
| `PbPDF_Page_SetMiterLimit(*page, limit)` | 设置斜接限制 |
| `PbPDF_Page_SetDash(*page, dashOn, dashOff, phase)` | 设置虚线模式 |

### 图形状态

| 函数 | 说明 |
|------|------|
| `PbPDF_Page_GSave(*page)` | 保存图形状态 |
| `PbPDF_Page_GRestore(*page)` | 恢复图形状态 |
| `PbPDF_Page_Concat(*page, a, b, c, d, x, y)` | 连接变换矩阵 |
| `PbPDF_Page_SetExtGState(*doc, *page, *gstate)` | 应用扩展图形状态 |
| `PbPDF_GStateNewEx(*doc, fillAlpha, strokeAlpha, blendMode)` | 创建扩展图形状态 |

### 便捷绘图

| 函数 | 说明 |
|------|------|
| `PbPDF_Page_DrawLine(*page, x1, y1, x2, y2)` | 绘制直线 |
| `PbPDF_Page_DrawRect(*page, x, y, w, h)` | 绘制矩形（描边） |
| `PbPDF_Page_FillRect(*page, x, y, w, h)` | 填充矩形 |
| `PbPDF_Page_DrawCircle(*page, x, y, radius)` | 绘制圆形（描边） |
| `PbPDF_Page_FillCircle(*page, x, y, radius)` | 填充圆形 |
| `PbPDF_Page_DrawEllipse(*page, x, y, rx, ry)` | 绘制椭圆（描边） |

### 图片操作

| 函数 | 说明 |
|------|------|
| `PbPDF_LoadJPEGImageFromFile(*doc, fileName$)` | 从文件加载JPEG图片 |
| `PbPDF_LoadPNGImageFromFile(*doc, fileName$)` | 从文件加载PNG图片 |
| `PbPDF_LoadCompressedImage(*doc, fileName$, scaleFactor, jpegQuality)` | 加载并压缩图片 |
| `PbPDF_Page_DrawImage(*doc, *page, *image, x, y, w, h)` | 绘制图片到页面 |

### 字体操作

| 函数 | 说明 |
|------|------|
| `PbPDF_LoadTTFontFromFile(*doc, fileName$, embedding)` | 从文件加载TTF字体 |
| `PbPDF_LoadTTFont(*doc, fontName$, embedding)` | 按名称加载TTF字体 |
| `PbPDF_FindSystemFont(fontName$)` | 查找系统字体文件 |
| `PbPDF_RegisterTTFont(*doc, *page, *font)` | 注册TTF字体到页面 |
| `PbPDF_RegisterCIDFont(*doc, *page, *font)` | 注册CID字体到页面 |
| `PbPDF_GetFont(*doc, *page, fontName$)` | 获取字体名称 |

### 书签/大纲

| 函数 | 说明 |
|------|------|
| `PbPDF_CreateOutline(*doc, title$, *parent, *dest, opened)` | 创建大纲项 |
| `PbPDF_SetOutlineOpened(*outline, opened)` | 设置展开/折叠 |
| `PbPDF_CreateDestination(*page, destType, left, top, right, bottom, zoom)` | 创建跳转目标 |
| `PbPDF_ModifyOutlineTitle(*outline, newTitle$)` | 修改大纲标题 |
| `PbPDF_ModifyOutlineDest(*outline, *newDest)` | 修改大纲目标 |
| `PbPDF_ModifyOutlineColor(*outline, r, g, b)` | 修改大纲颜色 |
| `PbPDF_ModifyOutlineStyle(*outline, styleFlags)` | 修改大纲样式 |
| `PbPDF_DeleteOutline(*doc, *outline)` | 删除大纲 |
| `PbPDF_GetFirstOutline(*doc)` | 获取第一个大纲 |
| `PbPDF_GetOutlineFirst(*outline)` | 获取大纲第一个子项 |
| `PbPDF_GetOutlineNext(*outline)` | 获取下一个兄弟大纲 |
| `PbPDF_GetOutlineTitle(*outline)` | 获取大纲标题 |

### 注释

| 函数 | 说明 |
|------|------|
| `PbPDF_CreateTextAnnot(*doc, *page, x, y, w, h, title$, contents$)` | 创建文本注释 |
| `PbPDF_CreateLinkAnnot(*doc, *page, x, y, w, h, *dest)` | 创建链接注释 |
| `PbPDF_CreateURILinkAnnot(*doc, *page, x, y, w, h, uri$)` | 创建URI链接注释 |
| `PbPDF_CreateHighlightAnnot(*doc, *page, x, y, w, h, title$, contents$, r, g, b)` | 创建高亮注释 |
| `PbPDF_SetAnnotBorder(*annot, borderStyle, borderWidth, dashOn, dashOff)` | 设置注释边框 |

### 加密/权限

| 函数 | 说明 |
|------|------|
| `PbPDF_SetPassword(*doc, userPwd$, ownerPwd$, permission, encryptionMode)` | 设置密码和加密 |
| `PbPDF_SetDecryptPassword(*ldoc, password$)` | 解密PDF文档 |
| `PbPDF_RemovePassword(inputFile$, outputFile$, ownerPwd$)` | 移除PDF密码 |
| `PbPDF_ChangePassword(inputFile$, outputFile$, oldOwnerPwd$, newUserPwd$, newOwnerPwd$, permission, encryptionMode)` | 修改PDF密码 |

### 水印/页眉页脚

| 函数 | 说明 |
|------|------|
| `PbPDF_AddTextWatermark(*doc, text$, fontSize, rotation, opacity, r, g, b, diagonal, fontName$)` | 添加文本水印 |
| `PbPDF_AddWatermarkToFile(inputFile$, outputFile$, text$, fontSize, angle, r, g, b)` | 为文件添加水印 |
| `PbPDF_AddHeaderFooter(inputFile$, outputFile$, headerText$, footerText$, fontSize)` | 添加页眉页脚 |

### PDF读取/解析

| 函数 | 说明 |
|------|------|
| `PbPDF_LoadFromFile(fileName$)` | 从文件读取PDF |
| `PbPDF_LoadGetPageCount(*ldoc)` | 获取已加载PDF页数 |
| `PbPDF_LoadGetPageSize(*ldoc, pageIndex, *width, *height)` | 获取页面尺寸 |
| `PbPDF_LoadGetInfoAttr(*ldoc, attrKey$)` | 获取文档属性 |
| `PbPDF_LoadGetVersion(*ldoc)` | 获取PDF版本 |
| `PbPDF_LoadGetPageContent(*ldoc, pageIndex)` | 获取页面内容流 |

### PDF页面操作

| 函数 | 说明 |
|------|------|
| `PbPDF_MergePDFFiles(outputFileName$, inputFiles$)` | 合并多个PDF |
| `PbPDF_ExtractPages(inputFile$, outputFile$, startPage, endPage)` | 提取页面 |
| `PbPDF_SplitPDF(inputFile$, outputPrefix$)` | 拆分PDF |
| `PbPDF_DeletePages(inputFile$, outputFile$, startPage, endPage)` | 删除页面 |

### 文档信息

| 函数 | 说明 |
|------|------|
| `PbPDF_SetInfoAttr(*doc, attrType, value$)` | 设置文档属性 |
| `PbPDF_GetInfoAttr(*doc, attrType)` | 获取文档属性 |

## 文件结构

PbPDFlib.pb 文件按照功能模块分为以下分区：

| 分区 | 内容 |
|------|------|
| 第1部分 | 常量和枚举定义（PDF版本、对象类型、图形模式、加密模式等） |
| 第2部分 | 基础数据结构（Point/Rect/Matrix/Color/DashMode等） |
| 第3部分 | 基础算法（MD5/RC4/ASCIIHex/UTF8/CRC32/随机数等） |
| 第4部分 | 内存管理和工具函数（List/Error/Stream） |
| 第5部分 | PDF对象模型（Null/Boolean/Number/Real/Name/String/Binary/Array/Dict） |
| 第6部分 | 交叉引用表（XRef） |
| 第7部分 | 对象序列化（WriteToStream/WriteIndirectObj） |
| 第8部分 | 文档管理（New/Free/NewDoc/FreeDoc/SaveToFile） |
| 第9部分 | 页面管理（AddPage/PageSize） |
| 第10部分 | 目标链接（Destination） |
| 第11部分 | 书签/大纲（Outline） |
| 第12部分 | 注释（Annotation） |
| 第13部分 | 扩展图形状态（ExtGState） |
| 第14部分 | 水印（Watermark） |
| 第15部分 | 加密（Encrypt/Password） |
| 第16部分 | TTF字体处理（FontLoad/Subset/GlyphMap） |
| 第17部分 | CID字体和UTF-8编码 |
| 第18部分 | 压缩模式 |
| 第19部分 | 图片处理（JPEG/PNG） |
| 第20部分 | 页面操作符（路径/文本/颜色/变换） |
| 第21部分 | PDF读取和解析（Lexer/Parser/XRef） |
| 第22部分 | PDF页面操作（Merge/Extract/Split/Delete） |
| 第23部分 | 页眉页脚/文件水印 |
| 第24部分 | PDF解密/密码管理 |
| 第25部分 | 大纲修改/删除 |
| 第26部分 | 公共API |

## 版本历史

### v6.7 (2026-04-26)

- \[修复] PDF标准密码填充字符串(PbPDF_EncryptPadding)错误，导致加密PDF无法被第三方软件打开
- \[修复] PbPDF_SetDecryptPassword函数缺少R3(RC4-128)的50次MD5迭代
- \[修复] 测试文件路径问题，统一使用GetPathPart(ProgramFilename())获取输出目录
- \[新增] 捐赠/赞助信息
- \[新增] 英文版README和帮助文档

### v6.6 (2026-04-26)

- \[新增] 生成HTML帮助文档（PbPDFlib\_Help.html）
- \[新增] 添加README.md文档
- \[新增] 功能参考来源对照表（infos.md）
- \[优化] 完善代码注释和文档

### v6.5 (2026-03-05)

- \[新增] 大纲删除功能（PbPDF\_DeleteOutline）
- \[新增] 大纲树释放和取消链接功能
- \[新增] 大纲遍历API（GetFirstOutline/GetOutlineFirst/GetOutlineNext/GetOutlineTitle）
- \[修复] 大纲树写入时计数递归错误

### v6.4 (2026-01-29)

- \[新增] 大纲颜色修改（PbPDF\_ModifyOutlineColor）
- \[新增] 大纲样式修改（PbPDF\_ModifyOutlineStyle）
- \[新增] 大纲展开状态修改（PbPDF\_ModifyOutlineOpened）
- \[优化] 大纲修改功能增强

### v6.3 (2025-12-27)

- \[新增] 大纲标题修改（PbPDF\_ModifyOutlineTitle）
- \[新增] 大纲目标修改（PbPDF\_ModifyOutlineDest）
- \[修复] 修改大纲后PDF保存时对象引用错误

### v6.2 (2025-11-24)

- \[新增] PDF版本设置功能（PbPDF\_SetPDFVersion），支持PDF 1.2-2.0
- \[新增] 压缩模式设置（PbPDF\_SetCompressionMode）
- \[优化] SaveToFile2支持内容流压缩

### v6.1 (2025-10-22)

- \[新增] 便捷绘图函数（DrawLine/DrawRect/FillRect/DrawCircle/FillCircle/DrawEllipse）
- \[新增] 弧线绘制（PbPDF\_Page\_Arc）
- \[优化] 图形绘制API完善

### v6.0 (2025-09-19)

- \[新增] PDF密码修改功能（PbPDF\_ChangePassword）
- \[新增] PDF密码移除功能（PbPDF\_RemovePassword）
- \[优化] 加密流程重构，支持增量更新

### v5.9 (2025-08-17)

- \[新增] PDF解密功能（PbPDF\_SetDecryptPassword）
- \[新增] 加密PDF文件读取支持
- \[修复] RC4解密时对象密钥计算错误

### v5.8 (2025-07-15)

- \[新增] 页眉页脚功能（PbPDF\_AddHeaderFooter）
- \[新增] 文件级水印功能（PbPDF\_AddWatermarkToFile）
- \[优化] 对已有PDF的修改能力增强

### v5.7 (2025-06-12)

- \[新增] PDF删除页面功能（PbPDF\_DeletePages）
- \[新增] PDF拆分功能（PbPDF\_SplitPDF）
- \[修复] 删除页面后页面树更新错误

### v5.6 (2025-05-10)

- \[新增] PDF提取页面功能（PbPDF\_ExtractPages）
- \[新增] PDF合并功能（PbPDF\_MergePDFFiles）
- \[优化] 页面操作时资源字典合并

### v5.5 (2025-04-07)

- \[新增] PDF页面内容提取（PbPDF\_LoadGetPageContent）
- \[新增] PDF文档属性获取（PbPDF\_LoadGetInfoAttr）
- \[新增] PDF版本检测（PbPDF\_LoadGetVersion）

### v5.4 (2025-03-05)

- \[新增] PDF页面尺寸获取（PbPDF\_LoadGetPageSize）
- \[新增] PDF页面数量获取（PbPDF\_LoadGetPageCount）
- \[优化] PDF读取模块稳定性提升

### v5.3 (2025-01-31)

- \[新增] PDF对象解析器（PbPDF\_ParseObj/ParseIndirectObj）
- \[新增] XRef表解析（PbPDF\_ParseXRefTable）
- \[新增] 对象解引用（PbPDF\_ResolveObj）

### v5.2 (2024-12-29)

- \[新增] PDF词法分析器（PbPDF\_LexReadToken）
- \[新增] PDF字符串解析（字面字符串/十六进制字符串）
- \[新增] PDF名称和数组解析

### v5.1 (2024-11-26)

- \[新增] PDF文件读取功能（PbPDF\_LoadFromFile）
- \[新增] StartXRef定位和XRef表解析
- \[新增] 已加载PDF文档结构管理

### v5.0 (2024-10-24)

- \[新增] PDF文件读取框架搭建
- \[新增] 文件读取缓冲区管理
- \[优化] 整体架构调整，支持读取模式

### v4.9 (2024-09-21)

- \[修复] 大字体文件嵌入时内存溢出问题
- \[修复] PNG图片Alpha通道处理错误
- \[优化] 内存管理优化，减少碎片

### v4.8 (2024-08-19)

- \[新增] 完整测试套件（15个测试文件）
- \[修复] 加密PDF保存后无法打开的问题
- \[优化] 错误处理完善

### v4.7 (2024-07-17)

- \[新增] 文件级水印和页眉页脚框架
- \[优化] PDF写入性能提升
- \[修复] 大文件保存时流缓冲区溢出

### v4.6 (2024-06-14)

- \[新增] 高亮注释（PbPDF\_CreateHighlightAnnot）
- \[新增] 注释边框设置（PbPDF\_SetAnnotBorder）
- \[优化] 注释字典生成逻辑

### v4.5 (2024-05-12)

- \[新增] URI链接注释（PbPDF\_CreateURILinkAnnot）
- \[新增] 链接注释（PbPDF\_CreateLinkAnnot）
- \[修复] 注释矩形区域坐标计算错误

### v4.4 (2024-04-09)

- \[新增] 文本注释（PbPDF\_CreateTextAnnot）
- \[新增] 注释类型名称映射
- \[优化] 注释对象结构设计

### v4.3 (2024-03-07)

- \[新增] 文本水印功能（PbPDF\_AddTextWatermark）
- \[新增] 对角线水印支持
- \[新增] 水印透明度和旋转

### v4.2 (2024-02-03)

- \[新增] 扩展图形状态（PbPDF\_GStateNewEx）
- \[新增] 透明度设置（填充/描边Alpha）
- \[新增] 混合模式设置（12种混合模式）

### v4.1 (2024-01-01)

- \[新增] 大纲展开/折叠设置（PbPDF\_SetOutlineOpened）
- \[新增] 跳转目标类型（XYZ/Fit/FitH/FitV/FitR/FitB/FitBH/FitBV）
- \[优化] 大纲树写入逻辑

### v4.0 (2023-11-29)

- \[新增] 书签/大纲创建（PbPDF\_CreateOutline）
- \[新增] 大纲树构建（First/Last/Prev/Next指针链）
- \[新增] 跳转目标（PbPDF\_CreateDestination）

### v3.9 (2023-10-27)

- \[新增] AES-256加密支持
- \[新增] SHA-256哈希算法实现
- \[优化] 加密模块重构

### v3.8 (2023-09-24)

- \[新增] AES-128加密支持
- \[新增] AES S-Box和密钥扩展实现
- \[新增] CBC模式和PKCS#7填充

### v3.7 (2023-08-22)

- \[新增] RC4-128加密支持
- \[新增] 对象级加密（基于obj\_id/gen\_no密钥生成）
- \[修复] RC4加密密钥调度算法错误

### v3.6 (2023-07-20)

- \[新增] PDF加密功能（PbPDF\_SetPassword）
- \[新增] RC4-40加密支持
- \[新增] MD5哈希算法实现
- \[新增] 权限标志设置

### v3.5 (2023-06-17)

- \[新增] PNG图片Alpha通道/透明度处理
- \[新增] PNG tRNS块解析
- \[修复] PNG灰度图片颜色空间设置错误

### v3.4 (2023-05-15)

- \[新增] PNG图片加载（PbPDF\_LoadPNGImageFromFile）
- \[新增] PNG文件头验证和IDAT块解析
- \[新增] PNG过滤器反过滤（None/Sub/Up/Average/Paeth）

### v3.3 (2023-04-12)

- \[新增] JPEG图片加载（PbPDF\_LoadJPEGImageFromFile）
- \[新增] JPEG文件头解析（SOI/SOF/SOS标记）
- \[新增] 图片绘制（PbPDF\_Page\_DrawImage）

### v3.2 (2023-03-10)

- \[新增] 压缩图片加载（PbPDF\_LoadCompressedImage）
- \[新增] 图片缩放和JPEG质量控制
- \[优化] 图片资源管理

### v3.1 (2023-02-05)

- \[新增] CID字体字典创建（PbPDF\_CreateCIDFontDict）
- \[新增] CID字体注册（PbPDF\_RegisterCIDFont）
- \[新增] CID ToUnicode CMap生成

### v3.0 (2023-01-03)

- \[新增] UTF-8文本高级显示（PbPDF\_Page\_ShowTextUTF8Ex）
- \[新增] 子集化ToUnicode CMap生成
- \[优化] UTF-8编码流程重构

### v2.9 (2022-12-01)

- \[新增] UTF-8文本显示（PbPDF\_Page\_ShowTextUTF8）
- \[新增] UTF8转PDF十六进制编码（PbPDF\_EncodeUTF8ToPDFHex）
- \[新增] ToUnicode CMap生成（PbPDF\_CreateToUnicodeCMap）

### v2.8 (2022-10-29)

- \[新增] TTF字体子集化（PbPDF\_TTFontCreateSubset）
- \[新增] 字形映射表排序和查找
- \[新增] 子集字体流生成

### v2.7 (2022-09-26)

- \[新增] 字形使用标记（PbPDF\_TTFontMarkGlyphUsed）
- \[新增] 字形偏移表查找
- \[优化] 字体子集化准备工作

### v2.6 (2022-08-24)

- \[新增] 系统字体查找（PbPDF\_FindSystemFont）
- \[新增] Windows注册表字体搜索
- \[新增] 按名称加载TTF字体（PbPDF\_LoadTTFont）

### v2.5 (2022-07-22)

- \[新增] TTF字体注册（PbPDF\_RegisterTTFont）
- \[新增] TTF字体字典创建（PbPDF\_CreateTTFontDict）
- \[新增] 字体资源字典管理

### v2.4 (2022-06-19)

- \[新增] TTF字体加载（PbPDF\_LoadTTFontFromFile）
- \[新增] TTF文件头和表解析
- \[新增] CMap Format4解析

### v2.3 (2022-05-17)

- \[新增] TTF字体属性结构（PbPDF\_TTFontAttr）
- \[新增] TTF偏移表和字形度量
- \[优化] 字体定义结构完善

### v2.2 (2022-04-14)

- \[新增] 14种标准字体宽度度量数据
- \[新增] Base14字体定义
- \[新增] 字体注册和获取API

### v2.1 (2022-03-12)

- \[新增] 字体定义结构（PbPDF\_FontDef）
- \[新增] 字体对象结构（PbPDF\_Font）
- \[新增] WinAnsiEncoding编码器

### v2.0 (2022-02-07)

- \[新增] 图形状态栈（GSave/GRestore）
- \[新增] 变换矩阵（PbPDF\_Page\_Concat）
- \[新增] 图形状态结构（PbPDF\_GState）
- \[优化] 页面内容流管理重构

### v1.9 (2022-01-05)

- \[新增] 虚线模式设置（PbPDF\_Page\_SetDash）
- \[新增] 线端样式（SetLineCap）
- \[新增] 线连接样式（SetLineJoin）
- \[新增] 斜接限制（SetMiterLimit）

### v1.8 (2021-12-03)

- \[新增] CMYK颜色设置（SetCMYKFill/SetCMYKStroke）
- \[新增] 灰度颜色设置（SetGrayFill/SetGrayStroke）
- \[优化] 颜色空间管理

### v1.7 (2021-11-01)

- \[新增] RGB颜色设置（SetRGBFill/SetRGBStroke）
- \[新增] 线宽设置（SetLineWidth）
- \[新增] 路径绘制操作（Stroke/Fill/Eofill/FillStroke等）

### v1.6 (2021-09-29)

- \[新增] 路径构造操作（MoveTo/LineTo/CurveTo/Rectangle/ClosePath）
- \[新增] 三次贝塞尔曲线（CurveTo/CurveTo2/CurveTo3）
- \[优化] 页面图形模式管理

### v1.5 (2021-08-27)

- \[新增] 文本渲染模式设置
- \[新增] 文本上升设置
- \[新增] 字符间距/词间距/行距/水平缩放设置

### v1.4 (2021-07-25)

- \[新增] 文本绘制功能（BeginText/EndText/ShowText/MoveTextPos）
- \[新增] 字体和大小设置（SetFontAndSize）
- \[新增] 下一行显示文本（ShowTextNextLine）

### v1.3 (2021-06-22)

- \[新增] 预定义页面尺寸（A3/A4/A5/Letter/Legal等）
- \[新增] 页面方向设置（纵向/横向）
- \[新增] 便捷页面创建函数（AddPageA4/AddPageCustom/AddPagePredefined）

### v1.2 (2021-05-20)

- \[新增] 页面尺寸设置和获取
- \[新增] 页面内容流管理
- \[新增] 多页面支持
- \[修复] 页面字典写入时资源引用错误

### v1.1 (2021-04-18)

- \[新增] PDF文档保存功能（PbPDF\_SaveToFile）
- \[新增] 交叉引用表写入
- \[新增] Trailer字典写入
- \[新增] PDF文件头和文件尾写入

### v1.0 (2021-03-15)

- \[新增] 初始项目创建，参考pdfcpu和libharu编写
- \[新增] PDF对象模型（Null/Boolean/Number/Real/Name/String/Binary/Array/Dict）
- \[新增] 内存管理模块（PbPDF\_List动态列表）
- \[新增] 流处理模块（FileStream/MemStream）
- \[新增] 交叉引用表结构
- \[新增] 错误处理机制
- \[新增] PDF文档对象结构（PbPDF\_Doc）
- \[新增] 基础算法（CRC32/ASCIIHex/UTF8解码/随机数生成）

## 赞助 / 捐赠

如果 PbPDFlib 对您有帮助，欢迎赞助支持项目的持续开发和维护！

- **PayPal** : https://www.paypal.me/lcodecn
- **微信支付** : #付款:lcodecn(经营_lcodecn)/openlib/003

您的每一份支持都是作者继续完善开源项目的动力，感谢！

## 许可证

本库采用 Apache 2.0 许可证。

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

本库参考的 pdfcpu 项目采用 Apache 2.0 许可证。

```

                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright [yyyy] [name of copyright owner]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

```

本库参考的 libharu 项目采用 ZLIB/LIBPNG 许可证。

```
Copyright (C) 1999-2006 Takeshi Kanno
Copyright (C) 2007-2009 Antony Dovgal

This software is provided 'as-is', without any express or implied warranty.

In no event will the authors be held liable for any damages arising from the 
use of this software.

Permission is granted to anyone to use this software for any purpose,including 
commercial applications, and to alter it and redistribute it freely, subject 
to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not claim 
    that you wrote the original software. If you use this software in a 
    product, an acknowledgment in the product documentation would be 
    appreciated but is not required.
 2. Altered source versions must be plainly marked as such, and must not be 
    misrepresented as being the original software.
 3. This notice may not be removed or altered from any source distribution.
```

## 致谢

- 感谢 pdfcpu 项目提供了优秀的 PDF 读取/修改参考实现
- 感谢 libharu 项目提供了优秀的 PDF 创建参考实现
- 感谢 PureBasic QQ群的支持
