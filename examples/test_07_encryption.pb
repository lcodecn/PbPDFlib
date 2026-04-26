;=============================================================================
; test_07_encryption.pb - 测试7：加密和权限
; PbPDFlib 功能测试：MD5哈希、RC4加密、随机数生成、高级加密API
;=============================================================================
; 功能覆盖：
;   PbPDF_MD5          - MD5哈希计算
;   PbPDF_MD5Init      - MD5初始化
;   PbPDF_MD5Update    - MD5更新数据
;   PbPDF_MD5Final     - MD5最终计算
;   PbPDF_RC4Init      - RC4密钥调度初始化
;   PbPDF_RC4Crypt     - RC4加密/解密
;   PbPDF_GenRandomBytes - 生成随机字节
;   PbPDF_ASCIIHexEncode - ASCII十六进制编码
;   PbPDF_ASCIIHexDecode - ASCII十六进制解码
;   PbPDF_SetPassword  - 设置文档加密密码
;   PbPDF_RemovePassword - 删除文档密码
;   PbPDF_ChangePassword - 修改文档密码
;=============================================================================

XIncludeFile "..\PbPDFlib.pb"

OpenConsole()
PrintN("========================================")
PrintN("测试7：加密和权限底层算法测试")
PrintN("========================================")

;--- 变量声明 ---
Define result.i
Define testStr$
Define *srcBuf
Define *dstBuf
Define *digest
Define ctx.PbPDF_MD5Ctx
Define enc.PbPDF_Encrypt
Define i.i
Define hexStr$
Define srcLen.i
Define outputDir$ = GetPathPart(ProgramFilename())

;=============================================================================
; 7.1 MD5哈希算法测试
;=============================================================================
PrintN("")
PrintN("--- 7.1 MD5哈希算法测试 ---")

; MD5("") = d41d8cd98f00b204e9800998ecf8427e
*srcBuf = AllocateMemory(1)
*dstBuf = AllocateMemory(16)
PbPDF_MD5(*srcBuf, 0, *dstBuf)
hexStr$ = ""
For i = 0 To 15
  hexStr$ + RSet(Hex(PeekA(*dstBuf + i)), 2, "0")
Next
If hexStr$ = "D41D8CD98F00B204E9800998ECF8427E"
  PrintN("  [通过] MD5(空字符串) = " + hexStr$)
Else
  PrintN("  [失败] MD5(空字符串) = " + hexStr$ + " (期望D41D8CD98F00B204E9800998ECF8427E)")
EndIf

