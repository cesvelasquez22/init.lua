-- Aylin Selene palette overrides applied on top of the ayu colorscheme.
-- Runs automatically every time `:colorscheme ayu` is invoked (including at
-- startup via lua/config/aylin_selene.lua), but only when the mirage variant
-- is active so other ayu variants (plain dark / light) are unaffected.
--
-- Sources:
--   * Aylin Selene theme (Zed port): bIaqat/aylin-theme-zed
--   * Aylin for Vim:                 AhmedAbdulrahman/aylin.vim

if vim.g.ayucolor ~= "mirage" then
	return
end

local C = {
	bg          = "#1f2430", -- editor background
	bg_float    = "#171B25", -- elevated surface / status bar / tab bar
	bg_hover    = "#1B202B", -- panel background / hover
	bg_cursor   = "#242f3f", -- active line
	border      = "#363C4A",
	fg          = "#ebefff", -- text
	fg_muted    = "#c8c8db", -- text.muted / types
	placeholder = "#74778c",
	disabled    = "#606375",

	comment     = "#6f738a", -- italic comments
	blue        = "#6cbeff", -- keywords
	gold        = "#ECC48D", -- strings / constants
	teal        = "#7FDBCA", -- functions / enums / lifetimes
	pink        = "#FD98B9", -- numbers / operators / booleans / tags / builtins
	purple      = "#c792ea", -- parameters
	green       = "#addb67", -- created / success
	red         = "#EB8378", -- errors / deleted
	yellow      = "#ECC48D", -- warnings / modified

	punct       = "#e0e2eb", -- punctuation / brackets
	line_nr     = "#303F54",

	-- blended (semi-transparent values from the theme composited on bg)
	selection   = "#283344", -- #303F5490 over #1f2430
	search      = "#655E4B", -- #ffdf8850 over #1f2430
}

local hl = function(group, val)
	vim.api.nvim_set_hl(0, group, val)
end

-- Editor / UI ---------------------------------------------------------
hl("Normal",               { fg = C.fg,   bg = C.bg })
hl("NormalFloat",          { fg = C.fg,   bg = C.bg_float })
hl("NormalNC",             { fg = C.fg,   bg = C.bg })
hl("EndOfBuffer",          { fg = C.blue })
hl("ColorColumn",          { bg = C.bg_hover })
hl("CursorLine",           { bg = C.bg_hover })
hl("CursorColumn",         { bg = C.bg_hover })
hl("CursorLineNr",         { fg = C.pink })
hl("LineNr",               { fg = C.line_nr })
hl("SignColumn",           { bg = C.bg })
hl("Folded",               { fg = C.disabled, bg = C.bg_float })
hl("FoldColumn",           { fg = C.disabled, bg = C.bg })
hl("VertSplit",            { fg = C.border, bg = C.bg })
hl("WinSeparator",         { fg = C.border, bg = C.bg })
hl("StatusLine",           { fg = C.fg,   bg = C.bg_float })
hl("StatusLineNC",         { fg = C.disabled, bg = C.bg_float })
hl("TabLine",              { fg = C.fg_muted, bg = C.bg_float })
hl("TabLineFill",          { fg = C.fg_muted, bg = C.bg_float })
hl("TabLineSel",           { fg = C.fg,   bg = C.bg })
hl("WinBar",               { fg = C.fg,   bg = C.bg_float })
hl("WinBarNC",             { fg = C.disabled, bg = C.bg_float })
hl("MsgArea",              { fg = C.fg,   bg = C.bg })
hl("Title",                { fg = C.blue, bold = true })
hl("Directory",            { fg = C.teal })
hl("Search",               { fg = C.fg,   bg = C.search })
hl("CurSearch",            { fg = C.bg,   bg = C.pink })
hl("IncSearch",            { fg = C.bg,   bg = C.pink })
hl("MatchParen",           { fg = C.gold, bg = C.selection, bold = true })
hl("Visual",               { bg = C.selection })
hl("VisualNOS",            { bg = C.selection })
hl("NonText",              { fg = C.disabled })
hl("Whitespace",           { fg = C.disabled })
hl("SpecialKey",           { fg = C.disabled })
hl("Conceal",              { fg = C.disabled })
hl("Pmenu",                { fg = C.fg,   bg = C.bg_float })
hl("PmenuSel",             { fg = C.fg,   bg = C.selection })
hl("PmenuSbar",            { bg = C.bg_hover })
hl("PmenuThumb",           { bg = C.border })
hl("FloatBorder",          { fg = C.border, bg = C.bg_float })
hl("FloatTitle",           { fg = C.blue, bg = C.bg_float })
hl("Cursor",               { bg = C.fg_muted })
hl("FindCursor",           { bg = C.gold })
hl("LspReferenceText",     { bg = C.selection })
hl("LspReferenceRead",     { bg = C.selection, underline = true })
hl("LspReferenceWrite",    { bg = C.selection, underline = true })
hl("LspSignatureActiveParameter", { fg = C.gold, bold = true })
hl("LspCodeLens",          { fg = C.placeholder })
hl("LspInlayHint",         { fg = C.placeholder, bg = C.bg_float })
hl("LspInfoBorder",        { fg = C.border, bg = C.bg_float })
hl("LspDiagnosticsBase",   {})
hl("QuickFixLine",         { bg = C.selection })

