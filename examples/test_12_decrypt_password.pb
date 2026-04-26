;=============================================================================
; test_12_decrypt_password.pb - PDF加密/解密/修改密码功能测试
; 测试PbPDFlib的PDF加密、删除密码、修改密码功能
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole("PbPDFlib - PDF加密/解密功能测试")

Define *doc.PbPDF_Doc
Define *page.PbPDF_Object
Define fontName$
Define result.i
Define outputDir$ = GetPathPart(ProgramFilename())

;--- 第1步：创建一个加密的PDF文件 ---
PrintN("=== 第1步：创建加密PDF文件 ===")

*doc = PbPDF_Create()
If Not *doc
  PrintN("错误：无法创建PDF文档")
  Goto EndTest
EndIf

PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Encryption Test Document")
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, "PbPDFlib")

; 创建3个页面
*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.3, 0.7)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Encrypted PDF - Page 1")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "This document is encrypted with RC4-128.")
PbPDF_Page_MoveTextPos(*page, 0, -20)
PbPDF_Page_ShowText(*page, "User password: (empty)")
PbPDF_Page_MoveTextPos(*page, 0, -20)
PbPDF_Page_ShowText(*page, "Owner password: owner123")
PbPDF_Page_EndText(*page)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.7, 0.0, 0.3)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Encrypted PDF - Page 2")
PbPDF_Page_EndText(*page)

PbPDF_Page_SetRGBStroke(*page, 0.0, 0.5, 0.0)
PbPDF_Page_SetLineWidth(*page, 2.0)
PbPDF_Page_DrawCircle(*page, 300, 500, 60)

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 24)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.5, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "Encrypted PDF - Page 3")
PbPDF_Page_EndText(*page)

; 设置加密（RC4-40，用户密码为空，所有者密码为owner123）
PbPDF_SetPassword(*doc, "", "owner123", #PbPDF_PERM_PRINT | #PbPDF_PERM_COPY, #PbPDF_ENCRYPT_RC4_40)

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_12_encrypted.pdf")
If result = #PbPDF_OK
  PrintN("加密PDF文件已创建：output_test_12_encrypted.pdf")
Else
  PrintN("错误：无法保存加密PDF文件，错误码=" + Hex(result))
EndIf
PbPDF_Free(*doc)

;--- 第2步：验证加密PDF文件 ---
PrintN("")
PrintN("=== 第2步：验证加密PDF文件 ===")

Define *ldoc.PbPDF_LoadedDoc = PbPDF_LoadFromFile(outputDir$ + "output_test_12_encrypted.pdf")
If *ldoc
  PrintN("加密PDF文件加载成功！")
  PrintN("页数：" + Str(PbPDF_LoadGetPageCount(*ldoc)))
  PrintN("版本：" + PbPDF_LoadGetVersion(*ldoc))
  PbPDF_FreeLoadedDoc(*ldoc)
Else
  PrintN("注意：加密PDF文件无法直接读取内容（需要解密）")
EndIf

;--- 第3步：删除密码（解密） ---
PrintN("")
PrintN("=== 第3步：删除密码（解密PDF） ===")

result = PbPDF_RemovePassword(outputDir$ + "output_test_12_encrypted.pdf", outputDir$ + "output_test_12_decrypted.pdf", "owner123")
If result = 1
  PrintN("密码删除成功！已保存为：output_test_12_decrypted.pdf")
Else
  PrintN("错误：密码删除失败")
EndIf

;--- 第4步：验证解密后的PDF文件 ---
PrintN("")
PrintN("=== 第4步：验证解密后的PDF文件 ===")

*ldoc = PbPDF_LoadFromFile(outputDir$ + "output_test_12_decrypted.pdf")
If *ldoc
  PrintN("解密PDF文件加载成功！")
  PrintN("页数：" + Str(PbPDF_LoadGetPageCount(*ldoc)))
  PrintN("版本：" + PbPDF_LoadGetVersion(*ldoc))
  Define pw.f, ph.f
  If PbPDF_LoadGetPageSize(*ldoc, 0, @pw, @ph)
    PrintN("第1页尺寸：" + StrF(pw, 1) + " x " + StrF(ph, 1))
  EndIf
  PbPDF_FreeLoadedDoc(*ldoc)
Else
  PrintN("错误：解密PDF文件无法加载")
EndIf

;--- 第5步：创建RC4-40加密的PDF ---
PrintN("")
PrintN("=== 第5步：创建RC4-40加密的PDF ===")

*doc = PbPDF_Create()
PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_13)
PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "RC4-40 Encrypted")

