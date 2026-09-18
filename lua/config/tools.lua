-- ─────────────────────────────────────────────────────────────────────────────
-- Feature 2: Paste JSON as typed class / interface via quicktype
-- <leader>xj  →  prompts: (c)sharp or (t)ypescript, then generates from clipboard
-- Requires: npm install -g quicktype (node v20+)
-- ─────────────────────────────────────────────────────────────────────────────

local node_bin      = vim.fn.expand('$HOME') .. '/.nvm/versions/node/v24.16.0/bin/node'
local quicktype_bin = vim.fn.expand('$HOME') .. '/.nvm/versions/node/v24.16.0/bin/quicktype'

local function paste_json_as_code()
	local clipboard = vim.fn.getreg('+')
	if clipboard == '' then clipboard = vim.fn.getreg('"') end

	-- basic validation
	local ok, _ = pcall(vim.json.decode, clipboard)
	if not ok then
		vim.notify('Clipboard does not contain valid JSON', vim.log.levels.ERROR)
		return
	end

	local lang = vim.fn.input('Generate for: (c)sharp / (t)ypescript: ')
	if lang == '' then return end

	local root_name = vim.fn.input('Root class/interface name: ')
	if root_name == '' then root_name = 'Root' end

	local qt_lang, ft
	if lang:lower():sub(1,1) == 'c' then
		qt_lang = 'csharp'
		ft      = 'cs'
	elseif lang:lower():sub(1,1) == 't' then
		qt_lang = 'typescript'
		ft      = 'typescript'
	else
		vim.notify('Unknown target: choose c or t', vim.log.levels.WARN)
		return
	end

	-- write clipboard JSON to a temp file
	local tmpfile = os.tmpname() .. '.json'
	local f = io.open(tmpfile, 'w')
	f:write(clipboard)
	f:close()

	local cmd = node_bin .. ' ' .. quicktype_bin
		.. ' --lang ' .. qt_lang
		.. ' --src-lang json'
		.. ' -t ' .. vim.fn.shellescape(root_name)
		.. ' ' .. tmpfile

	local output = vim.fn.system(cmd)
	os.remove(tmpfile)

	if vim.v.shell_error ~= 0 then
		vim.notify('quicktype error: ' .. output, vim.log.levels.ERROR)
		return
	end

	local lines = vim.split(output, '\n', { plain = true })

	vim.cmd('vnew')
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype  = ft
	vim.bo[buf].buftype   = 'nofile'
	vim.bo[buf].buflisted = false
	vim.b[buf].lsp_disable = true
	for _, client in ipairs(vim.lsp.get_clients({ buf = buf })) do
		vim.lsp.buf_detach_client(buf, client.id)
	end
end

vim.keymap.set('n', '<leader>xj', paste_json_as_code,
	{ silent = true, desc = 'Paste JSON as C# class or TS interface (quicktype)' })