-- Messages / diagnostics -------------------------------------------------
hl("ErrorMsg",             { fg = C.red })
hl("WarningMsg",           { fg = C.gold })
hl("ModeMsg",              { fg = C.green })
hl("MoreMsg",              { fg = C.green })
hl("Question",             { fg = C.green })
hl("Todo",                 { fg = C.gold, bold = true })
hl("Underlined",           { fg = C.pink, underline = true })
hl("DiagnosticError",      { fg = C.red })
hl("DiagnosticWarn",       { fg = C.gold })
hl("DiagnosticInfo",       { fg = C.blue })
hl("DiagnosticHint",       { fg = C.placeholder })
hl("DiagnosticOk",         { fg = C.green })
hl("DiagnosticVirtualTextError", { fg = C.red })
hl("DiagnosticVirtualTextWarn",  { fg = C.gold })
hl("DiagnosticVirtualTextInfo",  { fg = C.blue })
hl("DiagnosticVirtualTextHint",  { fg = C.placeholder })
hl("DiagnosticUnderlineError",   { undercurl = true, sp = C.red })
hl("DiagnosticUnderlineWarn",    { undercurl = true, sp = C.gold })
hl("DiagnosticUnderlineInfo",    { undercurl = true, sp = C.blue })
hl("DiagnosticUnderlineHint",    { undercurl = true, sp = C.placeholder })
hl("SpellBad",             { undercurl = true, sp = C.red })
hl("SpellCap",             { undercurl = true, sp = C.blue })
hl("SpellLocal",           { undercurl = true, sp = C.gold })
hl("SpellRare",            { undercurl = true, sp = C.purple })

-- Diff ------------------------------------------------------------------
hl("DiffAdd",              { fg = C.green, bg = C.bg })
hl("DiffChange",           { fg = C.blue,  bg = C.bg })
hl("DiffDelete",           { fg = C.red,   bg = C.bg })
hl("DiffText",             { fg = C.pink,  bg = C.bg })
hl("diffAdded",            { fg = C.green })
hl("diffRemoved",          { fg = C.red })
hl("diffChanged",          { fg = C.blue })
hl("diffOldFile",          { fg = C.gold })
hl("diffNewFile",          { fg = C.green })
hl("diffFile",             { fg = C.blue })
hl("diffLine",             { fg = C.purple })

-- Base syntax -------------------------------------------------------------
hl("Comment",              { fg = C.comment, italic = true })
hl("Constant",             { fg = C.gold })
hl("String",               { fg = C.gold })
hl("Character",            { fg = C.teal })
hl("Number",               { fg = C.pink })
hl("Float",                { fg = C.pink })
hl("Boolean",              { fg = C.pink })
hl("Identifier",           { fg = C.fg })
hl("Function",             { fg = C.teal })
hl("Statement",            { fg = C.blue })
hl("Conditional",          { fg = C.blue })
hl("Repeat",               { fg = C.blue })
hl("Label",                { fg = C.blue })
hl("Operator",             { fg = C.pink })
hl("Keyword",              { fg = C.blue })
hl("Exception",            { fg = C.blue })
hl("PreProc",              { fg = C.fg_muted })
hl("Include",              { fg = C.blue })
hl("Define",               { fg = C.blue })
hl("Macro",                { fg = C.gold })
hl("PreCondit",            { fg = C.blue })
hl("Type",                 { fg = C.fg_muted })
hl("StorageClass",         { fg = C.blue })
hl("Structure",            { fg = C.teal })
hl("Typedef",              { fg = C.fg_muted })
hl("Special",              { fg = C.gold })
hl("SpecialChar",          { fg = C.pink })
hl("Tag",                  { fg = C.pink })
hl("Delimiter",            { fg = C.punct })
hl("SpecialComment",       { fg = C.gold, italic = true })
hl("Debug",                { fg = C.gold })
hl("Error",                { fg = C.red, bg = C.bg_hover })
hl("Ignore",               { fg = C.disabled })