*page = PbPDF_AddPage(*doc)
fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica-Bold")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 20)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.5)
PbPDF_Page_MoveTextPos(*page, 100, 750)
PbPDF_Page_ShowText(*page, "RC4-40 Encrypted Document")
PbPDF_Page_EndText(*page)

fontName$ = PbPDF_GetFont(*doc, *page, "Helvetica")
PbPDF_Page_BeginText(*page)
PbPDF_Page_SetFontAndSize(*page, fontName$, 12)
PbPDF_Page_SetRGBFill(*page, 0.0, 0.0, 0.0)
PbPDF_Page_MoveTextPos(*page, 100, 700)
PbPDF_Page_ShowText(*page, "User password: user123")
PbPDF_Page_MoveTextPos(*page, 0, -20)
PbPDF_Page_ShowText(*page, "Owner password: admin456")
PbPDF_Page_EndText(*page)

; RC4-40加密
PbPDF_SetPassword(*doc, "user123", "admin456", #PbPDF_PERM_PRINT, #PbPDF_ENCRYPT_RC4_40)

result = PbPDF_SaveToFile2(*doc, outputDir$ + "output_test_12_rc4_40.pdf")
If result = #PbPDF_OK
  PrintN("RC4-40加密PDF已创建：output_test_12_rc4_40.pdf")
EndIf
PbPDF_Free(*doc)

;--- 第6步：修改密码 ---
PrintN("")
PrintN("=== 第6步：修改PDF密码 ===")

result = PbPDF_ChangePassword(outputDir$ + "output_test_12_encrypted.pdf", outputDir$ + "output_test_12_reencrypted.pdf", "owner123", "newuser", "newowner", #PbPDF_PERM_PRINT | #PbPDF_PERM_COPY, #PbPDF_ENCRYPT_RC4_40)
If result = 1
  PrintN("密码修改成功！新密码：user=newuser, owner=newowner")
  PrintN("已保存为：output_test_12_reencrypted.pdf")
Else
  PrintN("错误：密码修改失败")
EndIf

;--- 第7步：验证修改密码后的PDF ---
PrintN("")
PrintN("=== 第7步：验证修改密码后的PDF ===")

*ldoc = PbPDF_LoadFromFile(outputDir$ + "output_test_12_reencrypted.pdf")
If *ldoc
  PrintN("修改密码后的PDF加载成功！")
  PrintN("页数：" + Str(PbPDF_LoadGetPageCount(*ldoc)))
  PbPDF_FreeLoadedDoc(*ldoc)
Else
  PrintN("修改密码后的PDF无法直接读取（已加密，需要密码打开）")
EndIf

; 再解密一次验证
result = PbPDF_RemovePassword(outputDir$ + "output_test_12_reencrypted.pdf", outputDir$ + "output_test_12_re_decrypted.pdf", "newowner")
If result = 1
  PrintN("重新解密成功！")
  *ldoc = PbPDF_LoadFromFile(outputDir$ + "output_test_12_re_decrypted.pdf")
  If *ldoc
    PrintN("重新解密后的PDF页数：" + Str(PbPDF_LoadGetPageCount(*ldoc)))
    PbPDF_FreeLoadedDoc(*ldoc)
  EndIf
Else
  PrintN("重新解密失败")
EndIf

;--- 第8步：文件大小比较 ---
PrintN("")
PrintN("=== 第8步：文件大小比较 ===")

Define encSize.i = FileSize(outputDir$ + "output_test_12_encrypted.pdf")
Define decSize.i = FileSize(outputDir$ + "output_test_12_decrypted.pdf")
Define rc4Size.i = FileSize(outputDir$ + "output_test_12_rc4_40.pdf")
Define reEncSize.i = FileSize(outputDir$ + "output_test_12_reencrypted.pdf")
PrintN("RC4-128加密文件大小：" + Str(encSize) + "字节")
PrintN("解密后文件大小：" + Str(decSize) + "字节")
PrintN("RC4-40加密文件大小：" + Str(rc4Size) + "字节")
PrintN("修改密码后文件大小：" + Str(reEncSize) + "字节")

EndTest:
PrintN("")
PrintN("=== PDF加密/解密功能测试完成 ===")
PrintN("按回车键退出...")
Input()
CloseConsole()

; IDE Options = PureBasic 6.40 (Windows - x86)
; EnableThread
; EnableXP
; DPIAware
; CompileSourceDirectory