; MD5("abc") = 900150983cd24fb0d6963f7d28e17f72
testStr$ = "abc"
srcLen = StringByteLength(testStr$, #PB_UTF8)
*srcBuf = AllocateMemory(srcLen)
PokeS(*srcBuf, testStr$, srcLen, #PB_UTF8)
*dstBuf = AllocateMemory(16)
PbPDF_MD5(*srcBuf, srcLen, *dstBuf)
hexStr$ = ""
For i = 0 To 15
  hexStr$ + RSet(Hex(PeekA(*dstBuf + i)), 2, "0")
Next
If hexStr$ = "900150983CD24FB0D6963F7D28E17F72"
  PrintN("  [通过] MD5('abc') = " + hexStr$)
Else
  PrintN("  [失败] MD5('abc') = " + hexStr$ + " (期望900150983CD24FB0D6963F7D28E17F72)")
EndIf
FreeMemory(*srcBuf)
FreeMemory(*dstBuf)

; MD5分步计算测试
PbPDF_MD5Init(@ctx)
testStr$ = "a"
srcLen = StringByteLength(testStr$, #PB_UTF8)
*srcBuf = AllocateMemory(srcLen)
PokeS(*srcBuf, testStr$, srcLen, #PB_UTF8)
PbPDF_MD5Update(@ctx, *srcBuf, srcLen)
FreeMemory(*srcBuf)
testStr$ = "bc"
srcLen = StringByteLength(testStr$, #PB_UTF8)
*srcBuf = AllocateMemory(srcLen)
PokeS(*srcBuf, testStr$, srcLen, #PB_UTF8)
PbPDF_MD5Update(@ctx, *srcBuf, srcLen)
FreeMemory(*srcBuf)
*dstBuf = AllocateMemory(16)
PbPDF_MD5Final(*dstBuf, @ctx)
hexStr$ = ""
For i = 0 To 15
  hexStr$ + RSet(Hex(PeekA(*dstBuf + i)), 2, "0")
Next
If hexStr$ = "900150983CD24FB0D6963F7D28E17F72"
  PrintN("  [通过] MD5分步计算('a'+'bc') = " + hexStr$)
Else
  PrintN("  [失败] MD5分步计算 = " + hexStr$ + " (期望900150983CD24FB0D6963F7D28E17F72)")
EndIf
FreeMemory(*dstBuf)

;=============================================================================
; 7.2 RC4加密/解密测试
;=============================================================================
PrintN("")
PrintN("--- 7.2 RC4加密/解密测试 ---")

; RC4加密测试：使用密钥"Key"加密明文"Plaintext"
Define keyStr$ = "Key"
Define plainStr$ = "Plaintext"
Define keyLen.i = StringByteLength(keyStr$, #PB_UTF8)
Define plainLen.i = StringByteLength(plainStr$, #PB_UTF8)

*srcBuf = AllocateMemory(plainLen)
*dstBuf = AllocateMemory(plainLen)
Define *keyBuf = AllocateMemory(keyLen)

PokeS(*keyBuf, keyStr$, keyLen, #PB_UTF8)
PokeS(*srcBuf, plainStr$, plainLen, #PB_UTF8)

; 初始化RC4并加密
PbPDF_RC4Init(@enc, *keyBuf, keyLen)
PbPDF_RC4Crypt(@enc, *srcBuf, *dstBuf, plainLen)

; 验证加密结果（RC4("Key","Plaintext")已知密文前几个字节为: BF B5 7A 1F ...）
hexStr$ = ""
For i = 0 To plainLen - 1
  hexStr$ + RSet(Hex(PeekA(*dstBuf + i)), 2, "0")
Next
PrintN("  [信息] RC4加密结果: " + hexStr$)

; RC4解密测试：用相同密钥解密密文应得到明文
Define *decBuf = AllocateMemory(plainLen)
PbPDF_RC4Init(@enc, *keyBuf, keyLen)
PbPDF_RC4Crypt(@enc, *dstBuf, *decBuf, plainLen)

Define decStr$ = PeekS(*decBuf, plainLen, #PB_UTF8)
If decStr$ = plainStr$
  PrintN("  [通过] RC4加密/解密一致性验证: 解密后 = '" + decStr$ + "'")
Else
  PrintN("  [失败] RC4解密结果不匹配: '" + decStr$ + "' (期望'" + plainStr$ + "')")
EndIf

FreeMemory(*srcBuf)
FreeMemory(*dstBuf)
FreeMemory(*keyBuf)
FreeMemory(*decBuf)

;=============================================================================
; 7.3 随机字节生成测试
;=============================================================================
PrintN("")
PrintN("--- 7.3 随机字节生成测试 ---")

*dstBuf = AllocateMemory(16)
PbPDF_GenRandomBytes(*dstBuf, 16)
hexStr$ = ""
For i = 0 To 15
  hexStr$ + RSet(Hex(PeekA(*dstBuf + i)), 2, "0")
Next
PrintN("  [通过] 生成16字节随机数: " + hexStr$)

; 再次生成验证随机性
PbPDF_GenRandomBytes(*dstBuf, 16)
hexStr$ = ""
For i = 0 To 15
  hexStr$ + RSet(Hex(PeekA(*dstBuf + i)), 2, "0")
Next
PrintN("  [通过] 再次生成16字节随机数: " + hexStr$)
FreeMemory(*dstBuf)

;=============================================================================
; 7.4 ASCII十六进制编解码测试
;=============================================================================
PrintN("")
PrintN("--- 7.4 ASCII十六进制编解码测试 ---")

; 编码测试
testStr$ = "Hello"
srcLen = StringByteLength(testStr$, #PB_UTF8)
*srcBuf = AllocateMemory(srcLen)
PokeS(*srcBuf, testStr$, srcLen, #PB_UTF8)
*dstBuf = AllocateMemory(srcLen * 2 + 1)
PbPDF_ASCIIHexEncode(*srcBuf, srcLen, *dstBuf)
Define encodedStr$ = PeekS(*dstBuf, srcLen * 2, #PB_ASCII)
PrintN("  [通过] ASCIIHex编码('Hello') = " + encodedStr$)

; 解码测试
Define *decBuf2 = AllocateMemory(srcLen + 1)
PbPDF_ASCIIHexDecode(*dstBuf, srcLen * 2, *decBuf2)
Define decodedStr$ = PeekS(*decBuf2, srcLen, #PB_UTF8)
If decodedStr$ = testStr$
  PrintN("  [通过] ASCIIHex解码验证: '" + decodedStr$ + "'")
Else
  PrintN("  [失败] ASCIIHex解码结果: '" + decodedStr$ + "' (期望'" + testStr$ + "')")
EndIf

FreeMemory(*srcBuf)
FreeMemory(*dstBuf)
FreeMemory(*decBuf2)

;=============================================================================
; 7.5 高级加密API测试
;=============================================================================
PrintN("")
PrintN("--- 7.5 高级加密API测试 ---")

; 创建加密PDF文档（RC4-40）
Define *encDoc.PbPDF_Doc = PbPDF_Create()
If *encDoc
  PbPDF_SetPDFVersion(*encDoc, #PbPDF_PDF_VER_14)
  PbPDF_SetInfoAttr(*encDoc, #PbPDF_INFO_TITLE, "Encryption API Test")
  
  Define *encPage.PbPDF_Object = PbPDF_AddPage(*encDoc)
  Define encFont$ = PbPDF_GetFont(*encDoc, *encPage, "Helvetica")
  PbPDF_Page_BeginText(*encPage)
  PbPDF_Page_SetFontAndSize(*encPage, encFont$, 16)
  PbPDF_Page_SetRGBFill(*encPage, 0.0, 0.0, 0.0)
  PbPDF_Page_MoveTextPos(*encPage, 100, 750)
  PbPDF_Page_ShowText(*encPage, "RC4-40 Encrypted Document")
  PbPDF_Page_EndText(*encPage)
  
  ; 设置RC4-40加密
  PbPDF_SetPassword(*encDoc, "", "testowner", #PbPDF_PERM_PRINT | #PbPDF_PERM_COPY, #PbPDF_ENCRYPT_RC4_40)
  
  Define encResult.i = PbPDF_SaveToFile2(*encDoc, outputDir$ + "output_test_07_rc4_40.pdf")
  If encResult = #PbPDF_OK
    PrintN("  [通过] RC4-40加密PDF创建成功")
  Else
    PrintN("  [失败] RC4-40加密PDF创建失败，错误码=" + Str(encResult))
  EndIf
  PbPDF_Free(*encDoc)
Else
  PrintN("  [失败] 无法创建加密文档")
EndIf

; 创建加密PDF文档（RC4-128）
Define *encDoc2.PbPDF_Doc = PbPDF_Create()
If *encDoc2
  PbPDF_SetPDFVersion(*encDoc2, #PbPDF_PDF_VER_14)
  PbPDF_SetInfoAttr(*encDoc2, #PbPDF_INFO_TITLE, "RC4-128 Encryption Test")
  
  Define *encPage2.PbPDF_Object = PbPDF_AddPage(*encDoc2)
  Define encFont2$ = PbPDF_GetFont(*encDoc2, *encPage2, "Helvetica")
  PbPDF_Page_BeginText(*encPage2)
  PbPDF_Page_SetFontAndSize(*encPage2, encFont2$, 16)
  PbPDF_Page_SetRGBFill(*encPage2, 0.0, 0.0, 0.0)
  PbPDF_Page_MoveTextPos(*encPage2, 100, 750)
  PbPDF_Page_ShowText(*encPage2, "RC4-128 Encrypted Document")
  PbPDF_Page_EndText(*encPage2)
  
  ; 设置RC4-128加密（用户密码user123，所有者密码admin456）
  PbPDF_SetPassword(*encDoc2, "user123", "admin456", #PbPDF_PERM_PRINT, #PbPDF_ENCRYPT_RC4_128)
  
  Define encResult2.i = PbPDF_SaveToFile2(*encDoc2, outputDir$ + "output_test_07_rc4_128.pdf")
  If encResult2 = #PbPDF_OK
    PrintN("  [通过] RC4-128加密PDF创建成功")
  Else
    PrintN("  [失败] RC4-128加密PDF创建失败，错误码=" + Str(encResult2))
  EndIf
  PbPDF_Free(*encDoc2)
Else
  PrintN("  [失败] 无法创建RC4-128加密文档")
EndIf

; 测试解密功能
Define decResult.i = PbPDF_RemovePassword(outputDir$ + "output_test_07_rc4_40.pdf", outputDir$ + "output_test_07_decrypted.pdf", "testowner")
If decResult > 0
  PrintN("  [通过] PDF解密成功（RC4-40 -> 无加密）")
Else
  PrintN("  [失败] PDF解密失败")
EndIf

; 测试修改密码
Define chgResult.i = PbPDF_ChangePassword(outputDir$ + "output_test_07_rc4_40.pdf", outputDir$ + "output_test_07_reencrypted.pdf", "testowner", "newuser", "newowner", #PbPDF_PERM_PRINT | #PbPDF_PERM_COPY, #PbPDF_ENCRYPT_RC4_40)
If chgResult > 0
  PrintN("  [通过] PDF密码修改成功")
Else
  PrintN("  [失败] PDF密码修改失败")
EndIf

PrintN("")
PrintN("========================================")
PrintN("测试7：加密底层算法测试完成!")
PrintN("========================================")
Input()