-- Treesitter legacy groups -----------------------------------------------
local ts = {
	TSComment             = { fg = C.comment, italic = true },
	TSConstant            = { fg = C.gold },
	TSConstBuiltin        = { fg = C.pink },
	TSConstMacro          = { fg = C.gold },
	TSString              = { fg = C.gold },
	TSStringRegex         = { fg = C.gold },
	TSStringEscape        = { fg = C.pink },
	TSStringSpecial       = { fg = C.gold },
	TSCharacter           = { fg = C.teal },
	TSNumber              = { fg = C.pink },
	TSBoolean             = { fg = C.pink },
	TSFloat               = { fg = C.pink },
	TSField               = { fg = C.fg_muted },
	TSProperty            = { fg = C.fg_muted },
	TSFunction            = { fg = C.teal },
	TSFuncMacro           = { fg = C.gold },
	TSFuncBuiltin         = { fg = C.pink },
	TSMethod              = { fg = C.teal },
	TSParameter           = { fg = C.purple },
	TSParameterReference  = { fg = C.purple },
	TSVariable            = { fg = C.fg },
	TSVariableBuiltin     = { fg = C.pink },
	TSKeyword             = { fg = C.blue },
	TSKeywordFunction     = { fg = C.blue },
	TSKeywordOperator     = { fg = C.pink },
	TSKeywordReturn       = { fg = C.blue },
	TSOperator            = { fg = C.pink },
	TSLabel               = { fg = C.pink },
	TSType                = { fg = C.fg_muted },
	TSTypeBuiltin         = { fg = C.pink },
	TSTypeDefinition      = { fg = C.fg_muted },
	TSTypeQualifier       = { fg = C.purple },
	TSNamespace           = { fg = C.fg_muted },
	TSInclude             = { fg = C.blue },
	TSConstructor         = { fg = C.punct },
	TSAnnotation          = { fg = C.gold },
	TSAttribute           = { fg = C.fg_muted },
	TSTag                 = { fg = C.pink },
	TSTagDelimiter        = { fg = C.punct },
	TSTagAttribute        = { fg = C.fg_muted },
	TSPunctDelimiter      = { fg = C.punct },
	TSPunctBracket        = { fg = C.punct },
	TSPunctSpecial        = { fg = C.pink },
	TSException           = { fg = C.blue },
	TSStructure           = { fg = C.teal },
	TSURI                 = { fg = C.pink, underline = true },
	TSEmphasis            = { fg = C.fg, italic = true },
	TSStrong              = { fg = C.fg, bold = true },
	TSTitle               = { fg = C.blue, bold = true },
	TSLiteral             = { fg = C.gold },
	TSQuote               = { fg = C.fg },
	TSNone                = { fg = C.fg },
	TSDefinition          = { fg = C.fg },
	TSDefinitionUsage     = { fg = C.fg },
	TSMath                = { fg = C.pink },
	TSText                = { fg = C.fg },
	TSEnvironment         = { fg = C.blue },
	TSEnvironmentName     = { fg = C.gold },
	TSError               = { fg = C.red },
	TSNote                = { fg = C.blue },
	TSWarning             = { fg = C.gold },
	TSDanger              = { fg = C.red },
}
for group, val in pairs(ts) do
	hl(group, val)
end

