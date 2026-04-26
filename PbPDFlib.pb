;=============================================================================
; PbPDFlib.pb - PureBasic PDF操作库
; Copyright (c) lcode.cn
; Licensed under the Apache License, Version 2.0
;
; 基于pdfcpu(Go)和libharu(C)开源项目移植
; 无第三方依赖，纯PureBasic原生实现
;
; 赞助/捐赠:
;   PayPal: https://www.paypal.me/lcodecn
;   微信支付: #付款:lcodecn(经营_lcodecn)/openlib/003
;=============================================================================

;--- 初始化Cipher库(用于MD5等加密功能) ---
UseMD5Fingerprint()

;=============================================================================
; 第1部分：常量和枚举定义
;=============================================================================

;--- 库版本 ---
#PbPDF_VERSION_MAJOR = 0
#PbPDF_VERSION_MINOR = 1
#PbPDF_VERSION_PATCH = 0
#PbPDF_VERSION_TEXT$ = "0.1.0"

;--- PDF版本 ---
#PbPDF_PDF_VER_12 = 0   ; PDF 1.2
#PbPDF_PDF_VER_13 = 1   ; PDF 1.3
#PbPDF_PDF_VER_14 = 2   ; PDF 1.4
#PbPDF_PDF_VER_15 = 3   ; PDF 1.5
#PbPDF_PDF_VER_16 = 4   ; PDF 1.6
#PbPDF_PDF_VER_17 = 5   ; PDF 1.7
#PbPDF_PDF_VER_20 = 6   ; PDF 2.0

;--- PDF对象类型 ---
#PbPDF_OBJ_NULL     = 0
#PbPDF_OBJ_BOOLEAN  = 1
#PbPDF_OBJ_NUMBER   = 2
#PbPDF_OBJ_REAL     = 3
#PbPDF_OBJ_NAME     = 4
#PbPDF_OBJ_STRING   = 5
#PbPDF_OBJ_BINARY   = 6
#PbPDF_OBJ_ARRAY    = 7
#PbPDF_OBJ_DICT     = 8
#PbPDF_OBJ_INDIRECT = 9

;--- 对象子类 ---
#PbPDF_OSUBCLASS_NONE       = $0000
#PbPDF_OSUBCLASS_FONT       = $0100
#PbPDF_OSUBCLASS_CATALOG    = $0200
#PbPDF_OSUBCLASS_PAGES      = $0300
#PbPDF_OSUBCLASS_PAGE       = $0400
#PbPDF_OSUBCLASS_XOBJECT    = $0500
#PbPDF_OSUBCLASS_OUTLINE    = $0600
#PbPDF_OSUBCLASS_DESTINATION= $0700
#PbPDF_OSUBCLASS_ANNOTATION = $0800
#PbPDF_OSUBCLASS_ENCRYPT    = $0900
#PbPDF_OSUBCLASS_EXT_GSTATE = $0A00
#PbPDF_OSUBCLASS_INFO       = $0B00
#PbPDF_OSUBCLASS_NAMES      = $0C00

;--- 对象标志 ---
#PbPDF_OTYPE_DIRECT   = $80000000
#PbPDF_OTYPE_INDIRECT = $40000000

;--- 交叉引用条目类型 ---
#PbPDF_XREF_FREE_ENTRY    = 0
#PbPDF_XREF_INUSE_ENTRY   = 1

;--- 压缩模式 ---
#PbPDF_COMP_NONE     = $00
#PbPDF_COMP_TEXT     = $01
#PbPDF_COMP_IMAGE    = $02
#PbPDF_COMP_METADATA = $04
#PbPDF_COMP_ALL      = $0F

;--- 流过滤器 ---
#PbPDF_STREAM_FILTER_NONE         = $00
#PbPDF_STREAM_FILTER_FLATE_DECODE = $01
#PbPDF_STREAM_FILTER_ASCIIHEX     = $02
#PbPDF_STREAM_FILTER_ASCII85      = $04
#PbPDF_STREAM_FILTER_DCT_DECODE   = $08
#PbPDF_STREAM_FILTER_CCITT_DECODE = $10
#PbPDF_STREAM_FILTER_LZW_DECODE   = $20
#PbPDF_STREAM_FILTER_RUNLENGTH    = $40

;--- 图形模式 ---
#PbPDF_GMODE_PAGE_DESCRIPTION = $0001
#PbPDF_GMODE_PATH_OBJECT      = $0002
#PbPDF_GMODE_TEXT_OBJECT       = $0004
#PbPDF_GMODE_CLIPPING_PATH    = $0008

;--- 线端样式 ---
#PbPDF_LINE_CAP_BUTT   = 0
#PbPDF_LINE_CAP_ROUND  = 1
#PbPDF_LINE_CAP_PROJ_SQUARE = 2

;--- 线连接样式 ---
#PbPDF_LINE_JOIN_MITER = 0
#PbPDF_LINE_JOIN_ROUND = 1
#PbPDF_LINE_JOIN_BEVEL = 2

;--- 文本渲染模式 ---
#PbPDF_TEXT_RENDER_FILL            = 0
#PbPDF_TEXT_RENDER_STROKE          = 1
#PbPDF_TEXT_RENDER_FILL_STROKE     = 2
#PbPDF_TEXT_RENDER_INVISIBLE       = 3
#PbPDF_TEXT_RENDER_FILL_CLIP       = 4
#PbPDF_TEXT_RENDER_STROKE_CLIP     = 5
#PbPDF_TEXT_RENDER_FILL_STROKE_CLIP= 6
#PbPDF_TEXT_RENDER_CLIP            = 7

;--- 色彩空间 ---
#PbPDF_CS_DEVICEGRAY = 0
#PbPDF_CS_DEVICERGB  = 1
#PbPDF_CS_DEVICECMYK = 2

;--- 页面尺寸 ---
#PbPDF_PAGE_SIZE_LETTER    = 0
#PbPDF_PAGE_SIZE_LEGAL     = 1
#PbPDF_PAGE_SIZE_A3        = 2
#PbPDF_PAGE_SIZE_A4        = 3
#PbPDF_PAGE_SIZE_A5        = 4
#PbPDF_PAGE_SIZE_B4        = 5
#PbPDF_PAGE_SIZE_B5        = 6
#PbPDF_PAGE_SIZE_EXECUTIVE = 7
#PbPDF_PAGE_SIZE_US4x6     = 8
#PbPDF_PAGE_SIZE_US4x8     = 9
#PbPDF_PAGE_SIZE_US5x7     = 10
#PbPDF_PAGE_SIZE_COMM10    = 11

;--- 页面方向 ---
#PbPDF_PAGE_PORTRAIT  = 0
#PbPDF_PAGE_LANDSCAPE = 1

;--- 字体类型 ---
#PbPDF_FONT_TYPE1       = 0
#PbPDF_FONT_TRUETYPE    = 1
#PbPDF_FONT_TYPE0_CID   = 2
#PbPDF_FONT_TYPE0_TT    = 3
#PbPDF_FONT_CID_TYPE0   = 4
#PbPDF_FONT_CID_TYPE2   = 5

;--- 字体定义类型 ---
#PbPDF_FONTDEF_TYPE1  = 0
#PbPDF_FONTDEF_TRUETYPE = 1
#PbPDF_FONTDEF_CID   = 2

;--- 编码器类型 ---
#PbPDF_ENCODER_SINGLE_BYTE = 0
#PbPDF_ENCODER_DOUBLE_BYTE = 1
#PbPDF_ENCODER_UTF8        = 2

;--- 图片颜色空间 ---
#PbPDF_CS_DEVICEGRAY = 0
#PbPDF_CS_DEVICERGB  = 1
#PbPDF_CS_DEVICECMYK = 2
#PbPDF_CS_INDEXED    = 3

;--- 图片类型 ---
#PbPDF_IMAGE_JPEG = 0
#PbPDF_IMAGE_PNG  = 1

;--- 加密模式 ---
#PbPDF_ENCRYPT_RC4_40  = 0
#PbPDF_ENCRYPT_RC4_128 = 1
#PbPDF_ENCRYPT_AES_128 = 2
#PbPDF_ENCRYPT_AES_256 = 3

;--- 权限标志 ---
#PbPDF_PERM_PRINT       = 4
#PbPDF_PERM_EDIT_ALL    = 8
#PbPDF_PERM_COPY        = 16
#PbPDF_PERM_EDIT        = 32
#PbPDF_PERM_FILL_FORM   = 256
#PbPDF_PERM_EXTRACT     = 512
#PbPDF_PERM_ASSEMBLE    = 1024
#PbPDF_PERM_PRINT_HIRES = 2048

;--- 注释类型 ---
#PbPDF_ANNOT_TEXT           = 0
#PbPDF_ANNOT_LINK           = 1
#PbPDF_ANNOT_SOUND          = 2
#PbPDF_ANNOT_FREE_TEXT      = 3
#PbPDF_ANNOT_STAMP          = 4
#PbPDF_ANNOT_SQUARE         = 5
#PbPDF_ANNOT_CIRCLE         = 6
#PbPDF_ANNOT_STRIKE_OUT     = 7
#PbPDF_ANNOT_HIGHLIGHT      = 8
#PbPDF_ANNOT_UNDERLINE      = 9
#PbPDF_ANNOT_INK            = 10
#PbPDF_ANNOT_FILE_ATTACHMENT= 11
#PbPDF_ANNOT_POPUP          = 12
#PbPDF_ANNOT_3D             = 13
#PbPDF_ANNOT_SQUIGGLY       = 14
#PbPDF_ANNOT_LINE           = 15
#PbPDF_ANNOT_PROJECTION     = 16
#PbPDF_ANNOT_WIDGET         = 17

;--- 印章类型 ---
#PbPDF_STAMP_APPROVED        = 0
#PbPDF_STAMP_EXPERIMENTAL    = 1
#PbPDF_STAMP_NOTAPPROVED     = 2
#PbPDF_STAMP_SOLD            = 3
#PbPDF_STAMP_DEPARTMENTAL    = 4
#PbPDF_STAMP_FORCOMMENT      = 5
#PbPDF_STAMP_TOPSECRET       = 6
#PbPDF_STAMP_FORPUBLICRELEASE= 7

;--- Windows API文件操作常量 ---
; 用于系统字体文件的读取，PureBasic的ReadFile无法读取C:\Windows\Fonts\目录下的文件
; 需要使用Windows API的CreateFile_和ReadFile_来替代
#PbPDF_WIN_GENERIC_READ       = $80000000
#PbPDF_WIN_FILE_SHARE_READ    = $00000001
#PbPDF_WIN_FILE_SHARE_WRITE   = $00000002
#PbPDF_WIN_OPEN_EXISTING      = 3
#PbPDF_WIN_FILE_ATTRIBUTE_NORMAL = $00000080
#PbPDF_WIN_INVALID_HANDLE_VALUE = -1
#PbPDF_STAMP_CONFIDENTIAL    = 8
#PbPDF_STAMP_DRAFT           = 9
#PbPDF_STAMP_FINAL           = 10

;--- 混合模式 ---
#PbPDF_BLEND_NORMAL     = 0
#PbPDF_BLEND_MULTIPLY   = 1
#PbPDF_BLEND_SCREEN     = 2
#PbPDF_BLEND_OVERLAY    = 3
#PbPDF_BLEND_DARKEN     = 4
#PbPDF_BLEND_LIGHTEN    = 5
#PbPDF_BLEND_COLOR_DODGE= 6
#PbPDF_BLEND_COLOR_BURN = 7
#PbPDF_BLEND_HARD_LIGHT = 8
#PbPDF_BLEND_SOFT_LIGHT = 9
#PbPDF_BLEND_DIFFERENCE = 10
#PbPDF_BLEND_EXCLUSION  = 11

;--- 目标类型 ---
#PbPDF_DEST_XYZ   = 0
#PbPDF_DEST_FIT   = 1
#PbPDF_DEST_FITH  = 2
#PbPDF_DEST_FITV  = 3
#PbPDF_DEST_FITR  = 4
#PbPDF_DEST_FITB  = 5
#PbPDF_DEST_FITBH = 6
#PbPDF_DEST_FITBV = 7

;--- 水印类型 ---
#PbPDF_WM_TEXT  = 0
#PbPDF_WM_IMAGE = 1
#PbPDF_WM_PDF   = 2

;--- 边框样式 ---
#PbPDF_BORDER_SOLID   = 0
#PbPDF_BORDER_DASHED  = 1
#PbPDF_BORDER_BEVELED = 2
#PbPDF_BORDER_INSET   = 3
#PbPDF_BORDER_UNDERLINE = 4

;--- 文档信息属性 ---
#PbPDF_INFO_AUTHOR         = 0
#PbPDF_INFO_CREATOR        = 1
#PbPDF_INFO_PRODUCER       = 2
#PbPDF_INFO_TITLE          = 3
#PbPDF_INFO_SUBJECT        = 4
#PbPDF_INFO_KEYWORDS       = 5
#PbPDF_INFO_CREATION_DATE  = 6
#PbPDF_INFO_MOD_DATE       = 7
#PbPDF_INFO_TRAPPED        = 8

;--- 验证模式 ---
#PbPDF_VALIDATION_STRICT   = 0
#PbPDF_VALIDATION_RELAXED  = 1
#PbPDF_VALIDATION_NONE     = 2

;--- 限制常量 ---
#PbPDF_MAX_GSTATE_DEPTH    = 28
#PbPDF_MAX_PAGE_SIZE       = 14400
#PbPDF_MIN_PAGE_SIZE       = 3
#PbPDF_MAX_PASSWORD_LEN    = 32
#PbPDF_DEFAULT_XREF_ENTRIES= 1024
#PbPDF_MEM_STREAM_BUF_SIZE = 4096
#PbPDF_MAX_GENERATION_NUM  = 65535

;--- 错误码 ---
#PbPDF_OK                  = 0
#PbPDF_ERR_UNKNOWN         = $1001
#PbPDF_ERR_INVALID_OBJ     = $1002
#PbPDF_ERR_INVALID_DOC     = $1003
#PbPDF_ERR_INVALID_PAGE    = $1004
#PbPDF_ERR_INVALID_FONT    = $1005
#PbPDF_ERR_INVALID_ENCODING= $1006
#PbPDF_ERR_INVALID_IMAGE   = $1007
#PbPDF_ERR_INVALID_STREAM  = $1008
#PbPDF_ERR_INVALID_DICT    = $1009
#PbPDF_ERR_INVALID_ARRAY   = $100A
#PbPDF_ERR_INVALID_PASSWORD= $100B
#PbPDF_ERR_INVALID_ENCRYPT = $100C
#PbPDF_ERR_FILE_NOT_FOUND  = $100D
#PbPDF_ERR_FILE_OPEN       = $100E
#PbPDF_ERR_FILE_WRITE      = $100F
#PbPDF_ERR_MEM_ALLOC       = $1010
#PbPDF_ERR_PAGE_MODE       = $1011
#PbPDF_ERR_GMODE           = $1012
#PbPDF_ERR_FONT_NOT_FOUND  = $1013
#PbPDF_ERR_ENCODER_NOT_FOUND=$1014
#PbPDF_ERR_UNSUPPORTED     = $1015
#PbPDF_ERR_PDF_PARSE       = $1016
#PbPDF_ERR_XREF            = $1017
#PbPDF_ERR_EOF             = $1018
#PbPDF_ERR_IO              = $1019
#PbPDF_ERR_ENCRYPT         = $101A

;=============================================================================
; 第2部分：基础数据结构
;=============================================================================

;--- 二维点 ---
Structure PbPDF_Point
  x.f
  y.f
EndStructure

;--- 矩形区域 ---
Structure PbPDF_Rect
  llx.f   ; 左下角X
  lly.f   ; 左下角Y
  urx.f   ; 右上角X
  ury.f   ; 右上角Y
EndStructure

;--- 边框框 ---
Structure PbPDF_Box
  left.w
  bottom.w
  right.w
  top.w
EndStructure

;--- RGB颜色 ---
Structure PbPDF_RGBColor
  r.f
  g.f
  b.f
EndStructure

;--- CMYK颜色 ---
Structure PbPDF_CMYKColor
  c.f
  m.f
  y.f
  k.f
EndStructure

;--- 变换矩阵 ---
Structure PbPDF_Matrix
  a.f
  b.f
  c.f
  d.f
  x.f
  y.f
EndStructure

;--- 虚线模式 ---
Structure PbPDF_DashMode
  dashArray.l[8]  ; 虚线数组(最多8个元素)
  numDash.i       ; 虚线数组元素个数
  phase.i         ; 虚线起始相位
EndStructure

;--- 边框样式 ---
Structure PbPDF_BorderStyle
  width.f
  dashOn.f
  dashOff.f
EndStructure

;--- 页面尺寸 ---
Structure PbPDF_PageSize
  width.f
  height.f
EndStructure

;--- 边距 ---
Structure PbPDF_Margins
  left.f
  right.f
  top.f
  bottom.f
EndStructure

;--- 日期结构 ---
Structure PbPDF_Date
  year.w
  month.a
  day.a
  hour.a
  minute.a
  second.a
  ind.a         ; UTC偏移符号(+/-/Z)
  offHour.a     ; UTC偏移小时
  offMinute.a   ; UTC偏移分钟
EndStructure

;=============================================================================
; 前向声明（PureBasic使用Interface和指针实现面向对象）
;=============================================================================

;--- 动态列表 ---
Structure PbPDF_List
  *items.Long     ; 项目数组指针
  count.i         ; 当前项目数
  capacity.i      ; 当前容量
  itemSize.i      ; 每项大小(字节)
EndStructure

;--- 错误对象 ---
Structure PbPDF_Error
  errorCode.i     ; 错误码
  errorDetail.i   ; 错误详情
  errorMsg.s      ; 错误消息
EndStructure

;--- 内存流属性 ---
Structure PbPDF_MemStreamAttr
  *bufList.PbPDF_List  ; 缓冲区块列表
  bufSize.i            ; 当前缓冲区已用大小
  totalSize.i          ; 总大小
  readPos.i            ; 读取位置
EndStructure

;--- 流对象 ---
Structure PbPDF_Stream
  streamType.i         ; 流类型(0=文件,1=内存,2=回调)
  size.i               ; 流大小
  *attr                ; 类型特定属性
  ; 文件流属性
  fileID.i             ; 文件句柄
  fileName.s           ; 文件名
  ; 内存流属性
  *memAttr.PbPDF_MemStreamAttr
EndStructure

;--- 字典元素 ---
Structure PbPDF_DictElement
  key.s                   ; 键名
  *value.PbPDF_Object     ; 值对象指针
EndStructure

;--- 字典元素列表项(使用固定大小键名避免CopyMemory字符串问题) ---
Structure PbPDF_DictEntry
  key.s                   ; 键名
  *value.PbPDF_Object     ; 值对象指针
EndStructure

;--- PDF对象 ---
Structure PbPDF_Object
  objType.i            ; 对象类型(#PbPDF_OBJ_xxx)
  objId.i              ; 对象ID
  genNo.i               ; 生成号
  objClass.i           ; 对象子类(#PbPDF_OSUBCLASS_xxx)
  flags.i              ; 标志
  ; 根据objType使用不同值域
  boolValue.i          ; Boolean值
  numberValue.i        ; Number值
  realValue.f          ; Real值
  nameValue.s          ; Name值
  stringValue.s        ; String值
  *arrayData.PbPDF_List; Array数据(元素为PbPDF_Object指针)
  *dictKeys.PbPDF_List ; Dict键名列表(字符串指针)
  *dictValues.PbPDF_List; Dict值列表(PbPDF_Object指针)
  *stream.PbPDF_Stream ; 关联流(用于流字典对象)
  filter.i             ; 流过滤器
  ; 类型特定属性指针
  *attr                ; 类型特定属性
EndStructure

;--- 交叉引用条目 ---
Structure PbPDF_XRefEntry
  entryType.i          ; 条目类型(#PbPDF_XREF_FREE_ENTRY/#PbPDF_XREF_INUSE_ENTRY)
  byteOffset.i         ; 字节偏移
  genNo.i               ; 生成号
  *obj.PbPDF_Object     ; 对象指针
EndStructure

;--- 交叉引用表 ---
Structure PbPDF_XRef
  *entries.PbPDF_List  ; 交叉引用条目列表(PbPDF_XRefEntry指针)
  startOffset.i        ; 起始偏移
  addr.i               ; 当前写入地址
  *prev.PbPDF_XRef     ; 前一个xref(链式)
  *trailer.PbPDF_Object; Trailer字典对象
EndStructure

;--- 图形状态 ---
Structure PbPDF_GState
  transMatrix.PbPDF_Matrix  ; 变换矩阵
  lineWidth.f               ; 线宽
  lineCap.i                 ; 线端样式
  lineJoin.i                ; 线连接样式
  miterLimit.f              ; 斜接限制
  dashMode.PbPDF_DashMode   ; 虚线模式
  charSpace.f               ; 字符间距
  wordSpace.f               ; 词间距
  hScalling.f               ; 水平缩放
  textLeading.f             ; 文本行距
  renderingMode.i           ; 文本渲染模式
  textRise.f                ; 文本上升
  csFill.i                  ; 填充色彩空间
  csStroke.i                ; 描边色彩空间
  rgbFill.PbPDF_RGBColor    ; 填充RGB颜色
  rgbStroke.PbPDF_RGBColor  ; 描边RGB颜色
  cmykFill.PbPDF_CMYKColor  ; 填充CMYK颜色
  cmykStroke.PbPDF_CMYKColor; 描边CMYK颜色
  grayFill.f                ; 填充灰度
  grayStroke.f              ; 描边灰度
  *font                     ; 当前字体(前向引用)
  fontSize.f                ; 字体大小
  fillAlpha.f               ; 填充透明度(0.0~1.0)
  strokeAlpha.f             ; 描边透明度(0.0~1.0)
  blendMode.i               ; 混合模式(#PbPDF_BLEND_xxx)
  *dictObj.PbPDF_Object     ; ExtGState字典对象(用于透明度/混合模式)
  *prev.PbPDF_GState        ; 前一个状态(栈链)
  depth.i                   ; 栈深度
EndStructure

;--- 页面属性(内嵌在PbPDF_Object的attr中) ---
Structure PbPDF_PageAttr
  *parent.PbPDF_Object     ; 父Pages节点对象
  *fonts.PbPDF_Object      ; 字体资源字典
  *xobjects.PbPDF_Object   ; XObject资源字典
  *extGStates.PbPDF_Object ; 扩展图形状态字典
  *gstate.PbPDF_GState     ; 当前图形状态(栈顶)
  strPos.PbPDF_Point       ; 文本起始位置
  curPos.PbPDF_Point       ; 当前绘图位置
  textPos.PbPDF_Point      ; 当前文本位置
  textMatrix.PbPDF_Matrix  ; 文本变换矩阵
  gmode.i                  ; 当前图形模式
  *contents.PbPDF_Object   ; 内容流字典对象
  *contentStream.PbPDF_Stream ; 内容流
  *xref.PbPDF_XRef         ; 交叉引用
  compressionMode.i        ; 压缩模式
  mediaBox.PbPDF_Rect      ; 页面媒体框
EndStructure

;--- 编码器属性(BasicEncoder) ---
Structure PbPDF_BasicEncoderAttr
  name.s                   ; 编码器名称
  *unicodeMap.Long         ; Unicode映射表(256项)
  *differences             ; 差异表(256项)
  hasDifferences.i         ; 是否有差异
EndStructure

;--- 编码器对象 ---
Structure PbPDF_Encoder
  name.s                   ; 编码器名称
  type.i                   ; 编码器类型(#PbPDF_ENCODER_xxx)
  *attr                    ; 类型特定属性
  *byteTypeFn              ; 字节类型判断函数指针
  *toUnicodeFn             ; 转Unicode函数指针
  *encodeTextFn            ; 文本编码函数指针
EndStructure

;--- 字体定义对象 ---
Structure PbPDF_FontDef
  baseFont.s               ; 基础字体名
  type.i                   ; 字体定义类型(#PbPDF_FONTDEF_xxx)
  ascent.w                 ; 上升高度
  descent.w                ; 下降深度
  flags.i                  ; 字体标志
  fontBBox.PbPDF_Box       ; 字体边界框
  italicAngle.w            ; 斜体角度
  stemV.w                  ; 垂直主干宽度
  avgWidth.w               ; 平均宽度
  maxWidth.w               ; 最大宽度
  missingWidth.w           ; 缺失字符宽度
  xHeight.w                ; x高度
  capHeight.w              ; 大写高度
  *descriptorObj.PbPDF_Object; FontDescriptor字典对象
  *dataStream.PbPDF_Stream ; 字体数据流
  valid.i                  ; 有效标志
  *attr                    ; 类型特定属性(TTF/Type1/CID)
EndStructure

;--- 字体对象 ---
Structure PbPDF_Font
  fontType.i               ; 字体类型(#PbPDF_FONT_xxx)
  *fontDef.PbPDF_FontDef   ; 字体定义
  *encoder.PbPDF_Encoder   ; 编码器
  *widths.Long             ; 字符宽度缓存(256项,单字节编码)
  *used                    ; 已使用字符标记(256项)
  *fontObj.PbPDF_Object    ; PDF字体字典对象
  *descendantFont          ; 后代字体(Type0用)
  *mapStream.PbPDF_Object  ; 映射流
  *cmapStream.PbPDF_Object ; CMap流
  localName.s              ; 页面内本地名称(如"F1")
EndStructure

;--- 加密对象 ---
Structure PbPDF_Encrypt
  mode.i                   ; 加密模式(#PbPDF_ENCRYPT_xxx)
  keyLen.i                 ; 密钥长度(位)
  ownerPasswd.a[32]        ; 所有者密码(填充后)
  userPasswd.a[32]         ; 用户密码(填充后)
  ownerKey.a[32]           ; 所有者密钥
  userKey.a[32]            ; 用户密钥
  permission.i             ; 权限标志
  encryptID.a[16]          ; 加密ID(文档ID的第一个元素)
  encryptionKey.a[21]      ; 加密密钥(最大21字节)
  md5Key.a[16]             ; MD5加密密钥
  revision.i               ; 加密修订版本(R2/R3/R4)
  keyLength.i              ; 密钥长度(字节)
  ; ARC4上下文
  arc4S.a[256]             ; ARC4状态数组S
  arc4I.a                  ; ARC4索引i
  arc4J.a                  ; ARC4索引j
EndStructure

;--- 全局加密上下文（保存时用于字符串和二进制对象加密） ---
Global _PbPDF_CurrentEncrypt.PbPDF_Encrypt
Global _PbPDF_CurrentObjId.i
Global _PbPDF_CurrentGenNo.i

;--- 大纲/书签对象 ---
Structure PbPDF_Outline
  *dictObj.PbPDF_Object    ; 大纲字典对象
  title.s                  ; 大纲标题
  *parent.PbPDF_Outline    ; 父大纲
  *first.PbPDF_Outline     ; 第一个子大纲
  *last.PbPDF_Outline      ; 最后一个子大纲
  *prev.PbPDF_Outline      ; 前一个兄弟
  *next.PbPDF_Outline      ; 后一个兄弟
  count.i                  ; 子项数量
  opened.i                 ; 是否展开
  *dest                    ; 跳转目标
EndStructure

;--- 注释对象 ---
Structure PbPDF_Annotation
  *dictObj.PbPDF_Object    ; 注释字典对象
  annotType.i              ; 注释类型(#PbPDF_ANNOT_xxx)
  rect.PbPDF_Rect          ; 注释矩形区域
  title.s                  ; 注释标题
  contents.s               ; 注释内容
  *dest                    ; 链接目标
  uri.s                    ; URI链接
  borderStyle.PbPDF_BorderStyle; 边框样式
  color.PbPDF_RGBColor     ; 颜色
  opacity.f                ; 透明度
  *popup.PbPDF_Annotation  ; 弹出注释
  subject.s                ; 主题
  creationDate.s           ; 创建日期
  intent.s                 ; 意图
EndStructure

;--- 水印对象 ---
Structure PbPDF_Watermark
  wmType.i                 ; 水印类型(#PbPDF_WM_xxx)
  text.s                   ; 水印文本
  *imageObj                ; 水印图片对象
  onTop.i                  ; 是否在内容上方
  rotation.f               ; 旋转角度
  opacity.f                ; 透明度
  scale.f                  ; 缩放比例
  scaleAbs.i               ; 缩放是否绝对
  posMode.i                ; 位置模式
  offsetX.f                ; X偏移
  offsetY.f                ; Y偏移
  fontName.s               ; 字体名
  fontSize.f               ; 字体大小
  fillColor.PbPDF_RGBColor ; 填充颜色
  strokeColor.PbPDF_RGBColor; 描边颜色
  renderMode.i             ; 渲染模式
  margins.PbPDF_Margins    ; 边距
  borderWidth.f            ; 边框宽度
  borderColor.PbPDF_RGBColor; 边框颜色
  roundCorners.f           ; 圆角半径
  update.i                 ; 是否更新已有水印
  diagonal.i               ; 对角线方向(0=无,1=左下到右上,2=左上到右下)
EndStructure

;--- 图片对象 ---
Structure PbPDF_Image
  *imageObj.PbPDF_Object   ; PDF图像字典对象(XObject)
  imageType.i              ; 图片类型(#PbPDF_IMAGE_JPEG或#PbPDF_IMAGE_PNG)
  width.i                  ; 图片宽度(像素)
  height.i                 ; 图片高度(像素)
  colorSpace.i             ; 颜色空间(#PbPDF_CS_xxx)
  bitsPerComponent.i       ; 每个分量的位数(通常为8)
  *smaskObj.PbPDF_Object   ; 软遮罩对象(Alpha通道,仅PNG带透明度)
  localName.s              ; 页面内本地名称(如"Img1")
EndStructure

;--- PDF文档对象 ---
Structure PbPDF_Doc
  pdfVersion.i             ; PDF版本(#PbPDF_PDF_VER_xxx)
  *catalogObj.PbPDF_Object ; 文档目录字典对象
  *xref.PbPDF_XRef         ; 交叉引用表
  *rootPagesObj.PbPDF_Object; 根页面节点对象
  *curPageObj.PbPDF_Object ; 当前页面对象
  *infoObj.PbPDF_Object    ; 文档信息字典对象
  *outlinesRoot.PbPDF_Outline; 大纲根节点
  *fontMgr.PbPDF_List      ; 字体管理列表(PbPDF_Font指针)
  *fontDefMgr.PbPDF_List   ; 字体定义管理列表(PbPDF_FontDef指针)
  *encoderMgr.PbPDF_List   ; 编码器管理列表(PbPDF_Encoder指针)
  *curEncoder.PbPDF_Encoder; 当前编码器
  *defEncoder.PbPDF_Encoder; 默认编码器
  *encryptDictObj.PbPDF_Object; 加密字典对象
  *encrypt.PbPDF_Encrypt   ; 加密对象
  compressionMode.i        ; 压缩模式
  encryptOn.i              ; 加密开关
  pageCount.i              ; 页面总数
  *outStream.PbPDF_Stream  ; 输出流
  error.PbPDF_Error        ; 错误对象
  ttfontTagCounter.i       ; TTF字体标签计数器
  *imageMgr.PbPDF_List     ; 图片管理列表(PbPDF_Image指针)
  imageTagCounter.i        ; 图片标签计数器
  *pageList.PbPDF_List     ; 页面列表(PbPDF_Object指针)
  *trailerObj.PbPDF_Object ; Trailer字典对象
  ; 读取上下文(修改已有PDF时使用)
  *readBuf                 ; 读取缓冲区
  readBufSize.i            ; 读取缓冲区大小
  readPos.i                ; 读取位置
  validated.i              ; 是否已验证
  optimized.i              ; 是否已优化
EndStructure

;--- 预定义页面尺寸表 ---
DataSection
  PbPDF_PageSizes:
  ; Letter
  Data.f 612.0, 792.0
  ; Legal
  Data.f 612.0, 1008.0
  ; A3
  Data.f 841.89, 1190.551
  ; A4
  Data.f 595.276, 841.89
  ; A5
  Data.f 419.528, 595.276
  ; B4
  Data.f 708.661, 1000.63
  ; B5
  Data.f 498.898, 708.661
  ; Executive
  Data.f 521.86, 756.0
  ; US4x6
  Data.f 288.0, 432.0
  ; US4x8
  Data.f 288.0, 576.0
  ; US5x7
  Data.f 360.0, 504.0
  ; Comm10
  Data.f 297.0, 684.0
EndDataSection

;=============================================================================
; 第3部分：基础算法 (MD5/RC4/AES/SHA256/Flate/CRC32/Hex/UTF8)
;=============================================================================

;--- CRC32查表和计算 ---
DataSection
  PbPDF_CRC32Table:
  Data.l $00000000, $77073096, $EE0E612C, $990951BA
  Data.l $076DC419, $706AF48F, $E963A535, $9E6495A3
  Data.l $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988
  Data.l $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91
  Data.l $1DB71064, $6AB020F2, $F3B97148, $84BE41DE
  Data.l $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7
  Data.l $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC
  Data.l $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5
  Data.l $3B6E20C8, $4C69105E, $D56041E4, $A2677172
  Data.l $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B
  Data.l $35B5A8FA, $42B2986C, $DBBBBBD6, $ACBCCB40
  Data.l $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59
  Data.l $26D930AC, $51DE003A, $C8D75180, $BFD06116
  Data.l $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F
  Data.l $2802B89E, $5F058808, $C60CD9B2, $B10BE924
  Data.l $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D
  Data.l $76DC4190, $01DB7106, $98D220BC, $EFD5102A
  Data.l $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433
  Data.l $7807C9A2, $0F00F934, $9609A88E, $E10E9818
  Data.l $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01
  Data.l $6B6B51F4, $1C6C6162, $856530D8, $F262004E
  Data.l $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457
  Data.l $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C
  Data.l $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65
  Data.l $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2
  Data.l $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB
  Data.l $4369E96A, $346ED9FC, $AD678846, $DA60B8D0
  Data.l $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9
  Data.l $5005713C, $270241AA, $BE0B1010, $C90C2086
  Data.l $5768B525, $206F85B3, $B966D409, $CE61E49F
  Data.l $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4
  Data.l $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD
  Data.l $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A
  Data.l $EAD54739, $9DD277AF, $04DB2615, $73DC1683
  Data.l $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8
  Data.l $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1
  Data.l $F00F9344, $8708A3D2, $1E01F268, $6906C2FE
  Data.l $F762575D, $806567CB, $196C3671, $6E6B06E7
  Data.l $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC
  Data.l $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5
  Data.l $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252
  Data.l $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B
  Data.l $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A63
  Data.l $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79
  Data.l $CB61B38C, $BC66831A, $256FD2A0, $5268E236
  Data.l $CC0C7795, $BB0B4703, $220216B9, $5505262F
  Data.l $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04
  Data.l $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D
  Data.l $9B64C2B0, $EC63F226, $756AA39C, $026D930A
  Data.l $9C0906A9, $EB0E363F, $72076785, $05005713
  Data.l $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38
  Data.l $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21
  Data.l $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E
  Data.l $81BE16CD, $F6B9265B, $6FB077E1, $18B74777
  Data.l $88085AE6, $FF0F6A70, $66063BCA, $11010B5C
  Data.l $8F659EFF, $F862AE69, $616BFFD3, $166CCF45
  Data.l $A00AE278, $D70DD2EE, $4E048354, $3903B3C2
  Data.l $A7672661, $D06016F7, $4969474D, $3E6E77DB
  Data.l $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0
  Data.l $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9
  Data.l $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6
  Data.l $BAD03605, $CDD70693, $54DE5729, $23D967BF
  Data.l $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94
  Data.l $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D
EndDataSection

;--- CRC32计算 ---
Procedure.l PbPDF_CRC32(*buf, size.i, crc.l = $FFFFFFFF)
  Protected i.i
  Protected *ptr.Byte = *buf
  Protected result.l = crc
  Protected *table.Long = ?PbPDF_CRC32Table
  For i = 0 To size - 1
    result = (result >> 8) ! PeekL(*table + ((result ! *ptr\b) & $FF) * 4)
    *ptr + 1
  Next
  ProcedureReturn result ! $FFFFFFFF
EndProcedure

;--- MD5十六进制字符串转二进制缓冲区 ---
; PureBasic内置Fingerprint()返回32字符十六进制字符串，需要转换为16字节原始数据
Procedure PbPDF_MD5HexToBin(hex$, *dst)
  Protected i.i, hi.a, lo.a, val.a
  For i = 0 To 15
    hi = Asc(Mid(hex$, i * 2 + 1, 1))
    lo = Asc(Mid(hex$, i * 2 + 2, 1))
    If hi >= 'A' And hi <= 'F'
      hi = hi - 'A' + 10
    ElseIf hi >= 'a' And hi <= 'f'
      hi = hi - 'a' + 10
    ElseIf hi >= '0' And hi <= '9'
      hi = hi - '0'
    EndIf
    If lo >= 'A' And lo <= 'F'
      lo = lo - 'A' + 10
    ElseIf lo >= 'a' And lo <= 'f'
      lo = lo - 'a' + 10
    ElseIf lo >= '0' And lo <= '9'
      lo = lo - '0'
    EndIf
    val = (hi << 4) | lo
    PokeA(*dst + i, val)
  Next
EndProcedure

;--- MD5上下文(使用PureBasic内置增量指纹API) ---
Structure PbPDF_MD5Ctx
  fpNum.i             ; 指纹计算编号
EndStructure

;--- MD5初始化 ---
Procedure PbPDF_MD5Init(*ctx.PbPDF_MD5Ctx)
  *ctx\fpNum = 1
  StartFingerprint(*ctx\fpNum, #PB_Cipher_MD5)
EndProcedure

;--- MD5更新 ---
Procedure PbPDF_MD5Update(*ctx.PbPDF_MD5Ctx, *buf.Byte, len.i)
  AddFingerprintBuffer(*ctx\fpNum, *buf, len)
EndProcedure

;--- MD5最终化 ---
Procedure PbPDF_MD5Final(*digest, *ctx.PbPDF_MD5Ctx)
  Protected hex$ = FinishFingerprint(*ctx\fpNum)
  PbPDF_MD5HexToBin(hex$, *digest)
EndProcedure

;--- MD5便捷函数：计算数据的MD5哈希 ---
Procedure PbPDF_MD5(*buf, len.i, *digest)
  Protected hex$ = Fingerprint(*buf, len, #PB_Cipher_MD5)
  PbPDF_MD5HexToBin(hex$, *digest)
EndProcedure

;--- RC4初始化 ---
Procedure PbPDF_RC4Init(*enc.PbPDF_Encrypt, *key, keyLen.i)
  Protected i.i, j.i, t.a
  For i = 0 To 255
    *enc\arc4S[i] = i
  Next
  j = 0
  For i = 0 To 255
    j = (j + *enc\arc4S[i] + PeekA(*key + (i % keyLen))) & $FF
    t = *enc\arc4S[i]
    *enc\arc4S[i] = *enc\arc4S[j]
    *enc\arc4S[j] = t
  Next
  *enc\arc4I = 0
  *enc\arc4J = 0
EndProcedure

;--- 计算对象加密密钥 ---
; PDF规范：对象密钥 = MD5(加密密钥 + 对象号(3字节LE) + 代号(2字节LE))的前n+5字节
; n为加密密钥长度，最大16字节
Procedure PbPDF_ComputeObjKey(*encrypt.PbPDF_Encrypt, objId.i, genNo.i, *objKey, *objKeyLen.INTEGER)
  Protected keyLen.i = *encrypt\keyLength
  Protected bufLen.i = keyLen + 5
  Protected *buf = AllocateMemory(bufLen + 5)
  If Not *buf
    *objKeyLen\i = 0
    ProcedureReturn
  EndIf
  Protected offset.i = 0
  CopyMemory(@*encrypt\encryptionKey[0], *buf + offset, keyLen)
  offset + keyLen
  ; 对象号3字节(Little-Endian)
  PokeA(*buf + offset, objId & $FF) : offset + 1
  PokeA(*buf + offset, (objId >> 8) & $FF) : offset + 1
  PokeA(*buf + offset, (objId >> 16) & $FF) : offset + 1
  ; 代号2字节(Little-Endian)
  PokeA(*buf + offset, genNo & $FF) : offset + 1
  PokeA(*buf + offset, (genNo >> 8) & $FF) : offset + 1
  ; MD5哈希
  Protected *md5Result = AllocateMemory(16)
  If *md5Result
    PbPDF_MD5(*buf, offset, *md5Result)
    ; 取前min(n+5, 16)字节作为对象密钥
    Protected finalLen.i = keyLen + 5
    If finalLen > 16 : finalLen = 16 : EndIf
    CopyMemory(*md5Result, *objKey, finalLen)
    *objKeyLen\i = finalLen
    FreeMemory(*md5Result)
  Else
    *objKeyLen\i = 0
  EndIf
  FreeMemory(*buf)
EndProcedure

;--- RC4加密/解密 ---
Procedure PbPDF_RC4Crypt(*enc.PbPDF_Encrypt, *src, *dst, len.i)
  Protected i.i, t.a
  Protected si.a = *enc\arc4I
  Protected sj.a = *enc\arc4J
  For i = 0 To len - 1
    si = (si + 1) & $FF
    sj = (sj + *enc\arc4S[si]) & $FF
    t = *enc\arc4S[si]
    *enc\arc4S[si] = *enc\arc4S[sj]
    *enc\arc4S[sj] = t
    t = *enc\arc4S[(*enc\arc4S[si] + *enc\arc4S[sj]) & $FF]
    PokeA(*dst + i, PeekA(*src + i) ! t)
  Next
  *enc\arc4I = si
  *enc\arc4J = sj
EndProcedure

;--- ASCII十六进制编码 ---
Procedure PbPDF_ASCIIHexEncode(*src, srcLen.i, *dst)
  Protected i.i, pos.i = 0
  Protected hexChars.s = "0123456789ABCDEF"
  Protected *srcPtr.Byte = *src
  Protected *dstPtr.Byte = *dst
  For i = 0 To srcLen - 1
    *dstPtr\b = Asc(Mid(hexChars, (*srcPtr\b >> 4) + 1, 1))
    *dstPtr + 1
    *dstPtr\b = Asc(Mid(hexChars, (*srcPtr\b & $0F) + 1, 1))
    *dstPtr + 1
    *srcPtr + 1
  Next
  *dstPtr\b = Asc(">")
  *dstPtr + 1
  ProcedureReturn *dstPtr - *dst
EndProcedure

;--- ASCII十六进制解码 ---
Procedure PbPDF_ASCIIHexDecode(*src, srcLen.i, *dst)
  Protected i.i, pos.i = 0, hi.a, lo.a
  Protected Dim hexVal.a(255)
  Protected *srcPtr.Byte = *src
  Protected *dstPtr.Byte = *dst
  FillMemory(@hexVal(0), 256, 0, #PB_Byte)
  For i = 0 To 9
    hexVal('0' + i) = i
  Next
  For i = 0 To 5
    hexVal('A' + i) = 10 + i
    hexVal('a' + i) = 10 + i
  Next
  i = 0
  While i < srcLen
    If *srcPtr\b = Asc(">")
      Break
    EndIf
    hi = hexVal(*srcPtr\b)
    *srcPtr + 1
    i + 1
    If i >= srcLen Or *srcPtr\b = Asc(">")
      *dstPtr\b = hi << 4
      *dstPtr + 1
      Break
    EndIf
    lo = hexVal(*srcPtr\b)
    *srcPtr + 1
    i + 1
    *dstPtr\b = (hi << 4) | lo
    *dstPtr + 1
  Wend
  ProcedureReturn *dstPtr - *dst
EndProcedure

;--- UTF-8字符解码(返回Unicode码点，并推进字节数) ---
Procedure PbPDF_UTF8Decode(*src, srcLen.i, *byteCount.Integer)
  Protected ch.l = 0
  Protected *p.Byte = *src
  Protected b0.a = *p\b
  If b0 < $80
    ch = b0
    *byteCount\i = 1
  ElseIf (b0 & $E0) = $C0
    If srcLen >= 2
      ch = ((b0 & $1F) << 6) | ((PeekA(*src + 1)) & $3F)
    EndIf
    *byteCount\i = 2
  ElseIf (b0 & $F0) = $E0
    If srcLen >= 3
      ch = ((b0 & $0F) << 12) | ((PeekA(*src + 1) & $3F) << 6) | (PeekA(*src + 2) & $3F)
    EndIf
    *byteCount\i = 3
  ElseIf (b0 & $F8) = $F0
    If srcLen >= 4
      ch = ((b0 & $07) << 18) | ((PeekA(*src + 1) & $3F) << 12) | ((PeekA(*src + 2) & $3F) << 6) | (PeekA(*src + 3) & $3F)
    EndIf
    *byteCount\i = 4
  Else
    *byteCount\i = 1
  EndIf
  ProcedureReturn ch
EndProcedure

;--- UTF-8字符串转Unicode码点数组 ---
Procedure.i PbPDF_UTF8ToUnicode(*src, srcLen.i, *unicodeArr)
  Protected i.i = 0, pos.i = 0, byteCount.i
  While i < srcLen
    PokeL(*unicodeArr + pos * 4, PbPDF_UTF8Decode(*src + i, srcLen - i, @byteCount))
    i + byteCount
    pos + 1
  Wend
  ProcedureReturn pos
EndProcedure

;--- Unicode码点转UTF-16BE字节序列 ---
Procedure.i PbPDF_UnicodeToUTF16BE(unicode.l, *dst)
  If unicode < $10000
    PokeA(*dst, (unicode >> 8) & $FF)
    PokeA(*dst + 1, unicode & $FF)
    ProcedureReturn 2
  Else
    Protected w1.l = $D800 + ((unicode - $10000) >> 10)
    Protected w2.l = $DC00 + ((unicode - $10000) & $3FF)
    PokeA(*dst, (w1 >> 8) & $FF)
    PokeA(*dst + 1, w1 & $FF)
    PokeA(*dst + 2, (w2 >> 8) & $FF)
    PokeA(*dst + 3, w2 & $FF)
    ProcedureReturn 4
  EndIf
EndProcedure

;--- 生成随机字节 ---
Procedure PbPDF_GenRandomBytes(*buf, len.i)
  Protected i.i
  Protected *ptr.Byte = *buf
  For i = 0 To len - 1
    *ptr\b = Random(255)
    *ptr + 1
  Next
EndProcedure

;--- PDF字符串转义 ---
Procedure.s PbPDF_EscapeString(text$)
  Protected result$
  result$ = ReplaceString(text$, "\", "\\")
  result$ = ReplaceString(result$, "(", "\(")
  result$ = ReplaceString(result$, ")", "\)")
  ProcedureReturn result$
EndProcedure

;--- 十六进制字符串转字节 ---
Procedure.i PbPDF_HexStrToBytes(hex$, *dst)
  Protected i.i, pos.i = 0, len.i = Len(hex$)
  Protected hi.a, lo.a
  Protected *dstPtr.Byte = *dst
  If len & 1
    hex$ + "0"
    len + 1
  EndIf
  For i = 1 To len Step 2
    hi = Val("$" + Mid(hex$, i, 1))
    lo = Val("$" + Mid(hex$, i + 1, 1))
    *dstPtr\b = (hi << 4) | lo
    *dstPtr + 1
  Next
  ProcedureReturn *dstPtr - *dst
EndProcedure

;--- 字节转十六进制字符串 ---
Procedure.s PbPDF_BytesToHexStr(*src, len.i)
  Protected result$ = ""
  Protected i.i
  For i = 0 To len - 1
    result$ + RSet(Hex(PeekA(*src + i)), 2, "0")
  Next
  ProcedureReturn result$
EndProcedure

;--- PDF日期格式化 ---
Procedure.s PbPDF_FormatPDFDate(*d.PbPDF_Date)
  Protected result$
  result$ = "D:" + RSet(Str(*d\year), 4, "0")
  result$ + RSet(Str(*d\month), 2, "0")
  result$ + RSet(Str(*d\day), 2, "0")
  result$ + RSet(Str(*d\hour), 2, "0")
  result$ + RSet(Str(*d\minute), 2, "0")
  result$ + RSet(Str(*d\second), 2, "0")
  If *d\ind = Asc("Z")
    result$ + "Z"
  ElseIf *d\ind = Asc("+") Or *d\ind = Asc("-")
    result$ + Chr(*d\ind)
    result$ + RSet(Str(*d\offHour), 2, "0") + "'" + RSet(Str(*d\offMinute), 2, "0") + "'"
  EndIf
  ProcedureReturn result$
EndProcedure

;--- 获取当前PDF日期 ---
Procedure PbPDF_GetCurrentDate(*d.PbPDF_Date)
  *d\year = Year(Date())
  *d\month = Month(Date())
  *d\day = Day(Date())
  *d\hour = Hour(Date())
  *d\minute = Minute(Date())
  *d\second = Second(Date())
  *d\ind = Asc("Z")
  *d\offHour = 0
  *d\offMinute = 0
EndProcedure

;=============================================================================
; 第4部分：内存管理和工具函数
;=============================================================================

;--- 创建动态列表 ---
Procedure.i PbPDF_ListNew(itemSize.i = 4, initialCapacity.i = 16)
  Protected *list.PbPDF_List = AllocateMemory(SizeOf(PbPDF_List))
  If *list
    *list\count = 0
    *list\itemSize = itemSize
    *list\capacity = initialCapacity
    If initialCapacity > 0
      *list\items = AllocateMemory(initialCapacity * itemSize)
    EndIf
  EndIf
  ProcedureReturn *list
EndProcedure

;--- 释放动态列表 ---
Procedure PbPDF_ListFree(*list.PbPDF_List)
  If *list
    If *list\items
      FreeMemory(*list\items)
    EndIf
    FreeMemory(*list)
  EndIf
EndProcedure

;--- 列表扩容 ---
Procedure PbPDF_ListGrow(*list.PbPDF_List, newCapacity.i)
  Protected *newItems
  If newCapacity <= *list\capacity
    ProcedureReturn
  EndIf
  *newItems = AllocateMemory(newCapacity * *list\itemSize)
  If *newItems
    If *list\items And *list\count > 0
      CopyMemory(*list\items, *newItems, *list\count * *list\itemSize)
    EndIf
    If *list\items
      FreeMemory(*list\items)
    EndIf
    *list\items = *newItems
    *list\capacity = newCapacity
  EndIf
EndProcedure

;--- 列表添加项目(通用) ---
Procedure.i PbPDF_ListAdd(*list.PbPDF_List, *item)
  If *list\count >= *list\capacity
    PbPDF_ListGrow(*list, *list\capacity * 2)
  EndIf
  If *list\items
    CopyMemory(*item, *list\items + *list\count * *list\itemSize, *list\itemSize)
    *list\count + 1
    ProcedureReturn *list\count - 1
  EndIf
  ProcedureReturn -1
EndProcedure

;--- 列表添加指针 ---
Procedure.i PbPDF_ListAddPointer(*list.PbPDF_List, ptr.i)
  ProcedureReturn PbPDF_ListAdd(*list, @ptr)
EndProcedure

;--- 列表获取指针 ---
Procedure.i PbPDF_ListGetPointer(*list.PbPDF_List, index.i)
  If index < 0 Or index >= *list\count
    ProcedureReturn 0
  EndIf
  Protected *ptr.Long = *list\items + index * *list\itemSize
  ProcedureReturn *ptr\l
EndProcedure

;--- 列表设置指针 ---
Procedure PbPDF_ListSetPointer(*list.PbPDF_List, index.i, ptr.i)
  If index >= 0 And index < *list\count
    Protected *ptr.Long = *list\items + index * *list\itemSize
    *ptr\l = ptr
  EndIf
EndProcedure

;--- 列表获取项目数 ---
Procedure.i PbPDF_ListCount(*list.PbPDF_List)
  If *list
    ProcedureReturn *list\count
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 列表删除指定索引项 ---
Procedure PbPDF_ListRemove(*list.PbPDF_List, index.i)
  If index < 0 Or index >= *list\count
    ProcedureReturn
  EndIf
  If index < *list\count - 1
    CopyMemory(*list\items + (index + 1) * *list\itemSize, *list\items + index * *list\itemSize, (*list\count - index - 1) * *list\itemSize)
  EndIf
  *list\count - 1
EndProcedure

;--- 列表清空 ---
Procedure PbPDF_ListClear(*list.PbPDF_List)
  *list\count = 0
EndProcedure

;--- 设置错误 ---
Procedure PbPDF_SetError(*err.PbPDF_Error, code.i, detail.i = 0, msg$ = "")
  *err\errorCode = code
  *err\errorDetail = detail
  *err\errorMsg = msg$
EndProcedure

;--- 检查错误 ---
Procedure.i PbPDF_HasError(*err.PbPDF_Error)
  ProcedureReturn Bool(*err\errorCode <> #PbPDF_OK)
EndProcedure

;--- 清除错误 ---
Procedure PbPDF_ClearError(*err.PbPDF_Error)
  *err\errorCode = #PbPDF_OK
  *err\errorDetail = 0
  *err\errorMsg = ""
EndProcedure

;=============================================================================
; 第5部分：流处理 (Stream)
;=============================================================================

;--- 创建文件写入流 ---
Procedure.i PbPDF_FileWriteStreamNew(fileName$)
  Protected *stream.PbPDF_Stream = AllocateMemory(SizeOf(PbPDF_Stream))
  If *stream
    *stream\streamType = 0  ; 文件流
    *stream\size = 0
    *stream\fileName = fileName$
    *stream\fileID = CreateFile(#PB_Any, fileName$)
    If *stream\fileID = 0
      FreeMemory(*stream)
      ProcedureReturn 0
    EndIf
  EndIf
  ProcedureReturn *stream
EndProcedure

;--- 创建文件读取流 ---
Procedure.i PbPDF_FileReadStreamNew(fileName$)
  Protected *stream.PbPDF_Stream = AllocateMemory(SizeOf(PbPDF_Stream))
  If *stream
    *stream\streamType = 0
    *stream\size = FileSize(fileName$)
    *stream\fileName = fileName$
    *stream\fileID = OpenFile(#PB_Any, fileName$)
    If *stream\fileID = 0
      FreeMemory(*stream)
      ProcedureReturn 0
    EndIf
  EndIf
  ProcedureReturn *stream
EndProcedure

;--- 创建内存流 ---
Procedure.i PbPDF_MemStreamNew()
  Protected *stream.PbPDF_Stream = AllocateMemory(SizeOf(PbPDF_Stream))
  If *stream
    *stream\streamType = 1  ; 内存流
    *stream\size = 0
    *stream\memAttr = AllocateMemory(SizeOf(PbPDF_MemStreamAttr))
    If *stream\memAttr
      *stream\memAttr\bufList = PbPDF_ListNew(#PB_Long, 8)
      *stream\memAttr\bufSize = 0
      *stream\memAttr\totalSize = 0
      *stream\memAttr\readPos = 0
    EndIf
  EndIf
  ProcedureReturn *stream
EndProcedure

;--- 释放流 ---
Procedure PbPDF_StreamFree(*stream.PbPDF_Stream)
  If *stream
    If *stream\streamType = 0 And *stream\fileID
      CloseFile(*stream\fileID)
    ElseIf *stream\streamType = 1 And *stream\memAttr
      If *stream\memAttr\bufList
        Protected i.i, count.i = PbPDF_ListCount(*stream\memAttr\bufList)
        For i = 0 To count - 1
          FreeMemory(PbPDF_ListGetPointer(*stream\memAttr\bufList, i))
        Next
        PbPDF_ListFree(*stream\memAttr\bufList)
      EndIf
      FreeMemory(*stream\memAttr)
    EndIf
    FreeMemory(*stream)
  EndIf
EndProcedure

;--- 流写入字节 ---
Procedure PbPDF_StreamWriteByte(*stream.PbPDF_Stream, b.a)
  If *stream\streamType = 0 And *stream\fileID
    WriteData(*stream\fileID, @b, 1)
    *stream\size + 1
  ElseIf *stream\streamType = 1
    If *stream\memAttr\bufSize = 0 Or *stream\memAttr\bufSize >= #PbPDF_MEM_STREAM_BUF_SIZE
      Protected *newBuf = AllocateMemory(#PbPDF_MEM_STREAM_BUF_SIZE)
      If *newBuf
        PbPDF_ListAddPointer(*stream\memAttr\bufList, *newBuf)
        *stream\memAttr\bufSize = 0
      EndIf
    EndIf
    Protected count.i = PbPDF_ListCount(*stream\memAttr\bufList)
    If count > 0
      Protected *curBuf = PbPDF_ListGetPointer(*stream\memAttr\bufList, count - 1)
      If *curBuf
        PokeA(*curBuf + *stream\memAttr\bufSize, b)
        *stream\memAttr\bufSize + 1
      EndIf
    EndIf
    *stream\size + 1
  EndIf
EndProcedure

;--- 流写入数据 ---
Procedure PbPDF_StreamWriteData(*stream.PbPDF_Stream, *buf, len.i)
  If *stream\streamType = 0 And *stream\fileID
    WriteData(*stream\fileID, *buf, len)
    *stream\size + len
  ElseIf *stream\streamType = 1
    Protected i.i
    Protected *ptr.Byte = *buf
    For i = 0 To len - 1
      PbPDF_StreamWriteByte(*stream, *ptr\b)
      *ptr + 1
    Next
  EndIf
EndProcedure

;--- 流写入字符串 ---
Procedure PbPDF_StreamWriteStr(*stream.PbPDF_Stream, text$)
  If *stream\streamType = 0 And *stream\fileID
    WriteString(*stream\fileID, text$, #PB_UTF8)
    *stream\size + StringByteLength(text$, #PB_UTF8)
  ElseIf *stream\streamType = 1
    Protected *buf = AllocateMemory(StringByteLength(text$, #PB_UTF8) + 1)
    PokeS(*buf, text$, -1, #PB_UTF8)
    PbPDF_StreamWriteData(*stream, *buf, StringByteLength(text$, #PB_UTF8))
    FreeMemory(*buf)
  EndIf
EndProcedure

;--- 流写入格式化字符串 ---
Procedure PbPDF_StreamWriteFormat(*stream.PbPDF_Stream, format$, value1=0, value2=0, value3=0, value4=0, value5=0, value6=0, value7=0, value8=0, value9=0, value10=0)
  Protected text$ = StrF(value1)
  ; 简化版：直接写入格式化后的字符串
  ; 注意：PureBasic的FormatStr有限制，这里使用字符串拼接代替
  PbPDF_StreamWriteStr(*stream, format$)
EndProcedure

;--- 流写入换行 ---
Procedure PbPDF_StreamWriteEOL(*stream.PbPDF_Stream)
  PbPDF_StreamWriteByte(*stream, 10)  ; LF
EndProcedure

;--- 内存流获取数据(合并所有缓冲区) ---
Procedure.i PbPDF_MemStreamGetData(*stream.PbPDF_Stream, *outBuf)
  If *stream\streamType <> 1 Or Not *stream\memAttr
    ProcedureReturn 0
  EndIf
  Protected i.i, count.i = PbPDF_ListCount(*stream\memAttr\bufList)
  Protected totalWritten.i = 0
  Protected *dst = *outBuf
  For i = 0 To count - 1
    Protected *buf = PbPDF_ListGetPointer(*stream\memAttr\bufList, i)
    If *buf
      Protected writeLen.i = #PbPDF_MEM_STREAM_BUF_SIZE
      If i = count - 1
        writeLen = *stream\memAttr\bufSize
      EndIf
      CopyMemory(*buf, *dst + totalWritten, writeLen)
      totalWritten + writeLen
    EndIf
  Next
  ProcedureReturn totalWritten
EndProcedure

;--- 内存流保存到文件 ---
Procedure PbPDF_MemStreamSaveToFile(*stream.PbPDF_Stream, fileName$)
  If *stream\streamType <> 1 Or Not *stream\memAttr
    ProcedureReturn #PbPDF_ERR_INVALID_STREAM
  EndIf
  Protected fileID.i = CreateFile(#PB_Any, fileName$)
  If fileID = 0
    ProcedureReturn #PbPDF_ERR_FILE_OPEN
  EndIf
  Protected i.i, count.i = PbPDF_ListCount(*stream\memAttr\bufList)
  For i = 0 To count - 1
    Protected *buf = PbPDF_ListGetPointer(*stream\memAttr\bufList, i)
    If *buf
      Protected writeLen.i = #PbPDF_MEM_STREAM_BUF_SIZE
      If i = count - 1
        writeLen = *stream\memAttr\bufSize
      EndIf
      WriteData(fileID, *buf, writeLen)
    EndIf
  Next
  CloseFile(fileID)
  ProcedureReturn #PbPDF_OK
EndProcedure

;=============================================================================
; 第6部分：PDF对象模型
;=============================================================================

;--- 创建PDF对象 ---
Procedure.i PbPDF_ObjNew(objType.i, objClass.i = #PbPDF_OSUBCLASS_NONE)
  Protected *obj.PbPDF_Object = AllocateMemory(SizeOf(PbPDF_Object))
  If *obj
    InitializeStructure(*obj, PbPDF_Object)
    *obj\objType = objType
    *obj\objClass = objClass
    *obj\objId = 0
    *obj\genNo = 0
    *obj\flags = 0
    *obj\boolValue = 0
    *obj\numberValue = 0
    *obj\realValue = 0.0
    *obj\nameValue = ""
    *obj\stringValue = ""
    *obj\arrayData = 0
    *obj\dictKeys = 0
    *obj\dictValues = 0
    *obj\stream = 0
    *obj\filter = 0
    *obj\attr = 0
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 创建Null对象 ---
Procedure.i PbPDF_NullNew()
  ProcedureReturn PbPDF_ObjNew(#PbPDF_OBJ_NULL)
EndProcedure

;--- 创建Boolean对象 ---
Procedure.i PbPDF_BooleanNew(value.i)
  Protected *obj.PbPDF_Object = PbPDF_ObjNew(#PbPDF_OBJ_BOOLEAN)
  If *obj
    *obj\boolValue = value
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 创建Number对象 ---
Procedure.i PbPDF_NumberNew(value.i)
  Protected *obj.PbPDF_Object = PbPDF_ObjNew(#PbPDF_OBJ_NUMBER)
  If *obj
    *obj\numberValue = value
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 创建Real对象 ---
Procedure.i PbPDF_RealNew(value.f)
  Protected *obj.PbPDF_Object = PbPDF_ObjNew(#PbPDF_OBJ_REAL)
  If *obj
    *obj\realValue = value
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 创建Name对象 ---
Procedure.i PbPDF_NameNew(name$)
  Protected *obj.PbPDF_Object = PbPDF_ObjNew(#PbPDF_OBJ_NAME)
  If *obj
    *obj\nameValue = name$
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 创建String对象 ---
Procedure.i PbPDF_StringNew(value$)
  Protected *obj.PbPDF_Object = PbPDF_ObjNew(#PbPDF_OBJ_STRING)
  If *obj
    *obj\stringValue = value$
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 创建Binary对象 ---
Procedure.i PbPDF_BinaryNew(*data, len.i)
  Protected *obj.PbPDF_Object = PbPDF_ObjNew(#PbPDF_OBJ_BINARY)
  If *obj
    ; 将二进制数据存储为十六进制字符串
    ; 注意：必须使用PeekA()读取无符号字节，不能用*srcPtr\b(有符号)
    ; 因为Hex(-1)会产生"FFFFFFFF"而不是"FF"，导致hex字符串损坏
    Protected hex$ = ""
    Protected i.i
    For i = 0 To len - 1
      hex$ + RSet(Hex(PeekA(*data + i)), 2, "0")
    Next
    *obj\stringValue = hex$
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 创建Array对象 ---
Procedure.i PbPDF_ArrayNew()
  Protected *obj.PbPDF_Object = PbPDF_ObjNew(#PbPDF_OBJ_ARRAY)
  If *obj
    *obj\arrayData = PbPDF_ListNew(#PB_Long, 8)
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 创建Dict对象 ---
Procedure.i PbPDF_DictNew(objClass.i = #PbPDF_OSUBCLASS_NONE)
  Protected *obj.PbPDF_Object = PbPDF_ObjNew(#PbPDF_OBJ_DICT, objClass)
  If *obj
    *obj\dictKeys = PbPDF_ListNew(#PB_Long, 8)
    *obj\dictValues = PbPDF_ListNew(#PB_Long, 8)
  EndIf
  ProcedureReturn *obj
EndProcedure

;--- 释放PDF对象 ---
Procedure PbPDF_ObjFree(*obj.PbPDF_Object)
  If Not *obj
    ProcedureReturn
  EndIf
  ; 释放数组数据
  If *obj\arrayData
    Protected i.i, count.i
    count = PbPDF_ListCount(*obj\arrayData)
    For i = 0 To count - 1
      Protected *item.PbPDF_Object = PbPDF_ListGetPointer(*obj\arrayData, i)
      If *item
        If Not (*item\flags & #PbPDF_OTYPE_DIRECT)
          PbPDF_ObjFree(*item)
        EndIf
      EndIf
    Next
    PbPDF_ListFree(*obj\arrayData)
  EndIf
  ; 释放字典数据
  If *obj\dictKeys
    count = PbPDF_ListCount(*obj\dictKeys)
    For i = 0 To count - 1
      Protected *keyPtr = PbPDF_ListGetPointer(*obj\dictKeys, i)
      If *keyPtr
        FreeMemory(*keyPtr)
      EndIf
    Next
    PbPDF_ListFree(*obj\dictKeys)
  EndIf
  If *obj\dictValues
    count = PbPDF_ListCount(*obj\dictValues)
    For i = 0 To count - 1
      Protected *valObj.PbPDF_Object = PbPDF_ListGetPointer(*obj\dictValues, i)
      If *valObj And Not (*valObj\flags & #PbPDF_OTYPE_DIRECT)
        PbPDF_ObjFree(*valObj)
      EndIf
    Next
    PbPDF_ListFree(*obj\dictValues)
  EndIf
  ; 释放流
  If *obj\stream
    PbPDF_StreamFree(*obj\stream)
  EndIf
  ; 释放类型特定属性
  If *obj\attr
    FreeMemory(*obj\attr)
  EndIf
  FreeMemory(*obj)
EndProcedure

;--- 数组添加元素 ---
Procedure PbPDF_ArrayAdd(*arrayObj.PbPDF_Object, *item.PbPDF_Object)
  If Not *arrayObj Or *arrayObj\objType <> #PbPDF_OBJ_ARRAY
    ProcedureReturn
  EndIf
  If *item
    *item\flags | #PbPDF_OTYPE_DIRECT
  EndIf
  PbPDF_ListAddPointer(*arrayObj\arrayData, *item)
EndProcedure

;--- 数组添加名称元素 ---
Procedure PbPDF_ArrayAddName(*arrayObj.PbPDF_Object, name$)
  Protected *nameObj.PbPDF_Object = PbPDF_NameNew(name$)
  If *nameObj
    PbPDF_ArrayAdd(*arrayObj, *nameObj)
  EndIf
EndProcedure

;--- 数组添加整数元素 ---
Procedure PbPDF_ArrayAddNumber(*arrayObj.PbPDF_Object, value.i)
  Protected *numObj.PbPDF_Object = PbPDF_NumberNew(value)
  If *numObj
    PbPDF_ArrayAdd(*arrayObj, *numObj)
  EndIf
EndProcedure

;--- 数组添加实数元素 ---
Procedure PbPDF_ArrayAddReal(*arrayObj.PbPDF_Object, value.f)
  Protected *realObj.PbPDF_Object = PbPDF_RealNew(value)
  If *realObj
    PbPDF_ArrayAdd(*arrayObj, *realObj)
  EndIf
EndProcedure

;--- 数组获取元素 ---
Procedure.i PbPDF_ArrayGetItem(*arrayObj.PbPDF_Object, index.i)
  If Not *arrayObj Or *arrayObj\objType <> #PbPDF_OBJ_ARRAY
    ProcedureReturn 0
  EndIf
  ProcedureReturn PbPDF_ListGetPointer(*arrayObj\arrayData, index)
EndProcedure

;--- 数组获取元素数 ---
Procedure.i PbPDF_ArrayGetCount(*arrayObj.PbPDF_Object)
  If Not *arrayObj Or *arrayObj\objType <> #PbPDF_OBJ_ARRAY
    ProcedureReturn 0
  EndIf
  ProcedureReturn PbPDF_ListCount(*arrayObj\arrayData)
EndProcedure

;--- 字典添加键值对 ---
Procedure PbPDF_DictAdd(*dictObj.PbPDF_Object, key$, *value.PbPDF_Object)
  If Not *dictObj Or *dictObj\objType <> #PbPDF_OBJ_DICT
    ProcedureReturn
  EndIf
  ; 检查是否已存在同名键
  Protected i.i, count.i = PbPDF_ListCount(*dictObj\dictKeys)
  For i = 0 To count - 1
    Protected *keyPtr = PbPDF_ListGetPointer(*dictObj\dictKeys, i)
    If *keyPtr And PeekS(*keyPtr, -1, #PB_UTF8) = key$
      ; 替换已有值
      Protected *oldVal.PbPDF_Object = PbPDF_ListGetPointer(*dictObj\dictValues, i)
      If *oldVal And Not (*oldVal\flags & #PbPDF_OTYPE_DIRECT)
        PbPDF_ObjFree(*oldVal)
      EndIf
      PbPDF_ListSetPointer(*dictObj\dictValues, i, *value)
      If *value
        *value\flags | #PbPDF_OTYPE_DIRECT
      EndIf
      ProcedureReturn
    EndIf
  Next
  ; 添加新键值对(分配内存存储键名字符串)
  Protected keyLen.i = StringByteLength(key$, #PB_UTF8) + 1
  Protected *newKey = AllocateMemory(keyLen)
  If *newKey
    PokeS(*newKey, key$, -1, #PB_UTF8)
    PbPDF_ListAddPointer(*dictObj\dictKeys, *newKey)
  EndIf
  PbPDF_ListAddPointer(*dictObj\dictValues, *value)
  If *value
    *value\flags | #PbPDF_OTYPE_DIRECT
  EndIf
EndProcedure

;--- 字典获取值 ---
Procedure.i PbPDF_DictGetValue(*dictObj.PbPDF_Object, key$)
  If Not *dictObj Or *dictObj\objType <> #PbPDF_OBJ_DICT
    ProcedureReturn 0
  EndIf
  Protected i.i, count.i = PbPDF_ListCount(*dictObj\dictKeys)
  For i = 0 To count - 1
    Protected *keyPtr = PbPDF_ListGetPointer(*dictObj\dictKeys, i)
    If *keyPtr And PeekS(*keyPtr, -1, #PB_UTF8) = key$
      ProcedureReturn PbPDF_ListGetPointer(*dictObj\dictValues, i)
    EndIf
  Next
  ProcedureReturn 0
EndProcedure

;--- 字典删除键 ---
Procedure PbPDF_DictRemove(*dictObj.PbPDF_Object, key$)
  If Not *dictObj Or *dictObj\objType <> #PbPDF_OBJ_DICT
    ProcedureReturn
  EndIf
  Protected i.i, count.i = PbPDF_ListCount(*dictObj\dictKeys)
  For i = 0 To count - 1
    Protected *keyPtr = PbPDF_ListGetPointer(*dictObj\dictKeys, i)
    If *keyPtr And PeekS(*keyPtr, -1, #PB_UTF8) = key$
      FreeMemory(*keyPtr)
      PbPDF_ListRemove(*dictObj\dictKeys, i)
      PbPDF_ListRemove(*dictObj\dictValues, i)
      ProcedureReturn
    EndIf
  Next
EndProcedure

;--- 字典获取元素数 ---
Procedure.i PbPDF_DictGetCount(*dictObj.PbPDF_Object)
  If Not *dictObj Or *dictObj\objType <> #PbPDF_OBJ_DICT
    ProcedureReturn 0
  EndIf
  ProcedureReturn PbPDF_ListCount(*dictObj\dictKeys)
EndProcedure

;--- 字典添加Name类型键值 ---
Procedure PbPDF_DictAddName(*dictObj.PbPDF_Object, key$, name$)
  PbPDF_DictAdd(*dictObj, key$, PbPDF_NameNew(name$))
EndProcedure

;--- 字典添加Number类型键值 ---
Procedure PbPDF_DictAddNumber(*dictObj.PbPDF_Object, key$, value.i)
  PbPDF_DictAdd(*dictObj, key$, PbPDF_NumberNew(value))
EndProcedure

;--- 字典添加Real类型键值 ---
Procedure PbPDF_DictAddReal(*dictObj.PbPDF_Object, key$, value.f)
  PbPDF_DictAdd(*dictObj, key$, PbPDF_RealNew(value))
EndProcedure

;--- 字典添加String类型键值 ---
Procedure PbPDF_DictAddString(*dictObj.PbPDF_Object, key$, value$)
  PbPDF_DictAdd(*dictObj, key$, PbPDF_StringNew(value$))
EndProcedure

;--- 字典添加Boolean类型键值 ---
Procedure PbPDF_DictAddBoolean(*dictObj.PbPDF_Object, key$, value.i)
  PbPDF_DictAdd(*dictObj, key$, PbPDF_BooleanNew(value))
EndProcedure

;=============================================================================
; 第7部分：交叉引用表和对象序列化
;=============================================================================

;--- 创建交叉引用表 ---
Procedure.i PbPDF_XRefNew(startOffset.i = 0)
  Protected *xref.PbPDF_XRef = AllocateMemory(SizeOf(PbPDF_XRef))
  If *xref
    *xref\entries = PbPDF_ListNew(SizeOf(PbPDF_XRefEntry), #PbPDF_DEFAULT_XREF_ENTRIES)
    *xref\startOffset = startOffset
    *xref\addr = 0
    *xref\prev = 0
    *xref\trailer = 0
    ; 添加第0个条目(空闲条目)
    If startOffset = 0
      Protected entry.PbPDF_XRefEntry
      entry\entryType = #PbPDF_XREF_FREE_ENTRY
      entry\byteOffset = 0
      entry\genNo = #PbPDF_MAX_GENERATION_NUM
      entry\obj = 0
      PbPDF_ListAdd(*xref\entries, @entry)
    EndIf
  EndIf
  ProcedureReturn *xref
EndProcedure

;--- 释放交叉引用表 ---
Procedure PbPDF_XRefFree(*xref.PbPDF_XRef)
  If Not *xref
    ProcedureReturn
  EndIf
  If *xref\entries
    PbPDF_ListFree(*xref\entries)
  EndIf
  If *xref\prev
    PbPDF_XRefFree(*xref\prev)
  EndIf
  FreeMemory(*xref)
EndProcedure

;--- 交叉引用表添加对象 ---
Procedure.i PbPDF_XRefAdd(*xref.PbPDF_XRef, *obj.PbPDF_Object)
  Protected entry.PbPDF_XRefEntry
  entry\entryType = #PbPDF_XREF_INUSE_ENTRY
  entry\byteOffset = 0
  entry\genNo = 0
  entry\obj = *obj
  Protected idx.i = PbPDF_ListAdd(*xref\entries, @entry)
  *obj\objId = idx
  *obj\genNo = 0
  *obj\flags | #PbPDF_OTYPE_INDIRECT
  ProcedureReturn idx
EndProcedure

;--- 交叉引用表获取条目数 ---
Procedure.i PbPDF_XRefGetCount(*xref.PbPDF_XRef)
  ProcedureReturn PbPDF_ListCount(*xref\entries)
EndProcedure

;--- 对象序列化：写入对象到流 ---
Procedure PbPDF_ObjWrite(*obj.PbPDF_Object, *stream.PbPDF_Stream)
  If Not *obj
    PbPDF_StreamWriteStr(*stream, "null")
    ProcedureReturn
  EndIf

  Select *obj\objType
    Case #PbPDF_OBJ_NULL
      PbPDF_StreamWriteStr(*stream, "null")

    Case #PbPDF_OBJ_BOOLEAN
      If *obj\boolValue
        PbPDF_StreamWriteStr(*stream, "true")
      Else
        PbPDF_StreamWriteStr(*stream, "false")
      EndIf

    Case #PbPDF_OBJ_NUMBER
      PbPDF_StreamWriteStr(*stream, Str(*obj\numberValue))

    Case #PbPDF_OBJ_REAL
      Protected realStr$
      realStr$ = StrF(*obj\realValue, 6)
      ; 去除尾部多余的0
      If FindString(realStr$, ".")
        While Right(realStr$, 1) = "0"
          realStr$ = Left(realStr$, Len(realStr$) - 1)
        Wend
        If Right(realStr$, 1) = "."
          realStr$ + "0"
        EndIf
      EndIf
      PbPDF_StreamWriteStr(*stream, realStr$)

    Case #PbPDF_OBJ_NAME
      PbPDF_StreamWriteStr(*stream, "/" + *obj\nameValue)

    Case #PbPDF_OBJ_STRING
      ; PDF规范：包含非ASCII字符的文本字符串必须使用UTF-16BE with BOM编码
      ; 检测字符串是否包含非ASCII字符
      Protected hasNonAscii.i = #False
      Protected si.i
      For si = 1 To Len(*obj\stringValue)
        If Asc(Mid(*obj\stringValue, si, 1)) > 127
          hasNonAscii = #True
          Break
        EndIf
      Next
      If hasNonAscii
        ; 使用UTF-16BE with BOM编码，以hex字符串形式写入
        ; hex字符串格式<FEFF...>避免了字面字符串中特殊字节(0x28/0x29/0x5C)的转义问题
        ; 且PDF阅读器对hex字符串的UTF-16BE兼容性更好
        ; 构建UTF-16BE字节数据：BOM(2字节) + 每个字符(2字节)
        Protected utf16Len.i = 2 + Len(*obj\stringValue) * 2
        Protected *utf16Buf = AllocateMemory(utf16Len + 2)
        If *utf16Buf
          ; 写入BOM: FE FF
          PokeA(*utf16Buf, $FE)
          PokeA(*utf16Buf + 1, $FF)
          Protected utf16Off.i = 2
          ; 写入每个字符的UTF-16BE编码
          For si = 1 To Len(*obj\stringValue)
            Protected ch.i = Asc(Mid(*obj\stringValue, si, 1))
            PokeA(*utf16Buf + utf16Off, (ch >> 8) & $FF)
            utf16Off + 1
            PokeA(*utf16Buf + utf16Off, ch & $FF)
            utf16Off + 1
          Next
          ; 检查是否需要加密
          If _PbPDF_CurrentEncrypt\mode <> 0
            ; 加密UTF-16BE字节数据
            Protected objKeyLenNA.i
            Protected Dim objKeyNA.a(20)
            PbPDF_ComputeObjKey(_PbPDF_CurrentEncrypt, _PbPDF_CurrentObjId, _PbPDF_CurrentGenNo, @objKeyNA(0), @objKeyLenNA)
            If objKeyLenNA > 0
              Protected *encBufNA = AllocateMemory(utf16Len + 1)
              If *encBufNA
                Protected rc4CtxNA.PbPDF_Encrypt
                PbPDF_RC4Init(@rc4CtxNA, @objKeyNA(0), objKeyLenNA)
                PbPDF_RC4Crypt(@rc4CtxNA, *utf16Buf, *encBufNA, utf16Len)
                ; 以hex string形式写入加密后的数据
                PbPDF_StreamWriteByte(*stream, '<')
                Protected eiNA.i
                For eiNA = 0 To utf16Len - 1
                  PbPDF_StreamWriteStr(*stream, RSet(Hex(PeekA(*encBufNA + eiNA)), 2, "0"))
                Next
                PbPDF_StreamWriteByte(*stream, '>')
                FreeMemory(*encBufNA)
              Else
                ; 加密缓冲区分配失败，回退到未加密hex字符串
                PbPDF_StreamWriteByte(*stream, '<')
                Protected eiFB.i
                For eiFB = 0 To utf16Len - 1
                  PbPDF_StreamWriteStr(*stream, RSet(Hex(PeekA(*utf16Buf + eiFB)), 2, "0"))
                Next
                PbPDF_StreamWriteByte(*stream, '>')
              EndIf
            Else
              ; 对象密钥计算失败，回退到未加密hex字符串
              PbPDF_StreamWriteByte(*stream, '<')
              Protected eiFB2.i
              For eiFB2 = 0 To utf16Len - 1
                PbPDF_StreamWriteStr(*stream, RSet(Hex(PeekA(*utf16Buf + eiFB2)), 2, "0"))
              Next
              PbPDF_StreamWriteByte(*stream, '>')
            EndIf
          Else
            ; 无加密，直接以hex字符串写入UTF-16BE数据
            PbPDF_StreamWriteByte(*stream, '<')
            Protected eiNA2.i
            For eiNA2 = 0 To utf16Len - 1
              PbPDF_StreamWriteStr(*stream, RSet(Hex(PeekA(*utf16Buf + eiNA2)), 2, "0"))
            Next
            PbPDF_StreamWriteByte(*stream, '>')
          EndIf
          FreeMemory(*utf16Buf)
        Else
          ; UTF-16BE缓冲区分配失败，回退到转义字面字符串
          PbPDF_StreamWriteStr(*stream, "(" + PbPDF_EscapeString(*obj\stringValue) + ")")
        EndIf
      Else
        ; 检查是否需要加密字符串
        If _PbPDF_CurrentEncrypt\mode <> 0
          ; 加密字符串：先转为字节，RC4加密，以hex string写入
          Protected strBytes.i = StringByteLength(*obj\stringValue, #PB_UTF8)
          Protected *strBuf = AllocateMemory(strBytes + 1)
          If *strBuf
            PokeS(*strBuf, *obj\stringValue, strBytes, #PB_UTF8)
            Protected objKeyLen2.i
            Protected Dim objKey2.a(20)
            PbPDF_ComputeObjKey(_PbPDF_CurrentEncrypt, _PbPDF_CurrentObjId, _PbPDF_CurrentGenNo, @objKey2(0), @objKeyLen2)
            If objKeyLen2 > 0
              Protected *encBuf2 = AllocateMemory(strBytes + 1)
              If *encBuf2
                Protected rc4Ctx2.PbPDF_Encrypt
                PbPDF_RC4Init(@rc4Ctx2, @objKey2(0), objKeyLen2)
                PbPDF_RC4Crypt(@rc4Ctx2, *strBuf, *encBuf2, strBytes)
                ; 以hex string形式写入加密后的数据
                PbPDF_StreamWriteByte(*stream, '<')
                Protected ei.i
                For ei = 0 To strBytes - 1
                  PbPDF_StreamWriteStr(*stream, RSet(Hex(PeekA(*encBuf2 + ei)), 2, "0"))
                Next
                PbPDF_StreamWriteByte(*stream, '>')
                FreeMemory(*encBuf2)
              Else
                PbPDF_StreamWriteStr(*stream, "(" + PbPDF_EscapeString(*obj\stringValue) + ")")
              EndIf
            Else
              PbPDF_StreamWriteStr(*stream, "(" + PbPDF_EscapeString(*obj\stringValue) + ")")
            EndIf
            FreeMemory(*strBuf)
          Else
            PbPDF_StreamWriteStr(*stream, "(" + PbPDF_EscapeString(*obj\stringValue) + ")")
          EndIf
        Else
          PbPDF_StreamWriteStr(*stream, "(" + PbPDF_EscapeString(*obj\stringValue) + ")")
        EndIf
      EndIf

    Case #PbPDF_OBJ_BINARY
      ; 检查是否需要加密二进制数据
      If _PbPDF_CurrentEncrypt\mode <> 0
        Protected binLen.i = Len(*obj\stringValue) / 2
        Protected *binBuf = AllocateMemory(binLen + 1)
        If *binBuf
          Protected bi5.i, hi6$, lo6$, bv.i
          For bi5 = 1 To Len(*obj\stringValue) Step 2
            hi6$ = Mid(*obj\stringValue, bi5, 1)
            lo6$ = Mid(*obj\stringValue, bi5 + 1, 1)
            bv = Val("$" + hi6$ + lo6$)
            PokeA(*binBuf + (bi5 - 1) / 2, bv)
          Next
          Protected objKeyLen3.i
          Protected Dim objKey3.a(20)
          PbPDF_ComputeObjKey(_PbPDF_CurrentEncrypt, _PbPDF_CurrentObjId, _PbPDF_CurrentGenNo, @objKey3(0), @objKeyLen3)
          If objKeyLen3 > 0
            Protected *encBuf3 = AllocateMemory(binLen + 1)
            If *encBuf3
              Protected rc4Ctx3.PbPDF_Encrypt
              PbPDF_RC4Init(@rc4Ctx3, @objKey3(0), objKeyLen3)
              PbPDF_RC4Crypt(@rc4Ctx3, *binBuf, *encBuf3, binLen)
              PbPDF_StreamWriteByte(*stream, '<')
              Protected ei2.i
              For ei2 = 0 To binLen - 1
                PbPDF_StreamWriteStr(*stream, RSet(Hex(PeekA(*encBuf3 + ei2)), 2, "0"))
              Next
              PbPDF_StreamWriteByte(*stream, '>')
              FreeMemory(*encBuf3)
            Else
              PbPDF_StreamWriteStr(*stream, "<" + *obj\stringValue + ">")
            EndIf
          Else
            PbPDF_StreamWriteStr(*stream, "<" + *obj\stringValue + ">")
          EndIf
          FreeMemory(*binBuf)
        Else
          PbPDF_StreamWriteStr(*stream, "<" + *obj\stringValue + ">")
        EndIf
      Else
        PbPDF_StreamWriteStr(*stream, "<" + *obj\stringValue + ">")
      EndIf

    Case #PbPDF_OBJ_ARRAY
      PbPDF_StreamWriteStr(*stream, "[")
      Protected i.i, count.i = PbPDF_ListCount(*obj\arrayData)
      For i = 0 To count - 1
        If i > 0
          PbPDF_StreamWriteStr(*stream, " ")
        EndIf
        Protected *item.PbPDF_Object = PbPDF_ListGetPointer(*obj\arrayData, i)
        If *item
          If *item\flags & #PbPDF_OTYPE_INDIRECT
            PbPDF_StreamWriteStr(*stream, Str(*item\objId) + " " + Str(*item\genNo) + " R")
          Else
            PbPDF_ObjWrite(*item, *stream)
          EndIf
        EndIf
      Next
      PbPDF_StreamWriteStr(*stream, "]")

    Case #PbPDF_OBJ_DICT
      PbPDF_StreamWriteStr(*stream, "<<")
      Protected dictCount.i = PbPDF_ListCount(*obj\dictKeys)
      For i = 0 To dictCount - 1
        Protected *keyPtr = PbPDF_ListGetPointer(*obj\dictKeys, i)
        Protected *valObj.PbPDF_Object = PbPDF_ListGetPointer(*obj\dictValues, i)
        If *keyPtr
          PbPDF_StreamWriteStr(*stream, "/" + PeekS(*keyPtr, -1, #PB_UTF8) + " ")
        EndIf
        If *valObj
          If *valObj\flags & #PbPDF_OTYPE_INDIRECT
            PbPDF_StreamWriteStr(*stream, Str(*valObj\objId) + " " + Str(*valObj\genNo) + " R")
          Else
            PbPDF_ObjWrite(*valObj, *stream)
          EndIf
        Else
          PbPDF_StreamWriteStr(*stream, "null")
        EndIf
      Next
      PbPDF_StreamWriteStr(*stream, ">>")

    Case #PbPDF_OBJ_INDIRECT
      PbPDF_StreamWriteStr(*stream, Str(*obj\objId) + " " + Str(*obj\genNo) + " R")

  EndSelect
EndProcedure

;--- 写入间接对象定义 ---
Procedure PbPDF_WriteIndirectObj(*obj.PbPDF_Object, *stream.PbPDF_Stream, *xref.PbPDF_XRef, *encrypt.PbPDF_Encrypt = 0)
  If Not *obj Or Not (*obj\flags & #PbPDF_OTYPE_INDIRECT)
    ProcedureReturn
  EndIf
  ; 记录偏移
  Protected idx.i = *obj\objId
  If idx >= 0 And idx < PbPDF_ListCount(*xref\entries)
    Protected *entry.PbPDF_XRefEntry = *xref\entries\items + idx * SizeOf(PbPDF_XRefEntry)
    *entry\byteOffset = *xref\addr
  EndIf
  ; 写入对象头
  Protected header$ = Str(*obj\objId) + " " + Str(*obj\genNo) + " obj" + #LF$
  PbPDF_StreamWriteStr(*stream, header$)
  *xref\addr + Len(header$)
  ; 设置全局加密上下文（用于字符串和二进制对象加密）
  If *encrypt
    CopyMemory(*encrypt, @_PbPDF_CurrentEncrypt, SizeOf(PbPDF_Encrypt))
  Else
    FillMemory(@_PbPDF_CurrentEncrypt, SizeOf(PbPDF_Encrypt), 0, #PB_Ascii)
  EndIf
  _PbPDF_CurrentObjId = *obj\objId
  _PbPDF_CurrentGenNo = *obj\genNo
  ; 写入对象内容
  Protected startAddr.i = *xref\addr
  PbPDF_ObjWrite(*obj, *stream)
  ; 清除全局加密上下文
  FillMemory(@_PbPDF_CurrentEncrypt, SizeOf(PbPDF_Encrypt), 0, #PB_Ascii)
  ; 写入流数据(如果有)
  If *obj\stream
    PbPDF_StreamWriteStr(*stream, #LF$ + "stream" + #LF$)
    ; 写入流内容
    Protected streamSize.i = *obj\stream\size
    If *obj\stream\streamType = 1 And *obj\stream\memAttr
      Protected *tmpBuf = AllocateMemory(streamSize + 1)
      If *tmpBuf
        Protected actualLen.i = PbPDF_MemStreamGetData(*obj\stream, *tmpBuf)
        ; 加密流数据（如果加密开启且不是加密字典对象）
        If *encrypt And *obj\objId > 0
          Protected objKeyLen.i
          Protected Dim objKey.a(20)
          PbPDF_ComputeObjKey(*encrypt, *obj\objId, *obj\genNo, @objKey(0), @objKeyLen)
          If objKeyLen > 0
            Protected *encBuf = AllocateMemory(actualLen + 1)
            If *encBuf
              Protected rc4Ctx.PbPDF_Encrypt
              PbPDF_RC4Init(@rc4Ctx, @objKey(0), objKeyLen)
              PbPDF_RC4Crypt(@rc4Ctx, *tmpBuf, *encBuf, actualLen)
              PbPDF_StreamWriteData(*stream, *encBuf, actualLen)
              FreeMemory(*encBuf)
            Else
              PbPDF_StreamWriteData(*stream, *tmpBuf, actualLen)
            EndIf
          Else
            PbPDF_StreamWriteData(*stream, *tmpBuf, actualLen)
          EndIf
        Else
          PbPDF_StreamWriteData(*stream, *tmpBuf, actualLen)
        EndIf
        FreeMemory(*tmpBuf)
      EndIf
    EndIf
    PbPDF_StreamWriteStr(*stream, #LF$ + "endstream")
  EndIf
  ; 写入对象尾
  Protected footer$ = #LF$ + "endobj" + #LF$
  PbPDF_StreamWriteStr(*stream, footer$)
  *xref\addr = *stream\size
EndProcedure

;=============================================================================
; 第8-17部分：文档管理（核心实现）
;=============================================================================

;--- 创建PDF文档对象 ---
Procedure.i PbPDF_New()
  Protected *doc.PbPDF_Doc = AllocateMemory(SizeOf(PbPDF_Doc))
  If *doc
    InitializeStructure(*doc, PbPDF_Doc)
    *doc\pdfVersion = #PbPDF_PDF_VER_17
    *doc\compressionMode = #PbPDF_COMP_ALL
    *doc\encryptOn = 0
    *doc\pageCount = 0
    *doc\ttfontTagCounter = 0
    *doc\imageTagCounter = 0
    *doc\validated = 0
    *doc\optimized = 0
    PbPDF_ClearError(@*doc\error)
  EndIf
  ProcedureReturn *doc
EndProcedure

;--- 前向声明 ---
Declare PbPDF_FreeDoc(*doc.PbPDF_Doc)

;--- 释放PDF文档对象 ---
Procedure PbPDF_Free(*doc.PbPDF_Doc)
  If Not *doc
    ProcedureReturn
  EndIf
  PbPDF_FreeDoc(*doc)
  ; 释放编码器
  If *doc\encoderMgr
    Protected i.i, count.i
    count = PbPDF_ListCount(*doc\encoderMgr)
    For i = 0 To count - 1
      Protected *enc.PbPDF_Encoder = PbPDF_ListGetPointer(*doc\encoderMgr, i)
      If *enc
        If *enc\attr
          FreeMemory(*enc\attr)
        EndIf
        FreeMemory(*enc)
      EndIf
    Next
    PbPDF_ListFree(*doc\encoderMgr)
  EndIf
  FreeMemory(*doc)
EndProcedure

;--- 创建新文档 ---
Procedure PbPDF_NewDoc(*doc.PbPDF_Doc)
  If Not *doc
    ProcedureReturn
  EndIf
  ; 释放旧文档
  PbPDF_FreeDoc(*doc)
  ; 创建交叉引用表
  *doc\xref = PbPDF_XRefNew(0)
  ; 创建Trailer字典
  *doc\trailerObj = PbPDF_DictNew()
  ; 创建Catalog
  *doc\catalogObj = PbPDF_DictNew(#PbPDF_OSUBCLASS_CATALOG)
  PbPDF_DictAddName(*doc\catalogObj, "Type", "Catalog")
  PbPDF_XRefAdd(*doc\xref, *doc\catalogObj)
  ; 创建根Pages节点
  *doc\rootPagesObj = PbPDF_DictNew(#PbPDF_OSUBCLASS_PAGES)
  PbPDF_DictAddName(*doc\rootPagesObj, "Type", "Pages")
  Protected *kidsArray.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_DictAdd(*doc\rootPagesObj, "Kids", *kidsArray)
  PbPDF_DictAddNumber(*doc\rootPagesObj, "Count", 0)
  PbPDF_XRefAdd(*doc\xref, *doc\rootPagesObj)
  ; Catalog引用Pages
  PbPDF_DictAdd(*doc\catalogObj, "Pages", *doc\rootPagesObj)
  ; 创建Info字典
  *doc\infoObj = PbPDF_DictNew(#PbPDF_OSUBCLASS_INFO)
  PbPDF_XRefAdd(*doc\xref, *doc\infoObj)
  ; 设置Trailer
  PbPDF_DictAdd(*doc\trailerObj, "Root", *doc\catalogObj)
  PbPDF_DictAdd(*doc\trailerObj, "Info", *doc\infoObj)
  PbPDF_DictAddNumber(*doc\trailerObj, "Size", PbPDF_XRefGetCount(*doc\xref))
  ; 创建页面列表
  *doc\pageList = PbPDF_ListNew(#PB_Long, 16)
  ; 创建字体管理列表
  *doc\fontMgr = PbPDF_ListNew(#PB_Long, 8)
  *doc\fontDefMgr = PbPDF_ListNew(#PB_Long, 8)
  *doc\encoderMgr = PbPDF_ListNew(#PB_Long, 8)
  ; 创建默认编码器
  ; (将在第二阶段实现)
  ; 设置默认文档信息
  Protected date.PbPDF_Date
  PbPDF_GetCurrentDate(@date)
  PbPDF_DictAddString(*doc\infoObj, "Producer", "PbPDFlib " + #PbPDF_VERSION_TEXT$)
  PbPDF_DictAddString(*doc\infoObj, "CreationDate", PbPDF_FormatPDFDate(@date))
EndProcedure

;--- 释放文档内容 ---
Procedure PbPDF_FreeDoc(*doc.PbPDF_Doc)
  If Not *doc
    ProcedureReturn
  EndIf
  ; 释放页面列表
  If *doc\pageList
    PbPDF_ListFree(*doc\pageList)
    *doc\pageList = 0
  EndIf
  ; 释放字体管理列表
  If *doc\fontMgr
    Protected i.i, count.i
    count = PbPDF_ListCount(*doc\fontMgr)
    For i = 0 To count - 1
      Protected *font.PbPDF_Font = PbPDF_ListGetPointer(*doc\fontMgr, i)
      If *font
        If *font\widths
          FreeMemory(*font\widths)
        EndIf
        If *font\used
          FreeMemory(*font\used)
        EndIf
        FreeMemory(*font)
      EndIf
    Next
    PbPDF_ListFree(*doc\fontMgr)
    *doc\fontMgr = 0
  EndIf
  ; 释放字体定义列表
  If *doc\fontDefMgr
    count = PbPDF_ListCount(*doc\fontDefMgr)
    For i = 0 To count - 1
      Protected *fontDef.PbPDF_FontDef = PbPDF_ListGetPointer(*doc\fontDefMgr, i)
      If *fontDef
        If *fontDef\attr
          FreeMemory(*fontDef\attr)
        EndIf
        If *fontDef\dataStream
          PbPDF_StreamFree(*fontDef\dataStream)
        EndIf
        FreeMemory(*fontDef)
      EndIf
    Next
    PbPDF_ListFree(*doc\fontDefMgr)
    *doc\fontDefMgr = 0
  EndIf
  ; 释放交叉引用表(会递归释放所有注册的对象)
  If *doc\xref
    PbPDF_XRefFree(*doc\xref)
    *doc\xref = 0
  EndIf
  ; 释放Trailer(如果未注册到xref)
  If *doc\trailerObj
    PbPDF_ObjFree(*doc\trailerObj)
    *doc\trailerObj = 0
  EndIf
  ; 释放加密对象
  If *doc\encrypt
    FreeMemory(*doc\encrypt)
    *doc\encrypt = 0
  EndIf
  *doc\pageCount = 0
  *doc\catalogObj = 0
  *doc\rootPagesObj = 0
  *doc\curPageObj = 0
  *doc\infoObj = 0
EndProcedure

;--- 添加新页面 ---
Procedure.i PbPDF_AddPage(*doc.PbPDF_Doc)
  If Not *doc Or Not *doc\xref
    ProcedureReturn 0
  EndIf
  ; 创建页面对象
  Protected *pageObj.PbPDF_Object = PbPDF_DictNew(#PbPDF_OSUBCLASS_PAGE)
  PbPDF_DictAddName(*pageObj, "Type", "Page")
  ; 设置父节点
  PbPDF_DictAdd(*pageObj, "Parent", *doc\rootPagesObj)
  ; 设置默认MediaBox (A4)
  Protected *mediaBox.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_ArrayAdd(*mediaBox, PbPDF_NumberNew(0))
  PbPDF_ArrayAdd(*mediaBox, PbPDF_NumberNew(0))
  PbPDF_ArrayAdd(*mediaBox, PbPDF_RealNew(595.276))
  PbPDF_ArrayAdd(*mediaBox, PbPDF_RealNew(841.89))
  PbPDF_DictAdd(*pageObj, "MediaBox", *mediaBox)
  ; 创建页面属性
  Protected *pageAttr.PbPDF_PageAttr = AllocateMemory(SizeOf(PbPDF_PageAttr))
  If *pageAttr
    InitializeStructure(*pageAttr, PbPDF_PageAttr)
    *pageAttr\parent = *doc\rootPagesObj
    *pageAttr\gmode = #PbPDF_GMODE_PAGE_DESCRIPTION
    *pageAttr\compressionMode = *doc\compressionMode
    *pageAttr\mediaBox\llx = 0
    *pageAttr\mediaBox\lly = 0
    *pageAttr\mediaBox\urx = 595.276
    *pageAttr\mediaBox\ury = 841.89
    ; 创建初始图形状态
    *pageAttr\gstate = AllocateMemory(SizeOf(PbPDF_GState))
    If *pageAttr\gstate
      InitializeStructure(*pageAttr\gstate, PbPDF_GState)
      *pageAttr\gstate\lineWidth = 1.0
      *pageAttr\gstate\fontSize = 10.0
      *pageAttr\gstate\hScalling = 100.0
      *pageAttr\gstate\depth = 1
    EndIf
    ; 创建内容流
    *pageAttr\contentStream = PbPDF_MemStreamNew()
    *pageObj\attr = *pageAttr
  EndIf
  ; 注册到xref
  PbPDF_XRefAdd(*doc\xref, *pageObj)
  ; 添加到页面树
  Protected *kidsArray.PbPDF_Object = PbPDF_DictGetValue(*doc\rootPagesObj, "Kids")
  If *kidsArray
    PbPDF_ArrayAdd(*kidsArray, *pageObj)
  EndIf
  ; 更新页面计数
  *doc\pageCount + 1
  PbPDF_DictAddNumber(*doc\rootPagesObj, "Count", *doc\pageCount)
  ; 添加到页面列表
  If *doc\pageList
    PbPDF_ListAddPointer(*doc\pageList, *pageObj)
  EndIf
  ; 设置为当前页面
  *doc\curPageObj = *pageObj
  ProcedureReturn *pageObj
EndProcedure

;--- 获取页面 ---
Procedure.i PbPDF_GetPageByIndex(*doc.PbPDF_Doc, index.i)
  If Not *doc Or Not *doc\pageList
    ProcedureReturn 0
  EndIf
  If index < 0 Or index >= *doc\pageCount
    ProcedureReturn 0
  EndIf
  ProcedureReturn PbPDF_ListGetPointer(*doc\pageList, index)
EndProcedure

;--- 获取当前页面 ---
Procedure.i PbPDF_GetCurrentPage(*doc.PbPDF_Doc)
  If *doc
    ProcedureReturn *doc\curPageObj
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 设置页面尺寸 ---
Procedure PbPDF_Page_SetSize(*pageObj.PbPDF_Object, width.f, height.f)
  If Not *pageObj Or *pageObj\objType <> #PbPDF_OBJ_DICT
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If *pageAttr
    *pageAttr\mediaBox\llx = 0
    *pageAttr\mediaBox\lly = 0
    *pageAttr\mediaBox\urx = width
    *pageAttr\mediaBox\ury = height
  EndIf
  ; 更新MediaBox字典条目
  Protected *mediaBox.PbPDF_Object = PbPDF_DictGetValue(*pageObj, "MediaBox")
  If *mediaBox And *mediaBox\objType = #PbPDF_OBJ_ARRAY
    Protected *w.PbPDF_Object = PbPDF_ArrayGetItem(*mediaBox, 2)
    Protected *h.PbPDF_Object = PbPDF_ArrayGetItem(*mediaBox, 3)
    If *w
      *w\realValue = width
    EndIf
    If *h
      *h\realValue = height
    EndIf
  EndIf
EndProcedure

;--- 设置预定义页面尺寸 ---
Procedure PbPDF_Page_SetPredefinedSize(*pageObj.PbPDF_Object, pageSize.i, direction.i = #PbPDF_PAGE_PORTRAIT)
  Protected w.f, h.f
  Protected *ptr.PbPDF_PageSize = ?PbPDF_PageSizes + pageSize * SizeOf(PbPDF_PageSize)
  w = *ptr\width
  h = *ptr\height
  If direction = #PbPDF_PAGE_LANDSCAPE
    Swap w, h
  EndIf
  PbPDF_Page_SetSize(*pageObj, w, h)
EndProcedure

;--- 获取页面宽度 ---
Procedure.f PbPDF_Page_GetWidth(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn 0
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If *pageAttr
    ProcedureReturn *pageAttr\mediaBox\urx - *pageAttr\mediaBox\llx
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 获取页面高度 ---
Procedure.f PbPDF_Page_GetHeight(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn 0
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If *pageAttr
    ProcedureReturn *pageAttr\mediaBox\ury - *pageAttr\mediaBox\lly
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 保存PDF到文件 ---
Procedure.i PbPDF_SaveToFile(*doc.PbPDF_Doc, fileName$)
  If Not *doc Or Not *doc\xref
    ProcedureReturn #PbPDF_ERR_INVALID_DOC
  EndIf
  Protected *stream.PbPDF_Stream = PbPDF_FileWriteStreamNew(fileName$)
  If Not *stream
    ProcedureReturn #PbPDF_ERR_FILE_OPEN
  EndIf
  ; 写入PDF文件头
  Protected header$
  Select *doc\pdfVersion
    Case #PbPDF_PDF_VER_12: header$ = "%PDF-1.2"
    Case #PbPDF_PDF_VER_13: header$ = "%PDF-1.3"
    Case #PbPDF_PDF_VER_14: header$ = "%PDF-1.4"
    Case #PbPDF_PDF_VER_15: header$ = "%PDF-1.5"
    Case #PbPDF_PDF_VER_16: header$ = "%PDF-1.6"
    Case #PbPDF_PDF_VER_17: header$ = "%PDF-1.7"
    Case #PbPDF_PDF_VER_20: header$ = "%PDF-2.0"
    Default: header$ = "%PDF-1.7"
  EndSelect
  PbPDF_StreamWriteStr(*stream, header$ + #LF$)
  ; 写入二进制标记(表示文件包含二进制数据)
  PbPDF_StreamWriteByte(*stream, '%')
  Protected b.a
  For b = 128 To 255
    PbPDF_StreamWriteByte(*stream, b)
  Next
  PbPDF_StreamWriteEOL(*stream)
  ; 初始化xref地址
  *doc\xref\addr = *stream\size
  ; 写入所有间接对象
  Protected i.i, count.i = PbPDF_XRefGetCount(*doc\xref)
  For i = 0 To count - 1
    Protected *entry.PbPDF_XRefEntry = *doc\xref\entries\items + i * SizeOf(PbPDF_XRefEntry)
    If *entry\obj And (*entry\entryType = #PbPDF_XREF_INUSE_ENTRY)
      ; 加密对象时排除加密字典和文档ID数组
      Protected *encParam.PbPDF_Encrypt = 0
      If *doc\encryptOn And *doc\encrypt
        ; 排除加密字典对象（Encrypt dict）不加密
        If *doc\encryptDictObj And *entry\obj = *doc\encryptDictObj
          *encParam = 0
        Else
          *encParam = *doc\encrypt
        EndIf
      EndIf
      PbPDF_WriteIndirectObj(*entry\obj, *stream, *doc\xref, *encParam)
    EndIf
  Next
  ; 写入xref表
  Protected xrefOffset.i = *stream\size
  PbPDF_StreamWriteStr(*stream, "xref" + #LF$)
  PbPDF_StreamWriteStr(*stream, "0 " + Str(count) + #LF$)
  For i = 0 To count - 1
    *entry = *doc\xref\entries\items + i * SizeOf(PbPDF_XRefEntry)
    If *entry\entryType = #PbPDF_XREF_FREE_ENTRY
      Protected nextFree$ = "0000000000"
      If i = 0
        nextFree$ = "0000000000"
      EndIf
      PbPDF_StreamWriteStr(*stream, nextFree$ + " " + RSet(Str(*entry\genNo), 5, "0") + " f " + #LF$)
    Else
      PbPDF_StreamWriteStr(*stream, RSet(Str(*entry\byteOffset), 10, "0") + " " + RSet(Str(*entry\genNo), 5, "0") + " n " + #LF$)
    EndIf
  Next
  ; 写入Trailer
  PbPDF_StreamWriteStr(*stream, "trailer" + #LF$)
  PbPDF_DictAddNumber(*doc\trailerObj, "Size", count)
  PbPDF_ObjWrite(*doc\trailerObj, *stream)
  PbPDF_StreamWriteEOL(*stream)
  ; 写入startxref
  PbPDF_StreamWriteStr(*stream, "startxref" + #LF$)
  PbPDF_StreamWriteStr(*stream, Str(xrefOffset) + #LF$)
  PbPDF_StreamWriteStr(*stream, "%%EOF" + #LF$)
  ; 关闭流
  PbPDF_StreamFree(*stream)
  ProcedureReturn #PbPDF_OK
EndProcedure

;=============================================================================
; 第19部分：目标链接(Destination)

;--- 创建目标对象 ---
; 创建一个指向指定页面的目标链接
; *page: 目标页面对象
; destType: 目标类型(#PbPDF_DEST_xxx)
; left, top, right, bottom, zoom: 目标参数(根据类型不同使用不同参数)
;   XYZ: left, top, zoom (null值表示保持不变)
;   Fit: 无参数
;   FitH: top
;   FitV: left
;   FitR: left, top, right, bottom
;   FitB: 无参数
;   FitBH: top
;   FitBV: left
Procedure.i PbPDF_CreateDestination(*page.PbPDF_Object, destType.i, left.f, top.f, right.f, bottom.f, zoom.f)
  Protected *dest.PbPDF_Object
  If Not *page
    ProcedureReturn 0
  EndIf
  *dest = PbPDF_ArrayNew()
  If Not *dest
    ProcedureReturn 0
  EndIf
  ; 数组第一个元素是页面引用
  PbPDF_ArrayAdd(*dest, *page)
  ; 根据目标类型添加参数
  Select destType
    Case #PbPDF_DEST_XYZ
      PbPDF_ArrayAddName(*dest, "XYZ")
      If left >= 0
        PbPDF_ArrayAddReal(*dest, left)
      Else
        PbPDF_ArrayAdd(*dest, PbPDF_NullNew())
      EndIf
      If top >= 0
        PbPDF_ArrayAddReal(*dest, top)
      Else
        PbPDF_ArrayAdd(*dest, PbPDF_NullNew())
      EndIf
      If zoom >= 0
        PbPDF_ArrayAddReal(*dest, zoom)
      Else
        PbPDF_ArrayAdd(*dest, PbPDF_NullNew())
      EndIf
    Case #PbPDF_DEST_FIT
      PbPDF_ArrayAddName(*dest, "Fit")
    Case #PbPDF_DEST_FITH
      PbPDF_ArrayAddName(*dest, "FitH")
      If top >= 0
        PbPDF_ArrayAddReal(*dest, top)
      Else
        PbPDF_ArrayAdd(*dest, PbPDF_NullNew())
      EndIf
    Case #PbPDF_DEST_FITV
      PbPDF_ArrayAddName(*dest, "FitV")
      If left >= 0
        PbPDF_ArrayAddReal(*dest, left)
      Else
        PbPDF_ArrayAdd(*dest, PbPDF_NullNew())
      EndIf
    Case #PbPDF_DEST_FITR
      PbPDF_ArrayAddName(*dest, "FitR")
      PbPDF_ArrayAddReal(*dest, left)
      PbPDF_ArrayAddReal(*dest, bottom)
      PbPDF_ArrayAddReal(*dest, right)
      PbPDF_ArrayAddReal(*dest, top)
    Case #PbPDF_DEST_FITB
      PbPDF_ArrayAddName(*dest, "FitB")
    Case #PbPDF_DEST_FITBH
      PbPDF_ArrayAddName(*dest, "FitBH")
      If top >= 0
        PbPDF_ArrayAddReal(*dest, top)
      Else
        PbPDF_ArrayAdd(*dest, PbPDF_NullNew())
      EndIf
    Case #PbPDF_DEST_FITBV
      PbPDF_ArrayAddName(*dest, "FitBV")
      If left >= 0
        PbPDF_ArrayAddReal(*dest, left)
      Else
        PbPDF_ArrayAdd(*dest, PbPDF_NullNew())
      EndIf
  EndSelect
  ProcedureReturn *dest
EndProcedure

;=============================================================================
; 第20部分：书签/大纲(Outline)
;=============================================================================

;--- 创建大纲/书签 ---
; 在文档中创建一个新的书签条目
; *doc: PDF文档对象
; title$: 书签标题
; *parent: 父书签(为0表示顶级书签)
; *dest: 跳转目标(由PbPDF_CreateDestination创建)
; opened: 是否展开子项
; 返回书签对象指针
Procedure.i PbPDF_CreateOutline(*doc.PbPDF_Doc, title$, *parent.PbPDF_Outline, *dest, opened.i = #False)
  Protected *outline.PbPDF_Outline
  If Not *doc Or title$ = ""
    ProcedureReturn 0
  EndIf
  ; 分配大纲对象
  *outline = AllocateMemory(SizeOf(PbPDF_Outline))
  If Not *outline
    ProcedureReturn 0
  EndIf
  InitializeStructure(*outline, PbPDF_Outline)
  ; 创建大纲字典
  *outline\dictObj = PbPDF_DictNew(#PbPDF_OSUBCLASS_OUTLINE)
  If Not *outline\dictObj
    FreeMemory(*outline)
    ProcedureReturn 0
  EndIf
  PbPDF_XRefAdd(*doc\xref, *outline\dictObj)
  ; 设置标题
  *outline\title = title$
  PbPDF_DictAddString(*outline\dictObj, "Title", title$)
  ; 设置目标
  If *dest
    *outline\dest = *dest
    PbPDF_DictAdd(*outline\dictObj, "Dest", *dest)
  EndIf
  ; 设置展开状态
  *outline\opened = opened
  ; 建立父子关系
  If *parent
    *outline\parent = *parent
    ; 添加到父节点的子列表末尾
    If *parent\first = 0
      ; 第一个子节点
      *parent\first = *outline
      *parent\last = *outline
    Else
      ; 添加到兄弟链表末尾
      *parent\last\next = *outline
      *outline\prev = *parent\last
      *parent\last = *outline
    EndIf
    *parent\count + 1
  Else
    ; 顶级书签，添加到文档大纲根
    If *doc\outlinesRoot = 0
      ; 创建大纲根节点
      *doc\outlinesRoot = AllocateMemory(SizeOf(PbPDF_Outline))
      If *doc\outlinesRoot
        InitializeStructure(*doc\outlinesRoot, PbPDF_Outline)
        *doc\outlinesRoot\dictObj = PbPDF_DictNew(#PbPDF_OSUBCLASS_OUTLINE)
        If *doc\outlinesRoot\dictObj
          PbPDF_XRefAdd(*doc\xref, *doc\outlinesRoot\dictObj)
          PbPDF_DictAddName(*doc\outlinesRoot\dictObj, "Type", "Outlines")
        EndIf
      EndIf
    EndIf
    ; 添加到根节点的子列表
    If *doc\outlinesRoot
      If *doc\outlinesRoot\first = 0
        *doc\outlinesRoot\first = *outline
        *doc\outlinesRoot\last = *outline
      Else
        *doc\outlinesRoot\last\next = *outline
        *outline\prev = *doc\outlinesRoot\last
        *doc\outlinesRoot\last = *outline
      EndIf
      *doc\outlinesRoot\count + 1
      *outline\parent = *doc\outlinesRoot
    EndIf
  EndIf
  ProcedureReturn *outline
EndProcedure

;--- 递归写入大纲字典的链接关系 ---
; 在保存PDF前调用，将大纲树结构写入PDF字典对象
Procedure PbPDF_WriteOutlineTree(*outline.PbPDF_Outline)
  If Not *outline Or Not *outline\dictObj
    ProcedureReturn
  EndIf
  ; 写入First/Last/Prev/Next引用
  If *outline\first And *outline\first\dictObj
    PbPDF_DictAdd(*outline\dictObj, "First", *outline\first\dictObj)
  EndIf
  If *outline\last And *outline\last\dictObj
    PbPDF_DictAdd(*outline\dictObj, "Last", *outline\last\dictObj)
  EndIf
  If *outline\prev And *outline\prev\dictObj
    PbPDF_DictAdd(*outline\dictObj, "Prev", *outline\prev\dictObj)
  EndIf
  If *outline\next And *outline\next\dictObj
    PbPDF_DictAdd(*outline\dictObj, "Next", *outline\next\dictObj)
  EndIf
  ; 写入Count(子项数量)
  If *outline\count > 0
    If *outline\opened
      PbPDF_DictAddNumber(*outline\dictObj, "Count", *outline\count)
    Else
      PbPDF_DictAddNumber(*outline\dictObj, "Count", -*outline\count)
    EndIf
  EndIf
  ; 写入Parent引用
  If *outline\parent And *outline\parent\dictObj
    PbPDF_DictAdd(*outline\dictObj, "Parent", *outline\parent\dictObj)
  EndIf
  ; 递归处理子节点
  Protected *child.PbPDF_Outline = *outline\first
  While *child
    PbPDF_WriteOutlineTree(*child)
    *child = *child\next
  Wend
EndProcedure

;--- 将大纲写入文档目录 ---
; 在保存PDF前调用，将大纲根节点与文档目录关联
Procedure PbPDF_WriteOutlines(*doc.PbPDF_Doc)
  If Not *doc Or Not *doc\outlinesRoot Or Not *doc\outlinesRoot\dictObj
    ProcedureReturn
  EndIf
  ; 递归写入所有大纲节点的链接关系
  Protected *child.PbPDF_Outline = *doc\outlinesRoot\first
  While *child
    PbPDF_WriteOutlineTree(*child)
    *child = *child\next
  Wend
  ; 写入大纲根节点的First/Last
  If *doc\outlinesRoot\first And *doc\outlinesRoot\first\dictObj
    PbPDF_DictAdd(*doc\outlinesRoot\dictObj, "First", *doc\outlinesRoot\first\dictObj)
  EndIf
  If *doc\outlinesRoot\last And *doc\outlinesRoot\last\dictObj
    PbPDF_DictAdd(*doc\outlinesRoot\dictObj, "Last", *doc\outlinesRoot\last\dictObj)
  EndIf
  ; 写入Count
  If *doc\outlinesRoot\count > 0
    PbPDF_DictAddNumber(*doc\outlinesRoot\dictObj, "Count", *doc\outlinesRoot\count)
  EndIf
  ; 将大纲根节点添加到文档目录
  PbPDF_DictAdd(*doc\catalogObj, "Outlines", *doc\outlinesRoot\dictObj)
  ; 设置页面模式为UseOutlines(显示书签面板)
  PbPDF_DictAddName(*doc\catalogObj, "PageMode", "UseOutlines")
EndProcedure

;--- 设置大纲展开状态 ---
Procedure PbPDF_SetOutlineOpened(*outline.PbPDF_Outline, opened.i)
  If *outline
    *outline\opened = opened
  EndIf
EndProcedure

;=============================================================================
; 第21部分：注释(Annotation)
;=============================================================================

;--- 注释类型名称映射 ---
Procedure.s PbPDF_AnnotTypeName(annotType.i)
  Select annotType
    Case #PbPDF_ANNOT_TEXT:             ProcedureReturn "Text"
    Case #PbPDF_ANNOT_LINK:             ProcedureReturn "Link"
    Case #PbPDF_ANNOT_FREE_TEXT:        ProcedureReturn "FreeText"
    Case #PbPDF_ANNOT_LINE:             ProcedureReturn "Line"
    Case #PbPDF_ANNOT_SQUARE:           ProcedureReturn "Square"
    Case #PbPDF_ANNOT_CIRCLE:           ProcedureReturn "Circle"
    Case #PbPDF_ANNOT_HIGHLIGHT:        ProcedureReturn "Highlight"
    Case #PbPDF_ANNOT_UNDERLINE:        ProcedureReturn "Underline"
    Case #PbPDF_ANNOT_SQUIGGLY:         ProcedureReturn "Squiggly"
    Case #PbPDF_ANNOT_STRIKE_OUT:       ProcedureReturn "StrikeOut"
    Case #PbPDF_ANNOT_STAMP:            ProcedureReturn "Stamp"
    Case #PbPDF_ANNOT_INK:              ProcedureReturn "Ink"
    Case #PbPDF_ANNOT_POPUP:            ProcedureReturn "Popup"
    Case #PbPDF_ANNOT_FILE_ATTACHMENT:  ProcedureReturn "FileAttachment"
    Case #PbPDF_ANNOT_SOUND:            ProcedureReturn "Sound"
    Case #PbPDF_ANNOT_WIDGET:           ProcedureReturn "Widget"
    Case #PbPDF_ANNOT_3D:               ProcedureReturn "3D"
    Case #PbPDF_ANNOT_PROJECTION:       ProcedureReturn "Projection"
    Default:                             ProcedureReturn "Text"
  EndSelect
EndProcedure

;--- 创建文本注释 ---
; 在页面上创建一个文本注释(便签式注释)
; *page: 页面对象
; x, y: 注释位置(左下角坐标)
; width, height: 注释图标大小
; title$: 注释标题(作者名)
; contents$: 注释内容文本
; 返回注释对象指针
Procedure.i PbPDF_CreateTextAnnot(*doc.PbPDF_Doc, *page.PbPDF_Object, x.f, y.f, width.f, height.f, title$, contents$)
  Protected *annot.PbPDF_Annotation
  Protected *annotDict.PbPDF_Object
  Protected *rectArray.PbPDF_Object
  If Not *doc Or Not *page
    ProcedureReturn 0
  EndIf
  ; 分配注释对象
  *annot = AllocateMemory(SizeOf(PbPDF_Annotation))
  If Not *annot
    ProcedureReturn 0
  EndIf
  InitializeStructure(*annot, PbPDF_Annotation)
  ; 创建注释字典
  *annotDict = PbPDF_DictNew(#PbPDF_OSUBCLASS_ANNOTATION)
  If Not *annotDict
    FreeMemory(*annot)
    ProcedureReturn 0
  EndIf
  PbPDF_XRefAdd(*doc\xref, *annotDict)
  *annot\dictObj = *annotDict
  *annot\annotType = #PbPDF_ANNOT_TEXT
  ; 设置类型
  PbPDF_DictAddName(*annotDict, "Type", "Annot")
  PbPDF_DictAddName(*annotDict, "Subtype", "Text")
  ; 设置矩形区域
  *rectArray = PbPDF_ArrayNew()
  PbPDF_ArrayAddReal(*rectArray, x)
  PbPDF_ArrayAddReal(*rectArray, y)
  PbPDF_ArrayAddReal(*rectArray, x + width)
  PbPDF_ArrayAddReal(*rectArray, y + height)
  PbPDF_DictAdd(*annotDict, "Rect", *rectArray)
  ; 设置标题
  If title$ <> ""
    *annot\title = title$
    PbPDF_DictAddString(*annotDict, "T", title$)
  EndIf
  ; 设置内容
  If contents$ <> ""
    *annot\contents = contents$
    PbPDF_DictAddString(*annotDict, "Contents", contents$)
  EndIf
  ; 设置颜色(黄色，便签注释的默认颜色)
  *annot\color\r = 1.0
  *annot\color\g = 1.0
  *annot\color\b = 0.0
  Protected *colorArray.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_ArrayAddReal(*colorArray, 1.0)
  PbPDF_ArrayAddReal(*colorArray, 1.0)
  PbPDF_ArrayAddReal(*colorArray, 0.0)
  PbPDF_DictAdd(*annotDict, "C", *colorArray)
  ; 将注释添加到页面的Annots数组
  Protected *pageAttr.PbPDF_PageAttr = *page\attr
  If *pageAttr
    Protected *annots.PbPDF_Object = PbPDF_DictGetValue(*page, "Annots")
    If Not *annots
      *annots = PbPDF_ArrayNew()
      PbPDF_DictAdd(*page, "Annots", *annots)
    EndIf
    PbPDF_ArrayAdd(*annots, *annotDict)
  EndIf
  ProcedureReturn *annot
EndProcedure

;--- 创建链接注释 ---
; 在页面上创建一个可点击的链接区域
; *page: 页面对象
; x, y: 链接区域左下角坐标
; width, height: 链接区域大小
; *dest: 跳转目标(由PbPDF_CreateDestination创建)
; 返回注释对象指针
Procedure.i PbPDF_CreateLinkAnnot(*doc.PbPDF_Doc, *page.PbPDF_Object, x.f, y.f, width.f, height.f, *dest)
  Protected *annot.PbPDF_Annotation
  Protected *annotDict.PbPDF_Object
  Protected *rectArray.PbPDF_Object
  If Not *doc Or Not *page
    ProcedureReturn 0
  EndIf
  ; 分配注释对象
  *annot = AllocateMemory(SizeOf(PbPDF_Annotation))
  If Not *annot
    ProcedureReturn 0
  EndIf
  InitializeStructure(*annot, PbPDF_Annotation)
  ; 创建注释字典
  *annotDict = PbPDF_DictNew(#PbPDF_OSUBCLASS_ANNOTATION)
  If Not *annotDict
    FreeMemory(*annot)
    ProcedureReturn 0
  EndIf
  PbPDF_XRefAdd(*doc\xref, *annotDict)
  *annot\dictObj = *annotDict
  *annot\annotType = #PbPDF_ANNOT_LINK
  ; 设置类型
  PbPDF_DictAddName(*annotDict, "Type", "Annot")
  PbPDF_DictAddName(*annotDict, "Subtype", "Link")
  ; 设置矩形区域
  *rectArray = PbPDF_ArrayNew()
  PbPDF_ArrayAddReal(*rectArray, x)
  PbPDF_ArrayAddReal(*rectArray, y)
  PbPDF_ArrayAddReal(*rectArray, x + width)
  PbPDF_ArrayAddReal(*rectArray, y + height)
  PbPDF_DictAdd(*annotDict, "Rect", *rectArray)
  ; 设置边框(无边框)
  Protected *borderArray.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_ArrayAddNumber(*borderArray, 0)
  PbPDF_ArrayAddNumber(*borderArray, 0)
  PbPDF_ArrayAddNumber(*borderArray, 0)
  PbPDF_DictAdd(*annotDict, "Border", *borderArray)
  ; 设置目标
  If *dest
    *annot\dest = *dest
    PbPDF_DictAdd(*annotDict, "Dest", *dest)
  EndIf
  ; 将注释添加到页面的Annots数组
  Protected *pageAttr.PbPDF_PageAttr = *page\attr
  If *pageAttr
    Protected *annots.PbPDF_Object = PbPDF_DictGetValue(*page, "Annots")
    If Not *annots
      *annots = PbPDF_ArrayNew()
      PbPDF_DictAdd(*page, "Annots", *annots)
    EndIf
    PbPDF_ArrayAdd(*annots, *annotDict)
  EndIf
  ProcedureReturn *annot
EndProcedure

;--- 创建URI链接注释 ---
; 在页面上创建一个指向外部URL的链接
; *page: 页面对象
; x, y: 链接区域左下角坐标
; width, height: 链接区域大小
; uri$: URI地址(如"http://www.example.com")
; 返回注释对象指针
Procedure.i PbPDF_CreateURILinkAnnot(*doc.PbPDF_Doc, *page.PbPDF_Object, x.f, y.f, width.f, height.f, uri$)
  Protected *annot.PbPDF_Annotation
  Protected *annotDict.PbPDF_Object
  Protected *rectArray.PbPDF_Object
  Protected *uriAction.PbPDF_Object
  If Not *doc Or Not *page Or uri$ = ""
    ProcedureReturn 0
  EndIf
  ; 分配注释对象
  *annot = AllocateMemory(SizeOf(PbPDF_Annotation))
  If Not *annot
    ProcedureReturn 0
  EndIf
  InitializeStructure(*annot, PbPDF_Annotation)
  ; 创建注释字典
  *annotDict = PbPDF_DictNew(#PbPDF_OSUBCLASS_ANNOTATION)
  If Not *annotDict
    FreeMemory(*annot)
    ProcedureReturn 0
  EndIf
  PbPDF_XRefAdd(*doc\xref, *annotDict)
  *annot\dictObj = *annotDict
  *annot\annotType = #PbPDF_ANNOT_LINK
  *annot\uri = uri$
  ; 设置类型
  PbPDF_DictAddName(*annotDict, "Type", "Annot")
  PbPDF_DictAddName(*annotDict, "Subtype", "Link")
  ; 设置矩形区域
  *rectArray = PbPDF_ArrayNew()
  PbPDF_ArrayAddReal(*rectArray, x)
  PbPDF_ArrayAddReal(*rectArray, y)
  PbPDF_ArrayAddReal(*rectArray, x + width)
  PbPDF_ArrayAddReal(*rectArray, y + height)
  PbPDF_DictAdd(*annotDict, "Rect", *rectArray)
  ; 设置边框
  Protected *borderArray.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_ArrayAddNumber(*borderArray, 0)
  PbPDF_ArrayAddNumber(*borderArray, 0)
  PbPDF_ArrayAddNumber(*borderArray, 1)
  PbPDF_DictAdd(*annotDict, "Border", *borderArray)
  ; 创建URI动作
  *uriAction = PbPDF_DictNew()
  PbPDF_DictAddName(*uriAction, "S", "URI")
  PbPDF_DictAddString(*uriAction, "URI", uri$)
  PbPDF_DictAdd(*annotDict, "A", *uriAction)
  ; 将注释添加到页面的Annots数组
  Protected *pageAttr.PbPDF_PageAttr = *page\attr
  If *pageAttr
    Protected *annots.PbPDF_Object = PbPDF_DictGetValue(*page, "Annots")
    If Not *annots
      *annots = PbPDF_ArrayNew()
      PbPDF_DictAdd(*page, "Annots", *annots)
    EndIf
    PbPDF_ArrayAdd(*annots, *annotDict)
  EndIf
  ProcedureReturn *annot
EndProcedure

;--- 创建高亮注释 ---
; 在页面上创建一个高亮区域注释
; *page: 页面对象
; x, y: 高亮区域左下角坐标
; width, height: 高亮区域大小
; title$: 注释标题
; contents$: 注释内容
; r, g, b: 高亮颜色(RGB, 0.0~1.0)
; 返回注释对象指针
Procedure.i PbPDF_CreateHighlightAnnot(*doc.PbPDF_Doc, *page.PbPDF_Object, x.f, y.f, width.f, height.f, title$, contents$, r.f, g.f, b.f)
  Protected *annot.PbPDF_Annotation
  Protected *annotDict.PbPDF_Object
  Protected *rectArray.PbPDF_Object
  If Not *doc Or Not *page
    ProcedureReturn 0
  EndIf
  *annot = AllocateMemory(SizeOf(PbPDF_Annotation))
  If Not *annot
    ProcedureReturn 0
  EndIf
  InitializeStructure(*annot, PbPDF_Annotation)
  *annotDict = PbPDF_DictNew(#PbPDF_OSUBCLASS_ANNOTATION)
  If Not *annotDict
    FreeMemory(*annot)
    ProcedureReturn 0
  EndIf
  PbPDF_XRefAdd(*doc\xref, *annotDict)
  *annot\dictObj = *annotDict
  *annot\annotType = #PbPDF_ANNOT_HIGHLIGHT
  PbPDF_DictAddName(*annotDict, "Type", "Annot")
  PbPDF_DictAddName(*annotDict, "Subtype", "Highlight")
  *rectArray = PbPDF_ArrayNew()
  PbPDF_ArrayAddReal(*rectArray, x)
  PbPDF_ArrayAddReal(*rectArray, y)
  PbPDF_ArrayAddReal(*rectArray, x + width)
  PbPDF_ArrayAddReal(*rectArray, y + height)
  PbPDF_DictAdd(*annotDict, "Rect", *rectArray)
  If title$ <> ""
    *annot\title = title$
    PbPDF_DictAddString(*annotDict, "T", title$)
  EndIf
  If contents$ <> ""
    *annot\contents = contents$
    PbPDF_DictAddString(*annotDict, "Contents", contents$)
  EndIf
  ; 设置高亮颜色
  *annot\color\r = r
  *annot\color\g = g
  *annot\color\b = b
  Protected *colorArray.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_ArrayAddReal(*colorArray, r)
  PbPDF_ArrayAddReal(*colorArray, g)
  PbPDF_ArrayAddReal(*colorArray, b)
  PbPDF_DictAdd(*annotDict, "C", *colorArray)
  ; QuadPoints(高亮区域四角坐标)
  Protected *quadArray.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_ArrayAddReal(*quadArray, x)
  PbPDF_ArrayAddReal(*quadArray, y + height)
  PbPDF_ArrayAddReal(*quadArray, x + width)
  PbPDF_ArrayAddReal(*quadArray, y + height)
  PbPDF_ArrayAddReal(*quadArray, x)
  PbPDF_ArrayAddReal(*quadArray, y)
  PbPDF_ArrayAddReal(*quadArray, x + width)
  PbPDF_ArrayAddReal(*quadArray, y)
  PbPDF_DictAdd(*annotDict, "QuadPoints", *quadArray)
  ; 将注释添加到页面
  Protected *pageAttr.PbPDF_PageAttr = *page\attr
  If *pageAttr
    Protected *annots.PbPDF_Object = PbPDF_DictGetValue(*page, "Annots")
    If Not *annots
      *annots = PbPDF_ArrayNew()
      PbPDF_DictAdd(*page, "Annots", *annots)
    EndIf
    PbPDF_ArrayAdd(*annots, *annotDict)
  EndIf
  ProcedureReturn *annot
EndProcedure

;--- 设置注释边框 ---
; borderStyle: 边框样式(#PbPDF_BORDER_xxx)
; width: 边框宽度
; dashOn, dashOff: 虚线参数(仅虚线样式有效)
Procedure PbPDF_SetAnnotBorder(*annot.PbPDF_Annotation, borderStyle.i, borderWidth.f, dashOn.f, dashOff.f)
  Protected *borderArray.PbPDF_Object
  If Not *annot Or Not *annot\dictObj
    ProcedureReturn
  EndIf
  *borderArray = PbPDF_ArrayNew()
  PbPDF_ArrayAddNumber(*borderArray, 0)
  PbPDF_ArrayAddNumber(*borderArray, 0)
  PbPDF_ArrayAddReal(*borderArray, borderWidth)
  ; 如果是虚线样式，添加虚线数组
  If borderStyle = #PbPDF_BORDER_DASHED And dashOn > 0
    Protected *dashArray.PbPDF_Object = PbPDF_ArrayNew()
    PbPDF_ArrayAddReal(*dashArray, dashOn)
    PbPDF_ArrayAddReal(*dashArray, dashOff)
    PbPDF_DictAdd(*annot\dictObj, "D", *dashArray)
  EndIf
  PbPDF_DictAdd(*annot\dictObj, "Border", *borderArray)
  *annot\borderStyle\width = borderWidth
EndProcedure

;=============================================================================
; 第22部分：扩展图形状态(ExtGState - 透明度/混合模式)
;=============================================================================

;--- 创建扩展图形状态对象 ---
; fillAlpha: 填充透明度(0.0完全透明~1.0完全不透明)
; strokeAlpha: 描边透明度(0.0完全透明~1.0完全不透明)
; blendMode: 混合模式(#PbPDF_BLEND_xxx)
; 返回图形状态对象指针
Procedure.i PbPDF_GStateNewEx(*doc.PbPDF_Doc, fillAlpha.f, strokeAlpha.f, blendMode.i)
  Protected *gstate.PbPDF_GState
  Protected *gstateDict.PbPDF_Object
  Protected *extGStateDict.PbPDF_Object
  If Not *doc
    ProcedureReturn 0
  EndIf
  ; 分配图形状态对象
  *gstate = AllocateMemory(SizeOf(PbPDF_GState))
  If Not *gstate
    ProcedureReturn 0
  EndIf
  InitializeStructure(*gstate, PbPDF_GState)
  ; 创建ExtGState字典
  *gstateDict = PbPDF_DictNew()
  If Not *gstateDict
    FreeMemory(*gstate)
    ProcedureReturn 0
  EndIf
  PbPDF_XRefAdd(*doc\xref, *gstateDict)
  PbPDF_DictAddName(*gstateDict, "Type", "ExtGState")
  ; 设置填充透明度
  If fillAlpha >= 0 And fillAlpha <= 1.0
    PbPDF_DictAddReal(*gstateDict, "ca", fillAlpha)
    *gstate\fillAlpha = fillAlpha
  EndIf
  ; 设置描边透明度
  If strokeAlpha >= 0 And strokeAlpha <= 1.0
    PbPDF_DictAddReal(*gstateDict, "CA", strokeAlpha)
    *gstate\strokeAlpha = strokeAlpha
  EndIf
  ; 设置混合模式
  If blendMode <> #PbPDF_BLEND_NORMAL
    Protected blendName$
    Select blendMode
      Case #PbPDF_BLEND_MULTIPLY:   blendName$ = "Multiply"
      Case #PbPDF_BLEND_SCREEN:     blendName$ = "Screen"
      Case #PbPDF_BLEND_OVERLAY:    blendName$ = "Overlay"
      Case #PbPDF_BLEND_DARKEN:     blendName$ = "Darken"
      Case #PbPDF_BLEND_LIGHTEN:    blendName$ = "Lighten"
      Case #PbPDF_BLEND_COLOR_DODGE:blendName$ = "ColorDodge"
      Case #PbPDF_BLEND_COLOR_BURN: blendName$ = "ColorBurn"
      Case #PbPDF_BLEND_HARD_LIGHT: blendName$ = "HardLight"
      Case #PbPDF_BLEND_SOFT_LIGHT: blendName$ = "SoftLight"
      Case #PbPDF_BLEND_DIFFERENCE: blendName$ = "Difference"
      Case #PbPDF_BLEND_EXCLUSION:  blendName$ = "Exclusion"
      Default:                       blendName$ = "Normal"
    EndSelect
    PbPDF_DictAddName(*gstateDict, "BM", blendName$)
    *gstate\blendMode = blendMode
  EndIf
  *gstate\dictObj = *gstateDict
  ProcedureReturn *gstate
EndProcedure

;--- 在页面上应用扩展图形状态 ---
; 将ExtGState对象应用到页面内容流
; 注意：此函数必须在PbPDF_PageGetContentStream可用之后调用
; 如果在内容流创建前调用，仅注册资源，不写入内容流
Procedure PbPDF_Page_SetExtGState(*doc.PbPDF_Doc, *page.PbPDF_Object, *gstate.PbPDF_GState)
  Protected *pageAttr.PbPDF_PageAttr
  Protected gstateName$
  If Not *doc Or Not *page Or Not *gstate
    ProcedureReturn
  EndIf
  *pageAttr = *page\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  ; 确保页面有ExtGState资源字典
  If *pageAttr\extGStates = 0
    *pageAttr\extGStates = PbPDF_DictNew()
    Protected *resources.PbPDF_Object = PbPDF_DictGetValue(*page, "Resources")
    If Not *resources
      *resources = PbPDF_DictNew()
      PbPDF_DictAdd(*page, "Resources", *resources)
    EndIf
    PbPDF_DictAdd(*resources, "ExtGState", *pageAttr\extGStates)
  EndIf
  ; 生成唯一名称
  gstateName$ = "GS" + Str(*doc\ttfontTagCounter)
  *doc\ttfontTagCounter + 1
  ; 注册到页面资源
  PbPDF_DictAdd(*pageAttr\extGStates, gstateName$, *gstate\dictObj)
  ; 写入内容流(如果内容流已创建)
  If *pageAttr\contentStream
    PbPDF_StreamWriteStr(*pageAttr\contentStream, "/" + gstateName$ + " gs" + #LF$)
  EndIf
EndProcedure

;=============================================================================
; 第23部分：水印(Watermark)
;=============================================================================

;--- 创建文本水印 ---
; 在文档的所有页面上添加文本水印
; text$: 水印文本内容
; fontSize: 字体大小
; rotation: 旋转角度(度数，通常为45)
; opacity: 透明度(0.0~1.0)
; r, g, b: 水印颜色(RGB, 0.0~1.0)
; diagonal: 对角线方向(0=无,1=左下到右上,2=左上到右下)
; fontName$: 使用的字体本地名称(默认为Helvetica-Bold)
Procedure PbPDF_AddTextWatermark(*doc.PbPDF_Doc, text$, fontSize.f, rotation.f, opacity.f, r.f, g.f, b.f, diagonal.i, fontName$ = "F1")
  Protected i.i
  Protected *page.PbPDF_Object
  Protected *pageAttr.PbPDF_PageAttr
  Protected *contentStream.PbPDF_Stream
  Protected pageWidth.f, pageHeight.f
  Protected rad.f, cosA.f, sinA.f
  Protected tx.f, ty.f
  If Not *doc Or text$ = ""
    ProcedureReturn
  EndIf
  ; 遍历所有页面添加水印
  For i = 0 To *doc\pageCount - 1
    *page = PbPDF_ListGetPointer(*doc\pageList, i)
    If Not *page
      Continue
    EndIf
    *pageAttr = *page\attr
    If Not *pageAttr
      Continue
    EndIf
    pageWidth = PbPDF_Page_GetWidth(*page)
    pageHeight = PbPDF_Page_GetHeight(*page)
    ; 计算水印位置(页面中心)
    tx = pageWidth / 2
    ty = pageHeight / 2
    ; 计算旋转角度
    If diagonal = 1
      rad = 45 * 3.14159265 / 180
    ElseIf diagonal = 2
      rad = -45 * 3.14159265 / 180
    Else
      rad = rotation * 3.14159265 / 180
    EndIf
    cosA = Cos(rad)
    sinA = Sin(rad)
    ; 获取内容流(直接从页面属性获取)
    *contentStream = *pageAttr\contentStream
    If Not *contentStream
      Continue
    EndIf
    ; 保存图形状态
    PbPDF_StreamWriteStr(*contentStream, "q" + #LF$)
    ; 设置透明度(如果支持)
    If opacity < 1.0
      ; 创建并应用ExtGState
      Protected *gstate.PbPDF_GState = PbPDF_GStateNewEx(*doc, opacity, opacity, #PbPDF_BLEND_NORMAL)
      If *gstate
        PbPDF_Page_SetExtGState(*doc, *page, *gstate)
      EndIf
    EndIf
    ; 设置颜色
    PbPDF_StreamWriteStr(*contentStream, StrF(r, 4) + " " + StrF(g, 4) + " " + StrF(b, 4) + " rg" + #LF$)
    ; 变换矩阵：平移到中心，旋转，再偏移使文本居中
    ; 文本宽度估算(粗略)
    Protected textWidth.f = fontSize * Len(text$) * 0.5
    Protected textHeight.f = fontSize
    ; 变换矩阵: a=cos, b=sin, c=-sin, d=cos, e=tx-textWidth/2*cos+textHeight/2*sin, f=ty-textWidth/2*sin-textHeight/2*cos
    Protected e.f = tx - (textWidth / 2) * cosA + (textHeight / 2) * sinA
    Protected f.f = ty - (textWidth / 2) * sinA - (textHeight / 2) * cosA
    PbPDF_StreamWriteStr(*contentStream, StrF(cosA, 6) + " " + StrF(sinA, 6) + " " + StrF(-sinA, 6) + " " + StrF(cosA, 6) + " " + StrF(e, 4) + " " + StrF(f, 4) + " cm" + #LF$)
    ; 设置字体
    PbPDF_StreamWriteStr(*contentStream, "BT" + #LF$)
    PbPDF_StreamWriteStr(*contentStream, "/" + fontName$ + " " + StrF(fontSize, 2) + " Tf" + #LF$)
    ; 写入文本(使用简单十六进制编码)
    Protected j.i
    Protected hexStr$ = ""
    Protected textBytes.i = StringByteLength(text$, #PB_UTF8)
    Protected *textBuf = AllocateMemory(textBytes + 1)
    PokeS(*textBuf, text$, textBytes, #PB_UTF8)
    For j = 0 To textBytes - 1
      hexStr$ + RSet(Hex(PeekA(*textBuf + j)), 2, "0")
    Next
    FreeMemory(*textBuf)
    PbPDF_StreamWriteStr(*contentStream, "<" + hexStr$ + "> Tj" + #LF$)
    PbPDF_StreamWriteStr(*contentStream, "ET" + #LF$)
    ; 恢复图形状态
    PbPDF_StreamWriteStr(*contentStream, "Q" + #LF$)
  Next
EndProcedure

;=============================================================================
; 第24部分：加密高级API
;=============================================================================

;--- 设置文档加密 ---
; 为PDF文档设置用户密码和所有者密码
; userPwd$: 用户密码(打开文档需要输入的密码，空字符串表示无密码)
; ownerPwd$: 所有者密码(更改权限需要输入的密码)
; permission: 权限标志(多个权限用|组合，如 #PbPDF_ENABLE_PRINT|#PbPDF_ENABLE_COPY)
; encryptionMode: 加密模式(#PbPDF_ENCRYPT_RC4_40 或 #PbPDF_ENCRYPT_RC4_128)
Procedure PbPDF_SetPassword(*doc.PbPDF_Doc, userPwd$, ownerPwd$, permission.i, encryptionMode.i)
  Protected *encrypt.PbPDF_Encrypt
  Protected *encryptDict.PbPDF_Object
  Protected *idArray.PbPDF_Object
  Protected *id1.PbPDF_Object
  Protected *id2.PbPDF_Object
  Protected i.i
  Protected *md5Buf
  Dim md5Result.a(15)
  Protected keyLen.i
  Protected permValue.i
  If Not *doc
    ProcedureReturn
  EndIf
  ; 分配加密对象
  *encrypt = AllocateMemory(SizeOf(PbPDF_Encrypt))
  If Not *encrypt
    ProcedureReturn
  EndIf
  InitializeStructure(*encrypt, PbPDF_Encrypt)
  ; 设置加密模式
  If encryptionMode = #PbPDF_ENCRYPT_RC4_128
    *encrypt\keyLength = 16
    *encrypt\revision = 3
    keyLen = 16
  Else
    *encrypt\keyLength = 5
    *encrypt\revision = 2
    keyLen = 5
  EndIf
  *encrypt\mode = encryptionMode
  *encrypt\permission = permission
  ; 修正权限值(PDF规范: Revision 3的bits 7-8和bits 13-32必须为1)
  Protected permForCalc.i = permission
  If encryptionMode = #PbPDF_ENCRYPT_RC4_128
    permForCalc = permission | $FFFFF0C0
  EndIf
  ; 生成文档ID(32字节随机数)
  Protected *id1Buf = AllocateMemory(16)
  Protected *id2Buf = AllocateMemory(16)
  PbPDF_GenRandomBytes(*id1Buf, 16)
  PbPDF_GenRandomBytes(*id2Buf, 16)
  *id1 = PbPDF_BinaryNew(*id1Buf, 16)
  *id2 = PbPDF_BinaryNew(*id2Buf, 16)
  ; 将文档ID保存到加密对象
  For i = 0 To 15
    *encrypt\encryptID[i] = PeekA(*id1Buf + i)
  Next
  ; 计算加密密钥
  ; 算法步骤:
  ; 1. 将所有者密码填充到32字节(不足用0x28填充)
  Dim ownerPad.a(31)
  Dim userPad.a(31)
  ; 填充密码(使用标准填充序列)
  Dim pad.a(31)
  For i = 0 To 31
    pad(i) = PeekA(?PbPDF_EncryptPadding + i)
  Next
  ; 处理所有者密码
  If ownerPwd$ = ""
    ownerPwd$ = userPwd$
  EndIf
  Protected ownerBytes.i = StringByteLength(ownerPwd$, #PB_UTF8)
  If ownerBytes > 32 : ownerBytes = 32 : EndIf
  Protected *ownerUtf8 = AllocateMemory(ownerBytes + 1)
  PokeS(*ownerUtf8, ownerPwd$, -1, #PB_UTF8)
  For i = 0 To 31
    If i < ownerBytes
      ownerPad(i) = PeekA(*ownerUtf8 + i)
    Else
      ownerPad(i) = pad(i - ownerBytes)
    EndIf
  Next
  ; 处理用户密码
  Protected userBytes.i = StringByteLength(userPwd$, #PB_UTF8)
  If userBytes > 32 : userBytes = 32 : EndIf
  Protected *userUtf8 = AllocateMemory(userBytes + 1)
  PokeS(*userUtf8, userPwd$, -1, #PB_UTF8)
  For i = 0 To 31
    If i < userBytes
      userPad(i) = PeekA(*userUtf8 + i)
    Else
      userPad(i) = pad(i - userBytes)
    EndIf
  Next
  ; 释放UTF-8临时缓冲区
  FreeMemory(*ownerUtf8)
  FreeMemory(*userUtf8)
  ; 2. MD5(所有者密码填充) -> 所有者密钥
  *md5Buf = AllocateMemory(64)
  CopyMemory(@ownerPad(0), *md5Buf, 32)
  PbPDF_MD5(*md5Buf, 32, @md5Result(0))
  ; RC4-128需要多次MD5
  If encryptionMode = #PbPDF_ENCRYPT_RC4_128
    For i = 1 To 50
      CopyMemory(@md5Result(0), *md5Buf, 16)
      PbPDF_MD5(*md5Buf, 16, @md5Result(0))
    Next
  EndIf
  ; 所有者密钥（取前keyLen字节作为RC4密钥）
  Dim ownerKey.a(15)
  CopyMemory(@md5Result(0), @ownerKey(0), keyLen)
  ; O值 = RC4(owner_key, user_pad)
  ; PDF规范：用所有者密钥对用户密码填充进行RC4加密
  Dim oValue.a(31)
  CopyMemory(@userPad(0), @oValue(0), 32)
  Protected rc4Owner.PbPDF_Encrypt
  PbPDF_RC4Init(@rc4Owner, @ownerKey(0), keyLen)
  PbPDF_RC4Crypt(@rc4Owner, @oValue(0), @oValue(0), 32)
  ; RC4-128需要19轮额外RC4加密
  If encryptionMode = #PbPDF_ENCRYPT_RC4_128
    Dim roundKeyO.a(15)
    For i = 1 To 19
      Protected j2.i
      For j2 = 0 To keyLen - 1
        roundKeyO(j2) = ownerKey(j2) ! i
      Next
      PbPDF_RC4Init(@rc4Owner, @roundKeyO(0), keyLen)
      PbPDF_RC4Crypt(@rc4Owner, @oValue(0), @oValue(0), 32)
    Next
  EndIf
  ; 3. 计算加密密钥: MD5( 用户密码填充 + O值 + 权限 + 文档ID )
  Protected *keyBuf = AllocateMemory(32 + 32 + 4 + 16)
  Protected offset.i = 0
  CopyMemory(@userPad(0), *keyBuf + offset, 32) : offset + 32
  CopyMemory(@oValue(0), *keyBuf + offset, 32) : offset + 32
  ; 权限(Little-endian 32位, 使用修正后的权限值)
  PokeL(*keyBuf + offset, permForCalc) : offset + 4
  CopyMemory(*id1Buf, *keyBuf + offset, 16) : offset + 16
  PbPDF_MD5(*keyBuf, offset, @md5Result(0))
  If encryptionMode = #PbPDF_ENCRYPT_RC4_128
    For i = 1 To 50
      CopyMemory(@md5Result(0), *md5Buf, 16)
      PbPDF_MD5(*md5Buf, 16, @md5Result(0))
    Next
  EndIf
  ; 保存加密密钥
  CopyMemory(@md5Result(0), @*encrypt\encryptionKey[0], keyLen)
  ; 4. 计算用户密码U值(用于验证)
  ; PDF规范: RC4-40使用Algorithm 4, RC4-128使用Algorithm 5
  Dim uValueData.a(31)
  If encryptionMode = #PbPDF_ENCRYPT_RC4_40
    ; Algorithm 4(Revision 2): U = RC4(加密密钥, 32字节填充字符串)
    ; 直接对32字节标准填充序列做RC4加密, 结果即为U值(32字节)
    CopyMemory(@pad(0), @uValueData(0), 32)
    PbPDF_RC4Init(*encrypt, @*encrypt\encryptionKey[0], keyLen)
    PbPDF_RC4Crypt(*encrypt, @uValueData(0), @uValueData(0), 32)
  Else
    ; Algorithm 5(Revision 3): MD5(填充+文档ID) → RC4加密 → 19轮RC4 → 16字节 + 16字节填充
    CopyMemory(@pad(0), *md5Buf, 32)
    CopyMemory(*id1Buf, *md5Buf + 32, 16)
    PbPDF_MD5(*md5Buf, 48, @md5Result(0))
    ; 第一轮RC4加密
    CopyMemory(@md5Result(0), @uValueData(0), 16)
    PbPDF_RC4Init(*encrypt, @*encrypt\encryptionKey[0], keyLen)
    PbPDF_RC4Crypt(*encrypt, @uValueData(0), @uValueData(0), 16)
    ; 19轮额外RC4加密(每轮密钥与轮次XOR)
    Dim roundKey.a(15)
    For i = 1 To 19
      Protected j.i
      For j = 0 To keyLen - 1
        roundKey(j) = *encrypt\encryptionKey[j] ! i
      Next
      PbPDF_RC4Init(*encrypt, @roundKey(0), keyLen)
      PbPDF_RC4Crypt(*encrypt, @uValueData(0), @uValueData(0), 16)
    Next
    ; 后16字节为任意填充字节
    CopyMemory(@pad(0), @uValueData(16), 16)
  EndIf
  FreeMemory(*md5Buf)
  FreeMemory(*keyBuf)
  ; 创建加密字典
  *encryptDict = PbPDF_DictNew()
  If *encryptDict
    PbPDF_XRefAdd(*doc\xref, *encryptDict)
    PbPDF_DictAddName(*encryptDict, "Type", "Encrypt")
    If encryptionMode = #PbPDF_ENCRYPT_RC4_40
      PbPDF_DictAddName(*encryptDict, "Filter", "Standard")
      PbPDF_DictAddNumber(*encryptDict, "V", 1)
      PbPDF_DictAddNumber(*encryptDict, "R", 2)
      PbPDF_DictAddNumber(*encryptDict, "Length", 40)
    Else
      PbPDF_DictAddName(*encryptDict, "Filter", "Standard")
      PbPDF_DictAddNumber(*encryptDict, "V", 2)
      PbPDF_DictAddNumber(*encryptDict, "R", 3)
      PbPDF_DictAddNumber(*encryptDict, "Length", 128)
    EndIf
    ; 所有者密码哈希(O值=RC4加密后的用户密码填充)
    Protected *oValueBuf = AllocateMemory(32)
    CopyMemory(@oValue(0), *oValueBuf, 32)
    Protected *oValueObj.PbPDF_Object = PbPDF_BinaryNew(*oValueBuf, 32)
    PbPDF_DictAdd(*encryptDict, "O", *oValueObj)
    ; 用户密码哈希(U值)
    ; RC4-40: U值=32字节RC4加密的填充字符串(Algorithm 4)
    ; RC4-128: U值=16字节加密哈希+16字节任意填充(Algorithm 5)
    Protected *uValueBuf = AllocateMemory(32)
    CopyMemory(@uValueData(0), *uValueBuf, 32)
    Protected *uValue.PbPDF_Object = PbPDF_BinaryNew(*uValueBuf, 32)
    PbPDF_DictAdd(*encryptDict, "U", *uValue)
    ; 权限(使用修正后的权限值, Revision 3必须设置保留位)
    PbPDF_DictAddNumber(*encryptDict, "P", permForCalc)
  EndIf
  ; 保存到文档对象
  *doc\encrypt = *encrypt
  *doc\encryptDictObj = *encryptDict
  *doc\encryptOn = #True
  ; 将文档ID添加到Trailer
  *idArray = PbPDF_ArrayNew()
  PbPDF_ArrayAdd(*idArray, *id1)
  PbPDF_ArrayAdd(*idArray, *id2)
  PbPDF_DictAdd(*doc\trailerObj, "ID", *idArray)
  ; 将加密字典添加到Trailer
  PbPDF_DictAdd(*doc\trailerObj, "Encrypt", *encryptDict)
  ; 更新Trailer Size
  PbPDF_DictAddNumber(*doc\trailerObj, "Size", PbPDF_XRefGetCount(*doc\xref))
EndProcedure

;--- 加密填充序列(PDF标准定义) ---
DataSection
  PbPDF_EncryptPadding:
  Data.a $28, $BF, $4E, $5E, $4E, $75, $8A, $41, $64, $00, $4E, $56, $FF, $FA, $01, $08
  Data.a $2E, $2E, $00, $B6, $D0, $68, $3E, $80, $2F, $0C, $A9, $FE, $64, $53, $69, $7A
EndDataSection

;=============================================================================
; 第18部分：TTF字体解析
;=============================================================================

;--- TTF偏移表(Offset Table) ---
Structure PbPDF_TTFOffsetTbl
  sfVersion.l      ; 0x00010000或'TRUE'
  numTables.w      ; 表数量
  searchRange.w    ; 二分搜索范围
  entrySelector.w  ; 二分搜索选择器
  rangeShift.w     ; 范围偏移
EndStructure

;--- TTF表目录条目 ---
Structure PbPDF_TTFTableDirEntry
  tag.l            ; 4字节标签
  checksum.l       ; 校验和
  offset.l         ; 偏移量
  length.l         ; 长度
EndStructure

;--- TTF字体头(head表) ---
Structure PbPDF_TTFHeader
  version.l        ; 版本号
  fontRevision.l   ; 字体修订号
  checksumAdj.l    ; 校验和调整
  magicNumber.l    ; 魔术数 0x5F0F3CF5
  flags.w          ; 标志
  unitsPerEm.w     ; 每em单位数
  created.q[2]     ; 创建日期
  modified.q[2]    ; 修改日期
  xMin.w           ; x最小值
  yMin.w           ; y最小值
  xMax.w           ; x最大值
  yMax.w           ; y最大值
  macStyle.w       ; Mac样式
  lowestRecPPEM.w  ; 最低推荐PPEM
  fontDirectionHint.w ; 字体方向提示
  indexToLocFormat.w  ; 索引到位置格式(0=短,1=长)
  glyphDataFormat.w   ; 字形数据格式
EndStructure

;--- TTF水平度量条目 ---
Structure PbPDF_TTFHorMetric
  advanceWidth.w   ; 前进宽度
  lsb.w            ; 左侧边界
EndStructure

;--- TTF CMap范围条目 ---
Structure PbPDF_TTFCmapRange
  startCode.i            ; 起始字符码
  endCode.i              ; 结束字符码
  idDelta.i              ; ID增量
  idRangeOffset.i        ; ID范围偏移
  idRangeOffsetEntryOff.i; idRangeOffset[i]在字体数据缓冲区中的绝对偏移(用于Format 4查找)
EndStructure

;--- TTF字体属性(扩展) ---
Structure PbPDF_TTFontAttr
  baseFont.s[128]       ; 字体名
  header.PbPDF_TTFHeader; 字体头信息
  numGlyphs.w           ; 字形数量
  numHMetric.w          ; 水平度量数量
  offsetTbl.PbPDF_TTFOffsetTbl; 偏移表
  *hMetric              ; 水平度量表(PbPDF_TTFHorMetric数组)
  *cmapRanges.PbPDF_List; CMap范围列表(PbPDF_TTFCmapRange指针)
  cmapFormat.i          ; CMap格式(0或4)
  cmapSegCount.i        ; CMap段数
  embedding.i           ; 是否嵌入
  isCIDFont.i           ; 是否CID字体
  *fontDataBuf          ; 原始字体数据缓冲区
  fontDataSize.i        ; 原始字体数据大小
  *usedGIDs.PbPDF_List  ; 已使用的字形ID集合(用于子集化)
  *locaTable            ; loca表数据
  locaFormat.i          ; loca格式(0=短,1=长)
  *glyfTable            ; glyf表数据
  glyfTableSize.i       ; glyf表大小
  headTableOffset.i     ; head表偏移
  os2Ascent.w           ; OS/2上升高度
  os2Descent.w          ; OS/2下降深度
  os2CapHeight.w        ; OS/2大写高度
  os2XHeight.w          ; OS/2 x高度
  os2WeightClass.w      ; OS/2字重类
  os2WidthClass.w       ; OS/2宽度类
  os2Flags.i            ; OS/2标志
  os2ItalicAngle.w      ; 斜体角度(从post表)
  os2StemV.w            ; 垂直主干宽度
  numCmapRanges.i       ; CMap范围数量
EndStructure

;--- 从TTF数据中读取大端16位整数 ---
Procedure.i PbPDF_TTFReadU16(*buf, offset.i)
  ProcedureReturn ((PeekA(*buf + offset) & $FF) << 8) | (PeekA(*buf + offset + 1) & $FF)
EndProcedure

;--- 从TTF数据中读取大端32位整数 ---
Procedure.i PbPDF_TTFReadU32(*buf, offset.i)
  ProcedureReturn ((PeekA(*buf + offset) & $FF) << 24) | ((PeekA(*buf + offset + 1) & $FF) << 16) | ((PeekA(*buf + offset + 2) & $FF) << 8) | (PeekA(*buf + offset + 3) & $FF)
EndProcedure

;--- 从TTF数据中读取大端16位有符号整数 ---
Procedure.i PbPDF_TTFReadS16(*buf, offset.i)
  Protected v.i = PbPDF_TTFReadU16(*buf, offset)
  If v & $8000
    v - $10000
  EndIf
  ProcedureReturn v
EndProcedure

;--- 向TTF数据中写入大端16位整数 ---
Procedure PbPDF_TTFWriteU16(*buf, offset.i, value.i)
  PokeA(*buf + offset, (value >> 8) & $FF)
  PokeA(*buf + offset + 1, value & $FF)
EndProcedure

;--- 向TTF数据中写入大端32位整数 ---
Procedure PbPDF_TTFWriteU32(*buf, offset.i, value.i)
  PokeA(*buf + offset, (value >> 24) & $FF)
  PokeA(*buf + offset + 1, (value >> 16) & $FF)
  PokeA(*buf + offset + 2, (value >> 8) & $FF)
  PokeA(*buf + offset + 3, value & $FF)
EndProcedure

;--- 查找TTF表偏移 ---
Procedure.i PbPDF_TTFFindTable(*buf, tableName$, numTables.i)
  Protected i.i, tag$
  For i = 0 To numTables - 1
    Protected entryOffset.i = 12 + i * 16
    tag$ = ""
    tag$ + Chr(PeekA(*buf + entryOffset))
    tag$ + Chr(PeekA(*buf + entryOffset + 1))
    tag$ + Chr(PeekA(*buf + entryOffset + 2))
    tag$ + Chr(PeekA(*buf + entryOffset + 3))
    If tag$ = tableName$
      ProcedureReturn PbPDF_TTFReadU32(*buf, entryOffset + 8)
    EndIf
  Next
  ProcedureReturn -1
EndProcedure

;--- 解析TTF字体文件 ---
Procedure.i PbPDF_TTFontLoad(*fontDef.PbPDF_FontDef, *buf, bufSize.i, embedding.i = #True)
  If Not *buf Or bufSize < 12
    ProcedureReturn #PbPDF_ERR_INVALID_FONT
  EndIf
  ; 分配TTF属性结构
  Protected *attr.PbPDF_TTFontAttr = AllocateMemory(SizeOf(PbPDF_TTFontAttr))
  If Not *attr
    ProcedureReturn #PbPDF_ERR_MEM_ALLOC
  EndIf
  InitializeStructure(*attr, PbPDF_TTFontAttr)
  *fontDef\attr = *attr
  *attr\embedding = embedding
  ; 保存原始字体数据
  *attr\fontDataBuf = AllocateMemory(bufSize)
  If *attr\fontDataBuf
    CopyMemory(*buf, *attr\fontDataBuf, bufSize)
    *attr\fontDataSize = bufSize
  EndIf
  ; 解析偏移表
  *attr\offsetTbl\sfVersion = PbPDF_TTFReadU32(*buf, 0)
  *attr\offsetTbl\numTables = PbPDF_TTFReadU16(*buf, 4)
  *attr\offsetTbl\searchRange = PbPDF_TTFReadU16(*buf, 6)
  *attr\offsetTbl\entrySelector = PbPDF_TTFReadU16(*buf, 8)
  *attr\offsetTbl\rangeShift = PbPDF_TTFReadU16(*buf, 10)
  ; 检查是否为有效的TTF文件
  If *attr\offsetTbl\sfVersion <> $00010000 And *attr\offsetTbl\sfVersion <> $74727565
    ProcedureReturn #PbPDF_ERR_INVALID_FONT
  EndIf
  ; 解析head表
  Protected headOffset.i = PbPDF_TTFFindTable(*buf, "head", *attr\offsetTbl\numTables)
  If headOffset < 0
    ProcedureReturn #PbPDF_ERR_INVALID_FONT
  EndIf
  *attr\header\version = PbPDF_TTFReadU32(*buf, headOffset)
  *attr\header\flags = PbPDF_TTFReadU16(*buf, headOffset + 16)
  *attr\header\unitsPerEm = PbPDF_TTFReadU16(*buf, headOffset + 18)
  *attr\header\xMin = PbPDF_TTFReadS16(*buf, headOffset + 36)
  *attr\header\yMin = PbPDF_TTFReadS16(*buf, headOffset + 38)
  *attr\header\xMax = PbPDF_TTFReadS16(*buf, headOffset + 40)
  *attr\header\yMax = PbPDF_TTFReadS16(*buf, headOffset + 42)
  *attr\header\indexToLocFormat = PbPDF_TTFReadS16(*buf, headOffset + 50)
  *attr\locaFormat = *attr\header\indexToLocFormat
  ; 解析maxp表
  Protected maxpOffset.i = PbPDF_TTFFindTable(*buf, "maxp", *attr\offsetTbl\numTables)
  If maxpOffset < 0
    ProcedureReturn #PbPDF_ERR_INVALID_FONT
  EndIf
  *attr\numGlyphs = PbPDF_TTFReadU16(*buf, maxpOffset + 4)
  ; 解析hhea表
  Protected hheaOffset.i = PbPDF_TTFFindTable(*buf, "hhea", *attr\offsetTbl\numTables)
  If hheaOffset < 0
    ProcedureReturn #PbPDF_ERR_INVALID_FONT
  EndIf
  *attr\numHMetric = PbPDF_TTFReadU16(*buf, hheaOffset + 34)
  ; 解析OS/2表
  Protected os2Offset.i = PbPDF_TTFFindTable(*buf, "OS/2", *attr\offsetTbl\numTables)
  If os2Offset >= 0
    *attr\os2WeightClass = PbPDF_TTFReadU16(*buf, os2Offset + 4)
    *attr\os2WidthClass = PbPDF_TTFReadU16(*buf, os2Offset + 6)
    *attr\os2Flags = PbPDF_TTFReadU16(*buf, os2Offset + 8)
    *attr\os2Ascent = PbPDF_TTFReadS16(*buf, os2Offset + 68)
    *attr\os2Descent = PbPDF_TTFReadS16(*buf, os2Offset + 70)
    *attr\os2CapHeight = PbPDF_TTFReadS16(*buf, os2Offset + 88)
    *attr\os2XHeight = PbPDF_TTFReadS16(*buf, os2Offset + 90)
    *fontDef\ascent = *attr\os2Ascent
    *fontDef\descent = *attr\os2Descent
    *fontDef\capHeight = *attr\os2CapHeight
    *fontDef\xHeight = *attr\os2XHeight
    *fontDef\flags = *attr\os2Flags
  EndIf
  ; 解析post表(获取斜体角度)
  Protected postOffset.i = PbPDF_TTFFindTable(*buf, "post", *attr\offsetTbl\numTables)
  If postOffset >= 0
    Protected postVersion.l = PbPDF_TTFReadU32(*buf, postOffset)
    If postVersion = $00030000 Or postVersion = $00020000
      *fontDef\italicAngle = PbPDF_TTFReadS16(*buf, postOffset + 12)
    EndIf
  EndIf
  ; 解析name表(获取字体名)
  Protected nameOffset.i = PbPDF_TTFFindTable(*buf, "name", *attr\offsetTbl\numTables)
  If nameOffset >= 0
    Protected nameCount.i = PbPDF_TTFReadU16(*buf, nameOffset + 2)
    Protected stringOffset.i = PbPDF_TTFReadU16(*buf, nameOffset + 4)
    Protected ni.i
    For ni = 0 To nameCount - 1
      Protected recOffset.i = nameOffset + 6 + ni * 12
      Protected nameID.i = PbPDF_TTFReadU16(*buf, recOffset + 6)
      ; nameID=6是PostScript名称
      If nameID = 6
        Protected platformID.i = PbPDF_TTFReadU16(*buf, recOffset)
        Protected length.i = PbPDF_TTFReadU16(*buf, recOffset + 8)
        Protected offset2.i = PbPDF_TTFReadU16(*buf, recOffset + 10)
        Protected *namePtr = *buf + nameOffset + stringOffset + offset2
        Protected fontName$ = ""
        If platformID = 1 Or platformID = 3
          ; Mac或Windows平台
          Protected ci.i
          For ci = 0 To length - 2 Step 2
            Protected ch.w = PbPDF_TTFReadU16(*namePtr, ci)
            If ch > 0 And ch < 128
              fontName$ + Chr(ch)
            ElseIf ch >= 128
              fontName$ + "_"
            EndIf
          Next
          If fontName$ <> ""
            *fontDef\baseFont = fontName$
          EndIf
        EndIf
        Break
      EndIf
    Next
  EndIf
  ; 解析hmtx表(水平度量)
  Protected hmtxOffset.i = PbPDF_TTFFindTable(*buf, "hmtx", *attr\offsetTbl\numTables)
  If hmtxOffset >= 0
    Protected hmtxSize.i = *attr\numHMetric * SizeOf(PbPDF_TTFHorMetric)
    *attr\hMetric = AllocateMemory(*attr\numHMetric * 4)
    If *attr\hMetric
      Protected hi.i
      For hi = 0 To *attr\numHMetric - 1
        Protected mOffset.i = hmtxOffset + hi * 4
        PokeW(*attr\hMetric + hi * 4, PbPDF_TTFReadU16(*buf, mOffset))
        PokeW(*attr\hMetric + hi * 4 + 2, PbPDF_TTFReadS16(*buf, mOffset + 2))
      Next
    EndIf
  EndIf
  ; 解析cmap表(字符映射)
  Protected cmapOffset.i = PbPDF_TTFFindTable(*buf, "cmap", *attr\offsetTbl\numTables)
  If cmapOffset >= 0
    Protected cmapNumSub.i = PbPDF_TTFReadU16(*buf, cmapOffset + 2)
    *attr\cmapRanges = PbPDF_ListNew(SizeOf(PbPDF_TTFCmapRange), 64)
    ; 查找Format 4子表(Unicode BMP)
    Protected si.i, foundFormat4.i = 0
    For si = 0 To cmapNumSub - 1
      Protected subOffset.i = cmapOffset + 4 + si * 8
      Protected subPlatform.i = PbPDF_TTFReadU16(*buf, subOffset)
      Protected subEncoding.i = PbPDF_TTFReadU16(*buf, subOffset + 2)
      Protected subTableOffset.i = PbPDF_TTFReadU32(*buf, subOffset + 4)
      Protected fmtOffset.i = cmapOffset + subTableOffset
      Protected fmt.i = PbPDF_TTFReadU16(*buf, fmtOffset)
      ; 优先使用Windows Unicode(3,1)的Format 4
      If fmt = 4 And (subPlatform = 3 And subEncoding = 1)
        foundFormat4 = 1
        Protected segCount2.i = PbPDF_TTFReadU16(*buf, fmtOffset + 6)
        Protected segCount.i = segCount2 / 2
        *attr\cmapSegCount = segCount
        *attr\cmapFormat = 4
        ; 读取endCode数组
        Protected endCodeOffset.i = fmtOffset + 14
        Protected startCodeOffset.i = endCodeOffset + segCount2 + 2
        Protected idDeltaOffset.i = startCodeOffset + segCount2
        Protected idRangeOffset.i = idDeltaOffset + segCount2
        Protected segi.i
        For segi = 0 To segCount - 1
          Protected range.PbPDF_TTFCmapRange
          range\endCode = PbPDF_TTFReadU16(*buf, endCodeOffset + segi * 2)
          range\startCode = PbPDF_TTFReadU16(*buf, startCodeOffset + segi * 2)
          range\idDelta = PbPDF_TTFReadS16(*buf, idDeltaOffset + segi * 2)
          range\idRangeOffset = PbPDF_TTFReadU16(*buf, idRangeOffset + segi * 2)
          ; 存储idRangeOffset[i]条目在字体数据缓冲区中的绝对偏移
          ; 用于Format 4中idRangeOffset!=0时查找glyphIdArray
          range\idRangeOffsetEntryOff = idRangeOffset + segi * 2
          ; 跳过真正的终止段(startCode和endCode都是0xFFFF)
          If range\startCode = $FFFF And range\endCode = $FFFF
            Continue
          EndIf
          ; 跳过空段(startCode > endCode)
          If range\startCode > range\endCode
            Continue
          EndIf
          PbPDF_ListAdd(*attr\cmapRanges, @range)
          *attr\numCmapRanges + 1
        Next
        Break
      EndIf
    Next
    ; 如果没有找到Format 4，尝试Mac Roman(1,0)的Format 0
    If Not foundFormat4
      For si = 0 To cmapNumSub - 1
        Protected subOffset2.i = cmapOffset + 4 + si * 8
        Protected fmtOffset2.i = cmapOffset + PbPDF_TTFReadU32(*buf, subOffset2 + 4)
        Protected fmt2.i = PbPDF_TTFReadU16(*buf, fmtOffset2)
        If fmt2 = 0
          *attr\cmapFormat = 0
          Break
        EndIf
      Next
    EndIf
  EndIf
  ; 解析loca表
  Protected locaOffset.i = PbPDF_TTFFindTable(*buf, "loca", *attr\offsetTbl\numTables)
  If locaOffset >= 0
    If *attr\locaFormat = 0
      *attr\locaTable = AllocateMemory((*attr\numGlyphs + 1) * 2)
      If *attr\locaTable
        CopyMemory(*buf + locaOffset, *attr\locaTable, (*attr\numGlyphs + 1) * 2)
      EndIf
    Else
      *attr\locaTable = AllocateMemory((*attr\numGlyphs + 1) * 4)
      If *attr\locaTable
        CopyMemory(*buf + locaOffset, *attr\locaTable, (*attr\numGlyphs + 1) * 4)
      EndIf
    EndIf
  EndIf
  ; 解析glyf表
  Protected glyfOffset.i = PbPDF_TTFFindTable(*buf, "glyf", *attr\offsetTbl\numTables)
  If glyfOffset >= 0
    Protected glyfLen.i = PbPDF_TTFFindTable(*buf, "glyf", *attr\offsetTbl\numTables)
    ; 获取glyf表长度
    Protected gi.i
    For gi = 0 To *attr\offsetTbl\numTables - 1
      Protected entryOff.i = 12 + gi * 16
      Protected tag$ = ""
      tag$ + Chr(PeekA(*buf + entryOff))
      tag$ + Chr(PeekA(*buf + entryOff + 1))
      tag$ + Chr(PeekA(*buf + entryOff + 2))
      tag$ + Chr(PeekA(*buf + entryOff + 3))
      If tag$ = "glyf"
        *attr\glyfTableSize = PbPDF_TTFReadU32(*buf, entryOff + 12)
        Break
      EndIf
    Next
    *attr\glyfTable = AllocateMemory(*attr\glyfTableSize)
    If *attr\glyfTable
      CopyMemory(*buf + glyfOffset, *attr\glyfTable, *attr\glyfTableSize)
    EndIf
  EndIf
  ; 设置字体定义属性
  *fontDef\type = #PbPDF_FONTDEF_TRUETYPE
  *fontDef\fontBBox\left = *attr\header\xMin
  *fontDef\fontBBox\bottom = *attr\header\yMin
  *fontDef\fontBBox\right = *attr\header\xMax
  *fontDef\fontBBox\top = *attr\header\yMax
  ; 计算StemV(近似值)
  *fontDef\stemV = 80
  If *attr\os2WeightClass >= 600
    *fontDef\stemV = 120
  EndIf
  *fontDef\valid = 1
  ; 创建已使用字形ID列表(用于子集化)
  *attr\usedGIDs = PbPDF_ListNew(#PB_Long, 64)
  ProcedureReturn #PbPDF_OK
EndProcedure

;--- 从Unicode码点获取TTF字形ID ---
; 根据cmap表查找Unicode码点对应的字形ID
; Format 4中idRangeOffset!=0时，需要从glyphIdArray中查找
Procedure.i PbPDF_TTFontGetGlyphID(*fontDef.PbPDF_FontDef, unicode.i)
  If Not *fontDef Or Not *fontDef\attr
    ProcedureReturn 0
  EndIf
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  If *attr\cmapFormat = 4 And *attr\cmapRanges
    ; Format 4: 段映射
    Protected i.i, count.i = *attr\numCmapRanges
    For i = 0 To count - 1
      Protected *range.PbPDF_TTFCmapRange = *attr\cmapRanges\items + i * SizeOf(PbPDF_TTFCmapRange)
      If unicode >= *range\startCode And unicode <= *range\endCode
        Protected glyphID.i
        If *range\idRangeOffset = 0
          ; idRangeOffset为0时，直接用公式计算: glyphID = (unicode + idDelta) & 0xFFFF
          glyphID = (unicode + *range\idDelta) & $FFFF
        Else
          ; idRangeOffset不为0时，需要从glyphIdArray中查找
          ; 计算公式: offset = idRangeOffsetEntryOff + idRangeOffset + 2*(unicode - startCode)
          ; glyphID = ReadU16(fontData, offset)
          ; 如果glyphID不为0，则 glyphID = (glyphID + idDelta) & 0xFFFF
          If *attr\fontDataBuf
            Protected glyphArrayOff.i = *range\idRangeOffsetEntryOff + *range\idRangeOffset + 2 * (unicode - *range\startCode)
            glyphID = PbPDF_TTFReadU16(*attr\fontDataBuf, glyphArrayOff)
            If glyphID <> 0
              glyphID = (glyphID + *range\idDelta) & $FFFF
            EndIf
          Else
            ; 没有字体数据缓冲区时使用简化计算(可能不准确)
            glyphID = (unicode - *range\startCode + *range\idDelta) & $FFFF
          EndIf
        EndIf
        ProcedureReturn glyphID
      EndIf
    Next
  ElseIf *attr\cmapFormat = 0
    ; Format 0: 直接映射(单字节)
    If unicode < 256
      ProcedureReturn unicode
    EndIf
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 获取TTF字形前进宽度(以em单位) ---
Procedure.w PbPDF_TTFontGetAdvanceWidth(*fontDef.PbPDF_FontDef, glyphID.i)
  If Not *fontDef Or Not *fontDef\attr
    ProcedureReturn 0
  EndIf
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  If Not *attr\hMetric
    ProcedureReturn 0
  EndIf
  If glyphID < *attr\numHMetric
    ProcedureReturn PeekW(*attr\hMetric + glyphID * 4) & $FFFF
  ElseIf *attr\numHMetric > 0
    ; 超出hMetric范围的字形使用最后一个条目的宽度
    ProcedureReturn PeekW(*attr\hMetric + (*attr\numHMetric - 1) * 4) & $FFFF
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 获取TTF字符宽度(以1000为单位，PDF标准) ---
Procedure.w PbPDF_TTFontGetCharWidth(*fontDef.PbPDF_FontDef, unicode.i)
  Protected glyphID.i = PbPDF_TTFontGetGlyphID(*fontDef, unicode)
  Protected width.w = PbPDF_TTFontGetAdvanceWidth(*fontDef, glyphID)
  If *fontDef\attr
    Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
    If *attr\header\unitsPerEm > 0
      width = width * 1000 / *attr\header\unitsPerEm
    EndIf
  EndIf
  ProcedureReturn width
EndProcedure

;--- 记录已使用的字形ID(用于子集化) ---
Procedure PbPDF_TTFontMarkGlyphUsed(*fontDef.PbPDF_FontDef, unicode.i)
  If Not *fontDef Or Not *fontDef\attr
    ProcedureReturn
  EndIf
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  Protected glyphID.i = PbPDF_TTFontGetGlyphID(*fontDef, unicode)
  ; 检查是否已记录
  Protected i.i, count.i = PbPDF_ListCount(*attr\usedGIDs)
  For i = 0 To count - 1
    If PbPDF_ListGetPointer(*attr\usedGIDs, i) = glyphID
      ProcedureReturn  ; 已存在
    EndIf
  Next
  PbPDF_ListAddPointer(*attr\usedGIDs, glyphID)
EndProcedure

;=============================================================================
; 第19部分：TTF字体嵌入和FontDescriptor
;=============================================================================

;--- 从文件加载TTF字体 ---
; 支持从任意路径加载TTF/TTC字体文件，包括系统字体目录(C:\Windows\Fonts\)
; PureBasic的ReadFile无法读取系统字体目录下的文件，因此使用Windows API作为后备方案
; fileName$: 字体文件的完整路径
; embedding: 是否嵌入字体数据到PDF中
; 返回字体对象指针，失败返回0
Procedure.i PbPDF_LoadTTFontFromFile(*doc.PbPDF_Doc, fileName$, embedding.i = #True)
  Protected fileID.i, fileSize.i, *buf, hFile.i, bytesRead.i
  Protected *fontDef.PbPDF_FontDef, result.i, *font.PbPDF_Font
  
  If Not *doc
    ProcedureReturn 0
  EndIf
  
  ;--- 方式1：尝试使用PureBasic的ReadFile读取 ---
  ; 对于普通目录下的字体文件，PureBasic的ReadFile可以正常工作
  fileID = ReadFile(#PB_Any, fileName$)
  If fileID
    fileSize = Lof(fileID)
    If fileSize > 0
      *buf = AllocateMemory(fileSize)
      If *buf
        If ReadData(fileID, *buf, fileSize) = fileSize
          CloseFile(fileID)
          ; 成功读取，跳转到解析步骤
          Goto pbpdf_load_font_parse
        EndIf
        FreeMemory(*buf)
      EndIf
    EndIf
    CloseFile(fileID)
  EndIf
  
  ;--- 方式2：PureBasic ReadFile失败时，使用Windows API读取 ---
  ; 系统字体目录(C:\Windows\Fonts\)下的文件需要使用Windows API才能读取
  ; CreateFile_使用GENERIC_READ和FILE_SHARE_READ|FILE_SHARE_WRITE共享模式
  hFile = CreateFile_(@fileName$, #PbPDF_WIN_GENERIC_READ, #PbPDF_WIN_FILE_SHARE_READ | #PbPDF_WIN_FILE_SHARE_WRITE, 0, #PbPDF_WIN_OPEN_EXISTING, #PbPDF_WIN_FILE_ATTRIBUTE_NORMAL, 0)
  If hFile = #PbPDF_WIN_INVALID_HANDLE_VALUE Or hFile = 0
    ProcedureReturn 0
  EndIf
  fileSize = GetFileSize_(hFile, 0)
  If fileSize <= 0 Or fileSize = $FFFFFFFF
    CloseHandle_(hFile)
    ProcedureReturn 0
  EndIf
  *buf = AllocateMemory(fileSize)
  If Not *buf
    CloseHandle_(hFile)
    ProcedureReturn 0
  EndIf
  bytesRead = 0
  If Not ReadFile_(hFile, *buf, fileSize, @bytesRead, 0) Or bytesRead <> fileSize
    CloseHandle_(hFile)
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  CloseHandle_(hFile)
  
  ;--- 解析TTF字体数据 ---
pbpdf_load_font_parse:
  ; 创建字体定义
  *fontDef = AllocateMemory(SizeOf(PbPDF_FontDef))
  If Not *fontDef
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  InitializeStructure(*fontDef, PbPDF_FontDef)
  *fontDef\type = #PbPDF_FONTDEF_TRUETYPE
  ; 解析TTF文件
  result = PbPDF_TTFontLoad(*fontDef, *buf, fileSize, embedding)
  FreeMemory(*buf)
  If result <> #PbPDF_OK
    FreeMemory(*fontDef)
    ProcedureReturn 0
  EndIf
  ; 添加到字体定义管理列表
  If *doc\fontDefMgr
    PbPDF_ListAddPointer(*doc\fontDefMgr, *fontDef)
  EndIf
  ; 创建字体对象
  *font = AllocateMemory(SizeOf(PbPDF_Font))
  If Not *font
    FreeMemory(*fontDef)
    ProcedureReturn 0
  EndIf
  InitializeStructure(*font, PbPDF_Font)
  *font\fontType = #PbPDF_FONT_TRUETYPE
  *font\fontDef = *fontDef
  *font\localName = "TTF" + Str(*doc\ttfontTagCounter)
  *doc\ttfontTagCounter + 1
  ; 添加到字体管理列表
  If *doc\fontMgr
    PbPDF_ListAddPointer(*doc\fontMgr, *font)
  EndIf
  ProcedureReturn *font
EndProcedure

;--- 在系统字体目录中查找字体文件 ---
; 根据字体名称(如"SimHei"、"SimSun"、"Microsoft YaHei")在系统字体目录中查找对应的TTF/TTC文件
; 返回找到的字体文件完整路径，未找到返回空字符串
Procedure.s PbPDF_FindSystemFont(fontName$)
  Protected fontDir$ = Space(#MAX_PATH)
  ; 获取Windows系统字体目录路径
  GetWindowsDirectory_(@fontDir$, #MAX_PATH)
  fontDir$ = RTrim(fontDir$, "\") + "\Fonts\"
  ; 常见中文字体名到文件名的映射表
  ; 优先使用映射表查找，因为很多中文字体的文件名与字体名不一致
  Protected NewMap fontNameToFile.s()
  ; 简体中文字体
  fontNameToFile("SimHei") = "simhei.ttf"
  fontNameToFile("SimSun") = "simsun.ttc"
  fontNameToFile("NSimSun") = "simsun.ttc"
  fontNameToFile("Microsoft YaHei") = "msyh.ttc"
  fontNameToFile("Microsoft YaHei Bold") = "msyhbd.ttc"
  fontNameToFile("Microsoft YaHei Light") = "msyhl.ttc"
  fontNameToFile("FangSong") = "simfang.ttf"
  fontNameToFile("KaiTi") = "simkai.ttf"
  ; 繁体中文字体
  fontNameToFile("MingLiU") = "mingliu.ttc"
  fontNameToFile("PMingLiU") = "mingliu.ttc"
  fontNameToFile("Microsoft JhengHei") = "msjh.ttc"
  fontNameToFile("Microsoft JhengHei Bold") = "msjhbd.ttc"
  ; 日文字体
  fontNameToFile("MS Gothic") = "msgothic.ttc"
  fontNameToFile("MS PGothic") = "msgothic.ttc"
  fontNameToFile("MS Mincho") = "msmincho.ttc"
  fontNameToFile("MS PMincho") = "msmincho.ttc"
  ; 韩文字体
  fontNameToFile("Batang") = "batang.ttc"
  fontNameToFile("Gulim") = "gulim.ttc"
  ; 英文字体
  fontNameToFile("Arial") = "arial.ttf"
  fontNameToFile("Arial Bold") = "arialbd.ttf"
  fontNameToFile("Arial Italic") = "ariali.ttf"
  fontNameToFile("Arial Bold Italic") = "arialbi.ttf"
  fontNameToFile("Times New Roman") = "times.ttf"
  fontNameToFile("Times New Roman Bold") = "timesbd.ttf"
  fontNameToFile("Times New Roman Italic") = "timesi.ttf"
  fontNameToFile("Times New Roman Bold Italic") = "timesbi.ttf"
  fontNameToFile("Courier New") = "cour.ttf"
  fontNameToFile("Courier New Bold") = "courbd.ttf"
  fontNameToFile("Consolas") = "consola.ttf"
  fontNameToFile("Consolas Bold") = "consolab.ttf"
  fontNameToFile("Tahoma") = "tahoma.ttf"
  fontNameToFile("Verdana") = "verdana.ttf"
  fontNameToFile("Georgia") = "georgia.ttf"
  ; 先在映射表中查找
  If FindMapElement(fontNameToFile(), fontName$)
    Protected mappedFile$ = fontDir$ + fontNameToFile()
    If FileSize(mappedFile$) > 0
      ProcedureReturn mappedFile$
    EndIf
  EndIf
  ; 映射表中未找到，尝试直接用字体名作为文件名
  ; 尝试多种扩展名
  Protected extensions$ = ".ttf|.ttc|.otf|.TTF|.TTC|.OTF"
  Protected extIdx.i
  For extIdx = 0 To 5
    Protected ext$ = StringField(extensions$, extIdx + 1, "|")
    Protected tryPath$ = fontDir$ + fontName$ + ext$
    If FileSize(tryPath$) > 0
      ProcedureReturn tryPath$
    EndIf
  Next
  ; 尝试去掉空格后再查找
  Protected noSpaceName$ = ReplaceString(fontName$, " ", "")
  For extIdx = 0 To 5
    ext$ = StringField(extensions$, extIdx + 1, "|")
    tryPath$ = fontDir$ + noSpaceName$ + ext$
    If FileSize(tryPath$) > 0
      ProcedureReturn tryPath$
    EndIf
  Next
  ; 尝试在注册表中查找(HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts)
  ; 读取注册表中字体名对应的文件名
  Protected regKey.i
  Protected regValueName$ = fontName$ + " (TrueType)"
  Protected regValue$ = Space(#MAX_PATH)
  Protected regSize.i = #MAX_PATH
  If RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", 0, #KEY_READ, @regKey) = #ERROR_SUCCESS
    If RegQueryValueEx_(regKey, @regValueName$, 0, 0, @regValue$, @regSize) = #ERROR_SUCCESS
      regValue$ = Left(regValue$, regSize - 1)
      ; 注册表中的路径可能是相对路径或绝对路径
      If FileSize(regValue$) > 0
        RegCloseKey_(regKey)
        ProcedureReturn regValue$
      EndIf
      ; 尝试加上字体目录前缀
      tryPath$ = fontDir$ + GetFilePart(regValue$)
      If FileSize(tryPath$) > 0
        RegCloseKey_(regKey)
        ProcedureReturn tryPath$
      EndIf
    EndIf
    ; 尝试不带(TrueType)后缀的注册表键名
    regValueName$ = fontName$
    regValue$ = Space(#MAX_PATH)
    regSize = #MAX_PATH
    If RegQueryValueEx_(regKey, @regValueName$, 0, 0, @regValue$, @regSize) = #ERROR_SUCCESS
      regValue$ = Left(regValue$, regSize - 1)
      If FileSize(regValue$) > 0
        RegCloseKey_(regKey)
        ProcedureReturn regValue$
      EndIf
      tryPath$ = fontDir$ + GetFilePart(regValue$)
      If FileSize(tryPath$) > 0
        RegCloseKey_(regKey)
        ProcedureReturn tryPath$
      EndIf
    EndIf
    RegCloseKey_(regKey)
  EndIf
  ; 未找到
  ProcedureReturn ""
EndProcedure

;--- 从系统字体库加载TrueType字体 ---
; 根据字体名称自动在系统字体目录中查找并加载字体
; fontName$: 字体名称(如"SimHei"、"Microsoft YaHei"、"Arial")
; embedding: 是否嵌入字体数据
; 返回字体对象指针，失败返回0
Procedure.i PbPDF_LoadTTFont(*doc.PbPDF_Doc, fontName$, embedding.i = #True)
  If Not *doc Or fontName$ = ""
    ProcedureReturn 0
  EndIf
  ; 在系统字体目录中查找字体文件
  Protected fontPath$ = PbPDF_FindSystemFont(fontName$)
  If fontPath$ = ""
    ProcedureReturn 0
  EndIf
  ; 使用文件加载函数加载字体
  ProcedureReturn PbPDF_LoadTTFontFromFile(*doc, fontPath$, embedding)
EndProcedure
Procedure.i PbPDF_CreateTTFontDict(*doc.PbPDF_Doc, *font.PbPDF_Font)
  If Not *doc Or Not *font Or Not *font\fontDef
    ProcedureReturn 0
  EndIf
  Protected *fontDef.PbPDF_FontDef = *font\fontDef
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  ; 创建FontDescriptor字典
  Protected *fontDesc.PbPDF_Object = PbPDF_DictNew()
  PbPDF_DictAddName(*fontDesc, "Type", "FontDescriptor")
  PbPDF_DictAddName(*fontDesc, "FontName", *fontDef\baseFont)
  PbPDF_DictAddNumber(*fontDesc, "Flags", *fontDef\flags)
  ; FontBBox
  Protected *bbox.PbPDF_Object = PbPDF_ArrayNew()
  Protected scale.f = 1000.0 / *attr\header\unitsPerEm
  PbPDF_ArrayAdd(*bbox, PbPDF_NumberNew(Int(*fontDef\fontBBox\left * scale)))
  PbPDF_ArrayAdd(*bbox, PbPDF_NumberNew(Int(*fontDef\fontBBox\bottom * scale)))
  PbPDF_ArrayAdd(*bbox, PbPDF_NumberNew(Int(*fontDef\fontBBox\right * scale)))
  PbPDF_ArrayAdd(*bbox, PbPDF_NumberNew(Int(*fontDef\fontBBox\top * scale)))
  PbPDF_DictAdd(*fontDesc, "FontBBox", *bbox)
  PbPDF_DictAddNumber(*fontDesc, "ItalicAngle", *fontDef\italicAngle)
  PbPDF_DictAddNumber(*fontDesc, "Ascent", Int(*fontDef\ascent * scale))
  PbPDF_DictAddNumber(*fontDesc, "Descent", Int(*fontDef\descent * scale))
  PbPDF_DictAddNumber(*fontDesc, "CapHeight", Int(*fontDef\capHeight * scale))
  PbPDF_DictAddNumber(*fontDesc, "StemV", *fontDef\stemV)
  ; 嵌入字体数据
  If *attr\embedding And *attr\fontDataBuf
    ; 创建字体流
    Protected *fontStream.PbPDF_Stream = PbPDF_MemStreamNew()
    If *fontStream
      PbPDF_StreamWriteData(*fontStream, *attr\fontDataBuf, *attr\fontDataSize)
    EndIf
    ; 创建字体流字典
    Protected *fontFileDict.PbPDF_Object = PbPDF_DictNew()
    *fontFileDict\stream = *fontStream
    PbPDF_DictAddNumber(*fontFileDict, "Length1", *attr\fontDataSize)
    PbPDF_DictAddNumber(*fontFileDict, "Length2", 0)
    PbPDF_DictAddNumber(*fontFileDict, "Length3", 0)
    ; 注册到xref
    If *doc\xref
      PbPDF_XRefAdd(*doc\xref, *fontFileDict)
    EndIf
    PbPDF_DictAdd(*fontDesc, "FontFile2", *fontFileDict)
  EndIf
  ; 注册FontDescriptor到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *fontDesc)
  EndIf
  ; 创建字体字典(TrueType)
  Protected *fontDict.PbPDF_Object = PbPDF_DictNew(#PbPDF_OSUBCLASS_FONT)
  PbPDF_DictAddName(*fontDict, "Type", "Font")
  PbPDF_DictAddName(*fontDict, "Subtype", "TrueType")
  PbPDF_DictAddName(*fontDict, "BaseFont", *fontDef\baseFont)
  PbPDF_DictAdd(*fontDict, "FontDescriptor", *fontDesc)
  ; 添加编码
  PbPDF_DictAddName(*fontDict, "Encoding", "WinAnsiEncoding")
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *fontDict)
  EndIf
  *font\fontObj = *fontDict
  ProcedureReturn *fontDict
EndProcedure

;--- 注册TTF字体到页面 ---
Procedure.s PbPDF_RegisterTTFont(*doc.PbPDF_Doc, *pageObj.PbPDF_Object, *font.PbPDF_Font)
  If Not *doc Or Not *pageObj Or Not *font
    ProcedureReturn ""
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn ""
  EndIf
  ; 创建字体字典(如果尚未创建)
  If Not *font\fontObj
    PbPDF_CreateTTFontDict(*doc, *font)
  EndIf
  If Not *font\fontObj
    ProcedureReturn ""
  EndIf
  ; 确保页面有字体资源字典
  If Not *pageAttr\fonts
    *pageAttr\fonts = PbPDF_DictNew()
    Protected *resources.PbPDF_Object = PbPDF_DictGetValue(*pageObj, "Resources")
    If Not *resources
      *resources = PbPDF_DictNew()
      PbPDF_DictAdd(*pageObj, "Resources", *resources)
    EndIf
    PbPDF_DictAdd(*resources, "Font", *pageAttr\fonts)
  EndIf
  ; 使用本地名称注册
  Protected localName$ = *font\localName
  ; 检查是否已注册
  Protected *existing.PbPDF_Object = PbPDF_DictGetValue(*pageAttr\fonts, localName$)
  If *existing
    ProcedureReturn localName$
  EndIf
  ; 添加到页面字体资源
  PbPDF_DictAdd(*pageAttr\fonts, localName$, *font\fontObj)
  ProcedureReturn localName$
EndProcedure

;=============================================================================
; 第20部分：UTF-8编码器和ToUnicode CMap
;=============================================================================

;--- 将UTF-8字符串编码为PDF十六进制字符串 ---
; 用于在PDF中正确显示Unicode文本
Procedure.s PbPDF_EncodeUTF8ToPDFHex(text$)
  Protected result$ = ""
  Protected *buf = AllocateMemory(StringByteLength(text$, #PB_UTF8) + 1)
  If *buf
    PokeS(*buf, text$, -1, #PB_UTF8)
    Protected bufLen.i = StringByteLength(text$, #PB_UTF8)
    Protected i.i, byteCount.i, unicode.l
    Protected *srcPtr.Byte = *buf
    i = 0
    While i < bufLen
      unicode = PbPDF_UTF8Decode(*srcPtr + i, bufLen - i, @byteCount)
      i + byteCount
      ; 编码为UTF-16BE
      If unicode < $10000
        result$ + RSet(Hex((unicode >> 8) & $FF), 2, "0")
        result$ + RSet(Hex(unicode & $FF), 2, "0")
      Else
        Protected w1.l = $D800 + ((unicode - $10000) >> 10)
        Protected w2.l = $DC00 + ((unicode - $10000) & $3FF)
        result$ + RSet(Hex((w1 >> 8) & $FF), 2, "0")
        result$ + RSet(Hex(w1 & $FF), 2, "0")
        result$ + RSet(Hex((w2 >> 8) & $FF), 2, "0")
        result$ + RSet(Hex(w2 & $FF), 2, "0")
      EndIf
    Wend
    FreeMemory(*buf)
  EndIf
  ProcedureReturn result$
EndProcedure

;--- 显示UTF-8文本(使用十六进制编码) ---
Procedure PbPDF_Page_ShowTextUTF8(*pageObj.PbPDF_Object, text$)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    Protected hex$ = PbPDF_EncodeUTF8ToPDFHex(text$)
    If hex$ <> ""
      PbPDF_StreamWriteStr(*stream, "<" + hex$ + "> Tj" + #LF$)
    EndIf
  EndIf
EndProcedure

;--- 生成ToUnicode CMap流 ---
; 用于让PDF阅读器正确映射字形到Unicode
Procedure.i PbPDF_CreateToUnicodeCMap(*doc.PbPDF_Doc, *fontDef.PbPDF_FontDef)
  If Not *doc Or Not *fontDef
    ProcedureReturn 0
  EndIf
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  If Not *attr
    ProcedureReturn 0
  EndIf
  ; 创建CMap内容
  Protected *cmapStream.PbPDF_Stream = PbPDF_MemStreamNew()
  If Not *cmapStream
    ProcedureReturn 0
  EndIf
  ; 写入CMap头部
  PbPDF_StreamWriteStr(*cmapStream, "/CIDInit /ProcSet findresource begin" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "12 dict begin" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "begincmap" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CIDSystemInfo" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "<< /Registry (Adobe)" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/Ordering (UCS)" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/Supplement 0 >> def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CMapName /Adobe-Identity-UCS def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CMapType 2 def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "1 begincodespacerange" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "<0000> <FFFF>" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "endcodespacerange" + #LF$)
  ; 写入字形映射(从cmap范围生成)
  If *attr\cmapRanges And *attr\numCmapRanges > 0
    Protected rangeCount.i = *attr\numCmapRanges
    If rangeCount > 100
      rangeCount = 100  ; 限制每批数量
    EndIf
    PbPDF_StreamWriteStr(*cmapStream, Str(rangeCount) + " beginbfchar" + #LF$)
    Protected ri.i
    For ri = 0 To rangeCount - 1
      If ri >= *attr\numCmapRanges
        Break
      EndIf
      Protected *range.PbPDF_TTFCmapRange = *attr\cmapRanges\items + ri * SizeOf(PbPDF_TTFCmapRange)
      ; 为每个Unicode码点生成映射
      Protected ui.i
      For ui = *range\startCode To *range\endCode
        Protected gid.i
        If *range\idRangeOffset = 0
          gid = (ui + *range\idDelta) & $FFFF
        Else
          ; 使用正确的idRangeOffset查找方式
          If *attr\fontDataBuf
            Protected glyphArrayOff.i = *range\idRangeOffsetEntryOff + *range\idRangeOffset + 2 * (ui - *range\startCode)
            gid = PbPDF_TTFReadU16(*attr\fontDataBuf, glyphArrayOff)
            If gid <> 0
              gid = (gid + *range\idDelta) & $FFFF
            EndIf
          Else
            gid = (ui - *range\startCode + *range\idDelta) & $FFFF
          EndIf
        EndIf
        PbPDF_StreamWriteStr(*cmapStream, "<" + RSet(Hex(gid), 4, "0") + "> <" + RSet(Hex(ui), 4, "0") + ">" + #LF$)
      Next
    Next
    PbPDF_StreamWriteStr(*cmapStream, "endbfchar" + #LF$)
  EndIf
  ; 写入CMap尾部
  PbPDF_StreamWriteStr(*cmapStream, "endcmap" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "CMapName currentdict /CMap defineresource pop" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "end" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "end" + #LF$)
  ; 创建CMap流字典对象
  Protected *cmapDict.PbPDF_Object = PbPDF_DictNew()
  *cmapDict\stream = *cmapStream
  PbPDF_DictAddNumber(*cmapDict, "Length", *cmapStream\size)
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *cmapDict)
  EndIf
  ProcedureReturn *cmapDict
EndProcedure

;--- 设置PDF版本 ---
Procedure PbPDF_SetPDFVersion(*doc.PbPDF_Doc, version.i)
  If *doc
    *doc\pdfVersion = version
  EndIf
EndProcedure

;=============================================================================
; 第21部分：字体子集化
;=============================================================================

;--- 字形映射条目(旧GID -> 新GID) ---
Structure PbPDF_GlyphMapEntry
  oldGID.i         ; 原始字形ID
  newGID.i         ; 新字形ID
  unicode.i        ; Unicode码点
  offset.i         ; 在glyf表中的偏移
  length.i         ; 字形数据长度
EndStructure

;--- 获取字形在glyf表中的偏移和长度 ---
; 根据loca表计算指定GID的字形数据位置和大小
Procedure.i PbPDF_TTFontGetGlyphOffset(*attr.PbPDF_TTFontAttr, glyphID.i, *offset.Integer, *length.Integer)
  If Not *attr Or Not *attr\locaTable Or Not *attr\glyfTable
    ProcedureReturn #PbPDF_ERR_INVALID_FONT
  EndIf
  If glyphID < 0 Or glyphID >= *attr\numGlyphs
    ProcedureReturn #PbPDF_ERR_INVALID_FONT
  EndIf
  Protected glyphOffset.i, nextOffset.i
  If *attr\locaFormat = 0
    ; 短格式：每个条目为2字节(大端序)，实际偏移需要乘以2
    glyphOffset = PbPDF_TTFReadU16(*attr\locaTable, glyphID * 2) * 2
    nextOffset = PbPDF_TTFReadU16(*attr\locaTable, (glyphID + 1) * 2) * 2
  Else
    ; 长格式：每个条目为4字节(大端序)
    glyphOffset = PbPDF_TTFReadU32(*attr\locaTable, glyphID * 4)
    nextOffset = PbPDF_TTFReadU32(*attr\locaTable, (glyphID + 1) * 4)
  EndIf
  If *offset
    PokeI(*offset, glyphOffset)
  EndIf
  If *length
    PokeI(*length, nextOffset - glyphOffset)
  EndIf
  ProcedureReturn #PbPDF_OK
EndProcedure

;--- 比较函数：按旧GID排序(用于字形映射表排序) ---
Procedure.i PbPDF_GlyphMapCompare(*a.PbPDF_GlyphMapEntry, *b.PbPDF_GlyphMapEntry)
  If *a\oldGID < *b\oldGID
    ProcedureReturn -1
  ElseIf *a\oldGID > *b\oldGID
    ProcedureReturn 1
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 创建子集化TTF字体数据 ---
; 从原始TTF字体中提取已使用的字形，生成新的子集化字体
; 返回子集化字体数据缓冲区(调用者负责释放)
Procedure.i PbPDF_TTFontCreateSubset(*fontDef.PbPDF_FontDef, *subsetSize.Integer)
  If Not *fontDef Or Not *fontDef\attr
    ProcedureReturn 0
  EndIf
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  If Not *attr\usedGIDs Or Not *attr\fontDataBuf
    ProcedureReturn 0
  EndIf
  Protected usedCount.i = PbPDF_ListCount(*attr\usedGIDs)
  ; 如果没有使用任何字形，或者使用的字形数量接近全部，则返回完整字体
  If usedCount = 0
    ProcedureReturn 0
  EndIf
  ; 如果使用的字形超过总数的80%，直接嵌入完整字体
  If usedCount >= *attr\numGlyphs * 80 / 100
    Protected *fullBuf = AllocateMemory(*attr\fontDataSize)
    If *fullBuf
      CopyMemory(*attr\fontDataBuf, *fullBuf, *attr\fontDataSize)
      If *subsetSize
        PokeI(*subsetSize, *attr\fontDataSize)
      EndIf
    EndIf
    ProcedureReturn *fullBuf
  EndIf
  ; 构建字形映射表(包含.notdef + 已使用字形)
  ; 新字形顺序：0=.notdef, 1..n=已使用字形(按旧GID排序)
  Protected totalGlyphs.i = usedCount + 1  ; 加上.notdef
  Protected *glyphMap.PbPDF_GlyphMapEntry = AllocateMemory(totalGlyphs * SizeOf(PbPDF_GlyphMapEntry))
  If Not *glyphMap
    ProcedureReturn 0
  EndIf
  ; .notdef始终为GID 0
  *glyphMap\oldGID = 0
  *glyphMap\newGID = 0
  *glyphMap\unicode = 0
  *glyphMap\offset = 0
  *glyphMap\length = 0
  ; 收集已使用字形的偏移和长度
  Protected gi.i
  For gi = 0 To usedCount - 1
    Protected *entry.PbPDF_GlyphMapEntry = *glyphMap + (gi + 1) * SizeOf(PbPDF_GlyphMapEntry)
    *entry\oldGID = PbPDF_ListGetPointer(*attr\usedGIDs, gi)
    *entry\newGID = gi + 1
    *entry\unicode = 0  ; 将在后面填充
    Protected gOffset.i, gLength.i
    If PbPDF_TTFontGetGlyphOffset(*attr, *entry\oldGID, @gOffset, @gLength) = #PbPDF_OK
      *entry\offset = gOffset
      *entry\length = gLength
    Else
      *entry\offset = 0
      *entry\length = 0
    EndIf
  Next
  ; 为每个已使用字形查找Unicode码点(从cmap范围反向映射)
  Protected mi.i
  For mi = 1 To totalGlyphs - 1
    Protected *mapEntry.PbPDF_GlyphMapEntry = *glyphMap + mi * SizeOf(PbPDF_GlyphMapEntry)
    If *attr\cmapRanges And *attr\numCmapRanges > 0
      Protected ri.i
      For ri = 0 To *attr\numCmapRanges - 1
        Protected *range.PbPDF_TTFCmapRange = *attr\cmapRanges\items + ri * SizeOf(PbPDF_TTFCmapRange)
        Protected ui.i
        For ui = *range\startCode To *range\endCode
          Protected gid.i
          If *range\idRangeOffset = 0
            gid = (ui + *range\idDelta) & $FFFF
          Else
            ; 使用正确的idRangeOffset查找方式
            If *attr\fontDataBuf
              Protected glyphArrayOff.i = *range\idRangeOffsetEntryOff + *range\idRangeOffset + 2 * (ui - *range\startCode)
              gid = PbPDF_TTFReadU16(*attr\fontDataBuf, glyphArrayOff)
              If gid <> 0
                gid = (gid + *range\idDelta) & $FFFF
              EndIf
            Else
              gid = (ui - *range\startCode + *range\idDelta) & $FFFF
            EndIf
          EndIf
          If gid = *mapEntry\oldGID
            *mapEntry\unicode = ui
            Break 2
          EndIf
        Next
      Next
    EndIf
  Next
  ; 计算子集化字体各表的大小
  ; 需要包含的表：head, hhea, maxp, hmtx, cmap, loca, glyf, name, OS/2, post
  ; 简化方案：直接复制原始字体数据，但替换glyf/loca/hmtx/cmap/maxp表
  ; 更简单的方案：使用完整的原始字体数据但修改maxp表中的numGlyphs
  ; 这里采用最实用的方案：生成最小化的子集化字体
  ; 计算glyf表总大小(包含所有已使用字形)
  Protected totalGlyfSize.i = 0
  For gi = 0 To totalGlyphs - 1
    Protected *gEntry.PbPDF_GlyphMapEntry = *glyphMap + gi * SizeOf(PbPDF_GlyphMapEntry)
    totalGlyfSize + *gEntry\length
    ; 字形数据需要4字节对齐
    If *gEntry\length > 0
      totalGlyfSize + (4 - (*gEntry\length % 4)) % 4
    EndIf
  Next
  ; 计算loca表大小
  Protected locaSize.i
  If *attr\locaFormat = 0
    locaSize = (totalGlyphs + 1) * 2
  Else
    locaSize = (totalGlyphs + 1) * 4
  EndIf
  ; 计算hmtx表大小
  Protected hmtxSize.i = totalGlyphs * 4  ; 每个字形4字节(advanceWidth + lsb)
  ; 计算cmap表大小(Format 4)
  ; Format 4结构: 14(头部) + segCount*2(endCode) + 2(reservedPad) + segCount*2(startCode)
  ; + segCount*2(idDelta) + segCount*2(idRangeOffset) = 14 + 2 + segCount*8
  ; 加上cmap头部12字节和编码记录8字节
  ; segCount最多为totalGlyphs+1(每个字形一个段+终止段)，使用此值作为上限估算
  Protected cmapEstSegCount.i = totalGlyphs + 1
  Protected cmapSize.i = 12 + 8 + 14 + 2 + cmapEstSegCount * 8 + 2
  ; 计算需要的表数量
  Protected numTables.i = 9  ; head, hhea, maxp, hmtx, cmap, loca, glyf, name, post
  ; 计算偏移表大小
  Protected offsetTblSize.i = 12 + numTables * 16
  ; 计算各表偏移(4字节对齐)
  Protected headTblOffset.i = offsetTblSize
  Protected hheaTblOffset.i = headTblOffset + 54  ; head表固定54字节
  hheaTblOffset + (4 - (hheaTblOffset % 4)) % 4
  Protected maxpTblOffset.i = hheaTblOffset + 36  ; hhea表固定36字节
  maxpTblOffset + (4 - (maxpTblOffset % 4)) % 4
  Protected hmtxTblOffset.i = maxpTblOffset + 32  ; maxp表约32字节
  hmtxTblOffset + (4 - (hmtxTblOffset % 4)) % 4
  Protected cmapTblOffset.i = hmtxTblOffset + hmtxSize
  cmapTblOffset + (4 - (cmapTblOffset % 4)) % 4
  Protected locaTblOffset.i = cmapTblOffset + cmapSize
  locaTblOffset + (4 - (locaTblOffset % 4)) % 4
  Protected glyfTblOffset.i = locaTblOffset + locaSize
  glyfTblOffset + (4 - (glyfTblOffset % 4)) % 4
  Protected nameTblOffset.i = glyfTblOffset + totalGlyfSize
  nameTblOffset + (4 - (nameTblOffset % 4)) % 4
  Protected postTblOffset.i = nameTblOffset + 512  ; name表预留512字节
  postTblOffset + (4 - (postTblOffset % 4)) % 4
  Protected totalSize.i = postTblOffset + 32  ; post表约32字节
  ; 分配子集化字体缓冲区
  Protected *subsetBuf = AllocateMemory(totalSize + 1024)  ; 额外1024字节余量
  If Not *subsetBuf
    FreeMemory(*glyphMap)
    ProcedureReturn 0
  EndIf
  Protected *dst = *subsetBuf
  ; 填充零
  FillMemory(*dst, totalSize + 1024, 0)
  ;--- 写入偏移表 ---
  PbPDF_TTFWriteU32(*dst, 0, $00010000)   ; sfVersion
  PbPDF_TTFWriteU16(*dst, 4, numTables)   ; numTables
  ; 计算searchRange, entrySelector, rangeShift
  Protected sr.i = 1, es.i = 0
  While sr <= numTables
    sr * 2
    es + 1
  Wend
  sr / 2
  PbPDF_TTFWriteU16(*dst, 6, sr * 16)      ; searchRange
  PbPDF_TTFWriteU16(*dst, 8, es - 1)       ; entrySelector
  PbPDF_TTFWriteU16(*dst, 10, numTables * 16 - sr * 16)  ; rangeShift
  ;--- 写入表目录 ---
  Protected dirOffset.i = 12
  ; 辅助宏：写入一个表目录条目
  Protected tblIdx.i
  Protected tableTags$ = "headhheamaxpHMTXcmaplocaglyfnamepost"
  For tblIdx = 0 To numTables - 1
    Protected tag$ = Mid(tableTags$, tblIdx * 4 + 1, 4)
    Protected tblOffset.i, tblLen.i
    Select tag$
      Case "head": tblOffset = headTblOffset: tblLen = 54
      Case "hhea": tblOffset = hheaTblOffset: tblLen = 36
      Case "maxp": tblOffset = maxpTblOffset: tblLen = 32
      Case "HMTX": tblOffset = hmtxTblOffset: tblLen = hmtxSize
      Case "cmap": tblOffset = cmapTblOffset: tblLen = cmapSize
      Case "loca": tblOffset = locaTblOffset: tblLen = locaSize
      Case "glyf": tblOffset = glyfTblOffset: tblLen = totalGlyfSize
      Case "name": tblOffset = nameTblOffset: tblLen = 80
      Case "post": tblOffset = postTblOffset: tblLen = 32
    EndSelect
    ; 写入标签
    PokeA(*dst + dirOffset, Asc(Mid(tag$, 1, 1)))
    PokeA(*dst + dirOffset + 1, Asc(Mid(tag$, 2, 1)))
    PokeA(*dst + dirOffset + 2, Asc(Mid(tag$, 3, 1)))
    PokeA(*dst + dirOffset + 3, Asc(Mid(tag$, 4, 1)))
    PbPDF_TTFWriteU32(*dst, dirOffset + 4, 0)        ; checksum(暂时为0)
    PbPDF_TTFWriteU32(*dst, dirOffset + 8, tblOffset) ; offset
    PbPDF_TTFWriteU32(*dst, dirOffset + 12, tblLen)   ; length
    dirOffset + 16
  Next
  ;--- 写入head表(从原始字体复制并修改) ---
  Protected *srcHead = *attr\fontDataBuf
  Protected headSrcOffset.i = PbPDF_TTFFindTable(*srcHead, "head", *attr\offsetTbl\numTables)
  If headSrcOffset >= 0
    CopyMemory(*srcHead + headSrcOffset, *dst + headTblOffset, 54)
    ; 修改indexToLocFormat保持与原始一致
    ; checkSumAdjustment将在最后计算
    PbPDF_TTFWriteU32(*dst, headTblOffset + 8, 0)  ; 清零checkSumAdjustment
  EndIf
  ;--- 写入hhea表 ---
  Protected hheaSrcOffset.i = PbPDF_TTFFindTable(*srcHead, "hhea", *attr\offsetTbl\numTables)
  If hheaSrcOffset >= 0
    CopyMemory(*srcHead + hheaSrcOffset, *dst + hheaTblOffset, 36)
    ; 修改numOfLongHorMetrics为子集字形数
    PbPDF_TTFWriteU16(*dst, hheaTblOffset + 34, totalGlyphs)
  EndIf
  ;--- 写入maxp表 ---
  Protected maxpSrcOffset.i = PbPDF_TTFFindTable(*srcHead, "maxp", *attr\offsetTbl\numTables)
  If maxpSrcOffset >= 0
    CopyMemory(*srcHead + maxpSrcOffset, *dst + maxpTblOffset, 32)
    ; 修改numGlyphs为子集字形数
    PbPDF_TTFWriteU16(*dst, maxpTblOffset + 4, totalGlyphs)
  EndIf
  ;--- 写入hmtx表 ---
  Protected hmtxSrcOffset.i = PbPDF_TTFFindTable(*srcHead, "hmtx", *attr\offsetTbl\numTables)
  For gi = 0 To totalGlyphs - 1
    Protected *gmEntry.PbPDF_GlyphMapEntry = *glyphMap + gi * SizeOf(PbPDF_GlyphMapEntry)
    Protected aw.i = PbPDF_TTFontGetAdvanceWidth(*fontDef, *gmEntry\oldGID)
    Protected lsb.i = 0
    ; 获取lsb
    If *gmEntry\oldGID < *attr\numHMetric And hmtxSrcOffset >= 0
      lsb = PbPDF_TTFReadS16(*srcHead, hmtxSrcOffset + *gmEntry\oldGID * 4 + 2)
    EndIf
    PbPDF_TTFWriteU16(*dst, hmtxTblOffset + gi * 4, aw)
    PbPDF_TTFWriteU16(*dst, hmtxTblOffset + gi * 4 + 2, lsb)
  Next
  ;--- 写入cmap表(Format 4简化版) ---
  ; 使用Format 4映射：新GID -> Unicode
  Protected cmapDstOffset.i = cmapTblOffset
  PbPDF_TTFWriteU16(*dst, cmapDstOffset, 0)      ; version
  PbPDF_TTFWriteU16(*dst, cmapDstOffset + 2, 1)  ; numTables
  ; 编码记录(Platform 3, Encoding 1 = Windows Unicode)
  PbPDF_TTFWriteU16(*dst, cmapDstOffset + 4, 3)  ; platformID
  PbPDF_TTFWriteU16(*dst, cmapDstOffset + 6, 1)  ; encodingID
  PbPDF_TTFWriteU32(*dst, cmapDstOffset + 8, 12) ; offset
  ; Format 4子表
  Protected fmt4Offset.i = cmapDstOffset + 12
  ; 收集有效的Unicode映射条目
  Protected validMappings.i = 0
  For gi = 1 To totalGlyphs - 1
    Protected *gm.PbPDF_GlyphMapEntry = *glyphMap + gi * SizeOf(PbPDF_GlyphMapEntry)
    If *gm\unicode > 0 And *gm\unicode < $FFFF
      validMappings + 1
    EndIf
  Next
  ; 简化：每个映射作为独立段(startCode=endCode)
  Protected segCount.i = validMappings + 1  ; 加上0xFFFF终止段
  Protected segCount2.i = segCount * 2
  ; 计算searchRange等
  Protected cmapSR.i = 1, cmapES.i = 0
  While cmapSR <= segCount
    cmapSR * 2
    cmapES + 1
  Wend
  cmapSR / 2
  ; 写入Format 4头部
  PbPDF_TTFWriteU16(*dst, fmt4Offset, 4)                        ; format
  PbPDF_TTFWriteU16(*dst, fmt4Offset + 2, 14 + segCount2 * 4)   ; length
  PbPDF_TTFWriteU16(*dst, fmt4Offset + 4, 0)                     ; language
  PbPDF_TTFWriteU16(*dst, fmt4Offset + 6, segCount2)             ; segCountX2
  PbPDF_TTFWriteU16(*dst, fmt4Offset + 8, cmapSR * 2)            ; searchRange
  PbPDF_TTFWriteU16(*dst, fmt4Offset + 10, cmapES - 1)           ; entrySelector
  PbPDF_TTFWriteU16(*dst, fmt4Offset + 12, segCount2 - cmapSR * 2); rangeShift
  ; 写入endCode数组
  Protected endCodeArrOff.i = fmt4Offset + 14
  Protected arrIdx.i = 0
  For gi = 1 To totalGlyphs - 1
    Protected *gme.PbPDF_GlyphMapEntry = *glyphMap + gi * SizeOf(PbPDF_GlyphMapEntry)
    If *gme\unicode > 0 And *gme\unicode < $FFFF
      PbPDF_TTFWriteU16(*dst, endCodeArrOff + arrIdx * 2, *gme\unicode)
      arrIdx + 1
    EndIf
  Next
  PbPDF_TTFWriteU16(*dst, endCodeArrOff + arrIdx * 2, $FFFF)  ; 终止段
  ; reservedPad(在endCode和startCode之间)
  PbPDF_TTFWriteU16(*dst, endCodeArrOff + (arrIdx + 1) * 2, 0)
  ; 写入startCode数组
  Protected startCodeArrOff.i = endCodeArrOff + segCount * 2 + 2  ; +2 for reservedPad
  arrIdx = 0
  For gi = 1 To totalGlyphs - 1
    Protected *gms.PbPDF_GlyphMapEntry = *glyphMap + gi * SizeOf(PbPDF_GlyphMapEntry)
    If *gms\unicode > 0 And *gms\unicode < $FFFF
      PbPDF_TTFWriteU16(*dst, startCodeArrOff + arrIdx * 2, *gms\unicode)
      arrIdx + 1
    EndIf
  Next
  PbPDF_TTFWriteU16(*dst, startCodeArrOff + arrIdx * 2, $FFFF)  ; 终止段
  ; 写入idDelta数组
  Protected idDeltaArrOff.i = startCodeArrOff + segCount * 2
  arrIdx = 0
  For gi = 1 To totalGlyphs - 1
    Protected *gmd.PbPDF_GlyphMapEntry = *glyphMap + gi * SizeOf(PbPDF_GlyphMapEntry)
    If *gmd\unicode > 0 And *gmd\unicode < $FFFF
      Protected delta.i = (*gmd\newGID - *gmd\unicode) & $FFFF
      PbPDF_TTFWriteU16(*dst, idDeltaArrOff + arrIdx * 2, delta)
      arrIdx + 1
    EndIf
  Next
  PbPDF_TTFWriteU16(*dst, idDeltaArrOff + arrIdx * 2, 1)  ; 终止段delta
  ; 写入idRangeOffset数组(全部为0)
  Protected idRangeArrOff.i = idDeltaArrOff + segCount * 2
  For arrIdx = 0 To segCount - 1
    PbPDF_TTFWriteU16(*dst, idRangeArrOff + arrIdx * 2, 0)
  Next
  ;--- 写入loca表 ---
  Protected curGlyfOffset.i = 0
  For gi = 0 To totalGlyphs - 1
    Protected *gml.PbPDF_GlyphMapEntry = *glyphMap + gi * SizeOf(PbPDF_GlyphMapEntry)
    If *attr\locaFormat = 0
      PbPDF_TTFWriteU16(*dst, locaTblOffset + gi * 2, curGlyfOffset / 2)
    Else
      PbPDF_TTFWriteU32(*dst, locaTblOffset + gi * 4, curGlyfOffset)
    EndIf
    curGlyfOffset + *gml\length
    ; 4字节对齐
    If *gml\length > 0
      curGlyfOffset + (4 - (*gml\length % 4)) % 4
    EndIf
  Next
  ; 写入最后一个loca条目(指向glyf表末尾)
  If *attr\locaFormat = 0
    PbPDF_TTFWriteU16(*dst, locaTblOffset + totalGlyphs * 2, curGlyfOffset / 2)
  Else
    PbPDF_TTFWriteU32(*dst, locaTblOffset + totalGlyphs * 4, curGlyfOffset)
  EndIf
  ;--- 写入glyf表 ---
  curGlyfOffset = 0
  For gi = 0 To totalGlyphs - 1
    Protected *gmg.PbPDF_GlyphMapEntry = *glyphMap + gi * SizeOf(PbPDF_GlyphMapEntry)
    If *gmg\length > 0 And *gmg\offset >= 0 And *attr\glyfTable
      ; 检查偏移是否在有效范围内
      If *gmg\offset + *gmg\length <= *attr\glyfTableSize
        CopyMemory(*attr\glyfTable + *gmg\offset, *dst + glyfTblOffset + curGlyfOffset, *gmg\length)
        ; 处理复合字形：需要更新componentGlyphID
        ; 读取字形头部的numberOfContours(有符号16位，-1表示复合字形)
        Protected numContoursRaw.i = (PeekA(*dst + glyfTblOffset + curGlyfOffset) & $FF) << 8 | (PeekA(*dst + glyfTblOffset + curGlyfOffset + 1) & $FF)
        If numContoursRaw = $FFFF Or (numContoursRaw & $8000)
          ; 复合字形：需要遍历组件并更新GID引用
          Protected compOff.i = glyfTblOffset + curGlyfOffset + 10
          Protected compFlags.i
          Protected maxCompOff.i = glyfTblOffset + curGlyfOffset + *gmg\length - 4
          Repeat
            If compOff > maxCompOff
              Break
            EndIf
            compFlags = (PeekA(*dst + compOff) & $FF) << 8 | (PeekA(*dst + compOff + 1) & $FF)
            Protected compGID.i = (PeekA(*dst + compOff + 2) & $FF) << 8 | (PeekA(*dst + compOff + 3) & $FF)
            ; 查找旧GID在新映射表中的位置
            Protected ci.i
            For ci = 0 To totalGlyphs - 1
              Protected *gmc.PbPDF_GlyphMapEntry = *glyphMap + ci * SizeOf(PbPDF_GlyphMapEntry)
              If *gmc\oldGID = compGID
                PbPDF_TTFWriteU16(*dst, compOff + 2, *gmc\newGID)
                Break
              EndIf
            Next
            ; 跳到下一个组件
            compOff + 4
            If compFlags & $0001  ; ARG_1_AND_2_ARE_WORDS
              compOff + 4
            Else
              compOff + 2
            EndIf
            If compFlags & $0008  ; WE_HAVE_A_SCALE
              compOff + 2
            ElseIf compFlags & $0040  ; WE_HAVE_AN_X_AND_Y_SCALE
              compOff + 4
            ElseIf compFlags & $0080  ; WE_HAVE_A_TWO_BY_TWO
              compOff + 8
            EndIf
          Until compFlags & $0020  ; MORE_COMPONENTS
        EndIf
      EndIf
    EndIf
    curGlyfOffset + *gmg\length
    If *gmg\length > 0
      curGlyfOffset + (4 - (*gmg\length % 4)) % 4
    EndIf
  Next
  ;--- 写入name表(从原始字体复制) ---
  Protected nameSrcOffset.i = PbPDF_TTFFindTable(*srcHead, "name", *attr\offsetTbl\numTables)
  If nameSrcOffset >= 0
    Protected nameSrcLen.i = 0
    Protected ni.i
    For ni = 0 To *attr\offsetTbl\numTables - 1
      Protected eOff.i = 12 + ni * 16
      Protected t$ = ""
      t$ + Chr(PeekA(*srcHead + eOff))
      t$ + Chr(PeekA(*srcHead + eOff + 1))
      t$ + Chr(PeekA(*srcHead + eOff + 2))
      t$ + Chr(PeekA(*srcHead + eOff + 3))
      If t$ = "name"
        nameSrcLen = PbPDF_TTFReadU32(*srcHead, eOff + 12)
        Break
      EndIf
    Next
    If nameSrcLen > 0 And nameSrcLen <= 512
      ; 限制name表大小不超过512字节(分配空间)
      Protected nameCopyLen.i = nameSrcLen
      CopyMemory(*srcHead + nameSrcOffset, *dst + nameTblOffset, nameCopyLen)
    EndIf
  EndIf
  ;--- 写入post表(从原始字体复制) ---
  Protected postSrcOffset.i = PbPDF_TTFFindTable(*srcHead, "post", *attr\offsetTbl\numTables)
  If postSrcOffset >= 0
    CopyMemory(*srcHead + postSrcOffset, *dst + postTblOffset, 32)
  EndIf
  ; 计算实际总大小
  ; curGlyfOffset是glyf表内最后一个字形后的偏移
  ; 实际总大小 = glyfTblOffset + curGlyfOffset(即glyf表结束位置)
  ; 但如果后面还有name和post表，需要取最大值
  Protected actualSize.i = glyfTblOffset + curGlyfOffset
  ; name表和post表在glyf表之后，取最大值
  If postTblOffset + 32 > actualSize
    actualSize = postTblOffset + 32
  EndIf
  ; 更新输出大小
  If *subsetSize
    PokeI(*subsetSize, actualSize)
  EndIf
  ; 释放字形映射表
  FreeMemory(*glyphMap)
  ProcedureReturn *subsetBuf
EndProcedure

;--- 生成CIDFont的ToUnicode CMap ---
; 映射原始GID(作为CID)到Unicode码点
; 这是CIDFont Type2 + Identity-H编码的正确映射方式
; 内容流中使用原始GID作为CID，ToUnicode CMap将CID映射回Unicode
Procedure.i PbPDF_CreateCIDFontToUnicodeCMap(*doc.PbPDF_Doc, *fontDef.PbPDF_FontDef)
  If Not *doc Or Not *fontDef Or Not *fontDef\attr
    ProcedureReturn 0
  EndIf
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  If Not *attr\usedGIDs
    ProcedureReturn 0
  EndIf
  Protected usedCount.i = PbPDF_ListCount(*attr\usedGIDs)
  If usedCount = 0
    ProcedureReturn 0
  EndIf
  ; 创建CMap内容流
  Protected *cmapStream.PbPDF_Stream = PbPDF_MemStreamNew()
  If Not *cmapStream
    ProcedureReturn 0
  EndIf
  ; 写入CMap头部
  PbPDF_StreamWriteStr(*cmapStream, "/CIDInit /ProcSet findresource begin" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "12 dict begin" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "begincmap" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CIDSystemInfo" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "<< /Registry (Adobe)" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/Ordering (UCS)" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/Supplement 0 >> def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CMapName /Adobe-Identity-UCS def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CMapType 2 def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "1 begincodespacerange" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "<0000> <FFFF>" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "endcodespacerange" + #LF$)
  ; 收集字形到Unicode映射
  ; 使用原始GID作为CID，映射到Unicode码点
  Protected totalMappings.i = usedCount
  ; 分批写入(每批最多100条)
  Protected batchStart.i = 0
  Protected batchSize.i = 100
  While batchStart < totalMappings
    Protected batchEnd.i = batchStart + batchSize
    If batchEnd > totalMappings
      batchEnd = totalMappings
    EndIf
    Protected batchCount.i = batchEnd - batchStart
    PbPDF_StreamWriteStr(*cmapStream, Str(batchCount) + " beginbfchar" + #LF$)
    Protected bi.i
    For bi = batchStart To batchEnd - 1
      ; 获取原始GID(作为CID)
      Protected oldGID.i = PbPDF_ListGetPointer(*attr\usedGIDs, bi)
      Protected unicode.i = 0
      ; 从cmap范围反向查找原始GID对应的Unicode码点
      If *attr\cmapRanges And *attr\numCmapRanges > 0
        Protected ri.i
        For ri = 0 To *attr\numCmapRanges - 1
          Protected *range.PbPDF_TTFCmapRange = *attr\cmapRanges\items + ri * SizeOf(PbPDF_TTFCmapRange)
          Protected ui.i
          For ui = *range\startCode To *range\endCode
            Protected gid.i
            If *range\idRangeOffset = 0
              gid = (ui + *range\idDelta) & $FFFF
            Else
              ; 使用正确的idRangeOffset查找方式
              If *attr\fontDataBuf
                Protected glyphArrayOff.i = *range\idRangeOffsetEntryOff + *range\idRangeOffset + 2 * (ui - *range\startCode)
                gid = PbPDF_TTFReadU16(*attr\fontDataBuf, glyphArrayOff)
                If gid <> 0
                  gid = (gid + *range\idDelta) & $FFFF
                EndIf
              Else
                gid = (ui - *range\startCode + *range\idDelta) & $FFFF
              EndIf
            EndIf
            If gid = oldGID
              unicode = ui
              Break 2
            EndIf
          Next
        Next
      EndIf
      ; 写入映射: <原始GID(CID)> <Unicode>
      PbPDF_StreamWriteStr(*cmapStream, "<" + RSet(Hex(oldGID), 4, "0") + "> <" + RSet(Hex(unicode), 4, "0") + ">" + #LF$)
    Next
    PbPDF_StreamWriteStr(*cmapStream, "endbfchar" + #LF$)
    batchStart = batchEnd
  Wend
  ; 写入CMap尾部
  PbPDF_StreamWriteStr(*cmapStream, "endcmap" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "CMapName currentdict /CMap defineresource pop" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "end" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "end" + #LF$)
  ; 创建CMap流字典对象
  Protected *cmapDict.PbPDF_Object = PbPDF_DictNew()
  *cmapDict\stream = *cmapStream
  PbPDF_DictAddNumber(*cmapDict, "Length", *cmapStream\size)
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *cmapDict)
  EndIf
  ProcedureReturn *cmapDict
EndProcedure

;--- 生成子集化字体的ToUnicode CMap ---
; 基于已使用的字形生成精确的Unicode映射
Procedure.i PbPDF_CreateSubsetToUnicodeCMap(*doc.PbPDF_Doc, *fontDef.PbPDF_FontDef)
  If Not *doc Or Not *fontDef Or Not *fontDef\attr
    ProcedureReturn 0
  EndIf
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  If Not *attr\usedGIDs
    ProcedureReturn 0
  EndIf
  Protected usedCount.i = PbPDF_ListCount(*attr\usedGIDs)
  If usedCount = 0
    ProcedureReturn 0
  EndIf
  ; 创建CMap内容流
  Protected *cmapStream.PbPDF_Stream = PbPDF_MemStreamNew()
  If Not *cmapStream
    ProcedureReturn 0
  EndIf
  ; 写入CMap头部
  PbPDF_StreamWriteStr(*cmapStream, "/CIDInit /ProcSet findresource begin" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "12 dict begin" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "begincmap" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CIDSystemInfo" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "<< /Registry (Adobe)" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/Ordering (UCS)" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/Supplement 0 >> def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CMapName /Adobe-Identity-UCS def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "/CMapType 2 def" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "1 begincodespacerange" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "<0000> <FFFF>" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "endcodespacerange" + #LF$)
  ; 收集字形到Unicode映射
  ; 新GID: 0=.notdef, 1..n=已使用字形
  ; 使用beginbfchar逐个映射
  Protected totalMappings.i = usedCount + 1  ; 包含.notdef
  ; 分批写入(每批最多100条)
  Protected batchStart.i = 0
  Protected batchSize.i = 100
  While batchStart < totalMappings
    Protected batchEnd.i = batchStart + batchSize
    If batchEnd > totalMappings
      batchEnd = totalMappings
    EndIf
    Protected batchCount.i = batchEnd - batchStart
    PbPDF_StreamWriteStr(*cmapStream, Str(batchCount) + " beginbfchar" + #LF$)
    Protected bi.i
    For bi = batchStart To batchEnd - 1
      Protected newGID.i = bi
      Protected unicode.i = 0
      If bi = 0
        ; .notdef
        unicode = 0
      Else
        ; 查找此字形对应的Unicode
        Protected oldGID.i = PbPDF_ListGetPointer(*attr\usedGIDs, bi - 1)
        ; 从cmap范围反向查找Unicode
        If *attr\cmapRanges And *attr\numCmapRanges > 0
          Protected ri.i
          For ri = 0 To *attr\numCmapRanges - 1
            Protected *range.PbPDF_TTFCmapRange = *attr\cmapRanges\items + ri * SizeOf(PbPDF_TTFCmapRange)
            Protected ui.i
            For ui = *range\startCode To *range\endCode
              Protected gid.i
              If *range\idRangeOffset = 0
                gid = (ui + *range\idDelta) & $FFFF
              Else
                ; 使用正确的idRangeOffset查找方式
                If *attr\fontDataBuf
                  Protected glyphArrayOff.i = *range\idRangeOffsetEntryOff + *range\idRangeOffset + 2 * (ui - *range\startCode)
                  gid = PbPDF_TTFReadU16(*attr\fontDataBuf, glyphArrayOff)
                  If gid <> 0
                    gid = (gid + *range\idDelta) & $FFFF
                  EndIf
                Else
                  gid = (ui - *range\startCode + *range\idDelta) & $FFFF
                EndIf
              EndIf
              If gid = oldGID
                unicode = ui
                Break 2
              EndIf
            Next
          Next
        EndIf
      EndIf
      ; 写入映射: <新GID> <Unicode>
      PbPDF_StreamWriteStr(*cmapStream, "<" + RSet(Hex(newGID), 4, "0") + "> <" + RSet(Hex(unicode), 4, "0") + ">" + #LF$)
    Next
    PbPDF_StreamWriteStr(*cmapStream, "endbfchar" + #LF$)
    batchStart = batchEnd
  Wend
  ; 写入CMap尾部
  PbPDF_StreamWriteStr(*cmapStream, "endcmap" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "CMapName currentdict /CMap defineresource pop" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "end" + #LF$)
  PbPDF_StreamWriteStr(*cmapStream, "end" + #LF$)
  ; 创建CMap流字典对象
  Protected *cmapDict.PbPDF_Object = PbPDF_DictNew()
  *cmapDict\stream = *cmapStream
  PbPDF_DictAddNumber(*cmapDict, "Length", *cmapStream\size)
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *cmapDict)
  EndIf
  ProcedureReturn *cmapDict
EndProcedure

;--- 创建CIDFont Type0字体字典结构 ---
; 对于TrueType字体，使用CIDFont Type2 + Type0复合字体结构
; CIDToGIDMap设为/Identity，表示CID直接对应字体中的字形索引(GID)
; 内容流中使用原始GID作为CID，ToUnicode CMap映射原始GID到Unicode
Procedure.i PbPDF_CreateCIDFontDict(*doc.PbPDF_Doc, *font.PbPDF_Font)
  If Not *doc Or Not *font Or Not *font\fontDef
    ProcedureReturn 0
  EndIf
  Protected *fontDef.PbPDF_FontDef = *font\fontDef
  Protected *attr.PbPDF_TTFontAttr = *fontDef\attr
  If Not *attr
    ProcedureReturn 0
  EndIf
  ; 生成子集前缀(6个大写字母)
  Protected subsetPrefix$ = ""
  Protected pi.i
  For pi = 0 To 5
    subsetPrefix$ + Chr(65 + Random(25))
  Next
  ; 设置子集化字体名
  Protected baseFontName$ = subsetPrefix$ + "+" + *fontDef\baseFont
  ;--- 字体子集化 ---
  ; 尝试创建子集化字体数据(只包含已使用的字形)
  ; 如果子集化失败，回退到嵌入完整字体
  Protected *subsetData = 0
  Protected subsetSize.i = 0
  Protected useSubset.i = #False
  Protected usedCount.i = 0
  If *attr\usedGIDs
    usedCount = PbPDF_ListCount(*attr\usedGIDs)
  EndIf
  If usedCount > 0 And usedCount < *attr\numGlyphs * 80 / 100
    *subsetData = PbPDF_TTFontCreateSubset(*fontDef, @subsetSize)
    If *subsetData And subsetSize > 0
      useSubset = #True
    EndIf
  EndIf
  ;--- 创建字体流 ---
  Protected *fontStream.PbPDF_Stream = PbPDF_MemStreamNew()
  Protected fontDataSize.i
  If useSubset
    ; 使用子集化字体数据
    fontDataSize = subsetSize
    If *fontStream
      PbPDF_StreamWriteData(*fontStream, *subsetData, subsetSize)
    EndIf
  Else
    ; 回退：使用完整字体数据
    fontDataSize = *attr\fontDataSize
    If *fontStream
      If *attr\fontDataBuf And *attr\fontDataSize > 0
        PbPDF_StreamWriteData(*fontStream, *attr\fontDataBuf, *attr\fontDataSize)
      EndIf
    EndIf
  EndIf
  ; 创建字体流字典(FontFile2)
  Protected *fontFileDict.PbPDF_Object = PbPDF_DictNew()
  *fontFileDict\stream = *fontStream
  PbPDF_DictAddNumber(*fontFileDict, "Length1", fontDataSize)
  PbPDF_DictAddNumber(*fontFileDict, "Length2", 0)
  PbPDF_DictAddNumber(*fontFileDict, "Length3", 0)
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *fontFileDict)
  EndIf
  ; 计算缩放因子
  Protected scale.f = 1000.0 / *attr\header\unitsPerEm
  ; 创建FontDescriptor字典
  Protected *fontDesc.PbPDF_Object = PbPDF_DictNew()
  PbPDF_DictAddName(*fontDesc, "Type", "FontDescriptor")
  PbPDF_DictAddName(*fontDesc, "FontName", baseFontName$)
  PbPDF_DictAddNumber(*fontDesc, "Flags", *fontDef\flags)
  ; FontBBox
  Protected *bbox.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_ArrayAdd(*bbox, PbPDF_NumberNew(Int(*fontDef\fontBBox\left * scale)))
  PbPDF_ArrayAdd(*bbox, PbPDF_NumberNew(Int(*fontDef\fontBBox\bottom * scale)))
  PbPDF_ArrayAdd(*bbox, PbPDF_NumberNew(Int(*fontDef\fontBBox\right * scale)))
  PbPDF_ArrayAdd(*bbox, PbPDF_NumberNew(Int(*fontDef\fontBBox\top * scale)))
  PbPDF_DictAdd(*fontDesc, "FontBBox", *bbox)
  PbPDF_DictAddNumber(*fontDesc, "ItalicAngle", *fontDef\italicAngle)
  PbPDF_DictAddNumber(*fontDesc, "Ascent", Int(*fontDef\ascent * scale))
  PbPDF_DictAddNumber(*fontDesc, "Descent", Int(*fontDef\descent * scale))
  PbPDF_DictAddNumber(*fontDesc, "CapHeight", Int(*fontDef\capHeight * scale))
  PbPDF_DictAddNumber(*fontDesc, "StemV", *fontDef\stemV)
  PbPDF_DictAdd(*fontDesc, "FontFile2", *fontFileDict)
  ; 注册FontDescriptor到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *fontDesc)
  EndIf
  ; 创建CIDSystemInfo字典
  Protected *cidSysInfo.PbPDF_Object = PbPDF_DictNew()
  PbPDF_DictAddString(*cidSysInfo, "Registry", "Adobe")
  PbPDF_DictAddString(*cidSysInfo, "Ordering", "Identity")
  PbPDF_DictAddNumber(*cidSysInfo, "Supplement", 0)
  ;--- 创建W数组(字形宽度) ---
  ; W数组中的CID必须与内容流中的CID一致
  ; 内容流中使用原始GID作为CID，所以W数组也必须使用原始GID
  ; 格式: c_first c_last width
  Protected *wArray.PbPDF_Object = PbPDF_ArrayNew()
  Protected wi.i
  For wi = 0 To usedCount - 1
    Protected oldGID.i = PbPDF_ListGetPointer(*attr\usedGIDs, wi)
    Protected width.i = PbPDF_TTFontGetAdvanceWidth(*fontDef, oldGID)
    If *attr\header\unitsPerEm > 0
      width = width * 1000 / *attr\header\unitsPerEm
    EndIf
    ; CID使用原始GID(与内容流中的CID一致)
    PbPDF_ArrayAdd(*wArray, PbPDF_NumberNew(oldGID))
    PbPDF_ArrayAdd(*wArray, PbPDF_NumberNew(oldGID))
    PbPDF_ArrayAdd(*wArray, PbPDF_NumberNew(width))
  Next
  ;--- 创建CIDFont字典(Type2 - TrueType轮廓) ---
  Protected *cidFont.PbPDF_Object = PbPDF_DictNew(#PbPDF_OSUBCLASS_FONT)
  PbPDF_DictAddName(*cidFont, "Type", "Font")
  PbPDF_DictAddName(*cidFont, "Subtype", "CIDFontType2")
  PbPDF_DictAddName(*cidFont, "BaseFont", baseFontName$)
  PbPDF_DictAdd(*cidFont, "CIDSystemInfo", *cidSysInfo)
  PbPDF_DictAdd(*cidFont, "FontDescriptor", *fontDesc)
  ;--- 设置CIDToGIDMap ---
  If useSubset
    ; 子集化字体：需要创建CIDToGIDMap映射流
    ; 内容流中使用原始GID作为CID，子集化字体中使用新GID
    ; 映射流格式：按CID顺序，每2字节存储对应的GID(大端序)
    ; CID范围从0到maxCID(最大原始GID)，未使用的CID映射到GID 0
    Protected maxCID.i = 0
    Protected gi.i
    For gi = 0 To usedCount - 1
      Protected cid.i = PbPDF_ListGetPointer(*attr\usedGIDs, gi)
      If cid > maxCID
        maxCID = cid
      EndIf
    Next
    ; 创建CIDToGIDMap流
    Protected *cidToGidStream.PbPDF_Stream = PbPDF_MemStreamNew()
    If *cidToGidStream
      ; 分配映射表(从CID 0到maxCID，每项2字节)
      ; 初始化所有映射为0(未使用的CID映射到.notdef)
      Protected mapSize.i = (maxCID + 1) * 2
      Protected *mapBuf = AllocateMemory(mapSize)
      If *mapBuf
        FillMemory(*mapBuf, mapSize, 0)
        ; 设置已使用字形的映射: CID(原始GID) -> newGID
        For gi = 0 To usedCount - 1
          Protected srcCID.i = PbPDF_ListGetPointer(*attr\usedGIDs, gi)
          Protected dstGID.i = gi + 1  ; 新GID从1开始
          ; 写入2字节大端序GID
          PokeA(*mapBuf + srcCID * 2, (dstGID >> 8) & $FF)
          PokeA(*mapBuf + srcCID * 2 + 1, dstGID & $FF)
        Next
        ; .notdef: CID 0 -> GID 0
        PokeA(*mapBuf, 0)
        PokeA(*mapBuf + 1, 0)
        PbPDF_StreamWriteData(*cidToGidStream, *mapBuf, mapSize)
        FreeMemory(*mapBuf)
      EndIf
    EndIf
    ; 创建CIDToGIDMap流字典
    Protected *cidToGidDict.PbPDF_Object = PbPDF_DictNew()
    *cidToGidDict\stream = *cidToGidStream
    PbPDF_DictAddNumber(*cidToGidDict, "Length", *cidToGidStream\size)
    If *doc\xref
      PbPDF_XRefAdd(*doc\xref, *cidToGidDict)
    EndIf
    PbPDF_DictAdd(*cidFont, "CIDToGIDMap", *cidToGidDict)
  Else
    ; 完整字体：CID直接对应GID，使用/Identity
    PbPDF_DictAddName(*cidFont, "CIDToGIDMap", "Identity")
  EndIf
  If PbPDF_ArrayGetCount(*wArray) > 0
    PbPDF_DictAdd(*cidFont, "W", *wArray)
  EndIf
  ; 默认宽度(DW)
  Protected defWidth.i = 1000
  If *attr\header\unitsPerEm > 0
    defWidth = *attr\header\unitsPerEm / 2 * 1000 / *attr\header\unitsPerEm
  EndIf
  PbPDF_DictAddNumber(*cidFont, "DW", defWidth)
  ; 注册CIDFont到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *cidFont)
  EndIf
  ;--- 创建ToUnicode CMap ---
  ; 子集化模式：映射原始GID(CID)到Unicode
  ; 完整字体模式：同样映射原始GID(CID)到Unicode
  Protected *toUnicode.PbPDF_Object = PbPDF_CreateCIDFontToUnicodeCMap(*doc, *fontDef)
  ;--- 创建Type0字体字典(复合字体) ---
  Protected *type0Font.PbPDF_Object = PbPDF_DictNew(#PbPDF_OSUBCLASS_FONT)
  PbPDF_DictAddName(*type0Font, "Type", "Font")
  PbPDF_DictAddName(*type0Font, "Subtype", "Type0")
  PbPDF_DictAddName(*type0Font, "BaseFont", baseFontName$)
  ; Encoding使用Identity-H
  PbPDF_DictAddName(*type0Font, "Encoding", "Identity-H")
  ; DescendantFonts数组
  Protected *descFonts.PbPDF_Object = PbPDF_ArrayNew()
  PbPDF_ArrayAdd(*descFonts, *cidFont)
  PbPDF_DictAdd(*type0Font, "DescendantFonts", *descFonts)
  ; ToUnicode CMap
  If *toUnicode
    PbPDF_DictAdd(*type0Font, "ToUnicode", *toUnicode)
  EndIf
  ; 注册Type0字体到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *type0Font)
  EndIf
  *font\fontObj = *type0Font
  *font\descendantFont = *cidFont
  *font\mapStream = *toUnicode
  ; 释放子集化字体数据
  If *subsetData
    FreeMemory(*subsetData)
  EndIf
  ProcedureReturn *type0Font
EndProcedure

;--- 注册CIDFont到页面 ---
; 仅注册字体名称，字体字典将在保存时创建(延迟创建以支持子集化)
Procedure.s PbPDF_RegisterCIDFont(*doc.PbPDF_Doc, *pageObj.PbPDF_Object, *font.PbPDF_Font)
  If Not *doc Or Not *pageObj Or Not *font
    ProcedureReturn ""
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn ""
  EndIf
  ; 确保页面有字体资源字典
  If Not *pageAttr\fonts
    *pageAttr\fonts = PbPDF_DictNew()
    Protected *resources.PbPDF_Object = PbPDF_DictGetValue(*pageObj, "Resources")
    If Not *resources
      *resources = PbPDF_DictNew()
      PbPDF_DictAdd(*pageObj, "Resources", *resources)
    EndIf
    PbPDF_DictAdd(*resources, "Font", *pageAttr\fonts)
  EndIf
  ; 使用本地名称注册
  Protected localName$ = *font\localName
  ; 检查当前页面是否已注册该字体
  Protected *existing.PbPDF_Object = PbPDF_DictGetValue(*pageAttr\fonts, localName$)
  If *existing
    ProcedureReturn localName$
  EndIf
  ; 如果字体已有fontObj(在其他页面已创建占位符)，直接复用
  ; 这样所有页面共享同一个占位符，保存时只需替换一次
  If *font\fontObj
    PbPDF_DictAdd(*pageAttr\fonts, localName$, *font\fontObj)
    ProcedureReturn localName$
  EndIf
  ; 首次注册：创建一个占位符字典(将在保存时替换为真正的CIDFont字典)
  Protected *placeholder.PbPDF_Object = PbPDF_DictNew(#PbPDF_OSUBCLASS_FONT)
  PbPDF_DictAddName(*placeholder, "Type", "Font")
  PbPDF_DictAddName(*placeholder, "Subtype", "Type0")
  PbPDF_DictAddName(*placeholder, "BaseFont", *font\fontDef\baseFont)
  PbPDF_DictAddName(*placeholder, "Encoding", "Identity-H")
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *placeholder)
  EndIf
  ; 添加到页面字体资源
  PbPDF_DictAdd(*pageAttr\fonts, localName$, *placeholder)
  ; 保存占位符引用(保存时将替换为完整CIDFont)
  *font\fontObj = *placeholder
  ProcedureReturn localName$
EndProcedure

;--- 使用TTF字体显示UTF-8文本(完整流程) ---
; 自动注册字体、标记已使用字形、生成十六进制编码
Procedure PbPDF_Page_ShowTextUTF8Ex(*doc.PbPDF_Doc, *pageObj.PbPDF_Object, *font.PbPDF_Font, text$, fontSize.f)
  If Not *doc Or Not *pageObj Or Not *font
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If Not *stream
    ProcedureReturn
  EndIf
  Protected *fontDef.PbPDF_FontDef = *font\fontDef
  If Not *fontDef
    ProcedureReturn
  EndIf
  ; 先标记文本中使用的字形(用于子集化，必须在注册字体之前)
  Protected *buf = AllocateMemory(StringByteLength(text$, #PB_UTF8) + 4)
  If *buf
    PokeS(*buf, text$, -1, #PB_UTF8)
    Protected bufLen.i = StringByteLength(text$, #PB_UTF8)
    Protected i.i, byteCount.i, unicode.l
    Protected *srcPtr.Byte = *buf
    i = 0
    While i < bufLen
      unicode = PbPDF_UTF8Decode(*srcPtr + i, bufLen - i, @byteCount)
      i + byteCount
      PbPDF_TTFontMarkGlyphUsed(*fontDef, unicode)
    Wend
    FreeMemory(*buf)
  EndIf
  ; 注册CIDFont到页面(延迟创建，只注册名称)
  Protected localName$ = PbPDF_RegisterCIDFont(*doc, *pageObj, *font)
  If localName$ = ""
    ProcedureReturn
  EndIf
  ; 设置字体和大小
  PbPDF_StreamWriteStr(*stream, "/" + localName$ + " " + StrF(fontSize, 2) + " Tf" + #LF$)
  ; 编码文本为GID十六进制字符串
  ; 对于CIDFont Type2，使用字形ID作为CID
  Protected hex$ = ""
  *buf = AllocateMemory(StringByteLength(text$, #PB_UTF8) + 4)
  If *buf
    PokeS(*buf, text$, -1, #PB_UTF8)
    bufLen = StringByteLength(text$, #PB_UTF8)
    *srcPtr = *buf
    i = 0
    While i < bufLen
      unicode = PbPDF_UTF8Decode(*srcPtr + i, bufLen - i, @byteCount)
      i + byteCount
      ; 获取字形ID
      Protected gid.i = PbPDF_TTFontGetGlyphID(*fontDef, unicode)
      ; 编码为2字节十六进制(高字节在前)
      hex$ + RSet(Hex((gid >> 8) & $FF), 2, "0")
      hex$ + RSet(Hex(gid & $FF), 2, "0")
    Wend
    FreeMemory(*buf)
  EndIf
  If hex$ <> ""
    PbPDF_StreamWriteStr(*stream, "<" + hex$ + "> Tj" + #LF$)
  EndIf
EndProcedure

;--- 设置压缩模式 ---
Procedure PbPDF_SetCompressionMode(*doc.PbPDF_Doc, mode.i)
  If *doc
    *doc\compressionMode = mode
  EndIf
EndProcedure

;=============================================================================
; 第22部分：图片处理
;=============================================================================

;--- JPEG标记常量 ---
#PbPDF_JPEG_SOI  = $FFD8   ; Start Of Image
#PbPDF_JPEG_EOI  = $FFD9   ; End Of Image
#PbPDF_JPEG_SOF0 = $FFC0   ; Start Of Frame (Baseline)
#PbPDF_JPEG_SOF1 = $FFC1   ; Start Of Frame (Extended Sequential)
#PbPDF_JPEG_SOF2 = $FFC2   ; Start Of Frame (Progressive)
#PbPDF_JPEG_SOF9 = $FFC9   ; Start Of Frame (Extended Sequential, Arithmetic)
#PbPDF_JPEG_SOS  = $FFDA   ; Start Of Scan
#PbPDF_JPEG_APP0 = $FFE0   ; APP0 marker (JFIF)
#PbPDF_JPEG_APP1 = $FFE1   ; APP1 marker (EXIF)

;--- PNG签名 ---
#PbPDF_PNG_SIGNATURE = $89504E47

;--- 解析JPEG文件头信息 ---
; 从JPEG数据中提取宽度、高度和颜色空间
Procedure.i PbPDF_ParseJPEGHeader(*buf, bufSize.i, *width.Integer, *height.Integer, *colorSpace.Integer, *bitsPerComp.Integer)
  If Not *buf Or bufSize < 4
    ProcedureReturn #PbPDF_ERR_INVALID_IMAGE
  EndIf
  ; 验证JPEG签名(SOI标记 = 0xFFD8)
  Protected tag.i = ((PeekA(*buf) & $FF) << 8) | (PeekA(*buf + 1) & $FF)
  If tag <> #PbPDF_JPEG_SOI
    ProcedureReturn #PbPDF_ERR_INVALID_IMAGE
  EndIf
  ; 遍历JPEG标记段，寻找SOF(Start Of Frame)记录
  Protected offset.i = 2
  While offset < bufSize - 4
    ; 读取标记
    Protected marker.i = ((PeekA(*buf + offset) & $FF) << 8) | (PeekA(*buf + offset + 1) & $FF)
    offset + 2
    ; 检查是否为SOF标记
    If marker = #PbPDF_JPEG_SOF0 Or marker = #PbPDF_JPEG_SOF1 Or marker = #PbPDF_JPEG_SOF2 Or marker = #PbPDF_JPEG_SOF9
      ; SOF段结构: [长度2字节][精度1字节][高度2字节][宽度2字节][分量数1字节]
      If offset + 6 > bufSize
        ProcedureReturn #PbPDF_ERR_INVALID_IMAGE
      EndIf
      ; 跳过段长度(2字节)
      Protected segLen.i = ((PeekA(*buf + offset) & $FF) << 8) | (PeekA(*buf + offset + 1) & $FF)
      ; 精度(1字节)
      Protected precision.i = PeekA(*buf + offset + 2) & $FF
      ; 高度(2字节,大端序)
      Protected h.i = ((PeekA(*buf + offset + 3) & $FF) << 8) | (PeekA(*buf + offset + 4) & $FF)
      ; 宽度(2字节,大端序)
      Protected w.i = ((PeekA(*buf + offset + 5) & $FF) << 8) | (PeekA(*buf + offset + 6) & $FF)
      ; 颜色分量数(1字节)
      Protected numComp.i = PeekA(*buf + offset + 7) & $FF
      ; 设置输出参数
      If *width
        PokeI(*width, w)
      EndIf
      If *height
        PokeI(*height, h)
      EndIf
      If *bitsPerComp
        PokeI(*bitsPerComp, precision)
      EndIf
      ; 根据颜色分量数确定颜色空间
      If *colorSpace
        Select numComp
          Case 1
            PokeI(*colorSpace, #PbPDF_CS_DEVICEGRAY)
          Case 3
            PokeI(*colorSpace, #PbPDF_CS_DEVICERGB)
          Case 4
            PokeI(*colorSpace, #PbPDF_CS_DEVICECMYK)
          Default
            PokeI(*colorSpace, #PbPDF_CS_DEVICERGB)
        EndSelect
      EndIf
      ProcedureReturn #PbPDF_OK
    ElseIf (marker & $FF00) = $FF00 And marker <> #PbPDF_JPEG_SOI And marker <> #PbPDF_JPEG_EOI And marker <> $FF00
      ; 非SOF标记：跳过该段
      If marker = #PbPDF_JPEG_SOS
        ; SOS标记后是压缩数据，不再有标记段
        Break
      EndIf
      ; 读取段长度并跳过
      If offset + 2 > bufSize
        Break
      EndIf
      Protected skipLen.i = ((PeekA(*buf + offset) & $FF) << 8) | (PeekA(*buf + offset + 1) & $FF)
      offset + skipLen
    Else
      ; 未知标记或填充字节，跳过
      offset + 1
    EndIf
  Wend
  ProcedureReturn #PbPDF_ERR_INVALID_IMAGE
EndProcedure

;--- 从文件加载JPEG图片 ---
; 读取JPEG文件并创建PDF图像对象
Procedure.i PbPDF_LoadJPEGImageFromFile(*doc.PbPDF_Doc, fileName$)
  If Not *doc
    ProcedureReturn 0
  EndIf
  ; 读取文件
  Protected fileID.i = ReadFile(#PB_Any, fileName$)
  If fileID = 0
    ProcedureReturn 0
  EndIf
  Protected fileSize.i = Lof(fileID)
  If fileSize <= 0
    CloseFile(fileID)
    ProcedureReturn 0
  EndIf
  Protected *buf = AllocateMemory(fileSize)
  If Not *buf
    CloseFile(fileID)
    ProcedureReturn 0
  EndIf
  If ReadData(fileID, *buf, fileSize) <> fileSize
    CloseFile(fileID)
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  CloseFile(fileID)
  ; 解析JPEG头信息
  Protected imgWidth.i, imgHeight.i, imgCS.i, imgBPC.i
  Protected result.i = PbPDF_ParseJPEGHeader(*buf, fileSize, @imgWidth, @imgHeight, @imgCS, @imgBPC)
  If result <> #PbPDF_OK
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  ; 创建图片对象
  Protected *image.PbPDF_Image = AllocateMemory(SizeOf(PbPDF_Image))
  If Not *image
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  InitializeStructure(*image, PbPDF_Image)
  *image\imageType = #PbPDF_IMAGE_JPEG
  *image\width = imgWidth
  *image\height = imgHeight
  *image\colorSpace = imgCS
  *image\bitsPerComponent = imgBPC
  ; 创建PDF图像字典对象
  Protected *imageDict.PbPDF_Object = PbPDF_DictNew(#PbPDF_OSUBCLASS_XOBJECT)
  ; 创建图像数据流
  Protected *imageStream.PbPDF_Stream = PbPDF_MemStreamNew()
  If Not *imageStream
    FreeMemory(*buf)
    FreeMemory(*image)
    ProcedureReturn 0
  EndIf
  ; 将JPEG数据写入流(不需要解码，直接嵌入)
  PbPDF_StreamWriteData(*imageStream, *buf, fileSize)
  FreeMemory(*buf)
  *imageDict\stream = *imageStream
  ; 设置图像字典属性
  PbPDF_DictAddName(*imageDict, "Type", "XObject")
  PbPDF_DictAddName(*imageDict, "Subtype", "Image")
  PbPDF_DictAddNumber(*imageDict, "Width", imgWidth)
  PbPDF_DictAddNumber(*imageDict, "Height", imgHeight)
  ; 设置颜色空间
  Select imgCS
    Case #PbPDF_CS_DEVICEGRAY
      PbPDF_DictAddName(*imageDict, "ColorSpace", "DeviceGray")
    Case #PbPDF_CS_DEVICERGB
      PbPDF_DictAddName(*imageDict, "ColorSpace", "DeviceRGB")
    Case #PbPDF_CS_DEVICECMYK
      PbPDF_DictAddName(*imageDict, "ColorSpace", "DeviceCMYK")
      ; CMYK需要反转Decode数组
      Protected *decode.PbPDF_Object = PbPDF_ArrayNew()
      Protected di.i
      For di = 0 To 3
        PbPDF_ArrayAdd(*decode, PbPDF_NumberNew(1))
        PbPDF_ArrayAdd(*decode, PbPDF_NumberNew(0))
      Next
      PbPDF_DictAdd(*imageDict, "Decode", *decode)
  EndSelect
  PbPDF_DictAddNumber(*imageDict, "BitsPerComponent", imgBPC)
  ; JPEG使用DCTDecode过滤器
  PbPDF_DictAddName(*imageDict, "Filter", "DCTDecode")
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *imageDict)
  EndIf
  *image\imageObj = *imageDict
  ; 生成本地名称
  *image\localName = "Img" + Str(*doc\imageTagCounter)
  *doc\imageTagCounter + 1
  ; 添加到图片管理列表
  If *doc\imageMgr
    PbPDF_ListAddPointer(*doc\imageMgr, *image)
  EndIf
  ProcedureReturn *image
EndProcedure

;--- 解析PNG文件头信息 ---
; 从PNG数据中提取宽度、高度、位深和颜色类型
Procedure.i PbPDF_ParsePNGHeader(*buf, bufSize.i, *width.Integer, *height.Integer, *colorType.Integer, *bitDepth.Integer)
  If Not *buf Or bufSize < 29
    ProcedureReturn #PbPDF_ERR_INVALID_IMAGE
  EndIf
  ; 验证PNG签名(8字节: 89 50 4E 47 0D 0A 1A 0A)
  Protected sig.l = ((PeekA(*buf) & $FF) << 24) | ((PeekA(*buf + 1) & $FF) << 16) | ((PeekA(*buf + 2) & $FF) << 8) | (PeekA(*buf + 3) & $FF)
  If sig <> #PbPDF_PNG_SIGNATURE
    ProcedureReturn #PbPDF_ERR_INVALID_IMAGE
  EndIf
  ; IHDR段紧跟在PNG签名之后(偏移8)
  ; 段结构: [长度4字节][类型4字节][数据][CRC4字节]
  ; IHDR数据: [宽度4字节][高度4字节][位深1字节][颜色类型1字节][压缩1字节][过滤1字节][交错1字节]
  Protected chunkOffset.i = 8
  ; 读取IHDR段长度
  Protected chunkLen.l = ((PeekA(*buf + chunkOffset) & $FF) << 24) | ((PeekA(*buf + chunkOffset + 1) & $FF) << 16) | ((PeekA(*buf + chunkOffset + 2) & $FF) << 8) | (PeekA(*buf + chunkOffset + 3) & $FF)
  ; 读取IHDR段类型(应为"IHDR" = $49484452)
  Protected chunkType.l = ((PeekA(*buf + chunkOffset + 4) & $FF) << 24) | ((PeekA(*buf + chunkOffset + 5) & $FF) << 16) | ((PeekA(*buf + chunkOffset + 6) & $FF) << 8) | (PeekA(*buf + chunkOffset + 7) & $FF)
  If chunkType <> $49484452  ; "IHDR"
    ProcedureReturn #PbPDF_ERR_INVALID_IMAGE
  EndIf
  ; 读取IHDR数据
  Protected dataOffset.i = chunkOffset + 8
  If dataOffset + 13 > bufSize
    ProcedureReturn #PbPDF_ERR_INVALID_IMAGE
  EndIf
  ; 宽度(4字节,大端序)
  Protected w.l = ((PeekA(*buf + dataOffset) & $FF) << 24) | ((PeekA(*buf + dataOffset + 1) & $FF) << 16) | ((PeekA(*buf + dataOffset + 2) & $FF) << 8) | (PeekA(*buf + dataOffset + 3) & $FF)
  ; 高度(4字节,大端序)
  Protected h.l = ((PeekA(*buf + dataOffset + 4) & $FF) << 24) | ((PeekA(*buf + dataOffset + 5) & $FF) << 16) | ((PeekA(*buf + dataOffset + 6) & $FF) << 8) | (PeekA(*buf + dataOffset + 7) & $FF)
  ; 位深(1字节)
  Protected bd.i = PeekA(*buf + dataOffset + 8) & $FF
  ; 颜色类型(1字节)
  Protected ct.i = PeekA(*buf + dataOffset + 9) & $FF
  ; 设置输出参数
  If *width
    PokeI(*width, w)
  EndIf
  If *height
    PokeI(*height, h)
  EndIf
  If *bitDepth
    PokeI(*bitDepth, bd)
  EndIf
  If *colorType
    PokeI(*colorType, ct)
  EndIf
  ProcedureReturn #PbPDF_OK
EndProcedure

;--- PNG颜色类型常量 ---
#PbPDF_PNG_CT_GRAY       = 0   ; 灰度
#PbPDF_PNG_CT_RGB        = 2   ; RGB
#PbPDF_PNG_CT_PALETTE    = 3   ; 索引颜色(调色板)
#PbPDF_PNG_CT_GRAY_ALPHA = 4   ; 灰度+Alpha
#PbPDF_PNG_CT_RGBA       = 6   ; RGBA

;--- 从文件加载PNG图片(简化版：不支持Alpha通道和交错) ---
; 读取PNG文件并创建PDF图像对象
; 注意：此版本仅支持非交错、无Alpha的PNG(灰度/RGB/调色板)
Procedure.i PbPDF_LoadPNGImageFromFile(*doc.PbPDF_Doc, fileName$)
  If Not *doc
    ProcedureReturn 0
  EndIf
  ; 注册zlib压缩插件（UncompressMemory需要此插件）
  UseZipPacker()
  ; 读取文件
  Protected fileID.i = ReadFile(#PB_Any, fileName$)
  If fileID = 0
    ProcedureReturn 0
  EndIf
  Protected fileSize.i = Lof(fileID)
  If fileSize <= 0
    CloseFile(fileID)
    ProcedureReturn 0
  EndIf
  Protected *buf = AllocateMemory(fileSize)
  If Not *buf
    CloseFile(fileID)
    ProcedureReturn 0
  EndIf
  If ReadData(fileID, *buf, fileSize) <> fileSize
    CloseFile(fileID)
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  CloseFile(fileID)
  ; 解析PNG头信息
  Protected imgWidth.i, imgHeight.i, colorType.i, bitDepth.i
  Protected result.i = PbPDF_ParsePNGHeader(*buf, fileSize, @imgWidth, @imgHeight, @colorType, @bitDepth)
  If result <> #PbPDF_OK
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  ; 创建图片对象
  Protected *image.PbPDF_Image = AllocateMemory(SizeOf(PbPDF_Image))
  If Not *image
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  InitializeStructure(*image, PbPDF_Image)
  *image\imageType = #PbPDF_IMAGE_PNG
  *image\width = imgWidth
  *image\height = imgHeight
  *image\bitsPerComponent = bitDepth
  ; 确定颜色空间
  Protected csName$ = "DeviceRGB"
  Protected hasAlpha.i = #False
  Select colorType
    Case #PbPDF_PNG_CT_GRAY
      csName$ = "DeviceGray"
      *image\colorSpace = #PbPDF_CS_DEVICEGRAY
    Case #PbPDF_PNG_CT_RGB
      csName$ = "DeviceRGB"
      *image\colorSpace = #PbPDF_CS_DEVICERGB
    Case #PbPDF_PNG_CT_PALETTE
      csName$ = "Indexed"
      *image\colorSpace = #PbPDF_CS_INDEXED
    Case #PbPDF_PNG_CT_GRAY_ALPHA
      csName$ = "DeviceGray"
      *image\colorSpace = #PbPDF_CS_DEVICEGRAY
      hasAlpha = #True
    Case #PbPDF_PNG_CT_RGBA
      csName$ = "DeviceRGB"
      *image\colorSpace = #PbPDF_CS_DEVICERGB
      hasAlpha = #True
  EndSelect
  ; 解析PNG数据块，提取IDAT数据
  ; PNG数据块结构: [长度4字节][类型4字节][数据N字节][CRC4字节]
  Protected chunkOff.i = 8  ; 跳过PNG签名
  Protected *idatData = AllocateMemory(imgWidth * imgHeight * 4 + fileSize)
  Protected idatSize.i = 0
  Protected *paletteData = 0
  Protected paletteSize.i = 0
  While chunkOff < fileSize - 12
    Protected cLen.l = ((PeekA(*buf + chunkOff) & $FF) << 24) | ((PeekA(*buf + chunkOff + 1) & $FF) << 16) | ((PeekA(*buf + chunkOff + 2) & $FF) << 8) | (PeekA(*buf + chunkOff + 3) & $FF)
    Protected cType.l = ((PeekA(*buf + chunkOff + 4) & $FF) << 24) | ((PeekA(*buf + chunkOff + 5) & $FF) << 16) | ((PeekA(*buf + chunkOff + 6) & $FF) << 8) | (PeekA(*buf + chunkOff + 7) & $FF)
    If cLen > fileSize - chunkOff - 12
      Break
    EndIf
    Select cType
      Case $49444154  ; "IDAT"
        ; 复制IDAT数据
        If *idatData
          CopyMemory(*buf + chunkOff + 8, *idatData + idatSize, cLen)
          idatSize + cLen
        EndIf
      Case $504C5445  ; "PLTE" - 调色板
        *paletteData = AllocateMemory(cLen)
        If *paletteData
          CopyMemory(*buf + chunkOff + 8, *paletteData, cLen)
          paletteSize = cLen
        EndIf
      Case $49454E44  ; "IEND" - 结束
        Break
    EndSelect
    chunkOff + 12 + cLen  ; 4(长度) + 4(类型) + cLen(数据) + 4(CRC)
  Wend
  ; 解压缩IDAT数据(zlib/deflate)
  ; 使用PureBasic的UncompressFunction
  Protected *rawData = 0
  Protected rawSize.i = 0
  If idatSize > 0 And *idatData
    ; 估算解压后大小(每行 = 1(过滤类型) + 每像素字节数 * 宽度)
    Protected bytesPerPixel.i = 1
    Select colorType
      Case #PbPDF_PNG_CT_GRAY: bytesPerPixel = 1
      Case #PbPDF_PNG_CT_RGB: bytesPerPixel = 3
      Case #PbPDF_PNG_CT_PALETTE: bytesPerPixel = 1
      Case #PbPDF_PNG_CT_GRAY_ALPHA: bytesPerPixel = 2
      Case #PbPDF_PNG_CT_RGBA: bytesPerPixel = 4
    EndSelect
    If bitDepth = 16
      bytesPerPixel * 2
    EndIf
    Protected rowSize.i = 1 + bytesPerPixel * imgWidth
    rawSize = rowSize * imgHeight
    *rawData = AllocateMemory(rawSize + 1024)
    If *rawData
      ; 使用PureBasic内置的UncompressMemory解压zlib数据
      ; zlib数据格式: 2字节头 + deflate数据 + 4字节校验
      ; UncompressMemory需要目标大小
      Protected actualSize.i = UncompressMemory(*idatData + 2, idatSize - 6, *rawData, rawSize + 1024)
      If actualSize > 0
        rawSize = actualSize
      EndIf
    EndIf
  EndIf
  FreeMemory(*idatData)
  ; 处理解压后的像素数据
  ; PNG每行有一个过滤类型字节，需要去除
  Protected *pdfData = 0
  Protected pdfDataSize.i = 0
  If *rawData And rawSize > 0
    ; 计算不含过滤字节的行大小
    Protected pixelBytes.i = bytesPerPixel * imgWidth
    If bitDepth = 16
      pixelBytes = bytesPerPixel * imgWidth / 2  ; 16位降为8位
    EndIf
    pdfDataSize = pixelBytes * imgHeight
    *pdfData = AllocateMemory(pdfDataSize)
    If *pdfData
      Protected srcRow.i, dstRow.i
      For srcRow = 0 To imgHeight - 1
        Protected srcOff.i = srcRow * (1 + pixelBytes)
        Protected dstOff.i = dstRow * pixelBytes
        dstRow + 1
        If srcOff + 1 + pixelBytes <= rawSize
          ; 跳过过滤类型字节，复制像素数据
          ; 注意：简化处理，忽略PNG过滤(可能导致图像失真)
          ; 完整实现需要根据过滤类型重建像素值
          CopyMemory(*rawData + srcOff + 1, *pdfData + dstOff, pixelBytes)
        EndIf
      Next
    EndIf
    FreeMemory(*rawData)
  EndIf
  ; 创建PDF图像字典对象
  Protected *imageDict.PbPDF_Object = PbPDF_DictNew(#PbPDF_OSUBCLASS_XOBJECT)
  Protected *imageStream.PbPDF_Stream = PbPDF_MemStreamNew()
  If Not *imageStream
    FreeMemory(*buf)
    If *pdfData
      FreeMemory(*pdfData)
    EndIf
    FreeMemory(*image)
    ProcedureReturn 0
  EndIf
  ; 写入像素数据
  If *pdfData And pdfDataSize > 0
    PbPDF_StreamWriteData(*imageStream, *pdfData, pdfDataSize)
    FreeMemory(*pdfData)
  EndIf
  *imageDict\stream = *imageStream
  ; 设置图像字典属性
  PbPDF_DictAddName(*imageDict, "Type", "XObject")
  PbPDF_DictAddName(*imageDict, "Subtype", "Image")
  PbPDF_DictAddNumber(*imageDict, "Width", imgWidth)
  PbPDF_DictAddNumber(*imageDict, "Height", imgHeight)
  ; 设置颜色空间
  If colorType = #PbPDF_PNG_CT_PALETTE And *paletteData And paletteSize > 0
    ; 索引颜色空间: [/Indexed /DeviceRGB (numColors-1) <palette_bytes>]
    Protected *csArray.PbPDF_Object = PbPDF_ArrayNew()
    PbPDF_ArrayAdd(*csArray, PbPDF_NameNew("Indexed"))
    PbPDF_ArrayAdd(*csArray, PbPDF_NameNew("DeviceRGB"))
    Protected numColors.i = paletteSize / 3
    PbPDF_ArrayAdd(*csArray, PbPDF_NumberNew(numColors - 1))
    ; 创建调色板十六进制字符串
    Protected palHex$ = ""
    Protected pi2.i
    For pi2 = 0 To paletteSize - 1
      palHex$ + RSet(Hex(PeekA(*paletteData + pi2) & $FF), 2, "0")
    Next
    PbPDF_ArrayAdd(*csArray, PbPDF_StringNew("<" + palHex$ + ">"))
    PbPDF_DictAdd(*imageDict, "ColorSpace", *csArray)
    FreeMemory(*paletteData)
  Else
    PbPDF_DictAddName(*imageDict, "ColorSpace", csName$)
    If *paletteData
      FreeMemory(*paletteData)
    EndIf
  EndIf
  PbPDF_DictAddNumber(*imageDict, "BitsPerComponent", bitDepth)
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *imageDict)
  EndIf
  *image\imageObj = *imageDict
  ; 生成本地名称
  *image\localName = "Img" + Str(*doc\imageTagCounter)
  *doc\imageTagCounter + 1
  ; 添加到图片管理列表
  If *doc\imageMgr
    PbPDF_ListAddPointer(*doc\imageMgr, *image)
  EndIf
  FreeMemory(*buf)
  ProcedureReturn *image
EndProcedure

;--- 注册图片到页面资源 ---
Procedure.s PbPDF_RegisterImage(*doc.PbPDF_Doc, *pageObj.PbPDF_Object, *image.PbPDF_Image)
  If Not *doc Or Not *pageObj Or Not *image
    ProcedureReturn ""
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn ""
  EndIf
  ; 确保页面有XObject资源字典
  If Not *pageAttr\xobjects
    *pageAttr\xobjects = PbPDF_DictNew()
    Protected *resources.PbPDF_Object = PbPDF_DictGetValue(*pageObj, "Resources")
    If Not *resources
      *resources = PbPDF_DictNew()
      PbPDF_DictAdd(*pageObj, "Resources", *resources)
    EndIf
    PbPDF_DictAdd(*resources, "XObject", *pageAttr\xobjects)
  EndIf
  ; 检查是否已注册
  Protected *existing.PbPDF_Object = PbPDF_DictGetValue(*pageAttr\xobjects, *image\localName)
  If *existing
    ProcedureReturn *image\localName
  EndIf
  ; 添加到页面XObject资源
  PbPDF_DictAdd(*pageAttr\xobjects, *image\localName, *image\imageObj)
  ProcedureReturn *image\localName
EndProcedure

;--- 在页面上绘制图片 ---
; x, y: 左下角坐标; w, h: 显示宽高
Procedure PbPDF_Page_DrawImage(*doc.PbPDF_Doc, *pageObj.PbPDF_Object, *image.PbPDF_Image, x.f, y.f, w.f, h.f)
  If Not *doc Or Not *pageObj Or Not *image
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If Not *stream
    ProcedureReturn
  EndIf
  ; 注册图片到页面
  Protected localName$ = PbPDF_RegisterImage(*doc, *pageObj, *image)
  If localName$ = ""
    ProcedureReturn
  EndIf
  ; 使用PDF操作符绘制图片
  ; q: 保存图形状态
  ; w 0 0 h x y cm: 设置变换矩阵(缩放+平移)
  ; /ImgN Do: 绘制XObject
  ; Q: 恢复图形状态
  PbPDF_StreamWriteStr(*stream, "q" + #LF$)
  PbPDF_StreamWriteStr(*stream, StrF(w, 4) + " 0 0 " + StrF(h, 4) + " " + StrF(x, 4) + " " + StrF(y, 4) + " cm" + #LF$)
  PbPDF_StreamWriteStr(*stream, "/" + localName$ + " Do" + #LF$)
  PbPDF_StreamWriteStr(*stream, "Q" + #LF$)
EndProcedure

;--- 加载并压缩图片 ---
; 加载图片文件并按指定缩放比例压缩后嵌入PDF
; 支持JPEG、PNG、BMP、TGA等PureBasic支持的格式
; scaleFactor: 缩放因子(0.0~1.0)，如0.5表示缩小到50%
; jpegQuality: JPEG压缩质量(1~100)，仅对JPEG输出有效
; 返回PbPDF_Image指针，失败返回0
Procedure.i PbPDF_LoadCompressedImage(*doc.PbPDF_Doc, fileName$, scaleFactor.f, jpegQuality.i)
  Protected imgNum.i
  Protected origWidth.i, origHeight.i
  Protected newWidth.i, newHeight.i
  Protected *image.PbPDF_Image
  Protected *imageDict.PbPDF_Object
  Protected *imageStream.PbPDF_Stream
  Protected tempJPEG$
  Protected *buf
  Protected fileSize.i
  Protected imgWidth.i, imgHeight.i, imgCS.i, imgBPC.i
  Protected result.i
  If Not *doc
    ProcedureReturn 0
  EndIf
  ; 注册图像插件（SaveImage需要JPEG插件）
  UseJPEGImageEncoder()
  UseJPEGImageDecoder()
  UsePNGImageDecoder()
  ; 限制缩放因子范围
  If scaleFactor <= 0.0 Or scaleFactor > 1.0
    scaleFactor = 1.0
  EndIf
  ; 限制JPEG质量范围
  If jpegQuality < 1 : jpegQuality = 1 : EndIf
  If jpegQuality > 100 : jpegQuality = 100 : EndIf
  ; 使用PureBasic加载图片
  imgNum = LoadImage(#PB_Any, fileName$)
  If imgNum = 0
    ProcedureReturn 0
  EndIf
  ; 获取原始尺寸
  origWidth = ImageWidth(imgNum)
  origHeight = ImageHeight(imgNum)
  ; 计算缩放后尺寸
  newWidth = Int(origWidth * scaleFactor)
  newHeight = Int(origHeight * scaleFactor)
  If newWidth < 1 : newWidth = 1 : EndIf
  If newHeight < 1 : newHeight = 1 : EndIf
  ; 如果需要缩放，则调整图片大小
  If scaleFactor < 1.0
    ResizeImage(imgNum, newWidth, newHeight)
  EndIf
  ; 将图片保存为临时JPEG文件
  tempJPEG$ = GetTemporaryDirectory() + "pbpdf_temp_" + Hex(GetTickCount_()) + ".jpg"
  If Not SaveImage(imgNum, tempJPEG$, #PB_ImagePlugin_JPEG, 0, jpegQuality)
    FreeImage(imgNum)
    ProcedureReturn 0
  EndIf
  FreeImage(imgNum)
  ; 读取临时JPEG文件
  Protected fileID.i = ReadFile(#PB_Any, tempJPEG$)
  If fileID = 0
    DeleteFile(tempJPEG$)
    ProcedureReturn 0
  EndIf
  fileSize = Lof(fileID)
  If fileSize <= 0
    CloseFile(fileID)
    DeleteFile(tempJPEG$)
    ProcedureReturn 0
  EndIf
  *buf = AllocateMemory(fileSize)
  If Not *buf
    CloseFile(fileID)
    DeleteFile(tempJPEG$)
    ProcedureReturn 0
  EndIf
  If ReadData(fileID, *buf, fileSize) <> fileSize
    CloseFile(fileID)
    FreeMemory(*buf)
    DeleteFile(tempJPEG$)
    ProcedureReturn 0
  EndIf
  CloseFile(fileID)
  DeleteFile(tempJPEG$)
  ; 解析JPEG头信息
  result = PbPDF_ParseJPEGHeader(*buf, fileSize, @imgWidth, @imgHeight, @imgCS, @imgBPC)
  If result <> #PbPDF_OK
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  ; 创建图片对象
  *image = AllocateMemory(SizeOf(PbPDF_Image))
  If Not *image
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  InitializeStructure(*image, PbPDF_Image)
  *image\imageType = #PbPDF_IMAGE_JPEG
  *image\width = imgWidth
  *image\height = imgHeight
  *image\colorSpace = imgCS
  *image\bitsPerComponent = imgBPC
  ; 创建PDF图像字典对象
  *imageDict = PbPDF_DictNew(#PbPDF_OSUBCLASS_XOBJECT)
  *imageStream = PbPDF_MemStreamNew()
  If Not *imageStream
    FreeMemory(*buf)
    FreeMemory(*image)
    ProcedureReturn 0
  EndIf
  ; 将JPEG数据写入流
  PbPDF_StreamWriteData(*imageStream, *buf, fileSize)
  FreeMemory(*buf)
  *imageDict\stream = *imageStream
  ; 设置图像字典属性
  PbPDF_DictAddName(*imageDict, "Type", "XObject")
  PbPDF_DictAddName(*imageDict, "Subtype", "Image")
  PbPDF_DictAddNumber(*imageDict, "Width", imgWidth)
  PbPDF_DictAddNumber(*imageDict, "Height", imgHeight)
  Select imgCS
    Case #PbPDF_CS_DEVICEGRAY
      PbPDF_DictAddName(*imageDict, "ColorSpace", "DeviceGray")
    Case #PbPDF_CS_DEVICERGB
      PbPDF_DictAddName(*imageDict, "ColorSpace", "DeviceRGB")
    Case #PbPDF_CS_DEVICECMYK
      PbPDF_DictAddName(*imageDict, "ColorSpace", "DeviceCMYK")
  EndSelect
  PbPDF_DictAddNumber(*imageDict, "BitsPerComponent", imgBPC)
  PbPDF_DictAddName(*imageDict, "Filter", "DCTDecode")
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *imageDict)
  EndIf
  *image\imageObj = *imageDict
  ; 生成本地名称
  *image\localName = "Img" + Str(*doc\imageTagCounter)
  *doc\imageTagCounter + 1
  ; 添加到图片管理列表
  If *doc\imageMgr
    PbPDF_ListAddPointer(*doc\imageMgr, *image)
  EndIf
  ProcedureReturn *image
EndProcedure

;--- 获取页面总数 ---
Procedure.i PbPDF_GetPageCount(*doc.PbPDF_Doc)
  If *doc
    ProcedureReturn *doc\pageCount
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 设置文档信息属性 ---
Procedure PbPDF_SetInfoAttr(*doc.PbPDF_Doc, attrType.i, value$)
  If Not *doc Or Not *doc\infoObj
    ProcedureReturn
  EndIf
  Select attrType
    Case #PbPDF_INFO_AUTHOR
      PbPDF_DictAddString(*doc\infoObj, "Author", value$)
    Case #PbPDF_INFO_CREATOR
      PbPDF_DictAddString(*doc\infoObj, "Creator", value$)
    Case #PbPDF_INFO_PRODUCER
      PbPDF_DictAddString(*doc\infoObj, "Producer", value$)
    Case #PbPDF_INFO_TITLE
      PbPDF_DictAddString(*doc\infoObj, "Title", value$)
    Case #PbPDF_INFO_SUBJECT
      PbPDF_DictAddString(*doc\infoObj, "Subject", value$)
    Case #PbPDF_INFO_KEYWORDS
      PbPDF_DictAddString(*doc\infoObj, "Keywords", value$)
  EndSelect
EndProcedure

;--- 获取文档信息属性 ---
Procedure.s PbPDF_GetInfoAttr(*doc.PbPDF_Doc, attrType.i)
  If Not *doc Or Not *doc\infoObj
    ProcedureReturn ""
  EndIf
  Protected key$
  Select attrType
    Case #PbPDF_INFO_AUTHOR:   key$ = "Author"
    Case #PbPDF_INFO_CREATOR:  key$ = "Creator"
    Case #PbPDF_INFO_PRODUCER: key$ = "Producer"
    Case #PbPDF_INFO_TITLE:    key$ = "Title"
    Case #PbPDF_INFO_SUBJECT:  key$ = "Subject"
    Case #PbPDF_INFO_KEYWORDS: key$ = "Keywords"
    Default: ProcedureReturn ""
  EndSelect
  Protected *valueObj.PbPDF_Object = PbPDF_DictGetValue(*doc\infoObj, key$)
  If *valueObj And *valueObj\objType = #PbPDF_OBJ_STRING
    ProcedureReturn *valueObj\stringValue
  EndIf
  ProcedureReturn ""
EndProcedure

;=============================================================================
; 第27部分：公开API函数（便捷包装）
;=============================================================================

;--- 便捷函数：创建PDF文档并返回 ---
Procedure.i PbPDF_Create()
  Protected *doc.PbPDF_Doc = PbPDF_New()
  If *doc
    PbPDF_NewDoc(*doc)
  EndIf
  ProcedureReturn *doc
EndProcedure

;--- 便捷函数：添加A4页面 ---
Procedure.i PbPDF_AddPageA4(*doc.PbPDF_Doc)
  Protected *page.PbPDF_Object = PbPDF_AddPage(*doc)
  ProcedureReturn *page
EndProcedure

;--- 便捷函数：添加自定义尺寸页面 ---
Procedure.i PbPDF_AddPageCustom(*doc.PbPDF_Doc, width.f, height.f)
  Protected *page.PbPDF_Object = PbPDF_AddPage(*doc)
  If *page
    PbPDF_Page_SetSize(*page, width, height)
  EndIf
  ProcedureReturn *page
EndProcedure

;--- 便捷函数：添加预定义尺寸页面 ---
Procedure.i PbPDF_AddPagePredefined(*doc.PbPDF_Doc, pageSize.i, direction.i = #PbPDF_PAGE_PORTRAIT)
  Protected *page.PbPDF_Object = PbPDF_AddPage(*doc)
  If *page
    PbPDF_Page_SetPredefinedSize(*page, pageSize, direction)
  EndIf
  ProcedureReturn *page
EndProcedure

;--- 便捷函数：保存并释放文档 ---
Procedure.i PbPDF_SaveAndFree(*doc.PbPDF_Doc, fileName$)
  Protected result.i = PbPDF_SaveToFile(*doc, fileName$)
  PbPDF_Free(*doc)
  ProcedureReturn result
EndProcedure

;=============================================================================
; 第11部分：图形状态管理 (GState/GSave/GRestore)
;=============================================================================

;--- 创建图形状态副本 ---
Procedure.i PbPDF_GStateNew(*prev.PbPDF_GState = 0)
  Protected *gs.PbPDF_GState = AllocateMemory(SizeOf(PbPDF_GState))
  If *gs
    InitializeStructure(*gs, PbPDF_GState)
    If *prev
      ; 从前一个状态复制所有属性
      CopyMemory(*prev, *gs, SizeOf(PbPDF_GState))
      *gs\prev = *prev
      *gs\depth = *prev\depth + 1
    Else
      ; 设置默认值
      *gs\transMatrix\a = 1.0
      *gs\transMatrix\d = 1.0
      *gs\lineWidth = 1.0
      *gs\miterLimit = 10.0
      *gs\charSpace = 0.0
      *gs\wordSpace = 0.0
      *gs\hScalling = 100.0
      *gs\textLeading = 0.0
      *gs\renderingMode = #PbPDF_TEXT_RENDER_FILL
      *gs\fontSize = 10.0
      *gs\csFill = #PbPDF_CS_DEVICERGB
      *gs\csStroke = #PbPDF_CS_DEVICERGB
      *gs\rgbFill\r = 0.0
      *gs\rgbFill\g = 0.0
      *gs\rgbFill\b = 0.0
      *gs\rgbStroke\r = 0.0
      *gs\rgbStroke\g = 0.0
      *gs\rgbStroke\b = 0.0
      *gs\grayFill = 0.0
      *gs\grayStroke = 0.0
      *gs\depth = 1
    EndIf
  EndIf
  ProcedureReturn *gs
EndProcedure

;--- 释放图形状态栈 ---
Procedure PbPDF_GStateFree(*gs.PbPDF_GState)
  If *gs
    PbPDF_GStateFree(*gs\prev)
    FreeMemory(*gs)
  EndIf
EndProcedure

;--- 获取页面的内容流(用于写入绘图指令) ---
Procedure.i PbPDF_PageGetContentStream(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn 0
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If *pageAttr
    ProcedureReturn *pageAttr\contentStream
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 保存图形状态 (PDF操作符: q) ---
Procedure PbPDF_Page_GSave(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  ; 创建新的图形状态(复制当前状态)
  Protected *newGs.PbPDF_GState = PbPDF_GStateNew(*pageAttr\gstate)
  If *newGs And *newGs\depth <= #PbPDF_MAX_GSTATE_DEPTH
    *pageAttr\gstate = *newGs
  EndIf
  ; 写入q操作符
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "q" + #LF$)
  EndIf
EndProcedure

;--- 恢复图形状态 (PDF操作符: Q) ---
Procedure PbPDF_Page_GRestore(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate Or Not *pageAttr\gstate\prev
    ProcedureReturn
  EndIf
  ; 弹出当前图形状态，恢复前一个
  Protected *oldGs.PbPDF_GState = *pageAttr\gstate
  *pageAttr\gstate = *oldGs\prev
  *oldGs\prev = 0  ; 防止递归释放
  FreeMemory(*oldGs)
  ; 写入Q操作符
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "Q" + #LF$)
  EndIf
EndProcedure

;=============================================================================
; 第12部分：页面绘图操作符 (路径构造/绘制/颜色/变换)
;=============================================================================

;--- 路径构造：移动到指定点 (PDF操作符: m) ---
Procedure PbPDF_Page_MoveTo(*pageObj.PbPDF_Object, x.f, y.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(x, 4) + " " + StrF(y, 4) + " m" + #LF$)
    *pageAttr\curPos\x = x
    *pageAttr\curPos\y = y
  EndIf
EndProcedure

;--- 路径构造：画直线到指定点 (PDF操作符: l) ---
Procedure PbPDF_Page_LineTo(*pageObj.PbPDF_Object, x.f, y.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(x, 4) + " " + StrF(y, 4) + " l" + #LF$)
    *pageAttr\curPos\x = x
    *pageAttr\curPos\y = y
  EndIf
EndProcedure

;--- 路径构造：三次贝塞尔曲线 (PDF操作符: c) ---
Procedure PbPDF_Page_CurveTo(*pageObj.PbPDF_Object, x1.f, y1.f, x2.f, y2.f, x3.f, y3.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(x1, 4) + " " + StrF(y1, 4) + " " + StrF(x2, 4) + " " + StrF(y2, 4) + " " + StrF(x3, 4) + " " + StrF(y3, 4) + " c" + #LF$)
    *pageAttr\curPos\x = x3
    *pageAttr\curPos\y = y3
  EndIf
EndProcedure

;--- 路径构造：二次贝塞尔曲线(使用两个控制点) (PDF操作符: v) ---
Procedure PbPDF_Page_CurveTo2(*pageObj.PbPDF_Object, x2.f, y2.f, x3.f, y3.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(x2, 4) + " " + StrF(y2, 4) + " " + StrF(x3, 4) + " " + StrF(y3, 4) + " v" + #LF$)
    *pageAttr\curPos\x = x3
    *pageAttr\curPos\y = y3
  EndIf
EndProcedure

;--- 路径构造：二次贝塞尔曲线(使用一个控制点) (PDF操作符: y) ---
Procedure PbPDF_Page_CurveTo3(*pageObj.PbPDF_Object, x1.f, y1.f, x3.f, y3.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(x1, 4) + " " + StrF(y1, 4) + " " + StrF(x3, 4) + " " + StrF(y3, 4) + " y" + #LF$)
    *pageAttr\curPos\x = x3
    *pageAttr\curPos\y = y3
  EndIf
EndProcedure

;--- 路径构造：矩形 (PDF操作符: re) ---
Procedure PbPDF_Page_Rectangle(*pageObj.PbPDF_Object, x.f, y.f, w.f, h.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(x, 4) + " " + StrF(y, 4) + " " + StrF(w, 4) + " " + StrF(h, 4) + " re" + #LF$)
  EndIf
EndProcedure

;--- 关闭子路径 (PDF操作符: h) ---
Procedure PbPDF_Page_ClosePath(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "h" + #LF$)
  EndIf
EndProcedure

;--- 路径绘制：描边 (PDF操作符: S) ---
Procedure PbPDF_Page_Stroke(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "S" + #LF$)
  EndIf
EndProcedure

;--- 路径绘制：填充(非零缠绕规则) (PDF操作符: f) ---
Procedure PbPDF_Page_Fill(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "f" + #LF$)
  EndIf
EndProcedure

;--- 路径绘制：填充(奇偶规则) (PDF操作符: f*) ---
Procedure PbPDF_Page_Eofill(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "f*" + #LF$)
  EndIf
EndProcedure

;--- 路径绘制：描边并填充 (PDF操作符: B) ---
Procedure PbPDF_Page_FillStroke(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "B" + #LF$)
  EndIf
EndProcedure

;--- 路径绘制：关闭路径并描边 (PDF操作符: s) ---
Procedure PbPDF_Page_ClosePathStroke(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "s" + #LF$)
  EndIf
EndProcedure

;--- 路径绘制：关闭路径、描边并填充 (PDF操作符: b) ---
Procedure PbPDF_Page_ClosePathFillStroke(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "b" + #LF$)
  EndIf
EndProcedure

;--- 结束路径(无操作) (PDF操作符: n) ---
Procedure PbPDF_Page_EndPath(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "n" + #LF$)
  EndIf
EndProcedure

;=============================================================================
; 第13部分：颜色和线条属性设置
;=============================================================================

;--- 设置填充RGB颜色 (PDF操作符: rg) ---
Procedure PbPDF_Page_SetRGBFill(*pageObj.PbPDF_Object, r.f, g.f, b.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\csFill = #PbPDF_CS_DEVICERGB
  *pageAttr\gstate\rgbFill\r = r
  *pageAttr\gstate\rgbFill\g = g
  *pageAttr\gstate\rgbFill\b = b
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(r, 4) + " " + StrF(g, 4) + " " + StrF(b, 4) + " rg" + #LF$)
  EndIf
EndProcedure

;--- 设置描边RGB颜色 (PDF操作符: RG) ---
Procedure PbPDF_Page_SetRGBStroke(*pageObj.PbPDF_Object, r.f, g.f, b.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\csStroke = #PbPDF_CS_DEVICERGB
  *pageAttr\gstate\rgbStroke\r = r
  *pageAttr\gstate\rgbStroke\g = g
  *pageAttr\gstate\rgbStroke\b = b
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(r, 4) + " " + StrF(g, 4) + " " + StrF(b, 4) + " RG" + #LF$)
  EndIf
EndProcedure

;--- 设置填充CMYK颜色 (PDF操作符: k) ---
Procedure PbPDF_Page_SetCMYKFill(*pageObj.PbPDF_Object, c.f, m.f, y.f, k.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\csFill = #PbPDF_CS_DEVICECMYK
  *pageAttr\gstate\cmykFill\c = c
  *pageAttr\gstate\cmykFill\m = m
  *pageAttr\gstate\cmykFill\y = y
  *pageAttr\gstate\cmykFill\k = k
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(c, 4) + " " + StrF(m, 4) + " " + StrF(y, 4) + " " + StrF(k, 4) + " k" + #LF$)
  EndIf
EndProcedure

;--- 设置描边CMYK颜色 (PDF操作符: K) ---
Procedure PbPDF_Page_SetCMYKStroke(*pageObj.PbPDF_Object, c.f, m.f, y.f, k.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\csStroke = #PbPDF_CS_DEVICECMYK
  *pageAttr\gstate\cmykStroke\c = c
  *pageAttr\gstate\cmykStroke\m = m
  *pageAttr\gstate\cmykStroke\y = y
  *pageAttr\gstate\cmykStroke\k = k
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(c, 4) + " " + StrF(m, 4) + " " + StrF(y, 4) + " " + StrF(k, 4) + " K" + #LF$)
  EndIf
EndProcedure

;--- 设置填充灰度 (PDF操作符: g) ---
Procedure PbPDF_Page_SetGrayFill(*pageObj.PbPDF_Object, value.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\csFill = #PbPDF_CS_DEVICEGRAY
  *pageAttr\gstate\grayFill = value
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(value, 4) + " g" + #LF$)
  EndIf
EndProcedure

;--- 设置描边灰度 (PDF操作符: G) ---
Procedure PbPDF_Page_SetGrayStroke(*pageObj.PbPDF_Object, value.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\csStroke = #PbPDF_CS_DEVICEGRAY
  *pageAttr\gstate\grayStroke = value
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(value, 4) + " G" + #LF$)
  EndIf
EndProcedure

;--- 设置线宽 (PDF操作符: w) ---
Procedure PbPDF_Page_SetLineWidth(*pageObj.PbPDF_Object, width.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\lineWidth = width
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(width, 4) + " w" + #LF$)
  EndIf
EndProcedure

;--- 设置线端样式 (PDF操作符: J) ---
Procedure PbPDF_Page_SetLineCap(*pageObj.PbPDF_Object, capStyle.i)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\lineCap = capStyle
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, Str(capStyle) + " J" + #LF$)
  EndIf
EndProcedure

;--- 设置线连接样式 (PDF操作符: j) ---
Procedure PbPDF_Page_SetLineJoin(*pageObj.PbPDF_Object, joinStyle.i)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\lineJoin = joinStyle
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, Str(joinStyle) + " j" + #LF$)
  EndIf
EndProcedure

;--- 设置斜接限制 (PDF操作符: M) ---
Procedure PbPDF_Page_SetMiterLimit(*pageObj.PbPDF_Object, limit.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\miterLimit = limit
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(limit, 4) + " M" + #LF$)
  EndIf
EndProcedure

;--- 设置虚线模式 (PDF操作符: d) ---
Procedure PbPDF_Page_SetDash(*pageObj.PbPDF_Object, dashOn.f, dashOff.f, phase.f = 0)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    If dashOn <= 0 And dashOff <= 0
      PbPDF_StreamWriteStr(*stream, "[] 0 d" + #LF$)
    Else
      PbPDF_StreamWriteStr(*stream, "[" + StrF(dashOn, 2) + " " + StrF(dashOff, 2) + "] " + StrF(phase, 2) + " d" + #LF$)
    EndIf
  EndIf
EndProcedure

;--- 变换矩阵 (PDF操作符: cm) ---
Procedure PbPDF_Page_Concat(*pageObj.PbPDF_Object, a.f, b.f, c.f, d.f, x.f, y.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(a, 4) + " " + StrF(b, 4) + " " + StrF(c, 4) + " " + StrF(d, 4) + " " + StrF(x, 4) + " " + StrF(y, 4) + " cm" + #LF$)
  EndIf
EndProcedure

;=============================================================================
; 第14部分：便捷绘图函数
;=============================================================================

;--- 画直线 ---
Procedure PbPDF_Page_DrawLine(*pageObj.PbPDF_Object, x1.f, y1.f, x2.f, y2.f)
  PbPDF_Page_MoveTo(*pageObj, x1, y1)
  PbPDF_Page_LineTo(*pageObj, x2, y2)
  PbPDF_Page_Stroke(*pageObj)
EndProcedure

;--- 画矩形(描边) ---
Procedure PbPDF_Page_DrawRect(*pageObj.PbPDF_Object, x.f, y.f, w.f, h.f)
  PbPDF_Page_Rectangle(*pageObj, x, y, w, h)
  PbPDF_Page_Stroke(*pageObj)
EndProcedure

;--- 填充矩形 ---
Procedure PbPDF_Page_FillRect(*pageObj.PbPDF_Object, x.f, y.f, w.f, h.f)
  PbPDF_Page_Rectangle(*pageObj, x, y, w, h)
  PbPDF_Page_Fill(*pageObj)
EndProcedure

;--- 画圆(描边) ---
Procedure PbPDF_Page_DrawCircle(*pageObj.PbPDF_Object, x.f, y.f, radius.f)
  ; 使用贝塞尔曲线近似画圆(4段三次贝塞尔曲线)
  Protected curve.f = 0.552284749  ; 魔术常数: 4*(Sqrt(2)-1)/3
  Protected r.f = radius
  Protected c.f = r * curve
  PbPDF_Page_MoveTo(*pageObj, x + r, y)
  PbPDF_Page_CurveTo(*pageObj, x + r, y + c, x + c, y + r, x, y + r)
  PbPDF_Page_CurveTo(*pageObj, x - c, y + r, x - r, y + c, x - r, y)
  PbPDF_Page_CurveTo(*pageObj, x - r, y - c, x - c, y - r, x, y - r)
  PbPDF_Page_CurveTo(*pageObj, x + c, y - r, x + r, y - c, x + r, y)
  PbPDF_Page_ClosePath(*pageObj)
  PbPDF_Page_Stroke(*pageObj)
EndProcedure

;--- 填充圆 ---
Procedure PbPDF_Page_FillCircle(*pageObj.PbPDF_Object, x.f, y.f, radius.f)
  Protected curve.f = 0.552284749
  Protected r.f = radius
  Protected c.f = r * curve
  PbPDF_Page_MoveTo(*pageObj, x + r, y)
  PbPDF_Page_CurveTo(*pageObj, x + r, y + c, x + c, y + r, x, y + r)
  PbPDF_Page_CurveTo(*pageObj, x - c, y + r, x - r, y + c, x - r, y)
  PbPDF_Page_CurveTo(*pageObj, x - r, y - c, x - c, y - r, x, y - r)
  PbPDF_Page_CurveTo(*pageObj, x + c, y - r, x + r, y - c, x + r, y)
  PbPDF_Page_ClosePath(*pageObj)
  PbPDF_Page_Fill(*pageObj)
EndProcedure

;--- 画椭圆(描边) ---
Procedure PbPDF_Page_DrawEllipse(*pageObj.PbPDF_Object, x.f, y.f, rx.f, ry.f)
  Protected curve.f = 0.552284749
  Protected cx.f = rx * curve
  Protected cy.f = ry * curve
  PbPDF_Page_MoveTo(*pageObj, x + rx, y)
  PbPDF_Page_CurveTo(*pageObj, x + rx, y + cy, x + cx, y + ry, x, y + ry)
  PbPDF_Page_CurveTo(*pageObj, x - cx, y + ry, x - rx, y + cy, x - rx, y)
  PbPDF_Page_CurveTo(*pageObj, x - rx, y - cy, x - cx, y - ry, x, y - ry)
  PbPDF_Page_CurveTo(*pageObj, x + cx, y - ry, x + rx, y - cy, x + rx, y)
  PbPDF_Page_ClosePath(*pageObj)
  PbPDF_Page_Stroke(*pageObj)
EndProcedure

;--- 画弧线 ---
Procedure PbPDF_Page_Arc(*pageObj.PbPDF_Object, x.f, y.f, radius.f, angle1.f, angle2.f)
  Protected i.i, segments.i = 32
  Protected angleStep.f = (angle2 - angle1) / segments
  Protected angle.f, px.f, py.f
  angle = angle1
  px = x + radius * Cos(Radian(angle))
  py = y + radius * Sin(Radian(angle))
  PbPDF_Page_MoveTo(*pageObj, px, py)
  For i = 1 To segments
    angle = angle1 + angleStep * i
    px = x + radius * Cos(Radian(angle))
    py = y + radius * Sin(Radian(angle))
    PbPDF_Page_LineTo(*pageObj, px, py)
  Next
EndProcedure

;=============================================================================
; 第15部分：文本绘制
;=============================================================================

;--- 开始文本对象 (PDF操作符: BT) ---
Procedure PbPDF_Page_BeginText(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  *pageAttr\gmode | #PbPDF_GMODE_TEXT_OBJECT
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "BT" + #LF$)
  EndIf
EndProcedure

;--- 结束文本对象 (PDF操作符: ET) ---
Procedure PbPDF_Page_EndText(*pageObj.PbPDF_Object)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  *pageAttr\gmode & ~#PbPDF_GMODE_TEXT_OBJECT
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "ET" + #LF$)
  EndIf
EndProcedure

;--- 设置字体和大小 (PDF操作符: Tf) ---
Procedure PbPDF_Page_SetFontAndSize(*pageObj.PbPDF_Object, fontName$, fontSize.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\fontSize = fontSize
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "/" + fontName$ + " " + StrF(fontSize, 2) + " Tf" + #LF$)
  EndIf
EndProcedure

;--- 显示文本 (PDF操作符: Tj) ---
Procedure PbPDF_Page_ShowText(*pageObj.PbPDF_Object, text$)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "(" + PbPDF_EscapeString(text$) + ") Tj" + #LF$)
  EndIf
EndProcedure

;--- 移动文本位置 (PDF操作符: Td) ---
Procedure PbPDF_Page_MoveTextPos(*pageObj.PbPDF_Object, x.f, y.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(x, 4) + " " + StrF(y, 4) + " Td" + #LF$)
  EndIf
EndProcedure

;--- 下一行显示文本 (PDF操作符: ') ---
Procedure PbPDF_Page_ShowTextNextLine(*pageObj.PbPDF_Object, text$)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn
  EndIf
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, "(" + PbPDF_EscapeString(text$) + ") '" + #LF$)
  EndIf
EndProcedure

;--- 设置字符间距 (PDF操作符: Tc) ---
Procedure PbPDF_Page_SetCharSpace(*pageObj.PbPDF_Object, value.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\charSpace = value
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(value, 4) + " Tc" + #LF$)
  EndIf
EndProcedure

;--- 设置词间距 (PDF操作符: Tw) ---
Procedure PbPDF_Page_SetWordSpace(*pageObj.PbPDF_Object, value.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\wordSpace = value
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(value, 4) + " Tw" + #LF$)
  EndIf
EndProcedure

;--- 设置水平缩放 (PDF操作符: Tz) ---
Procedure PbPDF_Page_SetHorizontalScalling(*pageObj.PbPDF_Object, value.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\hScalling = value
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(value, 2) + " Tz" + #LF$)
  EndIf
EndProcedure

;--- 设置文本行距 (PDF操作符: TL) ---
Procedure PbPDF_Page_SetTextLeading(*pageObj.PbPDF_Object, value.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\textLeading = value
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(value, 4) + " TL" + #LF$)
  EndIf
EndProcedure

;--- 设置文本渲染模式 (PDF操作符: Tr) ---
Procedure PbPDF_Page_SetTextRenderingMode(*pageObj.PbPDF_Object, mode.i)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\renderingMode = mode
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, Str(mode) + " Tr" + #LF$)
  EndIf
EndProcedure

;--- 设置文本上升 (PDF操作符: Ts) ---
Procedure PbPDF_Page_SetTextRise(*pageObj.PbPDF_Object, value.f)
  If Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\gstate
    ProcedureReturn
  EndIf
  *pageAttr\gstate\textRise = value
  Protected *stream.PbPDF_Stream = *pageAttr\contentStream
  If *stream
    PbPDF_StreamWriteStr(*stream, StrF(value, 4) + " Ts" + #LF$)
  EndIf
EndProcedure

;=============================================================================
; 第16部分：14种标准字体(Base14)和字体资源管理
;=============================================================================

;--- 14种标准PDF字体名称 ---
DataSection
  PbPDF_Base14FontNames:
  Data.s "Courier"
  Data.s "Courier-Bold"
  Data.s "Courier-Oblique"
  Data.s "Courier-BoldOblique"
  Data.s "Helvetica"
  Data.s "Helvetica-Bold"
  Data.s "Helvetica-Oblique"
  Data.s "Helvetica-BoldOblique"
  Data.s "Times-Roman"
  Data.s "Times-Bold"
  Data.s "Times-Italic"
  Data.s "Times-BoldItalic"
  Data.s "Symbol"
  Data.s "ZapfDingbats"
EndDataSection

;--- 标准字体宽度数据(仅Courier等宽字体的简化版本) ---
; Courier系列所有字符宽度均为600
; Helvetica和Times的宽度数据将在后续版本中完善

;--- 注册字体资源到页面 ---
; 将字体添加到页面的Resources/Font字典中，并生成本地名称(如F1,F2等)
Procedure.s PbPDF_PageRegisterFont(*doc.PbPDF_Doc, *pageObj.PbPDF_Object, fontName$)
  If Not *doc Or Not *pageObj
    ProcedureReturn ""
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr
    ProcedureReturn ""
  EndIf
  ; 如果页面没有字体资源字典，则创建
  If Not *pageAttr\fonts
    *pageAttr\fonts = PbPDF_DictNew()
    ; 将字体字典添加到页面Resources
    Protected *resources.PbPDF_Object = PbPDF_DictGetValue(*pageObj, "Resources")
    If Not *resources
      *resources = PbPDF_DictNew()
      PbPDF_DictAdd(*pageObj, "Resources", *resources)
    EndIf
    PbPDF_DictAdd(*resources, "Font", *pageAttr\fonts)
  EndIf
  ; 检查字体是否已注册
  Protected *existingFont.PbPDF_Object = PbPDF_DictGetValue(*pageAttr\fonts, fontName$)
  If *existingFont
    ProcedureReturn fontName$
  EndIf
  ; 创建字体字典(Type1标准字体)
  Protected *fontDict.PbPDF_Object = PbPDF_DictNew(#PbPDF_OSUBCLASS_FONT)
  PbPDF_DictAddName(*fontDict, "Type", "Font")
  PbPDF_DictAddName(*fontDict, "Subtype", "Type1")
  PbPDF_DictAddName(*fontDict, "BaseFont", fontName$)
  PbPDF_DictAddName(*fontDict, "Encoding", "WinAnsiEncoding")
  ; 注册到xref
  If *doc\xref
    PbPDF_XRefAdd(*doc\xref, *fontDict)
  EndIf
  ; 添加到页面字体资源
  PbPDF_DictAdd(*pageAttr\fonts, fontName$, *fontDict)
  ProcedureReturn fontName$
EndProcedure

;--- 获取标准字体并注册到页面 ---
Procedure.s PbPDF_GetFont(*doc.PbPDF_Doc, *pageObj.PbPDF_Object, fontName$)
  ProcedureReturn PbPDF_PageRegisterFont(*doc, *pageObj, fontName$)
EndProcedure

;=============================================================================
; 第17部分：页面内容流写入(保存时将内容流写入PDF)
;=============================================================================

;--- 将页面内容流写入PDF对象 ---
; 在保存PDF前，需要将内存中的内容流数据关联到页面对象
Procedure PbPDF_PageFlushContent(*doc.PbPDF_Doc, *pageObj.PbPDF_Object)
  If Not *doc Or Not *pageObj
    ProcedureReturn
  EndIf
  Protected *pageAttr.PbPDF_PageAttr = *pageObj\attr
  If Not *pageAttr Or Not *pageAttr\contentStream
    ProcedureReturn
  EndIf
  ; 如果页面已有Contents，跳过
  Protected *existingContents.PbPDF_Object = PbPDF_DictGetValue(*pageObj, "Contents")
  If *existingContents
    ProcedureReturn
  EndIf
  ; 创建内容流字典对象
  Protected *contentsDict.PbPDF_Object = PbPDF_DictNew()
  Protected streamSize.i = *pageAttr\contentStream\size
  ; 获取内容流数据
  If *pageAttr\contentStream\streamType = 1 And *pageAttr\contentStream\memAttr
    Protected *streamBuf = AllocateMemory(streamSize + 1)
    If *streamBuf
      Protected actualLen.i = PbPDF_MemStreamGetData(*pageAttr\contentStream, *streamBuf)
      ; 创建流对象
      Protected *contentStream.PbPDF_Stream = PbPDF_MemStreamNew()
      If *contentStream
        PbPDF_StreamWriteData(*contentStream, *streamBuf, actualLen)
      EndIf
      ; 设置内容流字典属性
      *contentsDict\stream = *contentStream
      PbPDF_DictAddNumber(*contentsDict, "Length", actualLen)
      ; 注册到xref
      If *doc\xref
        PbPDF_XRefAdd(*doc\xref, *contentsDict)
      EndIf
      ; 添加到页面
      PbPDF_DictAdd(*pageObj, "Contents", *contentsDict)
      FreeMemory(*streamBuf)
    EndIf
  EndIf
EndProcedure

;--- 重写PbPDF_SaveToFile，在保存前刷新所有页面内容 ---
; 注意：此函数覆盖之前的定义
Procedure.i PbPDF_SaveToFile2(*doc.PbPDF_Doc, fileName$)
  If Not *doc Or Not *doc\xref
    ProcedureReturn #PbPDF_ERR_INVALID_DOC
  EndIf
  ; 刷新所有页面内容流
  Protected i.i
  For i = 0 To *doc\pageCount - 1
    Protected *pageObj.PbPDF_Object = PbPDF_ListGetPointer(*doc\pageList, i)
    If *pageObj
      PbPDF_PageFlushContent(*doc, *pageObj)
    EndIf
  Next
  ; 处理延迟创建的CIDFont字典(子集化)
  ; 遍历所有字体，将占位符替换为完整的CIDFont字典
  If *doc\fontMgr
    Protected fontCount.i = PbPDF_ListCount(*doc\fontMgr)
    For i = 0 To fontCount - 1
      Protected *font.PbPDF_Font = PbPDF_ListGetPointer(*doc\fontMgr, i)
      If *font And *font\fontType = #PbPDF_FONT_TRUETYPE And *font\fontObj
        ; 检查是否为占位符(没有DescendantFonts的Type0字体)
        Protected *desc.PbPDF_Object = PbPDF_DictGetValue(*font\fontObj, "DescendantFonts")
        If Not *desc
          ; 保存旧的fontObj引用(用于后续在页面资源中查找和替换)
          Protected *oldFontObj.PbPDF_Object = *font\fontObj
          ; 创建完整的CIDFont字典(含子集化)
          ; 注意：此函数会更新*font\fontObj为新的Type0字体对象
          Protected *cidFontObj.PbPDF_Object = PbPDF_CreateCIDFontDict(*doc, *font)
          If *cidFontObj
            ; 更新页面字体资源中的引用
            ; 遍历所有页面，将占位符替换为完整的CIDFont字典
            Protected pi.i
            For pi = 0 To *doc\pageCount - 1
              Protected *pObj.PbPDF_Object = PbPDF_ListGetPointer(*doc\pageList, pi)
              If *pObj
                Protected *pAttr.PbPDF_PageAttr = *pObj\attr
                If *pAttr And *pAttr\fonts
                  ; 使用旧的fontObj进行查找(因为页面资源中存储的是旧引用)
                  Protected *oldRef.PbPDF_Object = PbPDF_DictGetValue(*pAttr\fonts, *font\localName)
                  If *oldRef = *oldFontObj
                    ; 替换为新的CIDFont字典
                    PbPDF_DictAdd(*pAttr\fonts, *font\localName, *cidFontObj)
                  EndIf
                EndIf
              EndIf
            Next
          EndIf
        EndIf
      EndIf
    Next
  EndIf
  ; 写入大纲(如果存在)
  PbPDF_WriteOutlines(*doc)
  ; 更新Trailer的Size
  PbPDF_DictAddNumber(*doc\trailerObj, "Size", PbPDF_XRefGetCount(*doc\xref))
  ; 创建输出流
  Protected *stream.PbPDF_Stream = PbPDF_FileWriteStreamNew(fileName$)
  If Not *stream
    ProcedureReturn #PbPDF_ERR_FILE_OPEN
  EndIf
  ; 写入PDF文件头
  Protected header$
  Select *doc\pdfVersion
    Case #PbPDF_PDF_VER_12: header$ = "%PDF-1.2"
    Case #PbPDF_PDF_VER_13: header$ = "%PDF-1.3"
    Case #PbPDF_PDF_VER_14: header$ = "%PDF-1.4"
    Case #PbPDF_PDF_VER_15: header$ = "%PDF-1.5"
    Case #PbPDF_PDF_VER_16: header$ = "%PDF-1.6"
    Case #PbPDF_PDF_VER_17: header$ = "%PDF-1.7"
    Case #PbPDF_PDF_VER_20: header$ = "%PDF-2.0"
    Default: header$ = "%PDF-1.7"
  EndSelect
  PbPDF_StreamWriteStr(*stream, header$ + #LF$)
  ; 写入二进制标记
  PbPDF_StreamWriteByte(*stream, '%')
  Protected b.a
  For b = 128 To 255
    PbPDF_StreamWriteByte(*stream, b)
  Next
  PbPDF_StreamWriteEOL(*stream)
  ; 初始化xref地址
  *doc\xref\addr = *stream\size
  ; 写入所有间接对象
  Protected count.i = PbPDF_XRefGetCount(*doc\xref)
  For i = 0 To count - 1
    Protected *entry.PbPDF_XRefEntry = *doc\xref\entries\items + i * SizeOf(PbPDF_XRefEntry)
    If *entry\obj And (*entry\entryType = #PbPDF_XREF_INUSE_ENTRY)
      ; 加密对象时排除加密字典对象不加密
      Protected *encParam.PbPDF_Encrypt = 0
      If *doc\encryptOn And *doc\encrypt
        If *doc\encryptDictObj And *entry\obj = *doc\encryptDictObj
          *encParam = 0
        Else
          *encParam = *doc\encrypt
        EndIf
      EndIf
      PbPDF_WriteIndirectObj(*entry\obj, *stream, *doc\xref, *encParam)
    EndIf
  Next
  ; 写入xref表
  Protected xrefOffset.i = *stream\size
  PbPDF_StreamWriteStr(*stream, "xref" + #LF$)
  PbPDF_StreamWriteStr(*stream, "0 " + Str(count) + #LF$)
  For i = 0 To count - 1
    *entry = *doc\xref\entries\items + i * SizeOf(PbPDF_XRefEntry)
    If *entry\entryType = #PbPDF_XREF_FREE_ENTRY
      PbPDF_StreamWriteStr(*stream, "0000000000 " + RSet(Str(*entry\genNo), 5, "0") + " f " + #LF$)
    Else
      PbPDF_StreamWriteStr(*stream, RSet(Str(*entry\byteOffset), 10, "0") + " " + RSet(Str(*entry\genNo), 5, "0") + " n " + #LF$)
    EndIf
  Next
  ; 写入Trailer
  PbPDF_StreamWriteStr(*stream, "trailer" + #LF$)
  PbPDF_ObjWrite(*doc\trailerObj, *stream)
  PbPDF_StreamWriteEOL(*stream)
  ; 写入startxref
  PbPDF_StreamWriteStr(*stream, "startxref" + #LF$)
  PbPDF_StreamWriteStr(*stream, Str(xrefOffset) + #LF$)
  PbPDF_StreamWriteStr(*stream, "%%EOF" + #LF$)
  ; 关闭流
  PbPDF_StreamFree(*stream)
  ProcedureReturn #PbPDF_OK
EndProcedure

;=============================================================================
; 第28部分：PDF词法分析器（Lexer）
; 用于解析现有PDF文件中的各种token
;=============================================================================

;--- PDF词法Token类型常量 ---
#PbPDF_TOKEN_EOF        = 0   ; 文件结束
#PbPDF_TOKEN_NUMBER     = 1   ; 整数
#PbPDF_TOKEN_REAL       = 2   ; 实数
#PbPDF_TOKEN_STRING     = 3   ; 字面字符串 (...)
#PbPDF_TOKEN_HEXSTRING  = 4   ; 十六进制字符串 <...>
#PbPDF_TOKEN_NAME       = 5   ; 名称对象 /Name
#PbPDF_TOKEN_ARRAY_START= 6   ; 数组开始 [
#PbPDF_TOKEN_ARRAY_END  = 7   ; 数组结束 ]
#PbPDF_TOKEN_DICT_START = 8   ; 字典开始 <<
#PbPDF_TOKEN_DICT_END   = 9   ; 字典结束 >>
#PbPDF_TOKEN_KEYWORD    = 10  ; 关键字(true/false/null/obj/endobj/stream/endstream等)
#PbPDF_TOKEN_ERROR      = 11  ; 错误token

;--- PDF词法Token结构 ---
Structure PbPDF_Token
  tokenType.i          ; token类型(#PbPDF_TOKEN_xxx)
  intValue.i           ; 整数值(用于NUMBER类型)
  realValue.f          ; 实数值(用于REAL类型)
  strValue.s           ; 字符串值(用于STRING/HEXSTRING/NAME/KEYWORD类型)
EndStructure

;--- PDF已加载对象条目 ---
Structure PbPDF_LoadedObj
  objNum.i             ; 对象编号
  genNum.i             ; 生成编号
  byteOffset.i         ; 在文件中的字节偏移
  *obj.PbPDF_Object    ; 已解析的PDF对象(延迟解析)
  parsed.i             ; 是否已解析
EndStructure

;--- PDF已加载文档结构 ---
Structure PbPDF_LoadedDoc
  *readBuf             ; 文件读取缓冲区
  readBufSize.i        ; 缓冲区大小
  pdfVersion$          ; PDF版本字符串
  *xrefEntries.PbPDF_List ; 交叉引用条目列表(PbPDF_LoadedObj)
  *trailerDict.PbPDF_Object; Trailer字典
  *catalogObj.PbPDF_Object ; 文档目录对象
  *pagesObj.PbPDF_Object   ; 根页面节点对象
  pageCount.i          ; 页面总数
  *pageList.PbPDF_List ; 页面对象列表(PbPDF_Object)
  *infoObj.PbPDF_Object   ; 信息字典对象
  validated.i          ; 是否已验证
  fileName$            ; 源文件名
  ; 加密相关字段
  isEncrypted.i        ; 是否加密
  encryptV.i           ; 加密算法版本(V值)
  encryptR.i           ; 加密修订版本(R值)
  encryptKeyLen.i      ; 加密密钥长度(字节)
  encryptPermission.i  ; 权限标志(P值)
  encryptO$            ; O值(hex字符串)
  encryptU$            ; U值(hex字符串)
  encryptID1$          ; 文档ID1(hex字符串)
  encryptKey$          ; 计算得到的加密密钥(hex字符串)
  encryptMetadata.i    ; 是否加密元数据(V=4时有效,0=不加密,1=加密)
EndStructure

;--- 判断字符是否为空白 ---
Procedure.i PbPDF_LexIsWhitespace(c.a)
  ; PDF空白字符：空格(32)、制表符(9)、换行(10)、回车(13)、换页(12)
  Select c
    Case 0, 9, 10, 12, 13, 32
      ProcedureReturn #True
    Default
      ProcedureReturn #False
  EndSelect
EndProcedure

;--- 判断字符是否为分隔符 ---
Procedure.i PbPDF_LexIsDelimiter(c.a)
  ; PDF分隔符：( ) < > [ ] { } / %
  Select c
    Case '(', ')', '<', '>', '[', ']', '{', '}', '/', '%'
      ProcedureReturn #True
    Default
      ProcedureReturn #False
  EndSelect
EndProcedure

;--- 判断字符是否为普通字符（非空白、非分隔符） ---
Procedure.i PbPDF_LexIsRegular(c.a)
  ProcedureReturn Bool(Not PbPDF_LexIsWhitespace(c) And Not PbPDF_LexIsDelimiter(c))
EndProcedure

;--- 跳过空白和注释，返回新位置 ---
Procedure.i PbPDF_LexSkipWS(*buf, bufSize.i, pos.i)
  Protected c.a
  While pos < bufSize
    c = PeekA(*buf + pos)
    ; 跳过空白
    If PbPDF_LexIsWhitespace(c)
      pos + 1
      Continue
    EndIf
    ; 跳过注释(%到行尾)
    If c = '%'
      While pos < bufSize
        c = PeekA(*buf + pos)
        If c = 10 Or c = 13
          pos + 1
          Break
        EndIf
        pos + 1
      Wend
      Continue
    EndIf
    Break
  Wend
  ProcedureReturn pos
EndProcedure

;--- 读取字面字符串（圆括号包围的字符串） ---
; 处理嵌套括号和转义字符
Procedure.s PbPDF_LexReadLiteralString(*buf, bufSize.i, *pos.INTEGER)
  Protected result$ = ""
  Protected depth.i = 1
  Protected c.a, nextC.a
  Protected p.i = *pos\i
  Protected *rawBuf = AllocateMemory(bufSize + 1)
  Protected rawLen.i = 0
  If Not *rawBuf
    While p < bufSize And depth > 0
      c = PeekA(*buf + p)
      If c = '(' : depth + 1 : result$ + "(" : p + 1
      ElseIf c = ')'
        depth - 1 : If depth > 0 : result$ + ")" : EndIf : p + 1
      ElseIf c = '\'
        p + 1 : If p >= bufSize : Break : EndIf
        nextC = PeekA(*buf + p)
        Select nextC
          Case 'n' : result$ + Chr(10)
          Case 'r' : result$ + Chr(13)
          Case 't' : result$ + Chr(9)
          Case 'b' : result$ + Chr(8)
          Case 'f' : result$ + Chr(12)
          Case '(' : result$ + "("
          Case ')' : result$ + ")"
          Case '\' : result$ + "\"
          Default : result$ + Chr(nextC)
        EndSelect
        p + 1
      ElseIf c = 13
        p + 1 : If p < bufSize And PeekA(*buf + p) = 10 : p + 1 : EndIf
        result$ + #LF$
      Else
        result$ + Chr(c) : p + 1
      EndIf
    Wend
    *pos\i = p
    ProcedureReturn result$
  EndIf
  While p < bufSize And depth > 0
    c = PeekA(*buf + p)
    If c = '('
      depth + 1 : PokeA(*rawBuf + rawLen, c) : rawLen + 1 : p + 1
    ElseIf c = ')'
      depth - 1
      If depth > 0 : PokeA(*rawBuf + rawLen, c) : rawLen + 1 : EndIf
      p + 1
    ElseIf c = '\'
      p + 1 : If p >= bufSize : Break : EndIf
      nextC = PeekA(*buf + p)
      Select nextC
        Case 'n' : PokeA(*rawBuf + rawLen, 10) : rawLen + 1
        Case 'r' : PokeA(*rawBuf + rawLen, 13) : rawLen + 1
        Case 't' : PokeA(*rawBuf + rawLen, 9)  : rawLen + 1
        Case 'b' : PokeA(*rawBuf + rawLen, 8)  : rawLen + 1
        Case 'f' : PokeA(*rawBuf + rawLen, 12) : rawLen + 1
        Case '(' : PokeA(*rawBuf + rawLen, '(') : rawLen + 1
        Case ')' : PokeA(*rawBuf + rawLen, ')') : rawLen + 1
        Case '\' : PokeA(*rawBuf + rawLen, '\') : rawLen + 1
        Case '0' To '7'
          Protected oct2$ = Chr(nextC)
          Protected oi2.i
          For oi2 = 1 To 2
            If p + oi2 < bufSize
              Protected oc2.a = PeekA(*buf + p + oi2)
              If oc2 >= '0' And oc2 <= '7' : oct2$ + Chr(oc2) : Else : Break : EndIf
            EndIf
          Next
          PokeA(*rawBuf + rawLen, Val(oct2$)) : rawLen + 1
          p + Len(oct2$) - 1
        Default
          PokeA(*rawBuf + rawLen, nextC) : rawLen + 1
      EndSelect
      p + 1
    ElseIf c = 13
      p + 1 : If p < bufSize And PeekA(*buf + p) = 10 : p + 1 : EndIf
      PokeA(*rawBuf + rawLen, 10) : rawLen + 1
    Else
      PokeA(*rawBuf + rawLen, c) : rawLen + 1 : p + 1
    EndIf
  Wend
  *pos\i = p
  If rawLen >= 2
    Protected b0.a = PeekA(*rawBuf)
    Protected b1.a = PeekA(*rawBuf + 1)
    If b0 = $FE And b1 = $FF
      ; UTF-16BE with BOM：交换字节序为LE后读取
      Protected swapJ.i, swapB2.a
      For swapJ = 2 To rawLen - 2 Step 2
        swapB2 = PeekA(*rawBuf + swapJ)
        PokeA(*rawBuf + swapJ, PeekA(*rawBuf + swapJ + 1))
        PokeA(*rawBuf + swapJ + 1, swapB2)
      Next
      result$ = PeekS(*rawBuf + 2, (rawLen - 2) / 2, #PB_Unicode)
    ElseIf b0 = $FF And b1 = $FE
      result$ = PeekS(*rawBuf + 2, (rawLen - 2) / 2, #PB_Unicode)
    Else
      result$ = PeekS(*rawBuf, rawLen, #PB_UTF8)
      If Len(result$) = 0 And rawLen > 0
        result$ = PeekS(*rawBuf, rawLen, #PB_Ascii)
      EndIf
    EndIf
  ElseIf rawLen > 0
    result$ = PeekS(*rawBuf, rawLen, #PB_Ascii)
  EndIf
  FreeMemory(*rawBuf)
  ProcedureReturn result$
EndProcedure

;--- 读取十六进制字符串（尖括号包围） ---
; 返回原始小写hex字符串，由解析器负责解码
Procedure.s PbPDF_LexReadHexString(*buf, bufSize.i, *pos.INTEGER)
  Protected hex$ = ""
  Protected c.a
  Protected p.i = *pos\i
  While p < bufSize
    c = PeekA(*buf + p)
    If c = '>' : p + 1 : Break : EndIf
    If (c >= '0' And c <= '9') Or (c >= 'a' And c <= 'f') Or (c >= 'A' And c <= 'F')
      hex$ + LCase(Chr(c))
    EndIf
    p + 1
  Wend
  If Len(hex$) % 2 = 1 : hex$ + "0" : EndIf
  *pos\i = p
  ProcedureReturn hex$
EndProcedure

;--- 从缓冲区读取下一个token ---
Procedure.i PbPDF_LexReadToken(*buf, bufSize.i, *pos.INTEGER, *token.PbPDF_Token)
  Protected p.i, c.a, c2.a
  Protected tokenBuf$
  ; 清空token
  *token\tokenType = #PbPDF_TOKEN_EOF
  *token\intValue = 0
  *token\realValue = 0.0
  *token\strValue = ""
  ; 跳过空白和注释
  p = PbPDF_LexSkipWS(*buf, bufSize, *pos\i)
  If p >= bufSize
    *token\tokenType = #PbPDF_TOKEN_EOF
    *pos\i = p
    ProcedureReturn #False
  EndIf
  c = PeekA(*buf + p)
  ; 根据首字符判断token类型
  Select c
    Case '('
      ; 字面字符串
      *token\tokenType = #PbPDF_TOKEN_STRING
      p + 1
      *token\strValue = PbPDF_LexReadLiteralString(*buf, bufSize, @p)
    Case ')'
      ; 不匹配的闭括号
      *token\tokenType = #PbPDF_TOKEN_ERROR
      *token\strValue = ")"
      p + 1
    Case '<'
      ; 可能是十六进制字符串或字典开始
      If p + 1 < bufSize
        c2 = PeekA(*buf + p + 1)
        If c2 = '<'
          ; 字典开始 <<
          *token\tokenType = #PbPDF_TOKEN_DICT_START
          *token\strValue = "<<"
          p + 2
        Else
          ; 十六进制字符串
          *token\tokenType = #PbPDF_TOKEN_HEXSTRING
          p + 1
          *token\strValue = PbPDF_LexReadHexString(*buf, bufSize, @p)
        EndIf
      Else
        ; 单独的<，视为十六进制字符串开始
        *token\tokenType = #PbPDF_TOKEN_HEXSTRING
        p + 1
        *token\strValue = PbPDF_LexReadHexString(*buf, bufSize, @p)
      EndIf
    Case '>'
      ; 可能是字典结束 >>
      If p + 1 < bufSize And PeekA(*buf + p + 1) = '>'
        *token\tokenType = #PbPDF_TOKEN_DICT_END
        *token\strValue = ">>"
        p + 2
      Else
        *token\tokenType = #PbPDF_TOKEN_ERROR
        *token\strValue = ">"
        p + 1
      EndIf
    Case '['
      ; 数组开始
      *token\tokenType = #PbPDF_TOKEN_ARRAY_START
      *token\strValue = "["
      p + 1
    Case ']'
      ; 数组结束
      *token\tokenType = #PbPDF_TOKEN_ARRAY_END
      *token\strValue = "]"
      p + 1
    Case '/'
      ; 名称对象
      *token\tokenType = #PbPDF_TOKEN_NAME
      p + 1
      tokenBuf$ = ""
      While p < bufSize
        c = PeekA(*buf + p)
        If PbPDF_LexIsRegular(c)
          ; 处理#xx十六进制编码的名称字符
          If c = '#' And p + 2 < bufSize
            Protected hexChar$ = Chr(PeekA(*buf + p + 1)) + Chr(PeekA(*buf + p + 2))
            Protected charCode.i = Val("$" + hexChar$)
            If charCode > 0
              tokenBuf$ + Chr(charCode)
              p + 3
              Continue
            EndIf
          EndIf
          tokenBuf$ + Chr(c)
          p + 1
        Else
          Break
        EndIf
      Wend
      *token\strValue = tokenBuf$
    Case '{'
      ; 过时的大括号，跳过
      *token\tokenType = #PbPDF_TOKEN_ERROR
      *token\strValue = "{"
      p + 1
    Case '}'
      *token\tokenType = #PbPDF_TOKEN_ERROR
      *token\strValue = "}"
      p + 1
    Case '%'
      ; 注释，跳过到行尾
      While p < bufSize
        c = PeekA(*buf + p)
        If c = 10 Or c = 13
          Break
        EndIf
        p + 1
      Wend
      ; 递归读取下一个token
      *pos\i = p
      ProcedureReturn PbPDF_LexReadToken(*buf, bufSize, *pos, *token)
    Default
      ; 数字、关键字或其他普通token
      tokenBuf$ = ""
      ; 首先检查是否为数字（可能带符号）
      If (c >= '0' And c <= '9') Or c = '-' Or c = '+' Or c = '.'
        ; 收集连续的数字/符号/小数点字符
        Protected hasDot.i = #False
        Protected hasDigit.i = #False
        While p < bufSize
          c = PeekA(*buf + p)
          If c >= '0' And c <= '9'
            hasDigit = #True
            tokenBuf$ + Chr(c)
            p + 1
          ElseIf c = '.' And Not hasDot
            hasDot = #True
            tokenBuf$ + "."
            p + 1
          ElseIf (c = '-' Or c = '+') And Len(tokenBuf$) = 0
            tokenBuf$ + Chr(c)
            p + 1
          Else
            Break
          EndIf
        Wend
        ; 判断是整数还是实数
        If hasDot
          *token\tokenType = #PbPDF_TOKEN_REAL
          *token\realValue = ValF(tokenBuf$)
          *token\intValue = Int(ValF(tokenBuf$))
        ElseIf hasDigit
          *token\tokenType = #PbPDF_TOKEN_NUMBER
          *token\intValue = Val(tokenBuf$)
          *token\realValue = ValF(tokenBuf$)
        Else
          ; 只有符号没有数字，视为关键字
          *token\tokenType = #PbPDF_TOKEN_KEYWORD
          *token\strValue = tokenBuf$
        EndIf
      Else
        ; 收集关键字token
        While p < bufSize
          c = PeekA(*buf + p)
          If PbPDF_LexIsRegular(c)
            tokenBuf$ + Chr(c)
            p + 1
          Else
            Break
          EndIf
        Wend
        *token\tokenType = #PbPDF_TOKEN_KEYWORD
        *token\strValue = tokenBuf$
      EndIf
  EndSelect
  *pos\i = p
  ProcedureReturn #True
EndProcedure

;--- 从缓冲区读取原始字节（用于读取流内容） ---
Procedure.s PbPDF_LexReadRawBytes(*buf, bufSize.i, start.i, length.i)
  Protected result$ = ""
  Protected i.i
  If start + length > bufSize
    length = bufSize - start
  EndIf
  If length <= 0
    ProcedureReturn ""
  EndIf
  ; 使用字节方式读取，避免字符串编码问题
  Protected *tempBuf = AllocateMemory(length + 1)
  If *tempBuf
    CopyMemory(*buf + start, *tempBuf, length)
    PokeA(*tempBuf + length, 0)
    result$ = PeekS(*tempBuf, length, #PB_Ascii)
    FreeMemory(*tempBuf)
  EndIf
  ProcedureReturn result$
EndProcedure

;=============================================================================
; 第29部分：PDF语法分析器（Parser）
; 将词法token解析为PDF对象树
;=============================================================================

;--- 解析PDF对象（递归下降解析器） ---
; 从缓冲区指定位置解析一个完整的PDF对象
Procedure.i PbPDF_ParseObj(*buf, bufSize.i, *pos.INTEGER, *loadedObjs.PbPDF_List)
  Protected token.PbPDF_Token
  Protected *result.PbPDF_Object = 0
  Protected *subObj.PbPDF_Object = 0
  Protected *keyObj.PbPDF_Object = 0
  Protected *valObj.PbPDF_Object = 0
  Protected keyName$
  Protected readOk.i
  ; 读取下一个token
  readOk = PbPDF_LexReadToken(*buf, bufSize, *pos, @token)
  If Not readOk Or token\tokenType = #PbPDF_TOKEN_EOF
    ProcedureReturn 0
  EndIf
  Select token\tokenType
    Case #PbPDF_TOKEN_NUMBER
      ; 整数，可能是间接引用的一部分（如 "5 0 R"）
      Protected savedPos.i = *pos\i
      Protected nextToken.PbPDF_Token
      Protected thirdToken.PbPDF_Token
      ; 尝试读取 "gen R"
      If PbPDF_LexReadToken(*buf, bufSize, *pos, @nextToken)
        If nextToken\tokenType = #PbPDF_TOKEN_NUMBER
          If PbPDF_LexReadToken(*buf, bufSize, *pos, @thirdToken)
            If thirdToken\tokenType = #PbPDF_TOKEN_KEYWORD And thirdToken\strValue = "R"
              ; 这是一个间接引用：objNum genNum R
              *result = PbPDF_NumberNew(token\intValue)
              If *result
                *result\objType = #PbPDF_OBJ_INDIRECT
                *result\objId = token\intValue
                *result\genNo = nextToken\intValue
              EndIf
              ProcedureReturn *result
            EndIf
          EndIf
        EndIf
      EndIf
      ; 不是间接引用，回退位置
      *pos\i = savedPos
      ; 返回普通整数
      *result = PbPDF_NumberNew(token\intValue)
    Case #PbPDF_TOKEN_REAL
      ; 实数
      *result = PbPDF_RealNew(token\realValue)
    Case #PbPDF_TOKEN_STRING
      ; 字面字符串
      *result = PbPDF_StringNew(token\strValue)
    Case #PbPDF_TOKEN_HEXSTRING
      ; 十六进制字符串：检测是否为UTF-16BE文本，否则作为Binary对象
      Protected hexStrLen.i = Len(token\strValue)
      If hexStrLen >= 4 And Left(token\strValue, 4) = "feff"
        ; UTF-16BE with BOM：解码为String对象
        ; PureBasic的#PB_Unicode是UTF-16LE，需要交换字节序
        Protected hexByteLen2.i = hexStrLen / 2
        Protected *hexBuf2 = AllocateMemory(hexByteLen2 + 2)
        If *hexBuf2
          Protected bi2.i, hi3$, lo3$, byteVal2.i
          For bi2 = 1 To hexStrLen Step 2
            hi3$ = Mid(token\strValue, bi2, 1)
            lo3$ = Mid(token\strValue, bi2 + 1, 1)
            byteVal2 = Val("$" + hi3$ + lo3$)
            PokeA(*hexBuf2 + (bi2 - 1) / 2, byteVal2)
          Next
          ; 交换字节序：BE→LE（跳过BOM的2字节）
          Protected swapI.i, swapB.a
          For swapI = 2 To hexByteLen2 - 2 Step 2
            swapB = PeekA(*hexBuf2 + swapI)
            PokeA(*hexBuf2 + swapI, PeekA(*hexBuf2 + swapI + 1))
            PokeA(*hexBuf2 + swapI + 1, swapB)
          Next
          *result = PbPDF_StringNew(PeekS(*hexBuf2 + 2, (hexByteLen2 - 2) / 2, #PB_Unicode))
          FreeMemory(*hexBuf2)
        EndIf
      ElseIf hexStrLen >= 4 And Left(token\strValue, 4) = "fffe"
        ; UTF-16LE with BOM：解码为String对象
        Protected hexByteLen3.i = hexStrLen / 2
        Protected *hexBuf3 = AllocateMemory(hexByteLen3 + 2)
        If *hexBuf3
          Protected bi3.i, hi4$, lo4$, byteVal3.i
          For bi3 = 1 To hexStrLen Step 2
            hi4$ = Mid(token\strValue, bi3, 1)
            lo4$ = Mid(token\strValue, bi3 + 1, 1)
            byteVal3 = Val("$" + hi4$ + lo4$)
            PokeA(*hexBuf3 + (bi3 - 1) / 2, byteVal3)
          Next
          *result = PbPDF_StringNew(PeekS(*hexBuf3 + 2, (hexByteLen3 - 2) / 2, #PB_Unicode))
          FreeMemory(*hexBuf3)
        EndIf
      ElseIf hexStrLen > 0
        ; 其他hex字符串：检查是否包含非ASCII字节(>=0x80)
        ; 如果包含非ASCII字节，作为Binary对象存储（如O值、U值等加密数据）
        ; 如果全部是ASCII字节，尝试UTF-8解码为String对象
        Protected hexByteLen4.i = hexStrLen / 2
        Protected *hexBuf4 = AllocateMemory(hexByteLen4 + 1)
        If *hexBuf4
          Protected bi4.i, hi5$, lo5$, byteVal4.i
          Protected hasHighByte.i = #False
          For bi4 = 1 To hexStrLen Step 2
            hi5$ = Mid(token\strValue, bi4, 1)
            lo5$ = Mid(token\strValue, bi4 + 1, 1)
            byteVal4 = Val("$" + hi5$ + lo5$)
            PokeA(*hexBuf4 + (bi4 - 1) / 2, byteVal4)
            If byteVal4 >= $80
              hasHighByte = #True
            EndIf
          Next
          If hasHighByte
            ; 包含非ASCII字节，作为Binary对象存储
            *result = PbPDF_BinaryNew(*hexBuf4, hexByteLen4)
          Else
            ; 全部ASCII字节，尝试UTF-8解码为String对象
            Protected utf8Str$ = PeekS(*hexBuf4, hexByteLen4, #PB_UTF8)
            If Len(utf8Str$) > 0
              *result = PbPDF_StringNew(utf8Str$)
            Else
              *result = PbPDF_BinaryNew(*hexBuf4, hexByteLen4)
            EndIf
          EndIf
          FreeMemory(*hexBuf4)
        EndIf
      Else
        Protected *emptyBuf = AllocateMemory(1)
        If *emptyBuf
          PokeA(*emptyBuf, 0)
          *result = PbPDF_BinaryNew(*emptyBuf, 0)
          FreeMemory(*emptyBuf)
        EndIf
      EndIf
    Case #PbPDF_TOKEN_NAME
      ; 名称对象
      *result = PbPDF_NameNew(token\strValue)
    Case #PbPDF_TOKEN_ARRAY_START
      ; 数组：[obj1 obj2 ...]
      *result = PbPDF_ArrayNew()
      If *result
        While #True
          ; 检查下一个token是否为数组结束
          Protected arrPos.i = *pos\i
          Protected arrToken.PbPDF_Token
          PbPDF_LexReadToken(*buf, bufSize, @arrPos, @arrToken)
          If arrToken\tokenType = #PbPDF_TOKEN_ARRAY_END
            *pos\i = arrPos
            Break
          EndIf
          If arrToken\tokenType = #PbPDF_TOKEN_EOF
            Break
          EndIf
          ; 递归解析数组元素
          *subObj = PbPDF_ParseObj(*buf, bufSize, *pos, *loadedObjs)
          If *subObj
            PbPDF_ArrayAdd(*result, *subObj)
          Else
            Break
          EndIf
        Wend
      EndIf
    Case #PbPDF_TOKEN_DICT_START
      ; 字典：<< /Key1 Value1 /Key2 Value2 ... >>
      *result = PbPDF_DictNew()
      If *result
        While #True
          ; 读取键（必须是Name类型）
          Protected dictPos.i = *pos\i
          Protected dictToken.PbPDF_Token
          PbPDF_LexReadToken(*buf, bufSize, @dictPos, @dictToken)
          If dictToken\tokenType = #PbPDF_TOKEN_DICT_END
            *pos\i = dictPos
            Break
          EndIf
          If dictToken\tokenType = #PbPDF_TOKEN_EOF
            Break
          EndIf
          ; 键必须是Name
          If dictToken\tokenType = #PbPDF_TOKEN_NAME
            keyName$ = dictToken\strValue
            *pos\i = dictPos
            ; 递归解析值
            *valObj = PbPDF_ParseObj(*buf, bufSize, *pos, *loadedObjs)
            If *valObj
              PbPDF_DictAdd(*result, keyName$, *valObj)
            Else
              ; 值解析失败，使用Null代替
              PbPDF_DictAdd(*result, keyName$, PbPDF_NullNew())
            EndIf
          Else
            ; 键不是Name，跳过这个token
            *pos\i = dictPos
            ; 尝试读取值并跳过
            *valObj = PbPDF_ParseObj(*buf, bufSize, *pos, *loadedObjs)
            Break
          EndIf
        Wend
      EndIf
    Case #PbPDF_TOKEN_KEYWORD
      ; 关键字处理
      Select token\strValue
        Case "true"
          *result = PbPDF_BooleanNew(#True)
        Case "false"
          *result = PbPDF_BooleanNew(#False)
        Case "null"
          *result = PbPDF_NullNew()
        Default
          ; 未知关键字，返回Null
          *result = PbPDF_NullNew()
      EndSelect
    Case #PbPDF_TOKEN_DICT_END
      ; 多余的字典结束标记
      *result = 0
    Case #PbPDF_TOKEN_ARRAY_END
      ; 多余的数组结束标记
      *result = 0
    Default
      *result = PbPDF_NullNew()
  EndSelect
  ProcedureReturn *result
EndProcedure

;--- 解析间接对象定义（obj ... endobj） ---
; 返回解析后的PbPDF_Object，设置objId和genNo
Procedure.i PbPDF_ParseIndirectObj(*buf, bufSize.i, *pos.INTEGER, *loadedObjs.PbPDF_List)
  Protected token.PbPDF_Token
  Protected objNum.i, genNum.i
  Protected *obj.PbPDF_Object = 0
  ; 读取对象编号
  If Not PbPDF_LexReadToken(*buf, bufSize, *pos, @token)
    ProcedureReturn 0
  EndIf
  If token\tokenType <> #PbPDF_TOKEN_NUMBER
    ProcedureReturn 0
  EndIf
  objNum = token\intValue
  ; 读取生成编号
  If Not PbPDF_LexReadToken(*buf, bufSize, *pos, @token)
    ProcedureReturn 0
  EndIf
  If token\tokenType <> #PbPDF_TOKEN_NUMBER
    ProcedureReturn 0
  EndIf
  genNum = token\intValue
  ; 读取"obj"关键字
  If Not PbPDF_LexReadToken(*buf, bufSize, *pos, @token)
    ProcedureReturn 0
  EndIf
  If token\tokenType <> #PbPDF_TOKEN_KEYWORD Or token\strValue <> "obj"
    ProcedureReturn 0
  EndIf
  ; 解析对象内容
  *obj = PbPDF_ParseObj(*buf, bufSize, *pos, *loadedObjs)
  If Not *obj
    ProcedureReturn 0
  EndIf
  ; 设置对象编号和生成号
  *obj\objId = objNum
  *obj\genNo = genNum
  ; 检查是否有stream关键字
  Protected savedPos.i = *pos\i
  Protected streamToken.PbPDF_Token
  If PbPDF_LexReadToken(*buf, bufSize, @savedPos, @streamToken)
    If streamToken\tokenType = #PbPDF_TOKEN_KEYWORD And streamToken\strValue = "stream"
      *pos\i = savedPos
      ; 跳过stream关键字后的换行
      Protected sp.i = *pos\i
      If sp < bufSize And PeekA(*buf + sp) = 13
        sp + 1
      EndIf
      If sp < bufSize And PeekA(*buf + sp) = 10
        sp + 1
      EndIf
      ; 获取流长度
      Protected *lenObj.PbPDF_Object = PbPDF_DictGetValue(*obj, "Length")
      Protected streamLen.i = 0
      If *lenObj
        If *lenObj\objType = #PbPDF_OBJ_NUMBER
          streamLen = *lenObj\numberValue
        ElseIf *lenObj\objType = #PbPDF_OBJ_INDIRECT
          ; 间接引用的长度，尝试从已加载对象中查找
          Protected li.i
          If *loadedObjs
            For li = 0 To PbPDF_ListCount(*loadedObjs) - 1
              Protected *lo.PbPDF_LoadedObj = PbPDF_ListGetPointer(*loadedObjs, li)
              If *lo And *lo\objNum = *lenObj\objId And *lo\parsed And *lo\obj
                If *lo\obj\objType = #PbPDF_OBJ_NUMBER
                  streamLen = *lo\obj\numberValue
                  Break
                EndIf
              EndIf
            Next
          EndIf
          ; 如果找不到，尝试从当前位置向后搜索endstream
          If streamLen <= 0
            Protected searchPos.i = sp
            While searchPos + 9 < bufSize
              If PeekA(*buf + searchPos) = 'e'
                ; 逐字节比较"endstream"
                Protected esMatch.i = 0
                Protected esStr$ = "endstream"
                While esMatch < 9
                  If PeekA(*buf + searchPos + esMatch) = Asc(Mid(esStr$, esMatch + 1, 1))
                    esMatch + 1
                  Else
                    Break
                  EndIf
                Wend
                If esMatch = 9
                  streamLen = searchPos - sp
                  Break
                EndIf
              EndIf
              searchPos + 1
            Wend
          EndIf
        EndIf
      Else
        ; 没有Length字段，搜索endstream
        Protected searchP.i = sp
        While searchP + 9 < bufSize
          If PeekA(*buf + searchP) = 'e'
            ; 逐字节比较"endstream"
            Protected es2Match.i = 0
            Protected es2Str$ = "endstream"
            While es2Match < 9
              If PeekA(*buf + searchP + es2Match) = Asc(Mid(es2Str$, es2Match + 1, 1))
                es2Match + 1
              Else
                Break
              EndIf
            Wend
            If es2Match = 9
              streamLen = searchP - sp
              Break
            EndIf
          EndIf
          searchP + 1
        Wend
      EndIf
      ; 读取流数据
      If streamLen > 0 And sp + streamLen <= bufSize
        Protected *streamObj.PbPDF_Stream = PbPDF_MemStreamNew()
        If *streamObj
          PbPDF_StreamWriteData(*streamObj, *buf + sp, streamLen)
          *obj\stream = *streamObj
        EndIf
        ; 移动位置到流数据之后
        *pos\i = sp + streamLen
        ; 跳过可能的换行
        If *pos\i < bufSize And PeekA(*buf + *pos\i) = 13
          *pos\i + 1
        EndIf
        If *pos\i < bufSize And PeekA(*buf + *pos\i) = 10
          *pos\i + 1
        EndIf
      EndIf
      ; 读取并跳过endstream关键字
      Protected endStreamToken.PbPDF_Token
      PbPDF_LexReadToken(*buf, bufSize, *pos, @endStreamToken)
    Else
      ; 没有stream关键字，保持位置不变
    EndIf
  EndIf
  ; 读取并跳过endobj关键字
  Protected endObjPos.i = *pos\i
  Protected endObjToken.PbPDF_Token
  If PbPDF_LexReadToken(*buf, bufSize, @endObjPos, @endObjToken)
    If endObjToken\tokenType = #PbPDF_TOKEN_KEYWORD And endObjToken\strValue = "endobj"
      *pos\i = endObjPos
    EndIf
  EndIf
  ProcedureReturn *obj
EndProcedure

;=============================================================================
; 第30部分：PDF文件加载
; 读取现有PDF文件并构建对象树
;=============================================================================

;--- 读取文件到内存缓冲区 ---
; 使用Windows API作为备选方案，确保能读取系统目录文件
Procedure.i PbPDF_ReadFileToBuf(fileName$, *bufRef.INTEGER, *sizeRef.INTEGER)
  Protected fileID.i, fileSize.i, *buf
  Protected hFile.i, bytesRead.i
  fileID = ReadFile(#PB_Any, fileName$)
  If fileID
    fileSize = Lof(fileID)
    If fileSize <= 0
      CloseFile(fileID)
      ProcedureReturn #False
    EndIf
    *buf = AllocateMemory(fileSize + 1)
    If Not *buf
      CloseFile(fileID)
      ProcedureReturn #False
    EndIf
    If ReadData(fileID, *buf, fileSize) <> fileSize
      CloseFile(fileID)
      FreeMemory(*buf)
      ProcedureReturn #False
    EndIf
    CloseFile(fileID)
    PokeA(*buf + fileSize, 0)
    *bufRef\i = *buf
    *sizeRef\i = fileSize
    ProcedureReturn #True
  EndIf
  ; 使用Windows API备选方案
  hFile = CreateFile_(@fileName$, #PbPDF_WIN_GENERIC_READ, #PbPDF_WIN_FILE_SHARE_READ | #PbPDF_WIN_FILE_SHARE_WRITE, 0, #PbPDF_WIN_OPEN_EXISTING, #PbPDF_WIN_FILE_ATTRIBUTE_NORMAL, 0)
  If hFile = #PbPDF_WIN_INVALID_HANDLE_VALUE Or hFile = 0
    ProcedureReturn #False
  EndIf
  fileSize = GetFileSize_(hFile, 0)
  If fileSize <= 0 Or fileSize = $FFFFFFFF
    CloseHandle_(hFile)
    ProcedureReturn #False
  EndIf
  *buf = AllocateMemory(fileSize + 1)
  If Not *buf
    CloseHandle_(hFile)
    ProcedureReturn #False
  EndIf
  bytesRead = 0
  If Not ReadFile_(hFile, *buf, fileSize, @bytesRead, 0) Or bytesRead <> fileSize
    CloseHandle_(hFile)
    FreeMemory(*buf)
    ProcedureReturn #False
  EndIf
  CloseHandle_(hFile)
  PokeA(*buf + fileSize, 0)
  *bufRef\i = *buf
  *sizeRef\i = fileSize
  ProcedureReturn #True
EndProcedure

;--- 在缓冲区中查找startxref位置 ---
Procedure.i PbPDF_FindStartXRef(*buf, bufSize.i)
  Protected searchStart.i
  Protected searchPos.i
  Protected matchCount.i
  Protected startXRef$ = "startxref"
  Protected startXRefLen.i = 9
  Protected p.i
  Protected offsetStr$
  ; 从文件末尾向前搜索"startxref"字符串
  ; startxref通常在文件末尾附近，所以从后向前搜索
  searchStart = bufSize - 1
  For searchPos = searchStart To 0 Step -1
    ; 使用逐字节比较，避免Unicode模式下的PeekS问题
    If PeekA(*buf + searchPos) = 's'
      matchCount = 0
      While matchCount < startXRefLen
        If PeekA(*buf + searchPos + matchCount) = Asc(Mid(startXRef$, matchCount + 1, 1))
          matchCount + 1
        Else
          Break
        EndIf
      Wend
      If matchCount = startXRefLen
        ; 找到startxref，读取后面的偏移值
        p = searchPos + startXRefLen
        ; 跳过空白
        While p < bufSize And (PeekA(*buf + p) = 10 Or PeekA(*buf + p) = 13 Or PeekA(*buf + p) = 32)
          p + 1
        Wend
        ; 读取偏移值
        offsetStr$ = ""
        While p < bufSize And PeekA(*buf + p) >= '0' And PeekA(*buf + p) <= '9'
          offsetStr$ + Chr(PeekA(*buf + p))
          p + 1
        Wend
        If offsetStr$ <> ""
          ProcedureReturn Val(offsetStr$)
        EndIf
        Break
      EndIf
    EndIf
  Next
  ProcedureReturn -1
EndProcedure

;--- 解析交叉引用表 ---
; 从xref位置开始解析，返回xref条目列表和trailer字典
Procedure.i PbPDF_ParseXRefTable(*buf, bufSize.i, xrefPos.i, *loadedObjs.PbPDF_List, *trailerRef.INTEGER)
  Protected token.PbPDF_Token
  Protected pos.i = xrefPos
  Protected objNum.i, objCount.i, objOffset.i, objGen.i, objFlag$
  Protected entry$
  Protected i.i
  ; 读取"xref"关键字
  PbPDF_LexReadToken(*buf, bufSize, @pos, @token)
  If token\tokenType <> #PbPDF_TOKEN_KEYWORD Or token\strValue <> "xref"
    ; 可能是交叉引用流（PDF 1.5+），暂不支持
    ProcedureReturn #False
  EndIf
  ; 解析xref段
  While #True
    pos = PbPDF_LexSkipWS(*buf, bufSize, pos)
    ; 读取子段起始编号或trailer
    PbPDF_LexReadToken(*buf, bufSize, @pos, @token)
    If token\tokenType = #PbPDF_TOKEN_KEYWORD And token\strValue = "trailer"
      Break
    EndIf
    If token\tokenType <> #PbPDF_TOKEN_NUMBER
      Break
    EndIf
    objNum = token\intValue
    ; 读取子段条目数
    PbPDF_LexReadToken(*buf, bufSize, @pos, @token)
    If token\tokenType <> #PbPDF_TOKEN_NUMBER
      Break
    EndIf
    objCount = token\intValue
    ; 读取每个条目
    For i = 0 To objCount - 1
      pos = PbPDF_LexSkipWS(*buf, bufSize, pos)
      ; 每个条目格式：nnnnnnnnnn ggggg n/f
      If pos + 20 > bufSize
        Break
      EndIf
      ; 使用逐字节方式读取xref条目，避免Unicode模式下的PeekS问题
      entry$ = ""
      Protected ei.i
      For ei = 0 To 19
        If pos + ei < bufSize
          entry$ + Chr(PeekA(*buf + pos + ei))
        EndIf
      Next
      objOffset = Val(StringField(entry$, 1, " "))
      objGen = Val(StringField(entry$, 2, " "))
      objFlag$ = Trim(StringField(entry$, 3, " "))
      ; 移除可能的CR/LF字符(第三方PDF的xref条目可能为"n\r"格式)
      While Len(objFlag$) > 0 And (Right(objFlag$, 1) = Chr(13) Or Right(objFlag$, 1) = Chr(10))
        objFlag$ = Left(objFlag$, Len(objFlag$) - 1)
      Wend
      ; 只处理使用中的条目
      If objFlag$ = "n" And objOffset > 0
        Protected *lo.PbPDF_LoadedObj = AllocateMemory(SizeOf(PbPDF_LoadedObj))
        If *lo
          *lo\objNum = objNum + i
          *lo\genNum = objGen
          *lo\byteOffset = objOffset
          *lo\obj = 0
          *lo\parsed = #False
          PbPDF_ListAddPointer(*loadedObjs, *lo)
        EndIf
      EndIf
      ; 跳到下一行
      While pos < bufSize And PeekA(*buf + pos) <> 10
        pos + 1
      Wend
      If pos < bufSize
        pos + 1
      EndIf
    Next
    objNum + objCount
  Wend
  ; 解析Trailer字典
  Protected *trailerObj.PbPDF_Object = PbPDF_ParseObj(*buf, bufSize, @pos, *loadedObjs)
  If *trailerObj And *trailerObj\objType = #PbPDF_OBJ_DICT
    *trailerRef\i = *trailerObj
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

;--- 延迟解析指定编号的间接对象 ---
Procedure.i PbPDF_ResolveObj(*buf, bufSize.i, objNum.i, *loadedObjs.PbPDF_List)
  Protected i.i, *lo.PbPDF_LoadedObj
  Protected pos.i
  Protected *obj.PbPDF_Object
  ; 在已加载对象列表中查找
  If *loadedObjs
    For i = 0 To PbPDF_ListCount(*loadedObjs) - 1
      *lo = PbPDF_ListGetPointer(*loadedObjs, i)
      If *lo And *lo\objNum = objNum
        ; 如果已经解析过，直接返回
        If *lo\parsed And *lo\obj
          ProcedureReturn *lo\obj
        EndIf
        ; 延迟解析：从文件中的偏移位置解析对象
        If *lo\byteOffset > 0 And *lo\byteOffset < bufSize
          pos = *lo\byteOffset
          *obj = PbPDF_ParseIndirectObj(*buf, bufSize, @pos, *loadedObjs)
          If *obj
            *lo\obj = *obj
            *lo\parsed = #True
            ProcedureReturn *obj
          EndIf
        EndIf
        Break
      EndIf
    Next
  EndIf
  ProcedureReturn 0
EndProcedure

;--- 释放已加载文档 ---
Procedure PbPDF_FreeLoadedDoc(*ldoc.PbPDF_LoadedDoc)
  Protected i.i
  If Not *ldoc
    ProcedureReturn
  EndIf
  ; 释放交叉引用条目
  If *ldoc\xrefEntries
    For i = 0 To PbPDF_ListCount(*ldoc\xrefEntries) - 1
      Protected *lo.PbPDF_LoadedObj = PbPDF_ListGetPointer(*ldoc\xrefEntries, i)
      If *lo
        If *lo\obj
          PbPDF_ObjFree(*lo\obj)
        EndIf
        FreeMemory(*lo)
      EndIf
    Next
    PbPDF_ListFree(*ldoc\xrefEntries)
  EndIf
  ; 释放页面列表（页面对象属于xref条目，不需要单独释放）
  If *ldoc\pageList
    PbPDF_ListFree(*ldoc\pageList)
  EndIf
  ; 释放Trailer字典
  If *ldoc\trailerDict
    PbPDF_ObjFree(*ldoc\trailerDict)
  EndIf
  ; 释放读取缓冲区
  If *ldoc\readBuf
    FreeMemory(*ldoc\readBuf)
  EndIf
  FreeMemory(*ldoc)
EndProcedure

;--- 递归收集页面树中的所有页面对象 ---
Procedure PbPDF_CollectPages(*buf, bufSize.i, *nodeObj.PbPDF_Object, *loadedObjs.PbPDF_List, *pageList.PbPDF_List)
  Protected *kidsObj.PbPDF_Object
  Protected *kidObj.PbPDF_Object
  Protected *typeObj.PbPDF_Object
  Protected *resolvedKid.PbPDF_Object
  Protected kidCount.i, i.i
  If Not *nodeObj
    ProcedureReturn
  EndIf
  ; 检查节点类型
  *typeObj = PbPDF_DictGetValue(*nodeObj, "Type")
  If *typeObj And *typeObj\objType = #PbPDF_OBJ_NAME
    If *typeObj\nameValue = "Page"
      ; 这是一个页面对象，添加到列表
      PbPDF_ListAddPointer(*pageList, *nodeObj)
      ProcedureReturn
    ElseIf *typeObj\nameValue = "Pages"
      ; 这是一个页面树节点，递归处理子节点
      *kidsObj = PbPDF_DictGetValue(*nodeObj, "Kids")
      If *kidsObj
        ; 如果Kids是间接引用，先解析
        If *kidsObj\objType = #PbPDF_OBJ_INDIRECT
          *kidsObj = PbPDF_ResolveObj(*buf, bufSize, *kidsObj\objId, *loadedObjs)
        EndIf
        If *kidsObj And *kidsObj\objType = #PbPDF_OBJ_ARRAY
          kidCount = PbPDF_ArrayGetCount(*kidsObj)
          For i = 0 To kidCount - 1
            *kidObj = PbPDF_ArrayGetItem(*kidsObj, i)
            If *kidObj
              ; 如果子节点是间接引用，先解析
              If *kidObj\objType = #PbPDF_OBJ_INDIRECT
                *resolvedKid = PbPDF_ResolveObj(*buf, bufSize, *kidObj\objId, *loadedObjs)
                If *resolvedKid
                  PbPDF_CollectPages(*buf, bufSize, *resolvedKid, *loadedObjs, *pageList)
                EndIf
              Else
                PbPDF_CollectPages(*buf, bufSize, *kidObj, *loadedObjs, *pageList)
              EndIf
            EndIf
          Next
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

;--- 从PDF文件加载文档 ---
; 返回PbPDF_LoadedDoc结构指针，失败返回0
Procedure.i PbPDF_LoadFromFile(fileName$)
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *buf, bufSize.i
  Protected header$
  Protected xrefPos.i
  Protected trailerRef.INTEGER
  Protected *catalogObj.PbPDF_Object
  Protected *pagesRefObj.PbPDF_Object
  Protected *pagesObj.PbPDF_Object
  Protected *infoRefObj.PbPDF_Object
  Protected *infoObj.PbPDF_Object
  ; 直接尝试读取文件到内存（不使用FileSize预检查，因为文件可能刚创建）
  If Not PbPDF_ReadFileToBuf(fileName$, @*buf, @bufSize)
    ProcedureReturn 0
  EndIf
  ; 验证PDF文件头（使用逐字节方式避免Unicode模式下的PeekS问题）
  header$ = ""
  Protected hi3.i
  For hi3 = 0 To 7
    If hi3 < bufSize
      header$ + Chr(PeekA(*buf + hi3))
    EndIf
  Next
  If Left(header$, 5) <> "%PDF-"
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  ; 创建已加载文档结构
  *ldoc = AllocateMemory(SizeOf(PbPDF_LoadedDoc))
  If Not *ldoc
    FreeMemory(*buf)
    ProcedureReturn 0
  EndIf
  InitializeStructure(*ldoc, PbPDF_LoadedDoc)
  *ldoc\readBuf = *buf
  *ldoc\readBufSize = bufSize
  *ldoc\fileName$ = fileName$
  *ldoc\validated = #False
  ; 提取PDF版本号
  Protected verEnd.i = 5
  While verEnd < bufSize And verEnd < 20
    Protected vc.a = PeekA(*buf + verEnd)
    If vc = 10 Or vc = 13 Or vc = 32 Or vc = '%'
      Break
    EndIf
    verEnd + 1
  Wend
  ; 使用逐字节方式读取版本号
  *ldoc\pdfVersion$ = ""
  Protected vi.i
  For vi = 0 To verEnd - 1
    If vi < bufSize
      *ldoc\pdfVersion$ + Chr(PeekA(*buf + vi))
    EndIf
  Next
  ; 创建xref条目列表
  *ldoc\xrefEntries = PbPDF_ListNew(SizeOf(PbPDF_LoadedObj))
  If Not *ldoc\xrefEntries
    FreeMemory(*buf)
    FreeMemory(*ldoc)
    ProcedureReturn 0
  EndIf
  ; 创建页面列表
  *ldoc\pageList = PbPDF_ListNew(SizeOf(PbPDF_Object))
  ; 查找startxref
  xrefPos = PbPDF_FindStartXRef(*buf, bufSize)
  If xrefPos <= 0
    FreeMemory(*buf)
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  ; 解析交叉引用表
  trailerRef\i = 0
  If Not PbPDF_ParseXRefTable(*buf, bufSize, xrefPos, *ldoc\xrefEntries, @trailerRef)
    FreeMemory(*buf)
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  *ldoc\trailerDict = trailerRef\i
  ; 从Trailer获取Catalog引用
  *catalogObj = PbPDF_DictGetValue(*ldoc\trailerDict, "Root")
  If *catalogObj And *catalogObj\objType = #PbPDF_OBJ_INDIRECT
    *catalogObj = PbPDF_ResolveObj(*buf, bufSize, *catalogObj\objId, *ldoc\xrefEntries)
  EndIf
  *ldoc\catalogObj = *catalogObj
  ; 从Catalog获取Pages引用
  If *catalogObj
    *pagesRefObj = PbPDF_DictGetValue(*catalogObj, "Pages")
    If *pagesRefObj
      If *pagesRefObj\objType = #PbPDF_OBJ_INDIRECT
        *pagesObj = PbPDF_ResolveObj(*buf, bufSize, *pagesRefObj\objId, *ldoc\xrefEntries)
      Else
        *pagesObj = *pagesRefObj
      EndIf
      *ldoc\pagesObj = *pagesObj
      ; 收集所有页面
      PbPDF_CollectPages(*buf, bufSize, *pagesObj, *ldoc\xrefEntries, *ldoc\pageList)
      *ldoc\pageCount = PbPDF_ListCount(*ldoc\pageList)
    EndIf
    ; 从Trailer获取Info引用
    *infoRefObj = PbPDF_DictGetValue(*ldoc\trailerDict, "Info")
    If *infoRefObj
      If *infoRefObj\objType = #PbPDF_OBJ_INDIRECT
        *infoObj = PbPDF_ResolveObj(*buf, bufSize, *infoRefObj\objId, *ldoc\xrefEntries)
      Else
        *infoObj = *infoRefObj
      EndIf
      *ldoc\infoObj = *infoObj
    EndIf
    ; 检测加密字典
    *ldoc\isEncrypted = #False
    Protected *encryptRefObj.PbPDF_Object = PbPDF_DictGetValue(*ldoc\trailerDict, "Encrypt")
    If *encryptRefObj
      Protected *encryptObj.PbPDF_Object
      If *encryptRefObj\objType = #PbPDF_OBJ_INDIRECT
        *encryptObj = PbPDF_ResolveObj(*buf, bufSize, *encryptRefObj\objId, *ldoc\xrefEntries)
      Else
        *encryptObj = *encryptRefObj
      EndIf
      If *encryptObj And *encryptObj\objType = #PbPDF_OBJ_DICT
        *ldoc\isEncrypted = #True
        ; 解析加密参数
        Protected *vObj.PbPDF_Object = PbPDF_DictGetValue(*encryptObj, "V")
        Protected *rObj.PbPDF_Object = PbPDF_DictGetValue(*encryptObj, "R")
        Protected *lObj.PbPDF_Object = PbPDF_DictGetValue(*encryptObj, "Length")
        Protected *pObj.PbPDF_Object = PbPDF_DictGetValue(*encryptObj, "P")
        Protected *oObj.PbPDF_Object = PbPDF_DictGetValue(*encryptObj, "O")
        Protected *uObj.PbPDF_Object = PbPDF_DictGetValue(*encryptObj, "U")
        If *vObj : *ldoc\encryptV = *vObj\numberValue : EndIf
        If *rObj : *ldoc\encryptR = *rObj\numberValue : EndIf
        If *lObj
          *ldoc\encryptKeyLen = *lObj\numberValue / 8
        Else
          If *ldoc\encryptV = 1 : *ldoc\encryptKeyLen = 5 : Else : *ldoc\encryptKeyLen = 16 : EndIf
        EndIf
        If *pObj : *ldoc\encryptPermission = *pObj\numberValue : EndIf
        ; 读取EncryptMetadata标志(V=4时有效)
        *ldoc\encryptMetadata = #True
        Protected *emObj.PbPDF_Object = PbPDF_DictGetValue(*encryptObj, "EncryptMetadata")
        If *emObj And *emObj\objType = #PbPDF_OBJ_NAME
          If *emObj\nameValue = "false"
            *ldoc\encryptMetadata = #False
          EndIf
        ElseIf *emObj And *emObj\objType = #PbPDF_OBJ_BOOLEAN
          If *emObj\numberValue = 0
            *ldoc\encryptMetadata = #False
          EndIf
        EndIf
        ; O值和U值存储为hex字符串
        If *oObj
          If *oObj\objType = #PbPDF_OBJ_BINARY
            *ldoc\encryptO$ = *oObj\stringValue
          ElseIf *oObj\objType = #PbPDF_OBJ_STRING
            *ldoc\encryptO$ = ""
            Protected oi.i
            For oi = 1 To Len(*oObj\stringValue)
              *ldoc\encryptO$ + RSet(Hex(Asc(Mid(*oObj\stringValue, oi, 1)) & $FF), 2, "0")
            Next
          EndIf
        EndIf
        If *uObj
          If *uObj\objType = #PbPDF_OBJ_BINARY
            *ldoc\encryptU$ = *uObj\stringValue
          ElseIf *uObj\objType = #PbPDF_OBJ_STRING
            *ldoc\encryptU$ = ""
            Protected ui.i
            For ui = 1 To Len(*uObj\stringValue)
              *ldoc\encryptU$ + RSet(Hex(Asc(Mid(*uObj\stringValue, ui, 1)) & $FF), 2, "0")
            Next
          EndIf
        EndIf
        ; 获取文档ID
        Protected *idObj.PbPDF_Object = PbPDF_DictGetValue(*ldoc\trailerDict, "ID")
        If *idObj And *idObj\objType = #PbPDF_OBJ_ARRAY
          Protected *id1Obj.PbPDF_Object = PbPDF_ArrayGetItem(*idObj, 0)
          If *id1Obj
            If *id1Obj\objType = #PbPDF_OBJ_BINARY
              *ldoc\encryptID1$ = *id1Obj\stringValue
            ElseIf *id1Obj\objType = #PbPDF_OBJ_STRING
              *ldoc\encryptID1$ = ""
              Protected idi.i
              For idi = 1 To Len(*id1Obj\stringValue)
                *ldoc\encryptID1$ + RSet(Hex(Asc(Mid(*id1Obj\stringValue, idi, 1)) & $FF), 2, "0")
              Next
            EndIf
          EndIf
        EndIf
        ; 尝试用空用户密码计算加密密钥
        If *ldoc\encryptO$ <> "" And *ldoc\encryptID1$ <> ""
          Protected Dim encUserPad.a(31)
          Protected Dim encPad.a(31)
          For oi = 0 To 31
            encPad(oi) = PeekA(?PbPDF_EncryptPadding + oi)
          Next
          ; 空用户密码填充=标准填充序列
          CopyMemory(@encPad(0), @encUserPad(0), 32)
          ; 解码O值
          Protected encOLen.i = Len(*ldoc\encryptO$) / 2
          Protected *encOBuf = AllocateMemory(encOLen + 1)
          Protected ehi$, elo$, ebv.i
          For oi = 1 To Len(*ldoc\encryptO$) Step 2
            ehi$ = Mid(*ldoc\encryptO$, oi, 1)
            elo$ = Mid(*ldoc\encryptO$, oi + 1, 1)
            ebv = Val("$" + ehi$ + elo$)
            PokeA(*encOBuf + (oi - 1) / 2, ebv)
          Next
          ; 解码ID1
          Protected encID1Len.i = Len(*ldoc\encryptID1$) / 2
          Protected *encID1Buf = AllocateMemory(encID1Len + 1)
          For oi = 1 To Len(*ldoc\encryptID1$) Step 2
            ehi$ = Mid(*ldoc\encryptID1$, oi, 1)
            elo$ = Mid(*ldoc\encryptID1$, oi + 1, 1)
            ebv = Val("$" + ehi$ + elo$)
            PokeA(*encID1Buf + (oi - 1) / 2, ebv)
          Next
          ; 计算加密密钥: MD5(user_pad + O + P_LE32 + ID1 [+ EncryptMetadata补丁])
          Protected *encKeyBuf = AllocateMemory(32 + 32 + 4 + 16 + 4)
          Protected encOff.i = 0
          CopyMemory(@encUserPad(0), *encKeyBuf + encOff, 32) : encOff + 32
          CopyMemory(*encOBuf, *encKeyBuf + encOff, encOLen) : encOff + encOLen
          PokeL(*encKeyBuf + encOff, *ldoc\encryptPermission) : encOff + 4
          CopyMemory(*encID1Buf, *encKeyBuf + encOff, encID1Len) : encOff + encID1Len
          ; V=4且EncryptMetadata=false时, 追加4字节0xFFFFFFFF
          If *ldoc\encryptV >= 4 And *ldoc\encryptMetadata = #False
            PokeA(*encKeyBuf + encOff, $FF) : encOff + 1
            PokeA(*encKeyBuf + encOff, $FF) : encOff + 1
            PokeA(*encKeyBuf + encOff, $FF) : encOff + 1
            PokeA(*encKeyBuf + encOff, $FF) : encOff + 1
          EndIf
          Protected Dim encMd5.a(15)
          PbPDF_MD5(*encKeyBuf, encOff, @encMd5(0))
          ; R>=3时需要50次MD5迭代
          If *ldoc\encryptR >= 3
            Protected encIter.i
            For encIter = 1 To 50
              Protected *iterBuf = AllocateMemory(16)
              CopyMemory(@encMd5(0), *iterBuf, 16)
              PbPDF_MD5(*iterBuf, *ldoc\encryptKeyLen, @encMd5(0))
              FreeMemory(*iterBuf)
            Next
          EndIf
          ; 保存加密密钥为hex字符串
          *ldoc\encryptKey$ = ""
          For oi = 0 To *ldoc\encryptKeyLen - 1
            *ldoc\encryptKey$ + RSet(Hex(encMd5(oi)), 2, "0")
          Next
          FreeMemory(*encOBuf)
          FreeMemory(*encID1Buf)
          FreeMemory(*encKeyBuf)
        EndIf
      EndIf
    EndIf
  EndIf
  *ldoc\validated = #True
  ProcedureReturn *ldoc
EndProcedure

;--- 获取已加载PDF的页面数量 ---
Procedure.i PbPDF_LoadGetPageCount(*ldoc.PbPDF_LoadedDoc)
  If Not *ldoc
    ProcedureReturn 0
  EndIf
  ProcedureReturn *ldoc\pageCount
EndProcedure

;--- 获取已加载PDF的指定页面的MediaBox尺寸 ---
; 返回1=成功，0=失败
Procedure.i PbPDF_LoadGetPageSize(*ldoc.PbPDF_LoadedDoc, pageIndex.i, *width.FLOAT, *height.FLOAT)
  Protected *pageObj.PbPDF_Object
  Protected *mediaBoxObj.PbPDF_Object
  Protected *itemObj.PbPDF_Object
  Protected boxWidth.f, boxHeight.f
  If Not *ldoc Or pageIndex < 0 Or pageIndex >= *ldoc\pageCount
    ProcedureReturn 0
  EndIf
  *pageObj = PbPDF_ListGetPointer(*ldoc\pageList, pageIndex)
  If Not *pageObj
    ProcedureReturn 0
  EndIf
  ; 查找MediaBox（可能在页面自身或继承自父节点）
  *mediaBoxObj = PbPDF_DictGetValue(*pageObj, "MediaBox")
  If Not *mediaBoxObj
    ; 尝试从父Pages节点继承
    Protected *parentObj.PbPDF_Object = PbPDF_DictGetValue(*pageObj, "Parent")
    If *parentObj
      If *parentObj\objType = #PbPDF_OBJ_INDIRECT
        *parentObj = PbPDF_ResolveObj(*ldoc\readBuf, *ldoc\readBufSize, *parentObj\objId, *ldoc\xrefEntries)
      EndIf
      If *parentObj
        *mediaBoxObj = PbPDF_DictGetValue(*parentObj, "MediaBox")
      EndIf
    EndIf
  EndIf
  If Not *mediaBoxObj
    ; 使用默认A4尺寸
    *width\f = 595.276
    *height\f = 841.89
    ProcedureReturn 1
  EndIf
  ; 如果MediaBox是间接引用，先解析
  If *mediaBoxObj\objType = #PbPDF_OBJ_INDIRECT
    *mediaBoxObj = PbPDF_ResolveObj(*ldoc\readBuf, *ldoc\readBufSize, *mediaBoxObj\objId, *ldoc\xrefEntries)
  EndIf
  ; 解析MediaBox数组 [llx lly urx ury]
  If *mediaBoxObj And *mediaBoxObj\objType = #PbPDF_OBJ_ARRAY
    Protected arrCount.i = PbPDF_ArrayGetCount(*mediaBoxObj)
    If arrCount >= 4
      ; 获取urx
      *itemObj = PbPDF_ArrayGetItem(*mediaBoxObj, 2)
      If *itemObj
        If *itemObj\objType = #PbPDF_OBJ_NUMBER
          boxWidth = *itemObj\numberValue
        ElseIf *itemObj\objType = #PbPDF_OBJ_REAL
          boxWidth = *itemObj\realValue
        EndIf
      EndIf
      ; 获取ury
      *itemObj = PbPDF_ArrayGetItem(*mediaBoxObj, 3)
      If *itemObj
        If *itemObj\objType = #PbPDF_OBJ_NUMBER
          boxHeight = *itemObj\numberValue
        ElseIf *itemObj\objType = #PbPDF_OBJ_REAL
          boxHeight = *itemObj\realValue
        EndIf
      EndIf
      *width\f = boxWidth
      *height\f = boxHeight
      ProcedureReturn 1
    EndIf
  EndIf
  ; 默认A4
  *width\f = 595.276
  *height\f = 841.89
  ProcedureReturn 1
EndProcedure

;--- 获取已加载PDF的文档信息属性 ---
Procedure.s PbPDF_LoadGetInfoAttr(*ldoc.PbPDF_LoadedDoc, attrKey$)
  Protected *infoObj.PbPDF_Object
  Protected *attrObj.PbPDF_Object
  If Not *ldoc
    ProcedureReturn ""
  EndIf
  *infoObj = *ldoc\infoObj
  If Not *infoObj
    ProcedureReturn ""
  EndIf
  *attrObj = PbPDF_DictGetValue(*infoObj, attrKey$)
  If *attrObj
    If *attrObj\objType = #PbPDF_OBJ_STRING
      ProcedureReturn *attrObj\stringValue
    ElseIf *attrObj\objType = #PbPDF_OBJ_BINARY
      ProcedureReturn *attrObj\stringValue
    ElseIf *attrObj\objType = #PbPDF_OBJ_NAME
      ProcedureReturn *attrObj\nameValue
    EndIf
  EndIf
  ProcedureReturn ""
EndProcedure

;--- 获取已加载PDF的PDF版本字符串 ---
Procedure.s PbPDF_LoadGetVersion(*ldoc.PbPDF_LoadedDoc)
  If Not *ldoc
    ProcedureReturn ""
  EndIf
  ProcedureReturn *ldoc\pdfVersion$
EndProcedure

;--- 获取已加载PDF的指定页面的内容流数据 ---
; 返回内容流字符串，失败返回空字符串
; 如果PDF已加密且能计算加密密钥，会自动解密流数据
Procedure.s PbPDF_LoadGetPageContent(*ldoc.PbPDF_LoadedDoc, pageIndex.i)
  Protected *pageObj.PbPDF_Object
  Protected *contentsObj.PbPDF_Object
  Protected *resolvedObj.PbPDF_Object
  Protected contentData$
  Protected streamSize.i
  If Not *ldoc Or pageIndex < 0 Or pageIndex >= *ldoc\pageCount
    ProcedureReturn ""
  EndIf
  *pageObj = PbPDF_ListGetPointer(*ldoc\pageList, pageIndex)
  If Not *pageObj
    ProcedureReturn ""
  EndIf
  ; 获取Contents对象
  *contentsObj = PbPDF_DictGetValue(*pageObj, "Contents")
  If Not *contentsObj
    ProcedureReturn ""
  EndIf
  ; 如果是间接引用，先解析
  If *contentsObj\objType = #PbPDF_OBJ_INDIRECT
    *contentsObj = PbPDF_ResolveObj(*ldoc\readBuf, *ldoc\readBufSize, *contentsObj\objId, *ldoc\xrefEntries)
  EndIf
  If Not *contentsObj
    ProcedureReturn ""
  EndIf
  ; 辅助宏：解密流数据（如果PDF已加密）
  ; 读取流数据后，如果PDF加密且加密密钥已知，使用对象密钥RC4解密
  Protected needDecrypt.i = Bool(*ldoc\isEncrypted And *ldoc\encryptKey$ <> "")
  ; 解码加密密钥
  Protected Dim decEncKey.a(20)
  Protected decKeyLen.i = 0
  If needDecrypt
    decKeyLen = Len(*ldoc\encryptKey$) / 2
    Protected dki.i, dkhi$, dklo$, dkbv.i
    For dki = 1 To Len(*ldoc\encryptKey$) Step 2
      dkhi$ = Mid(*ldoc\encryptKey$, dki, 1)
      dklo$ = Mid(*ldoc\encryptKey$, dki + 1, 1)
      dkbv = Val("$" + dkhi$ + dklo$)
      decEncKey((dki - 1) / 2) = dkbv
    Next
  EndIf
  ; Contents可能是单个流字典或流字典数组
  If *contentsObj\objType = #PbPDF_OBJ_ARRAY
    ; 合并所有内容流
    Protected arrCount.i = PbPDF_ArrayGetCount(*contentsObj)
    Protected ai.i
    For ai = 0 To arrCount - 1
      Protected *arrItem.PbPDF_Object = PbPDF_ArrayGetItem(*contentsObj, ai)
      If *arrItem
        If *arrItem\objType = #PbPDF_OBJ_INDIRECT
          *resolvedObj = PbPDF_ResolveObj(*ldoc\readBuf, *ldoc\readBufSize, *arrItem\objId, *ldoc\xrefEntries)
        Else
          *resolvedObj = *arrItem
        EndIf
        If *resolvedObj And *resolvedObj\stream
          streamSize = *resolvedObj\stream\size
          If streamSize > 0
            Protected *streamBuf = AllocateMemory(streamSize + 1)
            If *streamBuf
              Protected actualLen.i = PbPDF_MemStreamGetData(*resolvedObj\stream, *streamBuf)
              ; 如果加密，解密流数据
              If needDecrypt And *resolvedObj\objId > 0
                ; 计算对象密钥
                Protected objKeyBufLen.i = decKeyLen + 5
                Protected *objKeyBuf = AllocateMemory(objKeyBufLen + 5)
                If *objKeyBuf
                  Protected okOff.i = 0
                  CopyMemory(@decEncKey(0), *objKeyBuf + okOff, decKeyLen) : okOff + decKeyLen
                  PokeA(*objKeyBuf + okOff, *resolvedObj\objId & $FF) : okOff + 1
                  PokeA(*objKeyBuf + okOff, (*resolvedObj\objId >> 8) & $FF) : okOff + 1
                  PokeA(*objKeyBuf + okOff, (*resolvedObj\objId >> 16) & $FF) : okOff + 1
                  PokeA(*objKeyBuf + okOff, *resolvedObj\genNo & $FF) : okOff + 1
                  PokeA(*objKeyBuf + okOff, (*resolvedObj\genNo >> 8) & $FF) : okOff + 1
                  Protected Dim objMd5.a(15)
                  PbPDF_MD5(*objKeyBuf, okOff, @objMd5(0))
                  Protected finalKeyLen.i = decKeyLen + 5
                  If finalKeyLen > 16 : finalKeyLen = 16 : EndIf
                  ; RC4解密
                  Protected rc4Ctx.PbPDF_Encrypt
                  PbPDF_RC4Init(@rc4Ctx, @objMd5(0), finalKeyLen)
                  PbPDF_RC4Crypt(@rc4Ctx, *streamBuf, *streamBuf, actualLen)
                  FreeMemory(*objKeyBuf)
                EndIf
              EndIf
              contentData$ + PeekS(*streamBuf, actualLen, #PB_Ascii)
              FreeMemory(*streamBuf)
            EndIf
          EndIf
        EndIf
      EndIf
    Next
  ElseIf *contentsObj\objType = #PbPDF_OBJ_DICT
    ; 单个内容流
    If *contentsObj\stream
      streamSize = *contentsObj\stream\size
      If streamSize > 0
        Protected *sBuf = AllocateMemory(streamSize + 1)
        If *sBuf
          Protected aLen.i = PbPDF_MemStreamGetData(*contentsObj\stream, *sBuf)
          ; 如果加密，解密流数据
          If needDecrypt And *contentsObj\objId > 0
            Protected objKeyBufLen2.i = decKeyLen + 5
            Protected *objKeyBuf2 = AllocateMemory(objKeyBufLen2 + 5)
            If *objKeyBuf2
              Protected okOff2.i = 0
              CopyMemory(@decEncKey(0), *objKeyBuf2 + okOff2, decKeyLen) : okOff2 + decKeyLen
              PokeA(*objKeyBuf2 + okOff2, *contentsObj\objId & $FF) : okOff2 + 1
              PokeA(*objKeyBuf2 + okOff2, (*contentsObj\objId >> 8) & $FF) : okOff2 + 1
              PokeA(*objKeyBuf2 + okOff2, (*contentsObj\objId >> 16) & $FF) : okOff2 + 1
              PokeA(*objKeyBuf2 + okOff2, *contentsObj\genNo & $FF) : okOff2 + 1
              PokeA(*objKeyBuf2 + okOff2, (*contentsObj\genNo >> 8) & $FF) : okOff2 + 1
              Protected Dim objMd52.a(15)
              PbPDF_MD5(*objKeyBuf2, okOff2, @objMd52(0))
              Protected finalKeyLen2.i = decKeyLen + 5
              If finalKeyLen2 > 16 : finalKeyLen2 = 16 : EndIf
              Protected rc4Ctx2.PbPDF_Encrypt
              PbPDF_RC4Init(@rc4Ctx2, @objMd52(0), finalKeyLen2)
              PbPDF_RC4Crypt(@rc4Ctx2, *sBuf, *sBuf, aLen)
              FreeMemory(*objKeyBuf2)
            EndIf
          EndIf
          contentData$ = PeekS(*sBuf, aLen, #PB_Ascii)
          FreeMemory(*sBuf)
        EndIf
      EndIf
    EndIf
  EndIf
  ProcedureReturn contentData$
EndProcedure

;--- 获取已加载PDF的指定页面中指定键的字典值 ---
Procedure.i PbPDF_LoadGetPageAttr(*ldoc.PbPDF_LoadedDoc, pageIndex.i, attrKey$)
  Protected *pageObj.PbPDF_Object
  Protected *attrObj.PbPDF_Object
  Protected *resolvedObj.PbPDF_Object
  If Not *ldoc Or pageIndex < 0 Or pageIndex >= *ldoc\pageCount
    ProcedureReturn 0
  EndIf
  *pageObj = PbPDF_ListGetPointer(*ldoc\pageList, pageIndex)
  If Not *pageObj
    ProcedureReturn 0
  EndIf
  *attrObj = PbPDF_DictGetValue(*pageObj, attrKey$)
  If *attrObj And *attrObj\objType = #PbPDF_OBJ_INDIRECT
    *resolvedObj = PbPDF_ResolveObj(*ldoc\readBuf, *ldoc\readBufSize, *attrObj\objId, *ldoc\xrefEntries)
    ProcedureReturn *resolvedObj
  EndIf
  ProcedureReturn *attrObj
EndProcedure

;=============================================================================
; 第31部分：PDF页面操作
; 合并、拆分、提取、删除页面
;=============================================================================

;--- 合并多个PDF文件 ---
; inputFiles$为用"|"分隔的文件路径列表
; 返回合并后的总页数，失败返回0
Procedure.i PbPDF_MergePDFFiles(outputFileName$, inputFiles$)
  Protected fileCount.i, i.i, j.i
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *doc.PbPDF_Doc
  Protected *newPage.PbPDF_Object
  Protected fontName$
  Protected totalPages.i = 0
  Protected pageWidth.f, pageHeight.f
  Protected contentData$
  ; 计算输入文件数量
  fileCount = CountString(inputFiles$, "|") + 1
  If fileCount <= 0
    ProcedureReturn 0
  EndIf
  ; 创建新的PDF文档
  *doc = PbPDF_Create()
  If Not *doc
    ProcedureReturn 0
  EndIf
  PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
  PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Merged PDF")
  PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_PRODUCER, "PbPDFlib")
  ; 逐个处理输入文件
  For i = 1 To fileCount
    Protected inputFile$ = StringField(inputFiles$, i, "|")
    inputFile$ = Trim(inputFile$)
    If inputFile$ = "" Or FileSize(inputFile$) <= 0
      Continue
    EndIf
    ; 加载源PDF文件
    *ldoc = PbPDF_LoadFromFile(inputFile$)
    If Not *ldoc
      Continue
    EndIf
    ; 逐页复制内容
    For j = 0 To *ldoc\pageCount - 1
      ; 获取源页面尺寸
      PbPDF_LoadGetPageSize(*ldoc, j, @pageWidth, @pageHeight)
      ; 在新文档中创建相同尺寸的页面
      *newPage = PbPDF_AddPage(*doc)
      If *newPage
        PbPDF_Page_SetSize(*newPage, pageWidth, pageHeight)
        ; 获取源页面内容流
        contentData$ = PbPDF_LoadGetPageContent(*ldoc, j)
        If contentData$ <> ""
          ; 将源内容流写入新页面
          PbPDF_PageGetContentStream(*newPage)
          Protected *cs.PbPDF_Stream = 0
          Protected *pAttr.PbPDF_PageAttr = *newPage\attr
          If *pAttr And *pAttr\contentStream
            *cs = *pAttr\contentStream
            ; 使用字节方式写入内容流，避免编码问题
            Protected *contentBuf = AllocateMemory(Len(contentData$) + 1)
            If *contentBuf
              Protected ci.i
              For ci = 1 To Len(contentData$)
                PokeA(*contentBuf + ci - 1, Asc(Mid(contentData$, ci, 1)))
              Next
              PbPDF_StreamWriteData(*cs, *contentBuf, Len(contentData$))
              FreeMemory(*contentBuf)
            EndIf
          EndIf
        EndIf
        ; 添加页脚标注
        fontName$ = PbPDF_GetFont(*doc, *newPage, "Helvetica")
        PbPDF_Page_BeginText(*newPage)
        PbPDF_Page_SetFontAndSize(*newPage, fontName$, 8)
        PbPDF_Page_SetRGBFill(*newPage, 0.5, 0.5, 0.5)
        PbPDF_Page_MoveTextPos(*newPage, 50, 20)
        PbPDF_Page_ShowText(*newPage, "Source: " + GetFilePart(inputFile$) + " - Page " + Str(j + 1))
        PbPDF_Page_EndText(*newPage)
        totalPages + 1
      EndIf
    Next
    ; 释放已加载文档
    PbPDF_FreeLoadedDoc(*ldoc)
  Next
  ; 保存合并后的PDF
  If totalPages > 0
    If PbPDF_SaveToFile2(*doc, outputFileName$) <> #PbPDF_OK
      PbPDF_Free(*doc)
      ProcedureReturn 0
    EndIf
  EndIf
  PbPDF_Free(*doc)
  ProcedureReturn totalPages
EndProcedure

;--- 从PDF文件中提取指定页面范围 ---
; 返回提取的页数，失败返回0
Procedure.i PbPDF_ExtractPages(inputFileName$, outputFileName$, startPage.i, endPage.i)
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *doc.PbPDF_Doc
  Protected *newPage.PbPDF_Object
  Protected fontName$
  Protected i.i
  Protected pageWidth.f, pageHeight.f
  Protected contentData$
  ; 加载源PDF文件
  *ldoc = PbPDF_LoadFromFile(inputFileName$)
  If Not *ldoc
    ProcedureReturn 0
  EndIf
  ; 验证页面范围
  If startPage < 1
    startPage = 1
  EndIf
  If endPage > *ldoc\pageCount
    endPage = *ldoc\pageCount
  EndIf
  If startPage > endPage
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  ; 创建新PDF文档
  *doc = PbPDF_Create()
  If Not *doc
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
  PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Extracted Pages")
  PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_PRODUCER, "PbPDFlib")
  ; 逐页提取
  For i = startPage - 1 To endPage - 1
    ; 获取源页面尺寸
    PbPDF_LoadGetPageSize(*ldoc, i, @pageWidth, @pageHeight)
    ; 创建相同尺寸的新页面
    *newPage = PbPDF_AddPage(*doc)
    If *newPage
      PbPDF_Page_SetSize(*newPage, pageWidth, pageHeight)
      ; 获取源页面内容流
      contentData$ = PbPDF_LoadGetPageContent(*ldoc, i)
      If contentData$ <> ""
        ; 将源内容流写入新页面
        PbPDF_PageGetContentStream(*newPage)
        Protected *pAttr.PbPDF_PageAttr = *newPage\attr
        If *pAttr And *pAttr\contentStream
          Protected *contentBuf = AllocateMemory(Len(contentData$) + 1)
          If *contentBuf
            Protected ci.i
            For ci = 1 To Len(contentData$)
              PokeA(*contentBuf + ci - 1, Asc(Mid(contentData$, ci, 1)))
            Next
            PbPDF_StreamWriteData(*pAttr\contentStream, *contentBuf, Len(contentData$))
            FreeMemory(*contentBuf)
          EndIf
        EndIf
      EndIf
      ; 添加页脚标注
      fontName$ = PbPDF_GetFont(*doc, *newPage, "Helvetica")
      PbPDF_Page_BeginText(*newPage)
      PbPDF_Page_SetFontAndSize(*newPage, fontName$, 8)
      PbPDF_Page_SetRGBFill(*newPage, 0.5, 0.5, 0.5)
      PbPDF_Page_MoveTextPos(*newPage, 50, 20)
      PbPDF_Page_ShowText(*newPage, "Extracted from: " + GetFilePart(inputFileName$) + " - Page " + Str(i + 1))
      PbPDF_Page_EndText(*newPage)
    EndIf
  Next
  ; 保存提取的PDF
  Protected pageCount.i = PbPDF_GetPageCount(*doc)
  If pageCount > 0
    If PbPDF_SaveToFile2(*doc, outputFileName$) <> #PbPDF_OK
      PbPDF_Free(*doc)
      PbPDF_FreeLoadedDoc(*ldoc)
      ProcedureReturn 0
    EndIf
  EndIf
  PbPDF_Free(*doc)
  PbPDF_FreeLoadedDoc(*ldoc)
  ProcedureReturn pageCount
EndProcedure

;--- 将PDF文件拆分为单页文件 ---
; 输出文件名格式：outputPrefix_001.pdf, outputPrefix_002.pdf, ...
; 返回拆分的文件数，失败返回0
Procedure.i PbPDF_SplitPDF(inputFileName$, outputPrefix$)
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *doc.PbPDF_Doc
  Protected *newPage.PbPDF_Object
  Protected i.i
  Protected pageWidth.f, pageHeight.f
  Protected contentData$
  Protected outputFileName$
  Protected splitCount.i = 0
  ; 加载源PDF文件
  *ldoc = PbPDF_LoadFromFile(inputFileName$)
  If Not *ldoc
    ProcedureReturn 0
  EndIf
  ; 逐页拆分
  For i = 0 To *ldoc\pageCount - 1
    ; 获取源页面尺寸
    PbPDF_LoadGetPageSize(*ldoc, i, @pageWidth, @pageHeight)
    ; 为每一页创建新PDF
    *doc = PbPDF_Create()
    If Not *doc
      Continue
    EndIf
    PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
    PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Split Page " + Str(i + 1))
    PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_PRODUCER, "PbPDFlib")
    ; 创建页面
    *newPage = PbPDF_AddPage(*doc)
    If *newPage
      PbPDF_Page_SetSize(*newPage, pageWidth, pageHeight)
      ; 获取源页面内容流
      contentData$ = PbPDF_LoadGetPageContent(*ldoc, i)
      If contentData$ <> ""
        ; 将源内容流写入新页面
        PbPDF_PageGetContentStream(*newPage)
        Protected *pAttr.PbPDF_PageAttr = *newPage\attr
        If *pAttr And *pAttr\contentStream
          Protected *contentBuf = AllocateMemory(Len(contentData$) + 1)
          If *contentBuf
            Protected ci.i
            For ci = 1 To Len(contentData$)
              PokeA(*contentBuf + ci - 1, Asc(Mid(contentData$, ci, 1)))
            Next
            PbPDF_StreamWriteData(*pAttr\contentStream, *contentBuf, Len(contentData$))
            FreeMemory(*contentBuf)
          EndIf
        EndIf
      EndIf
    EndIf
    ; 生成输出文件名
    outputFileName$ = outputPrefix$ + "_" + RSet(Str(i + 1), 3, "0") + ".pdf"
    ; 保存
    If PbPDF_SaveToFile2(*doc, outputFileName$) = #PbPDF_OK
      splitCount + 1
    EndIf
    PbPDF_Free(*doc)
  Next
  PbPDF_FreeLoadedDoc(*ldoc)
  ProcedureReturn splitCount
EndProcedure

;--- 从PDF文件中删除指定页面范围 ---
; 返回删除后的页数，失败返回0
Procedure.i PbPDF_DeletePages(inputFileName$, outputFileName$, startPage.i, endPage.i)
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *doc.PbPDF_Doc
  Protected *newPage.PbPDF_Object
  Protected fontName$
  Protected i.i
  Protected pageWidth.f, pageHeight.f
  Protected contentData$
  Protected resultCount.i = 0
  ; 加载源PDF文件
  *ldoc = PbPDF_LoadFromFile(inputFileName$)
  If Not *ldoc
    ProcedureReturn 0
  EndIf
  ; 验证页面范围
  If startPage < 1
    startPage = 1
  EndIf
  If endPage > *ldoc\pageCount
    endPage = *ldoc\pageCount
  EndIf
  ; 创建新PDF文档（不包含要删除的页面）
  *doc = PbPDF_Create()
  If Not *doc
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
  PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, "Pages Removed")
  PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_PRODUCER, "PbPDFlib")
  ; 复制不需要删除的页面
  For i = 0 To *ldoc\pageCount - 1
    ; 跳过要删除的页面范围（页面编号从1开始）
    If (i + 1) >= startPage And (i + 1) <= endPage
      Continue
    EndIf
    ; 获取源页面尺寸
    PbPDF_LoadGetPageSize(*ldoc, i, @pageWidth, @pageHeight)
    ; 创建新页面
    *newPage = PbPDF_AddPage(*doc)
    If *newPage
      PbPDF_Page_SetSize(*newPage, pageWidth, pageHeight)
      ; 获取源页面内容流
      contentData$ = PbPDF_LoadGetPageContent(*ldoc, i)
      If contentData$ <> ""
        ; 将源内容流写入新页面
        PbPDF_PageGetContentStream(*newPage)
        Protected *pAttr.PbPDF_PageAttr = *newPage\attr
        If *pAttr And *pAttr\contentStream
          Protected *contentBuf = AllocateMemory(Len(contentData$) + 1)
          If *contentBuf
            Protected ci.i
            For ci = 1 To Len(contentData$)
              PokeA(*contentBuf + ci - 1, Asc(Mid(contentData$, ci, 1)))
            Next
            PbPDF_StreamWriteData(*pAttr\contentStream, *contentBuf, Len(contentData$))
            FreeMemory(*contentBuf)
          EndIf
        EndIf
      EndIf
      resultCount + 1
    EndIf
  Next
  ; 保存结果
  If resultCount > 0
    If PbPDF_SaveToFile2(*doc, outputFileName$) <> #PbPDF_OK
      PbPDF_Free(*doc)
      PbPDF_FreeLoadedDoc(*ldoc)
      ProcedureReturn 0
    EndIf
  EndIf
  PbPDF_Free(*doc)
  PbPDF_FreeLoadedDoc(*ldoc)
  ProcedureReturn resultCount
EndProcedure

;--- 在PDF文件的所有页面上添加页眉和页脚 ---
; 返回处理的页数，失败返回0
Procedure.i PbPDF_AddHeaderFooter(inputFileName$, outputFileName$, headerText$, footerText$, fontSize.f)
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *doc.PbPDF_Doc
  Protected *newPage.PbPDF_Object
  Protected fontName$
  Protected i.i
  Protected pageWidth.f, pageHeight.f
  Protected contentData$
  Protected resultCount.i = 0
  ; 加载源PDF文件
  *ldoc = PbPDF_LoadFromFile(inputFileName$)
  If Not *ldoc
    ProcedureReturn 0
  EndIf
  ; 创建新PDF文档
  *doc = PbPDF_Create()
  If Not *doc
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
  ; 逐页处理
  For i = 0 To *ldoc\pageCount - 1
    PbPDF_LoadGetPageSize(*ldoc, i, @pageWidth, @pageHeight)
    *newPage = PbPDF_AddPage(*doc)
    If *newPage
      PbPDF_Page_SetSize(*newPage, pageWidth, pageHeight)
      ; 复制源页面内容流
      contentData$ = PbPDF_LoadGetPageContent(*ldoc, i)
      If contentData$ <> ""
        PbPDF_PageGetContentStream(*newPage)
        Protected *pAttr.PbPDF_PageAttr = *newPage\attr
        If *pAttr And *pAttr\contentStream
          Protected *contentBuf = AllocateMemory(Len(contentData$) + 1)
          If *contentBuf
            Protected ci.i
            For ci = 1 To Len(contentData$)
              PokeA(*contentBuf + ci - 1, Asc(Mid(contentData$, ci, 1)))
            Next
            PbPDF_StreamWriteData(*pAttr\contentStream, *contentBuf, Len(contentData$))
            FreeMemory(*contentBuf)
          EndIf
        EndIf
      EndIf
      ; 添加页眉
      fontName$ = PbPDF_GetFont(*doc, *newPage, "Helvetica")
      If headerText$ <> ""
        PbPDF_Page_BeginText(*newPage)
        PbPDF_Page_SetFontAndSize(*newPage, fontName$, fontSize)
        PbPDF_Page_SetRGBFill(*newPage, 0.3, 0.3, 0.3)
        PbPDF_Page_MoveTextPos(*newPage, 50, pageHeight - 30)
        PbPDF_Page_ShowText(*newPage, headerText$)
        PbPDF_Page_EndText(*newPage)
      EndIf
      ; 添加页脚
      If footerText$ <> ""
        PbPDF_Page_BeginText(*newPage)
        PbPDF_Page_SetFontAndSize(*newPage, fontName$, fontSize)
        PbPDF_Page_SetRGBFill(*newPage, 0.3, 0.3, 0.3)
        PbPDF_Page_MoveTextPos(*newPage, 50, 20)
        Protected footerWithPage$ = footerText$ + " - Page " + Str(i + 1) + " / " + Str(*ldoc\pageCount)
        PbPDF_Page_ShowText(*newPage, footerWithPage$)
        PbPDF_Page_EndText(*newPage)
      EndIf
      resultCount + 1
    EndIf
  Next
  ; 保存结果
  If resultCount > 0
    If PbPDF_SaveToFile2(*doc, outputFileName$) <> #PbPDF_OK
      PbPDF_Free(*doc)
      PbPDF_FreeLoadedDoc(*ldoc)
      ProcedureReturn 0
    EndIf
  EndIf
  PbPDF_Free(*doc)
  PbPDF_FreeLoadedDoc(*ldoc)
  ProcedureReturn resultCount
EndProcedure

;--- 在PDF文件的所有页面上添加水印 ---
; 返回处理的页数，失败返回0
Procedure.i PbPDF_AddWatermarkToFile(inputFileName$, outputFileName$, text$, fontSize.f, angle.f, r.f, g.f, b.f)
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *doc.PbPDF_Doc
  Protected *newPage.PbPDF_Object
  Protected fontName$
  Protected i.i
  Protected pageWidth.f, pageHeight.f
  Protected contentData$
  Protected resultCount.i = 0
  ; 加载源PDF文件
  *ldoc = PbPDF_LoadFromFile(inputFileName$)
  If Not *ldoc
    ProcedureReturn 0
  EndIf
  ; 创建新PDF文档
  *doc = PbPDF_Create()
  If Not *doc
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
  ; 逐页处理
  For i = 0 To *ldoc\pageCount - 1
    PbPDF_LoadGetPageSize(*ldoc, i, @pageWidth, @pageHeight)
    *newPage = PbPDF_AddPage(*doc)
    If *newPage
      PbPDF_Page_SetSize(*newPage, pageWidth, pageHeight)
      ; 复制源页面内容流
      contentData$ = PbPDF_LoadGetPageContent(*ldoc, i)
      If contentData$ <> ""
        PbPDF_PageGetContentStream(*newPage)
        Protected *pAttr.PbPDF_PageAttr = *newPage\attr
        If *pAttr And *pAttr\contentStream
          Protected *contentBuf = AllocateMemory(Len(contentData$) + 1)
          If *contentBuf
            Protected ci.i
            For ci = 1 To Len(contentData$)
              PokeA(*contentBuf + ci - 1, Asc(Mid(contentData$, ci, 1)))
            Next
            PbPDF_StreamWriteData(*pAttr\contentStream, *contentBuf, Len(contentData$))
            FreeMemory(*contentBuf)
          EndIf
        EndIf
      EndIf
      ; 添加水印
      fontName$ = PbPDF_GetFont(*doc, *newPage, "Helvetica-Bold")
      ; 保存图形状态
      PbPDF_Page_GSave(*newPage)
      ; 设置透明度
      Protected *gstate.PbPDF_Object = PbPDF_GStateNewEx(*doc, 0.15, 0.15, #PbPDF_BLEND_NORMAL)
      PbPDF_Page_SetExtGState(*doc, *newPage, *gstate)
      ; 设置水印颜色和字体
      PbPDF_Page_SetRGBFill(*newPage, r, g, b)
      ; 平移到页面中心，旋转
      PbPDF_Page_Concat(*newPage, 1.0, 0.0, 0.0, 1.0, pageWidth / 2, pageHeight / 2)
      ; 旋转角度（弧度）
      Protected rad.f = angle * 3.14159265 / 180.0
      PbPDF_Page_Concat(*newPage, Cos(rad), Sin(rad), -Sin(rad), Cos(rad), 0, 0)
      ; 绘制水印文本
      PbPDF_Page_BeginText(*newPage)
      PbPDF_Page_SetFontAndSize(*newPage, fontName$, fontSize)
      PbPDF_Page_MoveTextPos(*newPage, -Len(text$) * fontSize * 0.3, -fontSize / 2)
      PbPDF_Page_ShowText(*newPage, text$)
      PbPDF_Page_EndText(*newPage)
      ; 恢复图形状态
      PbPDF_Page_GRestore(*newPage)
      resultCount + 1
    EndIf
  Next
  ; 保存结果
  If resultCount > 0
    If PbPDF_SaveToFile2(*doc, outputFileName$) <> #PbPDF_OK
      PbPDF_Free(*doc)
      PbPDF_FreeLoadedDoc(*ldoc)
      ProcedureReturn 0
    EndIf
  EndIf
  PbPDF_Free(*doc)
  PbPDF_FreeLoadedDoc(*ldoc)
  ProcedureReturn resultCount
EndProcedure

;=============================================================================
; 第32部分：PDF解密/删除密码
; 加载加密的PDF文件并保存为无密码版本
;=============================================================================

;--- 用指定密码重新计算已加载PDF的加密密钥 ---
; 当PDF有非空用户密码时，PbPDF_LoadFromFile自动用空密码计算的密钥无法解密
; 调用此函数可以用正确的密码重新计算加密密钥
; 返回1=成功，0=失败
Procedure.i PbPDF_SetDecryptPassword(*ldoc.PbPDF_LoadedDoc, password$)
  If Not *ldoc Or Not *ldoc\isEncrypted
    ProcedureReturn 0
  EndIf
  If *ldoc\encryptO$ = "" Or *ldoc\encryptID1$ = ""
    ProcedureReturn 0
  EndIf
  ; 密码填充
  Protected Dim pwdPad.a(31)
  Protected Dim encPad.a(31)
  Protected pi.i
  For pi = 0 To 31
    encPad(pi) = PeekA(?PbPDF_EncryptPadding + pi)
  Next
  Protected pwdBytes.i = StringByteLength(password$, #PB_UTF8)
  If pwdBytes > 32 : pwdBytes = 32 : EndIf
  Protected *pwdUtf8 = AllocateMemory(pwdBytes + 1)
  If *pwdUtf8
    PokeS(*pwdUtf8, password$, -1, #PB_UTF8)
    For pi = 0 To 31
      If pi < pwdBytes
        pwdPad(pi) = PeekA(*pwdUtf8 + pi)
      Else
        pwdPad(pi) = encPad(pi - pwdBytes)
      EndIf
    Next
    FreeMemory(*pwdUtf8)
  Else
    ProcedureReturn 0
  EndIf
  ; 解码O值
  Protected encOLen.i = Len(*ldoc\encryptO$) / 2
  Protected *encOBuf = AllocateMemory(encOLen + 1)
  Protected ehi$, elo$, ebv.i
  For pi = 1 To Len(*ldoc\encryptO$) Step 2
    ehi$ = Mid(*ldoc\encryptO$, pi, 1)
    elo$ = Mid(*ldoc\encryptO$, pi + 1, 1)
    ebv = Val("$" + ehi$ + elo$)
    PokeA(*encOBuf + (pi - 1) / 2, ebv)
  Next
  ; 解码ID1
  Protected encID1Len.i = Len(*ldoc\encryptID1$) / 2
  Protected *encID1Buf = AllocateMemory(encID1Len + 1)
  For pi = 1 To Len(*ldoc\encryptID1$) Step 2
    ehi$ = Mid(*ldoc\encryptID1$, pi, 1)
    elo$ = Mid(*ldoc\encryptID1$, pi + 1, 1)
    ebv = Val("$" + ehi$ + elo$)
    PokeA(*encID1Buf + (pi - 1) / 2, ebv)
  Next
  ; 计算加密密钥: MD5(user_pad + O + P_LE32 + ID1)
  Protected *encKeyBuf = AllocateMemory(32 + 32 + 4 + 16)
  Protected encOff.i = 0
  CopyMemory(@pwdPad(0), *encKeyBuf + encOff, 32) : encOff + 32
  CopyMemory(*encOBuf, *encKeyBuf + encOff, encOLen) : encOff + encOLen
  PokeL(*encKeyBuf + encOff, *ldoc\encryptPermission) : encOff + 4
  CopyMemory(*encID1Buf, *encKeyBuf + encOff, encID1Len) : encOff + encID1Len
  Protected Dim encMd5.a(15)
  PbPDF_MD5(*encKeyBuf, encOff, @encMd5(0))
  ; R>=3时需要50次MD5迭代
  If *ldoc\encryptR >= 3
    Protected encMd5Iter.i
    For encMd5Iter = 1 To 50
      Protected *encIterBuf = AllocateMemory(16)
      CopyMemory(@encMd5(0), *encIterBuf, 16)
      PbPDF_MD5(*encIterBuf, *ldoc\encryptKeyLen, @encMd5(0))
      FreeMemory(*encIterBuf)
    Next
  EndIf
  ; 保存加密密钥为hex字符串
  *ldoc\encryptKey$ = ""
  For pi = 0 To *ldoc\encryptKeyLen - 1
    *ldoc\encryptKey$ + RSet(Hex(encMd5(pi)), 2, "0")
  Next
  FreeMemory(*encOBuf)
  FreeMemory(*encID1Buf)
  FreeMemory(*encKeyBuf)
  ProcedureReturn 1
EndProcedure

;--- 删除PDF文件密码（解密） ---
; 加载加密的PDF文件，将其内容复制到新的无密码PDF中
; ownerPwd$为所有者密码，用于打开加密的PDF
; 返回1=成功，0=失败
Procedure.i PbPDF_RemovePassword(inputFileName$, outputFileName$, ownerPwd$)
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *doc.PbPDF_Doc
  Protected *newPage.PbPDF_Object
  Protected i.i
  Protected pageWidth.f, pageHeight.f
  Protected contentData$
  Protected resultCount.i = 0
  ; 加载源PDF文件
  *ldoc = PbPDF_LoadFromFile(inputFileName$)
  If Not *ldoc
    ProcedureReturn 0
  EndIf
  ; 如果PDF加密，用提供的密码重新计算加密密钥
  ; PbPDF_LoadFromFile默认用空用户密码计算密钥
  ; 对于非空用户密码的PDF，需要用所有者密码解密O值获取用户密码填充
  If *ldoc\isEncrypted
    ; 先尝试用所有者密码解密O值获取用户密码填充
    Protected Dim ownerPwdPad.a(31)
    Protected Dim rmPad.a(31)
    Protected rmi.i
    For rmi = 0 To 31
      rmPad(rmi) = PeekA(?PbPDF_EncryptPadding + rmi)
    Next
    Protected rmOwnerBytes.i = StringByteLength(ownerPwd$, #PB_UTF8)
    If rmOwnerBytes > 32 : rmOwnerBytes = 32 : EndIf
    Protected *rmOwnerUtf8 = AllocateMemory(rmOwnerBytes + 1)
    If *rmOwnerUtf8
      PokeS(*rmOwnerUtf8, ownerPwd$, -1, #PB_UTF8)
      For rmi = 0 To 31
        If rmi < rmOwnerBytes
          ownerPwdPad(rmi) = PeekA(*rmOwnerUtf8 + rmi)
        Else
          ownerPwdPad(rmi) = rmPad(rmi - rmOwnerBytes)
        EndIf
      Next
      FreeMemory(*rmOwnerUtf8)
    EndIf
    ; 计算owner key
    Protected *rmMd5Buf = AllocateMemory(64)
    CopyMemory(@ownerPwdPad(0), *rmMd5Buf, 32)
    Protected Dim rmMd5Result.a(15)
    PbPDF_MD5(*rmMd5Buf, 32, @rmMd5Result(0))
    ; R>=3时需要50次MD5迭代
    If *ldoc\encryptR >= 3
      Protected rmMd5Iter.i
      For rmMd5Iter = 1 To 50
        CopyMemory(@rmMd5Result(0), *rmMd5Buf, 16)
        PbPDF_MD5(*rmMd5Buf, *ldoc\encryptKeyLen, @rmMd5Result(0))
      Next
    EndIf
    FreeMemory(*rmMd5Buf)
    Protected Dim rmOwnerKey.a(15)
    CopyMemory(@rmMd5Result(0), @rmOwnerKey(0), *ldoc\encryptKeyLen)
    ; 解码O值
    Protected rmOLen.i = Len(*ldoc\encryptO$) / 2
    Protected *rmOBuf = AllocateMemory(rmOLen + 1)
    Protected rmhi$, rmlo$, rmbv.i
    For rmi = 1 To Len(*ldoc\encryptO$) Step 2
      rmhi$ = Mid(*ldoc\encryptO$, rmi, 1)
      rmlo$ = Mid(*ldoc\encryptO$, rmi + 1, 1)
      rmbv = Val("$" + rmhi$ + rmlo$)
      PokeA(*rmOBuf + (rmi - 1) / 2, rmbv)
    Next
    ; 用owner key解密O值得到用户密码填充
    Protected Dim rmUserPad.a(31)
    CopyMemory(*rmOBuf, @rmUserPad(0), 32)
    FreeMemory(*rmOBuf)
    Protected rmRc4.PbPDF_Encrypt
    PbPDF_RC4Init(@rmRc4, @rmOwnerKey(0), *ldoc\encryptKeyLen)
    PbPDF_RC4Crypt(@rmRc4, @rmUserPad(0), @rmUserPad(0), 32)
    ; R>=3时需要19轮RC4解密(从第19轮倒序到第1轮)
    If *ldoc\encryptR >= 3
      Protected rmRoundIter.i
      For rmRoundIter = 19 To 1 Step -1
        Protected Dim rmRoundKey.a(15)
        Protected rmKi.i
        For rmKi = 0 To *ldoc\encryptKeyLen - 1
          rmRoundKey(rmKi) = rmOwnerKey(rmKi) ! rmRoundIter
        Next
        PbPDF_RC4Init(@rmRc4, @rmRoundKey(0), *ldoc\encryptKeyLen)
        PbPDF_RC4Crypt(@rmRc4, @rmUserPad(0), @rmUserPad(0), 32)
      Next
    EndIf
    ; 用解密得到的用户密码填充重新计算加密密钥
    Protected rmID1Len.i = Len(*ldoc\encryptID1$) / 2
    Protected *rmID1Buf = AllocateMemory(rmID1Len + 1)
    For rmi = 1 To Len(*ldoc\encryptID1$) Step 2
      rmhi$ = Mid(*ldoc\encryptID1$, rmi, 1)
      rmlo$ = Mid(*ldoc\encryptID1$, rmi + 1, 1)
      rmbv = Val("$" + rmhi$ + rmlo$)
      PokeA(*rmID1Buf + (rmi - 1) / 2, rmbv)
    Next
    Protected *rmKeyBuf = AllocateMemory(32 + 32 + 4 + 16 + 4)
    Protected rmOff.i = 0
    CopyMemory(@rmUserPad(0), *rmKeyBuf + rmOff, 32) : rmOff + 32
    Protected *rmOBuf2 = AllocateMemory(rmOLen + 1)
    For rmi = 1 To Len(*ldoc\encryptO$) Step 2
      rmhi$ = Mid(*ldoc\encryptO$, rmi, 1)
      rmlo$ = Mid(*ldoc\encryptO$, rmi + 1, 1)
      rmbv = Val("$" + rmhi$ + rmlo$)
      PokeA(*rmOBuf2 + (rmi - 1) / 2, rmbv)
    Next
    CopyMemory(*rmOBuf2, *rmKeyBuf + rmOff, rmOLen) : rmOff + rmOLen
    FreeMemory(*rmOBuf2)
    PokeL(*rmKeyBuf + rmOff, *ldoc\encryptPermission) : rmOff + 4
    CopyMemory(*rmID1Buf, *rmKeyBuf + rmOff, rmID1Len) : rmOff + rmID1Len
    FreeMemory(*rmID1Buf)
    ; V=4且EncryptMetadata=false时, 追加4字节0xFFFFFFFF
    If *ldoc\encryptV >= 4 And *ldoc\encryptMetadata = #False
      PokeA(*rmKeyBuf + rmOff, $FF) : rmOff + 1
      PokeA(*rmKeyBuf + rmOff, $FF) : rmOff + 1
      PokeA(*rmKeyBuf + rmOff, $FF) : rmOff + 1
      PokeA(*rmKeyBuf + rmOff, $FF) : rmOff + 1
    EndIf
    Protected Dim rmEncMd5.a(15)
    PbPDF_MD5(*rmKeyBuf, rmOff, @rmEncMd5(0))
    FreeMemory(*rmKeyBuf)
    ; R>=3时需要50次MD5迭代
    If *ldoc\encryptR >= 3
      Protected rmEncIter.i
      For rmEncIter = 1 To 50
        Protected *rmIterBuf = AllocateMemory(16)
        CopyMemory(@rmEncMd5(0), *rmIterBuf, 16)
        PbPDF_MD5(*rmIterBuf, *ldoc\encryptKeyLen, @rmEncMd5(0))
        FreeMemory(*rmIterBuf)
      Next
    EndIf
    ; 更新加密密钥
    *ldoc\encryptKey$ = ""
    For rmi = 0 To *ldoc\encryptKeyLen - 1
      *ldoc\encryptKey$ + RSet(Hex(rmEncMd5(rmi)), 2, "0")
    Next
  EndIf
  ; 创建新PDF文档（无加密）
  *doc = PbPDF_Create()
  If Not *doc
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
  ; 复制文档信息
  Protected infoTitle$ = PbPDF_LoadGetInfoAttr(*ldoc, "Title")
  Protected infoAuthor$ = PbPDF_LoadGetInfoAttr(*ldoc, "Author")
  Protected infoSubject$ = PbPDF_LoadGetInfoAttr(*ldoc, "Subject")
  If infoTitle$ <> ""
    PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, infoTitle$)
  EndIf
  If infoAuthor$ <> ""
    PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, infoAuthor$)
  EndIf
  If infoSubject$ <> ""
    PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_SUBJECT, infoSubject$)
  EndIf
  PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_PRODUCER, "PbPDFlib - Decrypted")
  ; 逐页复制内容
  For i = 0 To *ldoc\pageCount - 1
    ; 获取源页面尺寸
    PbPDF_LoadGetPageSize(*ldoc, i, @pageWidth, @pageHeight)
    ; 创建相同尺寸的新页面
    *newPage = PbPDF_AddPage(*doc)
    If *newPage
      PbPDF_Page_SetSize(*newPage, pageWidth, pageHeight)
      ; 获取源页面内容流
      contentData$ = PbPDF_LoadGetPageContent(*ldoc, i)
      If contentData$ <> ""
        ; 将源内容流写入新页面
        PbPDF_PageGetContentStream(*newPage)
        Protected *pAttr.PbPDF_PageAttr = *newPage\attr
        If *pAttr And *pAttr\contentStream
          Protected *contentBuf = AllocateMemory(Len(contentData$) + 1)
          If *contentBuf
            Protected ci.i
            For ci = 1 To Len(contentData$)
              PokeA(*contentBuf + ci - 1, Asc(Mid(contentData$, ci, 1)))
            Next
            PbPDF_StreamWriteData(*pAttr\contentStream, *contentBuf, Len(contentData$))
            FreeMemory(*contentBuf)
          EndIf
        EndIf
      EndIf
      resultCount + 1
    EndIf
  Next
  ; 保存无加密的PDF
  If resultCount > 0
    If PbPDF_SaveToFile2(*doc, outputFileName$) <> #PbPDF_OK
      PbPDF_Free(*doc)
      PbPDF_FreeLoadedDoc(*ldoc)
      ProcedureReturn 0
    EndIf
  EndIf
  PbPDF_Free(*doc)
  PbPDF_FreeLoadedDoc(*ldoc)
  ProcedureReturn 1
EndProcedure

;--- 修改PDF文件密码 ---
; 加载加密的PDF文件，使用新密码重新加密保存
; oldOwnerPwd$为旧所有者密码，newUserPwd$为新用户密码，newOwnerPwd$为新所有者密码
; permission为权限标志，encryptionMode为加密模式
; 返回1=成功，0=失败
Procedure.i PbPDF_ChangePassword(inputFileName$, outputFileName$, oldOwnerPwd$, newUserPwd$, newOwnerPwd$, permission.i, encryptionMode.i)
  Protected *ldoc.PbPDF_LoadedDoc
  Protected *doc.PbPDF_Doc
  Protected *newPage.PbPDF_Object
  Protected i.i
  Protected pageWidth.f, pageHeight.f
  Protected contentData$
  Protected resultCount.i = 0
  ; 加载源PDF文件
  *ldoc = PbPDF_LoadFromFile(inputFileName$)
  If Not *ldoc
    ProcedureReturn 0
  EndIf
  ; 如果PDF加密，用提供的旧所有者密码重新计算加密密钥
  ; 所有者密码可以解密O值获取用户密码填充，从而计算加密密钥
  If *ldoc\isEncrypted
    Protected Dim cpOwnerPwdPad.a(31)
    Protected Dim cpPad.a(31)
    Protected cpi.i
    For cpi = 0 To 31
      cpPad(cpi) = PeekA(?PbPDF_EncryptPadding + cpi)
    Next
    Protected cpOwnerBytes.i = StringByteLength(oldOwnerPwd$, #PB_UTF8)
    If cpOwnerBytes > 32 : cpOwnerBytes = 32 : EndIf
    Protected *cpOwnerUtf8 = AllocateMemory(cpOwnerBytes + 1)
    If *cpOwnerUtf8
      PokeS(*cpOwnerUtf8, oldOwnerPwd$, -1, #PB_UTF8)
      For cpi = 0 To 31
        If cpi < cpOwnerBytes
          cpOwnerPwdPad(cpi) = PeekA(*cpOwnerUtf8 + cpi)
        Else
          cpOwnerPwdPad(cpi) = cpPad(cpi - cpOwnerBytes)
        EndIf
      Next
      FreeMemory(*cpOwnerUtf8)
    EndIf
    ; 计算owner key
    Protected *cpMd5Buf = AllocateMemory(64)
    CopyMemory(@cpOwnerPwdPad(0), *cpMd5Buf, 32)
    Protected Dim cpMd5Result.a(15)
    PbPDF_MD5(*cpMd5Buf, 32, @cpMd5Result(0))
    ; R>=3时需要50次MD5迭代
    If *ldoc\encryptR >= 3
      Protected cpMd5Iter.i
      For cpMd5Iter = 1 To 50
        CopyMemory(@cpMd5Result(0), *cpMd5Buf, 16)
        PbPDF_MD5(*cpMd5Buf, *ldoc\encryptKeyLen, @cpMd5Result(0))
      Next
    EndIf
    FreeMemory(*cpMd5Buf)
    Protected Dim cpOwnerKey.a(15)
    CopyMemory(@cpMd5Result(0), @cpOwnerKey(0), *ldoc\encryptKeyLen)
    ; 解码O值
    Protected cpOLen.i = Len(*ldoc\encryptO$) / 2
    Protected *cpOBuf = AllocateMemory(cpOLen + 1)
    Protected cphi$, cplo$, cpbv.i
    For cpi = 1 To Len(*ldoc\encryptO$) Step 2
      cphi$ = Mid(*ldoc\encryptO$, cpi, 1)
      cplo$ = Mid(*ldoc\encryptO$, cpi + 1, 1)
      cpbv = Val("$" + cphi$ + cplo$)
      PokeA(*cpOBuf + (cpi - 1) / 2, cpbv)
    Next
    ; 用owner key解密O值得到用户密码填充
    Protected Dim cpUserPad.a(31)
    CopyMemory(*cpOBuf, @cpUserPad(0), 32)
    FreeMemory(*cpOBuf)
    Protected cpRc4.PbPDF_Encrypt
    PbPDF_RC4Init(@cpRc4, @cpOwnerKey(0), *ldoc\encryptKeyLen)
    PbPDF_RC4Crypt(@cpRc4, @cpUserPad(0), @cpUserPad(0), 32)
    ; R>=3时需要19轮RC4解密(从第19轮倒序到第1轮)
    If *ldoc\encryptR >= 3
      Protected cpRoundIter.i
      For cpRoundIter = 19 To 1 Step -1
        Protected Dim cpRoundKey.a(15)
        Protected cpKi.i
        For cpKi = 0 To *ldoc\encryptKeyLen - 1
          cpRoundKey(cpKi) = cpOwnerKey(cpKi) ! cpRoundIter
        Next
        PbPDF_RC4Init(@cpRc4, @cpRoundKey(0), *ldoc\encryptKeyLen)
        PbPDF_RC4Crypt(@cpRc4, @cpUserPad(0), @cpUserPad(0), 32)
      Next
    EndIf
    ; 用解密得到的用户密码填充重新计算加密密钥
    Protected cpID1Len.i = Len(*ldoc\encryptID1$) / 2
    Protected *cpID1Buf = AllocateMemory(cpID1Len + 1)
    For cpi = 1 To Len(*ldoc\encryptID1$) Step 2
      cphi$ = Mid(*ldoc\encryptID1$, cpi, 1)
      cplo$ = Mid(*ldoc\encryptID1$, cpi + 1, 1)
      cpbv = Val("$" + cphi$ + cplo$)
      PokeA(*cpID1Buf + (cpi - 1) / 2, cpbv)
    Next
    Protected *cpKeyBuf = AllocateMemory(32 + 32 + 4 + 16 + 4)
    Protected cpOff.i = 0
    CopyMemory(@cpUserPad(0), *cpKeyBuf + cpOff, 32) : cpOff + 32
    Protected *cpOBuf2 = AllocateMemory(cpOLen + 1)
    For cpi = 1 To Len(*ldoc\encryptO$) Step 2
      cphi$ = Mid(*ldoc\encryptO$, cpi, 1)
      cplo$ = Mid(*ldoc\encryptO$, cpi + 1, 1)
      cpbv = Val("$" + cphi$ + cplo$)
      PokeA(*cpOBuf2 + (cpi - 1) / 2, cpbv)
    Next
    CopyMemory(*cpOBuf2, *cpKeyBuf + cpOff, cpOLen) : cpOff + cpOLen
    FreeMemory(*cpOBuf2)
    PokeL(*cpKeyBuf + cpOff, *ldoc\encryptPermission) : cpOff + 4
    CopyMemory(*cpID1Buf, *cpKeyBuf + cpOff, cpID1Len) : cpOff + cpID1Len
    FreeMemory(*cpID1Buf)
    ; V=4且EncryptMetadata=false时, 追加4字节0xFFFFFFFF
    If *ldoc\encryptV >= 4 And *ldoc\encryptMetadata = #False
      PokeA(*cpKeyBuf + cpOff, $FF) : cpOff + 1
      PokeA(*cpKeyBuf + cpOff, $FF) : cpOff + 1
      PokeA(*cpKeyBuf + cpOff, $FF) : cpOff + 1
      PokeA(*cpKeyBuf + cpOff, $FF) : cpOff + 1
    EndIf
    Protected Dim cpEncMd5.a(15)
    PbPDF_MD5(*cpKeyBuf, cpOff, @cpEncMd5(0))
    FreeMemory(*cpKeyBuf)
    ; R>=3时需要50次MD5迭代
    If *ldoc\encryptR >= 3
      Protected cpEncIter.i
      For cpEncIter = 1 To 50
        Protected *cpIterBuf = AllocateMemory(16)
        CopyMemory(@cpEncMd5(0), *cpIterBuf, 16)
        PbPDF_MD5(*cpIterBuf, *ldoc\encryptKeyLen, @cpEncMd5(0))
        FreeMemory(*cpIterBuf)
      Next
    EndIf
    ; 更新加密密钥
    *ldoc\encryptKey$ = ""
    For cpi = 0 To *ldoc\encryptKeyLen - 1
      *ldoc\encryptKey$ + RSet(Hex(cpEncMd5(cpi)), 2, "0")
    Next
  EndIf
  ; 创建新PDF文档
  *doc = PbPDF_Create()
  If Not *doc
    PbPDF_FreeLoadedDoc(*ldoc)
    ProcedureReturn 0
  EndIf
  PbPDF_SetPDFVersion(*doc, #PbPDF_PDF_VER_14)
  ; 设置新密码
  PbPDF_SetPassword(*doc, newUserPwd$, newOwnerPwd$, permission, encryptionMode)
  ; 复制文档信息
  Protected infoTitle$ = PbPDF_LoadGetInfoAttr(*ldoc, "Title")
  Protected infoAuthor$ = PbPDF_LoadGetInfoAttr(*ldoc, "Author")
  If infoTitle$ <> ""
    PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_TITLE, infoTitle$)
  EndIf
  If infoAuthor$ <> ""
    PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_AUTHOR, infoAuthor$)
  EndIf
  PbPDF_SetInfoAttr(*doc, #PbPDF_INFO_PRODUCER, "PbPDFlib - Re-encrypted")
  ; 逐页复制内容
  For i = 0 To *ldoc\pageCount - 1
    PbPDF_LoadGetPageSize(*ldoc, i, @pageWidth, @pageHeight)
    *newPage = PbPDF_AddPage(*doc)
    If *newPage
      PbPDF_Page_SetSize(*newPage, pageWidth, pageHeight)
      contentData$ = PbPDF_LoadGetPageContent(*ldoc, i)
      If contentData$ <> ""
        PbPDF_PageGetContentStream(*newPage)
        Protected *pAttr.PbPDF_PageAttr = *newPage\attr
        If *pAttr And *pAttr\contentStream
          Protected *contentBuf = AllocateMemory(Len(contentData$) + 1)
          If *contentBuf
            Protected ci.i
            For ci = 1 To Len(contentData$)
              PokeA(*contentBuf + ci - 1, Asc(Mid(contentData$, ci, 1)))
            Next
            PbPDF_StreamWriteData(*pAttr\contentStream, *contentBuf, Len(contentData$))
            FreeMemory(*contentBuf)
          EndIf
        EndIf
      EndIf
      resultCount + 1
    EndIf
  Next
  ; 保存加密的PDF
  If resultCount > 0
    If PbPDF_SaveToFile2(*doc, outputFileName$) <> #PbPDF_OK
      PbPDF_Free(*doc)
      PbPDF_FreeLoadedDoc(*ldoc)
      ProcedureReturn 0
    EndIf
  EndIf
  PbPDF_Free(*doc)
  PbPDF_FreeLoadedDoc(*ldoc)
  ProcedureReturn 1
EndProcedure

;=============================================================================
; 第33部分：书签修改和删除
; 修改书签属性、删除指定书签
;=============================================================================

;--- 修改书签标题 ---
; 修改指定书签的标题文本
Procedure PbPDF_ModifyOutlineTitle(*outline.PbPDF_Outline, newTitle$)
  If Not *outline
    ProcedureReturn
  EndIf
  ; 更新标题
  *outline\title = newTitle$
  ; 更新字典对象中的Title条目
  If *outline\dictObj
    PbPDF_DictRemove(*outline\dictObj, "Title")
    PbPDF_DictAdd(*outline\dictObj, "Title", PbPDF_StringNew(newTitle$))
  EndIf
EndProcedure

;--- 修改书签目标（跳转页面） ---
; 修改书签的跳转目标为新的Destination对象
Procedure PbPDF_ModifyOutlineDest(*outline.PbPDF_Outline, *newDest)
  Protected *destDict.PbPDF_Object
  Protected *arrObj.PbPDF_Object
  If Not *outline Or Not *newDest
    ProcedureReturn
  EndIf
  ; 更新目标引用
  *outline\dest = *newDest
  ; 更新字典对象中的Dest条目
  If *outline\dictObj
    PbPDF_DictRemove(*outline\dictObj, "Dest")
    ; Dest是一个数组 [pageRef /FitType ...]
    *destDict = *newDest
    If *destDict
      PbPDF_DictAdd(*outline\dictObj, "Dest", *destDict)
    EndIf
  EndIf
EndProcedure

;--- 修改书签展开状态 ---
; 设置书签是否展开显示子项
Procedure PbPDF_ModifyOutlineOpened(*outline.PbPDF_Outline, opened.i)
  If Not *outline
    ProcedureReturn
  EndIf
  *outline\opened = opened
  ; 更新字典中的Count值（正数=展开，负数=折叠）
  If *outline\dictObj
    PbPDF_DictRemove(*outline\dictObj, "Count")
    If *outline\count > 0
      If opened
        PbPDF_DictAddNumber(*outline\dictObj, "Count", *outline\count)
      Else
        PbPDF_DictAddNumber(*outline\dictObj, "Count", -*outline\count)
      EndIf
    EndIf
  EndIf
EndProcedure

;--- 修改书签文本颜色 ---
; 设置书签标题的显示颜色（RGB）
Procedure PbPDF_ModifyOutlineColor(*outline.PbPDF_Outline, r.f, g.f, b.f)
  Protected *colorArr.PbPDF_Object
  If Not *outline
    ProcedureReturn
  EndIf
  If *outline\dictObj
    PbPDF_DictRemove(*outline\dictObj, "C")
    *colorArr = PbPDF_ArrayNew()
    PbPDF_ArrayAddReal(*colorArr, r)
    PbPDF_ArrayAddReal(*colorArr, g)
    PbPDF_ArrayAddReal(*colorArr, b)
    PbPDF_DictAdd(*outline\dictObj, "C", *colorArr)
  EndIf
EndProcedure

;--- 修改书签文本样式 ---
; styleFlags: 0=正常, 1=斜体, 2=粗体, 3=粗斜体
Procedure PbPDF_ModifyOutlineStyle(*outline.PbPDF_Outline, styleFlags.i)
  If Not *outline
    ProcedureReturn
  EndIf
  If *outline\dictObj
    PbPDF_DictRemove(*outline\dictObj, "F")
    If styleFlags > 0
      PbPDF_DictAddNumber(*outline\dictObj, "F", styleFlags)
    EndIf
  EndIf
EndProcedure

;--- 内部函数：从父节点的子链中移除指定书签 ---
Procedure PbPDF_UnlinkOutline(*outline.PbPDF_Outline)
  Protected *parent.PbPDF_Outline
  Protected *child.PbPDF_Outline
  Protected *prevSibling.PbPDF_Outline
  If Not *outline
    ProcedureReturn
  EndIf
  *parent = *outline\parent
  If Not *parent
    ; 没有父节点，无法从链中移除
    ProcedureReturn
  EndIf
  ; 从父节点的子链中移除
  If *parent\first = *outline
    ; 要移除的是第一个子节点
    *parent\first = *outline\next
    If *parent\first = 0
      ; 没有其他子节点了
      *parent\last = 0
    EndIf
  ElseIf *parent\last = *outline
    ; 要移除的是最后一个子节点
    *parent\last = *outline\prev
  EndIf
  ; 更新前后兄弟的链接
  If *outline\prev
    *outline\prev\next = *outline\next
  EndIf
  If *outline\next
    *outline\next\prev = *outline\prev
  EndIf
  ; 更新父节点的子项计数
  If *parent\count > 0
    *parent\count - 1
  EndIf
  ; 清除自身的前后链接
  *outline\prev = 0
  *outline\next = 0
  *outline\parent = 0
EndProcedure

;--- 内部函数：递归释放书签及其所有子节点 ---
Procedure PbPDF_FreeOutlineTree(*outline.PbPDF_Outline)
  Protected *child.PbPDF_Outline
  Protected *nextChild.PbPDF_Outline
  If Not *outline
    ProcedureReturn
  EndIf
  ; 先递归释放所有子节点
  *child = *outline\first
  While *child
    *nextChild = *child\next
    PbPDF_FreeOutlineTree(*child)
    *child = *nextChild
  Wend
  ; 注意：不释放dictObj，因为它属于PDF对象树，由PbPDF_ObjFree统一释放
  ; 只释放Outline结构本身
  FreeMemory(*outline)
EndProcedure

;--- 删除指定书签（及其所有子书签） ---
; *doc: PDF文档对象
; *outline: 要删除的书签对象
Procedure PbPDF_DeleteOutline(*doc.PbPDF_Doc, *outline.PbPDF_Outline)
  Protected *parent.PbPDF_Outline
  If Not *doc Or Not *outline
    ProcedureReturn
  EndIf
  ; 从父节点的子链中移除
  PbPDF_UnlinkOutline(*outline)
  ; 递归释放书签树（包括所有子节点）
  PbPDF_FreeOutlineTree(*outline)
EndProcedure

;--- 获取书签的第一个子书签 ---
Procedure.i PbPDF_GetOutlineFirst(*outline.PbPDF_Outline)
  If Not *outline
    ProcedureReturn 0
  EndIf
  ProcedureReturn *outline\first
EndProcedure

;--- 获取书签的下一个兄弟书签 ---
Procedure.i PbPDF_GetOutlineNext(*outline.PbPDF_Outline)
  If Not *outline
    ProcedureReturn 0
  EndIf
  ProcedureReturn *outline\next
EndProcedure

;--- 获取书签的标题 ---
Procedure.s PbPDF_GetOutlineTitle(*outline.PbPDF_Outline)
  If Not *outline
    ProcedureReturn ""
  EndIf
  ProcedureReturn *outline\title
EndProcedure

;--- 获取文档的第一个顶级书签 ---
Procedure.i PbPDF_GetFirstOutline(*doc.PbPDF_Doc)
  If Not *doc Or Not *doc\outlinesRoot
    ProcedureReturn 0
  EndIf
  ProcedureReturn *doc\outlinesRoot\first
EndProcedure

; IDE Options = PureBasic 6.40 (Windows - x86)
; CursorPosition = 10177
; FirstLine = 10157
; Folding = -----------------------------------------
; Markers = 591,1026,2203,2382,2482,3328,3837,3907
; EnableThread
; EnableXP
; DPIAware
; CompileSourceDirectory