-- New-style captures (@...) -----------------------------------------------
local caps = {
	["@comment"]                 = { fg = C.comment, italic = true },
	["@constant"]                = { fg = C.gold },
	["@constant.builtin"]        = { fg = C.pink },
	["@constant.macro"]          = { fg = C.gold },
	["@string"]                  = { fg = C.gold },
	["@string.regex"]            = { fg = C.gold },
	["@string.escape"]           = { fg = C.pink },
	["@string.special"]          = { fg = C.gold },
	["@string.symbol"]           = { fg = C.gold },
	["@character"]               = { fg = C.teal },
	["@number"]                  = { fg = C.pink },
	["@boolean"]                 = { fg = C.pink },
	["@float"]                   = { fg = C.pink },
	["@function"]                = { fg = C.teal },
	["@function.builtin"]        = { fg = C.pink },
	["@function.call"]           = { fg = C.teal },
	["@function.macro"]          = { fg = C.gold },
	["@method"]                  = { fg = C.teal },
	["@method.call"]             = { fg = C.teal },
	["@constructor"]             = { fg = C.punct },
	["@parameter"]               = { fg = C.purple },
	["@variable"]                = { fg = C.fg },
	["@variable.builtin"]        = { fg = C.pink },
	["@special"]                 = { fg = C.teal },
	["@special.symbol"]          = { fg = C.pink },
	["@special.character"]       = { fg = C.pink },
	["@keyword"]                 = { fg = C.blue },
	["@keyword.function"]        = { fg = C.pink },
	["@keyword.operator"]        = { fg = C.pink },
	["@keyword.return"]          = { fg = C.blue },
	["@keyword.conditional"]     = { fg = C.blue },
	["@keyword.repeat"]          = { fg = C.blue },
	["@keyword.import"]          = { fg = C.blue },
	["@keyword.exception"]       = { fg = C.blue },
	["@operator"]                = { fg = C.pink },
	["@exception"]               = { fg = C.blue },
	["@include"]                 = { fg = C.blue },
	["@label"]                   = { fg = C.pink },
	["@type"]                    = { fg = C.fg_muted },
	["@type.builtin"]            = { fg = C.pink },
	["@type.definition"]         = { fg = C.fg_muted },
	["@type.qualifier"]          = { fg = C.purple },
	["@type.super"]              = { fg = C.teal },
	["@type.interface"]          = { fg = C.fg_muted },
	["@namespace"]               = { fg = C.fg_muted },
	["@field"]                   = { fg = C.fg_muted },
	["@property"]                = { fg = C.fg_muted },
	["@parameter.reference"]     = { fg = C.purple },
	["@punctuation.delimiter"]   = { fg = C.punct },
	["@punctuation.bracket"]     = { fg = C.punct },
	["@punctuation.special"]     = { fg = C.pink },
	["@tag"]                     = { fg = C.pink },
	["@tag.delimiter"]           = { fg = C.punct },
	["@tag.attribute"]           = { fg = C.fg_muted },
	["@attribute"]               = { fg = C.fg_muted },
	["@annotation"]              = { fg = C.gold },
	["@enum"]                    = { fg = C.teal },
	["@enumMember"]              = { fg = C.purple },
	["@lifetime"]                = { fg = C.teal },
	["@variable.member"]         = { fg = C.fg },
	["@variable.special"]        = { fg = C.teal },
	["@uri"]                     = { fg = C.pink, underline = true },
	["@text.literal"]            = { fg = C.gold },
	["@text.reference"]          = { fg = C.teal },
	["@text.title"]              = { fg = C.blue, bold = true },
	["@text.emphasis"]           = { fg = C.fg, italic = true },
	["@text.strong"]             = { fg = C.fg, bold = true },
	["@text.underline"]          = { fg = C.fg, underline = true },
	["@text.diff.add"]           = { fg = C.green },
	["@text.diff.delete"]        = { fg = C.red },
	["@error"]                   = { fg = C.red },
	["@note"]                    = { fg = C.blue },
	["@warning"]                 = { fg = C.gold },
	["@danger"]                  = { fg = C.red },
	["@diff.added"]              = { fg = C.green },
	["@diff.removed"]            = { fg = C.red },
	["@diff.changed"]            = { fg = C.blue },
	-- LSP semantic tokens
	["@lsp.type.namespace"]      = { fg = C.fg_muted },
	["@lsp.type.class"]          = { fg = C.fg_muted },
	["@lsp.type.interface"]      = { fg = C.fg_muted },
	["@lsp.type.struct"]         = { fg = C.fg_muted },
	["@lsp.type.enum"]           = { fg = C.teal },
	["@lsp.type.typeParameter"]  = { fg = C.purple },
	["@lsp.type.parameter"]      = { fg = C.purple },
	["@lsp.type.variable"]       = { fg = C.fg },
	["@lsp.type.property"]       = { fg = C.fg_muted },
	["@lsp.type.enumMember"]     = { fg = C.gold },
	["@lsp.type.function"]       = { fg = C.teal },
	["@lsp.type.method"]         = { fg = C.teal },
	["@lsp.type.macro"]          = { fg = C.gold },
	["@lsp.type.keyword"]        = { fg = C.blue },
	["@lsp.type.string"]         = { fg = C.gold },
	["@lsp.type.number"]         = { fg = C.pink },
	["@lsp.type.operator"]       = { fg = C.pink },
	["@lsp.type.comment"]        = { fg = C.comment, italic = true },
	["@lsp.type.decorator"]      = { fg = C.purple },
	["@lsp.type.type"]           = { fg = C.fg_muted },
	["@lsp.typemod.function.defaultLibrary"]  = { fg = C.pink },
	["@lsp.typemod.method.defaultLibrary"]    = { fg = C.pink },
	["@lsp.typemod.variable.readonly"]        = { fg = C.gold },
	["@lsp.typemod.variable.defaultLibrary"]  = { fg = C.pink },
	["@lsp.typemod.type.defaultLibrary"]      = { fg = C.pink },
	["@lsp.typemod.property.readonly"]        = { fg = C.gold },
}
for group, val in pairs(caps) do
	hl(group, val)
end

-- Plugins ----------------------------------------------------------------
hl("GitSignsAdd",          { fg = C.green })
hl("GitSignsAddNr",        { fg = C.green })
hl("GitSignsAddLn",        { fg = C.green })
hl("GitSignsChange",       { fg = C.gold })
hl("GitSignsChangeNr",     { fg = C.gold })
hl("GitSignsChangeLn",     { fg = C.gold })
hl("GitSignsDelete",       { fg = C.red })
hl("GitSignsDeleteNr",     { fg = C.red })
hl("GitSignsDeleteLn",     { fg = C.red })
hl("GitSignsUntracked",    { fg = C.teal })
hl("GitGutterAdd",         { fg = C.green })
hl("GitGutterChange",      { fg = C.gold })
hl("GitGutterDelete",      { fg = C.red })
hl("SignifySignAdd",       { fg = C.green })
hl("SignifySignChange",    { fg = C.gold })
hl("SignifySignDelete",    { fg = C.red })

-- nvim-cmp completion kind colors
local kinds = {
	default = C.fg_muted,
	keyword = C.blue,
	property = C.fg_muted,
	reference = C.teal,
	["function"] = C.teal,
	method = C.teal,
	constant = C.gold,
	constructor = C.punct,
	enumerator = C.teal,
	enummember = C.purple,
	class = C.fg_muted,
	struct = C.fg_muted,
	interface = C.fg_muted,
	text = C.fg,
	value = C.gold,
	snippet = C.purple,
	unit = C.gold,
	field = C.fg_muted,
	Variable = C.fg,
	type = C.fg_muted,
	module = C.fg_muted,
	variable = C.fg,
	operator = C.pink,
	event = C.gold,
	file = C.blue,
	folder = C.blue,
	namespace = C.fg_muted,
	package = C.blue,
	import = C.blue,
	boolean = C.pink,
	number = C.pink,
	["enum"] = C.teal,
	["array"] = C.fg_muted,
	["object"] = C.fg_muted,
	["key"] = C.gold,
	["link"] = C.pink,
	["color"] = C.pink,
	["tab"] = C.blue,
	["receiver"] = C.purple,
	["dynamic"] = C.fg_muted,
	["symbol"] = C.gold,
}
for kind, color in pairs(kinds) do
	hl("CmpItemKind" .. kind, { fg = color })
end

-- Telescope
hl("TelescopePromptNormal",    { fg = C.fg, bg = C.bg_float })
hl("TelescopePromptBorder",    { fg = C.border, bg = C.bg_float })
hl("TelescopePromptTitle",     { fg = C.bg, bg = C.blue })
hl("TelescopePromptPrefix",    { fg = C.blue })
hl("TelescopeResultsNormal",   { fg = C.fg, bg = C.bg_float })
hl("TelescopeResultsBorder",   { fg = C.border, bg = C.bg_float })
hl("TelescopeResultsTitle",    { fg = C.bg, bg = C.gold })
hl("TelescopeSelection",       { bg = C.selection })
hl("TelescopeSelectionCaret",  { fg = C.pink })
hl("TelescopePreviewNormal",   { fg = C.fg, bg = C.bg_float })
hl("TelescopePreviewBorder",   { fg = C.border, bg = C.bg_float })
hl("TelescopePreviewTitle",    { fg = C.bg, bg = C.green })
hl("TelescopeMatching",        { fg = C.gold })

-- DAP UI
hl("DapBreakpoint",            { fg = C.red })
hl("DapLogPoint",              { fg = C.gold })
hl("DapStopped",               { fg = C.blue })

-- nvim-dap-ui
hl("DapUIBreakpointsPath",     { fg = C.blue })
hl("DapUIBreakpointsInfo",     { fg = C.green })
hl("DapUIBreakpointsCurrentLine", { fg = C.blue })
hl("DapUIStepOver",            { fg = C.teal })
hl("DapUIStepInto",            { fg = C.teal })
hl("DapUIStepOut",             { fg = C.teal })
hl("DapUIWatchesEmpty",        { fg = C.fg_muted })
hl("DapUIWatchesValue",        { fg = C.gold })
hl("DapUIWatchesError",        { fg = C.red })
hl("DapUIEvaluate",            { fg = C.teal })